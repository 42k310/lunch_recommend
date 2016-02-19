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

    # セッションから店舗情報を取得
    @shop = nil
    if session[:shop_id].present?
      @shop = Shop.find_by(id: session[:shop_id])
    end

    # ----------------------------------------------
    #  店舗情報が未設定の場合、リコメンド処理を実施
    # ----------------------------------------------

    if @shop.blank?

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

      # 回答履歴を保存
      AnswerHistory.create(user_id: current_user.id, answer_type: answer_type1, question_id: q_id1, answer_date: DateTime.now)
      AnswerHistory.create(user_id: current_user.id, answer_type: answer_type2, question_id: q_id2, answer_date: DateTime.now)
      AnswerHistory.create(user_id: current_user.id, answer_type: answer_type3, question_id: q_id3, answer_date: DateTime.now)

      # レコメンド
      matches1 = Match.where(question_id: q_id1, answer_type: answer_type1).order("RANDOM()")
      matches2 = matches1.where(question_id: q_id2, answer_type: answer_type2).order("RANDOM()")
      matches3 = matches2.where(question_id: q_id3, answer_type: answer_type3).order("RANDOM()")

      not_match = Match.all

      if matches3.present?
        match = matches3[0]
      elsif matches2.present?
        match = matches2[0]
      elsif matches1.present?
        match = matches1[0]
      else
        match = not_match[0]
      end

      # 店舗情報を取得
      @shop = Shop.find_by(id: match.shop.id)

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

    # 行った・行きたい情報を準備
    prepare_want_to_go
    prepare_has_gone

  end

  def next
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

    # ボタン名の準備
    prepare_btn_name(@action_want, @action_gone)

    render  :action => "ajx/want_to_go"

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

    # ボタン名の準備
    prepare_btn_name(@action_want, @action_gone)

    render  :action => "ajx/has_gone"

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

    @latitude = @rest_info["latitude"].to_f - @rest_info["latitude"].to_f * 0.00010695 + @rest_info["longitude"].to_f * 0.000017464 + 0.0046017
    @longitude = @rest_info["longitude"].to_f - @rest_info["latitude"].to_f * 0.000046038 - @rest_info["longitude"].to_f * 0.000083043 + 0.010040

    # スクレイピング
    agent = Mechanize.new
    page = agent.get("http://tabelog.com/tokyo/A1301/A130101/13138373/")
    elements = page.search('.rstdtl-top-photo__photo a')

    @eles = []
    elements.each do |element|
      @eles << element.get_attribute("href")
    end

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

end