_TITLE "QB64Doom"


'$CHECKING:OFF


'.....................................................
'$include: 'map.bas'


DIM SHARED rows AS LONG: rows = 12
DIM SHARED columns AS LONG: columns = 8
DIM SHARED player AS LONG
DIM SHARED textures(5) AS LONG
DIM SHARED offset AS SINGLE


DIM ff AS SINGLE
DIM fps1 AS SINGLE
DIM start AS LONG

DIM SHARED ox AS SINGLE: ox = 0
DIM SHARED oy AS SINGLE: oy = 0
DIM SHARED xm AS SINGLE: xm = 0
DIM SHARED ym AS SINGLE: ym = 0
DIM SHARED sin_a AS SINGLE: sin_a = 0
DIM SHARED cos_a AS SINGLE: cos_a = 0
DIM SHARED cur_angle AS SINGLE: cur_angle = 0
DIM SHARED x AS LONG
DIM SHARED y AS LONG
DIM SHARED depth AS SINGLE
DIM SHARED depth_h AS SINGLE
DIM SHARED depth_Y AS SINGLE
DIM SHARED xh AS SINGLE
DIM SHARED yv AS SINGLE

DIM SHARED tast AS player

DIM SHARED walls(NUM_RAYS) AS wall_data
DIM SHARED sprite_barrel AS LONG
DIM SHARED sprite_caco AS LONG
DIM SHARED spr_object(4) AS sprite_data

DIM SHARED weapon_base AS LONG

TYPE sprite_data
    'static?
    static_spr AS LONG
    'shift
    shift AS SINGLE
    '.............................

    'dist_sprite
    dist_sprite AS SINGLE

    'pos info
    posx AS SINGLE
    posy AS SINGLE
    scalex AS SINGLE
    scaley AS SINGLE
    offx AS SINGLE
    offy AS SINGLE
    offwdth AS SINGLE
    offhght AS SINGLE
    scale AS SINGLE
    'texture
    tex AS LONG
    show AS LONG
END TYPE

TYPE player
    x AS SINGLE
    y AS SINGLE
    angle AS SINGLE
    sensitivity AS SINGLE
END TYPE


TYPE wall_data
    dpth AS SINGLE

    posX AS SINGLE
    posY AS SINGLE
    scalex AS SINGLE
    scaley AS SINGLE
    offx AS SINGLE
    offy AS SINGLE
    offwdth AS SINGLE
    offhght AS SINGLE

    tex AS LONG



END TYPE




DIM SHARED my_player AS player

DIM SHARED map_surf AS LONG
'.....................................................................................

DIM SHARED temp_self(4) AS sprite_data



SCREEN _NEWIMAGE(GAME_WIDTH, GAME_HEIGHT, 32)

map_surf = _NEWIMAGE(INT(WORLD_WIDTH / MAP_SCALE), INT(WORLD_HEIGHT / MAP_SCALE), 32)



_MOUSEHIDE

main

'CLS , _RGBA(0, 0, 0, 0)



