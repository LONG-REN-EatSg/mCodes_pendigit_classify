function ptn_plot_proba_dens_func(pdf_config,  samples_1d_list)

N = length(samples_1d_list);
low_bound_pdf = pdf_config.low_bound_pdf;
upp_bound_pdf = pdf_config.upp_bound_pdf;
length_pdf = pdf_config.length_pdf;

probability_density_func = zeros(length_pdf, 1);
x_range = linspace(low_bound_pdf, upp_bound_pdf, length_pdf);
x_delta = (upp_bound_pdf - low_bound_pdf)/(length_pdf - 1)
for ii = 1:1:N
    class_float = (samples_1d_list(ii) - low_bound_pdf) / x_delta;
    class_int = round(class_float);
    if class_int > 1 & class_int <length_pdf
        probability_density_func(class_int) = probability_density_func(class_int) + 1;
    end
end
probability_density_func = probability_density_func/N;
plot(x_range, probability_density_func)
