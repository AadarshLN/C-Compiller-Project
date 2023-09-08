%option yylineno
%{
	int token = 0;
	#include<stdio.h>
	#include<string.h>

	struct SymbolTable{
		char symbol_name[100];
		char symbol_type[100];
		int lineno;
		int exist;
	}ST[1000];
	
	int length_error_stat = 0;
	int flc_comm_count = 0;
	int open_double = 0;
	int open_single = 0;
	int valid_number = 1;
	
	unsigned long hash(unsigned char *str)
	{
		unsigned long hash = 1200;
		int c;

		while (c = *str++)
			hash = ((hash << 5) + hash) + c;

		return hash;
	}

	int search_SymbolTable(char* str){
		unsigned long temp_val = hash(str);
		int val = temp_val%1000;
		
		if(ST[val].exist == 0){
			return 0;
		}
		
		else if(strcmp(ST[val].symbol_name, str) == 0)
		{
			return 1;
		}
		else
		{
			for(int i = val+1 ; i!=val ; i = (i+1)%1000)
			{
				if(strcmp(ST[i].symbol_name,str)==0)
				{
					return 1;
				}
			}
			return 0;
		}
	}

	void insert_SymbolTable(char* name, char* type,int lineNo){
		int index = 0;
		//printf("BBBB");0
		 if(search_SymbolTable(name)){
			//printf("AAAAAA");
			return;
		}
		else{
			unsigned long temp_val = hash(name);
			int val = temp_val%1000;
			if(ST[val].exist == 0){
				strcpy(ST[val].symbol_name, name);
				strcpy(ST[val].symbol_type, type);
				ST[val].exist = 1;
				ST[val].lineno= lineNo;
				return;
			}
			
			for(int i = val+1; i != val; i = (i+1)%1000){
				if(ST[i].exist == 0){
					index = i;
					break;
				}
			}
			strcpy(ST[index].symbol_name, name);
			strcpy(ST[index].symbol_type, type);
			ST[index].exist = 1;			
		}
	}

	void printSymbolTable(){
		printf("\nName\t Type \t LineNo\n");
		for(int i = 0; i < 1000; ++i){
			if(ST[i].exist == 0)
				continue;
				
			printf("%s\t%s\t%d\n", ST[i].symbol_name, ST[i].symbol_type,ST[i].lineno);
		}
	}
%}

DIGIT [0-9]
%% 
[$]			       {valid_number = 0;}
"int"|"float"|"char"           {printf("Keyword   : %s\n",yytext);token++;}
[A-Za-z_][a-zA-Z0-9_]*         {if(yyleng > 31) {length_error_stat = 1;} else {length_error_stat = 0;printf("Identifier: %s\n",yytext);insert_SymbolTable(yytext,"Identifier",yylineno);token++;}}
[,;]                           {printf("Seperator : %s\n",yytext);token++;}
"+"|"-"|"*"|"+="|"="|"++"|"-=" {printf("Operator  : %s\n",yytext);token++;}
"\t"|"\n"                      {printf("Total number of tokens are %d\n",token);}
" "*                            {;}
\/\/.*                         {printf("Comments ignored\n");}
\/\*(.*\n)*.*\*\/(\n)*         {printf("Comments ignored\n");} 
"\*"			       {flc_comm_count++;}
"*/"			       {if(flc_comm_count > 0) {flc_comm_count--;}}
\"			       {open_double++;}
\'			       {open_single++;}
%%


int yywrap(){
    return 1;
}
int main(){
	yyin = fopen("input.c","r");
	yylex();
	printSymbolTable();
//    printf("\nTotal number of tokens are %d\n",token);
	if(valid_number == 0){
		printf("Error : Invalid number\n");
	}
	if(flc_comm_count > 0)
	{
		printf("Error : Open multiline comment \n");
	}
	if(length_error_stat == 1)
	{
		printf("Error : Invalid Identifier length \n");
	}
	if(open_double % 2 != 0)
	{
		printf("Error : unmatched double quote found\n");
	}
	if(open_single % 2 != 0)
	{
		printf("Error : unmatched single quote found\n");
	}
}

