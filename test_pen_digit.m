close all

clear astSampleCase ptn_info class_model solution_x stNeuralNetwork
flag_load_data = input('[1: pen-digits classify, 2: a simple 2-d classify demo] ');
%
%
% History
% YYYYMMDD  Notes
% 20071111  replace nameing for structure array "pen_digit_case" to
% astSampleCase: array of structure, while keep the content and field
% struct: {'x', 'y', 'class', 'feature'}

if flag_load_data ~= 0
    [ptn_info, astSampleCase, stPenDataNeuralNetwork] = ptn_load_data_and_cfg(flag_load_data)
end

dim_feature = length(astSampleCase(1).feature);


ptn_info.flag_load_data = flag_load_data;
ptn_info.dim_feature = dim_feature;

stOutPenDigitIdentifyCalc = pen_digit_identify_calc(ptn_info, astSampleCase, stPenDataNeuralNetwork);

cpu_time_learning = stOutPenDigitIdentifyCalc.cpu_time_learning;
identify_time = stOutPenDigitIdentifyCalc.identify_time;
pattern_identify = stOutPenDigitIdentifyCalc.pattern_identify;
remain_error = stOutPenDigitIdentifyCalc.remain_error;

