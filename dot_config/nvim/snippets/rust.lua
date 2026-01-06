---@diagnostic disable: undefined-global

return {
	s({ trig = "dp" },
		fmta([[println!("{:?}", <>)]],
			{
				i(1),
			})
	),
	s({ trig = "p" },
		fmta([[println!("{}", <>)]],
			{
				i(1),
			})
	),
}
