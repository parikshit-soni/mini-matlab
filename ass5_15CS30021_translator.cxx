#include <iostream>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <fstream>
#include <vector>
#include "ass5_15CS30021_translator.h"						



ofstream myfile;
void Quad:: writeop(opcodeType op1)
{
	op = op1;
}

void Quad:: writeresult(char *s1)
{
	result = strdup(s1);
}

void Quad:: writearg1(char *s2)
{
	arg1 = strdup(s2);
}

void Quad:: writearg2(char *s3)
{
	arg2 = strdup(s3);
}

void Quad:: writerelop(char *s4)
{
	relationaloperator = strdup(s4);
}

void Quad:: writetarget(int s5) 
{
	target = s5;
}


opcodeType Quad:: getop()
{
	return op;
}

char* Quad:: getresult()
{
	return result;
}

char* Quad:: getarg1()
{
	return arg1;
}

char* Quad:: getarg2()
{
	return arg2;
}

char* Quad:: getrelop()
{
	return relationaloperator;
}

int Quad:: gettarget() 
{
	return target;
}


symtabentry* SymbolTable::insert(char *s)
{
	symtabentry* sp;
	if(countInTable>=MAX_SYMBOLS)
	{
		printf("Too many symbols\n");
		exit(1);
	}
	symboltable[countInTable].name = strdup(s);
	countInTable++;
	sp = &symboltable[countInTable-1];
	return sp;
}


symtabentry* SymbolTable::lookUp(char* s)
{
	symtabentry* sp;
	for(int i=0;i<countInTable;i++)
	{
		if(strcmp(symboltable[i].name,s)==0)
			{
				sp = &symboltable[i];
				return sp;
			}
				
	}

	return NULL;	
}


symtabentry* SymbolTable::gentemp()
{
	char str[10]; 
	sprintf(str, "t%d", registerCountKeeper++);
	return insert(str);
}


void SymbolTable::update(char* s, int num)
{
	symtabentry* entryToChange = lookUp(s);
	if(entryToChange == NULL)
	{
		entryToChange = insert(s);
	}
	entryToChange->value.intval = num;
}

void SymbolTable::update(char* s, double num)
{
	symtabentry* entryToChange = lookUp(s);
	if(entryToChange == NULL)
	{
		entryToChange = insert(s);
	}
	entryToChange->value.doubleval = num;
}

void SymbolTable::update(char* s, void* valsome)
{
	symtabentry* entryToChange = lookUp(s);
	if(entryToChange == NULL)
	{
		entryToChange = insert(s);
	}
	entryToChange->value.voidval = valsome;
}


void SymbolTable::update(char* s, opcodeType type_, entrytype* next_, int offset_,int arraysize_)
{
	symtabentry* entryToChange = lookUp(s);
	if(entryToChange == NULL)
	{
		entryToChange = insert(s);
	}
	switch(type_)
	{
		case CHAR:
		{
			(entryToChange->type).variabletype = type_;
			(entryToChange->type).next  = next_;	
			entryToChange->size = CHAR_SIZE;
			entryToChange->offset = offset_;
			(entryToChange->type).arraysize = arraysize_;
			break;
		}
		case FUNCTION:
		{
			(entryToChange->type).variabletype = type_;
			(entryToChange->type).next  = next_;	
			entryToChange->size = 0;
			entryToChange->offset = offset_;
			(entryToChange->type).arraysize = arraysize_;
			break;
		}
		case INT:
		{
			(entryToChange->type).variabletype = type_;
			(entryToChange->type).next  = next_;
			entryToChange->size = INT_SIZE;
			entryToChange->offset = offset_;
			(entryToChange->type).arraysize = arraysize_;
			break;
		}
		case BOOL:
		{
			(entryToChange->type).variabletype = type_;
			(entryToChange->type).next  = next_;
			entryToChange->size = INT_SIZE;
			entryToChange->offset = offset_;
			(entryToChange->type).arraysize = arraysize_;
			break;
		}
		case PTR:
		{
			(entryToChange->type).variabletype = type_;
			(entryToChange->type).next  = next_;
			entryToChange->size = VOIDPTR_SIZE;
			entryToChange->offset = offset_;
			(entryToChange->type).arraysize = arraysize_;
			break;
		}
		case DOUBLE:
		{
			(entryToChange->type).variabletype = type_;
			(entryToChange->type).next  = next_;
			entryToChange->size = DOUBLE_SIZE;
			entryToChange->offset = offset_;
			(entryToChange->type).arraysize = arraysize_;
			break;
		}
		default:
		{
			(entryToChange->type).variabletype = type_;
			(entryToChange->type).next  = next_;
			entryToChange->offset = offset_;
			(entryToChange->type).arraysize = arraysize_;
			break;
		} 
	}
	
}


