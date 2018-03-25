#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <vector>
#include "ass5_15CS30021_translator.h"						

int yyparse();
map<int, string> labels;
map<string, string> stringKeeper;

void makinglabels()
{
	int labelnum = 0;
	for(int i=0; i<nextInstruction; i++)
	{
		if(QuadArrayKeeper[i].getop() == IFGREATERTHAN ||
			QuadArrayKeeper[i].getop() == IFLESSTHAN ||
			QuadArrayKeeper[i].getop() == IFEQUAL ||
			 QuadArrayKeeper[i].getop() == GOTO || 
			QuadArrayKeeper[i].getop() == IFLESSEQUAL ||
			QuadArrayKeeper[i].getop() == IFGREATEREQUAL ||
			QuadArrayKeeper[i].getop() == IFNOTEQUAL)
		{
			string lab = ".L";
			stringstream ss;
			ss << labelnum;
			labelnum++;
			string str = ss.str();
			lab = lab + str;
			labels[QuadArrayKeeper[i].gettarget()] = lab;
		}
	}
}

bool checknum(const std::string& s)
{
    std::string::const_iterator it = s.begin();
    while (it != s.end() && std::isdigit(*it)) ++it;
    return !s.empty() && it == s.end();
}


void makeAsm()
{
	string buff;
	SymbolTable* curr = globalSymbolTableKeeper;
	bool scoped = false;
	int parsize = 0;
	int king=0;
	int negparsize;
	makinglabels();
	cout << "\t.section\t.rodata\n";
	for(map<string,string>::iterator it = stringKeeper.begin(); it != stringKeeper.end(); it++)
	{
		cout << "\t" << (*it).second << ":\t.string\t" <<(*it).first<<"\n";
	}
	
	symtabentry_* sp;
	for(sp = globalSymbolTableKeeper->symboltable;sp < &(globalSymbolTableKeeper->symboltable[200]);sp++){
		if(!sp->name){
			break;
		}
		if(sp->ptr == NULL){
		
		}
		else {

			curr = sp->ptr;
			if(curr->nameOfThis != "printi" && curr->nameOfThis != "prints" && curr->nameOfThis != "readi")
			{
				string ss1 = "";
				ss1 += "\t.text\n";
				ss1 += "\t.globl "+curr->nameOfThis+"\n";
				ss1 += "\t.type "+curr->nameOfThis+", @function\n";
				ss1 += curr->nameOfThis + ":\n";
				ss1 += "\tpushq %rbp\n";
				ss1 += "\tmovq %rsp, %rbp\n";
				int j=curr->symboltable[0].param_cnt;
				int i;
				for(i=0;i<j;i++)
				{
					if(i==0)
					{
						ss1 += "\tmovq %rdi, -8(%rbp)\n";		
					}
					else if(i==1)
					{
						ss1 += "\tmovq %rsi, -16(%rbp)\n";					
					}
					else if(i==2)
					{
						ss1 += "\tmovq %rdx, -24(%rbp)\n";					
					}
				}
				stringstream ss;
				ss << curr->globalOffset;
				string str = ss.str();		
				ss1 += "\tsubq $"+str+", %rsp\n";
				cout << ss1;	
			}
			
	for(int i=king; i<nextInstruction; i++)
	{
		buff = "";
		stringstream ss;
		string str ;
		int flag =0;
		if(labels.find(i) != labels.end()) buff += labels[i]+":\n";
		switch(QuadArrayKeeper[i].getop())
		{
			case PLUS:

				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				if(checknum(QuadArrayKeeper[i].getarg2()))
				{
					ss<< QuadArrayKeeper[i].getarg2();
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\taddq $"+str+", %rax\n";										
				}
				else
				{
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\taddq "+str+"(%rbp), %rax\n";
			
				}
				
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rax, "+str+"(%rbp)\n";
				break;

			case MINUS:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				
				if(checknum(QuadArrayKeeper[i].getarg2()))
				{
					ss<< QuadArrayKeeper[i].getarg2();
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tsubq $"+str+", %rax\n";										
				}
				else
				{
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tsubq "+str+"(%rbp), %rax\n";
			
				}


				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rax, "+str+"(%rbp)\n";
				break;

			case MULT:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				if(checknum(QuadArrayKeeper[i].getarg2()))
				{
					ss<< QuadArrayKeeper[i].getarg2();
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\timulq  $"+str+",%rax\n";										
				}
				else
				{
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\timulq "+str+"(%rbp), %rax\n";				
				}
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rax, "+str+"(%rbp)\n";
				break;

			case DIVIDE:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				if(checknum(QuadArrayKeeper[i].getarg2()))
				{					
					buff += "\tcqto\n";
					ss << QuadArrayKeeper[i].getarg2();
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tidivq $"+str+"\n";										
				}
				else
				{
					buff += "\tcqto\n";
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tidivq "+str+"(%rbp)\n";
				}
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rax, "+str+"(%rbp)\n";
				break;

			case MODULO:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				if(checknum(QuadArrayKeeper[i].getarg2()))
				{					
					buff += "\tcqto\n";
					ss << QuadArrayKeeper[i].getarg2();
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tidivq $"+str+"\n";										
				}
				else
				{
					buff += "\tcqto\n";
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tidivq "+str+"(%rbp)\n";
				}
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rdx, "+str+"(%rbp)\n";
				break;

			case GOTO:
				buff += "\tjmp "+labels[QuadArrayKeeper[i].gettarget()]+"\n";
				break;
				
			case IFGREATERTHAN:				
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tcmpq "+str+"(%rbp), %rax\n";
				buff += "\tjg "+labels[QuadArrayKeeper[i].gettarget()]+"\n";
				break;

			case IFLESSTHAN:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tcmpq "+str+"(%rbp), %rax\n";
				buff += "\tjl "+labels[QuadArrayKeeper[i].gettarget()]+"\n";
				break;


			case IFLESSEQUAL:				
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tcmpq "+str+"(%rbp), %rax\n";
				buff += "\tjle "+labels[QuadArrayKeeper[i].gettarget()]+"\n";
				break;

			case IFGREATEREQUAL:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tcmpq "+str+"(%rbp), %rax\n";
				buff += "\tjge "+labels[QuadArrayKeeper[i].gettarget()]+"\n";
				break;

			case IFEQUAL:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tcmpq "+str+"(%rbp), %rax\n";
				buff += "\tje "+labels[QuadArrayKeeper[i].gettarget()]+"\n";
				break;

			case IFNOTEQUAL:				
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tcmpq "+str+"(%rbp), %rax\n";
				buff += "\tjne "+labels[QuadArrayKeeper[i].gettarget()]+"\n";
				break;

			case COPY:
				if(checknum(QuadArrayKeeper[i].getarg1()))
				{
					ss<< QuadArrayKeeper[i].getarg1();
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tmovq $"+str+", %rax\n";					
					
				}
				else
				{

					if(stringKeeper.find(QuadArrayKeeper[i].getarg1()) != stringKeeper.end()) 
					{						

						string lax =stringKeeper[QuadArrayKeeper[i].getarg1()];
						buff += "\tmovq $"+lax+",%rax\n";					
						
					}
					else
					{
						ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
						str = ss.str();
						ss.clear();
						ss.str(string());
						buff += "\tmovq "+str+"(%rbp), %rax\n";					
							
					}
				}
				
				
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rax, "+str+"(%rbp)\n";
				
				break;

			case ARRAY_COPY:

				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq $"+str+", %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tsubq "+str+"(%rbp), %rax\n";
				buff += "\tmovq 0(%rbp,%rax,1), %rdx\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rdx, "+str+"(%rbp)\n";
				break;

			case COPY_TO_ARRAY:
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq $"+str+", %rax\n";
				ss<< -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tsubq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg2());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rdx\n";
				buff += "\tmovq %rdx, 0(%rbp,%rax,1)\n";
				break;

			case PARAM:
				if(string(QuadArrayKeeper[i+1].getarg1()) == "prints")
				{
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tmovq "+str+"(%rbp), %rax\n";
					buff += "\tmovq %rax,-8(%rsp)\n";
					parsize += 8;
					 
				}
				else
				{
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tmovq "+str+"(%rbp), %rax\n";
					negparsize =- 1*parsize;
					ss<< negparsize;
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tmovq %rax,"+str+"(%rsp)\n";
					parsize += 8;
					
				}	
				break;

			case CALL:
				ss << QuadArrayKeeper[i].getarg1();
				str = ss.str();
				ss.clear();
				ss.str(string());
				if(str == "printi")
				{
					buff += "\tmovq 0(%rsp),%rdi\n";	
					buff += "\tcall "+str+"\n";
					parsize = 0;
				}
				else if(str == "prints")
				{
					buff += "\tmovq -8(%rsp),%rdi\n";
					buff += "\tcall "+str+"\n";
					parsize = 0;
				}
				else
				{
					char *checkeratoi = QuadArrayKeeper[i].getarg2();

					int kappayo = atoi(checkeratoi);
					int jayo;
					for(jayo=0;jayo<=kappayo-1;jayo++)
					{
						if(jayo==0)
						{
							parsize = parsize - 8;
							negparsize = -1*parsize;
							ss<< negparsize;
							str = ss.str();
							ss.clear();
							ss.str(string());
							buff += "\tmovq "+str+"(%rsp),%rdi\n";
						}
						else if(jayo==1)
						{

							parsize = parsize - 8;
							negparsize = -1*parsize;
							ss<< negparsize;
							str = ss.str();
							ss.clear();
							ss.str(string());
							buff += "\tmovq "+str+"(%rsp),%rsi\n";
						}
						else if(jayo==2)
						{
								parsize = parsize - 8;
								negparsize = -1*parsize;
								ss<< negparsize;
								str = ss.str();
								ss.clear();
								ss.str(string());
								buff += "\tmovq "+str+"(%rsp),%rdx\n";
							
						}
					}	
					ss << QuadArrayKeeper[i].getarg1();
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tcall "+str+"\n";
					ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
					str = ss.str();
					ss.clear();
					ss.str(string());
					buff += "\tmovq %rax, "+str+"(%rbp)\n";
					parsize = 0;
				}
				
				break;

			case COPY_TO_PTR:
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rdx\n";
				buff += "\tmovq %rdx, 0(%rax)\n";
				break;	

			case UNARY_AND:
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tleaq "+str+"(%rbp), %rax\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rax, "+str+"(%rbp)\n";
				break;

			case STAR:
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp), %rax\n";
				buff += "\tmovq (%rax), %rdx\n";
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getresult());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq %rdx, "+str+"(%rbp)\n";
				break;			
				
				
			case RETURN:
				ss << -1*curr->GetOffset(QuadArrayKeeper[i].getarg1());
				str = ss.str();
				ss.clear();
				ss.str(string());
				buff += "\tmovq "+str+"(%rbp),%rax\n";
				ss << curr->globalOffset;
				str = ss.str();
				ss.clear();
				ss.str(string());

				stringstream ss;
				ss << curr->globalOffset;
				string str = ss.str();	
				buff += "\taddq $"+str+", %rsp\n";
				buff += "\tpopq %rbp\n";
				buff += "\tret\n";
				flag = 1;
				break;
		}

		cout<<buff;
		if(flag == 1)
		{
			king = i+1;
			break;
		}
	}	


		}
	}

}


