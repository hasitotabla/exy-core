local __charset = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890"
math.randomseed(GetGameTimer());

function randomString(length)
	local ret = {}
	local r
	for i = 1, length do
		r = math.random(1, #__charset)
		table.insert(ret, __charset:sub(r, r))
	end
	return table.concat(ret)
end; getRandomString = randomString;