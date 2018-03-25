%define parse.error verbose

%{ /* C Declarations and Definitions */
#include <string.h>
#include <stdio.h>
#include "ass5_15CS30021_translator.h" 
  extern int yylex();
  void yyerror(const char *s);

  SymbolTable* globalSymbolTableKeeper;
  SymbolTable* currentSymbolTableKeeper;
  int nextInstruction = 1;
  int registerCountKeeper = 0;
  Quad QuadArrayKeeper[1000];
  opcodeType keywordType;
  entrytype globalFType;
  %}

%union {

  int intval;
  float floatval;
  int nonval;
  char *charval;
  struct Etype_* E;
  struct Mtype_* M;
  struct Ntype_* N;
  struct Stype_* S;
  struct entrytype_* entryVariableType;
}

%type <charval> translation_unit;

%token <nonval>  CASEKEYWORD DEFAULTKEYWORD IFKEYWORD
%token <nonval> ELSEKEYWORD SWITCHKEYWORD WHILEKEYWORD DOKEYWORD FORKEYWORD GOTOKEYWORD CONTINUEKEYWORD BREAKKEYWORD        
%token <nonval> RETURNKEYWORD SIZEOFKEYWORD REGISTER
%token <charval> type_specifierkeyword                          
%token <charval> PARENTHESESOPEN CURLYOPEN SQUAREOPEN PARENTHESESCLOSE CURLYCLOSE SQUARECLOSE punctuator dot comma dereference
%token <charval> plusplus minusminus unaryand star plus minus complement mynot divide mod leftshift rightshift lessthan greaterthan dot_apos
%token <charval> lessthanequal greaterthanequal equalequal notequal xorthis funcor orthis question colon equal starequal divideequal
%token <charval> modequal plusequal minusequal leftshiftequal rightshiftequal andequal xorequal orequal semicolon elipses myand
%token <charval> Identifier integer_constant floating_constant character_constant string_literal
%token <charval> newline
%type <charval> external_declaration function_definition declaration_list;
%type <entryVariableType> declaration_specifiers;
%type <E> declaration init_declarator_list init_declarator declarator direct_declarator;
%type <entryVariableType> type_specifier;
%type <intval> pointer;
%type <E> parameter_type_list parameter_list parameter_declaration;
%type <charval> identifier_list;
%type <E> initializer;
%type <charval> initializer_row_list designation designator_list designator initializer_row assignment_operator;
%type <S> statement labeled_statement compound_statement block_item_list block_item expression_statement selection_statement;
%type <S> iteration_statement jump_statement;
%type <E> primary_expression postfix_expression unary_expression cast_expression multiplicative_expression additive_expression;
%type <E> shift_expression relational_expression equality_expression AND_expression exclusive_OR_expression inclusive_OR_expression;
%type <E> logical_AND_expression logical_OR_expression conditional_expression assignment_expression assignment_expression_opt;
%type <E> expression constant_expression expression_opt;
%type <E> argument_expression_list argument_expression_list_opt;
%type <E> identifier;
%type <M> M1;
%type <N> N1;

%start translation_unit

%nonassoc IFKEYWORDX
%nonassoc ELSEKEYWORD

%%


translation_unit    : external_declaration
{

}
| translation_unit external_declaration
{

}
;

primary_expression:  identifier
{
                        
}
| floating_constant
{
                      
  // This rule generates a temporary variable and sets it equal to the constant.
                                              
  $$ = new Etype; 
  $$->loc = currentSymbolTableKeeper->gentemp(); 
  currentSymbolTableKeeper->update($$->loc->name,DOUBLE,0,(currentSymbolTableKeeper->globalOffset)); 
  currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset+$$->loc->size;
  $$->entryVariableType = $$->loc->type;
  emit(COPY,$$->loc->name,$1);
}
| character_constant
{
                       
  // This rule generates a temporary variable and sets it equal to the constant.
                       
                       
  $$ = new Etype; 
  $$->loc = currentSymbolTableKeeper->gentemp(); 
  currentSymbolTableKeeper->update($$->loc->name,CHAR,0,(currentSymbolTableKeeper->globalOffset)); 
  currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset + $$->loc->size;
  emit(COPY,$$->loc->name,$1);
  $$->entryVariableType = $$->loc->type;
}
| string_literal
{
                       
  // This rule generates a temporary variable and sets it equal to the constant.
  string* stringtoadd = new string(yylval.charval); 
  stringadder(*stringtoadd);
  $$ = new Etype; 
  $$->loc = currentSymbolTableKeeper->gentemp();
  entrytype *tofo = new entrytype; tofo->variabletype = CHAR; tofo->next = NULL;  
  currentSymbolTableKeeper->update($$->loc->name,PTR,tofo,(currentSymbolTableKeeper->globalOffset)); 
  ($$->loc->type).arraysize = 1;
  ($$->loc->size) = 8*(strlen($1)+1); 
  currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset + $$->loc->size;
  emit(COPY,$$->loc->name,$1);
  $$->entryVariableType = $$->loc->type;
}
| PARENTHESESOPEN expression PARENTHESESCLOSE
{
  //This takes care of the rule E-> (E) 
  $$ = $2;
}
| integer_constant
{
                       
  // This rule generates a temporary variable and sets it equal to the constant.
                       

  $$ = new Etype; 
  $$->loc = currentSymbolTableKeeper->gentemp(); 
  currentSymbolTableKeeper->update($$->loc->name,INT,0,(currentSymbolTableKeeper->globalOffset)); 
                       
  currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset + $$->loc->size;
  $$->entryVariableType = $$->loc->type; 
  $$->val = atoi($1);
  currentSymbolTableKeeper->update($$->loc->name,$$->val);
  emit(COPY,$$->loc->name,$1);                      
}
;



identifier: Identifier
{
  $$ = new Etype;
  symtabentry* tofo1 = currentSymbolTableKeeper->lookUp($1);
  symtabentry* tofo2 = globalSymbolTableKeeper->lookUp($1);
  if(tofo1 != NULL)
    {
      $$->loc = tofo1;
      $$->entryVariableType = $$->loc->type;
    }
  else if(tofo2 != NULL)
    {
      $$->loc = &(tofo2->ptr->symboltable[0]);
      $$->entryVariableType = $$->loc->type;
    }
  else 
    {
      $$->loc = currentSymbolTableKeeper->insert($1);
      $$->entryVariableType = $$->loc->type;
      $$->loc->declared = 0;
    } 
}
;


