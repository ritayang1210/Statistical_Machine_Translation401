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
  outSentence = regexprep(outSentence, ['\.\s+', CSC401_A2_DEFNS.SENTEND], [' \. ', CSC401_A2_DEFNS.SENTEND]);
  possessives = strsplit(' ', '\( \) : ; \+ < > \= \.{3,} \?+ \!+ " \* \, ` \[ \] / \$ \% \&');
  for i = 1:length(possessives)
    possessive = possessives{i};
    outSentence = regexprep(outSentence, strcat('(', possessive, ')'), ' $1 ');
  end

  % outSentence = regexprep(outSentence, '(\(.*)-(.*\))', ' $1 - $2 ');

  oldOutSentence = outSentence;
  outSentence = regexprep(outSentence, '(\(\S+.+)-(\S+.+\))', ' $1 - $2 ', 'all');
  while (~strcmp(oldOutSentence, outSentence))
    oldOutSentence = outSentence;
    outSentence = regexprep(outSentence, '(\(\S+.+)-(\S+.+\))', ' $1 - $2 ', 'all');
  end

  switch language
   case 'e'
    outSentence = regexprep(outSentence, '(\S+s)''\s', ' $1 '' ');
    outSentence = regexprep(outSentence, '''s', ' ''s ');
   case 'f'
    outSentence = regexprep(outSentence, '\sl''', ' l'' ');
    outSentence = regexprep(outSentence, '\s(\S'')', ' $1 ');
    outSentence = regexprep(outSentence, '\squ''', ' qu'' ');
    outSentence = regexprep(outSentence, '(\S+'')on\s', ' $1 on ');
    outSentence = regexprep(outSentence, '(\S+'')il\s', ' $1 il ');

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

  disp(outSentence);

  end

  % change unpleasant characters to codes that can be keys in dictionaries
  outSentence = convertSymbols( outSentence );

