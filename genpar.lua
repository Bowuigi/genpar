-- Genpar
-- A generic, multipurpose string parser
-- Registered under the zlib License
-- 
-- (C) 2021 Bowuigi
-- 
-- This software is provided 'as-is', without any express or implied
-- warranty.  In no event will the authors be held liable for any damages
-- arising from the use of this software.
-- 
-- Permission is granted to anyone to use this software for any purpose,
-- including commercial applications, and to alter it and redistribute it
-- freely, subject to the following restrictions:
-- 
-- 1. The origin of this software must not be misrepresented; you must not
--    claim that you wrote the original software. If you use this software
--    in a product, an acknowledgment in the product documentation would be
--    appreciated but is not required.
-- 2. Altered source versions must be plainly marked as such, and must not be
--    misrepresented as being the original software.
-- 3. This notice may not be removed or altered from any source distribution.

-- The genpar table containing the default values, all of the values on "parser" are modifiable
local genpar={
	parser={
		token="",
		used="result",
		canOutput=true,
		any_func=nil,
		default_func=nil,
		init_func=nil
	}
}

-- Find a token in a tokens table
function genpar.find(t,token)
	for k,v in ipairs(t) do
		if v[1]==token then
			return v
		end
	end

	return nil
end

function genpar.parse(str,tokens,result)
	local usedToken=false
	genpar.parser={
		token="",
		used="result",
		canOutput=true,
		any_func=nil,
		default_func=nil,
		init_func=nil
	}

	-- Get all the special functions
	for k,v in ipairs({"any","default","init"}) do
		local tmp=genpar.find(tokens,v)
		if (type(tmp)=="table") then
			genpar.parser[v.."_func"]=tmp[2]
		end
	end

	-- Call the init function before the actual string parsing
	-- Pretty useful if you want to set some initial values like genpar.parser.used
	genpar.parser.init_func()

	for i=1, #str do
		-- Get a piece of the string
		genpar.parser.token=str:sub(i,i)

		-- Run the any token function before checking for the token
		genpar.parser.any_func()

		-- Check for the desired token, if it is found, continue the loop but set parser.canOutput to false so we don't output the token
		for n,t in ipairs(tokens) do
			if (genpar.parser.token==t[1]) then
				t[2]()
				usedToken=true
			end
		end

		-- The magic happens here
		if (genpar.parser.canOutput==true and usedToken==false) then
			result[genpar.parser.used]=(result[genpar.parser.used] or "")..genpar.parser.token
		end

		if (usedToken==false) then
			genpar.parser.default_func()
		end

		usedToken=false
	end

	return result
end

return genpar
