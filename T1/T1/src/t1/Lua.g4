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
          'do' trecho 'end' |
          'function' nomedafuncao corpodafuncao |
          'if'  exp 'then' trecho ('elseif' exp 'then' trecho)* ('else' trecho)? 'end' |
          'repeat' trecho 'until' exp |
          'for' nome '=' exp ',' exp (',' exp)* 'do' trecho 'end' |
          'for' listadenomes 'in' listaexp 'do' trecho 'end' |
          'local' listadenomes ('=' listaexp)?
           ;

ultimocomando: 'return' (listaexp)? | 'break';

nomedafuncao : nomeF {TabelaDeSimbolos.adicionarSimbolo($nomeF.text, Tipo.FUNCAO);};

nomeF : Nome ('.' Nome)? ;

corpodafuncao : '(' (listapar)? ')' trecho 'end';

listaexp : exp (',' exp)* ;

exp : exp2 opBinaria exp | exp2;
exp2 : 'false' | CadeiaCaracteres | constanteNumerica  | expprefixo | opUn exp2 ;

constanteNumerica: ConstanteNumerica ;

opUn : Menos ;

listapar : listadenomes (',' '...')? | '...';

nome : Nome {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.VARIAVEL);};

listadenomes : nome (',' nome)*;

expprefixo: var | expprefixo1;
expprefixo1 :  '(' exp ')' | chamadadefuncao;

var : nome ;

chamadadefuncao :  nomedafuncao '(' listaexp ')' ;


listavar : var ( ',' var) *;

//Operadores aritmeticos
opArit1 : Menos | Mais | DoisPontos;
opArit2: Multiplicar | Dividir | Modulo;
opArit3: Potencia;

opBinaria : opArit1 | opArit2 | OpRel ;