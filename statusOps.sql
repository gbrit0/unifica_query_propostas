-- STATUS DAS OPS 
SELECT
    TRIM(C2_FILIAL) + TRIM(C2_NUM) + TRIM(C2_ITEM) + TRIM(C2_SEQUEN) + TRIM(C2_ITEMGRD) AS CHAVE_OP,
    CASE 
        -- 1. Ordem de Produção Prevista
        WHEN C2_TPOP = 'P' THEN 'Prevista'
        
        -- 2. Ordem de Produção Encerrada Totalmente
        WHEN C2_TPOP = 'F' AND C2_DATRF <> '' AND C2_QUJE >= C2_QUANT THEN 'Encerrada Totalmente'
        
        -- 3. Ordem de Produção Encerrada Parcialmente
        WHEN C2_TPOP = 'F' AND C2_DATRF <> '' AND C2_QUJE < C2_QUANT THEN 'Encerrada Parcialmente'
        
        -- 4. Ordem de Produção Ociosa (Baseado na data base e dias de ociosidade)
        -- A regra oficial compara (Data Atual - Ult. Movimento) >= C2_DIASOCI
        WHEN C2_TPOP = 'F' AND C2_DATRF = '' AND
        DATEDIFF(day, ISNULL((SELECT MAX(D3_EMISSAO)
        FROM SD3010
        WHERE D3_OP = C2_NUM + C2_ITEM + C2_SEQUEN AND D_E_L_E_T_ <> '*'), C2_DATPRI), GETDATE()) >= C2_DIASOCI 
            THEN 'Ociosa'

        -- 5. Ordem de Produção Iniciada
        -- Possui apontamentos no SD3 ou SH6 e não está ociosa
        WHEN C2_TPOP = 'F' AND C2_DATRF = '' AND
        (EXISTS (SELECT 1
        FROM SD3010
        WHERE D3_OP = C2_NUM + C2_ITEM + C2_SEQUEN AND D_E_L_E_T_ <> '*') OR
        EXISTS (SELECT 1
        FROM SH6010
        WHERE H6_OP = C2_NUM + C2_ITEM + C2_SEQUEN AND D_E_L_E_T_ <> '*')) 
            THEN 'Iniciada'

        -- 6. Ordem de Produção em Aberto
        -- Tipo Firme, sem data de fechamento e sem movimentos
        ELSE 'Em Aberto'
    END AS STATUS_OP,
    CAST(C2_DATPRI AS DATE) AS PREVISAO_INICIO,
    CAST(C2_DATPRF AS DATE) AS PREVISAO_FIM,
    CASE 
        WHEN C2_DATRF = '        ' THEN NULL 
        ELSE CAST(C2_DATRF AS DATE) 
    END AS DATA_FIM

FROM SC2010 AS SC2
WHERE SC2.D_E_L_E_T_ <> '*'
ORDER BY R_E_C_N_O_ DESC;