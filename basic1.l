%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h" // You would need to define symbol_table.h

int isKeyword(char* lexeme) {
    // List of keywords (you can extend this list as needed)
    char* keywords[] = {
        "if", "else", "while", "for", "int", "float", "return", "break"
        // Add more keywords here
    };

    int numKeywords = sizeof(keywords) / sizeof(keywords[0]);

    for (int i = 0; i < numKeywords; i++) {
        if (strcmp(lexeme, keywords[i]) == 0) {
            return 1; // It's a keyword
        }
    }

    return 0; // It's not a keyword
}

// Function to handle identifier tokens
void handleIdentifier(char* lexeme) {
    // Check if it's a keyword
    if (isKeyword(lexeme)) {
        printf("Keyword: %s\n", lexeme);
    } else {
        printf("Identifier: %s\n", lexeme);
    }
}

// Function to handle numeric tokens
void handleNumber(char* lexeme) {
    // Add code here to detect numeric data types (int, float, etc.)
    printf("Number: %s\n", lexeme);
}

// Function to handle string literals
void handleString(char* lexeme) {
    // Add code here to handle escape sequences and other string-related tasks
    printf("String: %s\n", lexeme);
}

%}

%option noyywrap

DIGIT [0-9]
LETTER [a-zA-Z]
NUMBER {DIGIT}+(\.{DIGIT}+)?
IDENTIFIER ({LETTER}|{DIGIT})*

STRING \"([^\"\\\n]|(\\.))*\"
WS [ \t\n\r]
OPERATOR [=+-/*]

%%

{WS}+      /* Ignore whitespace */

"/*"       { /* Begin a C-style comment */
            int c;
            while ((c = input()) != EOF) {
                if (c == '*') {
                    if ((c = input()) == '/') {
                        break;
                    }
                }
            }
          }

"//"       { /* Begin a C++-style comment */
            int c;
            while ((c = input()) != EOF && c != '\n') {
                // Ignore characters until the end of the line
            }
          }

"#include" { /* Handle #include directive */
            int c;
            while ((c = input()) != EOF && c != '\n') {
                // Collect characters for the included file name
                // Resolve the file path and process it if necessary
            }
          }
{NUMBER} {
            handleNumber(yytext);
          }

{IDENTIFIER} {
            // Check for valid identifier naming convention
            if (yytext[0] >= '0' && yytext[0] <= '9') {
                printf("Lexical Error: Invalid identifier naming convention: %s\n", yytext);
            } else {
                handleIdentifier(yytext);
            }
          }



{STRING} {
            handleString(yytext);
          }

{OPERATOR}  { printf("Operator: %s\n", yytext);}






.         { /* Unrecognized character */
            printf("Unrecognized: %s\n", yytext);
          }

%%

int main(int argc, char* argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE* input_file = fopen(argv[1], "r");
    if (input_file == NULL) {
        perror("Error opening file");
        return 1;
    }

    yyin = input_file;
    yylex();

    fclose(input_file);
    return 0;
}
