function [matCell ] = rel_batch_pen_digit(astPenDigitCase)


nFiles = length(astPenDigitCase);
matCell(1,1) = {'Config Filename'};
matCell(1,2) = {'Learning time(sec)'};
matCell(1,3) = {'Identify time(sec)'};
matCell(1,4) = {'Failure rate (%)'};

for ff = 1:1:nFiles
    stOutPenIdentify = rel_pen(astPenDigitCase(ff).strConfigFilename);
    stOutPenIdentifyCase(ff).stOutPenIdentify = stOutPenIdentify;
    stIdentifyPassFail = stOutPenIdentify.stIdentifyPassFail;
    cpu_time_learning = stOutPenIdentify.cpu_time_learning;
    identify_time = stOutPenIdentify.identify_time;
    
    identify_fail = stIdentifyPassFail.identify_fail;
    identify_pass = stIdentifyPassFail.identify_pass;
    anTotalCasePerEach = identify_fail + identify_pass;
    for cc = 1:1:length(anTotalCasePerEach)
        afFailurePercent(cc) = identify_fail(cc) / anTotalCasePerEach(cc);
    end
    matCell(ff+1, 1) = {astPenDigitCase(ff).strConfigFilename};
    matCell(ff+1, 2) = {cpu_time_learning};
    matCell(ff+1, 3) = {identify_time};
    
end
for ff = 1:1:nFiles
    stOutPenIdentify = stOutPenIdentifyCase(ff).stOutPenIdentify;
    
    cpu_time_learning = stOutPenIdentify.cpu_time_learning;
    identify_time = stOutPenIdentify.identify_time;
    matCell(ff+1, 2) = {cpu_time_learning};
    matCell(ff+1, 3) = {identify_time};
    
    stIdentifyPassFail = stOutPenIdentify.stIdentifyPassFail;
    identify_fail = stIdentifyPassFail.identify_fail;
    identify_pass = stIdentifyPassFail.identify_pass;
    anTotalCasePerEach = abs(identify_fail) + identify_pass;
    for cc = 1:1:length(anTotalCasePerEach)
        afFailurePercent(cc) = abs(identify_fail(cc)) / anTotalCasePerEach(cc);
        matCell(ff+1, cc+3) = {afFailurePercent(cc)};
    end
end

xlswrite('compare_pen_identify.xls', matCell, 'pen-digitCompare', 'A1');
