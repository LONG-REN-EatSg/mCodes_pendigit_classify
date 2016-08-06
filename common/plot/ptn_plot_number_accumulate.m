function ptn_plot_number_accumulate(pen_digit_case, N, pattern_identify)
% ptn_plot_number_accumulate(pen_digit_case, N, pattern_identify)
%  pen_digit_case:   an array of struct including the trianing data and expected class
%     x: x coordinate
%     y: y coordinate
%     class:  expected class
%     feature: [x1, y1] ... [x8, y8]
% N:     total number of samples
% pattern_identify: Actual identified pattern output by the model.
%     
axis([-5, 15, -6, 6]);
hold;
grid on
for ii = 1:1:N
    strText = num2str(pen_digit_case(ii).class);
    text(pattern_identify(ii), rand(1,1)*5 - 2.5, strText);
    xlabel('recognition class');
    strText = sprintf('total samples: %d', N);
    ylabel(strText);
    title('Actual calss number is displayed on each location, with random y-cordinate');
end