SUB main

    'sprites
    sprite_barrel = _LOADIMAGE("sprites\barrel\0.png", 32)
    sprite_caco = _LOADIMAGE("sprites\caco\0.png", 32)
    sprite_pedestal = _LOADIMAGE("sprites\pedestal\0.png", 32)
    weapon_base = _LOADIMAGE("sprites/weapons/shotgun/base/0.png", 32)

    '  _DISPLAYORDER _HARDWARE , _SOFTWARE


    'walls
    textures(0) = textures(1)

    textures(1) = _LOADIMAGE("img/wall1.png", 32)
    textures(2) = _LOADIMAGE("img/wall2.png", 32)
    textures(3) = _LOADIMAGE("img/wall5.png", 32)
    textures(4) = _LOADIMAGE("img/wall6.png", 32)


    'sky
    textures(5) = _LOADIMAGE("img/sky3.png", 32)

    _FONT _LOADFONT("C:\Windows\Fonts\arialbd.ttf", 36, "Bold")
    showmap = 1


    my_player.x = player_posX
    my_player.y = player_posY
    my_player.angle = player_angle
    my_player.sensitivity = 0.004


    '  7, 4), -0.2, 0.74
    '  sprite_objects spr_object(), sprite_barrel, true, 7, 4, -0.2, 0.74

    sprite_objects temp_self(0), sprite_barrel, true, 5.9, 2.1, 1.8, 0.4
    sprite_objects temp_self(1), sprite_barrel, true, 7.1, 2.1, 1.8, 0.4
    sprite_objects temp_self(2), sprite_caco, true, 7, 4, -0.2, 0.74
    sprite_objects temp_self(3), sprite_pedestal, true, 8.8, 2.5, 1.6, 0.5
    sprite_objects temp_self(4), sprite_pedestal, true, 8.8, 5.6, 1.6, 0.5


    'temp_self(0).tex = sprite_barrel
    'temp_self(1).tex = sprite_barrel

    ' sprite_objects2 sprite_barrel, true, 5.9, 2.1, 1.8, 0.4
    'sprite_objects sprite_caco, true, 7, 4, -0.2, 0.74
    'temp_self(0).static_spr = static_spr
    'temp_self(0).posx = 5.9 * TILE
    'temp_self(0).posy = 2.1 * TILE
    'temp_self(0).shift = 1.8
    'temp_self(0).scale = 0.4


    'temp_self(1).static_spr = static_spr
    'temp_self(1).posx = 7.1 * TILE
    'temp_self(1).posy = 2.1 * TILE
    'temp_self(1).shift = 1.8
    'temp_self(1).scale = 0.4



    DO WHILE _KEYHIT <> 27
        offset = 0



        ff% = ff% + 1
        IF TIMER - start! >= 1 THEN fps1 = ff%: ff% = 0: start! = TIMER

        player_mov
        background_draw (radstodegs(my_player.angle))
        ray_casting my_player, textures()


        '_TITLE STR$(spr_object(0).dist_sprite) + " " + STR$(spr_object(1).dist_sprite)



        sprite_object_locate temp_self(0), spr_object(0), my_player, walls()
        sprite_object_locate temp_self(1), spr_object(1), my_player, walls()
        sprite_object_locate temp_self(2), spr_object(2), my_player, walls()
        sprite_object_locate temp_self(3), spr_object(3), my_player, walls()
        sprite_object_locate temp_self(4), spr_object(4), my_player, walls()






        world spr_object(), walls()



        drawtext DARKORANGE, FPS_POSX, FPS_POSY, STR$(fps1), 1

        minimap my_player
        player_weapon

        _DISPLAY

        _LIMIT 60

    LOOP


    _FREEIMAGE map_surf
    _FREEIMAGE weapon_base
    _FREEIMAGE sprite_barrel
    _FREEIMAGE sprite_caco





    FOR i = 0 + 1 TO UBOUND(textures) - 1
        _FREEIMAGE textures(i)


    NEXT i
    'FOR i = 0 TO UBOUND(walls) - 1
    '    _FREEIMAGE walls(i).tex


    'NEXT i
    'FOR i = 0 TO UBOUND(spr_object)
    '    _FREEIMAGE spr_object(i).tex


    'NEXT i




END SUB

SUB scroll_bg_H (img AS LONG, bg_offset AS LONG)

    empty_space = GAME_WIDTH - _WIDTH(img)
    sky_offset = -10 * (bg_offset) MOD (GAME_WIDTH - empty_space)
    'sky_offset = modulo(-10 * (bg_offset) , (GAME_WIDTH - empty_space))



    _PUTIMAGE (sky_offset, 0), img
    _PUTIMAGE (sky_offset - GAME_WIDTH + empty_space, 0), img
    _PUTIMAGE (sky_offset + GAME_WIDTH - empty_space, 0), img

    IF sky_offset <= -_WIDTH(img) + empty_space THEN


        _PUTIMAGE (sky_offset + _WIDTH(img) * 2, 0), img
    END IF



END SUB

SUB draw_rect (left AS LONG, top AS LONG, right AS LONG, bottom AS LONG, clr AS _UNSIGNED LONG)
    LINE (left, top)-(right + left, bottom + top), clr, BF