postfix_expression:  primary_expression
{
  $$ = $1;
}
|postfix_expression SQUAREOPEN expression SQUARECLOSE
{

  int effectivesize;
  entrytype* temp = ($1->entryVariableType).next;
  int factor = 1;
  while(temp->next){factor *= temp->arraysize;temp = temp->next;}                        
  switch(temp->variabletype){
    case INT:{
	effectivesize = INT_SIZE;
        break;                   
      }
    case CHAR:
      {
	effectivesize = CHAR_SIZE;
        break;               
      }
    case DOUBLE:
      {
	effectivesize = DOUBLE_SIZE;
        break;                       
      }
    }
                          
  symtabentry* tofo = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update(tofo->name,temp->variabletype,0,(currentSymbolTableKeeper->globalOffset));
  currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset+ tofo->size;
  emit(MULT,tofo->name,$3->loc->name,effectivesize*factor);
  for(int i=0;i<10;i++)
    {
      int k = k + i;
    }
  $$ = new Etype;
  $$->entryVariableType = *(($1->entryVariableType).next);
  if(($1->loc->type).variabletype != ARRAY)
    {
      $$->loc = currentSymbolTableKeeper->gentemp();
      currentSymbolTableKeeper->update($$->loc->name,temp->variabletype,0,(currentSymbolTableKeeper->globalOffset));
      (currentSymbolTableKeeper->globalOffset) += tofo->size;
      emit(PLUS,$$->loc->name,$1->loc->name,tofo->name);
      $$->arrayname = $1->arrayname;
    }
  else
    {
      $$->loc = tofo;
      $$->arrayname = $1->loc->name;
    }
  if(($$->entryVariableType).variabletype != ARRAY)
    { 
      ($$->entryVariableType).variabletype = ARRAY;
    }
}
|postfix_expression PARENTHESESOPEN argument_expression_list_opt PARENTHESESCLOSE
{
  symtabentry* tofo = globalSymbolTableKeeper->lookUp($1->loc->name);
  symtabentry* recur = currentSymbolTableKeeper->lookUp($1->loc->name);
  if(string($1->loc->name) != "printi" && string($1->loc->name) != "prints" && string($1->loc->name) != "readi")
    {
      Etype* a = $3;
      Etype* b = $3;
      SymbolTable* temp;
      if(tofo!=NULL)temp = tofo->ptr;
      else {temp = currentSymbolTableKeeper;tofo=recur;}
      for(int i=0;i<10;i++)
	{
	  int k = k + i;
	}
      for(int i=tofo->param_cnt;i>0;i--)
	{
	  $3->loc = typeCheck($3->loc,&((temp->symboltable[i]).type));
	  $3 = $3->prev_param;
	}
                       
      for(int i=tofo->param_cnt;i>0;i--)
	{
                        
	  symtabentry* tofo1 = currentSymbolTableKeeper->gentemp();
	  currentSymbolTableKeeper->update(tofo1->name,((temp->symboltable[i]).type).variabletype,((temp->symboltable[i]).type).next,currentSymbolTableKeeper->globalOffset);
	  currentSymbolTableKeeper->globalOffset += tofo1->size;
	  tofo1->type = ((temp->symboltable[i]).type);
	  emit(COPY,tofo1->name,a->loc->name);
	  a->loc = tofo1;
	  a = a->prev_param;
	}
      int k=0;
      for(int j=0;j<tofo->param_cnt;j++)
	{
	  k++;
	}    
      for(int i=tofo->param_cnt;i>0;i--)
	{
	  emit(PARAM,b->loc->name);
	  b = b->prev_param;
	}

                       
      int i = tofo->param_cnt + 1;
      $$ = new Etype;
      $$->loc = currentSymbolTableKeeper->gentemp();
      currentSymbolTableKeeper->update($$->loc->name,((temp->symboltable[i]).type).variabletype,((temp->symboltable[i]).type).next,currentSymbolTableKeeper->globalOffset);
      currentSymbolTableKeeper->globalOffset += $$->loc->size;
      for(int i=0;i<10;i++)
	{
	  int k = k + i;
	}
      ($$->loc->type).arraysize = ((temp->symboltable[i]).type).arraysize;
      $$->entryVariableType = $$->loc->type;
                    
      emit(CALL,$$->loc->name,$1->loc->name,tofo->param_cnt);

    }
  else
    {
      if(string($1->loc->name) != "readi")
	{
	  emit(PARAM,$3->loc->name);
	  emit(CALL,$$->loc->name,$1->loc->name,1);                      
                      
	}
      else
	{
	  emit(CALL,$$->loc->name,$1->loc->name,0);                      
                        
	}
    }                       
}
|postfix_expression dot identifier
{

}
|postfix_expression dereference identifier
{

}
|postfix_expression plusplus
{
                      
  symtabentry* tofo = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update(tofo->name,($1->loc->type).variabletype,($1->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset+tofo->size;
  (tofo->type).arraysize = ($1->loc->type).arraysize;
                       
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($1->loc->type).variabletype,($1->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  ($$->loc->type).arraysize = ($1->loc->type).arraysize;
  $$->entryVariableType = $$->loc->type;                       
  if(($1->entryVariableType).variabletype == ARRAY) 
    {
      emit(ARRAY_COPY,tofo->name,$1->arrayname,$1->loc->name);
      emit(COPY,$$->loc->name,tofo->name);
      emit(PLUS,tofo->name,tofo->name,"1");                        
      emit(COPY_TO_ARRAY,$1->arrayname,$1->loc->name,tofo->name);
    }
  else
    {
      emit(COPY,tofo->name,$1->loc->name);                        
      emit(COPY,$$->loc->name,tofo->name);
      emit(PLUS,tofo->name,tofo->name,"1");                        
      emit(COPY,$1->loc->name,tofo->name);                      
    }
}
                     
| postfix_expression dot_apos
{

}

|postfix_expression minusminus
{                        
  symtabentry* varfo = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update(varfo->name,($1->loc->type).variabletype,($1->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += varfo->size;
  (varfo->type).arraysize = ($1->loc->type).arraysize;
                       
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($1->loc->type).variabletype,($1->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  ($$->loc->type).arraysize = ($1->loc->type).arraysize;
  $$->entryVariableType = $$->loc->type;

  if(($1->entryVariableType).variabletype == ARRAY) 
    {
      emit(ARRAY_COPY,varfo->name,$1->arrayname,$1->loc->name);
      emit(COPY,$$->loc->name,varfo->name);
      emit(MINUS,varfo->name,varfo->name,"1");
      emit(COPY_TO_ARRAY,$1->arrayname,$1->loc->name,varfo->name);
    }
  else
    {
      emit(COPY,varfo->name,$1->loc->name);                        
      emit(COPY,$$->loc->name,varfo->name);
      emit(MINUS,varfo->name,varfo->name,"1");
      emit(COPY,$1->loc->name,varfo->name);                                                 
    }
                       
}
;





argument_expression_list_opt: argument_expression_list
{                               
  $$ = $1;
}
|{                           
        $$ = new Etype;
        $$->param_cnt = 0;
 }
;

argument_expression_list: assignment_expression
{                         
  $$ = new Etype;
  if(($1->entryVariableType).variabletype == BOOL) $$->loc = convertBOOL2INT($1);
  else $$->loc = $1->loc;
  $$->prev_param = NULL;
  $$->param_cnt = 1;
}
| argument_expression_list comma assignment_expression
{
  $$ = new Etype;
  if(($3->entryVariableType).variabletype == BOOL) $$->loc = convertBOOL2INT($3);
  else $$->loc = $3->loc;
  $$->prev_param = $1;
  $$->param_cnt = $1->param_cnt + 1; 
}
;





unary_expression:    postfix_expression
{
  //Pass the post fix expression up the grammar     
  $$ = $1;
}
| plusplus unary_expression
{
                      
                      
  symtabentry* tofo = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update(tofo->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  tofo->type = $2->loc->type;
  (currentSymbolTableKeeper->globalOffset) += tofo->size;
                       
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  for(int i=0;i<10;i++)
    {
      int k = k + i;
    }
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  $$->loc->type = $2->loc->type;
  $$->entryVariableType = $$->loc->type;

                       
  if(($2->entryVariableType).variabletype == ARRAY) 
    {
      emit(ARRAY_COPY,tofo->name,$2->arrayname,$2->loc->name);
      emit(PLUS,tofo->name,tofo->name,"1");
      emit(COPY,$$->loc->name,tofo->name);                        
      emit(COPY_TO_ARRAY,$2->arrayname,$2->loc->name,tofo->name);                       
    }
  else
    {
      emit(COPY,tofo->name,$2->loc->name); 
      emit(PLUS,tofo->name,tofo->name,"1");
      emit(COPY,$$->loc->name,tofo->name);  
      emit(COPY,$2->loc->name,tofo->name);                     
    }
                      
}
| minusminus unary_expression
{
                       
                      
  symtabentry* tofo = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update(tofo->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  tofo->type = $2->loc->type;
  (currentSymbolTableKeeper->globalOffset) += tofo->size;
                       
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  $$->loc->type = $2->loc->type;
  $$->entryVariableType = $$->loc->type;

  if(($2->entryVariableType).variabletype == ARRAY) 
    {
      emit(ARRAY_COPY,tofo->name,$2->arrayname,$2->loc->name);
    }
  else 
    {
      emit(COPY,tofo->name,$2->loc->name);                        
    }
  emit(MINUS,tofo->name,tofo->name,"1");
  emit(COPY,$$->loc->name,tofo->name);
  if(($2->entryVariableType).variabletype == ARRAY) 
    {
      emit(COPY_TO_ARRAY,$2->arrayname,$2->loc->name,tofo->name);
    }
  else
    {
      emit(COPY,$2->loc->name,tofo->name);                        
    } 
}
| plus cast_expression
{
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  $$->loc->type = $2->loc->type;
  emit(UNARY_PLUS,$$->loc->name,$2->loc->name,"1");
  $$->entryVariableType = $$->loc->type;                
}
| minus cast_expression
{
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  $$->loc->type = $2->loc->type;
  emit(UNARY_MINUS,$$->loc->name,$2->loc->name,"1");
  $$->entryVariableType = $$->loc->type;                
}
| complement cast_expression
{
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  $$->loc->type = $2->loc->type;
  emit(COMPLEMENT,$$->loc->name,$2->loc->name,"1");
  $$->entryVariableType = $$->loc->type;                
}
| mynot cast_expression
{
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($2->loc->type).variabletype,($2->loc->type).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  $$->loc->type = $2->loc->type;
  emit(NOT,$$->loc->name,$2->loc->name,"1");
  $$->entryVariableType = $$->loc->type;                
}
| unaryand cast_expression
{
                       
                       
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
                       
  entrytype* temp = new entrytype;
  temp->next = NULL;
  if(($2->loc->type).variabletype == PTR) temp = ($2->loc->type).next;
  else temp->variabletype =  ($2->loc->type).variabletype;

  currentSymbolTableKeeper->update($$->loc->name,PTR,temp,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;

  emit(UNARY_AND,$$->loc->name,$2->loc->name);
  if(($2->loc->type).variabletype == PTR) ($$->loc->type).arraysize = ($2->loc->type).arraysize + 1;
  else ($$->loc->type).arraysize = 1;   
  $$->entryVariableType = $$->loc->type;                
}
| star cast_expression
{
                       

  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
                       
  entrytype* temp = new entrytype;
  temp->next = NULL;
  temp = ($2->loc->type).next;
                       
  if(($2->loc->type).arraysize == 1)
    currentSymbolTableKeeper->update($$->loc->name,(($2->loc->type).next)->variabletype,0,(currentSymbolTableKeeper->globalOffset));
  else
    {
      currentSymbolTableKeeper->update($$->loc->name,PTR,temp,(currentSymbolTableKeeper->globalOffset));
    }
                       
  ($$->loc->type).arraysize = ($2->loc->type).arraysize - 1;
                       
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  emit(STAR,$$->loc->name,$2->loc->name,"1");
  $$->entryVariableType = $$->loc->type; 
                       
  if($2->loc->declared==0)$$->arrayname = $2->arrayname;
  else $$->arrayname = $2->loc->name;                
} 
;


cast_expression: unary_expression
{
                   
  if(($1->entryVariableType).variabletype != ARRAY) $$ = $1;
  else if(($1->loc->type).variabletype != ARRAY)
    {
      $$ = new Etype;
      $$->loc = currentSymbolTableKeeper->gentemp();
      currentSymbolTableKeeper->update($$->loc->name,($1->loc->type).variabletype,0,(currentSymbolTableKeeper->globalOffset));
      $1->entryVariableType = $$->loc->type;
      $$->entryVariableType = $$->loc->type;
      (currentSymbolTableKeeper->globalOffset)+=$$->loc->size;
      emit(ARRAY_COPY,$$->loc->name,$1->arrayname,$1->loc->name);
    }
  else {$$ = $1;}
}
;

multiplicative_expression:  cast_expression
{
  //Passing the expression up the grammar
  $$ = $1;
}
| multiplicative_expression star cast_expression
{
                              

  symtabentry* tofo1 = $1->loc;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);
                              
  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                              
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,higherType.variabletype,higherType.next,(currentSymbolTableKeeper->globalOffset));
  emit(MULT,$$->loc->name,tofo1->name,tofo2->name);
                                                           
  $$->entryVariableType = $$->loc->type;
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
}
| multiplicative_expression divide cast_expression
{

  symtabentry* tofo1 = $1->loc;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);
                              
  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,higherType.variabletype,higherType.next,(currentSymbolTableKeeper->globalOffset));
  emit(DIVIDE,$$->loc->name,tofo1->name,tofo2->name);
                                                           
  $$->entryVariableType = $$->loc->type;
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
}
| multiplicative_expression mod cast_expression
{
                              

  symtabentry* tofo1 = $1->loc;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);
                              
  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,higherType.variabletype,higherType.next,(currentSymbolTableKeeper->globalOffset));
  emit(MODULO,$$->loc->name,tofo1->name,tofo2->name);
                                                           
  $$->entryVariableType = $$->loc->type;
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
}
;


additive_expression:  multiplicative_expression
{
  $$ = $1;
}
| additive_expression plus multiplicative_expression
{
                        


  symtabentry* tofo1 = $1->loc;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);
                              
  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,higherType.variabletype,higherType.next,(currentSymbolTableKeeper->globalOffset));
  emit(PLUS,$$->loc->name,tofo1->name,tofo2->name);
                                                           
  $$->entryVariableType = $$->loc->type;
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
}
| additive_expression minus multiplicative_expression
{
                        

  symtabentry* tofo1 = $1->loc;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);
                              
  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,higherType.variabletype,higherType.next,(currentSymbolTableKeeper->globalOffset));
  emit(MINUS,$$->loc->name,tofo1->name,tofo2->name);
                                                           
  $$->entryVariableType = $$->loc->type;
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
}
;



