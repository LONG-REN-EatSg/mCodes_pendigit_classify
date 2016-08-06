function [ModelMatrix] = ptn_construct_model(N, dim_feature, x)


%%% Reconsctruct the Model
psd_variable_list = N + 2;
for ii = 1:1:dim_feature
    for jj = 1:1:dim_feature
        ModelMatrix(ii, jj) = x(psd_variable_list);
        psd_variable_list = psd_variable_list + 1;
    end
end
