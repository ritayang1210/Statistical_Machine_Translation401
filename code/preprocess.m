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

  end

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

