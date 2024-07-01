%{

    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    // Inclua o cabeçalho do lexer
    //#include "lex.yy.h"

    void yyerror(const char *s);
    extern FILE *yyin;
    int yylex(void);
    extern int yylineno;

%}

/* Definições de tokens retornados pelo lexer */
%token INICIOPROG FIMPROG INICIOARGS FIMARGS INICIOVARS FIMVARS ESCREVA INTEIRO REAL LITERAL SE ENTAO FIMSE ENQUANTO FACA FIMENQUANTO NUMERO LITERAL_CONST IDENTIFICADOR OP_RELACIONAL OP_ARITMETICO ATRIBUICAO ABRE_PAR FECHA_PAR VIRGULA PONTO_E_VIRG VAZIO COMENTARIO FIM_DE_ARQ ERRO

/* Declaração de precedência e associatividade dos operadores */
%left OP_RELACIONAL
%left OP_ARITMETICO

%%
/* Definições da linguagem (gramática livre de contexto) */

programa:
    INICIOPROG bloco_programa FIMPROG { printf("Derivação <programa>: INICIOPROG bloco_programa FIMPROG\n"); exit(0); }
    ;

bloco_programa:
    bloco_args bloco_vars bloco_comandos { printf("Derivação <bloco_programa>: bloco_args bloco_vars bloco_comandos\n"); }
    ;

bloco_args:
    INICIOARGS lista_declaracoes FIMARGS { printf("Derivação <bloco_args>: INICIOARGS lista_declaracoes FIMARGS\n"); }
    | /* vazio */ { printf("Derivação <bloco_args>: vazio\n"); }
    ;

bloco_vars:
    INICIOVARS lista_declaracoes FIMVARS { printf("Derivação <bloco_vars>: INICIOVARS lista_declaracoes FIMVARS\n"); }
    | /* vazio */ { printf("Derivação <bloco_vars>: vazio\n"); }
    ;

lista_declaracoes:
    lista_declaracoes declaracao PONTO_E_VIRG { printf("Derivação <lista_declaracoes>: lista_declaracoes declaracao PONTO_E_VIRG\n"); }
    | declaracao PONTO_E_VIRG { printf("Derivação <lista_declaracoes>: declaracao PONTO_E_VIRG\n"); }
    ;

declaracao:
    tipo lista_identificadores { printf("Derivação <declaracao>: tipo lista_identificadores\n"); }
    ;

tipo:
    INTEIRO { printf("Derivação <tipo>: INTEIRO\n"); }
    | REAL { printf("Derivação <tipo>: REAL\n"); }
    | LITERAL { printf("Derivação <tipo>: LITERAL\n"); }
    ;

lista_identificadores:
    lista_identificadores VIRGULA IDENTIFICADOR { printf("Derivação <lista_identificadores>: lista_identificadores VIRGULA IDENTIFICADOR\n"); }
    | IDENTIFICADOR { printf("Derivação <lista_identificadores>: IDENTIFICADOR\n"); }
    ;

bloco_comandos:
    lista_comandos { printf("Derivação <bloco_comandos>: lista_comandos\n"); }
    ;

lista_comandos:
    lista_comandos comando { printf("Derivação <lista_comandos>: lista_comandos comando\n"); }
    | comando { printf("Derivação <lista_comandos>: comando\n"); }
    ;

comando:
    atribuicao PONTO_E_VIRG { printf("Derivação <comando>: atribuicao PONTO_E_VIRG\n"); }
    | comando_se { printf("Derivação <comando>: comando_se\n"); }
    | comando_enquanto { printf("Derivação <comando>: comando_enquanto\n"); }
    | comando_escreva { printf("Derivação <comando>: comando_escreva\n"); }
    ;

atribuicao:
    IDENTIFICADOR ATRIBUICAO expressao { printf("Derivação <atribuicao>: IDENTIFICADOR ATRIBUICAO expressao\n"); }
    ;

comando_se:
    SE ABRE_PAR expressao FECHA_PAR ENTAO lista_comandos FIMSE { printf("Derivação <comando_se>: SE ABRE_PAR expressao FECHA_PAR ENTAO lista_comandos FIMSE\n"); }
    ;

comando_enquanto:
    ENQUANTO ABRE_PAR expressao FECHA_PAR FACA lista_comandos FIMENQUANTO { printf("Derivação <comando_enquanto>: ENQUANTO ABRE_PAR expressao FECHA_PAR FACA lista_comandos FIMENQUANTO\n"); }
    ;

comando_escreva:
    ESCREVA expressao PONTO_E_VIRG { printf("Derivação <comando_escreva>: ESCREVA expressao PONTO_E_VIRG\n"); }
    ;

expressao:
    expressao OP_ARITMETICO expressao { printf("Derivação <expressao>: expressao OP_ARITMETICO expressao\n"); }
    | expressao OP_RELACIONAL expressao { printf("Derivação <expressao>: expressao OP_RELACIONAL expressao\n"); }
    | IDENTIFICADOR { printf("Derivação <expressao>: IDENTIFICADOR\n"); }
    | NUMERO { printf("Derivação <expressao>: NUMERO\n"); }
    | LITERAL_CONST { printf("Derivação <expressao>: LITERAL_CONST\n"); }
    | ABRE_PAR expressao FECHA_PAR { printf("Derivação <expressao>: ABRE_PAR expressao FECHA_PAR\n"); }
    ;

%%

/* Implementação da função yyerror */
void yyerror(const char *s)
{ fprintf(stderr, "Error: %s -- Line: %d\n", s, yylineno); }

/* Main */
int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <arquivo_de_entrada>\n", argv[0]);
        return 1;
    }

    FILE *arquivo = fopen(argv[1], "r");
    if (!arquivo) {
        fprintf(stderr, "Erro ao abrir o arquivo %s\n", argv[1]);
        return 1;
    }

    yyin = arquivo;
    int resultado = yyparse();
    fclose(arquivo);

    return resultado;
}
