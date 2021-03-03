'$INCLUDE: 'settings.bas'
'_ = False
'matrix_map = [
'    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
'    [1, _, _, _, _, _, 2, _, _, _, _, _, _, _, _, _, _, 4, _, _, _, _, _, 1],
'    [1, _, 2, 2, _, _, _, _, _, 2, 2, 2, _, _, _, 3, _, _, _, _, 4, _, _, 1],
'    [1, _, _, _, _, _, _, _, _, _, _, 2, 2, _, _, _, 3, _, _, _, _, _, _, 1],
'    [1, _, 2, 2, _, _, _, _, _, _, _, _, 2, _, 4, _, _, 3, _, _, _, 4, _, 1],
'    [1, _, _, _, _, _, 4, _, _, 2, 2, _, 2, _, _, _, _, _, _, 4, _, _, _, 1],
'    [1, _, 3, _, _, _, 2, _, _, 2, _, _, 2, _, _, _, 4, _, _, _, _, 4, _, 1],
'    [1, _, _, 3, _, _, 2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, 1],
'    [1, _, 3, _, _, _, _, _, _, _, 3, _, _, 3, 3, _, _, _, _, 3, 3, _, _, 1],
'    [1, _, 3, _, _, _, 3, 3, _, 3, _, _, _, 3, 3, _, _, _, _, 2, 3, _, _, 1],
'    [1, _, _, _, _, 3, _, 3, _, _, 3, _, _, _, _, _, _, _, _, _, _, _, _, 1],
'    [1, _, 4, _, 3, _, _, _, _, 3, _, _, 2, _, _, _, _, _, _, _, _, 2, _, 1],
'    [1, _, _, _, _, _, 4, _, _, _, _, _, 2, 2, _, _, _, _, _, _, 2, 2, _, 1],
'    [1, _, _, 4, _, _, _, _, 4, _, _, _, _, 2, 2, 2, 2, 2, 2, 2, 2, _, _, 1],
'    [1, _, _, _, _, _, _, _, _, _, 4, _, _, _, _, _, _, _, _, _, _, _, _, 1],
'    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
']





'DIM SHARED map_data(12, 8) AS INTEGER
'DIM SHARED world_map(12, 8) AS INTEGER

'FOR y = 0 TO 8 - 1

'    FOR x = 0 TO 12 - 1


'        READ map_data(x, y)

'    NEXT
'NEXT

'FOR y = 0 TO 8 - 1

'    FOR x = 0 TO 12 - 1


'        world_map(x, y) = 0

'    NEXT
'NEXT




'DATA 1,1,1,1,1,1,1,1,1,1,1,1
'DATA 1,0,0,0,0,0,0,1,0,0,0,1
'DATA 1,0,0,1,1,1,0,0,0,1,0,1
'DATA 1,0,0,0,0,1,0,0,1,1,0,1
'DATA 1,0,0,2,0,0,0,0,1,0,0,1
'DATA 1,0,0,2,0,0,0,1,1,1,0,1
'DATA 1,0,0,0,0,1,0,0,0,0,0,1
'DATA 1,1,1,1,1,1,1,1,1,1,1,1

'$DYNAMIC

DIM SHARED text_map(ROWS_SCALE) AS STRING

DIM SHARED mini_map(0) AS map_data
DIM SHARED world_map(0) AS map_data
TYPE map_data

    x AS LONG
    y AS LONG
    textureID AS LONG


END TYPE




FOR ROW = 0 TO UBOUND(text_map) - 1


    READ text_map(ROW)

NEXT


'  24x16


'DATA "111111111111111111111111"
'DATA "1.....2.........4......1"
'DATA "1.22.......2..3....4...1"
'DATA "1..........2...3.......1"
'DATA "1.22....22.2.4..3...4..1"
'DATA "1.....4.2..2......4....1"
'DATA "1.3...2........4....4..1"
'DATA "1..3..2.....33.........1"
'DATA "1.3.........33....33...1"
'DATA "1.3...33..........23...1"
'DATA "1....3.3...............1"
'DATA "1.4.3......2........2..1"
'DATA "1.....4....22......22..1"
'DATA "1..4........22222222...1"
'DATA "1......................1"
'DATA "111111111111111111111111"





'DATA "111111111111111111111111"
'DATA "1.....2..........4.....1"
'DATA "1.22.....222...3....4..1"
'DATA "1..........22...3......1"
'DATA "1.22........2.4..3...4.1"
'DATA "1.....4..22.2......4...1"
'DATA "1.3...2..2..2...4....4.1"
'DATA "1..3..2................1"
'DATA "1.3.......3..33....33..1"
'DATA "1.3...33.3...33....23..1"
'DATA "1....3.3..3............1"
'DATA "1.4.3....3..2........2.1"
'DATA "1.....4.....22......22.1"
'DATA "1..4....4....22222222..1"
'DATA "1.........4............1"
'DATA "111111111111111111111111"

















'DATA "111111111111"
'DATA "1..........1"
'DATA "1..........1"
'DATA "1....22....1"
'DATA "1....22....1"
'DATA "1..........1"
'DATA "1..........1"
'DATA "111111111111"


DATA "111111111111"
DATA "1.....2....1"
DATA "1.22.....2.1"
DATA "1..........1"
DATA "1.22.......1"
DATA "1.2......2.1"
DATA "1.....2....1"
DATA "111111111111"


DIM SHARED WORLD_WIDTH: WORLD_WIDTH = LEN(text_map(0)) * TILE
DIM SHARED WORLD_HEIGHT: WORLD_HEIGHT = UBOUND(text_map) * TILE

'PRINT UBOUND(text_map)

add = 0
add2 = 0
ROWS = UBOUND(text_map)

FOR j = 0 TO ROWS - 1
    row$ = text_map(j)

    FOR i = 0 TO LEN(row$) - 1
        char$ = (MID$(row$, i + 1, 1))


        IF char$ <> "." THEN


            REDIM _PRESERVE mini_map(add) AS map_data

            mini_map(add).x = i * MAP_TILE
            mini_map(add).y = j * MAP_TILE
            add = add + 1


            IF char$ = "1" THEN

                REDIM _PRESERVE world_map(add2) AS map_data
                world_map(add2).textureID = 1
                world_map(add2).x = i * TILE
                world_map(add2).y = j * TILE
                add2 = add2 + 1
            ELSEIF char$ = "2" THEN

                REDIM _PRESERVE world_map(add2) AS map_data
                world_map(add2).textureID = 2
                world_map(add2).x = i * TILE
                world_map(add2).y = j * TILE
                add2 = add2 + 1

            ELSEIF char$ = "3" THEN

                REDIM _PRESERVE world_map(add2) AS map_data
                world_map(add2).textureID = 3
                world_map(add2).x = i * TILE
                world_map(add2).y = j * TILE
                add2 = add2 + 1

            ELSEIF char$ = "4" THEN

                REDIM _PRESERVE world_map(add2) AS map_data
                world_map(add2).textureID = 4
                world_map(add2).x = i * TILE
                world_map(add2).y = j * TILE
                add2 = add2 + 1






            END IF

        END IF


    NEXT i
NEXT j


'PRINT STR$(UBOUND(mini_map))

'DIM mini1(0)
'DIM SHARED mini5(10) AS map_data



'PRINT add2
''FOR y = 0 TO 8 - 1

''    FOR x = 0 TO 12 - 1


''        world_map(x, y) = "."

''    NEXT
''NEXT




















