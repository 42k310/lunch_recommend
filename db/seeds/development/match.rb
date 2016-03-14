# ぐるなびAPIのレスポンスを受けて、matcesTBLに情報を格納する
require "faraday"
require "json"
require 'Mechanize'
require "open-uri"
require "rubygems"
require "nokogiri"

# ぐるなびAPI
REQUEST_URL = "http://api.gnavi.co.jp"

# ぐるなびAPI利用(準備)
gnavi_ids = %w(g223622 g223601 g853173 6954195 6316220 1022330 e983301 a072800 g264000 a552400 e758502 ge8t100 g361600 a207505 6351857 6964525 a552400 t054100 p963302 a466102)

gnavi_ids.each do |gnavi_id|
  p "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  p "#{gnavi_id}の情報ここから"

  res = Faraday.new(:url => REQUEST_URL).get("/RestSearchAPI/20150630/?keyid=6cc53ab1245c8613381303a032c68791&format=json&id=#{gnavi_id}")
  @gnavi_info = JSON.parse(res.body)
  @rest_info = @gnavi_info["rest"]

  # 予算
  p "#{gnavi_id}の予算"
  if @rest_info["lunch"].empty?
    @lunch = nil
  else
    @lunch = @rest_info["lunch"].to_i
    p @lunch
    if @lunch > 1000
      p "#{gnavi_id}は1000円以上です"
      test = Shop.find(:conditions => { :gnavi_id => gnavi_id }).id
      if test.present?
        p test
      else
        p "なし"
      end

    else
      p "#{gnavi_id}は1000円以下です"
    end
  end


  # スクレイピング
  agent1 = Mechanize.new
  page1 = agent1.get("http://r.gnavi.co.jp/#{gnavi_id}")
  elements_private_room = page1.search('#info-table-seat table ul li').inner_text
  elements_smoking = page1.search('#info-table-seat table ul li').inner_text

  # 個室情報
  p "■#{gnavi_id}の個室"
  if elements_private_room.include?("個室")
    @private_room = "個室あり"
    p @private_room
  else
    @private_room= "情報なし"
    p @private_room
  end


  # 喫煙情報
  p "■#{gnavi_id}の喫煙"
    if elements_smoking.include?("喫煙可")
      @smoking = "喫煙可"
      p @smoking
    else
      @smoking = "情報なし"
      p @smoking
    end
end