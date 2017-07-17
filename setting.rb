﻿@setting = {"APIKEY" => "","APISECRET" => "","TOKENKEY" => "","TOKENSECRET" => "","MYSITE" => "","WEID" =>""}
@filename = "setting.db"

def settinginit
	
	if(FileTest::exist?(@filename) != true)
                fileinit();
        end
	rsetting()
	chsetting()

end

def fileinit()

        print "Please entry api key:\n"

        @setting["APIKEY"] = gets.chomp

        print "Please entry api sercrt key:\n"
        @setting["APISECRET"] = gets.chomp

        print "Please entry token key:\n"
        @setting["TOKENKEY"] = gets.chomp

        print "Please entry token secret key:\n"
        @setting["TOKENSECRET"] = gets.chomp

        print "Please entry origin report site:\n"
        @setting["MYSITE"] = gets.chomp
		
		print "Please entry openweather map API key:\n"
        @setting["WEID"] = gets.chomp
		
        wsetting()
	psetting()
end

def chsetting

	@setting.each{|key,value|

        	if(@setting[key] == "")
			print key + " is NULL\n"
			fileinit()
		end
        }

end

def psetting

        @setting.each{|key,value|
         	
		print key + ": " + value +"\n"
       
        }

end

def rsetting

	print "read setting... \n"	
	open(@filename,"r:utf-8") do |io|

	        while line = io.gets
		        line.chomp!
        		/([a-zA-Z0-9_]+)[ ]*=[ ]*['"]([a-zA-Z0-9\u4E00-\u9fA5]*)['"]/ =~ line

		        setting_key = $1
		        setting_value = $2

        		if (@setting.key?(setting_key))
                		@setting[setting_key] = setting_value
	                	print setting_key + ": " + setting_value + "\n"
		                
		        end

        	end

	end

end

def wsetting
	
	io = open(@filename,"w:utf-8")

	@setting.each{|key,value|
		io.puts("#{key.encode('UTF-8')} = \"#{value.encode('UTF-8')}\"")
	}

	io.close
	
end

def chapi(key,secret)

	@setting["APIKEY"] = key
	@settingp["APISECRET"] = secret
	wsetting()

end

def chtoken(key,secret)

	@setting["TOKENKEY"] = key
	@setting["TOKENSECRET"] = secret
	wsetting()

end

def chsite(site)
	
	@setting["MYSITE"] = site
        wsetting()

end

