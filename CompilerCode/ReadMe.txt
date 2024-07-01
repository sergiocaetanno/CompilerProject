O compilador desenvolvido lê um código como entrada (arquivo de texto) e realiza a análise léxica e sintática deste;
Uma tabela de símbolos é gerada, responsável por armazenar tokens e lexemas de palavras reservadas e identificadores (arquivo .csv);
As regras de derivação da gramática livre de contexto responsável por gerar as estruturas reconhecidas pela linguagem são impressas na tela.
Caso os códigos fornecidos não façam parte da linguagem, um erro léxico ou sintático é retornado.

Utilizar os comandos a seguir para teste:

flex lexer.l                             #GERA O ARQUIVO: lex.yy.c (analisador léxico)
bison -d parser.y                        #GERA OS ARQUIVOS: parser.tab.c e parser.tab.h (analisador sinsático)
gcc parser.tab.c lex.yy.c -o compilador  #COMPILA E INTEGRA O ANALISADOR LÉXICO COM O SINTÁTICO COM O NOME: compilador
./compilador arquivo_entrada             #EXECUTA O ANALISADOR LÉXICO PARA O ARQUIVO DE ENTRADA FORNECIDO
