# compiladorLexicoSintatico
Trabalho de compiladores

Alunos:
  Bianca Garcia Martins 606723
  

Implementar todas as convenções léxicas da linguagem Lua, apenas o subconjunto descrito a seguir.
a) Palavras reservadas (todas)
b) Símbolos reservados (todos)
c) Nomes
d) Cadeias de caracteres (apenas as versões curtas, sem sequência de escape, quebras de linha
não permitidas)
e) Constantes numéricas (apenas decimais, sem sinal, com dígitos antes e depois do ponto.

Para inserir um elemento na tabela de símbolos, insira uma ação semântica chamando o método "adicionarSimbolo". 
Ex:
regra : TK { TabelaDeSimbolos.adicionarSimbolo($TK.text,Tipo.VARIAVEL); }
;



