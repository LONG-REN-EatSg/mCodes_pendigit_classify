function [identify_pass, identify_fail] = ptn_plot_identify_pass_fail(ipf_config,  samples_1d_list, pen_digit_case)

%% Pass 
N = length(samples_1d_list);
ipf_class_list = ipf_config.ipf_class_list;
ipf_total_class = ipf_config.ipf_total_class;

identify_pass = zeros(ipf_total_class, 1);
identify_fail = zeros(ipf_total_class, 1);
x_range(1:2: ipf_total_class*2) = ipf_class_list;
x_range(2:2: ipf_total_class*2) = ipf_class_list + 0.1;
for ii = 1:1:N
    class_int = round(samples_1d_list(ii));
    if class_int == pen_digit_case(ii).class;
        identify_pass(pen_digit_case(ii).class + 1) = identify_pass(pen_digit_case(ii).class + 1) + 1;
    else
        identify_fail(pen_digit_case(ii).class + 1) = identify_fail(pen_digit_case(ii).class + 1) - 1;
    end
end
identify_pass_fail(1:2: ipf_total_class*2) = identify_pass;
identify_pass_fail(2:2: ipf_total_class*2) = identify_fail;
hold on;
for ii = 1:1: 2*ipf_total_class
    if identify_pass_fail(ii) > 0 
        plot([x_range(ii), x_range(ii)], [0, identify_pass_fail(ii)], 'g-');
        strText = sprintf('P: %d', identify_pass_fail(ii));
        text(x_range(ii), identify_pass_fail(ii), strText);
    else
        plot([x_range(ii), x_range(ii)], [0, identify_pass_fail(ii)], 'r*');
        strText = sprintf('F: %d', identify_pass_fail(ii));
        text(x_range(ii), identify_pass_fail(ii), strText);
    end
end
total_fail_percent = abs(sum(identify_fail))/N;
str_label = sprintf('+: Pass, -: Fail. Total fail percent / Total Sample: %4.3f%% / %d', total_fail_percent * 100, N);
ylabel(str_label);
xlabel('Class ID');


