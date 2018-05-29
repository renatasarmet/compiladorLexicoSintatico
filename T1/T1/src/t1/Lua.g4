/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
*/

grammar Lua;

@members {
    public static String grupo= "<606723, 726556 , 726586 >";
}


/*PALAVRAS RESERVADAS*/

 And : 'and' ;
 Or : 'or' ;
 Break : 'break' ;
 Do : 'do' ;
 Else : 'else' ;
 Elseif : 'elseif' ;
 End : 'end' ;
 False : 'false' ;
 For : 'for' ;
 Function : 'function' ;
 If : 'if' ;
 In : 'in' ;
 Local : 'local' ;
 Nil : 'nil' ;
 Not : 'not' ;
 Repeat : 'repeat' ;
 Return : 'return' ;
 Then : 'then' ;
 True : 'true' ;
 Until : 'until' ;
 While : 'while' ;

/*
    SIMBOLOS RESERVADOS:
*/

ParenE : '(' ;
ParenD : ')' ;
PontoVir : ';' ;
PontoFinal : '.' ;
Virgula : ',' ;


OpAtrib: '='; //ATRIBUIÇÃO


//Operadores lógicos
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

ConstanteNumerica: Digito+ (PontoFinal Digito+)?;


//Ignora comentarios, comentarios na mesma linha
Comentario: '--' ~('\n')* '\n' -> skip;

// Ignora tabulações, returns e quebras de linha
WS : [ \t\r\n]+ -> skip;


// Análise sintática

programa : trecho;

trecho : (comando (PontoVir)?)* (ultimocomando (PontoVir)?)?;

comando : listavar OpAtrib listaexp |
          chamadadefuncao |
          Do trecho End |
          Function nomedafuncao corpodafuncao |
          If  exp Then trecho (Elseif exp Then trecho)* (Else trecho)? End |
          Repeat trecho Until exp |
          For nome OpAtrib exp Virgula exp (Virgula exp)* Do trecho End |
          For listadenomes In listaexp Do trecho End|
          Local listadenomes (OpAtrib listaexp)?
           ;

ultimocomando: Return (listaexp)? | Break;

nomedafuncao : nomeF {TabelaDeSimbolos.adicionarSimbolo($nomeF.text, Tipo.FUNCAO);};

nomeF : Nome (PontoFinal Nome)? ;

corpodafuncao : ParenE (listapar)? ParenD trecho End;

listaexp : exp (Virgula exp)* ;

exp : exp2 opBinaria exp | exp2;
exp2 : False | CadeiaCaracteres | constanteNumerica  | expprefixo | opUn exp2 ;

constanteNumerica: ConstanteNumerica ;

opUn : Menos ;

listapar : listadenomes (Virgula '...')? | '...';

nome : Nome {TabelaDeSimbolos.adicionarSimbolo($Nome.text, Tipo.VARIAVEL);};

listadenomes : nome (Virgula nome)*;

expprefixo: var | expprefixo1;
expprefixo1 :  ParenE exp ParenD | chamadadefuncao;

var : nome ;

chamadadefuncao :  nomedafuncao ParenE listaexp ParenD ;


listavar : var ( Virgula var) *;

//Operadores aritmeticos
opArit1 : Menos | Mais | DoisPontos;
opArit2: Multiplicar | Dividir | Modulo;
opArit3: Potencia;

opBinaria : opArit1 | opArit2 | OpRel ;