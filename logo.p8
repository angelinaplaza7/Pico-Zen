pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
function _init()
	do_intro()
end

function _update()
	i=1
end

function do_intro()
	local y = 52.0
	local len = 0
	while  (len < 120) do
		cls()
		sspr(8,0,32,24,48,47,32,24)
		sspr(56,0,8,16,66,flr(y),8,16)
		if(y > 46) then
			y-=0.125
		end
		if(len > 60) then
			print("pico zen",48,72,3)
		elseif(len > 57) then
			spr(0,74,51)
		elseif(len > 53) then
			spr(0,74,56)
		elseif(len > 49) then
			spr(0,70,51)
		end
		flip()
		len+=1
	end
end

function _draw()
	cls()
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000033330000000000000000000004040400000000009000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000333330000000000000000000004040400000000009000000000000000000000000000000000000000000000000000000000000000000
00077000000000000003333333000000000000000000004444400000000009000000000000000000000000000000000000000000000000000000000000000000
00700700000000000003333333000000000000000000000040000000000009000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000022203000000000000000000000040000000000009000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000022200000000000000000000000040000000000009000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000222200000000000000000000000040000000000009000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000222220000000000000000000000040000000000009000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000222220000000000000000000000040000000000999990000000000000000000000000000000000000000000000000000000000000000
00000000000044444444222224444444444000000000000000000000000909090000000000000000000000000000000000000000000000000000000000000000
0000000000004ffffff2222222fff6f6f64000000000000000000000000909090000000000000000000000000000000000000000000000000000000000000000
0000000000004666666666666666f6f6f64000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004ffffffffffffffff6f6f64000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004666666666666666f6f6f64000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004ffffffffffffffff6f6f64000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000004666666666666666f6f6f64000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000044444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000044444444444444444444444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000440000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000440000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000440000000000000004400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000