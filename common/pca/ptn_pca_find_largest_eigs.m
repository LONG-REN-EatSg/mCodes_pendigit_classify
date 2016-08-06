function [ptn_pca_output] = ptn_pca_find_largest_eigs(pen_digit_case, ptn_info)
%
%
%
%

plot_flag = 3;

size_feature = size(pen_digit_case(1).feature);
feature_sum = zeros(size_feature);
for ii = 1:1:ptn_info.N
    feature_sum = feature_sum + pen_digit_case(ii).feature;
end

feature_mean = feature_sum/ptn_info.N;

% pen_digit_case(1).feature is a row vector
feature_len = length(pen_digit_case(1).feature);
CorvarMatrix = zeros(feature_len, feature_len);


for ii = 1:1:ptn_info.N
    CorvarMatrix = CorvarMatrix + (pen_digit_case(ii).feature - feature_mean)' * (pen_digit_case(ii).feature - feature_mean);
end

feature_len = length(pen_digit_case(1).feature);
[eig_vector_list, D] = eig(CorvarMatrix);
for ii = 1:1:feature_len
    eig_list_corvar(ii, 1) = D(ii, ii);
end

sum_eigens = sum(eig_list_corvar);

for dd = 1:1:feature_len
    eig_level = 1 - sum(eig_list_corvar(1:dd))/sum_eigens;
    if eig_level <= ptn_info.pca_level
        break;
    end
end
minor_dim = dd - 1;
pca_level = 1 - sum(eig_list_corvar(1:minor_dim))/sum_eigens;
pca_dim_list = (minor_dim + 1):feature_len;
pca_dim = feature_len - minor_dim;

for dd = 1:1:pca_dim
    PrincipalVectorList(:, dd) = eig_vector_list(:, pca_dim_list(dd));
end

for dd = 1:1:pca_dim
    vector = PrincipalVectorList(:, dd);
    PrincipalFeatureList(dd).x = vector(1:2:feature_len);
    PrincipalFeatureList(dd).y = vector(2:2:feature_len);
end

num_total_samples = length(pen_digit_case);
for ii = 1:1:num_total_samples
    pen_digit_case_pca(ii).feature = pen_digit_case(ii).feature * PrincipalVectorList;
    pen_digit_case_pca(ii).class = pen_digit_case(ii).class;
end

ptn_pca_output.eig_list_corvar = eig_list_corvar; 
ptn_pca_output.CorvarMatrix = CorvarMatrix; 
ptn_pca_output.PrincipalVectorList = PrincipalVectorList; 
ptn_pca_output.pca_dim_list = pca_dim_list;
ptn_pca_output.pen_digit_case_pca = pen_digit_case_pca;
ptn_pca_output.PrincipalFeatureList = PrincipalFeatureList;

if plot_flag >= 2
    figure(91);
    sub_fig_col = 3;
    sub_fig_row = pca_dim/sub_fig_col;
    for dd = 1:1:pca_dim
        subplot(sub_fig_row, sub_fig_col, pca_dim - dd +1);
        plot(PrincipalFeatureList(dd).x, PrincipalFeatureList(dd).y);
        strText = sprintf('%dst Pricipal Vector', dd);
        title(strText);
    end
end