END SUB
'Calculate minimum value between two values
FUNCTION min! (a!, b!)
    IF a! < b! THEN min! = a! ELSE min! = b!
END FUNCTION

'Calculate maximum value between two values
FUNCTION max! (a!, b!)
    IF a! > b! THEN max! = a! ELSE max! = b!
END FUNCTION



SUB minimap (plyer AS player)




    map_x = INT(plyer.x / MAP_SCALE)
    map_y = INT(plyer.y / MAP_SCALE)


    draw_to map_surf

    CLS , _RGB32(0, 0, 0)


    'player

    LINE (map_x, map_y)-(map_x + 12 * COS(plyer.angle), (map_y + 12 * SIN(plyer.angle))), YELLOW
    CircleFill INT(map_x), INT(map_y), 5, WHITE



    'caco
    CircleFill INT(temp_self(2).posx / MAP_SCALE), INT(temp_self(2).posy / MAP_SCALE), 4, RED


    'objects
    CircleFill INT(temp_self(0).posx / MAP_SCALE), INT(temp_self(0).posy / MAP_SCALE), 3, GRAY
    CircleFill INT(temp_self(1).posx / MAP_SCALE), INT(temp_self(1).posy / MAP_SCALE), 3, GRAY
    CircleFill INT(temp_self(3).posx / MAP_SCALE), INT(temp_self(3).posy / MAP_SCALE), 3, GRAY
    CircleFill INT(temp_self(4).posx / MAP_SCALE), INT(temp_self(4).posy / MAP_SCALE), 3, GRAY




    FOR i = 0 TO UBOUND(mini_map)

        draw_rect mini_map(i).x, mini_map(i).y, MAP_TILE, MAP_TILE, DARKBROWN


    NEXT i

    '_DISPLAY

    draw_to 0

    _PUTIMAGE (MAPPOS_X, MAPPOS_Y)-(MINIMAP_RESW, (MINIMAP_RESH) + MAPPOS_Y), map_surf, 0 ', (0, 0)-(MINIMAP_RESW, (MINIMAP_RESH))




END SUB


SUB draw_to (surf AS LONG)
    _DEST surf

END SUB



SUB background_draw (playerANG AS LONG)
    draw_to 0
    scroll_bg_H textures(5), playerANG


    draw_rect 0, HALF_HEIGHT, GAME_WIDTH, HALF_HEIGHT, DARKGRAY
    draw_rect 0, HALF_HEIGHT, GAME_WIDTH, HALF_HEIGHT, DARKGRAY


END SUB

SUB CircleFill (x AS LONG, y AS LONG, R AS LONG, C AS _UNSIGNED LONG)
    DIM x0 AS SINGLE, y0 AS SINGLE
    DIM e AS SINGLE

    x0 = R
    y0 = 0
    e = -R
    DO WHILE y0 < x0
        IF e <= 0 THEN
            y0 = y0 + 1
            LINE (x - x0, y + y0)-(x + x0, y + y0), C, BF
            LINE (x - x0, y - y0)-(x + x0, y - y0), C, BF
            e = e + 2 * y0
        ELSE
            LINE (x - y0, y - x0)-(x + y0, y - x0), C, BF
            LINE (x - y0, y + x0)-(x + y0, y + x0), C, BF
            x0 = x0 - 1
            e = e - 2 * x0
        END IF
    LOOP
    LINE (x - R, y)-(x + R, y), C, BF
END SUB

SUB drawtext (c AS LONG, dtx AS LONG, dty AS LONG, txt AS STRING, bktrans AS LONG)

    IF bktrans = 1 THEN _PRINTMODE _KEEPBACKGROUND ELSE _PRINTMODE _FILLBACKGROUND
    COLOR c
    _PRINTSTRING (dtx, dty), txt


END SUB




