function ptn_plot_modeling_error_03(x, dim_feature, N, remain_error)


subplot(2,1,1);
plot(x(dim_feature + 2:1:dim_feature + N+1))
title('Verification by the modelling samples')
xlabel('Sample Count');
ylabel('Modeling Error');

subplot(2,1,2);
plot(remain_error);
title('Verification by the remaining samples')
xlabel('Sample Count');
ylabel('Modeling Error');
