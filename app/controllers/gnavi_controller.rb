class GnaviController < ApplicationController
  # ブクログAPIのURL（非公式、ブログパーツの埋め込みコードから拝借）
  BOOKLOG_API_URL = "https://api.booklog.jp"

  def show

    # ブクログのユーザーID
    user_id = "npbook"

    # 取得するカテゴリーのID、0の場合は全て
    category = 0

    ## 読書状況
    # 0 「すべて」
    # 1 「読みたい」
    # 2 「いま読んでる」
    # 3 「読み終わった」
    # 4 「積読」
    status = 0

    # 取得件数
    count = 100

    ## ランク
    # 0 「すべて」
    # 1 「★」
    # 2 「★★」
    # 3 「★★★」
    # 4 「★★★★」
    # 5 「★★★★★」
    rank = 0

    # API-Clientを使ってJSON形式データを取得
    res = Faraday.new(:url => BOOKLOG_API_URL).get("/json/#{user_id}?category=#{category}&status=#{status}&rank=#{rank}&count=#{count}")
    # パースしてハッシュ化
    @booklog_info = JSON.parse(res.body)

    # 棚データと本データを格納してビューで利用
    @tana = @booklog_info["tana"]
    @books = @booklog_info["books"]


    # FIXME: for debug
    @tana.each { |tana_info| p tana_info }
    @books.each { |book| p book }

  end

end
