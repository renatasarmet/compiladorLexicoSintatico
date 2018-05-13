/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
*/

grammar Lua;

@members {
    public static String grupo="<<606723, , >>";
}

/*PALAVRAS RESERVADAS*/

PalavraReservada:'and' | 'break' | 'do' | 'else' | 'elseif' | 'end' | 'false' |
                 'for' | 'function' | ‘if’ | 'in' | 'local' | 'nil' | 'not' | 'or' |
                 'repeat' | 'return' | 'then' | 'true' | 'until' | 'while';



/*
    SIMBOLOS RESERVADOS:

    Precedência:
    Parênteses muda a precedência de uma expressão.
    Os operadores ('..') e ('^') são associativos à direita.
    Todos os demais operadores binários são associativos à esquerda.

*/

/*Operadores de acordo com a precedência*/
OpLogico1: 'or';
OpLogico2: 'and';
OpRel: '<' | '>' |  '<=' | '>=' | '~=' | '==';
OpConcat: '..'; // CONCATENAÇÃO
OpArit1: '+' | '-';
OpArit2: '*'| '/' | '%';
OpLogico3: 'not' | '#' | '-' // '-' UNÁRIO
OpArit3: '^'; //EXPONENCIAÇÃO

OpAtrib: '='; //ATRIBUIÇÃO
OpDelim: '(' | ')' | '{' | '}' | '[' | ']'; //DELIMITADORES
OpOutros: ';' | ':' | ',' | '.' | '...';



/*NOMES*/

fragment LetraMinuscula : ('a'..'z');
fragment LetraMaiuscula : ('A'..'Z');
Letra: ('a'..'z') | ('A'..'Z');
fragment Digito : '0'..'9';

Nome:(Letra|'_')(Letra|'_'|Digito)*


/*
    CADEIA DE CARACTERES:
    Apenas as versões curtas, sem sequência de escape, quebras de linha não permitidas
*/

CadeiaCaracteres: ('\'' | '"')(~('\'' | '"'))*('\'' | '"');


/*
    CONSTANTES NUMÉRICAS:
    Apenas decimais, sem sinal, com dígitos antes e depois do ponto decimal opcionais
*/

ConstanteNumerica: Digito+ '.'? Digito+


