% own example of lvqnet
[x,t] = iris_dataset;
net = lvqnet(20);
net = train(net,x,t);
view(net)
y = net(x);
perf = perform(net,t,y);
classes = vec2ind(y);


%% pendigit claasification by neural network-LVQ
%[pen_digit_case, num_total_cases, stNeuralNetwork] = load_data();
[ptn_info, astSampleCase, stNeuralNetwork] = ptn_load_data_and_cfg(1);
net = lvqnet(ptn_info.nNeuralLayer, ptn_info.fNeuralLearnRate);
N = ptn_info.N;
net.trainFcn = 'trainlm';
[net, TR] = train(net, stNeuralNetwork.matPoints(:, 1:N), stNeuralNetwork.matTargetClass(:, 1:N), 'CheckpointFile','MyCheckpoint','CheckpointDelay',120);
view(net)


%% ���һLVQ�����磬�������ѵ�����Ա�������10������ʸ����Ϊ���࣬��
p=[-3 -2 -2  0  0  0  0 +2  +2 +3;
    0 +1 -1  +2 +1 -1 -2 +1 -1 0];
c= [1 1 1    2  2  2  2  1  1  1];

%% �������ú���ind2vec����������cת��Ϊ��Ӧ��ʸ����ʽ
t = ind2vec(c);
%%t=[1 1 1 0 0 0 0 1 1 1; 0 0 0 1 1 1 1 0 0 0]

pause % Strike any key to plot these data points...
clc
colormap(hsv);
plotvec(p,c);
% alabel(p(1,:), p(2,:),'Input Vectors' ); 
pause % Strike any key to define an LVQ network...
clc

S=4; 
[aWeight]=initlvq(p,S,t);
hold on
plot(w1(1,1),w1(1,2),'ow')
%alabel('p(1), w(1)' ,'p(2)��w(3)' ,'Input/Weight Vectors' )
pause % Strike any key to train the LVQnetwork...
clc
df=20;  %��ʾƵ��
me=500; %ѵ������ಽ��
lr = 0.05; %ѧϰ��
tp=[df me lr];
[wl,w2]=trainlvq(w1,w2,p,t,tp);

pause % Strike any key to use competitive layer...

clc
P_test = [0; 0.2];
a = simulvq(P_test, w1, w2)
