# encoding: utf-8
require './plurk.rb'
require './weather.rb'
require './setting.rb'
require './weather_data_base.rb'
require 'time'
#Setup OAuth client by create a instance of Plurk class
settinginit() #read setting file
$plurk = Plurk.new(@setting["APIKEY"], @setting["APISECRET"])
$plurk.authorize(@setting["TOKENKEY"], @setting["TOKENSECRET"])
$mysite = @setting["MYSITE"]
$weid = @setting["WEID"]

$prevent_flag = true

def addPlurk(t,p)
	
	if p==nil
		ti = Time.now
		json = nil
		begin
			$prevent_flag = false
			json = $plurk.post('/APP/Timeline/plurkAdd', {:content=>t.to_s, :qualifier=>':'})
			$prevent_flag = true
		rescue
			ti = Time.now
			s = ti.to_s + "addplurk has error" + "\n" + $!.to_s
			print s + "\n"
			recordError s
			if json != nil
				if json.key?("error_text")
					if json["error_text"] == "anti-flood-too-many-new"
						ti = Time.now
						s = ti.to_s + "too many new"
						print s + "\n"
						recordError(s)
						
						
					end
					return json
				end						
			end
			ti = Time.now
			s = ti.to_s + "addplurk will retry in 120 secend"+"\n"
			print s + "\n"
			recordError(s)
			sleep 120
			retry
		end
		ti = Time.now
		p ti.to_s + " addplurk"
		print "\n"
		p t
		print "\n"
		p json
		print "\n"
		return json
		
	else
		addprivatePlurk(t,p)
	end
	
end

def addprivatePlurk(t,user_id)
	
	ti = Time.now 
	begin
		json = $plurk.post('/APP/Timeline/plurkAdd', {:content=>t.to_s, :qualifier=>':',:limited_to => [user_id]})
	rescue
		print ti.to_s + "add private plurk ha error" + "\n" + $!.to_s + "\n" 
	end
	
	print ti.to_s + "addprivateplurk"
	print "\n"
	p json
	print "\n"
	
	
end

def responsePlurk(plurkid,text)
	
	t = Time.now
	begin
		res = $plurk.post('/APP/Responses/responseAdd',{:plurk_id=>plurkid , :content=>text , :qualifier=>':'})
	rescue
		print t.to_s + "response plurk ha error" + "\n" + $!.to_s + "\n"
	ensure
		p t.to_s + "addres"+"\n"
		p text
		print"\n"
		p res
		print "\n"
	end
end

def getUnreadPlurk
	
	begin 
		json = $plurk.post('/APP/Timeline/getUnreadPlurks')
	rescue
		print "get unread plurk has error" + "\n" + $!.to_s + "\n"
		sleep 5
		retry
	end
	
	return json
end


def checkresponse(plurkid)
	
	json = nil
	begin
		json = $plurk.post('/APP/Responses/get',{:plurk_id=>plurkid})
	rescue
		print "get response has error"+"\n" + $!.to_s + "\n"
		sleep 5
		retry
	end
	i = true
	json["responses"].each{|res|
	
		if res["user_id"]==9472755 && res["content_raw"]=="是 知道了"
			i = false	
		end
	}
	return i

end

