function z = quad_2d(x, y)

global matQuad;
global aLin;
global fOffset;

aInput2d = [x;y];

z = aInput2d' * matQuad * aInput2d + aLin' * aInput2d + fOffset;

