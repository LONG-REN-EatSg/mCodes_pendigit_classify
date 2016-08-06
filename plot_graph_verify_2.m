function plot_graph_verify_2(num_total_cases, pen_digit_case)

ii=1;
num_appear = 0;

strDisp = sprintf('some cases of 10 digits');
title(strDisp);
hold on;

num_appear = zeros(10, 1);
while ii <= num_total_cases
  
    num_class = pen_digit_case(ii).class + 1;
    num_appear(num_class) = num_appear(num_class) + 1;
    subplot(2, 5, num_class);
    plot(pen_digit_case(ii).x, pen_digit_case(ii).y);
    
    ii = ii + 1;
    least_num_appear = min(num_appear);
    if least_num_appear >= 1
        break;
    end
end
