function ptn_plot_cluster(ptn_info, pen_digit_case, ptn_cluster_solution, figure_id)
%
%
%

iFlagHoldOn = 1;

axis([-1, ptn_info.total_class + 2, -1, 10]);
for cc = 1:1:ptn_info.total_class
    for ii = 1:1:ptn_cluster_solution.cluster_set(cc).total_sample
        strText = sprintf('%d', pen_digit_case(ptn_cluster_solution.cluster_set(cc).sample_set(ii)).class);
        rand2number = rand(1,2);
        xx = rand2number(1) * 0.8 - 0.4 + cc;
        yy = rand2number(2) * 5;
        text(xx, yy, strText);

        if iFlagHoldOn == 1
            hold on;
            iFlagHoldOn = 0;
        end

        strText = sprintf('%d', ptn_cluster_solution.cluster_set(cc).total_sample);
        xx = cc;
        yy = 6;
        text(xx, yy, strText);
    end
end

xlabel('Cluser ID');
ylabel('Total number of samples of each cluster, and actual samples');
hold off;