def checkcommand()
	
	t = Time.now
	f = false
	json = nil
	begin 
		while true
			if $prevent_flag == true
				json = $plurk.post('/APP/Timeline/getPlurks',{:limit=>10})
				break
			end
		end
	rescue
		ss = to_s + "get plurk has error" + "\n" + $!.to_s
		print ss + "\n"
		#recordError(ss)
		sleep 5
		retry
	end	
	if json == nil
		print "get plurk return nil"+"\n"
		return json 
	end
	json["plurks"].each{|pl|
		if pl["content_raw"] =~/GEJI[姐|姊] ([\W|\w|\u4e00-\u9fa5]+)/ 
			
			a= [pl["owner_id"],9472755]
		
			case $~[1]
			
			when /wenow|now weather|現在([\W|\w|\u4e00-\u9fa5]*)天氣/
				site = $~[1]
				
				if checkresponse(pl["plurk_id"]) == true
					printf site
					printf "\n"
					responsePlurk(pl["plurk_id"],"是 知道了")
					
					s = weatherString("now",site,2)
			
					responsePlurk(pl["plurk_id"],s)
					print pl["plurk_id"].to_s+"done"+"\n"
					f=true
				else 
					#print pl["plurk_id"].to_s+"had yet"+"\n"
				end 
				
			when /wetomorrow|tomorrow weather|明天([\W|\w|\u4e00-\u9fa5]*)天氣/
				site = $~[1]
				
				if checkresponse(pl["plurk_id"]) == true
					printf site
					printf "\n"
					responsePlurk(pl["plurk_id"],"是 知道了")
					
					s = weatherString("tomorrow",site,2)
					
					responsePlurk(pl["plurk_id"],s)
					print pl["plurk_id"].to_s+"done"+"\n"
					f=true
				else 
					#print pl["plurk_id"].to_s+"had yet"+"\n"
				end
			when /wetoday|today weather|今天([\W|\w|\u4e00-\u9fa5]*)天氣/
				site = $~[1]
				
				if checkresponse(pl["plurk_id"]) == true
					printf site
					printf "\n"
					responsePlurk(pl["plurk_id"],"是 知道了")
					
					s = weatherString("today",site,2)
					responsePlurk(pl["plurk_id"],s)
				
					print pl["plurk_id"].to_s+"done"+"\n"
					f=true
				else 
					#print pl["plurk_id"].to_s+"had yet"+"\n"
				end
				
			when /hidden head [N|n][O|o].(\d)/
				
				if checkresponse(pl["plurk_id"]) == true

					responsePlurk(pl["plurk_id"],"是 知道了")
					
					s = ""
					
					case $~[1].to_i
					
						when 1
							s = "君島報告 No.1"
							responsePlurk(pl["plurk_id"],s)
							sleep 2
							s = "這是假設我被殺害而準備的備份報告，我受到了不明人士的脅迫，恐怕在不久之後就會被抹殺吧。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "NASA隱瞞了重大的事實，在2000年11月調查太陽的南極圈時，毫無疑問的發現了磁單極子，也就是Monopole確實存在於那裡。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "但是，NASA卻進行了徹底的虛假宣傳，使得人們完全吧一部分流出的事實當成是謊言，但是，根據科學依據，太陽即將爆發這一點無可爭辯的事實，2012,15,19,20年，會連續發生大規模的太陽風暴，特別是2015年的太陽風暴，會對地球擊地球磁圈產生嚴重影響，在世間無人知曉的狀況下，招致重大危機的力量將從太陽而來。"
							responsePlurk(pl["plurk_id"],s)
						when 2
							s = "君島報告 No.2"
							responsePlurk(pl["plurk_id"],s)
							sleep 2
							s = "向NASA施壓的是被稱為「300人委員會」案中操控世界的存在。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "所謂的「人類牧場話計畫」，就是把全人類的人口總數縮減成10億人，通過使用與論導向的方式，以成立世界統一政府為目的。" 
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "一定要注意「籠中鳥」，那對他們是如同象徵一樣的歌曲，在進行實驗的地方，那首歌一定會時隱時現的存在"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
						when 3
							s = "君島報告 No.3"
							responsePlurk(pl["plurk_id"],s)
							sleep 2
							s = "Project Atum是在300人委員會中，認證第114號計畫，由Tavistock研究所主導的的人類牧場化計畫"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "具體來說將士隊進入極度活躍期的太陽進行直接干涉，人為的引發日冕以及日冕所帶來的太陽風暴，從而使地球環境產生劇烈變化。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "預想的被害人數設定為50億人，到2015年應有實行的動向，伴隨此計畫，與300人委員換案中有關的製造商們，直到2012年支球都匯集體聲稱在研究開發機器人吧，美國的US RobotCom,英國的Liveepool Tech,日本的Exoskeleton。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
						when 4
							s = "君島報告 No.4"
							responsePlurk(pl["plurk_id"],s)
							sleep 2
							s ="而這一切並不是隔岸觀火。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "太陽磁層與地球有著緊密的聯繫。在太陽磁層中發生的磁層再結合斷地球的磁層有著巨大的影響，太陽風暴會將太陽的大氣和電漿混合成超高速的粒子流形式運送到地球磁層。如果一電那些電漿與地球發生衝突，引發磁層再結合也並發不可能。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "極光的發生，也應該被當作遊這種等電漿的加熱，加速帶來的的能量所促生的現象。如果地球磁層發生磁層的再結合，及磁層亞爆的話，想必地球上會出現遠比太陽風暴襲擊更加危險的，甚至能夠毀滅人類的大規模災難。"
							responsePlurk(pl["plurk_id"],s)
							sleep 1
							s = "Project Atum即是人工引起這樣災難的計畫，而HAARP只不過是這個計畫當中的一環。過於巨大的太陽對於人類來來說太難駕馭，但是與此相比地球磁層就更容易控制了。至少300人委員會是這樣認為的。"
							responsePlurk(pl["plurk_id"],s)
						when 5
						
							responsePlurk(pl["plurk_id"],"正在發佈君島報告...")
							
							a = addPlurk("君島報告",p)
							
							s = "君島報告 No.1"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "這是假設我被殺害而準備的備份報告，我受到了不明人士的脅迫，恐怕在不久之後就會被抹殺吧。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "NASA隱瞞了重大的事實，在2000年11月調查太陽的南極圈時，毫無疑問的發現了磁單極子，也就是Monopole確實存在於那裡。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "但是，NASA卻進行了徹底的虛假宣傳，使得人們完全吧一部分流出的事實當成是謊言，但是，根據科學依據，太陽即將爆發這一點無可爭辯的事實，2012,15,19,20年，會連續發生大規模的太陽風暴，特別是2015年的太陽風暴，會對地球擊地球磁圈產生嚴重影響，在世間無人知曉的狀況下，招致重大危機的力量將從太陽而來。"
							responsePlurk(a["plurk_id"],s)
							
							s = "君島報告 No.2"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "向NASA施壓的是被稱為「300人委員會」案中操控世界的存在。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "所謂的「人類牧場話計畫」，就是把全人類的人口總數縮減成10億人，通過使用與論導向的方式，以成立世界統一政府為目的。" 
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "一定要注意「籠中鳥」，那對他們是如同象徵一樣的歌曲，在進行實驗的地方，那首歌一定會時隱時現的存在"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							
							s = "君島報告 No.3"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "Project Atum是在300人委員會中，認證第114號計畫，由Tavistock研究所主導的的人類牧場化計畫"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "具體來說將士隊進入極度活躍期的太陽進行直接干涉，人為的引發日冕以及日冕所帶來的太陽風暴，從而使地球環境產生劇烈變化。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "預想的被害人數設定為50億人，到2015年應有實行的動向，伴隨此計畫，與300人委員換案中有關的製造商們，直到2012年支球都匯集體聲稱在研究開發機器人吧，美國的US RobotCom,英國的Liveepool Tech,日本的Exoskeleton。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
						
							s = "君島報告 No.4"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s ="而這一切並不是隔岸觀火。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "太陽磁層與地球有著緊密的聯繫。在太陽磁層中發生的磁層再結合斷地球的磁層有著巨大的影響，太陽風暴會將太陽的大氣和電漿混合成超高速的粒子流形式運送到地球磁層。如果一電那些電漿與地球發生衝突，引發磁層再結合也並發不可能。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "極光的發生，也應該被當作遊這種等電漿的加熱，加速帶來的的能量所促生的現象。如果地球磁層發生磁層的再結合，及磁層亞爆的話，想必地球上會出現遠比太陽風暴襲擊更加危險的，甚至能夠毀滅人類的大規模災難。"
							responsePlurk(a["plurk_id"],s)
							sleep 2
							s = "Project Atum即是人工引起這樣災難的計畫，而HAARP只不過是這個計畫當中的一環。過於巨大的太陽對於人類來來說太難駕馭，但是與此相比地球磁層就更容易控制了。至少300人委員會是這樣認為的。"
							responsePlurk(a["plurk_id"],s)
							
						else
					
					end
					
					print pl["plurk_id"].to_s+"done"+"\n"
					f=true
				else 
					#print pl["plurk_id"].to_s+"had yet"+"\n"
				end
				
			end
		end
		
	}
	
	return f