shift_expression:    additive_expression
{
  $$ = $1;
}
| shift_expression leftshift additive_expression
{
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,INT,0,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size; 
  emit(SHIFT_LEFT,$$->loc->name,$1->loc->name,$3->loc->name);
  $$->entryVariableType = $$->loc->type;
}
| shift_expression rightshift additive_expression
{
                        
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,INT,0,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size; 
  emit(SHIFT_RIGHT,$$->loc->name,$1->loc->name,$3->loc->name);
  $$->entryVariableType = $$->loc->type;
}
;




relational_expression:      shift_expression
{
  $$ = $1;
}
|relational_expression lessthan shift_expression
{
                              

  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  symtabentry* tempv = convertBOOL2INT($1);

  symtabentry* tofo1 = tempv;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);

  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                        
  $$->truelist = makelist(nextInstruction);
  $$->falselist = makelist(nextInstruction+1);                              
  emit(IFLESSTHAN,tofo1->name,tofo2->name);
  emit(GOTO);
}
|relational_expression greaterthan shift_expression
{
  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  symtabentry* tempv = convertBOOL2INT($1);

  symtabentry* tofo1 = tempv;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);

  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                        
  $$->truelist = makelist(nextInstruction);
  $$->falselist = makelist(nextInstruction+1);                              
  emit(IFGREATERTHAN,tofo1->name,tofo2->name);
  emit(GOTO);
}
|relational_expression lessthanequal shift_expression
{
  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  symtabentry* tempv = convertBOOL2INT($1);

  symtabentry* tofo1 = tempv;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);

  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                        
  $$->truelist = makelist(nextInstruction);
  $$->falselist = makelist(nextInstruction+1);                              
  emit(IFLESSEQUAL,tofo1->name,tofo2->name);
  emit(GOTO);
}
|relational_expression greaterthanequal shift_expression
{
  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  symtabentry* tempv = convertBOOL2INT($1);

  symtabentry* tofo1 = tempv;
  symtabentry* tofo2 = $3->loc;
  entrytype higherType = 
    ((tofo1->type).variabletype) >= ((tofo2->type).variabletype) ? (tofo1->type) : (tofo2->type);

  tofo1 = typeCheck(tofo1,&higherType);
  tofo2 = typeCheck(tofo2,&higherType);
                        
  $$->truelist = makelist(nextInstruction);
  $$->falselist = makelist(nextInstruction+1);                              
  emit(IFGREATEREQUAL,tofo1->name,tofo2->name);
  emit(GOTO);
}
;