void SymbolTable::setExtrasizeOffset(symtabentry* a,int extraadd)
{
	int count = (a - &symboltable[0]) + 1;
	for(;count<countInTable;count++)
	symboltable[count].offset += extraadd;
}

void SymbolTable::print()
{
	printf("\nSymbolTable:\n\n");
	for(int i=0;i<countInTable;i++)
	{
		symboltable[i].print();
	}
}



void symtabentry::print()
{
	if(type.variabletype!=0)
	  {
	  	switch(type.variabletype)
	  	{
	  		case PTR    :
	  		{
	  			entrytype* temp = type.next;
	  			int stars = type.arraysize;
	  			while(temp->next){temp = temp->next;stars++;}
	  			char starmarks[10000];
	  			int j=0;
	  			while(stars--)
	  			{
	  					starmarks[j] = '*';
	  					j = j+1;
	  			}
	  			
	  			switch(temp->variabletype)
	  			{
	  				case CHAR :
	  				{
	  					printf("name: %s , type:char%s , value:NULL , size:%d , offset:%d nested table:%lld",name,starmarks,size,offset,ptr);
	  					break;	  			  					
	  				}
	  				case INT :
	  				{
	  					printf("name: %s , type:int%s , value:NULL , size:%d , countInTable:%d nested table:%lld",name,starmarks,size,offset,ptr);
	  					break;
	  				}
	  				case VOID :
	  				{
	  					printf("name: %s , type:void%s , value:NULL , size:%d , offset:%d nested table:%lld",name,starmarks,size,offset,ptr);
	  					break;	  		
	  				}
	  				case DOUBLE :
	  				{
	  					printf("name: %s , type:double%s , value:NULL , size:%d , offset:%d nested table:%lld",name,starmarks,size,offset,ptr);
	  					break;	  		  			
	  				}
	  				 
	  			}
	  				
	  			break;
	  		}
	  		case ARRAY :
	  		{
	  			printf("name: %s , type: ",name);	  				
	  			int countbrac = 1;
	  			printf("array(%d,",type.arraysize); 
	  			entrytype* temp = type.next;
	  			while(temp->variabletype == ARRAY)
	  			{
	  				printf("array(%d,",type.arraysize); 
	  				temp = temp->next;
	  				countbrac++;
	  			}
	  			
	  			switch(temp->variabletype)
	  			{
	  				case VOID : 
	  				{
	  					printf("void");
	  					while(countbrac--)cout<<")";
	  					printf(" , value:NULL , size:%d , offset:%d nested table:%lld",size,offset,ptr);break;
	  				}
	  				case DOUBLE :
	  				{
	  					printf("double");
	  					while(countbrac--)cout<<")";
	  					printf(", value:NULL , size:%d , offset:%d nested table:%lld",size,offset,ptr);break;	  		 
	  				}	

	  				case INT :
	  				{
	  					printf("int");
	  					while(countbrac--)cout<<")";
	  					printf(", value:NULL , size:%d , offset:%d nested table:%lld",size,offset,ptr);break;
	  				}
	  				case CHAR :
	  				{
	  					printf("char");
	  					while(countbrac--)cout<<")";
	  					printf(" , value:NULL , size:%d , offset:%d nested table:%lld",size,offset,ptr);break;
	  				}

	  			}
	  			
	  			break;
	  		}
	  		case FUNCTION :
	  		{
		
	  			if(ptr != 0)
	  			printf("name: %s , type:function , value:NULL , size:%d , offset:%d nested table:0x%x",name,size,offset,ptr);
	  			else
	  			printf("name: %s , type:function , value:NULL , size:%d , offset:%d nested table:%x",name,size,offset,ptr);
	  				
	  			break;
	  		}
	  		case INT : printf("name: %s , type:int , value:%d , size:%d , offset:%d nested table:%lld",name,value.intval,size,offset,ptr);break;
	  		case CHAR :printf("name: %s , type:char , value:%s , size:%d , offset:%d nested table:%lld",name,value.charstarval,size,offset,ptr);break;
	  		case VOID :printf("name: %s , type:void , value:NULL , size:%d , offset:%d nested table:%lld",name,size,offset,ptr);break;
	  		case DOUBLE :printf("name: %s , type:double , value:%f , size:%d , offset:%d nested table:%lld",name,value.doubleval,size,offset,ptr);break;
	  		
	  	}
	  }
	else
	{
		printf("name: %s , type:NULL , value:NULL , size:NULL , offset:NULL nested table:NULL");	  	
	} 		
	printf("\n\n");	
}

