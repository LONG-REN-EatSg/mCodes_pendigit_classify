function [pattern_identify, remain_error] = ptn_verify_model_neural_network(modelNetwork, pen_digit_case, ptn_info, stNeuralNetwork)
% [pattern_identify, remain_error] = ptn_verify_model_05(modelNetwork,
% pen_digit_case, ptn_info)

%  pen_digit_case:   an array of struct including the trianing data and expected class
%     x: x coordinate
%     y: y coordinate
%     class:  expected class
%     feature: [x1, y1] ... [x8, y8], totally 16-dim column vector
%  modelNetwork: 
%      Network, used by simu
%      output vector = simu(modelNetwork, stNeuralNetwork.matPoints(:, ii);
%      for each Points, ii
%  ptn_info: a struct indicating solution configuration
%     scale_feature_factor:
%     scale_factor: 
%     scale_offset: 
%     model_option: 
%     N: total number of samples
%     algo_max_iter: 
%     algo_bigeps: 
%     dim_feature: 16
%
% pattern_identify:  actual identified pattern by modelNetwork
% remain_error:      pen_digit_case(ii).class - pattern_identify(ii)

stop_on_error = 0;
error_cases_mod_16 = 0;

total_size = max(size(pen_digit_case));
for ii = 1:1:total_size
    max_likelihood = -inf;
    pattern_identify_list(ii) = -1;
    outY = sim(modelNetwork, stNeuralNetwork.matPoints(:, ii));
    [fMaxY, nIdxMax] = max(outY);
    pattern_identify_list(ii) = nIdxMax - 1; %% class, 0 to 9, mapping with, 1 to 10, row
%    for jj = 1:1:ptn_info.total_class  % 10
%        likelihood_jj = 
%        %pen_digit_case(ii).feature * class_model(jj).Model_Ord2.ModelMatrix * pen_digit_case(ii).feature'/ptn_info.scale_feature_factor/ptn_info.scale_feature_factor + ...
%        %    pen_digit_case(ii).feature *class_model(jj).Model_Ord2.ModelLinearVec/ptn_info.scale_feature_factor + class_model(jj).Model_Ord2.ModelOffset;
%        if likelihood_jj > max_likelihood
%            max_likelihood = likelihood_jj;
%            pattern_identify_list(ii) = class_model(jj).class_id;
%        end
%    end
    
    remain_error_list(ii) = pattern_identify_list(ii) - pen_digit_case(ii).class;

    if pattern_identify_list(ii) ~= pen_digit_case(ii).class & stop_on_error == 1
        if mod(error_cases_mod_16, 16) == 0
            error_cases_mod_16 = 0;
            figure
        end
        subplot(4,4,error_cases_mod_16 + 1);
        plot(pen_digit_case(ii).x, pen_digit_case(ii).y);
        strDisp = sprintf('No. %d: Actual: %d, Recognize: %d', ii, pen_digit_case(ii).class, pattern_identify_list(ii));
        xlabel(strDisp);
        error_cases_mod_16 = error_cases_mod_16 + 1;
        if stop_on_error == 1
            key_cmd = input('Input 0 to continue without stop');
        end
        if key_cmd == 0 
            stop_on_error = 0;
        end
    end
    
end

pattern_identify = pattern_identify_list;
remain_error = remain_error_list;