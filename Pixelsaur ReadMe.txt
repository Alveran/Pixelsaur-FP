Functional Programming Project ReadMe

Pixelsaur -The Game-

Abb. 1
Pixel-Minion :
[P]           Green P = 0 158 130
[P]
[P]

Abb. 2
Crouching:
[P][P]
[P]

Abb. 3
Barriers:
     [K]     [K]  [K][K]  [K]            [B][B]   Bird Crimson B = 220 20 60
[K], [K][K], [K], [K][K], [K][K], [K][K],

Abb. 4
Ground:
[G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G] G = 160 82 45

Abb. 5
Example field:
[ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ][ ]
[ ]                                                                                    [ ]
[ ]                                                                                    [ ]
[ ]                                                                                    [ ]
[ ]                                                                                    [ ]
[ ]                                                                                    [ ]
[ ]                                                                                    [ ]    Barrier (Cactus) K = 0 100 0 Dark Green
[ ]                                                      [B][B]                        [ ]
[ ]   [P]                                                                     [B][B]   [ ]
[ ]   [P]                                 [K][K]                              [P][P]   [ ]
[ ]   [P]   [K]            [K][K]         [K][K]                              [P]      [ ]
[G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G][G]

Background:
Background Colour Light Blue = 240 248 255

Description:
Our Project will be a small endless runner game.
A three pixel high minion (Abb. 1) will run on a ground and has to avoid
barriers of different height and length, which are spawned by a field read from a text file on
the ground. There will also be some barriers in the air (birds), which can be avoided
without jumping (because its higher than 3 pixels over the ground) or you
have to crouch.
If you crouch, the minion will shrink one pixel, which will appear in front of
the second pixel (Abb. 2).

The ground (Abb.4), the pixel-minion and the barriers (Abb. 3) will
have different colours, to differentiate between them.

To jump you have to press "UP" and to crouch, you have to press "DOWN".
Pressing "UP" the minion will jump 5 pixels high and then will return to the ground in the same amount of time.
Then it will automatically move to its original position. Crouching works by holding "DOWN" and will be brought into original state after releasing the button.
The game stops, when hitting a barrier.

By Ewelina Wendt and Luis Alvaro Rio