int stringnumber = 0;

void stringadder(string s)
{
	if(stringKeeper.find(s) == stringKeeper.end()) 
	{
		string lab = ".LC";
		stringstream ss;
		ss << stringnumber;
		stringnumber++;
		string str = ss.str();
		lab = lab + str;
		stringKeeper[s] = lab;
	}	
}

string getlabel(string s)
{
	return stringKeeper[s];
}

void emit(opcodeType op1, char *s1, int num)
{
    char s[15];
	sprintf(s,"%d",num);
	QuadArrayKeeper[nextInstruction].writeop(op1);
   	QuadArrayKeeper[nextInstruction].writeresult(s1);
   	QuadArrayKeeper[nextInstruction].writearg1(s);
   	nextInstruction = nextInstruction+ 1;
}

void emit(opcodeType op1, char *s1, char*s2, int num)
{
	char s[15];
	sprintf(s,"%d",num);
	QuadArrayKeeper[nextInstruction].writeop(op1);
   	QuadArrayKeeper[nextInstruction].writeresult(s1);
   	QuadArrayKeeper[nextInstruction].writearg1(s2);
   	QuadArrayKeeper[nextInstruction].writearg2(s);
   	nextInstruction = nextInstruction+ 1;
}

void emit(opcodeType op1, char *s1, int num, char*s2)
{
   QuadArrayKeeper[nextInstruction].writeop(op1);
   QuadArrayKeeper[nextInstruction].writetarget(num);
   QuadArrayKeeper[nextInstruction].writeresult(s1);
   QuadArrayKeeper[nextInstruction].writearg1(s2);
   nextInstruction = nextInstruction+ 1;
}