end

def checkAlerts  # not finish
	
	alert = $plurk.post('/APP/Alerts/getActive')
	
	alert.each{|ale|
		print ale
		print "\n"
		print "------------------------"
		print "\n"
	}
	
end


def weatherString(time,local,mode)  #mode: 1 = 愛理, 2 = GEJI姐

	$w = ReWeather.new
	$w.setWeather($w.localCode(local))
	nowcode = $w.nowWeatherCode.to_i
	todaycode = $w.todayWeatherCode.to_i
	tomorrowcode = $w.tomorrowWeatherCode.to_i
	s = nil
	if mode == 1
		s = "愛理好像出問題了"
	else
		s = "出現錯誤"
	end
	
	case time 
		
		when "now"
			
			if mode == 1
				s = "天氣預報 天氣預報 現在"+$w.localText(local)+"地區 天氣"+ $w.code2text(nowcode) +"  "+ "溫度" + $w.nowTemp + "\n" + weatherDB(nowcode,mode)
			end
			if mode == 2
				s = "現在"+$w.localText(local)+"地區 天氣"+ $w.code2text(nowcode) + "  " + "溫度" + $w.nowTemp + "\n" + weatherDB(nowcode,mode)
			end
			
		when "today"
			
			if mode == 1
				s = "天氣預報 天氣預報 今天"+ $w.localText(local) + "地區 天氣"+ $w.code2text(todaycode) + "  " + "溫度" + ($w.todayHighTemp-273.15).round.to_s + "到" + ($w.todayLowTemp-273.15).round.to_s + "\n" + weatherDB(todaycode,mode)
			end
			if mode == 2
				s = "今天"+$w.localText(local)+"地區 天氣"+ $w.code2text(todaycode) + "  " + "溫度" + ($w.todayHighTemp-273.15).round.to_s + "到" + ($w.todayLowTemp-273.15).round.to_s + "\n" + weatherDB(todaycode,mode)
			end
			
		when "tomorrow"
		
			if mode == 1
				s = "天氣預報 天氣預報 明天"+$w.localText(local)+"地區 天氣"+ $w.code2text(tomorrowcode) + "  " +"溫度" + $w.tomorrowHighTemp + "到" + $w.tomorrowLowTemp + "\n" + weatherDB(tomorrowcode,mode)
			end
			if mode == 2
				s = "明天"+$w.localText(local)+"地區 天氣"+ $w.code2text(tomorrowcode) + "  " +"溫度" + $w.tomorrowHighTemp + "到" + $w.tomorrowLowTemp + "\n" + weatherDB(tomorrowcode,mode)
			end
		
	end
	
	print "weather string s = "
	p s
	print "\n"
	
	return s
	
