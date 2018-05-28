/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
*/

grammar Lua;

@members {
    public static String grupo= "<606723, 726556 , 726586 >";
}


/*PALAVRAS RESERVADAS*/
/*
PalavraReservada:'and' | 'break' | 'do' | 'else' | 'elseif' | 'end' | 'false' |
                 'for' | 'function' | 'if' | 'in' | 'local' | 'nil' | 'not' | 'or' |
                 'repeat' | 'return' | 'then' | 'true' | 'until' | 'while';

*/

/*
    SIMBOLOS RESERVADOS:

    Precedência:
    Parênteses muda a precedência de uma expressão.
    Os operadores ('..') e ('^') são associativos à direita.
    Todos os demais operadores binários são associativos à esquerda.

*/
/*Operadores de acordo com a precedência*/
/*


OpConcat: '..'; // CONCATENAÇÃO



OpDelim: ParenE | ParenD | '(' | ')*' | '(' | ')?'; //DELIMITADORES
OpOutros: ';' | ':' | ',' | '.' | '...';

*/

/*NOMES*/



OpAtrib: '='; //ATRIBUIÇÃO



//Operadores lógicos
OpLogico1: 'or';
OpLogico2: 'and';
OpRel: '<' | '>' | '<=' | '>=' | '~=' | '==';


//OpUnaria: '-' ; //| 'not' | '#' ;// '-' UNÁRIO

Menos : '-' ;
Mais : '+' ;
DoisPontos : '..';
Multiplicar : '*' ;
Dividir : '/' ;
Modulo : '%' ;
Potencia : '^' ;

fragment LetraMinuscula : ('a'..'z');
fragment LetraMaiuscula : ('A'..'Z');
fragment Letra: LetraMinuscula | LetraMaiuscula;
fragment Digito : ('0'..'9');

Nome: (Letra|'_')(Letra|'_'|Digito)* ;

/*
    CADEIA DE CARACTERES:
    Apenas as versões curtas, sem sequência de escape, quebras de linha não permitidas
*/

CadeiaCaracteres: ('\'' | '"')(~('\'' | '"'))*('\'' | '"');


/*
    CONSTANTES NUMÉRICAS:
    Apenas decimais, sem sinal, com dígitos antes e depois do ponto decimal opcionais
*/

ConstanteNumerica: Digito+ ('.' Digito+)?;


//Ignora comentarios, comentarios na mesma linha
Comentario: '--' ~('\n')* '\n' -> skip;

// Ignora tabulações, returns e quebras de linha
WS : [ \t\r\n]+ -> skip;


// Análise sintática

programa : trecho;

trecho : (comando (';')?)* (ultimocomando (';')?)?;

comando : listavar '=' listaexp |
          chamadadefuncao |
          'function' nomedafuncao corpodafuncao |
          'if'  exp 'then' trecho ('elseif' exp 'then' trecho)* ('else' trecho)? 'end' |
          'repeat' trecho 'until' exp |
          'for' nome '=' exp ',' exp (',' exp)* 'do' trecho 'end' |
          'for' listadenomes 'in' listaexp 'do' trecho 'end'
           ;

ultimocomando: 'return' (listaexp)? | 'break';

nomedafuncao : Nome {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.FUNCAO);};

corpodafuncao : '(' (listapar)? ')' trecho 'end';

listaexp : exp (',' exp)* ;

exp : CadeiaCaracteres | constanteNumerica  | expprefixo | expprefixo OpRel exp | opUn exp | expprefixo opArit2 exp | expprefixo opArit1 exp  ;

constanteNumerica: ConstanteNumerica ;

opUn : Menos ;

listapar : listadenomes (',' '...')? | '...';

nome : Nome {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.VARIAVEL);};

listadenomes : nome (',' nome)*;

expprefixo: var | expprefixo1;
expprefixo1 :  '(' exp ')' | chamadadefuncao;

var : nome | (expprefixo1|nome) ('.' var)?;

chamadadefuncao :  nome '(' listaexp ')' ;


listavar : var ( ',' var) *;

//Operadores aritmeticos
opArit1 : Menos | Mais | DoisPontos;
opArit2: Multiplicar | Dividir | Modulo;
opArit3: Potencia;

/*
//definição de um programa
programa : trecho;

//definição de trecho
trecho : (comando (';')?)* (ultimocomando (';')?)?;

//definição de bloco
bloco : trecho;

//Comandos da linguagem
comando :   listavar '=' listaexp |
            callfuncao |
            'do' bloco 'end' |
            'while' exp 'do' bloco 'end' |
            'repeat' bloco 'until' exp |
            'if' exp 'then' bloco ('elseif' exp 'then' bloco)* ('else' bloco)? 'end' |
            'for' var '=' exp ',' exp (',' exp)? 'do' bloco 'end' |
            'for' listavar 'in' listaexp 'do' bloco 'end' |
            'function' nomedafuncao corpodafuncao |
            'local function' nomedafuncao corpodafuncao |
            'local' listadenomes ('=' listaexp)?;

//comando de natureza finalizadora
ultimocomando : 'return' (listaexp)? | 'break';

//definição do nome da função com chamadas para adição na tabela de simbolos
nomedafuncao : Nome {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.FUNCAO);} |
                NomeAtributo {TabelaDeSimbolos.adicionarSimbolo($NomeAtributo.text, Tipo.FUNCAO);};

//listas de variaveis separadas por virgula
listavar : var (',' var)*;

//definição das 3 variaveis presentes na linguagem Lua. Variáveis globais, variáveis locais e campos de tabelas
var :   Nome {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.VARIAVEL);}|
        Nome ('[' exp ']')+ {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.VARIAVEL);}|
        NomeAtributo {TabelaDeSimbolos.adicionarSimbolo($NomeAtributo.text, Tipo.VARIAVEL);};

// regra utilizada para salvar na tabela de simbolos
nome: Nome {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.VARIAVEL);};

//tipos de expressões
expprefixo :    var |
                callfuncao |
                '(' exp ')';

//chamada de funções (com "( )" ou " : ")
chamadadefuncao :   (args)+ |
                    (':' args)+;

//Listas de nomes, separados por virgula
listadenomes : nome (',' nome)*;

//Lista de expressões separadas por virgula
listaexp : (exp ',')* exp;

//expressões
exp : 'nil' | 'false' | 'true' | ConstanteNumerica | CadeiaCaracteres | '...' |
expprefixo | construtortabela | exp opbin exp | opunaria exp;

// regra para chamadas de funcao e procedimentos
callfuncao: nomedafuncao chamadadefuncao;
//argumentos
args : '(' (listaexp)? ')' | construtortabela | CadeiaCaracteres;
corpodafuncao : '(' (listapar)? ')' bloco 'end';

listapar : listadenomes (',' '...')? | '...';

//definição de construtor tabela
construtortabela : '{' (listadecampos)? '}';

//listas de campos, com separador de campos
listadecampos : campo (separadordecampos campo)* (separadordecampos)?;

//definição de campo
campo : '[' exp ']' '=' exp | Nome '=' exp | exp;

//separação de campos
separadordecampos : ',' | ';';

//Operadores binarios reservados
opbin : OpArit1 | OpArit2 | OpArit3 | OpConcat |
        OpRel | OpLogico1 | OpLogico2;

//Operadores unarios reservados
opunaria : OpLogico3;

*/