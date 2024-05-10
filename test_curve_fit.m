xdata = (0:0.1:2*pi)';
y0 = sin(xdata);
gnoise = y0.*randn(size(y0));
spnoise = zeros(size(y0));
p = randperm(length(y0));
sppoints = p(1:round(length(p)/5));
spnoise(sppoints) = 5*sign(y0(sppoints));
ydata = y0 + gnoise + spnoise;
%f = fittype('a*sin(b*x)'); 

%% function plot
f = @(x)abs(exp(-j*x*(0:9))*ones(10,1));
subplot(2,2,1), fplot(@humps,[0 1])
subplot(2,2,2), fplot(f,[0 2*pi])
subplot(2,2,3), fplot('[tan(x),sin(x),cos(x)]',2*pi*[-1 1 -1 1])
subplot(2,2,4), fplot('sin(1 ./ x)', [0.01 0.1],1e-3)

x = linspace(-1, 1, 100);
y = linspace(-1, 1, 100);
z1 = gen_quad_fun_val(class_model(1).Model_Ord2, x, y);
z2 = gen_quad_fun_val(class_model(2).Model_Ord2, x, y);

x_cv = [];
y_cv = [];
eps = 1e-2;
iNumData = 0;
for ii = 1:1:100
    for jj = 1:1:100
        if abs(z1(jj, ii)) <= eps
            iNumData = iNumData + 1;
            x_cv(iNumData) = x(ii);
            y_cv(iNumData) = y(jj);
        end
    end
end
plot(x_cv(1:7), y_cv(1:7), x_cv(8:end), y_cv(8:end))
for ii = 1:1:100
    for jj = 1:1:100
        if abs(z2(jj, ii) - 1) <= eps
            iNumData = iNumData + 1;
            x_cv(iNumData) = x(ii);
            y_cv(iNumData) = y(jj);
        end
    end
end
