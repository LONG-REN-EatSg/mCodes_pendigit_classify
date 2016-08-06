function [ptn_cluster_solution, new_cluster_mean] = ptn_cluster_basic_k_means(ptn_info, pen_digit_case)
%
%

EPSLON = 0.001;
Total_Iter = 100;
figure_id = 1;

cluster_size = ceil(ptn_info.N / ptn_info.total_class);
remain_sample_starting_index = 1;
total_num_assigned_sample = 0;
for cc = 1:1:ptn_info.total_class
    total_num_assigned_sample = total_num_assigned_sample + cluster_size;
    if total_num_assigned_sample <= ptn_info.N
        ptn_cluster_solution.cluster_set(cc).total_sample = cluster_size;
        ptn_cluster_solution.cluster_set(cc).sample_set = [remain_sample_starting_index: (remain_sample_starting_index + cluster_size - 1)];
        remain_sample_starting_index = remain_sample_starting_index + cluster_size;
    else
        ptn_cluster_solution.cluster_set(cc).sample_set = [remain_sample_starting_index: ptn_info.N];
        ptn_cluster_solution.cluster_set(cc).total_sample = length(ptn_cluster_solution.cluster_set(cc).sample_set);
    end
    
    for jj = 1:1:ptn_cluster_solution.cluster_set(cc).total_sample
        ptn_cluster_solution.sample_id_set(ptn_cluster_solution.cluster_set(cc).sample_set(jj)).cluster_id = cc;
    end
    
    sum_feature = zeros(1, ptn_info.dim_feature);
    for jj = 1:1:ptn_cluster_solution.cluster_set(cc).total_sample
        sum_feature = sum_feature + pen_digit_case(ptn_cluster_solution.cluster_set(cc).sample_set(jj)).feature;
    end
    ptn_cluster_solution.cluster_set(cc).cluster_mean = sum_feature/ptn_cluster_solution.cluster_set(cc).total_sample;

end

iter = 0;
while iter <= Total_Iter
    %%%% initialize memory
    for cc = 1:1:ptn_info.total_class
        ptn_cluster_solution.cluster_set(cc).total_sample = 0;
        ptn_cluster_solution.cluster_set(cc).sample_set = [];
    end
    %%%% recluster according to the current cluster_mean
    for jj = 1:1:ptn_info.N
        min_dist = inf;
        for cc = 1:1:ptn_info.total_class
            dist_current_sample_cluster(cc) = norm(pen_digit_case(jj).feature - ptn_cluster_solution.cluster_set(cc).cluster_mean);
            if min_dist > dist_current_sample_cluster(cc)
                min_dist = dist_current_sample_cluster(cc);
                min_index = cc;
            end
        end
        if min_index ~= ptn_cluster_solution.sample_id_set(jj).cluster_id
            min_index;
            ptn_cluster_solution.sample_id_set(jj).cluster_id;
        end
        ptn_cluster_solution.sample_id_set(jj).cluster_id = min_index;
        ptn_cluster_solution.cluster_set(min_index).total_sample = ptn_cluster_solution.cluster_set(min_index).total_sample + 1;
        ptn_cluster_solution.cluster_set(min_index).sample_set(ptn_cluster_solution.cluster_set(min_index).total_sample) = jj;
    end
    for cc = 1:1:ptn_info.total_class
        class_total_sample(cc) = ptn_cluster_solution.cluster_set(cc).total_sample;
    end
    class_total_sample
    %%%% recompute the means of new cluster
    for cc = 1:1:ptn_info.total_class
        sum_feature = zeros(1, ptn_info.dim_feature);
        for jj = 1:1:ptn_cluster_solution.cluster_set(cc).total_sample
            sum_feature = sum_feature + pen_digit_case(ptn_cluster_solution.cluster_set(cc).sample_set(jj)).feature;
        end
        new_cluster_mean(cc).vector = sum_feature/ptn_cluster_solution.cluster_set(cc).total_sample;
    end
    
    %%%% compare new_cluster_mean and existing mean
    sum_dist_mean = 0;
    for cc = 1:1:ptn_info.total_class
        sum_dist_mean = sum_dist_mean + norm(new_cluster_mean(cc).vector - ptn_cluster_solution.cluster_set(cc).cluster_mean);
    end
    
    if sum_dist_mean <= EPSLON
        sum_dist_mean
        break;
    else
        for cc = 1:1:ptn_info.total_class
            ptn_cluster_solution.cluster_set(cc).cluster_mean = new_cluster_mean(cc).vector;
        end
        iter = iter + 1;
    end

    if rem(iter, 100) == 1
        iter
        figure(figure_id);
        hold off;
        ptn_plot_cluster(ptn_info, pen_digit_case, ptn_cluster_solution, figure_id);
    end
    
end

figure(2);
ptn_plot_cluster(ptn_info, pen_digit_case, ptn_cluster_solution, 2);
