function ptn_plot_error_case_4by4(pattern_identify_list, pen_digit_case, stop_on_error)

error_cases_mod_16 = 0;
total_sample = max(size(pen_digit_case));

for ii = 1:1:total_sample
    if pattern_identify_list(ii) ~= pen_digit_case(ii).class
        if mod(error_cases_mod_16, 16) == 0
            error_cases_mod_16 = 0;
            figure
        end
        subplot(4,4,error_cases_mod_16 + 1);
        plot(pen_digit_case(ii).x, pen_digit_case(ii).y);
        strDisp = sprintf('No. %d: Actual: %d, Recognize: %d', ii, pen_digit_case(ii).class, pattern_identify_list(ii));
        xlabel(strDisp);
        error_cases_mod_16 = error_cases_mod_16 + 1;
        if stop_on_error == 1
            key_cmd = input('Input 0 to continue without stop');
        end
        if key_cmd == 0 
            stop_on_error = 0;
        end
    end
end