int SymbolTable::GetOffset(char *s)
{
	
	for(int i=0;i<countInTable;i++)
	{
		if(strcmp(symboltable[i].name,s)==0)
			{
				int b = symboltable[i].offset;
				return b;
			}
				
	}
	
}


void Quad::print() 
{
	switch(op)
	{
		case PLUS : 
		{
			myfile<< result<< "= " << arg1 << "+" << arg2 <<endl;	
			break;
		}
		case MINUS : 
		{
			myfile<< result<< "= " << arg1 << "-" << arg2 <<endl;	
				
			//printf("%s = %s - %s\n",result,arg1,arg2);
			break;
		}
		case MULT : 
		{	
			myfile<< result<< "= " << arg1 << "*" << arg2 <<endl;	
			
			//printf("%s = %s * %s\n",result,arg1,arg2);
			break;
		}
		case DIVIDE : 
		{	
			myfile<< result<< "= " << arg1 << "/" << arg2 <<endl;	
			
			//printf("%s = %s / %s\n",result,arg1,arg2);
			break;
		}
		case AND : 
		{	
			myfile<< result<< "= " << arg1 << "&" << arg2 <<endl;	
			
			//printf("%s = %s & %s\n",result,arg1,arg2);
			break;
		}
		case MODULO : 
		{	
			myfile<< result<< "= " << arg1 << "%" << arg2 <<endl;	
			
			//printf("%s = %s %% %s\n",result,arg1,arg2);
			break;
		}
		case IFLESSTHAN:
		{
				myfile<<"if ( " << arg1 << "<" << arg2 << " ) " << "goto " << target<<endl;	
		
			//printf("if ( %s < %s ) goto %d\n",arg1,arg2,target);
			break;		
		}	
		case IFGREATERTHAN:
		{
					myfile<<"if ( " << arg1 << ">" << arg2 << " ) " << "goto " << target<<endl;	
		
			//printf("if ( %s > %s ) goto %d\n",arg1,arg2,target);
			break;		
		}	
		case IFLESSEQUAL:
		{
					myfile<<"if ( " << arg1 << "<" << arg2 << " ) " << "goto " << target<<endl;	
		
			//printf("if ( %s <= %s ) goto %d\n",arg1,arg2,target);
			break;		
		}	
		case IFGREATEREQUAL:
		{
			//printf("if ( %s >= %s ) goto %d\n",arg1,arg2,target);
			break;		
		}
		case IFEQUAL:
		{
					myfile<<"if ( " << arg1 << "==" << arg2 << " ) " << "goto " << target<<endl;	
		
			//printf("if ( %s == %s ) goto %d\n",arg1,arg2,target);
			break;		
		}
		case IFNOTEQUAL:
		{
					myfile<<"if ( " << arg1 << "!=" << arg2 << " ) " << "goto " << target<<endl;	
		
			//printf("if ( %s != %s ) goto %d\n",arg1,arg2,target);
			break;		
		}
		case SHIFT_LEFT : 
		{	
			myfile<< result<< "= " << arg1 << "<<" << arg2 <<endl;	
			
			//printf("%s = %s << %s\n",result,arg1,arg2);
			break;
		}
		case SHIFT_RIGHT : 
		{	
			myfile<< result<< "= " << arg1 << ">>" << arg2 <<endl;	
			
			//printf("%s = %s >> %s\n",result,arg1,arg2);
			break;
		}
		case XOR : 
		{	
			myfile<< result<< "= " << arg1 << "^" << arg2 <<endl;	
			
			//printf("%s = %s ^ %s\n",result,arg1,arg2);
			break;
		}
		case LESS_EQUAL: 
		{
			myfile<< result<< "= " << arg1 << "<=" << arg2 <<endl;	
			
			//printf("%s = %s <= %s \n",result,arg1,arg2);
			break;
		}
		case GREATER_EQUAL: 
		{

			myfile<< result<< "= " << arg1 << ">=" << arg2 <<endl;	
			
			//printf("%s = %s >= %s \n",result,arg1,arg2);
			break;
		}
		case OR: 
		{	
			myfile<< result<< "= " << arg1 << "|" << arg2 <<endl;	
			
			//printf("%s = %s | %s\n",result,arg1,arg2);
			break;
		}
		case LESS: 
		{
			myfile<< result<< "= " << arg1 << "<" << arg2 <<endl;	
			
			//printf("%s = %s < %s \n",result,arg1,arg2);
			break;
		}
		case GREATER: 
		{
			myfile<< result<< "= " << arg1 << ">" << arg2 <<endl;	
			
			//printf("%s = %s > %s \n",result,arg1,arg2);
			break;
		}
		case IS_EQUAL: 
		{

			myfile<< result<< "= " << arg1 << "==" << arg2 <<endl;	
			
			//printf("%s = %s == %s \n",result,arg1,arg2);
			break;
		}
		case NOT_EQUAL: 
		{

			myfile<< result<< "= " << arg1 << "!=" << arg2 <<endl;	
			
			//printf("%s = %s != %s\n",result,arg1,arg2);
			break;
		}
		case ARRAY_COPY:
		{

			myfile<< result<< "= " << arg1 << "[" << arg2 <<"]"<<endl;	
			
			//printf("%s = %s[%s]\n",result,arg1,arg2);
			break;	
		}
		case COPY:
		{

			myfile<< result<< "= " << arg1 <<endl;	
			
			//printf("%s = %s\n",result,arg1);
			break;	
		}
		case COPY_TO_ARRAY:
		{

			myfile<< result<< "[" << arg1 << "] =" << arg2 <<endl;	
			
			//printf("%s[%s] = %s\n",result,arg1,arg2);
			break;	
		}
		case PARAM:
		{

			myfile<< "param " << result<<endl;	
			
			//printf("param %s\n",result);
			break;	
		}
		case CALL:
		{
			if(string(result) != "printi" && string(result) != "prints")
			{
				myfile<< result<< "= call" << arg1 << "," << arg2 <<endl;	
			
				//printf("%s = call %s, %s\n",result,arg1,arg2);
			}
			else
			{
				myfile<< "call " << arg1 << "," << arg2 <<endl;	
			
				//printf("call %s, %s\n",result,arg2);	
			}

			break;	
		}
		case LOGICAL_AND: 
		{	
			myfile<< result<< "= " << arg1 << "&&" << arg2 <<endl;	
			
			//printf("%s = %s && %s\n",result,arg1,arg2);
			break;
		}
		case LOGICAL_OR: 
		{	
			myfile<< result<< "= " << arg1 << "||" << arg2 <<endl;	
			
			//printf("%s = %s || %s\n",result,arg1,arg2);
			break;
		}		
		case UNARY_AND:
		{
			myfile<< result<< "= &" << arg1<<endl;	
			
			//printf("%s = &%s\n",result,arg1);
			break;	
		}
		case STAR:
		{
			myfile<< result<< "= *" << arg1<<endl;	
			
			//printf("%s = *%s\n",result,arg1);
			break;	
		}
		case TYPE_CAST:
		{
			myfile<< result<< "= "<< arg1<<"("<<arg2<<")"<<endl;	
			
			//printf("%s = %s(%s)\n",result,arg1,arg2);
			break;	
		}
		case UNARY_MINUS : 
		{
			myfile<< result<< "= -" << arg1<<endl;	
		
			//printf("%s = -%s\n",result,arg1);		
			break;
		}
		case UNARY_PLUS : 
		{
				myfile<< result<< "= +" << arg1<<endl;	
		
			//printf("%s = +%s\n",result,arg1);
			break;
		}
		case COMPLEMENT : 
		{
				myfile<< result<< "= ~" << arg1<<endl;	
		
			//printf("%s = ~%s\n",result,arg1);	
			break;
		}
		case NOT: 
		{
				myfile<< result<< "= !" << arg1<<endl;	
		
			//printf("%s = !%s\n",result,arg1);
			break;
		}
		case COPY_TO_PTR:
		{
			for(int i=0;i<target;i++)myfile << "*";
						myfile<<result <<" = "<<arg1<<endl;	
			
			//printf("%s = %s\n",result,arg1);
			break;
		}
		case COPY_FROM_PTR:
		{
			myfile<<result <<" = "<<endl;	
			
			//printf("%s = ",result);
			for(int i=0;i<target;i++)cout << "*";
							myfile<<arg1<<endl;	
			//printf("%s\n",arg1);
			break;
		}
		case GOTO:
		{
					myfile<<"goto " <<target<<endl;	
		
			//printf("goto %d\n",target);
			break;		
		}
		case RETURN:
		{
					myfile<<"return " <<arg1<<endl;	
		
			//printf("return %s\n",arg1);
			break;		
		}

	}	
}

