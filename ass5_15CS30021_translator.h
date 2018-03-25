#ifndef __PARSER_H								
#define __PARSER_H
#include <bits/stdc++.h>
#include <iostream>
#include <vector>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
using namespace std;
#define VOIDPTR_SIZE	8
#define INT_SIZE        8
#define DOUBLE_SIZE		8
#define CHAR_SIZE		8
#define PTR_SIZE   		8

#define MAX_SYMBOLS        200

class Quad;
class SymbolTable;

typedef enum {
	
	PLUS = 1,MINUS,MULT,DIVIDE,AND,MODULO,SHIFT_LEFT,SHIFT_RIGHT,XOR,OR,LOGICAL_AND,LOGICAL_OR,LESS,GREATER,IS_EQUAL,NOT_EQUAL,LESS_EQUAL,
	GREATER_EQUAL,UNARY_MINUS,UNARY_PLUS,UNARY_AND,STAR,COMPLEMENT,NOT,COPY,ARRAY_COPY,COPY_TO_ARRAY,TYPE_CAST,	CALL,COPY_TO_PTR,COPY_FROM_PTR,PARAM,					
	RETURN,IF,GOTO,DEF,VOID,CHAR,INT,DOUBLE,BOOL,PTR,ARRAY,FUNCTION,IFLESSTHAN,IFGREATERTHAN,IFLESSEQUAL,IFGREATEREQUAL,IFEQUAL,IFNOTEQUAL
	
} opcodeType;




class Quad
{
	opcodeType op;
	char *result, *arg1, *arg2;
	char* relationaloperator;
	int target;

	public:
	
	Quad(){}

	void writeop(opcodeType opcode);
	void writeresult(char *s1);
	void writearg1(char *arg1_);
	void writearg2(char *arg2_);
	void writerelop(char *relop_);
	void writetarget(int target_);

	opcodeType getop();
	char* getresult();
	char* getarg1();
	char* getarg2();
	char* getrelop();
	int gettarget();
	void print();
};




typedef struct targetlistnode_
{
	Quad* addr;
	struct targetlistnode_* next;
}targetlistnode;


typedef targetlistnode* targetlist;


typedef union valInEntry_
{
	int intval;
	double doubleval;
	void* voidval;
	char* charstarval;
}valInEntry;

typedef struct entrytype_
{
	opcodeType variabletype;
	int arraysize;
	struct entrytype_* next;		
}entrytype;


typedef struct symtabentry_{
	public:
		char *name;
		entrytype type;
		SymbolTable *ptr;
		int param_cnt;
		int declared;
		int flag1;
		int flag2;
		valInEntry value;
		int size;
		int offset;
		void print();
}symtabentry;

void emit(opcodeType op1, char *s1, char* s2, int num);
	
void emit(opcodeType op1, char *s1, int num, char *s2);


typedef struct Etype_
{
	struct symtabentry_* loc;
	struct symtabentry_* present_param;
	struct entrytype_ entryVariableType;
	struct Etype_* prev_param;
	int param_cnt;
	targetlist truelist;
	targetlist falselist;
	char* arrayname;
	int val;
}Etype;


typedef struct Mtype_
{
	int nextinstr;
}Mtype;


void stringadder(string);
string getlabel(string);
bool checknum(const string& s);
class SymbolTable{
	
  	
  	public:
		struct symtabentry_ symboltable[MAX_SYMBOLS];
		int countInTable;
		int globalOffset;
		string nameOfThis;		

		void update(char* s, int num);
		void update(char* s, double num);
		void update(char* s, void* valsome);
		void update(char* s, opcodeType typeOfEntry, entrytype* nextentrytype, int offsetThis,int arraysize_=0);		
		symtabentry *insert(char *s);
		symtabentry *lookUp(char* s);
		symtabentry *gentemp();
		void setExtrasizeOffset(symtabentry* a, int extraadd);
		int GetOffset(char* a);
		void print();

};

void emit(opcodeType op1, char *s1, char *s2, char *s3=0, int addr=0);
	
void emit(opcodeType op1, char *s1, int num=0);

void emit(opcodeType op1, char *s1, double num);



typedef struct Ntype_
{
	targetlist nextlist;
}Ntype;


typedef struct Stype_
{
	targetlist nextlist;
}Stype;

//GLOBAL FUNCTIONS

void makinglabels();

void makeAsm();


	
void emit(opcodeType op1, char *s1, char num);

void emit(opcodeType op1, int addr=0);


	
targetlist makelist(int i);

targetlist merge(targetlist p1, targetlist p2);

void backpatch(targetlist p1, int addr_);

symtabentry* convertBOOL2INT(Etype* a);

void convert2BOOL(Etype* a);

symtabentry* typeCheck(symtabentry* a,entrytype* type);

extern int registerCountKeeper;
extern  int symbolCountkeeper;
extern	int nextInstruction;
extern Quad QuadArrayKeeper[1000];
extern SymbolTable* globalSymbolTableKeeper;
extern SymbolTable* currentSymbolTableKeeper;
extern ofstream myfile;

#endif // __PARSER_H
