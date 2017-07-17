require 'json'

json_string = File.read('./city.list.json') # 这里返回的不是 file handle，只是 string
WeatherList = JSON.parse(json_string)

WeatherList.each do |key, value|
   if key['country'] == 'TW'
	puts(key['id'])
	puts(key['name'])
	puts("==============")
   end
   
end