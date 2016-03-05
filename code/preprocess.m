function outSentence = preprocess( inSentence, language )
%
%  preprocess
%
%  This function preprocesses the input text according to language-specific rules.
%  Specifically, we separate contractions according to the source language, convert
%  all tokens to lower-case, and separate end-of-sentence punctuation 
%
%  INPUTS:
%       inSentence     : (string) the original sentence to be processed 
%                                 (e.g., a line from the Hansard)
%       language       : (string) either 'e' (English) or 'f' (French) 
%                                 according to the language of inSentence
%
%  OUTPUT:
%       outSentence    : (string) the modified sentence
%
%  Template (c) 2011 Frank Rudzicz 

  global CSC401_A2_DEFNS
  
  % first, convert the input sentence to lower-case and add sentence marks 
  inSentence = [CSC401_A2_DEFNS.SENTSTART ' ' lower( inSentence ) ' ' CSC401_A2_DEFNS.SENTEND];

  % trim whitespaces down 
  inSentence = regexprep( inSentence, '\s+', ' '); 

  % initialize outSentence
  outSentence = inSentence;

  % perform language-agnostic changes
  % TODO: your code here
  %    e.g., outSentence = regexprep( outSentence, 'TODO', 'TODO');
  % dashes between parentheses ? 
  possessives = cellstr(['\.$'; '\('; '\)'; ':'; ';'; '-'; '\+'; '<'; '>'; '\='; '\.{3,}'; '\?+'; '\!+'; '"']);
  for i = 1:length(possessives)
    possessive = possessives{i};
    outSentence = regexprep(outSentence, strcat('(', possessive, ')'), strcat(' $1 '));
  end
  

  switch language
   case 'e'
    outSentence = regexprep(outSentence, '(\S+s)''\s', strcat(' $1 '' '));
    outSentence = regexprep(outSentence, strcat('''s'), strcat(' ''s '));
   case 'f'
    outSentence = regexprep(outSentence, strcat('\sl''', strcat(' l'' '));
    outSentence = regexprep(outSentence, strcat('\s(\S'')', strcat(' $1 '));
    outSentence = regexprep(outSentence, strcat('\squ''', strcat(' qu'' '));
    outSentence = regexprep(outSentence, strcat('(\S+'')on\s', strcat(' $1 on '));
    outSentence = regexprep(outSentence, strcat('(\S+'')il\s', strcat(' $1 il '));

  outSentence = strcat(CSC401_A2_DEFNS.SENTSTART, ' ', outSentence);
  outSentence = strcat(outSentence, ' ', CSC401_A2_DEFNS.SENTEND);

  outSentence = regexprep(outSentence, '1', CSC401_A2_DEFNS.ONE);
  outSentence = regexprep(outSentence, '2', CSC401_A2_DEFNS.TWO);
  outSentence = regexprep(outSentence, '3', CSC401_A2_DEFNS.THREE);
  outSentence = regexprep(outSentence, '4', CSC401_A2_DEFNS.FOUR);
  outSentence = regexprep(outSentence, '5', CSC401_A2_DEFNS.FIVE);
  outSentence = regexprep(outSentence, '6', CSC401_A2_DEFNS.SIX);
  outSentence = regexprep(outSentence, '7', CSC401_A2_DEFNS.SEVEN);
  outSentence = regexprep(outSentence, '8', CSC401_A2_DEFNS.EIGHT);
  outSentence = regexprep(outSentence, '9', CSC401_A2_DEFNS.NINE);
  outSentence = regexprep(outSentence, '10', CSC401_A2_DEFNS.ZERO);

  end

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

