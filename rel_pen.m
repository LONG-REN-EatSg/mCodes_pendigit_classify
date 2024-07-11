function stOutPenIdentify = rel_pen(strFilenamConfig)

close all

stOutPenIdentify = [];
flag_load_data = 0;
[astSampleCase, num_total_cases, stPenDataNeuralNetwork] = load_data;

%% Dimension of features
dim_feature = length(astSampleCase(1).feature);

strDisp = sprintf('Total number of samples: %d', num_total_cases);
disp(strDisp);
%N = input('Input actual number of cases for teaching: ');
%model_option = input('Input Model Option -- [0: PSD Only, 1: PSD + 1st order + offset, 2: PSD + 1st order, 3: No PSD + 1st + ofst, 4: each class has one 2nd order model]: ');
stOutPenIdentify.astSampleCase = astSampleCase;
stOutPenIdentify.num_total_cases = num_total_cases;
stOutPenIdentify.stPenDataNeuralNetwork = stPenDataNeuralNetwork;

if nargin == 1
    strFilenamConfig
    [ptn_info] = ptn_load_config(strFilenamConfig);
else
    [ptn_info] = ptn_load_config;
end
ptn_info.flag_load_data = flag_load_data;

ptn_info.dim_feature = dim_feature;

stOutPenDigitIdentifyCalc = pen_digit_identify_calc(ptn_info, astSampleCase, stPenDataNeuralNetwork);

stOutPenIdentify.cpu_time_learning = stOutPenDigitIdentifyCalc.cpu_time_learning;
stOutPenIdentify.identify_time = stOutPenDigitIdentifyCalc.identify_time;
stOutPenIdentify.pattern_identify = stOutPenDigitIdentifyCalc.pattern_identify;
stOutPenIdentify.remain_error = stOutPenDigitIdentifyCalc.remain_error;
stOutPenIdentify.stIdentifyPassFail = stOutPenDigitIdentifyCalc.stIdentifyPassFail;