equality_expression:        relational_expression
{
  $$ = $1;
}
| equality_expression equalequal relational_expression
{
  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  symtabentry* tempv = convertBOOL2INT($1);
  symtabentry* tempk = convertBOOL2INT($3);
  entrytype higherType = 
    ((tempv->type).variabletype) >= ((tempk->type).variabletype) ? (tempv->type) : (tempk->type);

  tempv = typeCheck(tempv,&higherType);
  tempk = typeCheck(tempk,&higherType);
                        
  $$->truelist = makelist(nextInstruction);
  $$->falselist = makelist(nextInstruction+1);                              
  emit(IFEQUAL,tempv->name,tempk->name);
  emit(GOTO);
}
| equality_expression notequal relational_expression
{
  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  symtabentry* tempv = convertBOOL2INT($1);
  symtabentry* tempk = convertBOOL2INT($3);
  entrytype higherType = 
    ((tempv->type).variabletype) >= ((tempk->type).variabletype) ? (tempv->type) : (tempk->type);

  tempv = typeCheck(tempv,&higherType);
  tempk = typeCheck(tempk,&higherType);
                        
  $$->truelist = makelist(nextInstruction);
  $$->falselist = makelist(nextInstruction+1);                              
  emit(IFNOTEQUAL,tempv->name,tempk->name);
  emit(GOTO);
}
;

