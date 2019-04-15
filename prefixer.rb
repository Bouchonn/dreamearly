require_relative 'main.rb'

if ARGV[0].nil?
	puts "please provide a filepath. ex: './FILE_NAME'"
else
	puts Parser.run(ARGV[0])
end