void emit(opcodeType op1, char *s1, char *s2, char *s3, int addr)
{
	if(op1 != IFLESSTHAN && op1 != IFGREATERTHAN && op1 != IFLESSEQUAL && op1 != IFGREATEREQUAL && op1 != IFEQUAL&& op1 != IFNOTEQUAL)
	{
		QuadArrayKeeper[nextInstruction].writeop(op1);
   		QuadArrayKeeper[nextInstruction].writeresult(s1);
   		if(s2)
   		{
   			QuadArrayKeeper[nextInstruction].writearg1(s2);	
   		}
   		
   		if(s3)
   		{
   			QuadArrayKeeper[nextInstruction].writearg2(s3);
   		}
   			
	}
	else
	{
		QuadArrayKeeper[nextInstruction].writeop(op1);
   		QuadArrayKeeper[nextInstruction].writearg1(s1);
   		QuadArrayKeeper[nextInstruction].writearg2(s2);
   		QuadArrayKeeper[nextInstruction].writetarget(addr);
	}
   	nextInstruction = nextInstruction+ 1;
}




void emit(opcodeType op1, char *s1, double num)
{
    char s[15];
	sprintf(s,"%lf",num);
	QuadArrayKeeper[nextInstruction].writeop(op1);
   	QuadArrayKeeper[nextInstruction].writeresult(s1);
   	QuadArrayKeeper[nextInstruction].writearg1(s);
   	nextInstruction = nextInstruction+ 1;
}

