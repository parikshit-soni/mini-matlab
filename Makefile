a.out: lex.yy.o  y.tab.h y.tab.o ass5_15CS30021_translator.h ass5_15CS30021_translator.o ass5_15CS30021_target_translator.o 
	g++ -w lex.yy.o y.tab.o ass5_15CS30021_translator.o  ass5_15CS30021_target_translator.o -lfl

ass5_15CS30021_target_translator.o: ass5_15CS30021_translator.h ass5_15CS30021_target_translator.cxx
	g++ -w -c ass5_15CS30021_target_translator.cxx

ass5_15CS30021_translator.o: ass5_15CS30021_translator.h ass5_15CS30021_translator.cxx
	g++ -w -c ass5_15CS30021_translator.cxx

lex.yy.o: lex.yy.c y.tab.h ass5_15CS30021_translator.o
	g++ -w -c lex.yy.c

lex.yy.c: ass5_15CS30021.l y.tab.h ass5_15CS30021_translator.o
	flex ass5_15CS30021.l

y.tab.h y.tab.c: ass5_15CS30021.y ass5_15CS30021_translator.o
	yacc -dtv ass5_15CS30021.y

y.tab.o: y.tab.c ass5_15CS30021_translator.o
	g++ -w -c y.tab.c

clean: 
	rm a.out ass5_15CS30021_translator.o lex.yy.o lex.yy.c y.output y.tab.c y.tab.h y.tab.o ass5_15CS30021_target_translator.o 

runtest:
	./a.out < mytest1.c > mytest1.s
	gcc mytest1.s -L. -lmyl -o mytest1.out
	./mytest1.out


