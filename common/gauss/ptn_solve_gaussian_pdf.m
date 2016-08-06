function [class_model] = ptn_solve_gaussian_pdf(pen_digit_case, ptn_info)
%
%
%

Priori = zeros(ptn_info.total_class, 1);
for ii = 1:1:ptn_info.N
    Priori(pen_digit_case(ii).class + 1) = Priori(pen_digit_case(ii).class + 1) + 1;
end

size_feature = size(pen_digit_case(1).feature);
for cc = 1:1:ptn_info.total_class
    feature_sum = zeros(size_feature);
    for ii = 1:1:ptn_info.N
        if pen_digit_case(ii).class == cc - 1
            feature_sum = feature_sum + pen_digit_case(ii).feature;
        end
    end
    class_model(cc).feature_mean = feature_sum/Priori(cc);
    class_model(cc).priori = Priori(cc);
    class_model(cc).class_id = cc - 1;
end

feature_len = length(pen_digit_case(1).feature);

for cc = 1:1:ptn_info.total_class
    CorvarMatrix = zeros(feature_len, feature_len);
    for ii = 1:1:ptn_info.N
        if pen_digit_case(ii).class == cc - 1
            CorvarMatrix = CorvarMatrix + ...
                (pen_digit_case(ii).feature - class_model(cc).feature_mean)'*(pen_digit_case(ii).feature - class_model(cc).feature_mean);
        end
    end
    class_model(cc).CovarMatrix = CorvarMatrix/(Priori(cc) - 1);
    [U_svd,S_svd,V_svd] = svd(class_model(cc).CovarMatrix);
    for ii = 1:1:feature_len
        if S_svd(ii, ii) ~= 0
            S_svd_inv(ii, ii) = 1/S_svd(ii, ii);
        else
            S_svd_inv(ii, ii) = 0;
        end
    end
%    class_model(cc).CovarMatrixInv = inv(class_model(cc).CovarMatrix);
%    class_model(cc).CovarMatrixDet = det(class_model(cc).CovarMatrix);

    class_model(cc).CovarMatrixInv =  V_svd * S_svd_inv *U_svd';
    
    class_model(cc).CovarMatrixDet = 1;
    for ii = 1:1:feature_len
        if S_svd(ii, ii) ~= 0
            class_model(cc).CovarMatrixDet = class_model(cc).CovarMatrixDet * S_svd(ii, ii);
        end
    end

end
