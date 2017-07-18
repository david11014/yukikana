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
		#@nowWeatherText = nowData["weather"]["main"]
		@nowTemp = nowData['main']['temp'] - 273.15
		#@nowDate = xmlweather['channel'][0]['item'][0]['condition'][0]['date']
	
	
		#@todayDate = xmlweather['channel'][0]['item'][0]['forecast'][0]['date'] + xmlweather['channel'][0]['item'][0]['forecast'][0]['day']
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
			
		#@tomorrowDate = xmlweather['channel'][0]['item'][0]['forecast'][1]['date'] + xmlweather['channel'][0]['item'][0]['forecast'][1]['day']
		#@tomorrowWeatherCode = xmlweather['channel'][0]['item'][0]['forecast'][1]['code']
		#@tomorrowWeatherText =	xmlweather['channel'][0]['item'][0]['forecast'][1]['text']
		#@tomorrowLowTemp =	xmlweather['channel'][0]['item'][0]['forecast'][1]['low']
		#@tomorrowHighTemp =	xmlweather['channel'][0]['item'][0]['forecast'][1]['high']
		
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
	case code
		when 1  ; return "熱帶風暴"
		when 2  ; return "颶風"
		when 3  ; return "強雷雨"
		when 4  ; return "雷雨"
		when 5  ; return "雨雪混合"
		when 6  ; return "混合雨和雨夾雪"
		when 7  ; return "混合雪和雨夾雪"
		when 8  ; return "凍結小雨"
		when 9  ; return "小雨"
		when 10 ; return "凍雨"
		when 11 ; return "陣雨"
		when 12 ; return "陣雨"
		when 13 ; return "小雪"
		when 14 ; return "小雪"
		when 15 ; return "吹雪"
		when 16 ; return "雪"
		when 17 ; return "冰雹"
		when 18 ; return "雨夾雪"
		when 19 ; return "沙塵"
		when 20 ; return "有霧"
		when 21 ; return "霾"
		when 22 ; return "多煙塵"
		when 23 ; return "大風"
		when 24 ; return "多風"
		when 25 ; return "寒冷"
		when 26 ; return "多雲"
		when 27 ; return "晚上晴時多雲"
		when 28 ; return "白天晴時多雲"
		when 29 ; return "晚上晴時多雲"
		when 30 ; return "白天晴時多雲"
		when 31 ; return "夜晚晴朗"
		when 32 ; return "陽光明媚"
		when 33 ; return "夜間天空清澈"
		when 34 ; return "白天天空清澈"
		when 35 ; return "混合雨和冰雹"
		when 36 ; return "大熱天"
		when 37 ; return "局部地區性雷雨"
		when 38 ; return "偶有雷雨"
		when 39 ; return "偶有雷雨"
		when 40 ; return "零星陣雨"
		when 41 ; return "大雪"
		when 42 ; return "零星陣雪"
		when 43 ; return "大雪"
		when 44 ; return "晴間多雲"
		when 45 ; return "雷陣雨"
		when 46 ; return "陣雪"
		when 47 ; return "局部區域性雷陣雨"
	end
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
	return weText.key(code)
end
	
	
	
end
