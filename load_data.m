function [pen_digit_case, num_total_cases] = load_data()

plot_flag = 2;

load pendigits.tra

num_total_cases = size(pendigits, 1);

for ii= 1:1:num_total_cases
    pen_digit_case(ii).x = pendigits(ii, 1:2:16);
    pen_digit_case(ii).y = pendigits(ii, 2:2:16);
    pen_digit_case(ii).class = pendigits(ii, 17);
    pen_digit_case(ii).feature = pendigits(ii, 1:1:16);
end

if plot_flag >= 2
    num_class = 4;
    max_appear = 16;
    figure(21)
    plot_graph_verify(num_class, num_total_cases, max_appear, pen_digit_case);
    figure(22)
    plot_graph_verify_2(num_total_cases, pen_digit_case);
end
