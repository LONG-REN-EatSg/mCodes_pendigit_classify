function ptn_plot_1_likelihood_quad2(pen_digit_case,  sample_id, ptn_info, class_model)

max_likelihood = -inf
for jj = 1:1:10
    likelihood_class(jj) = pen_digit_case(sample_id).feature * class_model(jj).Model_Ord2.ModelMatrix * pen_digit_case(sample_id).feature'/ptn_info.scale_feature_factor/ptn_info.scale_feature_factor + ...
            pen_digit_case(sample_id).feature *class_model(jj).Model_Ord2.ModelLinearVec/ptn_info.scale_feature_factor + class_model(jj).Model_Ord2.ModelOffset;
    if likelihood_class(jj) > max_likelihood
        max_likelihood = likelihood_class(jj);
        pattern_identify_by_quad2 = class_model(jj).class_id;
    end
end
subplot(2,1,1);
plot(pen_digit_case(sample_id).x, pen_digit_case(sample_id).y);
strText = sprintf('Sample Feature, expected class: %d', pen_digit_case(sample_id).class);
title(strText);
subplot(2,1,2);
plot([0:1:9], likelihood_class)
hold on;
plot(pattern_identify_by_quad2, max_likelihood, 'b*')
grid on;
xlabel('class id')
strText = sprintf('Likelihood function values per class for sample %d', sample_id);
ylabel(strText)
if pattern_identify_by_quad2 == pen_digit_case(sample_id).class
    strText = sprintf('SUCCESS identified sample, identified class: %d', pattern_identify_by_quad2);
    title(strText);
else
    strText = sprintf('FAILURE identified sample, identified class: %d', pattern_identify_by_quad2);
    title(strText);
end
