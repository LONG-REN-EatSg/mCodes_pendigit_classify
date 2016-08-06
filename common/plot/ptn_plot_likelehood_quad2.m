function ptn_plot_likelehood_quad2(pen_digit_case, class_model_quad2, ptn_info)
% ptn_plot_likelehood_quad2(pen_digit_case, class_model_quad2, ptn_info)
%
%  pen_digit_case:   an array of struct including the trianing data and expected class
%     x: x coordinate
%     y: y coordinate
%     class:  expected class
%     feature: [x1, y1] ... [x8, y8]
%  class_model_quad2: a struct, include 2nd order Cone Model and expected  class-id
%     class_id
%     Model_Ord2: a struct of 2nd order cone model
%        ModelMatrix: [16x16 double]
%        ModelLinearVec: [16x1 double]
%        ModelOffset: scalor
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

total_size = max(size(pen_digit_case));
for ii = 1:1:ptn_info.N
    likelihood(ii) = pen_digit_case(ii).feature * class_model_quad2.Model_Ord2.ModelMatrix * pen_digit_case(ii).feature'/ptn_info.scale_feature_factor/ptn_info.scale_feature_factor + ...
            pen_digit_case(ii).feature *class_model_quad2.Model_Ord2.ModelLinearVec/ptn_info.scale_feature_factor + class_model_quad2.Model_Ord2.ModelOffset;
end
size(likelihood);
y_min = min(likelihood)-1;
y_max = max(likelihood)+1;
x_max = ptn_info.N +1;
axis([-1, x_max, y_min, y_max]);
hold on;
xlabel('sample id')
ylabel('Likelihood function value');

for ii = 1:1:ptn_info.N
    strText = sprintf('%d', pen_digit_case(ii).class);
    text(ii, likelihood(ii), strText);
end    