#!/usr/bin/env ruby 
# encoding: utf-8

require 'net/http'
require 'rubygems'
require 'xmlsimple'
require 'json'

class ReWeather
	@nowWeatherCode = nil 
	@nowWeatherText = nil
	@nowTemp = nil
	@nowDate = nil
	
	@todayDate = nil
	@todayWeatherCode =	nil
	@todayWeatherText =	nil
	@todayLowTemp =	nil
	@todayHighTemp = nil

	@tomorrowDate = nil
	@tomorrowWeatherCode = nil
	@tomorrowWeatherText =	nil
	@tomorrowLowTemp =	nil
	@tomorrowHighTemp =	nil
	
	
	
	attr_reader :nowWeatherCode
	attr_reader :nowWeatherText
	attr_reader :nowTemp
	attr_reader :nowDate
	
	attr_reader :todayDate
	attr_reader :todayWeatherCode
	attr_reader :todayWeatherText
	attr_reader :todayLowTemp
	attr_reader :todayHighTemp
	
	attr_reader :tomorrowDate
	attr_reader :tomorrowWeatherCode
	attr_reader :tomorrowWeatherText
	attr_reader :tomorrowLowTemp
	attr_reader :tomorrowHighTemp
			
	def setWeather(localcode)
		
		
		url = 'http://api.openweathermap.org/data/2.5/weather?id=' + localcode.to_s + '&APPID=' + $weid.to_s
		nowData = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
		url = 'http://api.openweathermap.org/data/2.5/forecast?id=' + localcode.to_s + '&APPID=' + $weid.to_s
		forecastData = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
		fiveDayData = forecastData['list']
		
		
		@nowWeatherCode = nowData['weather'][0]['id']		
		@nowTemp = nowData['main']['temp'] - 273.15
	
		
		@todayWeatherCode =	fiveDayData[3]['weather'][0]['id']		
		@todayHighTemp = 0
		@todayLowTemp = 2147483647
		for i in 0..7 #03:00~24:00 every 3hr
			if  fiveDayData[i]["main"]["temp_max"] > @todayHighTemp
				@todayHighTemp =  fiveDayData[i]["main"]["temp_max"]
			end
			
			if  fiveDayData[i]["main"]["temp_min"] < @todayLowTemp
				@todayLowTemp =  fiveDayData[i]["main"]["temp_min"]
			end
		end
		@todayHighTemp -= 273.15
		@todayLowTemp -= 273.15
		
		
		@tomorrowWeatherCode =	fiveDayData[11]['weather'][0]['id']		
		@tomorrowHighTemp = 0
		@tomorrowLowTemp = 2147483647
		for i in 7..15 #03:00~24:00 every 3hr
			if  fiveDayData[i]["main"]["temp_max"] > @tomorrowHighTemp
				@tomorrowHighTemp =  fiveDayData[i]["main"]["temp_max"]
			end
			
			if  fiveDayData[i]["main"]["temp_min"] < @tomorrowLowTemp
				@tomorrowLowTemp =  fiveDayData[i]["main"]["temp_min"]
			end
		end
		
		@tomorrowHighTemp -= 273.15
		@tomorrowLowTemp -= 273.15			
		
		return nil
	end	
	
	def localCode(l)
		
		a='7280290'
		case l
	
			when /台北|臺北|Taipei|taipei/
				a='7280290'
				
			when /台中|臺中|Taichung|taichung/
				a='1668399'
				
			when /高雄|Kaohsiung|kaohsiung/
				a='7280289'
	
			when /新北/
				a='1665148'
	
			when /彰化|Changhua|changhua/
				a='1679136'
	
			when /屏東|Pingtung|pingtung/
				a='1670479'
	
			when /桃園|Taoyuan|taoyuan/
				a='1667905'
	
			when /南投|Nantou|nantou/
				a='1671566'
	
			when /基隆|Keelung|keelung/
				a='6724654'
	
			when /新竹|Hsinchu|hsinchu/
				a='1675151'
	
			when /嘉義|Chiayi|chiayi/
				a='1678836'
	
			when /宜蘭|Ilan|ilan/
				a='1674199'
	
			when /花蓮|Hualien|hualien/
				a='1674504'
	
			when /苗栗|Miaoli|miaoli/
				a='1671971'
			
			when /台南|臺南|Tainan|tainan/
				a='1668355'
			
			when /雲林|Yunlin|yunlin/
				a='1665194'
				
			when /台東|臺東|Taitung|taitung/
				a='1668295'
			
			when /金門/
				a='1675247'
			
			when /連江/
				a='1676453'
				
			when /澎湖|Peng-hu|peng-hu/
				a='1670651'
			when /種子島|Nishinoomote|nishinoomote|Tanegashima|tanegashima/
				a='1855203'				
		
		end
		
		return a
	end
	
	def localText(l)
		
		a="台北"
		case l
	
			when /台北|臺北|Taipei|taipei/
				a="台北"
				
			when /台中|臺中|Taichung|taichung/
				a="台中"
				
			when /高雄|Kaohsiung|kaohsiung/
				a="高雄"
	
			when /新北/
				a="新北市"
	
			when /彰化|Changhua|changhua/
				a="彰化"
	
			when /屏東|Pingtung|pingtung/
				a="屏東"
	
			when /桃園|Taoyuan|taoyuan/
				a="桃園"
	
			when /南投|Nantou|nantou/
				a="南投"
	
			when /基隆|Keelung|keelung/
				a="基隆"
	
			when /新竹|Hsinchu|hsinchu/
				a="新竹"
	
			when /嘉義|Chiayi|chiayi/
				a="嘉義"
	
			when /宜蘭|Ilan|ilan/
				a="宜蘭"
	
			when /花蓮|Hualien|hualien/
				a="花蓮"
	
			when /苗栗|Miaoli|miaoli/
				a="苗栗"
	
			when /台南|Tainan|tainan/
				a="台南"
				
			when /台東|Taitung|taitung/
				a="台東"
			when /澎湖|Peng-hu|peng-hu/
				a="澎湖"
			when /種子島/
				a="種子島"					
		
		end
		
		return a
	end
	
	def code2text(code)
	
	mode = 1
	
	if mode == 1
		weText ={'雷暴混和小雨'=> 200,
				'雷雨'=> 201,
				'雷雨混和大雨'=> 202,
				'輕雷暴'=> 210,
				'雷暴'=> 211,
				'大雷暴'=> 212,
				'很大的雷暴'=> 221,
				'雷雨混和細雨'=> 230,
				'雷雨混和毛毛雨'=> 231,
				'雷雨混和較大的細雨'=> 232,
				'輕度毛毛雨'=> 300,
				'毛毛雨'=> 301,
				'較大的毛毛雨'=> 302,
				'較小的毛毛雨'=> 310,
				'下毛毛雨'=> 311,
				'強力毛毛雨'=> 312,
				'陣雨混合毛毛雨'=> 313,
				'大雨混和毛毛雨'=> 314,
				'小陣雨'=> 321,
				'小雨'=> 500,
				'中雨'=> 501,
				'重度強降雨'=> 502,
				'很大的雨'=> 503,
				'極端降雨'=> 504,
				'凍雨'=> 511,
				'輕度陣雨'=> 520,
				'陣雨'=> 521,
				'強烈的陣雨'=> 522,
				'極強烈的陣雨'=> 531,
				'小雪'=> 600,
				'下雪花'=> 601,
				'下大雪'=> 602,
				'下霰'=> 611,
				'陣霰'=> 612,
				'輕雨雪'=> 615,
				'雨雪'=> 616,
				'小陣雪'=> 620,
				'陣雪'=> 621,
				'大雪'=> 622,
				'薄霧'=> 701,
				'煙霧'=> 711,
				'霾'=> 721,
				'沙混和著灰塵'=> 731,
				'霧'=> 741,
				'沙'=> 751,
				'粉塵'=> 761,
				'火山灰'=> 762,
				'狂風'=> 771,
				'龍捲風'=> 781,
				'晴天'=> 800,
				'天空少雲'=> 801,
				'天空有分散的雲'=> 802,
				'天空有破碎的雲彩'=> 803,
				'陰天'=> 804,
				'有龍捲風'=> 900,
				'有熱帶風暴'=> 901,
				'颶風'=> 902,
				'寒冷'=> 903,
				'炎熱'=> 904,
				'多風'=> 905,
				'冰雹'=> 906,
				'平穩'=> 951,
				'有輕微的風'=> 952,
				'有溫柔的微風'=> 953,
				'有中度的微風'=> 954,
				'有清新的微風'=> 955,
				'有強烈的風'=> 956,
				'很強烈的風'=> 957,
				'有大風'=> 958,
				'有嚴俊的大風'=> 959,
				'風暴'=> 960,
				'暴風雨'=> 961,
				'颱風'=> 962
	}
	else
		weText ={'thunderstorm with light rain'=>200,
				'thunderstorm with rain'=>201,
				'thunderstorm with heavy rain'=>202,
				'light thunderstorm'=>210,
				'thunderstorm'=>211,
				'heavy thunderstorm'=>212,
				'ragged thunderstorm'=>221,
				'thunderstorm with light drizzle'=>230,
				'thunderstorm with drizzle'=>231,
				'thunderstorm with heavy drizzle'=>232,
				'light intensity drizzle'=>300,
				'drizzle'=>301,
				'heavy intensity drizzle'=>302,
				'light intensity drizzle rain'=>310,
				'drizzle rain'=>311,
				'heavy intensity drizzle rain'=>312,
				'shower rain and drizzle'=>313,
				'heavy shower rain and drizzle'=>314,
				'shower drizzle'=>321,
				'light rain'=>500,
				'moderate rain'=>501,
				'heavy intensity rain'=>502,
				'very heavy rain'=>503,
				'extreme rain'=>504,
				'freezing rain'=>511,
				'light intensity shower rain'=>520,
				'shower rain'=>521,
				'heavy intensity shower rain'=>522,
				'ragged shower rain'=>531,
				'light snow'=>600,
				'snow'=>601,
				'heavy snow'=>602,
				'sleet'=>611,
				'shower sleet'=>612,
				'light rain and snow'=>615,
				'rain and snow'=>616,
				'light shower snow'=>620,
				'shower snow'=>621,
				'heavy shower snow'=>622,
				'mist'=>701,
				'smoke'=>711,
				'haze'=>721,
				'sand, dust whirls'=>731,
				'fog'=>741,
				'sand'=>751,
				'dust'=>761,
				'volcanic ash'=>762,
				'squalls'=>771,
				'tornado'=>781,
				'clear sky'=>800,
				'few clouds'=>801,
				'scattered clouds'=>802,
				'broken clouds'=>803,
				'overcast clouds'=>804,
				'tornado'=>900,
				'tropical storm'=>901,
				'hurricane'=>902,
				'cold'=>903,
				'hot'=>904,
				'windy'=>905,
				'hail'=>906,
				'calm'=>951,
				'light breeze'=>952,
				'gentle breeze'=>953,
				'moderate breeze'=>954,
				'fresh breeze'=>955,
				'strong breeze'=>956,
				'high wind, near gale'=>957,
				'gale'=>958,
				'severe gale'=>959,
				'storm'=>960,
				'violent storm'=>961,
				'hurricane'=>962	
	}
	end
	
	return weText.key(code)
end
	
	
	
end