void emit(opcodeType op1, char *s1, char num)
{
    char s[15];
	sprintf(s,"%c",num);
	QuadArrayKeeper[nextInstruction].writeop(op1);
   	QuadArrayKeeper[nextInstruction].writeresult(s1);
   	QuadArrayKeeper[nextInstruction].writearg1(s);
   	nextInstruction = nextInstruction+ 1;
}



void emit(opcodeType op1, int addr)
{
	QuadArrayKeeper[nextInstruction].writeop(op1);
	QuadArrayKeeper[nextInstruction].writetarget(addr);
	nextInstruction = nextInstruction + 1;
}


targetlist makelist(int i)
{
	targetlist newnode = new targetlistnode;
	newnode->addr = &(QuadArrayKeeper[i]);
	newnode->next = NULL;
	return newnode;
}

targetlist merge(targetlist p1, targetlist p2)
{
	if(p1 == NULL)return p2;
	if(p2 == NULL)return p1;
	targetlist newnode = p1;
	targetlist temp = p1;
	while(temp->next)temp=temp->next;
	temp->next = p2;
	return newnode;
}

void backpatch(targetlist p1, int addr_)
{
	if(p1==NULL)return;
	targetlist temp = p1;
	while(temp)
	{
		(temp->addr)->writetarget(addr_);
		temp=temp->next;
	}
}



