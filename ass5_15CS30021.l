%{
#include "y.tab.h"
#include <math.h>
#include <stdlib.h>
#include <string.h>
%}

%x multi_line_comment_

%{
int line_num = 1;
%}


type_specifierkeyword      (void)|(char)|(short)|(int)|(long)|(float)|(double)|(signed)|(unsigned)|(Bool)|(Matrix)
BREAKKEYWORD_        	   (break)
RETURNKEYWORD_        	   (return)
CASEKEYWORD_        	   (case)
FORKEYWORD_        	   (for)
WHILEKEYWORD_        	   (while)
GOTOKEYWORD_        	   (goto)
CONTINUEKEYWORD_           (continue)
IFKEYWORD_        	       (if)
DEFAULTKEYWORD_        	   (default)
DOKEYWORD_        	       (do)
SWITCHKEYWORD_        	   (switch)
ELSEKEYWORD_               (else)


digit                 [0-9]		  
sign                  ("+"|"-")
digit-sequence		[0-9]+
identifier-nondigit   [a-z_A-Z]
identifier_           ({identifier-nondigit}({identifier-nondigit}|{digit})*)
integer_constant_     ([1-9]{digit}*)|[0]
fractional_constant	  (({digit-sequence}[\.]{digit-sequence})|(\.{digit-sequence})|({digit-sequence}[\.]))
exponent_part		  (([eE]{digit-sequence})|([eE]{sign}{digit-sequence})) 
floating_constant_    (({fractional_constant}{exponent_part})|({fractional_constant})|({digit-sequence}{exponent_part}))
c_char                ([^\'\\\n]|"\\"[\'\"\?\\nbfratv])
c_char_sequence		  {c_char}+
character_constant_   ("\'"{c_char_sequence}"\'")
s_char                ([^\"\\\n]|"\\"[\'\"\?\\nbfratv])
s_char_sequence       {s_char}+
string_literal_       (("\""{s_char_sequence}"\"")|("\"\""))
single_line_comment_  ("//"[^\n]*)

%%

[ \t]+						{;}

[\n]						{;}



{type_specifierkeyword}         	  {yylval.charval = (char*)malloc((yyleng+1)*sizeof(char)); strncpy(yylval.charval, yytext, yyleng); yylval.charval[yyleng] = '\0' ;return type_specifierkeyword;}  

{CASEKEYWORD_}                            {return CASEKEYWORD;}  
{DEFAULTKEYWORD_}                         { return DEFAULTKEYWORD;}  
{IFKEYWORD_}                              { return IFKEYWORD;}  
{ELSEKEYWORD_}		                      {return ELSEKEYWORD;}
{SWITCHKEYWORD_}         				  {return SWITCHKEYWORD;}  
{WHILEKEYWORD_}         				  {return WHILEKEYWORD;}  
{DOKEYWORD_}                              {return DOKEYWORD;}  
{FORKEYWORD_}                             {return FORKEYWORD;}  
{GOTOKEYWORD_}         					  {return GOTOKEYWORD;}  
{CONTINUEKEYWORD_}         				  {return CONTINUEKEYWORD;}  
{BREAKKEYWORD_}         				  {return BREAKKEYWORD;}  
{RETURNKEYWORD_}         				  {return RETURNKEYWORD;}  

{identifier_}                             {yylval.charval = (char*)malloc((yyleng+1)*sizeof(char)); strncpy(yylval.charval, yytext, yyleng); yylval.charval[yyleng] = '\0' ;return Identifier;}
{integer_constant_}		                  {yylval.charval = (char*)malloc((yyleng+1)*sizeof(char)); strncpy(yylval.charval, yytext, yyleng); yylval.charval[yyleng] = '\0'; return integer_constant;}
{floating_constant_}		              {yylval.charval = (char*)malloc((yyleng+1)*sizeof(char)); strncpy(yylval.charval, yytext, yyleng); yylval.charval[yyleng] = '\0'; return integer_constant;}
{character_constant_}                     {yylval.charval = (char*)malloc((yyleng+1)*sizeof(char)); strncpy(yylval.charval, yytext, yyleng); yylval.charval[yyleng] = '\0'; return character_constant;}
{string_literal_}			              {yylval.charval = (char*)malloc((yyleng+1)*sizeof(char)); 
											strncpy(yylval.charval, yytext, yyleng); 
											yylval.charval[yyleng] = '\0'; return string_literal;}

"#"				              {return punctuator;}

"("                       {return PARENTHESESOPEN;}  

"{"                      {return CURLYOPEN;}   

"["                       {return SQUAREOPEN;}  

")"                      {return PARENTHESESCLOSE;}  

"}"                     {return CURLYCLOSE;}  

"]"                      {return SQUARECLOSE;}  

";"                              {return semicolon;}  

"."                                    {return dot;}  

","                                  {return comma;}  

"->"                            {return dereference;}  

"++"                               {return plusplus;}  

"--"                             {return minusminus;}  

"&"                               {return unaryand;} 

"&&"                                  {return myand;}

"*"                                   {return star;}  

"/"         						  {return divide;}

"%"         							  {return mod;}  

"+"                                   {return plus;}  

"-"                                  {return minus;}  

"~"                             {return complement;} 

".'" 				{return dot_apos;}

"!"                                  {return mynot;}  

"<<"                              {return leftshift;}  

">>"                             {return rightshift;}  

"<"                               {return lessthan;}  

">"                            {return greaterthan;}  

"<="                          {return lessthanequal;}  

">="                       {return greaterthanequal;}  

"=="                             {return equalequal;}  

"!="                               {return notequal;}  

"^"                                  {return xorthis;}  

"|"                                {return funcor;}  

"||"                                   {return orthis;}  

"?"                               {return question;}  

":"                                  {return colon;}  

"="                                  {return equal;}  

"*="                              {return starequal;}  

"/="                            {return divideequal;}  

"%="                               {return modequal;}  

"+="                              {return plusequal;}  

"-="                             {return minusequal;}  

"<<="                         {return leftshiftequal;}  

">>="                        {return rightshiftequal;}  

"&="                               {return andequal;}  

"^="                               {return xorequal;}  

"|="                                {return orequal;}  

"..."                              {return elipses;}  

{single_line_comment_}                    {;}

<INITIAL>"/*"         BEGIN(multi_line_comment_);

<multi_line_comment_>[^*\n]*        /* eat anything that's not a '*' */
<multi_line_comment_>"*"+[^*/\n]*   /* eat up '*'s not followed by '/'s */
<multi_line_comment_>\n             
<multi_line_comment_>"*"+"/"        {BEGIN(INITIAL);}



.							               {;}

%%

