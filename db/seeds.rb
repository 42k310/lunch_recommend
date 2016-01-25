# シード投入用ファイル
target_file_names = %w( matches questions shops users )
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

