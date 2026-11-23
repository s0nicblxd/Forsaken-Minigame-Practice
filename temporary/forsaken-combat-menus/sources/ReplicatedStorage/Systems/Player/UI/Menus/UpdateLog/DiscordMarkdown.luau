local LocalizationService = game:GetService("LocalizationService")
local t1 = {
	24,
	20,
	16
}
local color3 = Color3.fromRGB(219, 222, 225)
local color3_2 = Color3.fromRGB(242, 243, 245)
local color3_3 = Color3.fromRGB(148, 155, 164)
local color3_4 = Color3.fromRGB(78, 80, 88)
local color3_5 = Color3.fromRGB(43, 45, 49)
local color3_6 = Color3.fromRGB(30, 31, 34)
local t2 = {
	"•",
	"◦",
	"▪"
}
local v10 = utf8.char(8201)
local t3 = {
	[8987] = true,
	[9203] = true,
	[9749] = true,
	[9889] = true,
	[9917] = true,
	[9940] = true,
	[9989] = true,
	[10024] = true,
	[10060] = true,
	[10067] = true,
	[10071] = true,
	[11088] = true
}
local t4 = {
	t = "LT",
	T = "LTS",
	d = "L",
	D = "LL",
	f = "LL [at] LT",
	F = "dddd, LL [at] LT",
	s = "L, LT",
	S = "L, LTS"
}
local t5 = {
	f = "LLL",
	F = "LLLL"
}
local t6 = {
	["&"] = "&amp;",
	["<"] = "&lt;",
	[">"] = "&gt;",
	["\""] = "&quot;"
}

local function __escape(s1: string) -- line: 142
	-- upvalues: t6 (copy)
	return (string.gsub(s1, "[&<>\"]", t6))
end
local function __isSpace(s2: string, n1: number) -- line: 146
	local v49 = string.sub(s2, n1, n1)

	return v49 == "" or string.find(v49, "^%s") ~= nil
end
local function __isWordChar(s3: string, n2: number) -- line: 151
	return string.find(string.sub(s3, n2, n2), "^[%w_]") ~= nil
end
local function __block(s4: string, s5: string?) -- line: 155
	return {
		Level = 0,
		Depth = 0,
		Marker = "",
		Ordered = false,
		Kind = s4,
		Text = s5 or "",
		Blocks = {}
	}
end
local function __relative(n3: number, n4: number) -- line: 159
	local v56 = n3 - n4
	local v57 = math.abs(v56)
	local v58 = math.round(v57 / 60)
	local v59 = math.round(v57 / 3600)
	local v60 = math.round(v57 / 86400)
	local v61 = math.round(v57 / 86400 / 30.436875)
	local v62 = math.round(v57 / 86400 / 30.436875 / 12)
	local v63 = if not (math.round(v57) < 60) then if not (v58 < 60) then if not (v59 < 22) then if not (v60 < 26) then if not (v61 < 11) then if not (v62 <= 1) then `{ v62 } years` else "a year" else if not (v61 <= 1) then `{ v61 } months` else "a month" else if not (v60 <= 1) then `{ v60 } days` else "a day" else if not (v59 <= 1) then `{ v59 } hours` else "an hour" else if not (v58 <= 1) then `{ v58 } minutes` else "a minute" else if not (math.round(v57) <= 1) then `{ math.round(v57) } seconds` else "a few seconds"

	if v56 >= 0 then
		return `in { v63 }`
	end

	return `{ v63 } ago`
end
local function __timestamp(n5: number, s6: string, t7: {[any]: any}) -- line: 186
	-- upvalues: __relative (copy), t4 (copy), t5 (copy)
	if s6 == "R" then
		t7.HasRelative = true

		return (__relative(n5, t7.Now))
	end

	local u67 = t4[s6] or "LL [at] LT"

	if not string.find(string.lower(t7.Locale), "^en") then
		u67 = t5[s6] or u67
	end

	local ok, result = pcall(function() -- line: 197
		-- upvalues: n5 (copy), u67 (ref), t7 (copy)
		return DateTime.fromUnixTimestamp(n5):FormatLocalTime(u67, t7.Locale)
	end)

	return if not ok then tostring(n5) else result
end
local function __findCodeClose(s7: string, n6: number, n7: number) -- line: 204
	while true do
		local start, stop = string.find(s7, "`+", n6)

		if not start or not stop then
			break
		end

		if n7 == stop - start + 1 then
			return start
		end

		n6 = stop + 1
	end

	return nil