end

def todayweatherreport(local,p=nil)
		
	addPlurk(weatherString("today",local,1),p)
		
end

def tomorrowweatherreport(local,p=nil)
	
	addPlurk(weatherString("tomorrow",local,1),p)

end

def nowweatherreport(local,p=nil)
	
	addPlurk(weatherString("now",local,1),p)
	
end

def recordError(text)
	
	begin
		re = File.open("./record","a+")
		re.write(text + "\n")
		re.write("==============================="+"\n")
		re.close
	rescue
		print "record file has error" + $!.to_s + "\n"
	end
end

print "Today weather ykikana start"+"\n"


Thread.new{

while true
	
	#print "reportweather start"+"\n"
    	t=Time.now
	begin 
	if t.hour == 7 && (t.min == 00||t.min ==01)   #7:00|7:01
		todayweatherreport($mysite,nil)
		sleep(120)
	end
	if t.hour == 11 && (t.min == 50 ||t.min ==51)  #11:50|11:51
		nowweatherreport($mysite,nil)
		sleep(120)
	end

	if t.hour == 18 && (t.min == 30||t.min ==31) #18:30|18:31
		tomorrowweatherreport($mysite,nil)
		sleep(120)
	end
	#print "reportweather end"+"\n"
	sleep 1
	rescue
	print t.to_s + "report weather has error" + "\n" + $!.to_s + "\n"
	sleep 5
	retry
	end 
end
}

Thread.new{
	while true
		t = Time.now
		begin
		#print "checkcommand start "+"\n"
		checkcommand()
		#print "checkcommand end "+"\n"
		sleep 1
		rescue
		print t.to_s + "checkcmd has errer" + "\n" + $!.to_s + "\n"
		sleep 5
		retry
		end
	end
	
}

while true

	#cmd = gets.chomp	
	
	case gets.chomp
		when "wetoday"
			todayweatherreport($mysite,nil)		
		
		when "wetomorrow"
			tomorrowweatherreport($mysite,nil)
	
		when "wenow"
			nowweatherreport($mysite,nil)
	
		when "check"
			checkcommand()
		
		when "close"
			break
				
		when "chsite"
			puts "請輸入地名"+"\n" 
			cmd = gets.chomp
			old_site = $mysite
			$mysite = cmd 
			chsite(cmd)
			s = "因為愛理搬家了 所以預報地區從" + old_site.to_s + "換成" + $mysite.to_s + "了歐 >///<"
			puts(s)
			addPlurk(s,nil)

		when "nowsite"
			 puts "現在的預報位置:"+$mysite
			 
		when "test"
			addPlurk("愛理發文系統測試中",nil)
			 
	end

 end
