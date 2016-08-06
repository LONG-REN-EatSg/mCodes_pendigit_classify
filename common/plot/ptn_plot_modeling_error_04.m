function ptn_plot_modeling_error_04(x, dim_feature, N, remain_error)


subplot(2,1,1);
plot(x(dim_feature + 2 + dim_feature*dim_feature:1:dim_feature + 2 + dim_feature*dim_feature + N))
title('Verification by the modelling samples')
xlabel('Sample Count');
ylabel('Modeling Error');

subplot(2,1,2);
plot(remain_error);
title('Verification by the remaining samples')
xlabel('Sample Count');
ylabel('Modeling Error');
