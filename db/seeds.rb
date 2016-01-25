# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# シード投入用ファイル
# target_file_names = %w(  seed_for_settlement_api_integration_test )
# target_file_names = %w( seed_for_member_portal_integration_test )
# target_file_names = %w( seed_for_member_auth_module_integration_test )
# property_file_names = %w( seed_for_business_message_properties seed_for_business_rule_properties seed_for_system_properties )
# member-portal test
target_file_names = %w( matches questions shops users )
# development, production それぞれで対象のシード用ファイルを準備、環境に合わせて実行
target_file_names.each do |target_file|
  path = Rails.root.join("db/seeds", Rails.env, target_file + ".rb")
  p path
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