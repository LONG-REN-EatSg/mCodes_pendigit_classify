function [Model_Ord2] = ptn_construct_model_05(N, dim_feature, x)


%%% Reconsctruct the Model
psd_variable_list = 2;
for ii = 1:1:dim_feature
    for jj = 1:1:dim_feature
        Model_Ord2.ModelMatrix(ii, jj) = x(psd_variable_list);
        psd_variable_list = psd_variable_list + 1;
    end
end

para_1st_start_index = 1 + dim_feature * dim_feature + 2 * N + 1;
Model_Ord2.ModelLinearVec = x(para_1st_start_index + 1: para_1st_start_index+ dim_feature);

Model_Ord2.ModelOffset = x(1);