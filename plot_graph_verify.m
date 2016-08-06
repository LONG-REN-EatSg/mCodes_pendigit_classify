function plot_graph_verify(num_class, num_total_cases, max_appear, pen_digit_case)

ii=1;
num_appear = 0;

strDisp = sprintf('First 16 cases of %d', num_class);
title(strDisp);
hold on;
while ii <= num_total_cases
  
    if pen_digit_case(ii).class == num_class
	 num_appear = num_appear + 1;
	 row_fig = floor((num_appear-1)/4) + 1;
	 col_fig = mod(num_appear - 1, 4) + 1;
	 subplot(4, 4, num_appear);
	 plot(pen_digit_case(ii).x, pen_digit_case(ii).y);
    
    end
    ii = ii + 1;
    if num_appear >= max_appear
        break;
    end
end

