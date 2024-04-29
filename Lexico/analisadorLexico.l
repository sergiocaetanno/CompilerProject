%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
%}


%option noyywrap

%{		
    // Definição de ponteiro para arquivo de entrada
    FILE *arquivo_entrada;

    // Definição de uma estrutura para um símbolo
    typedef struct Simbolo {
        char *lexema;
        char *token;
        struct Simbolo *prox;
    } Simbolo;

    // Definição de uma tabela de lexemas
    struct Simbolo tabela_lexema[1000]; // Suponha que sua tabela de símbolos pode conter até 1000 símbolos
    int num_simbolos = 0; // Número atual de símbolos na tabela
    
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
	
	void temp_exportar(const char *nome_arquivo) {
		FILE *arquivo = fopen(nome_arquivo, "w");
		if (arquivo == NULL) {
			fprintf(stderr, "Erro ao abrir o arquivo para escrita.\n");
			exit(EXIT_FAILURE);
		}

		// Escrever cabeçalho
		fprintf(arquivo, "Lexema,token\n");

		// Escrever cada entrada da tabela de símbolos no arquivo
		for (int i = 0; i < num_simbolos; i++) {
			fprintf(arquivo, "%s,%s\n", tabela_lexema[i].lexema, tabela_lexema[i].token);
		}

		fclose(arquivo);
	}

%}

D [0-9]
INTEIRO {D}+
S [~`!@#$%^&*()_\-+\\/\[\]|'?><,.]
L [A-Za-z]
PALAVRA {L}+
SPACE [[:space:]]
TAB [\t]

%%

inicioprog  {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "INICIOPROG";
    num_simbolos++;
	inserir_simbolo(yytext, "INICIOPROG");
    printf("INICIOPROG\n");
}

fimprog     {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "FIMPROG";
    num_simbolos++;
	inserir_simbolo(yytext, "FIMPROG");
    printf("FIMPROG\n");
}

inicioargs  {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "INICIOARGS";
    num_simbolos++;
	inserir_simbolo(yytext, "INICIOARGS");
    printf("INICIOARGS\n");
}

fimargs     {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "FIMARGS";
    num_simbolos++;
	inserir_simbolo(yytext, "FIMARGS");
    printf("FIMARGS\n");
}

iniciovars  {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "INICIOVARS";
    num_simbolos++;
	inserir_simbolo(yytext, "INICIOVARS");
    printf("INICIOVARS\n");
}

fimvars     {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "FIMVARS";
    num_simbolos++;
	inserir_simbolo(yytext, "FIMVARS");
    printf("FIMVARS\n");
}

escreva     {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "ESCREVA";
    num_simbolos++;
	inserir_simbolo(yytext, "ESCREVA");
    printf("ESCREVA\n");
}

inteiro     {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "INTEIRO";
    num_simbolos++;
	inserir_simbolo(yytext, "INTEIRO");
    printf("INTEIRO\n");
}

real        {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "REAL";
    num_simbolos++;
	inserir_simbolo(yytext, "REAL");
    printf("REAL\n");
}

literal     {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "LITERAL";
    num_simbolos++;
	inserir_simbolo(yytext, "LITERAL");
    printf("LITERAL\n");
}

se          {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "SE";
    num_simbolos++;
	inserir_simbolo(yytext, "SE");
    printf("SE\n");
}

entao       {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "ENTAO";
    num_simbolos++;
	inserir_simbolo(yytext, "ENTAO");
    printf("ENTAO\n");
}

fimse       {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "FIMSE";
    num_simbolos++;
	inserir_simbolo(yytext, "FIMSE");
    printf("FIMSE\n");
}

enquanto    {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "ENQUANTO";
    num_simbolos++;
	inserir_simbolo(yytext, "ENQUANTO");
    printf("ENQUANTO\n");
}

faca        {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "FACA";
    num_simbolos++;
	inserir_simbolo(yytext, "FACA");
    printf("FACA\n");
}

fimenquanto {
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "FIMENQUANTO";
    num_simbolos++;
	inserir_simbolo(yytext, "FIMENQUANTO");
    printf("FIMENQUANTO\n");
}

{D}+(\.{D}+)?((E|e)(\+|-)?{D}+)?  {
    // Armazenar o número na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "NUMERO";
	
	
    num_simbolos++;
    printf("NUMERO\n");
}

(\"({L}|{D}|{S}|{SPACE}|{TAB})*\")  {
    // Armazenar o literal na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "LITERAL";
    num_simbolos++;
    printf("LITERAL\n");
}

({L}({L}|{D}|\_)*)  {
    // Armazenar o identificador na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "IDENTIFICADOR";
	inserir_simbolo(yytext, "IDENTIFICADOR");
    num_simbolos++;
    printf("IDENTIFICADOR\n");
}

(<|>|>=|<=|==|<>)  {
    // Armazenar o operador relacional na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "OP_RELACIONAL";
    num_simbolos++;
    printf("OP_RELACIONAL\n");
}

(\+|\-|\*|\/)  {
    // Armazenar o operador aritmético na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "OP_ARITMETICO";
    num_simbolos++;
    printf("OP_ARITMETICO\n");
}

[=]  {
    // Armazenar o operador de atribuição na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "ATRIBUICAO";
    num_simbolos++;
    printf("ATRIBUICAO\n");
}

[(]   {
    // Armazenar o abre parêntese na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "ABRE_PAR";
    num_simbolos++;
    printf("ABRE_PAR\n");
}

[)]   {
    // Armazenar o fecha parêntese na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "FECHA_PAR";
    num_simbolos++;
    printf("FECHA_PAR\n");
}

[,]   {
    // Armazenar a vírgula na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "VIRGULA";
    num_simbolos++;
    printf("VIRGULA\n");
}

[;]   {
    // Armazenar o ponto e vírgula na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "PONTO_E_VIRG";
    num_simbolos++;
    printf("PONTO_E_VIRG\n");
}

[[:space:]]+ {
    // Armazenar o ponto e vírgula na tabela de símbolos
    //tabela_lexema[num_simbolos].lexema = strdup(yytext);
    //tabela_lexema[num_simbolos].token = "VAZIO";
    //num_simbolos++;
    //printf("VAZIO\n");
}

\{({L}|{D}|{S}|{SPACE}|{TAB})*\}  {
    // Armazenar o ponto e vírgula na tabela de símbolos
    tabela_lexema[num_simbolos].lexema = strdup(yytext);
    tabela_lexema[num_simbolos].token = "COMENTARIO";
    num_simbolos++;
    printf("COMENTARIO\n");
}

<<EOF>> {
    printf("FIM_DE_ARQ\n");
    // Exportar a tabela de símbolos para um arquivo
	temp_exportar("tabela_lexema.csv");
    exportar_tabela("tabela_simbolos.csv");
	exit(0);
}

. {
    printf("ERRO: EXPRESSÃO INVÁLIDA\n");
	exit(0);
}

%%

int main() {


  // Abrir o arquivo de entrada
  arquivo_entrada = fopen("arquivo_entrada", "r");

  // Verificar se o arquivo foi aberto com sucesso
  if (arquivo_entrada == NULL) {
    printf("Erro ao abrir o arquivo de entrada.\n");
    exit(1);
  }

  // Redirecionar a entrada padrão para o arquivo
  yyin = arquivo_entrada;

  // Chamar yylex() para iniciar a análise léxica
  yylex();
  
  // Fechar o arquivo de entrada
  fclose(arquivo_entrada);

  // Após a conclusão da análise léxica, exporte a tabela de símbolos
  //exportar_tabela("tabela_lexema.csv");

    return 0;
}
