function ptn_plot_likelihood(astSampleCase, class_model, model_linear, ptn_info, iFigId)

nTotalClass = round(ptn_info.total_class);
anFactor = factor(nTotalClass);
nFactors = length(anFactor);
if nFactors == 1
    nNumRow = ceil(sqrt(ptn_info.total_class));
    nNumCol = ceil(ptn_info.total_class/nNumRow);
elseif nFactors == 2
    nNumRow = anFactor(1);
    nNumCol = anFactor(2);
else
    nNumRow = 1;
    for ii = 1:1:floor(nFactors/2)
        nNumRow = nNumRow * nFactors( 2 * ii);
    end
    nNumCol = nTotalClass/nNumRow;
end

if ptn_info.model_option == 4 | ptn_info.model_option == 9 | ptn_info.model_option == 10
    figure(iFigId);
    for ii = 1:1:ptn_info.total_class
        subplot(nNumRow,nNumCol, ii);
        ptn_plot_likelehood_quad2(astSampleCase, class_model(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
        grid on;
    end
elseif ptn_info.model_option == 20 | ptn_info.model_option == 25 | ptn_info.model_option == 26
    figure(iFigId);
    for ii = 1:1:ptn_info.total_class
        subplot(nNumRow,nNumCol, ii);
        ptn_plot_likelehood_quad2(astSampleCase_pca, class_model(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
        grid on;
    end
elseif ptn_info.model_option == 5
    figure(iFigId);
    for ii = 1:1:ptn_info.total_class
        subplot(nNumRow,nNumCol, ii);
        ptn_plot_likelehood_linear(astSampleCase, model_linear(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
        grid on;
    end
elseif ptn_info.model_option == 21
    figure(iFigId);
    for ii = 1:1:ptn_info.total_class
        subplot(nNumRow,nNumCol, ii);
        ptn_plot_likelehood_linear(astSampleCase_pca, model_linear(ii), ptn_info);
        strTitle = sprintf('L_%d(feature): for class %d', ii - 1, ii - 1);
        title(strTitle);
        grid on;
    end
elseif ptn_info.model_option == 8
    figure(iFigId);
    for ii = 1:1:ptn_info.total_class
        subplot(nNumRow,nNumCol, ii);
        ptn_plot_likelehood_gauss_pdf(astSampleCase, class_model(ii), ptn_info);
        strTitle = sprintf('Value: L_%d(feature): for class %d', ii - 1, ii - 1);
        ylabel(strTitle);
        grid on;
    end
elseif ptn_info.model_option == 24
    figure(iFigId);
    for ii = 1:1:ptn_info.total_class
        subplot(nNumRow,nNumCol, ii);
        ptn_plot_likelehood_gauss_pdf(astSampleCase_pca, class_model(ii), ptn_info);
        strTitle = sprintf('Value: L_%d(feature): for class %d', ii - 1, ii - 1);
        ylabel(strTitle);
    end
else
end
