function [astSampleCase, num_total_cases] = load_demo_2d(strFileFullname, plot_flag)
%
%load demo_2d.txt

demo_2d = load(strFileFullname);

num_total_cases = size(demo_2d, 1);

for ii= 1:1:num_total_cases
    astSampleCase(ii).x = demo_2d(ii, 1);
    astSampleCase(ii).y = demo_2d(ii, 2);
    astSampleCase(ii).class = round(demo_2d(ii, 3));
    astSampleCase(ii).feature = demo_2d(ii, 1:2);
end

if plot_flag >= 2
    figure(20);
    axis([-1 1 -1 1])
    hold on;
    for ii= 1:1:num_total_cases
        if astSampleCase(ii).class == 0
            plot(astSampleCase(ii).x, astSampleCase(ii).y, 'o')
        elseif astSampleCase(ii).class == 1
            plot(astSampleCase(ii).x, astSampleCase(ii).y, '+')
        else
            plot(astSampleCase(ii).x, astSampleCase(ii).y, '?')
        end
    end
    title('demo for 2-d case, non PSD quadratic classifier:  [+, o] <=> class [1, 2]')
end
