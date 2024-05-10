function [astSampleCase, num_total_cases] = load_demo_3d(strFileFullname, plot_flag)
%
%load demo_2d.txt

load(strFileFullname);
demo_3d = [test_data_n, test_label; train_data_n, train_label];
num_total_cases = size(demo_3d, 1);

for ii= 1:1:num_total_cases
    astSampleCase(ii).x = demo_3d(ii, 1);
    astSampleCase(ii).y = demo_3d(ii, 2);
    astSampleCase(ii).z = demo_3d(ii, 3);
    astSampleCase(ii).class = round(demo_3d(ii, 4));
    astSampleCase(ii).feature = demo_3d(ii, 1:3);
end

if plot_flag >= 2
    figure(20);
    axis([-1 1 -1 1])
    hold on;
    for ii= 1:1:num_total_cases
        if astSampleCase(ii).class == 0
            plot3(astSampleCase(ii).x, astSampleCase(ii).y, astSampleCase(ii).z, 'o')
        elseif astSampleCase(ii).class == 1
            plot3(astSampleCase(ii).x, astSampleCase(ii).y, astSampleCase(ii).z, '+')
        else
            plot3(astSampleCase(ii).x, astSampleCase(ii).y, astSampleCase(ii).z, '?')
        end
    end
    title('demo for 3-d case, non PSD quadratic classifier:  [+, o] <=> class [1, 2]')
end
