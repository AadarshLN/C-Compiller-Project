%{
int length_error_stat = 0;
int flc_comm_count = 0;
int open_double = 0;
int open_single = 0;
int valid_number = 0;
%}
DIGIT [0-9]
%%
[$] {valid_number = 0;}
[0-9]+(\.[0-9]+)?(e[+-][0-9]+)? {valid_number = 1;}
[A-Za-z_][A-Za-z0-9_]* {if(yyleng > 31) {length_error_stat = 1;} else {length_error_stat = 0;}}
"\*" {flc_comm_count++;}
"*/" {if(flc_comm_count > 0) {flc_comm_count--;}}    
\"   {open_double++;}
\'   {open_single++;}

.|\n {}
%%
int yywrap(void)
{
  return 1;
}
int main(void)
{
  yylex();
  
    if(valid_number == 0)
  {
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

  
  return 0;
}