SUB ray_casting (plyer AS player, tex() AS LONG) 'function?
    DIM dx AS SINGLE
    DIM dy AS SINGLE

    '   draw_to 0

    '  offset = 0


    ox = plyer.x
    oy = plyer.y
    xm = mapping_x(ox)
    ym = mapping_y(oy)

    cur_angle = plyer.angle - HALF_FOV

    FOR ray = 0 TO NUM_RAYS - 1

        sin_a = SIN(cur_angle)
        cos_a = COS(cur_angle)

        IF sin_a THEN sin_a = sin_a ELSE sin_a = 0.000001
        IF cos_a THEN cos_a = cos_a ELSE cos_a = 0.000001

        'verticals
        IF cos_a >= 0 THEN x = xm + TILE: dx = 1 ELSE x = xm: dx = -1
        FOR i = 0 TO WORLD_WIDTH - 1 STEP TILE
            depth_v = (x - ox) / cos_a
            yv = oy + depth_v * sin_a

            tile_vX = mapping_x(x + dx)
            tile_vY = mapping_y(yv)

            exitfor = 0

            FOR i2 = 0 TO UBOUND(world_map)
                IF tile_vX = world_map(i2).x AND tile_vY = world_map(i2).y THEN
                    texture_v = world_map(i2).textureID
                    exitfor = 1
                    EXIT FOR

                END IF

            NEXT i2

            '   texture_v = 1
            IF exitfor = 1 THEN
                EXIT FOR
            END IF


            x = x + dx * TILE
        NEXT i


        '  horizontals
        exitfor = 0
        IF sin_a >= 0 THEN y = ym + TILE: dy = 1 ELSE y = ym: dy = -1
        FOR i = 0 TO WORLD_HEIGHT - 1 STEP TILE
            depth_h = (y - oy) / sin_a
            xh = ox + depth_h * cos_a


            depth_v = (x - ox) / cos_a
            yv = oy + depth_v * sin_a

            tile_hX = mapping_x(xh)
            tile_hY = mapping_y(y + dy)

            FOR i2 = 0 TO UBOUND(world_map)
                IF tile_hX = world_map(i2).x AND tile_hY = world_map(i2).y THEN
                    texture_h = world_map(i2).textureID
                    exitfor = 1
                    EXIT FOR

                END IF
            NEXT i2

            '   texture_h = 1
            IF exitfor = 1 THEN
                EXIT FOR
            END IF

            y = y + dy * TILE
        NEXT i

        'projection
        IF depth_v < depth_h THEN depth = depth_v: offset = yv: texture = texture_v ELSE: depth = depth_h: offset = xh: texture = texture_h
        offset = modulo(INT(offset), TILE) 'fix MOD python difference
        depth = depth * COS(plyer.angle - cur_angle)
        depth = max(depth, 0.00001)
        proj_height = min(INT(PROJ_COEFF / depth), 2 * GAME_HEIGHT)


        IF texture <= 0 THEN texture = 1
        'draw_rays tex(texture), ray * SCALE, INT(HALF_HEIGHT - proj_height / 2), SCALE, proj_height, offset * TEXTURE_SCALE, 0, TEXTURE_SCALE, TEXTURE_HEIGHT

        walls(ray).dpth = depth
        walls(ray).posX = ray * SCALE
        walls(ray).posY = INT(HALF_HEIGHT - proj_height / 2)
        walls(ray).scalex = SCALE
        walls(ray).scaley = proj_height
        walls(ray).offx = offset * TEXTURE_SCALE
        walls(ray).offy = 0
        walls(ray).offwdth = TEXTURE_SCALE
        walls(ray).offhght = TEXTURE_HEIGHT
        walls(ray).tex = tex(texture)
        cur_angle = cur_angle + DELTA_ANGLE






    NEXT



END SUB 'function?

SUB draw_rays (tex AS LONG, destx AS SINGLE, desty AS SINGLE, scaleX AS SINGLE, scaleY AS SINGLE, srcx AS SINGLE, srcy AS SINGLE, srcscaleX AS SINGLE, srcscaleY AS SINGLE)
    '  draw_to 0
    _PUTIMAGE (destx, desty)-(scaleX + destx, scaleY + desty), tex, 0, (srcx, srcy)-(srcscaleX + srcx, srcscaleY)

END SUB

FUNCTION mapping_x (a AS SINGLE)
    mapping_x = INT(a / TILE) * TILE
END FUNCTION

FUNCTION mapping_y (b AS SINGLE)
    mapping_y = INT(b / TILE) * TILE
END FUNCTION

