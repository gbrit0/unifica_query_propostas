-- CLIENTES BRG, GRID E AGROGERA 
SELECT DISTINCT
    TRIM(A1_CGC) AS CNPJ,
    TRIM(A1_COD) AS Codigo,
    TRIM(A1_LOJA) AS Loja,
    CASE 
        WHEN TRIM(A1_PESSOA) = 'F' THEN 'Física'
        WHEN TRIM(A1_PESSOA) = 'J' THEN 'Jurídica'
        ELSE NULL
    END AS Fisica_Jurid,
    TRIM(A1_NOME) AS Nome,
    TRIM(A1_NREDUZ) AS Nome_Fantasia,
    TRIM(A1_END) AS Endereco,
    TRIM(A1_BAIRRO) AS Bairro,
    TRIM(A1_EST) AS Estado,
    TRIM(A1_MUN) AS Municipio,
    CASE 
        WHEN LEN(RTRIM(LTRIM(A1_CEP))) = 8
            THEN SUBSTRING(A1_CEP, 1, 5) + '-' + SUBSTRING(A1_CEP, 6, 3)
        ELSE A1_CEP
    END AS CEP,
    TRIM(A1_INSCR) AS Ins_Estadual,
    TRIM(YA_DESCR) AS Descr_Pais,
    CASE
        WHEN A1_SIMPLES = 1 THEN 'Sim'
        WHEN A1_SIMPLES = 2 THEN 'Não'
        ELSE NULL
    END AS Opt_Simples,
    TRIM(A1_DDD) + TRIM(A1_TEL) AS Telefone,
    TRIM(A1_EMAIL) AS E_mail,
    A1_COMPLEM,
    CASE 
        WHEN A1_DTNASC IS NULL
        OR A1_DTNASC = ''
        OR A1_DTNASC = '19000101'
        THEN ''
        ELSE CONVERT(VARCHAR(10), CAST(A1_DTNASC AS DATE), 103)
    END AS Abertura,
    ROW_NUMBER() OVER (
        PARTITION BY TRIM(A1_CGC)
        ORDER BY TRIM(A1_COD), TRIM(A1_LOJA)
    ) AS rn
FROM SA1010
    LEFT JOIN SYA010
    ON A1_PAIS = YA_CODGI
        AND SYA010.D_E_L_E_T_ <> '*'
WHERE 
    SA1010.D_E_L_E_T_ <> '*'
    AND LTRIM(RTRIM(A1_COD)) <> ''
    AND A1_COD NOT LIKE '%000000%'
    AND A1_CGC <> ''
    AND A1_FILIAL IN ('01','05','10') -- Caso queira Grid inserir 05, caso queira agrogera inserir 10
    AND TRIM(A1_PAIS) = '105' -- Filtro apenas para clientes do Brasil 