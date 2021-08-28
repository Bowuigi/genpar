# Genpar

A generic, multipurpose string parser

Accepts any string and a token table with the following syntax:

```lua
tokens = {
 	{":",function() print("found the ':'!") end},
 	{",",function() print("found a comma!") end}
}
```

How to add it into a project
----------------------------

Just copy the genpar.lua file somewhere on your project path

The license (zlib) is included on the same file

Include it:

```lua
genpar=require 'genpar'
```

How it works
------------

When it finds the required token, it runs the function corresponding to it

It is that simple.

Those functions can read and redefine variables, including the parser ones

Variables you might want to redefine:
- **parser.canOutput** - Boolean - If the parser can output to the used table field or not
- **parser.used**      - String  - Special value, check the next section

Other values you can redefine:
- **parser.token** - String - The currently used character
- **parser.any_func** - String - The current "any" function, explained later
- **parser.default_func** - String - The current "default" function, explained later
- **parser.init_func** - String - The current "init" function, explained later

parser.used
-----------

This value is a special value, the parser depends on it, and as such, it has extra stuff like:

- **init** - executes before parsing
- **finish** - executes after parsing
- **any** - executes on every character
- **default** - executes when none of the tokens (excluding the special values) was found, for example:

```lua
default_example = {
	{"init"   , function() parser.used="key"                     end},
	{":"      , function() parser.used="value"                   end},
	{"default", function() print("Unknown token "..parser.token) end}
}
```

- **everything else** - executes when the matching token is found, remember that the token is one character wide, but you can work around that with some variables

Return values and the "result" argument:
----------------------------------------

The result argument is a table containing all of the fields you want the parser to write to

The return value is just result.

Be aware that the function **WILL** change the values of result

Example
-------

Example on the example.lua file
