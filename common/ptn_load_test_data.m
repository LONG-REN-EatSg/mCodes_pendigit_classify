function [pen_digit_test, num_total_test] = ptn_load_test_data()

load pendigits.tes

num_total_test = size(pendigits, 1);

for ii= 1:1:num_total_test
    pen_digit_test(ii).x = pendigits(ii, 1:2:16);
    pen_digit_test(ii).y = pendigits(ii, 2:2:16);
    pen_digit_test(ii).class = pendigits(ii, 17);
    pen_digit_test(ii).feature = pendigits(ii, 1:1:16);
end
