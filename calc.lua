genpar = require 'genpar'

function default_action(token,canOutput)
	if not (tonumber(token,10)) then
		print("Unknown symbol "..token)
		return true
	end
	return false
end

function operator_action(op)
	if (out[genpar.parser.used]~=nil) then
		genpar.parser.used=genpar.parser.used+1
	end
	out[genpar.parser.used]=op
	genpar.parser.used=genpar.parser.used+1
end

operations = {
	addition       = function(a,b) return a+b end;
	substraction   = function(a,b) return a-b end;
	multiplication = function(a,b) return a*b end;
	division       = function(a,b) return a/b end;
}

tokens = {
	{"init"    ; function() genpar.parser.used=1                                                                                  end};
	{"any"     ; function() genpar.parser.canOutput=true                                                                          end};
	{"+"       ; function() operator_action("addition")                                                                           end};
	{"-"       ; function() operator_action("substraction")                                                                       end};
	{"*"       ; function() operator_action("multiplication")                                                                     end};
	{"/"       ; function() operator_action("division")                                                                           end};
	{"("       ; function() operator_action("open_parentheses")                                                                   end};
	{")"       ; function() operator_action("close_parentheses")                                                                  end};
	{"default" ; function() if default_action(genpar.parser.token,genpar.parser.canOutput) then genpar.parser.canOutput=false end end};
}

out = {}

genpar.parse("(10+10)*10",tokens,out)

for i=1,#out do
	print(out[i])
end
