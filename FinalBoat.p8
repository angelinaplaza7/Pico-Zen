pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
playertip_sprite=1
player_sprite=2 
player_x=64
player_y=100

objs={}
obj_start=16
obj_count=3
obj_interval=16

pwrs={}
pwr_start=6
pwr_count=4
pwr_interval=16

gravity=1
frames=0

level=1
health=2
player_live=true
timeshit=0
finaltime=0
canhit = true
invtime = 0
doshake=0

-- code here happens during
-- the initial game load
function _init()
 do_logo()
 do_intro()
 game_init()
end

--code here runs 30 times
--per second
function _update()
 frames+=1
 --left
	if btn(0) and player_x>17
 then player_x-=2 end
	--right
	if btn(1) and player_x<103
 then player_x+=2 end
 
 t=(t+1)%s -- change tick
 if (t==0) f=f%#sp+1 -- change frame

 object_update()
	
	if #objs==0 and player_live then
			level +=1
			object_init()
	end
	
	if frames%300 == 0 
	and player_live 
	then
	 speedup()
		gravity += 0.5
	end
	
	if invtime > 0 then
	 invtime -= 1
	 if invtime == 0 then
	 	canhit = true
	 end
	end
end

-- code here runs w30 times
-- per second, but only
-- after the update() func
function _draw()
	cls()
	
	map(0,0,0,0,16,16)
 shake()
	
	if player_live then
	 if not canhit then
	  spr(24,player_x,player_y)
	  spr(24,player_x,player_y-8)
	 end
  spr(player_sprite,player_x,player_y)
	 spr(playertip_sprite,player_x,player_y-8)	
  spr(sp[f], player_x, player_y)
	
	 
	 for obj in all(objs) do
	 	spr(obj.sprite,obj.x,obj.y)
 	end
	
 	for pwr in all(pwrs) do
	 	spr(pwr.sprite,pwr.x,pwr.y)
	 end
	
	 print("health="..health, 7)
	 print("time="..frames/30, 7)
	 
	else
  print("final time:"..finaltime,28,64,8)
		print("game over",46,54,8)
		print("press x to restart",28,74,8)
		if btn(5) then   
		 game_init() 
	 end
	end
end


-->8
function do_logo()
	local y = 52.0
	local len = 0
	while  (len < 120) do
		cls()
		sspr(32,32,32,24,48,47,32,24)
		sspr(64,32,8,16,66,flr(y),8,16)
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

function do_intro()
	local y = 0
	local len = 0
	while  (len < 120) do
		cls()
		sspr(0,32,32,16,48,y,32,16)
		if(y < 48) then
			y+=1
		else
			print("boat blitz",44,64,3)
		end
		flip()
		len+=1
	end
end
function game_init()
 t,f,s=0,1,4 -- tick,frame,step
 sp={3,4,19,20} --sprites
	
	finaltime=0
	health = 2
	gravity=1
	frames=0
	level=1
 player_live=true
 player_x=64
 player_y=100
 canhit = true
 invtime = 0
 
 object_init()
end
-->8
function object_init()
 for i=1,level do
	 r = flr(rnd(obj_count))
	 if r == 0 then 
			 s = 2
		else
			 s = 1
		end
		obj={
			sprite=r+obj_start,
			x=flr(rnd(89))+16,
			y=i*(-obj_interval),
			str=s
		}
		add(objs,obj)
	end
	
	for i=1,level/3 do
	 r = flr(rnd(pwr_count))
	 if r == 0 then 
	  p = 'invinc'
	  sprpos = 1
	 else
	  p = 'hp'
	  sprpos = 0
		end
 	pwr={
	 	sprite=sprpos+pwr_start,
	 	x=flr(rnd(89))+16,
	 	y=i*(-pwr_interval),
	 	power=p
	 }
	 add(pwrs,pwr)
 end
end

function object_update()
 oldpos=0
	for obj in all(objs) do
	 oldpos=obj.y
		obj.y+=gravity
		
		if 
		 (obj.y+7>player_y-4 and
		 oldpos<player_y-4 or
	  obj.y+7==player_y-4)
		and
		 (obj.x+7>=player_x and
		  obj.x<=player_x+7)
	 then
	 	if canhit then health-=obj.str end
 		doshake=0.06
 		del(objs,obj)
		end
			
		if health < 1 then
			player_live = false
			finaltime=frames/30
			gameover()
			doshake=0.1
			for obj in all(objs) do
		  del(objs,obj)
		 end
		 for pwr in all(pwrs) do
		  del(pwrs,pwr)
		 end
		end
		
		if obj.y>112 then
		 del(objs,obj)
		end
	end
	
	for pwr in all(pwrs) do
	  oldpos=pwr.y
			pwr.y+=gravity
			
			if 
		 (pwr.y+7>player_y-4 and
		 oldpos<player_y-4 or
	  pwr.y+7==player_y-4)
		and
		 (pwr.x+7>=player_x and
		  pwr.x<=player_x+7)
	 then
	  if pwr.power == 'hp' then
		 	health+=1
		 else
		  canhit = false
		  invtime = 90
		 end
	 		del(pwrs,pwr)
			end
			
		 if pwr.y>112 then
			 del(pwrs,pwr)
			end
	end
