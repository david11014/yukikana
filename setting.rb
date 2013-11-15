@setting = {"APIKEY" => "","APISECRET" => "","TOKENKEY" => "","TOKENSECRET" => "","MYSITE" => ""}
@filename = "setting"

def rsetting

	open(@filename,"r") do |io|

	        while line = io.gets
		        line.chomp!
        		/([a-zA-Z0-9_]+)[ ]*=[ ]*['"]([a-zA-Z0-9\u4e00-\u9fa5]+)['"]/ =~ line

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
	
	io = open(@filename,"w")

	@setting.each{|key,value|
		io.puts("#{key} = \"#{value}\"")
	}

	io.close
	
end

def chapi(key,secret)

	@setting["APIKEY"] = key
	@settingp["APISECRET"] = secret

end

def chtoken(key,secret)

	@setting["TOKENKEY"] = key
	@setting["TOKENSECRET"] = secret

end
