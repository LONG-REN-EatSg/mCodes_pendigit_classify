function ptn_plot_likelehood_linear(pen_digit_case, model_linear, ptn_info)
% ptn_plot_likelehood_quad2(pen_digit_case, class_model_quad2, ptn_info)
%
%  pen_digit_case:   an array of struct including the trianing data and expected class
%     x: x coordinate
%     y: y coordinate
%     class:  expected class
%     feature: [x1, y1] ... [x8, y8]
%  model_linear: a struct, include 2nd order Cone Model and expected  class-id
%     model_linear.class_id
%     model_linear.factor
%     model_linear.offset
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
    likelihood(ii) = pen_digit_case(ii).feature * model_linear.factor + model_linear.offset;
end
size(likelihood);
y_min = min(likelihood)-1;
y_max = max(likelihood)+1;
x_max = ptn_info.N +1;
axis([-1, x_max, y_min, y_max]);
hold on;
xlabel('sample id')
ylabel('Likelyhood function value');

for ii = 1:1:ptn_info.N
    strText = sprintf('%d', pen_digit_case(ii).class);
    text(ii, likelihood(ii), strText);
end    