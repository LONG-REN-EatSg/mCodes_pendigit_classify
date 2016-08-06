function ptn_plot_likelehood_gauss_pdf(pen_digit_case, class_model, ptn_info)
%
%
%

total_size = max(size(pen_digit_case));
for ii = 1:1:ptn_info.N
    likelihood(ii) = ptn_eval_gauss_pdf(class_model, pen_digit_case(ii).feature);
    likelihood(ii) = likelihood(ii) * class_model.priori;
end
size(likelihood);
y_min = min(likelihood);
y_max = max(likelihood);
x_max = ptn_info.N +1;
axis([-1, x_max, y_min, y_max]);
hold on;
xlabel('sample id')

for ii = 1:1:ptn_info.N
    strText = sprintf('%d', pen_digit_case(ii).class);
    text(ii, likelihood(ii), strText);
end    