symtabentry* typeCheck(symtabentry* a,entrytype* type)
{
	
	char starmarker[100];
	if((((a->type).variabletype) == CHAR) && ((type->variabletype) == INT)) 
	{
		symtabentry* bnew = globalSymbolTableKeeper->gentemp();
		globalSymbolTableKeeper->update(bnew->name,INT,0,(currentSymbolTableKeeper->globalOffset));
		for(int j=0;j<a->declared;j++)
		{
			starmarker[j] = '*';
		}
		currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset+INT_SIZE;
		emit(TYPE_CAST,bnew->name,"chartoint",a->name); 
		return bnew;
	}
	if((((a->type).variabletype) == INT) && ((type->variabletype) == CHAR)) 
	{
		symtabentry* bnew = globalSymbolTableKeeper->gentemp();
		globalSymbolTableKeeper->update(bnew->name,CHAR,0,(currentSymbolTableKeeper->globalOffset));
		for(int j=0;j<a->declared;j++)
		{
			starmarker[j] = '*';
		}
		currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset+CHAR_SIZE;
		emit(TYPE_CAST,bnew->name,"inttochar",a->name); 
		return bnew;
	}
	if((((a->type).variabletype) == INT) && ((type->variabletype) == DOUBLE)) 
	{	
		symtabentry* bnew = globalSymbolTableKeeper->gentemp();
		globalSymbolTableKeeper->update(bnew->name,DOUBLE,0,(currentSymbolTableKeeper->globalOffset));
		for(int j=0;j<a->declared;j++)
		{
			starmarker[j] = '*';
		}
		currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset + DOUBLE_SIZE;
		emit(TYPE_CAST,bnew->name,"inttodouble",a->name); 
		return bnew;
	}
	if((((a->type).variabletype) == DOUBLE) && ((type->variabletype) == INT)) 
	{
		symtabentry* bnew = globalSymbolTableKeeper->gentemp();
		globalSymbolTableKeeper->update(bnew->name,INT,0,(currentSymbolTableKeeper->globalOffset));
		for(int j=0;j<a->declared;j++)
		{
			starmarker[j] = '*';
		}
		currentSymbolTableKeeper->globalOffset = currentSymbolTableKeeper->globalOffset + INT_SIZE;
		emit(TYPE_CAST,bnew->name,"doubletoint",a->name); 
		return bnew;
	}
	return a;
}
