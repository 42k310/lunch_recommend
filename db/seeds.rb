# # シード投入用ファイル
# target_file_names = %w( match )
# # development, production それぞれで対象のシード用ファイルを準備、環境に合わせて実行
# target_file_names.each do |target_file|
#   path = Rails.root.join("db/seeds/", Rails.env, target_file + ".rb")
#   p path
#   File.exist?(path)
#   if File.exist?(path)
#     puts "Loading #{Rails.env}:#{target_file}..."
#     require path
#   end
# end

# csvファイルでのデータ投入（matches）
require "csv"

# target_file_names = %w( matches shops questions )
# target_file_names.each do |target_file|
#   CSV.foreach('db/seeds/development/csv/matches.csv') do |row|
#     Match.create(:id => row[0],
#                  :shop_id => row[1],
#                  :question_id => row[2],
#                  :answer_type => row[3])
#     p "Loading #{Rails.env}:#{target_file}..."
#   end
#
# end
#
# CSV.foreach('db/seeds/development/csv/matches.csv') do |row|
#   Match.create(:id => row[0],
#                :shop_id => row[1],
#                :question_id => row[2],
#                :answer_type => row[3])
#     p "Loading #{Rails.env}:#{target_file}..."
#   end
#
# # csvファイルでのデータ投入（shops）
# CSV.foreach('db/seeds/development/csv/shops.csv') do |row|
#   Shop.create(:id => row[0],
#                :gnavi_id => row[1],
#                :tblg_id => row[2])
# end
#
# # csvファイルでのデータ投入（questions）
# CSV.foreach('db/seeds/development/csv/questions.csv') do |row|
#   Question.create(:id => row[0],
#               :title => row[1],
#               :answer1 => row[2],
#               :answer2 => row[3])
# end
#
#

target_file_names = %w( matches shops questions )
target_file_names.each do |target_file|
  p "#{target_file}start"
  if target_file == "matches"
    CSV.foreach("db/seeds/development/csv/#{target_file}.csv") do |row|
      Match.create(:id => row[0],
                   :shop_id => row[1],
                   :question_id => row[2],
                   :answer_type => row[3])
      p "Loading #{Rails.env}:#{target_file}..."
      end
      elsif target_file == "shops"
      CSV.foreach("db/seeds/development/csv/#{target_file}.csv") do |row|
        Shop.create(:id => row[0],
                    :gnavi_id => row[1],
                    :tblg_id => row[2])
        p "Loading #{Rails.env}:#{target_file}..."
      end
        elsif target_file == "questions"
        CSV.foreach('db/seeds/development/csv/questions.csv') do |row|
          Question.create(:id => row[0],
                          :title => row[1],
                          :answer1 => row[2],
                          :answer2 => row[3])
          p "Loading #{Rails.env}:#{target_file}..."
        end
    end
end