void convert2BOOL(Etype* a)
{
	if((a->entryVariableType).variabletype == BOOL) return;
	a->falselist = makelist(nextInstruction);	
	a->truelist = makelist(nextInstruction + 1);
	emit(IFEQUAL,a->loc->name,"0");
	emit(GOTO);
	return;
}


symtabentry* convertBOOL2INT(Etype* a)
{
	if((a->entryVariableType).variabletype != BOOL)return a->loc;
	symtabentry* t = currentSymbolTableKeeper->gentemp();
	currentSymbolTableKeeper->update(t->name,INT,0,(currentSymbolTableKeeper->globalOffset));
	(currentSymbolTableKeeper->globalOffset) += t->size;
	backpatch(a->truelist,nextInstruction);
	backpatch(a->falselist,nextInstruction+2);
	emit(COPY,t->name,1);
	emit(GOTO,nextInstruction+2);
	emit(COPY,t->name,0);
	return t;
}
int main()
{
	
	globalSymbolTableKeeper = new SymbolTable;
	currentSymbolTableKeeper = new SymbolTable;
	currentSymbolTableKeeper->globalOffset = 0;

	yyparse();




	char* symbolTableName[200];
	SymbolTable* symbolTableMaterial[200];
	symbolTableName[0] = "Global";
	globalSymbolTableKeeper->nameOfThis = "Global";
	symbolTableMaterial[0] = globalSymbolTableKeeper;
	symtabentry_* sp;
	int j=1;
	

		
	symtabentry* ThisisAdder=globalSymbolTableKeeper->insert("printi");
	globalSymbolTableKeeper->update(ThisisAdder->name,FUNCTION,0,0);
	ThisisAdder->ptr = new SymbolTable;
	ThisisAdder->ptr->nameOfThis = "printi";
	symtabentry *pp = ThisisAdder->ptr->insert("printi");
	ThisisAdder->declared = pp->declared = 2;
	ThisisAdder->param_cnt = pp->param_cnt = 1;
	ThisisAdder->ptr->update(pp->name,FUNCTION,0,0);
	pp = ThisisAdder->ptr->insert("n");
	ThisisAdder->ptr->update(pp->name,INT,0,0,1);
	pp = ThisisAdder->ptr->gentemp();
	ThisisAdder->ptr->update(pp->name,INT,0,8,0);
	

	ThisisAdder = globalSymbolTableKeeper->insert("prints");
	globalSymbolTableKeeper->update(ThisisAdder->name,FUNCTION,0,0);
	ThisisAdder->ptr = new SymbolTable;
	ThisisAdder->ptr->nameOfThis = "prints";
	pp = ThisisAdder->ptr->insert("prints");
	ThisisAdder->declared = pp->declared = 2;
	ThisisAdder->param_cnt = pp->param_cnt = 1;
	ThisisAdder->ptr->update(pp->name,FUNCTION,0,0);
	pp = ThisisAdder->ptr->insert("str");
	entrytype* type1 = new entrytype;
	type1->variabletype = CHAR;
	type1->next = 0;
	type1->arraysize = 0;
	ThisisAdder->ptr->update(pp->name,PTR,type1,0,1);
	pp = ThisisAdder->ptr->gentemp();
	ThisisAdder->ptr->update(pp->name,INT,0,8,0);
	

	ThisisAdder = globalSymbolTableKeeper->insert("readi");
	globalSymbolTableKeeper->update(ThisisAdder->name,FUNCTION,0,0);
	ThisisAdder->ptr = new SymbolTable;
	ThisisAdder->ptr->nameOfThis = "readi";
	pp = ThisisAdder->ptr->insert("readi");
	ThisisAdder->declared = pp->declared = 2;
	ThisisAdder->param_cnt = pp->param_cnt = 0;
	ThisisAdder->ptr->update(pp->name,FUNCTION,0,0);
	pp = ThisisAdder->ptr->gentemp();
	ThisisAdder->ptr->update(pp->name,INT,0,0,0);

	for(sp = globalSymbolTableKeeper->symboltable;sp < &(globalSymbolTableKeeper->symboltable[200]);sp++){
		if(!sp->name){
			break;
		}
		if(sp->ptr == NULL){
		
		}
		else {
			symbolTableName[j] = strdup(sp->name);
			symbolTableMaterial[j] = sp->ptr;
			symbolTableMaterial[j]->nameOfThis = symbolTableName[j];
			j = j + 1;
		}
	}
	
  	myfile.open ("quads.out");
	myfile << "The Quad Array: \n";
	int i=1;
	while(i<nextInstruction)
	{
		myfile  << i << ":   ";
  		
		QuadArrayKeeper[i].print();
		i++;	
	}

	  myfile.close();
	
	int k=0;
	while(k < j)
	{
		symbolTableMaterial[k]->setExtrasizeOffset(&(symbolTableMaterial[k]->symboltable[0]),8);
		k++;
	}
	
	/*
	k=0;
	while(k < j)
	{
		cout << "\nSymbol Table of "+symbolTableMaterial[k]->nameOfThis+"\n";
		symbolTableMaterial[k]->print();
		k++;
	}
	*/
	
	makeAsm();
	return 0;

}