FUNCTION radstodegs (rads AS SINGLE)

    radstodegs = rads * 180 / _PI

END FUNCTION

FUNCTION modulo& (num1 AS LONG, num2 AS LONG)
    modulo = ((num1 MOD num2) + num2) MOD num2
END FUNCTION

'FUNCTION modulo2 (num1 AS SINGLE, num2 AS SINGLE)
'    modulo2 = ((num1 MOD num2) + num2) MOD num2
'END FUNCTION






SUB player_mov
    ' my_player.angle = player_angle
    sin_a = SIN(my_player.angle)
    cos_a = COS(my_player.angle)
    IF _KEYDOWN(ASC("w")) THEN
        my_player.x = my_player.x + player_speed * cos_a
        my_player.y = my_player.y + player_speed * sin_a
    END IF

    IF _KEYDOWN(ASC("s")) THEN
        my_player.x = my_player.x + -player_speed * cos_a
        my_player.y = my_player.y + -player_speed * sin_a
    END IF

    IF _KEYDOWN(ASC("a")) THEN
        'my_player.angle = my_player.angle - 0.02

        my_player.x = my_player.x + player_speed * sin_a
        my_player.y = my_player.y + -player_speed * cos_a


    END IF
    IF _KEYDOWN(ASC("d")) THEN
        'my_player.angle = my_player.angle + 0.02
        my_player.x = my_player.x + -player_speed * sin_a
        my_player.y = my_player.y + player_speed * cos_a




    END IF

    IF _KEYDOWN(ASC("c")) THEN
        my_player.angle = my_player.angle + 0.02



    END IF
    IF _KEYDOWN(ASC("z")) THEN
        my_player.angle = my_player.angle - 0.02


    END IF

    'IF _KEYDOWN(ASC("z")) THEN
    '    my_player.x = my_player.x + player_speed * sin_a
    '    my_player.y = my_player.y + -player_speed * cos_a

    'END IF

    'IF _KEYDOWN(ASC("c")) THEN
    '    my_player.x = my_player.x + -player_speed * sin_a
    '    my_player.y = my_player.y + player_speed * cos_a

    'END IF



    '  my_player.angle = CSNG(INT(modulo((my_player.angle), INT(DOUBLE_PI))))
    'my_player.angle = degToRad(modulo(radstodegs(my_player.angle), radstodegs(DOUBLE_PI)))




    DO WHILE _MOUSEINPUT
        _MOUSEMOVE HALF_WIDTH, HALF_HEIGHT
        difference = _MOUSEX - HALF_WIDTH
        my_player.angle = my_player.angle + difference * my_player.sensitivity

    LOOP

    my_player.angle = degToRad(modulo(radstodegs(my_player.angle), radstodegs(DOUBLE_PI)))


    '_TITLE STR$(my_player.angle)


    'IF _KEYDOWN(104) THEN
    '    IF showmap = 1 THEN
    '        showmap = 0
    '    ELSEIF showmap = 0 THEN
    '        showmap = 1

    '    END IF
    'END IF


    'IF showmap = 1 THEN
    '    _PUTIMAGE (0, MAPPOS_Y)-(240, (GAME_HEIGHT / MAP_SCALE) + MAPPOS_Y), map_surf, 0

    'ELSEIF showmap = 0 THEN

    'END IF



    ' _DONTBLEND

END SUB

FUNCTION degToRad## (a AS _FLOAT)
    degToRad = a * _PI / 180.0
END FUNCTION




