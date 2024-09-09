close all;

strPath = pwd;

rel_pen([strPath, '\N=5000_ptn_config_QuadProgramming_sedumi.ini']);

rel_pen([strPath, '\ptn_config_QuadProgramming_sedumi_N=1000.ini']);

rel_pen([strPath, '\ptn_config_GaussianBayes.ini']);

stOutPenIdentify = rel_pen('N=5000_ptn_config_neural_network_LVQ_20Layer_Iter100_Rate0d001.ini');
stOutPenIdentify = rel_pen('ptn_config_GaussianBayes.ini');
stOutPenIdentify = rel_pen('ptn_config_QuadProgramming_sedumi_N=1000.ini');

astPenDigitCase(1).strConfigFilename = ([strPath, '\N=5000_ptn_config_neural_network_LVQ_20Layer_Iter100_Rate0d001.ini']);
astPenDigitCase(2).strConfigFilename = ([strPath, '\ptn_config_GaussianBayes.ini']);
astPenDigitCase(3).strConfigFilename = ([strPath, '\N=1000_ptn_config_GaussianBayes_.ini']);
astPenDigitCase(4).strConfigFilename = ([strPath, '\N=2000_ptn_config_GaussianBayes_.ini']);
astPenDigitCase(5).strConfigFilename = ([strPath, '\N=1000_ptn_config_neural_network_LVQ_5Layer_Iter1000_Rate0d01.ini']);
astPenDigitCase(6).strConfigFilename = ([strPath, '\N=2000_ptn_config_neural_network_20Layer_Iter100_Rate0d1.ini']);

rel_batch_pen_digit(astPenDigitCase);