AND_expression:             equality_expression
{
  $$ = $1;
}
| AND_expression unaryand equality_expression
{
  symtabentry* tempv1 = NULL;
  symtabentry* tempv2 = NULL;
                              
  if(($1->entryVariableType).variabletype==BOOL) tempv1 = convertBOOL2INT($1);
  else if(($1->entryVariableType).variabletype==INT) tempv1 = $1->loc;
                              
  if(($3->entryVariableType).variabletype==BOOL) tempv2 = convertBOOL2INT($3);
  else if(($3->entryVariableType).variabletype==INT) tempv2 = $3->loc;
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,INT,0,currentSymbolTableKeeper->globalOffset);
  currentSymbolTableKeeper->globalOffset += INT_SIZE;
  ($$->entryVariableType).variabletype = INT;
                              
  emit(AND,$$->loc->name,tempv1->name,tempv2->name);
                              
}
;



exclusive_OR_expression:    AND_expression
{
  $$ = $1;
}
| exclusive_OR_expression xorthis AND_expression
{
                              

  symtabentry* tempv1 = NULL;
  symtabentry* tempv2 = NULL;
                              
  if(($1->entryVariableType).variabletype==BOOL) tempv1 = convertBOOL2INT($1);
  else if(($1->entryVariableType).variabletype==INT) tempv1 = $1->loc;
                              
  if(($3->entryVariableType).variabletype==BOOL) tempv2 = convertBOOL2INT($3);
  else if(($3->entryVariableType).variabletype==INT) tempv2 = $3->loc;
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,INT,0,currentSymbolTableKeeper->globalOffset);
  currentSymbolTableKeeper->globalOffset += INT_SIZE;
  ($$->entryVariableType).variabletype = INT;
                              
  emit(XOR,$$->loc->name,tempv1->name,tempv2->name);
}
;


inclusive_OR_expression:    exclusive_OR_expression
{
  $$ = $1;
}
|inclusive_OR_expression funcor exclusive_OR_expression
{
                              
  symtabentry* tempv1 = NULL;
  symtabentry* tempv2 = NULL;
                              
  if(($1->entryVariableType).variabletype==BOOL) tempv1 = convertBOOL2INT($1);
  else if(($1->entryVariableType).variabletype==INT) tempv1 = $1->loc;
                              
  if(($3->entryVariableType).variabletype==BOOL) tempv2 = convertBOOL2INT($3);
  else if(($3->entryVariableType).variabletype==INT) tempv2 = $3->loc;
                              
  $$ = new Etype;
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,INT,0,currentSymbolTableKeeper->globalOffset);
  currentSymbolTableKeeper->globalOffset += INT_SIZE;
  ($$->entryVariableType).variabletype = INT;
                              
  emit(OR,$$->loc->name,tempv1->name,tempv2->name);
}
;

M1:
{
  $$ = new Mtype;
  $$->nextinstr = nextInstruction;
}

logical_AND_expression:     inclusive_OR_expression
{
  $$ = $1;
}
| logical_AND_expression myand M1 inclusive_OR_expression
{
  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  convert2BOOL($1);
  convert2BOOL($4);
  backpatch($1->truelist,$3->nextinstr);
  $$->truelist = $4->truelist;
  $$->falselist = merge($1->falselist,$4->falselist);
}
;

logical_OR_expression:      logical_AND_expression
{
  $$ = $1;
}
|logical_OR_expression orthis M1 logical_AND_expression
{
                              
  $$ = new Etype;
  ($$->entryVariableType).variabletype = BOOL;
  convert2BOOL($1);
  convert2BOOL($4);
  backpatch($1->falselist,$3->nextinstr);
  $$->falselist = $4->falselist;
  $$->truelist = merge($1->truelist,$4->truelist);
}
;

N1:
{
  $$ = new Ntype;
  $$->nextlist = makelist(nextInstruction);
  emit(GOTO);
}
;

