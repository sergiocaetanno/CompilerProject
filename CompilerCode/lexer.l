%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "parser.tab.h"

    // Definição de uma estrutura para um símbolo
    typedef struct Simbolo {
        char *lexema;
        char *token;
        struct Simbolo *prox;
    } Simbolo;
  
    // Iniciando tabela de simbolos
    struct Simbolo *inicio_tabela = NULL;


    Simbolo *buscarSimbolo(const char *lexema){
        if(inicio_tabela == NULL){
            return NULL;
        }
        else{
            struct Simbolo *atual = inicio_tabela;
            int resultado_comparacao;

            while(atual != NULL){

            resultado_comparacao = strcmp(atual->lexema, lexema);
            //printf("\n\n%s,%s\n\n", atual->lexema, lexema);  //linha de teste da comparação

            if(resultado_comparacao == 0){
                return atual;
            }
                
            atual = atual->prox;            
            }
        return NULL;
        }
    }

	void inserir_simbolo(const char *lexema, const char *token) {
		// Aloca memória para o novo símbolo
		struct Simbolo *novo_simbolo = (Simbolo *)malloc(sizeof(Simbolo));
		if (novo_simbolo == NULL) {
			fprintf(stderr, "Erro ao alocar memória para o novo símbolo.\n");
			exit(EXIT_FAILURE);
		}

		// Copia o lexema e o token para o novo símbolo
		novo_simbolo->lexema = strdup(lexema);
		novo_simbolo->token = strdup(token);
		novo_simbolo->prox = NULL;

		// Insere o novo símbolo no final da lista
		if (inicio_tabela == NULL) {
			inicio_tabela = novo_simbolo;
		} else {
            Simbolo *busca = buscarSimbolo(lexema);
   
            if(busca == NULL){

			    struct Simbolo *atual = inicio_tabela;
			    while (atual->prox != NULL) {
				    atual = atual->prox;
			    }
			    atual->prox = novo_simbolo;
            }
		}
	}

	void exportar_tabela(const char *nome_arquivo) {
		FILE *arquivo = fopen(nome_arquivo, "w");
		if (arquivo == NULL) {
			fprintf(stderr, "Erro ao abrir o arquivo para escrita.\n");
			exit(EXIT_FAILURE);
		}

		// Escrever cabeçalho
		fprintf(arquivo, "Lexema,token\n");

		// Escrever cada entrada da tabela de símbolos no arquivo
		Simbolo *atual = inicio_tabela;
		while (atual != NULL) {
			fprintf(arquivo, "%s,%s\n", atual->lexema, atual->token);
			atual = atual->prox;
		}

		fclose(arquivo);
	}
%}


%option noyywrap
%option yylineno

D [0-9]
INTEIRO {D}+
S [~`!@#$%^&*()_\-+\\/\[\]|'?><,.:]
L [A-Za-z]
PALAVRA {L}+
SPACE [[:space:]]
TAB [\t]

%%

inicioprog  {
	inserir_simbolo(yytext, "INICIOPROG");
    return INICIOPROG;
}

fimprog     {
	inserir_simbolo(yytext, "FIMPROG");
    exportar_tabela("tabela_simbolos.csv");
    return FIMPROG;
}

inicioargs  {
	inserir_simbolo(yytext, "INICIOARGS");
    return INICIOARGS;
}

fimargs     {
	inserir_simbolo(yytext, "FIMARGS");
    return FIMARGS;
}

iniciovars  {
	inserir_simbolo(yytext, "INICIOVARS");
    return INICIOVARS;
}

fimvars     {
	inserir_simbolo(yytext, "FIMVARS");
    return FIMVARS;
}

escreva     {
	inserir_simbolo(yytext, "ESCREVA");
    return ESCREVA;
}

inteiro     {
	inserir_simbolo(yytext, "INTEIRO");
    return INTEIRO;
}

real        {
	inserir_simbolo(yytext, "REAL");
    return REAL;
}

literal     {
	inserir_simbolo(yytext, "LITERAL");
    return LITERAL;
}

se          {
	inserir_simbolo(yytext, "SE");
    return SE;
}

entao       {
	inserir_simbolo(yytext, "ENTAO");
    return ENTAO;
}

fimse       {
	inserir_simbolo(yytext, "FIMSE");
    return FIMSE;
}

enquanto    {
	inserir_simbolo(yytext, "ENQUANTO");
    return ENQUANTO;
}

faca        {
	inserir_simbolo(yytext, "FACA");
    return FACA;
}

fimenquanto {
	inserir_simbolo(yytext, "FIMENQUANTO");
    return FIMENQUANTO;
}

{D}+(\.{D}+)?((E|e)(\+|-)?{D}+)?  {
    return NUMERO;
}

(\"({L}|{D}|{S}|{SPACE}|{TAB})*\")  {
    return LITERAL_CONST;
}

({L}({L}|{D}|\_)*)  {
	inserir_simbolo(yytext, "IDENTIFICADOR");
    return IDENTIFICADOR;
}

(<|>|>=|<=|==|<>)  {
    return OP_RELACIONAL;
}

(\+|\-|\*|\/)  {
    return OP_ARITMETICO;
}

[=]  {
    return ATRIBUICAO;
}

[(]   {
    return ABRE_PAR;
}

[)]   {
    return FECHA_PAR;
}

[,]   {
    return VIRGULA;
}

[;]   {
    return PONTO_E_VIRG;
}

[[:space:]]+ {
}


\{({L}|{D}|{S}|{SPACE}|{TAB})*\}  {
    return COMENTARIO;
}

<<EOF>> {
    printf("ERRO: código finalizado incorretamente");
    return FIM_DE_ARQ;
    // Exportar a tabela de símbolos para um arquivo
    //exit(0);
}

. {
    printf("ERRO LÉXICO: EXPRESSÃO --> %s <-- INVÁLIDA\n", yytext);
    return ERRO;
	//exit(0);
}

%%
