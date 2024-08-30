-- 1) Observe o trecho de código abaixo: int INDICE = 13, SOMA = 0, K = 0;
-- Enquanto K < INDICE faça { K = K + 1; SOMA = SOMA + K; }
-- Imprimir(SOMA);
-- Ao final do processamento, qual será o valor da variável SOMA?

WITH RECURSIVE SomaSeq AS (
    SELECT 1 AS K, 1 AS Soma
    UNION ALL
    SELECT K + 1, Soma + (K + 1)
    FROM SomaSeq
    WHERE K < 13
)
SELECT Soma
FROM SomaSeq
WHERE K = 13;

-- 2) Dado a sequência de Fibonacci, onde se inicia por 0 e 1 e o próximo valor sempre será a soma dos 2 valores anteriores 
-- (exemplo: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34...), escreva um programa na linguagem que desejar onde, informado um número, 
-- ele calcule a sequência de Fibonacci e retorne uma mensagem avisando se o número informado pertence ou não a sequência.

WITH RECURSIVE Fibonacci AS (
    SELECT 0 AS n, 0 AS a, 1 AS b
    UNION ALL
    SELECT n + 1, b, a + b
    FROM Fibonacci
    WHERE a + b <= 1000000
)
SELECT CASE
           WHEN a = 21 THEN 'O número pertence à sequência de Fibonacci'
           ELSE 'O número não pertence à sequência de Fibonacci'
       END AS Resultado
FROM Fibonacci
WHERE a = 21; -- numero que deseja fazer a verificação

-- 3) Dado um vetor que guarda o valor de faturamento diário de uma distribuidora, faça um programa, na linguagem que desejar, que calcule e retorne:
-- • O menor valor de faturamento ocorrido em um dia do mês;
-- • O maior valor de faturamento ocorrido em um dia do mês;
-- • Número de dias no mês em que o valor de faturamento diário foi superior à média mensal.

WITH Faturamento AS (
    SELECT valor
    FROM faturamento_diario
    WHERE valor > 0
),
Media AS (
    SELECT AVG(valor) AS media
    FROM Faturamento
)
SELECT
    (SELECT MIN(valor) FROM Faturamento) AS menor_valor,
    (SELECT MAX(valor) FROM Faturamento) AS maior_valor,
    (SELECT COUNT(*) FROM Faturamento WHERE valor > (SELECT media FROM Media)) AS dias_acima_media
;

-- 4) Dado o valor de faturamento mensal de uma distribuidora, detalhado por estado:
-- • SP – R$67.836,43
-- • RJ – R$36.678,66
-- • MG – R$29.229,88
-- • ES – R$27.165,48
-- • Outros – R$19.849,53

-- Escreva um programa na linguagem que desejar onde calcule o percentual de representação que cada estado teve dentro do valor total mensal da distribuidora.

WITH Faturamento AS (
    SELECT 'SP' AS estado, 67836.43 AS valor
    UNION ALL
    SELECT 'RJ', 36678.66
    UNION ALL
    SELECT 'MG', 29229.88
    UNION ALL
    SELECT 'ES', 27165.48
    UNION ALL
    SELECT 'Outros', 19849.53
),
Total AS (
    SELECT SUM(valor) AS total
    FROM Faturamento
)
SELECT
    estado,
    valor,
    (valor / (SELECT total FROM Total)) * 100 AS percentual
FROM Faturamento;

-- 5) Escreva um programa que inverta os caracteres de um string.

CREATE OR REPLACE FUNCTION inverter_string(input TEXT) RETURNS TEXT AS $$
DECLARE
    resultado TEXT := '';
    i INT;
BEGIN
    FOR i IN REVERSE 1..LENGTH(input) LOOP
        resultado := resultado || SUBSTRING(input FROM i FOR 1);
    END LOOP;
    RETURN resultado;
END;
$$ LANGUAGE plpgsql;

SELECT inverter_string('exemplo') AS string_invertida;
