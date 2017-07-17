require 'json'
require 'net/http'
json_string = File.read('./city.list.json') # 这里返回的不是 file handle，只是 string
WeatherList = JSON.parse(json_string)
io = open("city.db","w")
WeatherList.each do |key, value|
   if key['country'] == 'TW'
	io.puts("#{key['name']} = #{key['id']}")	
	io.puts("http://maps.google.com/?q="+"#{key['coord']['lat']},#{key['coord']['lon']}")
   end
   
end

io.close