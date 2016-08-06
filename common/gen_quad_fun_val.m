function z = gen_quad_fun_val(Model_Ord2, x, y)

global matQuad;
global aLin;
global fOffset;

matQuad = Model_Ord2.ModelMatrix;
aLin = Model_Ord2.ModelLinearVec
fOffset = Model_Ord2.ModelOffset;

for ii = 1:1:100
    for jj = 1:1:100
        z(jj, ii) = quad_2d(x(ii), y(jj));
    end
end