assignment_expression:  conditional_expression
{
  $$ = $1;
}
| unary_expression assignment_operator assignment_expression
{
                          
  if($1->loc->declared == 0)
    {
      symtabentry* decl = currentSymbolTableKeeper->lookUp($1->arrayname);
      if(decl == NULL)
	{
	  exit(1);
	}
    }

  $$ = new Etype;
                          
  symtabentry* tofo;
  if(($3->entryVariableType).variabletype == BOOL)tofo = convertBOOL2INT($3);
  else tofo = $3->loc;
  tofo = typeCheck(tofo,&($1->loc->type));

  $$->entryVariableType = ($1->loc->type);
  $$->loc = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update($$->loc->name,($$->entryVariableType).variabletype,($$->entryVariableType).next,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;
  if(($1->entryVariableType).variabletype!=ARRAY && ($1->loc->declared!=0))
    {
      emit(COPY,$1->loc->name,tofo->name);
      emit(COPY,$$->loc->name,$1->loc->name);
    }
  else if(($1->entryVariableType).variabletype==ARRAY)
    {
      emit(COPY_TO_ARRAY,$1->arrayname,$1->loc->name,tofo->name);
      $1->entryVariableType = $1->loc->type;
      emit(ARRAY_COPY,$$->loc->name,$1->arrayname,$1->loc->name);
    }
  else
    {
      symtabentry* decl = currentSymbolTableKeeper->lookUp($1->arrayname);
      ($1->loc->type).arraysize = ($1->loc->type).arraysize;
      int ptr_cnt = (decl->type).arraysize - ($1->loc->type).arraysize;
      emit(COPY_TO_PTR,$1->arrayname,ptr_cnt,tofo->name);
      emit(COPY_FROM_PTR,$$->loc->name,ptr_cnt,$1->arrayname);
    }
}
;

assignment_operator:     equal
| starequal
| divideequal
| modequal
| plusequal
| minusequal
| leftshiftequal
| rightshiftequal
| andequal
| xorequal
| orequal
;

expression:   assignment_expression
{
  $$ = $1;
}
| expression comma assignment_expression
;

constant_expression : conditional_expression
{
  $$ = $1;
}
;






declaration:            declaration_specifiers semicolon
{

}
| declaration_specifiers  init_declarator_list semicolon
{
  $$ = $2;
}
;

conditional_expression: logical_OR_expression
{
  $$ = $1;
}
| logical_OR_expression N1 question M1 expression N1 colon M1 conditional_expression
{ 
                          
                          
  $$ = new Etype();
  $$->loc = currentSymbolTableKeeper->gentemp();
  $$->entryVariableType = $5->entryVariableType;
                          
  if(($5->entryVariableType).variabletype!=BOOL)
    {
      currentSymbolTableKeeper->update($$->loc->name,($$->entryVariableType).variabletype,($$->entryVariableType).next,(currentSymbolTableKeeper->globalOffset));
      ($$->loc->type).arraysize = ($5->entryVariableType).arraysize;
    }
  else
    currentSymbolTableKeeper->update($$->loc->name,INT,0,(currentSymbolTableKeeper->globalOffset));
                          
  $$->entryVariableType = $$->loc->type;

  (currentSymbolTableKeeper->globalOffset) += $$->loc->size;

  symtabentry* newtemp;
  if(($9->entryVariableType).variabletype == BOOL) newtemp = convertBOOL2INT($9);
  else newtemp = $9->loc;

  symtabentry* temp = typeCheck(newtemp,&($$->loc->type));
  emit(COPY,$$->loc->name,temp->name);
                          
  targetlist l = makelist(nextInstruction);
  emit(GOTO);
  backpatch($6->nextlist,nextInstruction);
                          
  if(($5->entryVariableType).variabletype == BOOL) newtemp = convertBOOL2INT($5);
  else newtemp = $5->loc;
                          
  symtabentry* tofo = typeCheck(newtemp,&($$->loc->type));
  emit(COPY,$$->loc->name,tofo->name);
                          
  l = merge(l,makelist(nextInstruction));
  emit(GOTO);
  backpatch($2->nextlist,nextInstruction);
                          
  convert2BOOL($1);
                          
  backpatch($1->truelist,$4->nextinstr);
  backpatch($1->falselist,$8->nextinstr);
  backpatch(l,nextInstruction); 
}
;

declaration_specifiers: type_specifier  
{                        
  keywordType = $1->variabletype;
  $$ = $1;
}         
| type_specifier declaration_specifiers 
{
                          
};


init_declarator_list:   init_declarator
{
  $$ = $1;
} 
| init_declarator_list comma init_declarator
{
  $$ = $1;
};

init_declarator:        declarator
{
                          
  $$ = $1;
  if(($1->loc->type).variabletype == FUNCTION)
    {
      $$ = new Etype;
      symtabentry* t3 = globalSymbolTableKeeper->lookUp($1->loc->name);
      if(t3 == NULL)
	$$->loc = globalSymbolTableKeeper->insert($1->loc->name);
      else
	{
	  $$->loc = t3;
	}
      $$->entryVariableType = $$->loc->type;

      globalSymbolTableKeeper->update($$->loc->name,FUNCTION,0,globalSymbolTableKeeper->globalOffset);
      $$->loc->size = currentSymbolTableKeeper->globalOffset;
      globalSymbolTableKeeper->globalOffset += currentSymbolTableKeeper->globalOffset;
      $$->loc->param_cnt = $1->loc->param_cnt;
      $$->loc->ptr = currentSymbolTableKeeper; 

      currentSymbolTableKeeper = new SymbolTable;
      currentSymbolTableKeeper->globalOffset = 8;
    }
}
| declarator equal initializer
{
                          
  if(($3->entryVariableType).variabletype == BOOL)convertBOOL2INT($3);
  symtabentry *tofo = typeCheck($3->loc,&($1->loc->type));
  emit(COPY,$1->loc->name,tofo->name);
  $$ = $1;
}
;

type_specifier: type_specifierkeyword
{
  //printf("eqwqe\n");
  $$ = new entrytype;
  $$->next = NULL;
  if(strcmp($1,"char")==0)$$->variabletype = CHAR;
  else if(strcmp($1,"int")==0)$$->variabletype = INT;
  else if(strcmp($1,"void")==0)$$->variabletype = VOID;
  else if(strcmp($1,"double")==0)$$->variabletype = INT;
  else if(strcmp($1,"Matrix")==0)$$->variabletype = INT;
  
}
;


declarator:             pointer direct_declarator
{
  if(($2->loc->type).variabletype != FUNCTION)
    {
      entrytype* temp = new entrytype;
      temp->variabletype = ($2->loc->type).variabletype;
      temp->next = NULL;
      (currentSymbolTableKeeper->globalOffset) -= $2->loc->size;
      currentSymbolTableKeeper->update($2->loc->name,PTR,temp,(currentSymbolTableKeeper->globalOffset));
      ($2->loc->type).arraysize = $1;
      (currentSymbolTableKeeper->globalOffset) += $2->loc->size;
      $$ = $2;
    }
  else
    {
      int param_cnt = $2->loc->param_cnt;
      symtabentry* tofo = &(currentSymbolTableKeeper->symboltable[param_cnt+1]);
      entrytype* temp = new entrytype;
      temp->variabletype = (tofo->type).variabletype; 
      temp->next = NULL;
      (currentSymbolTableKeeper->globalOffset) -= tofo->size;
      currentSymbolTableKeeper->update(tofo->name,PTR,temp,(currentSymbolTableKeeper->globalOffset));
      (tofo->type).arraysize = $1;
      (currentSymbolTableKeeper->globalOffset) += tofo->size;
      $$ = $2;                          
    }
}
| direct_declarator
{
  $$ = $1;
}
;

assignment_expression_opt : assignment_expression
{
  $$ = $1;
}
| 
                            {
                              $$ = new Etype;
                              $$->val = 0;
                            }
;

direct_declarator:      identifier
{
                         

  $1->loc->declared = 1;
  currentSymbolTableKeeper->update($1->loc->name,keywordType,0,(currentSymbolTableKeeper->globalOffset));
  (currentSymbolTableKeeper->globalOffset) += $1->loc->size;
  $$ = $1;
}
| PARENTHESESOPEN declarator PARENTHESESCLOSE
{
  $$ = $2;
}
| direct_declarator SQUAREOPEN assignment_expression_opt SQUARECLOSE
{
                         

  entrytype* temp = new entrytype;;
  if(($1->loc->type).variabletype != ARRAY)
    {
      *temp = $1->loc->type;
      currentSymbolTableKeeper->update($1->loc->name,ARRAY,temp,$1->loc->offset,$3->val);
      int extrasize = ($3->val)*($1->loc->size) - $1->loc->size;
      $1->loc->size += extrasize;
      (currentSymbolTableKeeper->globalOffset)  += extrasize;
      $$ = $1;
      currentSymbolTableKeeper->setExtrasizeOffset($1->loc,extrasize);
    }
  else
    {
      temp = &($1->loc->type);
      while((temp->next)->variabletype == ARRAY) temp = temp->next;
      entrytype* ntemp = new entrytype;
      ntemp->variabletype = ARRAY;
      ntemp->arraysize = $3->val;
      ntemp->next = temp->next;
      temp->next = ntemp;
      int extrasize = ($3->val)*($1->loc->size) - $1->loc->size;
      $1->loc->size += extrasize;
      (currentSymbolTableKeeper->globalOffset)  += extrasize;
      $$ = $1;
      currentSymbolTableKeeper->setExtrasizeOffset($1->loc,extrasize);  
    }
}
| direct_declarator SQUAREOPEN star SQUARECLOSE
{

}
| direct_declarator PARENTHESESOPEN parameter_type_list PARENTHESESCLOSE
{

  $$->entryVariableType = $1->loc->type;


  if($1->loc != &(currentSymbolTableKeeper->symboltable[0])) 
    {
      SymbolTable* tofo = (globalSymbolTableKeeper->lookUp($1->loc->name))->ptr;
      symtabentry* p = &(currentSymbolTableKeeper->symboltable[0]);

      Etype* z = $3;
      for(int i = z->param_cnt; i>0; i--)
	{
                          
	  z = z->prev_param;
	}

      globalFType = (tofo->symboltable[$3->param_cnt+1]).type;
                           
      $$->entryVariableType = p->type;
      $1->loc = &(currentSymbolTableKeeper->symboltable[0]);
      $1->loc->declared = 2;

    }
                          
  currentSymbolTableKeeper->setExtrasizeOffset($1->loc,-($1->loc->size));
  (currentSymbolTableKeeper->globalOffset) -= $1->loc->size;
  currentSymbolTableKeeper->update($1->loc->name,FUNCTION,0,0);
                          
  symtabentry* retval = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update(retval->name,($$->entryVariableType).variabletype,($$->entryVariableType).next,currentSymbolTableKeeper->globalOffset);
  currentSymbolTableKeeper->globalOffset += retval->size;
  (retval->type).arraysize = ($$->entryVariableType).arraysize;
                          
  $1->loc->param_cnt = $3->param_cnt;

  $$ = $1;
}
| direct_declarator PARENTHESESOPEN PARENTHESESCLOSE
{

  $$->entryVariableType = $1->loc->type;

  if($1->loc != &(currentSymbolTableKeeper->symboltable[0])) 
    {
      SymbolTable* tofo = (globalSymbolTableKeeper->lookUp($1->loc->name))->ptr;
      symtabentry* p = &(currentSymbolTableKeeper->symboltable[0]);


      globalFType = (tofo->symboltable[1]).type;

      $$->entryVariableType = p->type;
      $1->loc = &(currentSymbolTableKeeper->symboltable[0]);
      $1->loc->declared = 2;

    }

  currentSymbolTableKeeper->setExtrasizeOffset($1->loc,-($1->loc->size));
  (currentSymbolTableKeeper->globalOffset) -= $1->loc->size;
  currentSymbolTableKeeper->update($1->loc->name,FUNCTION,0,0);
                          
  symtabentry* retval = currentSymbolTableKeeper->gentemp();
  currentSymbolTableKeeper->update(retval->name,($$->entryVariableType).variabletype,($$->entryVariableType).next,currentSymbolTableKeeper->globalOffset);
  currentSymbolTableKeeper->globalOffset += retval->size;
  (retval->type).arraysize = ($$->entryVariableType).arraysize;
                          
  $1->loc->param_cnt = 0;
  $$ = $1;
}
| direct_declarator PARENTHESESOPEN identifier_list PARENTHESESCLOSE
{

}
;







pointer:       star 
{

  $$ = 1;
}
|star pointer
{
                
  $$ = $2 + 1;
}
;


parameter_type_list: parameter_list
{
  $$ = $1;
}
;

parameter_list:   parameter_declaration
{
  $$ = $1;
}
| parameter_list comma parameter_declaration
{
                    
  $3->prev_param = $1;
  $$ = $3;
  $$->param_cnt = $1->param_cnt + 1;
}
;

parameter_declaration: declaration_specifiers declarator
{
  $$ = new Etype;
  $$->loc = $2->loc;
  $$->param_cnt = 1;
  $$->prev_param = NULL;
}
| declaration_specifiers
{

}
;

identifier_list:       identifier
{

}
| identifier_list comma identifier
{

}
;


initializer:
assignment_expression
{
  $$ = $1;
}
| CURLYOPEN initializer_row_list CURLYCLOSE
{
 
};


initializer_row_list:
initializer_row 
{ 
}
| initializer_row_list semicolon initializer_row 
{		
};

initializer_row:
designation_opt initializer
{

}
| initializer_row comma integer_constant
{
 
}
| integer_constant 
{
 
}
| initializer_row comma designation_opt initializer
{

};



designation_opt:
{

}
| designation
{

};
designation:         designator_list equal
{

}
;

designator_list:     designator
{

}
| designator_list designator
{

}
;

designator:          SQUAREOPEN constant_expression SQUARECLOSE
{

}
| dot identifier
{

}
;






statement:    labeled_statement
{
  $$ = $1;
}
| compound_statement
{
  $$ = $1;
}
| expression_statement
{
  $$ = $1;
}
| selection_statement
{
  $$ = $1;
}
| iteration_statement
{
  $$ = $1;
}
| jump_statement
{
  $$ = $1;
}
;

iteration_statement: WHILEKEYWORD M1 PARENTHESESOPEN expression PARENTHESESCLOSE N1 M1 statement 
{ 
  $$ = new Stype;
  emit(GOTO,$2->nextinstr);
  backpatch($8->nextlist,$2->nextinstr);
  backpatch($6->nextlist,nextInstruction);
  convert2BOOL($4);
  backpatch($4->truelist,$7->nextinstr);
  $$->nextlist = $4->falselist;  
}
| DOKEYWORD M1 statement M1 WHILEKEYWORD PARENTHESESOPEN expression PARENTHESESCLOSE semicolon 
{ 
                        

  $$ = new Stype;
  convert2BOOL($7);
  backpatch($7->truelist, $2->nextinstr );
  backpatch($3->nextlist, $4->nextinstr );
  $$->nextlist = $7->falselist; 
}
| FORKEYWORD PARENTHESESOPEN expression_opt semicolon M1 expression_opt N1 semicolon M1 expression_opt N1 PARENTHESESCLOSE M1 statement 
{
                        
  $$ = new Stype;
  if($6 != NULL)
    {
      emit(GOTO,$9->nextinstr);
      backpatch($7->nextlist,nextInstruction);
      convert2BOOL($6);
      backpatch($6->truelist, $13->nextinstr);
      backpatch($11->nextlist, $5->nextinstr);
      backpatch($14->nextlist, $9->nextinstr );
      $$->nextlist = $6->falselist;
    }
  else
    {
      emit(GOTO,$9->nextinstr);
      backpatch($7->nextlist,$13->nextinstr);
      backpatch($11->nextlist, $13->nextinstr);
      backpatch($14->nextlist, $9->nextinstr );
    }
}
| FORKEYWORD PARENTHESESOPEN declaration expression_opt semicolon expression_opt PARENTHESESCLOSE statement
{

}
;

jump_statement:      GOTOKEYWORD identifier semicolon
{

}
|CONTINUEKEYWORD semicolon
{

}
|BREAKKEYWORD semicolon
{

}
|RETURNKEYWORD semicolon
{
                      
  emit(RETURN);
  $$=new Stype;
  $$->nextlist = NULL;
}
|RETURNKEYWORD expression semicolon
{

  int param_cnt = (currentSymbolTableKeeper->symboltable[0]).param_cnt;
  symtabentry* retval = &(currentSymbolTableKeeper->symboltable[param_cnt+1]);
  symtabentry* tt = convertBOOL2INT($2);
  symtabentry* tofo = typeCheck(tt,&(retval->type));

                      
  emit(COPY,retval->name,tofo->name);
  emit(RETURN,retval->name,tofo->name);
  $$=new Stype;
  $$->nextlist = NULL;
}
;


labeled_statement:   identifier colon statement
{

}
| CASEKEYWORD constant_expression colon statement
{

}
| DEFAULTKEYWORD colon statement
{

}
;

compound_statement:  CURLYOPEN CURLYCLOSE
{
  $$ = new Stype;
  $$->nextlist = NULL;
}
| CURLYOPEN  block_item_list CURLYCLOSE
{
  $$ = new Stype;
  $$->nextlist = $2->nextlist;
}
;

block_item_list:     block_item
{
  $$ = new Stype;
  $$->nextlist = $1->nextlist;
}
| block_item_list M1 block_item
{
  $$ = new Stype;
  backpatch($1->nextlist,$2->nextinstr);
  $$->nextlist = $3->nextlist;
}
;

block_item:    declaration
{
  $$ = new Stype;
  $$-> nextlist = NULL;
}
| statement
{
  $$ = new Stype;
  $$->nextlist = $1->nextlist;
}
;

expression_statement:  semicolon
{
  $$ = new Stype;
  $$->nextlist = NULL;
}
| expression semicolon
{
  $$ = new Stype;
  $$->nextlist = NULL;
}
;


selection_statement:  IFKEYWORD PARENTHESESOPEN expression PARENTHESESCLOSE N1 M1 statement N1 %prec IFKEYWORDX
{ 
                        
  $$ = new Stype;
  backpatch($5->nextlist,nextInstruction);
  convert2BOOL($3);
  backpatch($3->truelist, $6->nextinstr);
  $$->nextlist = merge($3->falselist, $7->nextlist);
  $$->nextlist = merge($$->nextlist, $8->nextlist);
  backpatch($8->nextlist,nextInstruction);
}
|IFKEYWORD PARENTHESESOPEN expression PARENTHESESCLOSE N1 M1 statement N1 ELSEKEYWORD M1 statement N1
{
                       
                        

  $$ = new Stype;
  backpatch($5->nextlist,nextInstruction);
  convert2BOOL($3);
  backpatch($3->truelist, $6->nextinstr);
  backpatch($3->falselist, $10->nextinstr);
  targetlist temp = merge($7->nextlist,$8->nextlist); 
  $$->nextlist = merge(temp,$11->nextlist);
  $$->nextlist = merge($$->nextlist,$12->nextlist);
  backpatch($8->nextlist,nextInstruction);
  backpatch($12->nextlist,nextInstruction); 
}
|SWITCHKEYWORD PARENTHESESOPEN expression PARENTHESESCLOSE statement
{

}
;

expression_opt:
{
  $$ = NULL;
}
|expression
{
  $$ = $1;
};





external_declaration: function_definition
{

}
| declaration
{

}
;


function_definition:  declaration_specifiers declarator compound_statement
{
  symtabentry* tofo = globalSymbolTableKeeper->lookUp($2->loc->name);
  if(tofo == NULL)
    {
      tofo = globalSymbolTableKeeper->insert($2->loc->name);
    }
  globalSymbolTableKeeper->update(tofo->name,FUNCTION,0,globalSymbolTableKeeper->globalOffset);
  tofo->size = currentSymbolTableKeeper->globalOffset;
  globalSymbolTableKeeper->globalOffset += currentSymbolTableKeeper->globalOffset;
  tofo->param_cnt = $2->loc->param_cnt;
  tofo->ptr = currentSymbolTableKeeper; 
  $2->loc->declared = 2;
  currentSymbolTableKeeper = new SymbolTable;
  currentSymbolTableKeeper->globalOffset = 0;
}
| declaration_specifiers declarator declaration_list compound_statement
{

}
;

declaration_list:     declaration
{

} 
| declaration_list declaration
{

}
;






%%

void yyerror(const char *s)
{
  printf("%s\n",s);
}

