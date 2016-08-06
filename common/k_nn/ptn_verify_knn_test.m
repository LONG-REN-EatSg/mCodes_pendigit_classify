function [pattern_identify, remain_error, total_num_fail] = ptn_verify_knn_test(pen_digit_case, ptn_info, pen_digit_case_test)

total_samples = max(size(pen_digit_case_test));
total_num_fail = 0;
ptn_info.total_class = 10;
ptn_info.class_id = 0:(ptn_info.total_class - 1);

for ii = 1:1:total_samples
    %    [classify_output] =  ptn_knn_identify(pen_digit_case, ptn_info, pen_digit_case_test(ii).feature);
    
    for jj = 1:1:ptn_info.N
        %    feature_dist_class.dist(jj) = norm(pen_digit_case(jj).feature - feature_to_identify);
        row_error = (pen_digit_case(jj).feature - pen_digit_case_test(ii).feature);
        feature_dist_class.dist(jj) = row_error * row_error';
        feature_dist_class.class(jj) = pen_digit_case(jj).class;
    end

    [sorted_dist, sorted_index] = sort(feature_dist_class.dist);
    
    if isfield(ptn_info, 'len_Knn')
        k = ptn_info.len_Knn;
    else
        k = ceil(sqrt(ptn_info.N));
    end

    class_likelihood = zeros(ptn_info.total_class, 1);
    
    for jj = 1:1:k
        class_likelihood(feature_dist_class.class(sorted_index(jj)) + 1) = class_likelihood(feature_dist_class.class(sorted_index(jj)) + 1) + 1;
    end

    max_likelihood = class_likelihood(1);
    pattern_identify = ptn_info.class_id(1);
    
    for jj = 2:1:ptn_info.total_class
        if class_likelihood(jj) > max_likelihood
            max_likelihood = class_likelihood(jj);
            pattern_identify = ptn_info.class_id(jj);
        end
    end


    pattern_identify(ii) = pattern_identify;
    remain_error(ii) = pattern_identify(ii) - pen_digit_case_test(ii).class;
    if pen_digit_case_test(ii).class ~= pattern_identify(ii)
        total_num_fail = total_num_fail + 1;
    end
   
end

