class ShopsController < ApplicationController

  # 要ログイン
  before_filter :login_required

  def answers

    # レコメンド
    @match1 = Match.where("shop_question1 = ?", 1).order("RANDOM()")
    @match2 = Match.where("shop_question1 = ? and shop_question2 = ?", 1, 2).order("RANDOM()")
    # @match3 = @match2.where("shop_question3 = ?", 1)).order("RANDOM()")
    # @not_match = Match.all

    p "$$$$$$$$$"
    p @match1
    p @match2

    p @match3

    gnavi_id = Shop.find(1).gnavi_id # matchesTBLから同じq_idに対して同じa_typeを持っているshop_idを持ってくる

    # ぐるなびAPI利用(準備)
    request_url = "http://api.gnavi.co.jp"
    id = gnavi_id
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

  end

  def next
  end

  def has_gone
  end

  def want_to_go
  end
end