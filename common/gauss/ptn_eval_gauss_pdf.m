function [prob_density] = ptn_eval_gauss_pdf(class_model, feature)
% feature : row vector
% class_model:
%    feature_mean
%    priori
%    CovarMatrix

feature_len = length(feature);
exp_index = (feature - class_model.feature_mean) * class_model.CovarMatrixInv * (feature - class_model.feature_mean)';
exp_index = -0.5 * exp_index;

factor = (2*pi)^(feature_len/2);
factor = factor * sqrt(abs(class_model.CovarMatrixDet));
factor = 1/factor;

prob_density = factor * exp(exp_index);
