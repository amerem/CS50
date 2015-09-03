
#open / wright and read file
5.times do
  File.open("../master/features/support/pit_version.txt", "r").each {|e| puts e }
  sleep 2
  File.open("../master/features/support/pit_version.txt", "a") { |f| f << "#{Time.now.to_s}\n" }
  sleep 2
  File.open("../master/features/support/pit_version.txt", "r").each {|e| puts e }
end


