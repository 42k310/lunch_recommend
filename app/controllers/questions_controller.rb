class QuestionsController < ApplicationController

  # TODO: お気に入り店舗の登録（want程度の優先度）
  # 要ログイン
  before_filter :login_required

  # 行きたい、行った
  ACTION_KIND_WANT_TO_GO = 1
  ACTION_KIND_HAS_GONE = 2

  # ぐるなびAPI
  REQUEST_URL = "http://api.gnavi.co.jp"

  def index

    # TODO: Questionが取得できない・または3件取得できなかった場合、システムエラー画面に飛ばすこと（※要確認）
    # TODO: システムエラー画面に飛ばせているかの確認方法を相澤さんへ確認
    @questions = Question.order("RANDOM()").limit(3)

    # @questionsの中身が存在し、その数が３つなら通常通り処理、そうでないならシステムエラー画面に飛ばす
    if @questions.present?
      if @questions.count == 3
        render :action => "index"
      else
        error500
      end
    else
      error500
    end

  end


  def answer

    p '---------------------------------'
    p ' QuestionsController - answer'
    p '---------------------------------'

    # 回答情報をパラメータから取得
    answer1 = params[:answer1]
    answer2 = params[:answer2]
    answer3 = params[:answer3]

    answer_type1 = answer1["answer_type"]
    q_id1 = answer1["question_id"]
    answer_type2 = answer2["answer_type"]
    q_id2 = answer2["question_id"]
    answer_type3 = answer3["answer_type"]
    q_id3 = answer3["question_id"]

    # セッションに質問と回答を保存（matchメソッドで使用）
    session[:question1] = q_id1
    session[:answer1] = answer1["answer_type"]
    session[:question2] = q_id2
    session[:answer2] = answer2["answer_type"]
    session[:question3] = q_id3
    session[:answer3] = answer3["answer_type"]

    # 回答なしの場合は質問画面へリダイレクトする
    if session[:answer1].blank? || session[:answer2].blank? || session[:answer3].blank?
      redirect_to :action => "index"
    end

    # セッションから店舗情報を取得
    @shop = nil
    if session[:shop_id].present?
      @shop = Shop.find_by(id: session[:shop_id])
    end

    # ----------------------------------------------
    #  店舗情報が未設定の場合、リコメンド処理を実施
    # ----------------------------------------------

    if @shop.blank?
      # 回答履歴を保存
      AnswerHistory.create(user_id: current_user.id, answer_type: answer_type1, question_id: q_id1, answer_date: DateTime.now)
      AnswerHistory.create(user_id: current_user.id, answer_type: answer_type2, question_id: q_id2, answer_date: DateTime.now)
      AnswerHistory.create(user_id: current_user.id, answer_type: answer_type3, question_id: q_id3, answer_date: DateTime.now)

      # 回答とマッチしているショップを配列として取得
      matches

      # 店舗情報を取得
      @shop = Shop.find_by(id: session[:displayed_shop_ids][0])

      # セッションに店舗IDを格納
      session[:shop_id] = @shop.id
    end

    # アクションとボタン名の準備
    actions = get_actions(@shop.id, current_user.id)
    @action_want = actions[:action_want]
    @action_gone = actions[:action_gone]
    prepare_btn_name(@action_want, @action_gone)

    # 店舗情報を準備
    prepare_shop_info

    # スクレイピング
    scraping

    # 行った・行きたい情報を準備
    prepare_want_to_go
    prepare_has_gone

    p '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
    p 'answerにおけるセッション'
    p session[:shop_id]
    p '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'

  end

  # 「ちがう店舗」をレコメンド
  def next
    p '---------------------------------'
    p ' QuestionsController - next'
    p '---------------------------------'

    # セッションから店舗情報を取得
    @shop = nil

    # 回答とマッチした店舗を配列として取得→0番目の要素をmatchに格納
    matches

    # session[:match]の中身があれば、ぐるなびIDをとってきて店舗情報を描画する（なければ「ない画面」に飛ばす）
    if session[:match].present?
      # スクレイピング
      scraping

      # ボタン名の準備
      prepare_btn_name(@action_want, @action_gone)

      # 店舗情報を取得
      @shop = Shop.find_by(id: session[:match])

      # 店舗のぐるなび情報を取得
      prepare_shop_info()

      # 行った・行きたいを準備
      prepare_has_gone
      prepare_want_to_go

      render :action =>  "answer" and return
    else
      render :action => "nothing" and return
    end
  end

  def want_to_go

    p '---------------------------------'
    p ' QuestionsController - want_to_go'
    p '---------------------------------'

    # 店舗情報を取得
    shop_id = session[:shop_id]
    @shop = Shop.find_by(id: shop_id)

    # --------------------------------
    # 行ったのアクションを登録・削除
    # --------------------------------

    # アクションの準備
    actions = get_actions(shop_id, current_user.id)
    @action_want = actions[:action_want]
    @action_gone = actions[:action_gone]

    if @action_want.blank?
      # 存在しない場合は新規登録
      @action_want = Action.create(action_kind: ACTION_KIND_WANT_TO_GO, shop_id: shop_id.to_i, user_id: current_user.id)
    else
      # 存在した場合は削除
      @action_want.destroy
      @action_want = nil
    end

    # スクレイピング
    scraping

    # ボタン名の準備
    prepare_btn_name(@action_want, @action_gone)

    # 店舗情報を準備
    prepare_shop_info

    # 行った・行きたいを準備
    prepare_has_gone
    prepare_want_to_go

    # render  :action => "ajx/want_to_go"
    render :action =>  "answer"


  end

  def has_gone

    p '---------------------------------'
    p ' QuestionsController - has_gone'
    p '---------------------------------'

    # 店舗情報を取得
    shop_id = session[:shop_id]
    @shop = Shop.find_by(id: shop_id)

    # --------------------------------
    # 行ったのアクションを登録・削除
    # --------------------------------

    # アクションの準備
    actions = get_actions(shop_id, current_user.id)
    @action_want = actions[:action_want]
    @action_gone = actions[:action_gone]

    if @action_gone.blank?
      # 存在しない場合は新規登録
      @action_gone = Action.create(action_kind: ACTION_KIND_HAS_GONE, shop_id: shop_id.to_i, user_id: current_user.id)
    else
      # 存在した場合は削除
      @action_gone.destroy
      @action_gone = nil
    end

    # スクレイピング
    scraping

    # ボタン名の準備
    prepare_btn_name(@action_want, @action_gone)

    # 店舗情報を準備
    prepare_shop_info

    # 行った・行きたいを準備
    prepare_has_gone
    prepare_want_to_go

    # render  :action => "ajx/has_gone"
    render :action =>  "answer"

  end

  # def favorite
  #
  #   p '---------------------------------'
  #   p ' QuestionsController - favorite'
  #   p '---------------------------------'
  #   # スクレイピング
  #   scraping
  #
  #   # ボタン名の準備
  #   prepare_btn_name
  #
  #   # 店舗情報を準備
  #   prepare_shop_info
  #   # 行った・行きたい情報を準備
  #   prepare_want_to_go
  #   prepare_has_gone
  #
  #   # 店舗紹介画面を描画
  #   render :action => "answer"
  #
  # end

    # nothingののち、はじめからやり直す
  def retry
    session[:question1].clear
    session[:answer1].clear
    session[:question2].clear
    session[:answer2].clear
    session[:question3].clear
    session[:answer3].clear
    session[:displayed_shop_ids].clear
    redirect_to :action => "index"
  end

  # ━━━━━━━━━━━━━━━━━━━━━━━━━━
  # ここからprivate
  # ━━━━━━━━━━━━━━━━━━━━━━━━━━
  private

  def prepare_shop_info()

    # ぐるなびAPI利用(準備)
    gnavi_id = @shop.gnavi_id
    res = Faraday.new(:url => REQUEST_URL).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{gnavi_id}")

    @gnavi_info = JSON.parse(res.body)
    @rest_info = @gnavi_info["rest"]

    # ぐるなびAPI利用
    @name = @rest_info["name"]
    @shop_url = @rest_info["url"]
    @shop_image = @rest_info["image_url"]["shop_image1"]
    @tel = @rest_info["tel"]
    @category = @rest_info["category"]
    @lunch = @rest_info["lunch"]
    @address = @rest_info["address"]
    @tel = @rest_info["tel"]
    voucher_types = Match.where(shop_id: session[:shop_id]).where(question_id: 8)[0]
    p "voucher_types"
    p voucher_types
    voucher_type = voucher_types["answer_type"]
    p "voucher_type"
    p voucher_type
    if voucher_type == 1
      @voucher = "○"
      elsif voucher_type == 2
        @voucher = "×"

    # 店舗のコメントを取得
      @comment = Shop.where(shop_id: session[:shop_id])[0]["comment"]
    end

    @latitude = @rest_info["latitude"].to_f - @rest_info["latitude"].to_f * 0.00010695 + @rest_info["longitude"].to_f * 0.000017464 + 0.0046017
    @longitude = @rest_info["longitude"].to_f - @rest_info["latitude"].to_f * 0.000046038 - @rest_info["longitude"].to_f * 0.000083043 + 0.010040

    # 個室情報・喫煙情報を取得
    api_extention

  end

  # 行きたいを表示
  def prepare_want_to_go

    action_kinds1 = Action.where(action_kind: ACTION_KIND_WANT_TO_GO, user_id: current_user.id)
    @wanted_rest_infos = []
    action_kinds1.each do |action_kind1|
      wanted_shop_id = action_kind1.shop_id
      wanted_gnavi_id = Shop.find(wanted_shop_id).gnavi_id
      wanted_res = Faraday.new(:url => REQUEST_URL).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{wanted_gnavi_id}")

      wanted_gnavi_info = JSON.parse(wanted_res.body)
      @wanted_rest_infos << wanted_gnavi_info["rest"]
    end

  end

  # 行ったを表示
  def prepare_has_gone

    action_kinds2 = Action.where(action_kind: ACTION_KIND_HAS_GONE, user_id: current_user.id)
    @gone_rest_infos = []
    action_kinds2.each do |action_kind2|
      gone_shop_id = action_kind2.shop_id
      gone_gnavi_id = Shop.find(gone_shop_id).gnavi_id
      gone_res = Faraday.new(:url => REQUEST_URL).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{gone_gnavi_id}")

      gone_gnavi_info = JSON.parse(gone_res.body)
      @gone_rest_infos << gone_gnavi_info["rest"]
    end

  end

  # アクションの取得
  def get_actions(shop_id, user_id)
    action_want = Action.where(action_kind: ACTION_KIND_WANT_TO_GO, shop_id: shop_id, user_id: user_id).first
    action_gone = Action.where(action_kind: ACTION_KIND_HAS_GONE, shop_id: shop_id, user_id: user_id).first
    # アクションを返却
    {action_want: action_want, action_gone: action_gone}
  end

  # ボタン表示名
  def prepare_btn_name(action_want, action_gone)
    @want_to_go_btn_name = action_want.present? ?  "行きたいを取り消す" : "行きたい"
    @has_gone_btn_name = action_gone.present? ?  "行ったを取り消す" : "行った"
  end

  # 回答とマッチしているショップを配列として取得する
  def matches
    p '---------------------------------'
    p ' QuestionsController - matches'
    p '---------------------------------'

    matches1 = Match.where(question_id: session[:question1], answer_type: session[:answer1]).order("RANDOM()")
    matches2 = Match.where(question_id: session[:question2], answer_type: session[:answer2]).order("RANDOM()")
    matches3 = Match.where(question_id: session[:question3], answer_type: session[:answer3]).order("RANDOM()")
    not_matches = Match.all

    # shop_idのみを抜き出す
    match1_ids = []
    matches1.each do |match1|
      match1_ids << match1.shop_id
    end

    match2_ids = []
    matches2.each do |match2|
      match2_ids << match2.shop_id
    end

    match3_ids = []
    matches3.each do |match3|
      match3_ids << match3.shop_id
    end

    not_match_ids = []
    not_matches.each do |not_match|
      not_match_ids << not_match.shop_id
    end

    # match強度毎にshop_idを保持する
    matches_strength_0 = not_match_ids.uniq
    matches_strength_1 = match1_ids | match2_ids | match3_ids
    matches_strength_2 = (match1_ids & match2_ids) | (match2_ids & match3_ids)
    matches_strength_3 = match1_ids & match2_ids & match3_ids

    # 保持したshop_idから、以前表示したものを除去
    if session[:displayed_shop_ids].present?
      matches_strength_3 = matches_strength_3 - session[:displayed_shop_ids]
      matches_strength_2 = matches_strength_2 - session[:displayed_shop_ids]
      matches_strength_1 = matches_strength_1 - session[:displayed_shop_ids]
      matches_strength_0 = matches_strength_0 - session[:displayed_shop_ids]
    end

    p '---------------------------------'
    p 'デバッグ用（※match強度に応じた配列の中身を表示）'
    p "matches_strength_3 => #{matches_strength_3}"
    p "matches_strength_2 => #{matches_strength_2}"
    p "matches_strength_1 => #{matches_strength_1}"
    p "matches_strength_0 => #{matches_strength_0}"
    p '---------------------------------'

    if matches_strength_3.present?
      session[:match] = matches_strength_3[0]
    elsif matches_strength_2.present?
      session[:match] = matches_strength_2[0]
    elsif matches_strength_1.present?
      session[:match] = matches_strength_1[0]
    elsif matches_strength_0.present?
      session[:match] = matches_strength_0[0]
    else
      # 対象店舗がなくなったら、session[:match]をnilにする
      session[:match] = nil
    end

    # 表示済の店舗IDを保持する
    if session[:displayed_shop_ids].present?
      session[:displayed_shop_ids] << session[:match]
    else
      session[:displayed_shop_ids] = [session[:match]]
    end

    # session[:shop_id]を更新
    session[:shop_id] = session[:match]

  end

  # スクレイピング（from 食べログ）
  def scraping
    tblg_id = Shop.find(session[:shop_id]).tblg_id

    agent = Mechanize.new
    page = agent.get("http://tabelog.com/tokyo/#{tblg_id}dtlphotolst/1/smp2/")
    elements = page.search('.thum-photobox__img a')

    @eles = []
    elements.each do |element|
      @eles << element.get_attribute("href")
    end
  end

  # 個室情報・喫煙情報を取得（スクレイピング）
  def api_extention
    p '---------------------------------'
    p 'api_extention'
    p '---------------------------------'

    agent1 = Mechanize.new
    page1 = agent1.get("http://r.gnavi.co.jp/#{Shop.find(session[:shop_id]).gnavi_id}")
    elements_private_room = page1.search('#nav-main li')
    elements_smoking = page1.search('#info-table-seat table ul li')

    # 個室情報
    elements_private_room.each do |element_private_room|
      private_room = element_private_room.inner_text
      p "-----------------------------"
      p private_room
      p private_room.include?("個室")

      if private_room.include?("個室")
        @private_room = "個室あり"
      elsif private_room.include?("※個室の詳細はお店にお問い合わせください")
        @private_room = "※個室の詳細はお店にお問い合わせください"
      else
        @private_room= "情報はありません"
      end
    end

    # 喫煙情報
    elements_smoking.each do |element_smoking|
      smoking = element_smoking.inner_text
      p "-----------------------------"
      p smoking
      p smoking.include?("喫煙可")

      if smoking.include?("喫煙可")
        @smoking = "喫煙可"
        break
      else
        @smoking = "情報はありません"
      end
    end

  end

  # def error500
  #   render action: "errors/error_500", status: 500
  #   # render file: "#{Rails.root}/public/500.html", layout: false, status: 500
  # end
  #
  # def error404
  #   render action: "errors/error_404", status: 404
  #   # render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  # end

end