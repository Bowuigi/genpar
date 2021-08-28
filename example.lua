genpar=require "genpar"

tokens = {
	{"init"   , function() genpar.parser.used="key"                       end},
	{"any"    , function() print("Token "..genpar.parser.token.." found") end},
	{"="      , function() genpar.parser.used="value"                     end},
	{"default", function() print("Unknown token: "..genpar.parser.token)  end},
}

r = {}

genpar.parse("key=value",tokens, r)

print(r.key,r.value)
