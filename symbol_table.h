#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

typedef struct SymbolEntry {
    char lexeme[256];  // Adjust the size as needed
    char type[32];     // For storing the data type of the identifier
    int line;          // Line number where the identifier was encountered
    struct SymbolEntry* next; // Pointer to the next entry in the table
} SymbolEntry;

void insertSymbol(char* lexeme, char* type, int line);
void printSymbolTable();

#endif