SUB world (world_objects() AS sprite_data, wall_objects AS wall_data)





    DESC_SORT world_objects(), walls()






    FOR objects = 0 TO 300 '- 1




        '   draw_rays world_objects(objects).tex, world_objects(objects).posx, world_objects(objects).posy, world_objects(objects).scalex, world_objects(objects).scaley, world_objects(objects).offx, world_objects(objects).offy, world_objects(objects).offwdth, world_objects(objects).offhght

        '  draw_rays walls(objects).tex, walls(objects).posX, walls(objects).posY, walls(objects).scalex, walls(objects).scaley, walls(objects).offx, walls(objects).offy, walls(objects).offwdth, walls(objects).offhght

        'objects = objects + 1
        draw_rays walls(objects).tex, walls(objects).posX, walls(objects).posY, walls(objects).scalex, walls(objects).scaley, walls(objects).offx, walls(objects).offy, walls(objects).offwdth, walls(objects).offhght
    NEXT objects


    FOR objects = 0 TO UBOUND(world_objects)
        ' _TITLE STR$(world_objects(objects).posx)
        '_TITLE STR$(world_objects(0).show) + " " + STR$(world_objects(1).show)
        IF world_objects(objects).show = 1 THEN


            '     draw_rays world_objects(0).tex, world_objects(0).posx, world_objects(0).posy, world_objects(0).scalex, world_objects(0).scaley, 0, 0, _WIDTH(world_objects(0).tex), _HEIGHT(world_objects(objects).tex)

            draw_rays world_objects(objects).tex, world_objects(objects).posx, world_objects(objects).posy, world_objects(objects).scalex, world_objects(objects).scaley, 0, 0, _WIDTH(world_objects(objects).tex), _HEIGHT(world_objects(objects).tex)
        ELSE
            '   EXIT FOR
        END IF


    NEXT objects




    'def world(self, world_objects):
    '      for obj in sorted(world_objects, key=lambda n: n[0], reverse=True):
    '          if obj[0]:
    '              _, object, object_pos = obj


    '   self.sc.blit(object, object_pos)
END SUB



'SUB DESC_SORT (obj() AS wall_data)


'TYPE wall_data
'    dpth AS SINGLE

'    posX AS SINGLE
'    posY AS SINGLE
'    scalex AS SINGLE
'    scaley AS SINGLE
'    offx AS SINGLE
'    offy AS SINGLE
'    offwdth AS SINGLE
'    offhght AS SINGLE
'    tex AS LONG



'END TYPE





'    FOR i = 1 TO UBOUND(obj)
'        FOR j = 0 TO UBOUND(obj) - i
'            IF obj(j).posX > obj(j + 1).posX THEN
'                IF obj(j).posY > obj(j + 1).posY THEN

'                    IF obj(j).scalex > obj(j + 1).scalex THEN

'                        IF obj(j).scaley > obj(j + 1).scaley THEN

'                            SWAP obj(j), obj(j + 1)

'                        END IF
'                    END IF
'                END IF
'            END IF




'        NEXT j
'    NEXT i

'END SUB

SUB DESC_SORT (obj() AS sprite_data, wall_objs AS wall_data)






    FOR i = 1 TO UBOUND(obj)
        FOR j = 0 TO UBOUND(obj) - i


            IF obj(j).dist_sprite < obj(j + 1).dist_sprite THEN

                SWAP obj(j), obj(j + 1)

            END IF

        NEXT j
    NEXT i






END SUB



SUB sprite_objects (tmp_slf AS sprite_data, tex AS LONG, static_spr AS LONG, posx AS SINGLE, posy AS SINGLE, spr_shift AS SINGLE, spr_scale AS SINGLE)


    tmp_slf.tex = tex
    tmp_slf.static_spr = static_spr
    tmp_slf.posx = posx * TILE
    tmp_slf.posy = posy * TILE
    tmp_slf.shift = spr_shift
    tmp_slf.scale = spr_scale
    ' tmp_slf.show = 0

END SUB



