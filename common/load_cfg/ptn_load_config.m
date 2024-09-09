function [ptn_info] = ptn_load_config(strFileFullName)
%% 2024July9 Add neural network

strConstFeatureScaleFactor      = 'FEATURE_SCALE_FACTOR';
strConstClassScaleFactor        = 'CLASS_SCALE_FACTOR';
strConstClassScaleOffset        = 'CLASS_SCALE_OFFSET';
strConstModelOption             = 'MODEL_OPTION';
strConstLearningSample          = 'LEARNING_SAMPLE';
strConstSolverSedumiMaxIter     = 'SOLVER_SEDUMI_MAX_ITER';
strConstSolverSedumiBigEps      = 'SOLVER_SEDUMI_BIG_EPS';
strConstQuad2ModelPenalty       = 'MODEL_QUAD2_PENALTY';
strConstTotalClass              = 'TOTAL_CLASS';
strConstKesslerRo               = 'KESSLER_STEP_SIZE';
strConstNeuralLayer             = 'NEURAL_LAYER';  %% default = 20;
strConstNeuralMaxIteration      = 'MAX_ITER';      %% default = 1000;
strConstNeuralLearnRate         = 'NEURAL_LEARN_RATE';  %% default = 0.01;

lenConstFeatureScaleFactor = length(strConstFeatureScaleFactor);
lenConstClassScaleFactor = length(strConstClassScaleFactor);
lenConstClassScaleOffset = length(strConstClassScaleOffset);
lenConstModelOption = length(strConstModelOption);
lenConstLearningSample = length(strConstLearningSample);
lenConstSolverSedumiMaxIter = length(strConstSolverSedumiMaxIter);
lenConstSolverSedumiBigEps = length(strConstSolverSedumiBigEps);
lenConstQuad2ModelPenalty = length(strConstQuad2ModelPenalty);
lenConstTotalClass = length(strConstTotalClass);
lenConstKesslerRo = length(strConstKesslerRo);
lenConstNeuralLayer = length(strConstNeuralLayer);             %= 'NEURAL_LAYER';  %% default = 20;
lenConstNeuralMaxIteration = length(strConstNeuralMaxIteration);                 %= 'MAX_ITER';      %% default = 1000;
lenConstNeuralLearnRate = length(strConstNeuralLearnRate);         % = 'NEURAL_LEARN_RATE';  %% default = 0.01;

%% default parameters
ptn_info.penalty = 20;
ptn_info.scale_feature_factor = 100;
ptn_info.scale_factor = 1;
ptn_info.scale_offset = 0;

%% add neural network
ptn_info.fNeuralLearnRate = 0.1;
ptn_info.nNeuralLayer = 10;
ptn_info.nNeuralMaxIteration = 100;

if ~exist('strFileFullName')
    disp('Input the data file --- *.*');
    [Filename, Pathname] = uigetfile('*.ini', 'Pick an Text file as Pen Digits Identify Parameters');
    strFileFullName = strcat(Pathname , Filename);
end

fptr = fopen(strFileFullName, 'r');
ctnstk_name_label.fptr = fptr;

strLine = fgets(fptr);

while(~feof(fptr))
   strLine = sprintf('%sMINIMIMLENGTH_TO_BE_COMPATIBLE_WITH_READER', strLine);
   if strLine(1) == '%'
       strLine = fgets(fptr);
   else
       if strLine(1:lenConstFeatureScaleFactor) == strConstFeatureScaleFactor
           ptn_info.scale_feature_factor = sscanf(strLine((lenConstFeatureScaleFactor + 1): end), ' = %f');
       elseif strLine(1:lenConstNeuralLayer) == strConstNeuralLayer
           ptn_info.nNeuralLayer = sscanf(strLine((lenConstNeuralLayer + 1): end), ' = %d');
        % ConstNeuralMaxIteration
       elseif  strLine(1:lenConstNeuralMaxIteration) == strConstNeuralMaxIteration
           ptn_info.nNeuralMaxIteration = sscanf(strLine((lenConstNeuralMaxIteration + 1): end), ' = %d');
         
       % ConstNeuralLearnRate
       elseif  strLine(1:lenConstNeuralLearnRate) == strConstNeuralLearnRate
           ptn_info.fNeuralLearnRate = sscanf(strLine((lenConstNeuralLearnRate + 1): end), ' = %f');
           
       elseif strLine(1:lenConstClassScaleFactor) == strConstClassScaleFactor
           ptn_info.scale_factor = sscanf(strLine((lenConstClassScaleFactor + 1): end), ' = %f');
       elseif strLine(1:lenConstClassScaleOffset) == strConstClassScaleOffset
           ptn_info.scale_offset = sscanf(strLine((lenConstClassScaleOffset + 1): end), ' = %f');
       elseif strLine(1:lenConstQuad2ModelPenalty) == strConstQuad2ModelPenalty
           ptn_info.penalty = sscanf(strLine((lenConstQuad2ModelPenalty + 1): end), ' = %f');
       elseif strLine(1:lenConstLearningSample) == strConstLearningSample
           ptn_info.N = sscanf(strLine((lenConstLearningSample + 1): end), ' = %f');
       elseif strLine(1:lenConstSolverSedumiMaxIter) == strConstSolverSedumiMaxIter
           ptn_info.algo_max_iter = sscanf(strLine((lenConstSolverSedumiMaxIter + 1): end), ' = %f');
       elseif strLine(1:lenConstSolverSedumiBigEps) == strConstSolverSedumiBigEps
           ptn_info.algo_bigeps = sscanf(strLine((lenConstSolverSedumiBigEps + 1): end), ' = %f');
       elseif strLine(1:lenConstModelOption) == strConstModelOption
           ptn_info.model_option = sscanf(strLine((lenConstModelOption + 1): end), ' = %f');
       elseif strLine(1:lenConstTotalClass) == strConstTotalClass
           ptn_info.total_class = sscanf(strLine((lenConstTotalClass + 1): end), ' = %d');
       elseif strLine(1:lenConstKesslerRo) == strConstKesslerRo
%           strLine(1:lenConstKesslerRo)
           ptn_info.kessler_ro = sscanf(strLine((lenConstKesslerRo + 1): end), ' = %f');
       end
       strLine = fgets(fptr);
   end
end

fclose(fptr);