---@diagnostic disable: undefined-global

return {
	s({ trig = "cl (.*)", regTrig = true },
		fmta([[console.log(<>, <>)]], {
			i(1),
			f(function(_, s)
				local captured = s.captures[1]
				if captured and captured ~= "" then
					return captured
				else
					return '""'
				end
			end)
		})
	),
	s({ trig = "(.*) cl", regTrig = true },
		fmta([[console.log(<>, <>)]], {
			i(1),
			f(function(_, s)
				local captured = s.captures[1]
				if captured and captured ~= "" then
					return captured
				else
					return '""'
				end
			end)
		})
	),
}
