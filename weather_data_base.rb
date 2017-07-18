def weatherDB( wecode=nil ,mode = nil)
	s = ""
	case (wecode/100).round
		when 0
			if mode == 1
			end
			if mode ==2
			end
		when 2
			if mode == 1
			end
			if mode ==2
			end
		when 2                      #颱風
			if mode == 1
				s = "大家盡量不要外出喔"
			end
			if mode ==2
				s ="請盡量不要外出"
			end
		when (3..12),(37..40),45,47  #雨
			if mode == 1
			s = "大家記得要帶傘喔~"
			end
			if mode == 2 
			s = "要出門時請記得帶傘"
			end
		when 19
			if mode == 1
				s= "嗚~ 咳!咳!  請大家要保護好口鼻...咳!咳!"
			end
			if mode ==2
				s= "請大家要保護好口鼻，開車時要注意安全"
			end
		when (20..22)
			if mode == 1
				s = "開車要注意安全喔~"
			end
			if mode ==2
				s = "開車請注意安全"
			end
	end
return s
end
