function [Model_Ord2] = ptn_construct_model_02(N, dim_feature, x)


%%% Reconsctruct the Model
psd_variable_list = dim_feature + N + 3;
for ii = 1:1:dim_feature
    for jj = 1:1:dim_feature
        Model_Ord2.ModelMatrix(ii, jj) = x(psd_variable_list);
        psd_variable_list = psd_variable_list + 1;
    end
end

Model_Ord2.ModelLinearVec = x(2:dim_feature+1);

Model_Ord2.ModelOffset = x(1);