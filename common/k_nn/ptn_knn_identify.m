function [classify_output] =  ptn_knn_identify(pen_digit_case, ptn_info, feature_to_identify)
%
%
ptn_info.total_class = 10;
ptn_info.class_id = 0:(ptn_info.total_class - 1);

for ii = 1:1:ptn_info.N
    feature_dist_class.dist(ii) = norm(pen_digit_case(ii).feature - feature_to_identify);
    feature_dist_class.class(ii) = pen_digit_case(ii).class;
end

[sorted_dist, sorted_index] = sort(feature_dist_class.dist);

if isfield(ptn_info, 'len_Knn')
    k = ptn_info.len_Knn;
else
    k = ceil(sqrt(ptn_info.N));
end

class_likelihood = zeros(ptn_info.total_class, 1);

for ii = 1:1:k
    class_likelihood(feature_dist_class.class(sorted_index(ii)) + 1) = class_likelihood(feature_dist_class.class(sorted_index(ii)) + 1) + 1;
end

max_likelihood = class_likelihood(1);
pattern_identify = ptn_info.class_id(1);

for ii = 2:1:ptn_info.total_class
    if class_likelihood(ii) > max_likelihood
        max_likelihood = class_likelihood(ii);
        pattern_identify = ptn_info.class_id(ii);
    end
end

%classify_output.sorted_dist_class = sorted_dist_class;
classify_output.pattern_identify = pattern_identify;
classify_output.class_likelihood = class_likelihood;