%Example 3.21
clf reset;
figrect=get(gcf,'Position');
set(gcf,'Position',[figrect(1:2) 300 300]);
rand('seed', 43736218);

randn('seed', 1.251983983e+09);
echo on
clc
%======
%利用竞争学习进行模式分类
%===
%INITC-初始化竞争层
%TRAINC-训练竞争层
%SIMUC-竞争层仿真
%pause

clc
x=[0 1;0 1];
clusters=8;
points=6;
std_dev=0.05;
p=nngenc(x,clusters ,points,std_dev);
pause
clc
plot(p(1,:),p(2,:),'+r')
title('Input Vectors')
xlabel('p(1)')
ylabel('p(2)')

%
% tp=[20 500 0.1];
% w=trainc(w,p,tp);

% net.trainFcn = 'trainc';
% net.trainParam.epochs = 1000;
net.trainParam.goal = 0;
net.trainParam.max_fail = 5;
net.trainParam.show = 25;
net.trainParam.showCommandLine = false;
net.trainParam.showWindow = true;
net.trainParam.time = 120;

