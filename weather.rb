#!/usr/bin/env ruby 
# encoding: utf-8

require 'net/http'
require 'rubygems'
require 'xmlsimple'

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
		
		#url = 'http://weather.yahooapis.com/forecastrss?u=c&w='+localcode
		url = "http://api.openweathermap.org/data/2.5/forecast?id=#{localcode}&APPID=#{$weid}"
		#url='forecastrss.xml'
		NowData = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
		#xmlweather = XmlSimple.xml_in(xml_data)
		#puts data
		
		
		@nowWeatherCode = NowData["weather"]["id"]
		@nowWeatherText = NowData["weather"]["main"]
		@nowTemp = NowData["main"]["temp"]
		#@nowDate = xmlweather['channel'][0]['item'][0]['condition'][0]['date']
	
	
		@todayDate = xmlweather['channel'][0]['item'][0]['forecast'][0]['date'] + xmlweather['channel'][0]['item'][0]['forecast'][0]['day']
		@todayWeatherCode =	xmlweather['channel'][0]['item'][0]['forecast'][0]['code']
		@todayWeatherText =	xmlweather['channel'][0]['item'][0]['forecast'][0]['text']
		@todayLowTemp =	xmlweather['channel'][0]['item'][0]['forecast'][0]['low']
		@todayHighTemp =	xmlweather['channel'][0]['item'][0]['forecast'][0]['high']
		
		@tomorrowDate = xmlweather['channel'][0]['item'][0]['forecast'][1]['date'] + xmlweather['channel'][0]['item'][0]['forecast'][1]['day']
		@tomorrowWeatherCode = xmlweather['channel'][0]['item'][0]['forecast'][1]['code']
		@tomorrowWeatherText =	xmlweather['channel'][0]['item'][0]['forecast'][1]['text']
		@tomorrowLowTemp =	xmlweather['channel'][0]['item'][0]['forecast'][1]['low']
		@tomorrowHighTemp =	xmlweather['channel'][0]['item'][0]['forecast'][1]['high']
		
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
			
			when /台南|Tainan|tainan/
				a='1668355'
			
			when /雲林|Yunlin|yunlin/
				a='1665194'
				
			when /台東|Taitung|taitung/
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
		
		a="台中"
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
	
end
