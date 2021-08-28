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
