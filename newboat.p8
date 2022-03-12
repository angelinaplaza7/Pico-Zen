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

gravity=2

level=1
health=5

function _init()
	for i=1,level do
		obj={
			sprite=flr(rnd(obj_count)+obj_start),
			x=flr(rnd(120)+5),
			y=i*(-obj_interval)
		}
		add(objs,obj)
	end
end

function _update()
	if btn(0) then player_x-=2 end
	if btn(1) then player_x+=2 end

	for obj in all(objs) do
			obj.y+=gravity
			
			if obj.y+4>player_y-8
			and obj.y+4<player_y
			and obj.x+4>player_x
			and obj.x+4<player_x+8 then
			health-=1
			del(objs,obj)
			end
			
			if obj.y>100 then
			 del(objs,obj)
			end
	end
	
	if #objs==0 then
			level +=1
			_init()
	end
end

function _draw()
	cls()
 --	rectfill(0,0,127,127, 12)
	spr(player_sprite,player_x,player_y)
	spr(playertip_sprite,player_x,player_y-8)	

	for obj in all(objs) do
		spr(obj.sprite,obj.x,obj.y)
	end

	print("health="..health)
end

__gfx__
00000000000000000066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000065556000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000651115600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000656665600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000060000666666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000060000655555600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666000066666000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000666000088088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006a00000440000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000000440007770077700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00060000004444007070070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555500004004007070070700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555550040000407777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555550049999407777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555550049999407777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00555500044444407777777700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
