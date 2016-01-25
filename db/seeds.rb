# シード投入用ファイル
# target_file_names = %w(  actions )
# target_file_names = %w( answer_histories )
# target_file_names = %w( matches )
# target_file_names = %w( questions )
# target_file_names = %w( shops )
# target_file_names = %w( users )
# property_file_names = %w( seed_for_business_message_properties seed_for_business_rule_properties seed_for_system_properties )
# member-portal test
target_file_names = %w( matches questions shops users )
# development, production それぞれで対象のシード用ファイルを準備、環境に合わせて実行
target_file_names.each do |target_file|
  path = Rails.root.join("db/seeds/development/", Rails.env, target_file + ".rb")
  if File.exist?(path)
    puts "Loading #{Rails.env}:#{target_file}..."
    require path
  end
end
# property_file_names.each do |property_file|
#   path = Rails.root.join("db/seeds", Rails.env, property_file + ".rb")
#   if File.exist?(path)
#     puts "Loading #{Rails.env}:#{property_file}..."
#     require path
#   end
# end