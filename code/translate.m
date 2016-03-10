function translations = translate(file, LM, AM, lmtype, delta, vocabSize)

global CSC401_A2_DEFNS

SENTSTARTMARK = 'SENTSTART'; 
SENTENDMARK = 'SENTEND';

lines = textread(file, '%s','delimiter','\n');

for l=1:length(lines)
    french =  preprocess(lines{l}, 'f');

    disp(strjoin(decode(french, LM, AM, lmtype, delta, vocabSize), ' '));
end

return