end
-->8
function speedup()
 for i=0,2 do
  print("speed up!!!", 44,64,11)
  spr(25,player_x,player_y+8)
  wait()
  print("speed up!!!", 44,64,14)
  rectfill(player_x,player_y+8,player_x+8,player_y+15,12)
  wait()
 end
end

function shake()
 local fade = 0.95
 local offset_x=16-rnd(32)
 local offset_y=16-rnd(32)
 offset_x*=doshake
 offset_y*=doshake

 camera(offset_x,offset_y)
 doshake*=fade
 if doshake<0.05 then
   doshake=0
 end
end

function gameover()
 spr(0,player_x-5,player_y-11)
 wait()
 spr(0,player_x+5,player_y-11)
 wait()
 spr(0,player_x+5,player_y+5)
 wait()
 spr(0,player_x-5,player_y+5)
 wait()
end

function wait()
 flip()
 flip()
 flip()
end
__gfx__
00000000000ff0008811118800000000000000000000000000000000000000003333333333333334433333330000000000000000000000000000000000000000
0000000000ffff0088888888000000000000000000000000000000000000000033bbb33333b3b344443b3b330000000000000000000000000000000000000000
0040040000f88f008814418800000000000000000000000008800880044444403b8bbb33333b33344333b3330000000000000000000000000000000000000000
000440000f8888f08814418800000000000000000000000008888880088888803bbbb83333333344443333330000000000000000000000000000000000000000
00044000ff8118ff88111188000000000000000000000000088888800999999033b44b3333333334433333330000000000000000000000000000000000000000
00400400f811118f88888888000000000000000000000000088888800299222033344333b3b3334444333b3b0000000000000000000000000000000000000000
00000000f81cc18f0ffffff00a00000000000000000000000088880003933330333443333b333334433333b30000000000000000000000000000000000000000
00000000f811118f08800880a00000000000000a0000000000088000044444403333333333333344443333330000000000000000000000000000000000000000
0000a8000004400000000000000000000000000000000000cccccccccccccccc3333333300888800000000000000000000000000000000000000000000000000
000a00000009900000000000000000000000000000000000cccccccccccccccc3333333308999980000000000000000000000000000000000000000000000000
000a00000009900002200220000000000000000000000000cccccccccccccccc3333333389979998000000000000000000000000000000000000000000000000
005555000009900002200220000000000000000000000000cccccccccccccccc3333333389997998000000000000000000000000000000000000000000000000
055555500099990002222220000000000000000000000000cccccccccccccccc3333333308999980000000000000000000000000000000000000000000000000
055555500077770002222220000000000000000000000000c777cccccccccccc3333333300899800000000000000000000000000000000000000000000000000
0555555000999900022222200a00000000000000000000007cc777cccccccccc3333333300898000000000000000000000000000000000000000000000000000
005555000099990002222220a00000000000000a00000000cccccc77cccccccc3333333308880000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000ccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088ccccc0000000000000000000000000000000000033330000000000000000000090000000000000000000000000000000000000000000000000000000000
088881111ccc88888000000000100100000000000000333330000000000000000000090000000000000000000000000000000000000000000000000000000000
88888881111888888866000000000000000000000003333333000000000000000000090000000000000000000000000000000000000000000000000000000000
ff88888888888888ff66001111010000000000000003333333000000000000000000090000000000000000000000000000000000000000000000000000000000
4ffffffffffffffff466001cc1000000000000000000022203000000000000000000090000000000000000000000000000000000000000000000000000000000
04444444444444444406011c11000000000000000000022200000000000000000000090000000000000000000000000000000000000000000000000000000000
0111114411441144111611cc10000000000000000000222200000000000000000000090000000000000000000000000000000000000000000000000000000000
01cccc11cc11cc11ccc1ccc100000000000000000000222220000000000000000000090000000000000000000000000000000000000000000000000000000000
00111cccccccccccccccccc100000000000000000000222220000000000000000009999900000000000000000000000000000000000000000000000000000000
0000111cc11c111cc11cc11100000000000044444444222224444444444000000009090900000000000000000000000000000000000000000000000000000000
0000000110010001101110000000000000004ffffff2222222fff6f6f64000000009090900000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004666666666666666f6f6f64000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004ffffffffffffffff6f6f64000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004666666666666666f6f6f64000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004ffffffffffffffff6f6f64000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000004666666666666666f6f6f64000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000044444444444444444444444000000070070000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000044444444444444444444444000000007700000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000440000000000000004400000000007700000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000440000000000000004400000000070070000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000440000000000000004400000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091717171717171717171717170a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08091616161616161616161616160a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0016161616161616161616161616160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
