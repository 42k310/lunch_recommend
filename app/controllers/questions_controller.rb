class QuestionsController < ApplicationController

  # 要ログイン
  before_filter :login_required

  # 行きたい、行った
  ACTION_KIND_WANT_TO_GO = 1
  ACTION_KIND_HAS_GONE = 2

  # ぐるなびAPI
  REQUEST_URL = "http://api.gnavi.co.jp"

  def index

    # TODO: Questionが取得できない・または3件取得できなかった場合、システムエラー画面に飛ばすこと
    @questions = Question.order("RANDOM()").limit(3)

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
    prepare_action
    prepare_btn_name

    # 店舗情報を準備
    prepare_shop_info

    # 行った・行きたい情報を準備
    prepare_want_to_go
    prepare_has_gone

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

    # スクレイピング
    scraping

    # 店舗情報を取得
    @shop = Shop.find_by(id: session[:match])

    # 店舗のぐるなび情報を取得
    prepare_shop_info()
    render :action => "answer"
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
    prepare_action

    if @action_want.blank?
      # 存在しない場合は新規登録
      @action_want = Action.create(action_kind: ACTION_KIND_WANT_TO_GO, shop_id: shop_id.to_i, user_id: current_user.id)
    else
      # 存在した場合は削除
      @action_want.destroy
    end

    # ボタン名の準備
    prepare_btn_name

    # 店舗情報を準備
    prepare_shop_info

    # 行った・行きたい情報を準備
    prepare_want_to_go
    prepare_has_gone

    # 店舗紹介画面を描画
    render :action => "answer"

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
    prepare_action

    if @action_gone.blank?
      # 存在しない場合は新規登録
      @action_gone = Action.create(action_kind: ACTION_KIND_HAS_GONE, shop_id: shop_id.to_i, user_id: current_user.id)
    else
      # 存在した場合は削除
      @action_gone.destroy
    end

    # ボタン名の準備
    prepare_btn_name

    # 店舗情報を準備
    prepare_shop_info
    # 行った・行きたい情報を準備
    prepare_want_to_go
    prepare_has_gone

    # 店舗紹介画面を描画
    render :action => "answer"

  end

  private

  def prepare_shop_info()

    # ぐるなびAPI利用(準備)
    gnavi_id = @shop.gnavi_id
    res = Faraday.new(:url => REQUEST_URL).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{gnavi_id}")

    @gnavi_info = JSON.parse(res.body)
    @rest_info = @gnavi_info["rest"]

    # ぐるなびAPI利用
    @name = @rest_info["name"]
    @shop_image = @rest_info["image_url"]["shop_image1"]
    @tel = @rest_info["tel"]
    @category = @rest_info["category"]
    @lunch = @rest_info["lunch"]
    @station = @rest_info["access"]["station"]
    @walk = @rest_info["access"]["walk"]
    @no_smoking = @rest_info["no_smoking"]
    # @private_room = @rest_info["private_room"]

    @latitude = @rest_info["latitude"].to_f - @rest_info["latitude"].to_f * 0.00010695 + @rest_info["longitude"].to_f * 0.000017464 + 0.0046017
    @longitude = @rest_info["longitude"].to_f - @rest_info["latitude"].to_f * 0.000046038 - @rest_info["longitude"].to_f * 0.000083043 + 0.010040

    # スクレイピング
    scraping

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
  def prepare_action
    @action_want = Action.where(action_kind: ACTION_KIND_WANT_TO_GO, shop_id: @shop.id, user_id: current_user.id).first
    @action_gone = Action.where(action_kind: ACTION_KIND_HAS_GONE, shop_id: @shop.id, user_id: current_user.id).first
  end

  # ボタン表示名
  def prepare_btn_name
    @want_to_go_btn_name = @action_want.present? ?  "行きたいを取り消す" : "行きたい"
    @has_gone_btn_name = @action_gone.present? ?  "行ったを取り消す" : "行った"
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
    matches_strength_0 = not_match_ids
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

    if matches_strength_3.present?
      session[:match] = matches_strength_3[0]
    elsif matches_strength_2.present?
      session[:match] = matches_strength_2[0]
    elsif matches_strength_1.present?
      session[:match] = matches_strength_1[0]
    elsif matches_strength_0.present?
      session[:match] = matches_strength_0[0]
      # TODO: not_matchが空になったらエラー画面？に飛ばす
    # else
    #   redirect_to :action => "error"
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

  # # TODO: 個室、喫煙はAPIのリクエストにないため、メソッドをつくる（途中）
  # agent1 = Mechanize.new
  # page1 = agent1.get("http://r.gnavi.co.jp/#{session[:shop_id]}")
  # elements1 = page1.search('#nav-main li')
  #
  # elements1.each do |element|
  #   pri = element.inner_text
  #   if pri.include?("個室")
  #     @private_room = "個室あり"
  #     p "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  #     p @private_room
  #   end
  # end

end