SUB sprite_object_locate (temp_slf AS sprite_data, self AS sprite_data, plyr AS player, walls() AS wall_data)
    DIM gamma AS SINGLE
    DIM theta AS SINGLE
    DIM delta_rays AS SINGLE

    DIM dx AS SINGLE
    DIM dy AS SINGLE

    'fake_walls0 = [walls[0] for i in range(FAKE_RAYS)]
    '  fake_walls1 = [walls[-1] for i in range(FAKE_RAYS)]
    '  fake_walls = fake_walls0 + walls + fake_walls1
    ' delta_rays = 0

    'theta = 0
    'gamma = 0
    ' dx = 0
    '  dy = 0

    ' FOR obj = 0 TO 1
    dx = temp_slf.posx - plyr.x
    dy = temp_slf.posy - plyr.y


    'close enough?
    distance_to_sprite = SQR(dx ^ 2 + dy ^ 2)

    ' _TITLE STR$(distance_to_sprite)

    'dx = 550 dy = 50
    theta = _ATAN2(dy, dx)



    gamma = theta - plyr.angle



    IF (dx > 0 AND radstodegs(plyr.angle) >= 180 AND radstodegs(plyr.angle) <= 360) OR (dx < 0 AND dy < 0) THEN
        gamma = gamma + DOUBLE_PI
    END IF


    '_TITLE StrNum$(gamma)






    delta_rays = INT(gamma / DELTA_ANGLE)



    current_ray = CENTER_RAY + delta_rays


    distance_to_sprite = distance_to_sprite * COS(HALF_FOV - current_ray * DELTA_ANGLE)



    'END
    ' _TITLE STR$(current_ray)
    ' self.show = 0
    cur_ray = current_ray ' MOD 300
    IF cur_ray >= 300 THEN
        cur_ray = 300
        'self.show = 0


    ELSEIF cur_ray <= 0 THEN
        cur_ray = 0
    END IF


    ' IF cur_ray <= 0 OR cur_ray >= 300 THEN cur_ray = 300

    '_TITLE StrNum$(cur_ray)
    IF (current_ray >= 0) AND current_ray <= NUM_RAYS - 1 AND distance_to_sprite < walls(cur_ray).dpth THEN

        proj_height = min(INT(PROJ_COEFF / distance_to_sprite * temp_slf.scale), 2 * GAME_HEIGHT)
        half_proj_height = INT(proj_height / 2)
        shift = half_proj_height * temp_slf.shift





        self.posx = (current_ray * SCALE) - half_proj_height
        '400 - 52  + -10.4

        self.posy = HALF_HEIGHT - half_proj_height + shift
        self.show = 1




        self.scalex = proj_height
        self.scaley = proj_height
        self.dist_sprite = distance_to_sprite
        self.tex = temp_slf.tex

        '  _TITLE (STR$(my_player.angle))
        'self(1).posx = (current_ray * SCALE) - half_proj_height
        'self(1).posy = HALF_HEIGHT - half_proj_height + shift

        '_TITLE (STR$(self().posx))
        'self(1).show = 1

        'self(1).scalex = proj_height
        'self(1).scaley = proj_height
        'self(1).dist_sprite = distance_to_sprite
        'self(1).tex = temp_self(0).tex



    ELSE
        'EXIT SUB
        self.show = 0
    END IF


END SUB

SUB player_weapon
    '   (HALF_WIDTH - self.weapon_rect.width // 2, HEIGHT - self.weapon_rect.height)

    draw_rays weapon_base, HALF_WIDTH - _WIDTH(weapon_base) / 2, GAME_HEIGHT - _HEIGHT(weapon_base), _WIDTH(weapon_base), _HEIGHT(weapon_base), 0, 0, _WIDTH(weapon_base), _HEIGHT(weapon_base)



END SUB

FUNCTION StrNum$ (n#)
    value$ = UCASE$(LTRIM$(STR$(n#)))
    Xpos% = INSTR(value$, "D") + INSTR(value$, "E") 'only D or E can be present
    IF Xpos% THEN
        expo% = VAL(MID$(value$, Xpos% + 1))
        IF VAL(value$) < 0 THEN
            sign$ = "-": valu$ = MID$(value$, 2, Xpos% - 2)
        ELSE valu$ = MID$(value$, 1, Xpos% - 1)
        END IF
        dot% = INSTR(valu$, "."): L% = LEN(valu$)
        IF expo% > 0 THEN add$ = STRING$(expo% - (L% - dot%), "0")
        IF expo% < 0 THEN min1$ = STRING$(ABS(expo%) - (dot% - 1), "0"): DP$ = "."
        FOR n = 1 TO L%
            IF MID$(valu$, n, 1) <> "." THEN num$ = num$ + MID$(valu$, n, 1)
        NEXT
    ELSE StrNum$ = value$: EXIT FUNCTION
    END IF
    StrNum$ = sign$ + DP$ + min1$ + num$ + add$
END FUNCTION