end
local function __findClose(s8: string, n8: number, s9: string, p1: ((...any) -> ...any), s10: string?, b1: boolean?) -- line: 222
	-- upvalues: __findCodeClose (copy)
	while n8 <= #s8 do
		local v81 = string.sub(s8, n8, n8)

		if v81 ~= "\\" then
			if v81 == "`" then
				local v82 = #string.match(s8, "^`+", n8)
				local v83 = __findCodeClose(s8, n8 + v82, v82)

				n8 = if not v83 then n8 + v82 else v83 + v82

				continue
			end

			if s10 and s10 == string.sub(s8, n8, n8 + #s10 - 1) then
				n8 += #s10

				continue
			end

			if s9 ~= string.sub(s8, n8, n8 + #s9 - 1) then
				n8 += 1

				continue
			end

			if p1(n8) then
				return n8
			end

			if b1 then
				return nil
			end

			n8 += 1

			continue
		end

		n8 += 2
	end

	return nil
end
local function __codeSpan(s11: string, t8: {[any]: any}) -- line: 257
	-- upvalues: v10 (copy), t6 (copy)
	if #s11 >= 2 and (string.sub(s11, 1, 1) == " " and string.sub(s11, -1) == " " and string.find(s11, "%S")) then
		s11 = string.sub(s11, 2, -2)
	end

	return `<font family="rbxasset://fonts/families/AccanthisADFStd.json"{ (if not t8.Plain then ` size="{ math.round(t8.Size * 0.85) }"` else "") }><mark color="#2B2D31" transparency="0">{ v10 }{ string.gsub(s11, "[&<>\"]", t6) }{ v10 }</mark></font>`
end
local function __link(s12: string) -- line: 265
	return `<font color="#00A8FC">{ s12 }</font>`
end
local function __isEmojiStart(t9: {[any]: any}, n9: number) -- line: 269
	-- upvalues: t3 (copy)
	local v89 = t9[n9]

	if v89 >= 126976 or t3[v89] then
		return true
	end

	if t9[n9 + 1] ~= 65039 then
		return false
	end

	local v90 = t9[n9 + 2] == 8419 and (v89 == 35 or (v89 == 42 or v89 >= 48 and v89 <= 57))

	return v89 >= 169 or v90
end
local function __plain(s13: string, t10: {[any]: any}) -- line: 282
	-- upvalues: t6 (copy), t3 (copy)
	if t10.Plain or (not string.find(s13, "[\128-\255]") or utf8.len(s13) == nil) then
		return (string.gsub(s13, "[&<>\"]", t6))
	end

	local t11 = {}
	local t12 = {}

	for v95, v96 in utf8.codes(s13) do
		table.insert(t12, v95)
		table.insert(t11, v96)
	end

	table.insert(t12, #s13 + 1)

	local t13 = {}
	local n10 = 1
	local n11 = 1

	while n11 <= #t11 do
		local v100 = t11[n11]
		local v101

		if v100 >= 126976 or t3[v100] then
			v101 = true
		elseif t11[n11 + 1] ~= 65039 then
			v101 = false
		else
			local v102 = t11[n11 + 2] == 8419 and (v100 == 35 or (v100 == 42 or v100 >= 48 and v100 <= 57))

			v101 = v100 >= 169 or v102
		end

		if not v101 then
			n11 += 1
		else
			local v103 = n11

			while t11[v103 + 1] do
				local v104 = t11[v103 + 1]

				if v104 ~= 65039 and v104 ~= 8419 and (not (v104 >= 917536) or not (v104 <= 917631)) then
					if v104 == 8205 and t11[v103 + 2] then
						v103 += 2

						continue
					end

					local v105 = v103 + 1
					local v106 = t11[v105]
					local v107

					if v106 >= 126976 or t3[v106] then
						v107 = true
					elseif t11[v105 + 1] ~= 65039 then
						v107 = false
					else
						local v108 = t11[v105 + 2] == 8419 and (v106 == 35 or (v106 == 42 or v106 >= 48 and v106 <= 57))

						v107 = v106 >= 169 or v108
					end

					if not v107 then
						break
					end

					v103 += 1

					continue
				end

				v103 += 1
			end

			t10.HasEmoji = true

			local v109 = string.sub(s13, n10, t12[n11] - 1)

			table.insert(t13, (string.gsub(v109, "[&<>\"]", t6)))

			local v110 = string.sub(s13, t12[n11], t12[v103 + 1] - 1)
			local v111 = string.gsub(v110, "[&<>\"]", t6)

			table.insert(t13, `<font size="{ math.round(t10.Size * 1.375) }">{ v111 }</font>`)
			n10 = t12[v103 + 1]
			n11 = v103 + 1
		end
	end

	local v112 = string.sub(s13, n10)

	table.insert(t13, (string.gsub(v112, "[&<>\"]", t6)))

	return table.concat(t13)
end
local function __inline(s14: string, t14: {[any]: any}) -- line: 329
	-- upvalues: __plain (copy), __inline (ref), t6 (copy), __findCodeClose (copy), __codeSpan (copy), __timestamp (copy), __findClose (copy)
	local t15 = {}
	local n12 = 1
	local n13 = 1

	local function emit(s15: string, n14: number) -- line: 334
		-- upvalues: n12 (ref), n13 (ref), t15 (copy), __plain (copy), s14 (copy), t14 (copy)
		if n12 > n13 then
			table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
		end

		table.insert(t15, s15)
		n12 = n14
		n13 = n14
	end
	local function span(n15: number, n16: number) -- line: 343
		-- upvalues: __inline (ref), s14 (copy), t14 (copy)
		return __inline(string.sub(s14, n15, n16 - 1), t14)
	end

	local g125 = nil
	local g147 = nil
	local g154 = nil

	while n12 <= #s14 do
		local v120 = string.sub(s14, n12, n12)
		local v121 = false

		if v120 == "\\" then
			local v122 = string.sub(s14, n12 + 1, n12 + 1)

			if string.find(v122, "^%p") then
				local v123 = string.gsub(v122, "[&<>\"]", t6)
				local v124 = n12 + 2

				if n13 < n12 then
					table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
				end

				table.insert(t15, v123)
				n12 = v124
				n13 = v124
				v121 = true
			end

			g125 = true
		end

		if not g125 then
			if v120 == "`" then
				local v126 = #string.match(s14, "^`+", n12)
				local v127 = __findCodeClose(s14, n12 + v126, v126)

				if v127 then
					local v128 = __codeSpan(string.sub(s14, n12 + v126, v127 - 1), t14)
					local v129 = v127 + v126

					if n13 < n12 then
						table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
					end

					table.insert(t15, v128)
					n12 = v129
					n13 = v129
				else
					n12 += v126
				end

				v121 = true
				g125 = true
			end

			if not g125 then
				if v120 == "<" then
					local v130, v131, v132 = string.match(s14, "^<t:(%-?%d+):([tTdDfFsSR])>()", n12)

					if not v130 then
						v130, v132 = string.match(s14, "^<t:(%-?%d+)>()", n12)
						v131 = "f"
					end

					if v130 and v131 and v132 then
						local v133 = __timestamp(tonumber(v130), v131, t14)
						local v134 = `<b>{ string.gsub(v133, "[&<>\"]", t6) }</b>`

						if n13 < n12 then
							table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
						end

						table.insert(t15, v134)
						n12 = v132
						n13 = v132
						v121 = true
						g125 = true
					end

					if not g125 then
						local v135, v136 = string.match(s14, "^<(https?://[^%s>]+)>()", n12)
						local v137, v138 = string.match(s14, "^<a?:([%w_~]+):%d+>()", n12)
						local v139, v140 = string.match(s14, "^</([^:>]+):%d+>()", n12)
						local v141 = string.match(s14, "^<@[!&]?%d+>()", n12) or (string.match(s14, "^<#%d+>()", n12) or string.match(s14, "^<id:[%w%-:]+>()", n12))

						if v135 and v136 then
							local v142 = `<font color="#00A8FC">{ string.gsub(v135, "[&<>\"]", t6) }</font>`

							if n13 < n12 then
								table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
							end

							table.insert(t15, v142)
							n12 = v136
							n13 = v136
							v121 = true
							g125 = true
						end

						if not g125 then
							if v137 and v138 then
								local v143 = `:{ v137 }:`
								local v144 = string.gsub(v143, "[&<>\"]", t6)

								if n13 < n12 then
									table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
								end

								table.insert(t15, v144)
								n12 = v138
								n13 = v138
								v121 = true
								g125 = true
							end

							if not g125 then
								if v139 and v140 then
									local v145 = `/{ v139 }`
									local v146 = `<font color="#00A8FC">{ string.gsub(v145, "[&<>\"]", t6) }</font>`

									if n13 < n12 then
										table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
									end

									table.insert(t15, v146)
									n12 = v140
									n13 = v140
									v121 = true
									g125 = true
								end

								if not g125 then
									if not v141 then
										g125 = true
									end

									if not g125 then
										if string.sub(s14, v141, v141) == " " then
											repeat
												if not g147 and n12 ~= 1 then
													local v148 = n12 - 1
													local v149 = string.sub(s14, v148, v148)

													if v149 == "" or string.find(v149, "^%s") ~= nil then
														g147 = true
													end
												else
													g147 = false
													v141 += 1
												end
											until not g147
										end

										if n13 < n12 then
											table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
										end

										table.insert(t15, "")
										n12 = v141
										n13 = v141
										v121 = true
										g125 = true
									end
								end
							end
						end
					end
				end

				if not g125 then
					if not g125 then
						if not g125 then
							if not g125 then
								if not g125 then
									if not g125 then
										if v120 == "[" then
											local v150, v151, v152 = string.match(s14, "^%[([^%]]+)%]%(<?(https?://[^%s%)>]+)>?%)()", n12)

											if v150 and v151 and v152 then
												local v153 = `<font color="#00A8FC">{ __inline(v150, t14) }</font>`

												if n13 < n12 then
													table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
												end

												table.insert(t15, v153)
												n12 = v152
												n13 = v152
												v121 = true
											end

											g125 = true
										end

										if not g125 then
											repeat
												if not g154 and (v120 == "h" or v120 == "H") then
													local v155 = n12 - 1

													if string.find(string.sub(s14, v155, v155), "^[%w_]") ~= nil then
														g154 = true
													end

													if not g154 then
														local match = string.match(s14, "^[hH][tT][tT][pP][sS]?://[^%s<]+", n12)

														if match then
															local v157 = string.gsub(match, "[%.,:;!%?'\"]+$", "")

															if string.sub(v157, -1) == ")" and not string.find(v157, "%(") then
																v157 = string.sub(v157, 1, -2)
															end

															local v158 = `<font color="#00A8FC">{ string.gsub(v157, "[&<>\"]", t6) }</font>`
															local v159 = n12 + #v157

															if n13 < n12 then
																table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
															end

															table.insert(t15, v158)
															n12 = v159
															n13 = v159
															v121 = true
														end
													end
												else
													g154 = false

													if v120 == "*" then
														local v160 = #string.match(s14, "^%*+", n12)

														if v160 >= 3 then
															local v161 = __findClose(s14, n12 + 3, "***", function(p2) -- line: 421
																-- upvalues: s14 (copy)
																local v368 = s14
																local v369 = p2 - 1
																local v370 = string.sub(v368, v369, v369)

																return not (v370 == "" or string.find(v370, "^%s") ~= nil)
															end)

															if v161 and v161 > n12 + 3 then
																local v162 = n12 + 3
																local v163 = `<b><i>{ __inline(string.sub(s14, v162, v161 - 1), t14) }</i></b>`
																local v164 = v161 + 3

																if n13 < n12 then
																	table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
																end

																table.insert(t15, v163)
																n12 = v164
																n13 = v164
																v121 = true
															end
														end

														if not v121 and v160 >= 2 then
															local v165 = __findClose(s14, n12 + 2, "**", function(p3) -- line: 430
																-- upvalues: s14 (copy)
																return string.sub(s14, p3 + 2, p3 + 2) ~= "*"
															end)

															if v165 and v165 > n12 + 2 then
																local v166 = n12 + 2
																local v167 = `<b>{ __inline(string.sub(s14, v166, v165 - 1), t14) }</b>`
																local v168 = v165 + 2

																if n13 < n12 then
																	table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
																end

																table.insert(t15, v167)
																n12 = v168
																n13 = v168
																v121 = true
															end
														end

														if not v121 and v160 == 1 then
															local v169 = n12 + 1
															local v170 = string.sub(s14, v169, v169)

															if v170 ~= "" and string.find(v170, "^%s") == nil then
																local v171 = __findClose(s14, n12 + 1, "*", function(p4) -- line: 439
																	-- upvalues: s14 (copy)
																	local v373 = s14
																	local v374 = p4 - 1
																	local v375 = string.sub(v373, v374, v374)

																	return not (v375 == "" or string.find(v375, "^%s") ~= nil) and string.sub(s14, p4 + 1, p4 + 1) ~= "*"
																end, "**")

																if v171 and v171 > n12 + 1 then
																	local v172 = n12 + 1
																	local v173 = `<i>{ __inline(string.sub(s14, v172, v171 - 1), t14) }</i>`
																	local v174 = v171 + 1

																	if n13 < n12 then
																		table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
																	end

																	table.insert(t15, v173)
																	n12 = v174
																	n13 = v174
																	v121 = true
																end
															end
														end

														if not v121 then
															n12 += v160
															v121 = true
														end
													elseif v120 == "_" then
														local v175 = #string.match(s14, "^_+", n12)

														if v175 >= 3 then
															local v176 = __findClose(s14, n12 + 3, "___", function(p5) -- line: 454
																-- upvalues: s14 (copy)
																return string.sub(s14, p5 + 3, p5 + 3) ~= "_"
															end)

															if v176 and v176 > n12 + 3 then
																local v177 = n12 + 3
																local v178 = `<u><i>{ __inline(string.sub(s14, v177, v176 - 1), t14) }</i></u>`
																local v179 = v176 + 3

																if n13 < n12 then
																	table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
																end

																table.insert(t15, v178)
																n12 = v179
																n13 = v179
																v121 = true
															end
														end

														if not v121 and v175 >= 2 then
															local v180 = __findClose(s14, n12 + 2, "__", function(p6) -- line: 463
																-- upvalues: s14 (copy)
																return string.sub(s14, p6 + 2, p6 + 2) ~= "_"
															end)

															if v180 and v180 > n12 + 2 then
																local v181 = n12 + 2
																local v182 = `<u>{ __inline(string.sub(s14, v181, v180 - 1), t14) }</u>`
																local v183 = v180 + 2

																if n13 < n12 then
																	table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
																end

																table.insert(t15, v182)
																n12 = v183
																n13 = v183
																v121 = true
															end
														end

														if not v121 and v175 == 1 then
															local v184 = n12 - 1

															if string.find(string.sub(s14, v184, v184), "^[%w_]") == nil then
																local v185 = n12 + 1
																local v186 = string.sub(s14, v185, v185)

																if v186 ~= "" and string.find(v186, "^%s") == nil then
																	local v187 = __findClose(s14, n12 + 1, "_", function(p7) -- line: 472
																		-- upvalues: s14 (copy)
																		local v379 = s14
																		local v380 = p7 + 1

																		return string.find(string.sub(v379, v380, v380), "^[%w_]") == nil
																	end, "__", true)

																	if v187 and v187 > n12 + 1 then
																		local v188 = n12 + 1
																		local v189 = `<i>{ __inline(string.sub(s14, v188, v187 - 1), t14) }</i>`
																		local v190 = v187 + 1

																		if n13 < n12 then
																			table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
																		end

																		table.insert(t15, v189)
																		n12 = v190
																		n13 = v190
																		v121 = true
																	end
																end
															end
														end

														if not v121 then
															n12 += v175
															v121 = true
														end
													elseif v120 == "~" and string.sub(s14, n12, n12 + 1) == "~~" then
														local v191 = __findClose(s14, n12 + 2, "~~", function() -- line: 485
															return true
														end)

														if v191 and v191 > n12 + 2 then
															local v192 = n12 + 2
															local v193 = `<s>{ __inline(string.sub(s14, v192, v191 - 1), t14) }</s>`
															local v194 = v191 + 2

															if n13 < n12 then
																table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
															end

															table.insert(t15, v193)
															n12 = v194
															n13 = v194
															v121 = true
														end
													elseif v120 == "|" and string.sub(s14, n12, n12 + 1) == "||" then
														local v195 = __findClose(s14, n12 + 2, "||", function() -- line: 493
															return true
														end)

														if v195 and v195 > n12 + 2 then
															t14.HasSpoiler = true

															local v196 = n12 + 2
															local v197 = __inline(string.sub(s14, v196, v195 - 1), t14)
															local v198 = if not t14.Reveal then `<mark color="#1E1F22" transparency="0"><font transparency="1">{ v197 }</font></mark>` else `<mark color="#FFFFFF" transparency="0.9">{ v197 }</mark>`
															local v199 = v195 + 2

															if n13 < n12 then
																table.insert(t15, __plain(string.sub(s14, n13, n12 - 1), t14))
															end

															table.insert(t15, v198)
															n12 = v199
															n13 = v199
															v121 = true
														end
													end
												end
											until not g154
										end
									end
								end
							end
						end
					end
				end
			end
		end

		g125 = false

		if not v121 then
			n12 += 1
		end
	end

	if n13 <= #s14 then
		table.insert(t15, __plain(string.sub(s14, n13), t14))
	end

	return table.concat(t15)
end
local function __normalize(s16: string) -- line: 520
	local v201 = string.gsub(s16, "\r\n?", "\n")
	local v202 = string.gsub(v201, "\t", "    ")
	local parts = string.split(v202, "\n")
	local n17 = 1e999

	for _, v206 in parts do
		if string.find(v206, "%S") then
			n17 = math.min(n17, #string.match(v206, "^ *"))
		end
	end

	if n17 > 0 and n17 < 1e999 then
		for v207, v208 in parts do
			parts[v207] = string.sub(v208, n17 + 1)
		end
	end

	local v209 = table.concat(parts, "\n")
	local v210 = string.gsub(v209, "^%s*\n", "")

	return (string.gsub(v210, "\n%s*$", ""))
end
local function __quoteLine(s17: string, b2: boolean) -- line: 543
	if b2 then
		local match = string.match(s17, "^ *>>> (.*)$")

		if not match then
			if string.match(s17, "^ *>>>%s*$") then
				return ""
			end

			match = nil
		end

		return match
	end

	if string.find(s17, "^ *>>>") then
		return nil
	end

	local match = string.match(s17, "^ *> (.*)$")

	if not match then
		if string.match(s17, "^ *>%s*$") then
			return ""
		end

		match = nil
	end

	return match
end
local function __parseBlocks(s18: string, b3: boolean) -- line: 555
	-- upvalues: __block (copy), __parseBlocks (ref), t2 (copy)
	local parts = string.split(s18, "\n")
	local t16 = {}
	local t17 = {}
	local t18 = {}
	local t19 = {}
	local n18 = 1

	local function endList() -- line: 563
		-- upvalues: t17 (copy), t18 (copy), t19 (copy)
		table.clear(t17)
		table.clear(t18)
		table.clear(t19)
	end

	while n18 <= #parts do
		local v224 = parts[n18]

		n18 += 1

		local match = string.match(v224, "^%s*```(.*)$")

		if match then
			local match2 = string.match(match, "^(.-)```%s*$")

			if match2 and match2 ~= "" then
				table.clear(t17)
				table.clear(t18)
				table.clear(t19)
				table.insert(t16, (__block("Code", match2)))

				continue
			end

			local t20 = {}

			if match ~= "" and not string.match(match, "^[%w_%+%-%.#]+%s*$") then
				table.insert(t20, match)
			end

			local v228 = nil

			for i = n18, #parts do
				local match3 = string.match(parts[i], "^(.-)```")

				if match3 then
					if match3 ~= "" then
						table.insert(t20, match3)
					end

					v228 = i

					break
				end

				table.insert(t20, parts[i])
			end

			if v228 then
				table.clear(t17)
				table.clear(t18)
				table.clear(t19)
				n18 = v228 + 1
				table.insert(t16, (__block("Code", table.concat(t20, "\n"))))

				continue
			end
		end

		if not string.find(v224, "%S") then
			table.insert(t16, {
				Kind = "Blank",
				Text = "",
				Level = 0,
				Depth = 0,
				Marker = "",
				Ordered = false,
				Blocks = {}
			})

			continue
		end

		if b3 then
			local v231 = string.match(v224, "^ *>>> (.*)$") or if not string.match(v224, "^ *>>>%s*$") then nil else ""

			if v231 then
				table.clear(t17)
				table.clear(t18)
				table.clear(t19)

				local t21 = { v231 }

				for i = n18, #parts do
					table.insert(t21, parts[i])
				end

				n18 = #parts + 1
				table.insert(t16, {
					Kind = "Quote",
					Text = "",
					Level = 0,
					Depth = 0,
					Marker = "",
					Ordered = false,
					Blocks = {},
					Blocks = __parseBlocks(table.concat(t21, "\n"), false)
				})

				continue
			end

			local v234 = if not string.find(v224, "^ *>>>") then string.match(v224, "^ *> (.*)$") or if not string.match(v224, "^ *>%s*$") then nil else "" else nil

			if v234 then
				table.clear(t17)
				table.clear(t18)
				table.clear(t19)

				local t22 = { v234 }

				while n18 <= #parts do
					local v236 = parts[n18]
					local v237 = if not string.find(v236, "^ *>>>") then string.match(v236, "^ *> (.*)$") or if not string.match(v236, "^ *>%s*$") then nil else "" else nil

					if not v237 then
						break
					end

					table.insert(t22, v237)
					n18 += 1
				end

				table.insert(t16, {
					Kind = "Quote",
					Text = "",
					Level = 0,
					Depth = 0,
					Marker = "",
					Ordered = false,
					Blocks = {},
					Blocks = __parseBlocks(table.concat(t22, "\n"), false)
				})

				continue
			end
		end

		local v238, v239 = string.match(v224, "^(#+) +(.-)%s*$")

		if v238 and v239 and #v238 <= 3 and v239 ~= "" then
			table.clear(t17)
			table.clear(t18)
			table.clear(t19)
			table.insert(t16, {
				Kind = "Heading",
				Level = 0,
				Depth = 0,
				Marker = "",
				Ordered = false,
				Text = v239 or "",
				Blocks = {},
				Level = #v238
			})
		else
			local match4 = string.match(v224, "^%-# +(.-)%s*$")

			if match4 and match4 ~= "" then
				table.clear(t17)
				table.clear(t18)
				table.clear(t19)
				table.insert(t16, {
					Kind = "Subtext",
					Level = 0,
					Depth = 0,
					Marker = "",
					Ordered = false,
					Text = match4 or "",
					Blocks = {}
				})
			else
				local v241, v242 = string.match(v224, "^(%s*)[%-%*] +(.*)$")
				local v243 = nil

				if not v241 then
					local v244

					v241, v244, v242 = string.match(v224, "^(%s*)(%d+)%. +(.*)$")
					v243 = if not v244 then nil else tonumber(v244)
				end

				if v241 and v242 and string.find(v242, "%S") then
					local v245 = #v241

					while #t17 > 0 and v245 < t17[#t17] do
						table.remove(t17)
						table.remove(t18)
						table.remove(t19)
					end

					if #t17 == 0 or v245 > t17[#t17] then
						table.insert(t17, v245)
						table.insert(t18, v243 or 0)
						table.insert(t19, v243 ~= nil)
					elseif t19[#t19] ~= (v243 ~= nil) then
						t18[#t18] = v243 or 0
						t19[#t19] = v243 ~= nil
					end

					local v246 = #t17
					local t23 = {
						Kind = "ListItem",
						Level = 0,
						Depth = 0,
						Marker = "",
						Ordered = false,
						Text = v242 or "",
						Blocks = {},
						Depth = v246,
						Ordered = t19[v246]
					}

					if t23.Ordered then
						t23.Marker = `{ t18[v246] }.`
						t18[v246] = t18[v246] + 1
					else
						t23.Marker = t2[math.min(v246, #t2)]
					end

					table.insert(t16, t23)
				else
					local v248 = t16[#t16]

					if v248 and v248.Kind == "ListItem" and string.find(v224, "^%s+%S") then
						v248.Text = v248.Text .. "\n" .. string.match(v224, "^%s*(.-)$")
					else
						table.clear(t17)
						table.clear(t18)
						table.clear(t19)

						if v248 and v248.Kind == "Paragraph" then
							v248.Text = v248.Text .. "\n" .. v224
						else
							table.insert(t16, {
								Kind = "Paragraph",
								Level = 0,
								Depth = 0,
								Marker = "",
								Ordered = false,
								Text = v224 or "",
								Blocks = {}
							})
						end
					end
				end
			end
		end
	end

	return t16
end
local function __locale() -- line: 716
	-- upvalues: LocalizationService (copy)
	local ok, result = pcall(function() -- line: 717
		-- upvalues: LocalizationService (copy)
		return LocalizationService.RobloxLocaleId
	end)

	if ok and type(result) == "string" and result ~= "" then
		return result
	end

	return "en-us"
end
local function __defaultBanner() -- line: 724
	local v251 = if not script.Parent then nil else script.Parent:FindFirstChild("Presets")
	local v252 = if not v251 then nil else v251:FindFirstChild("Components")
	local v253 = if not v252 then nil else v252:FindFirstChild("SubheaderTemplate")

	if v253 and v253:IsA("GuiObject") then
		return v253
	end

	return nil
end
local function __state(t24: {[any]: any}, n19: number, b4: boolean, b5: boolean?) -- line: 732
	return {
		HasSpoiler = false,
		HasRelative = false,
		HasEmoji = false,
		Now = DateTime.now().UnixTimestamp,
		Locale = t24.Locale,
		Size = n19,
		Reveal = b4,
		Plain = b5 == true
	}
end
local function __frame(s19: string) -- line: 745
	local Frame = Instance.new("Frame")

	Frame.Name = s19
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.fromScale(1, 0)
	Frame.AutomaticSize = Enum.AutomaticSize.Y

	return Frame
end
local function __listLayout(p8) -- line: 755
	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.Parent = p8

	return UIListLayout
end
local function __padding(p9, n20: number, n21: number, n22: number?, n23: number?) -- line: 763
	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingTop = UDim.new(0, n20)
	UIPadding.PaddingBottom = UDim.new(0, n21)
	UIPadding.PaddingLeft = UDim.new(0, n22 or 0)
	UIPadding.PaddingRight = UDim.new(0, n23 or 0)
	UIPadding.Parent = p9
end
local function __text(t25: {[any]: any}, s20: string, n24: number, p10, color3_7: Color3) -- line: 776
	-- upvalues: __inline (ref), __padding (copy)
	local t26 = {
		Reveal = false,
		Plain = false,
		HasSpoiler = false,
		HasRelative = false,
		HasEmoji = false,
		Now = DateTime.now().UnixTimestamp,
		Locale = t25.Locale,
		Size = n24
	}
	local v274 = __inline(s20, t26)
	local v275 = if not t26.HasSpoiler then Instance.new("TextLabel") else Instance.new("TextButton")

	v275.Name = "Text"
	v275.BackgroundTransparency = 1
	v275.BorderSizePixel = 0
	v275.Size = UDim2.fromScale(1, 0)
	v275.AutomaticSize = Enum.AutomaticSize.Y
	v275.FontFace = Font.new("rbxasset://fonts/families/AccanthisADFStd.json", p10)
	v275.TextSize = n24
	v275.TextColor3 = color3_7
	v275.LineHeight = 1.375
	v275.RichText = true
	v275.TextWrapped = true
	v275.TextXAlignment = Enum.TextXAlignment.Left
	v275.TextYAlignment = Enum.TextYAlignment.Top
	v275.Text = v274

	local v276 = if not t26.HasEmoji then math.round(n24 * 0.375 / 2) else 0

	__padding(v275, v276, v276)

	if t26.HasSpoiler or t26.HasRelative then
		local t27 = {
			Revealed = false,
			Plain = false,
			Label = v275,
			Source = s20,
			Size = n24
		}

		if t26.HasRelative then
			table.insert(t25.Live, t27)
		end

		if t26.HasSpoiler then
			v275.AutoButtonColor = false
			v275.Activated:Connect(function() -- line: 808
				-- upvalues: t27 (copy), v275 (copy), __inline (ref), s20 (copy), t25 (copy), n24 (copy)
				t27.Revealed = true

				local v381 = v275
				local v382 = __inline
				local v383 = s20
				local v384 = t25
				local v385 = n24

				v381.Text = v382(v383, {
					Reveal = true,
					Plain = false,
					HasSpoiler = false,
					HasRelative = false,
					HasEmoji = false,
					Now = DateTime.now().UnixTimestamp,
					Locale = v384.Locale,
					Size = v385
				})
			end)
		end
	end

	return v275
end
local function __marker(t28: {[any]: any}) -- line: 818
	-- upvalues: color3 (copy), __padding (copy)
	local v279 = t28.Depth * 16

	if t28.Ordered then
		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = "Marker"
		TextLabel.BackgroundTransparency = 1
		TextLabel.FontFace = Font.new("rbxasset://fonts/families/AccanthisADFStd.json", Enum.FontWeight.Regular)
		TextLabel.TextSize = 16
		TextLabel.TextColor3 = color3
		TextLabel.Text = t28.Marker
		TextLabel.TextXAlignment = Enum.TextXAlignment.Right
		TextLabel.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel.AutomaticSize = Enum.AutomaticSize.Y
		TextLabel.Size = UDim2.fromOffset(40, 0)
		TextLabel.Position = UDim2.fromOffset(v279 - 4 - 40, 0)
		__padding(TextLabel, 3, 3)

		return TextLabel
	end

	local Frame = Instance.new("Frame")

	Frame.Name = "Marker"
	Frame.BorderSizePixel = 0
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.Position = UDim2.fromOffset(v279 - 11, 11)
	Frame.Size = UDim2.fromOffset(5, 5)
	Frame.BackgroundColor3 = color3

	if t28.Depth <= 2 then
		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0.5, 0)
		UICorner.Parent = Frame
	end

	if t28.Depth == 2 then
		Frame.BackgroundTransparency = 1
		Frame.Size = UDim2.fromOffset(3, 3)

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = color3
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame
	end

	return Frame
end
local function __spacer(p11, n25: number, n26: number) -- line: 863
	local Frame = Instance.new("Frame")

	Frame.Name = "Spacer"
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 0, n25)
	Frame.LayoutOrder = n26
	Frame.Parent = p11
end
local function __margins(t29: {[any]: any}, t30: {[any]: any}?, b6: boolean) -- line: 873
	if b6 then
		return 8, 0
	end

	if t29.Kind == "Heading" then
		return 16, 8
	end

	if t29.Kind == "ListItem" then
		return (not t30 or t30.Kind ~= "ListItem") and 4 or 0, 4
	end

	if t29.Kind == "Code" then
		return 6, 0
	end

	return 0, 0
end
local function __banner(t31: {[any]: any}, t32: {[any]: any}) -- line: 891
	-- upvalues: t1 (copy), __inline (ref)
	local Banner = t31.Banner

	if not Banner then
		return nil
	end

	local clone = Banner:Clone()
	local Header = clone:FindFirstChild("Header")

	if not Header or not Header:IsA("TextLabel") then
		clone:Destroy()

		return nil
	end

	local v296 = t1[math.clamp(t32.Level, 1, #t1)]
	local t33 = {
		Reveal = true,
		Plain = true,
		HasSpoiler = false,
		HasRelative = false,
		HasEmoji = false,
		Now = DateTime.now().UnixTimestamp,
		Locale = t31.Locale,
		Size = v296
	}

	Header.RichText = true
	Header.Text = __inline(t32.Text, t33)

	if t33.HasRelative then
		table.insert(t31.Live, {
			Revealed = true,
			Plain = true,
			Label = Header,
			Source = t32.Text,
			Size = t33.Size
		})
	end

	local UIAspectRatioConstraint = clone:FindFirstChildOfClass("UIAspectRatioConstraint")

	if UIAspectRatioConstraint and t32.Level == 1 then
		UIAspectRatioConstraint.AspectRatio = UIAspectRatioConstraint.AspectRatio / 1.2
	end

	clone.Name = `Heading{ t32.Level }`

	return clone
end

local __renderBlocks = nil

local function __renderBlock(t34: {[any]: any}, t35: {[any]: any}) -- line: 923
	-- upvalues: t1 (copy), __text (copy), color3_2 (copy), color3_3 (copy), color3 (copy), __marker (copy), color3_4 (copy), __renderBlocks (ref), color3_5 (copy), color3_6 (copy), __padding (copy)
	if t35.Kind == "Heading" then
		local v301 = t1[math.clamp(t35.Level, 1, #t1)]
		local v302 = __text(t34, t35.Text, v301, Enum.FontWeight.Bold, color3_2)

		v302.Name = `Heading{ t35.Level }`

		return v302
	end

	if t35.Kind == "Subtext" then
		local v303 = __text(t34, t35.Text, 13, Enum.FontWeight.Regular, color3_3)

		v303.Name = "Subtext"

		return v303
	end

	if t35.Kind == "ListItem" then
		local Frame = Instance.new("Frame")

		Frame.Name = "ListItem"
		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.fromScale(1, 0)
		Frame.AutomaticSize = Enum.AutomaticSize.Y

		local v305 = t35.Depth * 16
		local v306 = __text(t34, t35.Text, 16, Enum.FontWeight.Regular, color3)

		v306.Position = UDim2.fromOffset(v305, 0)
		v306.Size = UDim2.new(1, -v305, 0, 0)
		v306.Parent = Frame
		__marker(t35).Parent = Frame

		return Frame
	end

	if t35.Kind == "Quote" then
		local Frame = Instance.new("Frame")

		Frame.Name = "Quote"
		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.fromScale(1, 0)
		Frame.AutomaticSize = Enum.AutomaticSize.Y

		local Frame2 = Instance.new("Frame")

		Frame2.Name = "Bar"
		Frame2.BorderSizePixel = 0
		Frame2.BackgroundColor3 = color3_4
		Frame2.Size = UDim2.new(0, 4, 1, 0)

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = Frame2
		Frame2.Parent = Frame

		local Frame3 = Instance.new("Frame")

		Frame3.Name = "Body"
		Frame3.BackgroundTransparency = 1
		Frame3.BorderSizePixel = 0
		Frame3.Size = UDim2.fromScale(1, 0)
		Frame3.AutomaticSize = Enum.AutomaticSize.Y
		Frame3.Position = UDim2.fromOffset(16, 0)
		Frame3.Size = UDim2.new(1, -16, 0, 0)

		local UIListLayout = Instance.new("UIListLayout")

		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.FillDirection = Enum.FillDirection.Vertical
		UIListLayout.Parent = Frame3
		__renderBlocks(t34, Frame3, t35.Blocks)
		Frame3.Parent = Frame

		return Frame
	end

	if t35.Kind == "Code" then
		local Frame = Instance.new("Frame")

		Frame.Name = "CodeBlock"
		Frame.BackgroundTransparency = 1
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.fromScale(1, 0)
		Frame.AutomaticSize = Enum.AutomaticSize.Y
		Frame.BackgroundTransparency = 0
		Frame.BackgroundColor3 = color3_5

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = color3_6
		UIStroke.Thickness = 1
		UIStroke.Parent = Frame
		__padding(Frame, 7, 7, 7, 7)

		local TextLabel = Instance.new("TextLabel")

		TextLabel.Name = "Code"
		TextLabel.BackgroundTransparency = 1
		TextLabel.Size = UDim2.fromScale(1, 0)
		TextLabel.AutomaticSize = Enum.AutomaticSize.Y
		TextLabel.FontFace = Font.new("rbxasset://fonts/families/AccanthisADFStd.json", Enum.FontWeight.Regular)
		TextLabel.TextSize = 14
		TextLabel.LineHeight = 1.2857142857142858
		TextLabel.TextColor3 = color3
		TextLabel.RichText = false
		TextLabel.TextWrapped = true
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel.Text = t35.Text
		__padding(TextLabel, 2, 2)
		TextLabel.Parent = Frame

		return Frame
	end

	local v316 = __text(t34, t35.Text, 16, Enum.FontWeight.Regular, color3)

	v316.Name = "Paragraph"

	return v316
end

function __renderBlocks(t36: {[any]: any}, p12, t37: {[any]: any}, n27: number?) -- line: 1007
	-- upvalues: __banner (copy), __renderBlock (copy)
	local n28 = 0
	local v322 = nil
	local n29 = 0
	local v324 = false
	local n30 = 0

	for v326, v327 in t37 do
		if v327.Kind == "Blank" then
			local v328 = nil

			for i = v326 - 1, 1, -1 do
				if t37[i].Kind ~= "Blank" then
					v328 = t37[i]

					break
				end
			end

			local v330 = nil

			for i = v326 + 1, #t37 do
				if t37[i].Kind ~= "Blank" then
					v330 = t37[i]

					break
				end
			end

			if v328 and v330 and v328.Kind ~= "Heading" and v330.Kind ~= "Heading" then
				n30 += 22
			end
		else
			local v332 = if not n27 or (v327.Kind ~= "Heading" or not (v327.Level <= 2)) then nil else __banner(t36, v327)
			local n31, n32

			if v332 ~= nil then
				n31 = 8
				n32 = 0
			elseif v327.Kind == "Heading" then
				n31 = 16
				n32 = 8
			elseif v327.Kind == "ListItem" then
				n31 = (not v322 or v322.Kind ~= "ListItem") and 4 or 0
				n32 = 4
			elseif v327.Kind == "Code" then
				n31 = 6
				n32 = 0
			else
				n31 = 0
				n32 = 0
			end

			local v335 = if not v324 then math.max(n29, n31) else n29
			local v336 = not v322 and 0 or v335 + n30

			if v336 > 0 then
				n28 += 1

				local Frame = Instance.new("Frame")

				Frame.Name = "Spacer"
				Frame.BackgroundTransparency = 1
				Frame.BorderSizePixel = 0
				Frame.Size = UDim2.new(1, 0, 0, v336)
				Frame.LayoutOrder = n28
				Frame.Parent = p12
			end

			local v338 = v332 or __renderBlock(t36, v327)

			if n27 and not v332 then
				v338.Size = UDim2.new(n27, 0, v338.Size.Y.Scale, v338.Size.Y.Offset)
			end

			n28 += 1
			v338.LayoutOrder = n28
			v338.Parent = p12
			v322 = v327
			n29 = n32
			v324 = v332 ~= nil
			n30 = 0
		end
	end
end

local function __keepLive(p13, t38: {[any]: any}) -- line: 1061
	-- upvalues: __inline (ref)
	task.spawn(function() -- line: 1062
		-- upvalues: p13 (copy), t38 (copy), __inline (ref)
		while true do
			task.wait(1)

			if not p13.Parent then
				break
			end

			for _, v387 in t38.Live do
				local v388 = __inline
				local Source = v387.Source
				local v390 = t38
				local Size = v387.Size
				local Revealed = v387.Revealed
				local Plain = v387.Plain
				local v394 = v388(Source, {
					HasSpoiler = false,
					HasRelative = false,
					HasEmoji = false,
					Now = DateTime.now().UnixTimestamp,
					Locale = v390.Locale,
					Size = Size,
					Reveal = Revealed,
					Plain = Plain == true
				})

				if v394 ~= v387.Label.Text then
					v387.Label.Text = v394
				end
			end
		end
	end)
end

local t40 = {
	Parse = function(s21: string) -- line: 1084
		-- upvalues: __parseBlocks (ref), __normalize (copy)
		return __parseBlocks(__normalize(s21), true)
	end,
	ToRichText = function(s22: string, n33: number?) -- line: 1091
		-- upvalues: __inline (ref), LocalizationService (copy)
		local v344 = __inline
		local t39 = {}
		local ok, result = pcall(function() -- line: 717
			-- upvalues: LocalizationService (copy)
			return LocalizationService.RobloxLocaleId
		end)

		t39.Locale = (not ok or (type(result) ~= "string" or result == "")) and "en-us" or result
		t39.Live = {}

		local v348 = n33 or 16

		return v344(s22, {
			Reveal = false,
			Plain = false,
			HasSpoiler = false,
			HasRelative = false,
			HasEmoji = false,
			Now = DateTime.now().UnixTimestamp,
			Locale = t39.Locale,
			Size = v348
		})
	end
}

function t40.Render(s23: string, p14, t41: {[any]: any}?) -- line: 1099
	-- upvalues: LocalizationService (copy), __defaultBanner (copy), __padding (copy), __renderBlocks (ref), t40 (copy), __inline (ref)
	local t42 = {}
	local ok, result = pcall(function() -- line: 717
		-- upvalues: LocalizationService (copy)
		return LocalizationService.RobloxLocaleId
	end)

	t42.Locale = (not ok or (type(result) ~= "string" or result == "")) and "en-us" or result
	t42.Live = {}
	t42.Banner = if not t41 or not t41.HeadingTemplate then __defaultBanner() else t41.HeadingTemplate

	local Frame = Instance.new("Frame")

	Frame.Name = "MarkdownPage"
	Frame.BackgroundTransparency = 1
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.fromScale(1, 0)
	Frame.AutomaticSize = Enum.AutomaticSize.Y
	Frame.Size = UDim2.fromOffset(560, 0)
	Frame.LayoutOrder = (not t41 or not t41.LayoutOrder) and 0 or t41.LayoutOrder

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.Parent = Frame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	__padding(Frame, 18, 36)

	local UIScale = Instance.new("UIScale")

	UIScale.Parent = Frame
	__renderBlocks(t42, Frame, t40.Parse(s23), 0.8)

	local v358 = p14:IsA("ScrollingFrame")

	local function fit() -- line: 1118
		-- upvalues: v358 (copy), p14 (copy), UIScale (copy), Frame (copy)
		local v395 = if not v358 then p14.AbsoluteSize.X else p14.AbsoluteWindowSize.X

		if v395 > 0 then
			local v396 = math.max(v395 / 560, 0.75)

			UIScale.Scale = v396
			Frame.Size = UDim2.fromOffset(v395 / v396, 0)
		end
	end

	local v360 = if not v358 then p14.AbsoluteSize.X else p14.AbsoluteWindowSize.X

	if v360 > 0 then
		local v361 = math.max(v360 / 560, 0.75)

		UIScale.Scale = v361
		Frame.Size = UDim2.fromOffset(v360 / v361, 0)
	end

	local connection = p14:GetPropertyChangedSignal(not v358 and "AbsoluteSize" or "AbsoluteWindowSize"):Connect(fit)

	Frame.Destroying:Connect(function() -- line: 1129
		-- upvalues: connection (copy)
		connection:Disconnect()
	end)
	Frame.Parent = p14

	if #t42.Live > 0 then
		task.spawn(function() -- line: 1062
			-- upvalues: Frame (copy), t42 (copy), __inline (ref)
			while true do
				task.wait(1)

				if not Frame.Parent then
					break
				end

				for _, v398 in t42.Live do
					local v399 = __inline
					local Source = v398.Source
					local v401 = t42
					local Size = v398.Size
					local Revealed = v398.Revealed
					local Plain = v398.Plain
					local v405 = v399(Source, {
						HasSpoiler = false,
						HasRelative = false,
						HasEmoji = false,
						Now = DateTime.now().UnixTimestamp,
						Locale = v401.Locale,
						Size = Size,
						Reveal = Revealed,
						Plain = Plain == true
					})

					if v405 ~= v398.Label.Text then
						v398.Label.Text = v405
					end
				end
			end
		end)
	end

	return Frame
end

return t40
