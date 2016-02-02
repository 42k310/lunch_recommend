# シード投入用ファイル
target_file_names = %w( matches questions )
# development, production それぞれで対象のシード用ファイルを準備、環境に合わせて実行
target_file_names.each do |target_file|
  path = Rails.root.join("db/seeds/", Rails.env, target_file + ".rb")
  p path
  File.exist?(path)
  if File.exist?(path)
    puts "Loading #{Rails.env}:#{target_file}..."
    require path
  end
end

# csvファイルでのデータ投入（matches）
require "csv"

CSV.foreach('db/seeds/development/matches.csv') do |row|
  Match.create(:id => row[0],
               :shop_id => row[1],
               :question_id => row[2],
               :answer_type => row[3])
  end

# csvファイルでのデータ投入（shops）
CSV.foreach('db/seeds/development/shops.csv') do |row|
  Shop.create(:id => row[0],
               :gnavi_id => row[1],
               :tblg_id => row[2])
end