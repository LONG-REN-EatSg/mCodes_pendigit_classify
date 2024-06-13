chdir d:

%% install sedumi
strPath_sedumi_2024 = 'D:\github\sedumi-master\'
addpath(strPath_sedumi_2024);
install_sedumi;

str_Mtool_root = pwd;  % 'E:\zzy\22Q3\Simulation';

addpath(strcat(str_Mtool_root, '\common\cluster'));
addpath(strcat(str_Mtool_root, '\common\formu_solver'));
addpath(strcat(str_Mtool_root, '\common\gauss'));
addpath(strcat(str_Mtool_root, '\common\k_nn'));
addpath(strcat(str_Mtool_root, '\common\linear'));
addpath(strcat(str_Mtool_root, '\common\load_cfg'));
addpath(strcat(str_Mtool_root, '\common\model_constru_verify'));
addpath(strcat(str_Mtool_root, '\common\pca'));
addpath(strcat(str_Mtool_root, '\common\plot'));
addpath(strcat(str_Mtool_root, '\common\quad'));
addpath(strcat(str_Mtool_root, '\common\sdp'));
addpath(strcat(str_Mtool_root, '\common\'));
