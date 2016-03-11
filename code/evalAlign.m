%
% evalAlign
%
%  This is simply the script (not the function) that you use to perform your evaluations in 
%  Task 5. 

% some of your definitions
trainDir     = '/h/u1/cs401/A2_SMT/data/Hansard/Training';
testDir      = '/u/cs401/A2_SMT/data/Hansard/Testing';
testFileFrench = [testDir, '/Task5.f'];
testFileRef_1 = [testDir, '/Task5.e'];
testFileRef_2 = [testDir, '/Task5.google.e'];
fn_LME       = 'fn_LME.mat';
fn_LMF       = 'fn_LMF.mat';
lm_type      = '';
delta        = 0.0;
vocabSize    = 0.0; 
numSentences = 30000;
N = 3;

% Train your language models. This is task 2 which makes use of task 1
% LME = lm_train( trainDir, 'e', fn_LME );
% LMF = lm_train( trainDir, 'f', fn_LMF );
LME = load('LM_e.mat');
LME = LME.LM;
LMF = load('LM_f.mat');
LMF = LMF.LM;

% Train your alignment model of French, given English 
% AMFE = align_ibm1( trainDir, numSentences, 10 );
AMFE = load('AM_30000_10.mat');
AMFE = AMFE.AM;
% ... TODO: more 

% TODO: a bit more work to grab the English and French sentences. 
%       You can probably reuse your previous code for this  
vocabSize = length(LME.uni);

fres = textread(testFileFrench, '%s','delimiter','\n');
candidates_1 = textread(testFileRef_1, '%s','delimiter','\n');
candidates_2 = textread(testFileRef_2, '%s','delimiter','\n');

% Decode the test sentence 'fre'

% TODO: perform some analysis
% add BlueMix code here 
for l = 1:length(fres)
    fre =  preprocess(fres{l}, 'f');
    candidate = decode2(fre, LME, AMFE, lm_type, delta, vocabSize);
    candidate = strsplit(' ', candidate);
    candidate = candidate(2:length(candidate) - 1);
    can_length = length(candidate);

    eng_ref_1 = preprocess(candidates_1{l}, 'e');
    eng_ref_2 = preprocess(candidates_2{l}, 'e');
    [status, eng_ref_3] = unix(['env LD_LIBRARY_PATH='''' curl -u {8d809b19-c13e-4d69-ac11-7cd07d78b601}:{gy9MnOXvGje9} -X POST -F text=''', fre, ''' -F source=fr -F target=en https://gateway.watsonplatform.net/language-translation/api/v2/translate']);
    eng_ref_3 = preprocess(eng_ref_3, 'e');

    p = [];
    for n = 1:N
        num_of_grams = can_length - n + 1;
        match_count = 0;
        for i = 1:num_of_grams
            gram_candidate = strjoin(candidate(i:i + n - 1), ' ');
            match_count = match_count + (~isempty(findstr(eng_ref_1, gram_candidate)) || ~isempty(findstr(eng_ref_2, gram_candidate)) || ~isempty(findstr(eng_ref_3, gram_candidate)));
        end
        p{n} = match_count / num_of_grams;
    end

    eng_ref_1 = strsplit(' ', eng_ref_1);
    eng_ref_1 = eng_ref_1(2:length(eng_ref_1) - 1);
    eng_ref_2 = strsplit(' ', eng_ref_2);
    eng_ref_2 = eng_ref_2(2:length(eng_ref_2) - 1);
    eng_ref_3 = strsplit(' ', eng_ref_3);
    eng_ref_3 = eng_ref_3(2:length(eng_ref_3) - 1);

    closest_length = length(eng_ref_1);
    min_diff = abs(can_length - closest_length);
    if abs(can_length - length(eng_ref_2)) < min_diff
        closest_length = length(eng_ref_2);
        min_diff = abs(can_length - length(eng_ref_2));
    end
    if abs(can_length - length(eng_ref_3)) < min_diff
        closest_length = length(eng_ref_3);
        min_diff = abs(can_length - length(eng_ref_3));
    end

    brevity = closest_length / can_length;
    BP = 1;
    if brevity >= 1
        BP = exp(1 - brevity);
    end
    BLEU = BP;
    for n = 1:length(p)
        BLEU = BLEU * (p{n} ^ (1 / N));
    end

    disp(['BLEU score(n = ', num2str(N), ', numSentences = ', num2str(numSentences), ') for sentence{', fres{l}, '}: ', num2str(BLEU)]);
end






