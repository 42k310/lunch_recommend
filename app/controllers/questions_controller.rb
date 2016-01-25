class QuestionsController < ApplicationController

  def index
    @questions = Question.order("RANDOM()").limit(3)
    p @questions
  end

  def answer
    answer1 = params[:answer1]
    answer2 = params[:answer2]
    answer3 = params[:answer3]
    user_id = session[:user_id] # セッションに持っているuser_idをuser_idに入れる 現在はまだログインのやつ作っていないので持っていない

    answer_type1 = answer1["answer_type"]
    q_id1 = answer1["question_id"]
    answer_type2 = answer2["answer_type"]
    q_id2 = answer2["question_id"]
    answer_type3 = answer3["answer_type"]
    q_id3 = answer3["question_id"]

    AnswerHistoriy.create(answer_type: answer_type1, question_id: q_id1)
    AnswerHistoriy.create(answer_type: answer_type2, question_id: q_id2)
    AnswerHistoriy.create(answer_type: answer_type3, question_id: q_id3)

    # レコメンド
    matches1 = Match.where("shop_question#{q_id1} = ?", "#{answer_type1}").order("RANDOM()")
    matches2 = matches1.where("shop_question#{q_id2} = ?", "#{answer_type2}").order("RANDOM()")
    matches3 = matches2.where("shop_question#{q_id3} = ?", "#{answer_type3}").order("RANDOM()")
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


    @gnavi_id = Shop.find(match.id).gnavi_id # できたらアソシエーション使って書きたい

    # ぐるなびAPI利用(準備)
    request_url = "http://api.gnavi.co.jp"
    id = @gnavi_id
    res = Faraday.new(:url => request_url).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{id}")

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

    # 行きたいを表示
    action_kinds1 = Action.where("action_kind = 1")
    @wanted_rest_infos = []
    action_kinds1.each do |action_kind1|
      wanted_shop_id = action_kind1.shop_id
      wanted_gnavi_id = Shop.find(wanted_shop_id).gnavi_id
      wanted_res = Faraday.new(:url => request_url).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{wanted_gnavi_id}")

      wanted_gnavi_info = JSON.parse(wanted_res.body)
      @wanted_rest_infos << wanted_gnavi_info["rest"]
    end

    # 行ったを表示
    action_kinds2 = Action.where("action_kind = 2")
    @gone_rest_infos = []
    action_kinds2.each do |action_kind2|
      gone_shop_id = action_kind2.shop_id
      gone_gnavi_id = Shop.find(gone_shop_id).gnavi_id
      gone_res = Faraday.new(:url => request_url).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{gone_gnavi_id}")

      gone_gnavi_info = JSON.parse(gone_res.body)
      @gone_rest_infos << gone_gnavi_info["rest"]
    end
  end

  def next
    render :action => "answer"
  end

  def want_to_go
    Action.create(action_kind: 1, shop_id: 2, user_id: 2) # Shop.find(match.id).id
    render :action => "answer"
  end

  def has_gone
    Action.create(action_kind: 2, shop_id: 1, user_id: 1) # Shop.find(match.id).id
    render :action => "answer"
  end

end