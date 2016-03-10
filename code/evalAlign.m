%
% evalAlign
%
%  This is simply the script (not the function) that you use to perform your evaluations in 
%  Task 5. 

% some of your definitions
trainDir     = '/h/u1/cs401/A2_SMT/data/Hansard/Training';
testDir      = '/u/cs401/A2_SMT/data/Hansard/Testing';
fn_LME       = 'fn_LME.mat';
fn_LMF       = 'fn_LMF.mat';
lm_type      = '';
delta        = 0.0;
vocabSize    = 0.0; 
numSentences = 30000;

% Train your language models. This is task 2 which makes use of task 1
LME = lm_train( trainDir, 'e', fn_LME );
LMF = lm_train( trainDir, 'f', fn_LMF );

% Train your alignment model of French, given English 
AMFE = align_ibm1( trainDir, numSentences, 10 );
% ... TODO: more 

% TODO: a bit more work to grab the English and French sentences. 
%       You can probably reuse your previous code for this  
vocabSize = length(LME.uni);

% Decode the test sentence 'fre'
eng = decode( fre, LME, AMFE, 'smooth', delta, vocabSize );

% TODO: perform some analysis
% add BlueMix code here 

[status, result] = unix('')