function [ptn_info, astSampleCase] = ptn_load_data_and_cfg(flag_load_data)

[ptn_info] = ptn_load_config;

if flag_load_data ~= 0
    if flag_load_data == 1   
        %% pen-digits 10-classes {0, 1, 2, ..., 9}
        [astSampleCase, num_total_cases] = load_data;
         ptn_info.total_class = 10;

    elseif flag_load_data == 2 
        %% a 2-d demo class
         strFileFullname = '.\demo_2d\demo_2d.txt';
         [astSampleCase, num_total_cases] = load_demo_2d(strFileFullname, 2); 
         ptn_info.total_class = 2;
    else
        error();
    end
end

%% Dimension of features
dim_feature = length(astSampleCase(1).feature);

strDisp = sprintf('Total number of samples: %d', num_total_cases);
disp(strDisp);
%N = input('Input actual number of cases for teaching: '); 
% Number of samples
%model_option = input('Input Model Option -- [0: PSD Only, 1: PSD + 1st order + offset, 2: PSD + 1st order, 3: No PSD + 1st + ofst, 4: each class has one 2nd order model]: ');

ptn_info.dim_feature = dim_feature;

