close all;

strPath = pwd;

rel_pen([strPath, '\N=5000_ptn_config_QuadProgramming_sedumi.ini']);

rel_pen([strPath, '\ptn_config_QuadProgramming_sedumi_N=1000.ini']);

rel_pen([strPath, '\ptn_config_GaussianBayes.ini']);

stOutPenIdentify = rel_pen('N=5000_ptn_config_neural_network_LVQ_20Layer_Iter100_Rate0d001.ini');
stOutPenIdentify = rel_pen('ptn_config_GaussianBayes.ini');
stOutPenIdentify = rel_pen('ptn_config_QuadProgramming_sedumi_N=1000.ini');