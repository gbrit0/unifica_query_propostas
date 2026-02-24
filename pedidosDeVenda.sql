-- SQL DOS PEDIDOS DE VENDA 
SELECT DISTINCT
    SC5.C5_XUSER AS 'Usuário Protheus',
    SC6.C6_NUM AS 'Número PV',
    SC6.C6_LOTECTL AS 'Lote',
    SE4.E4_DESCRI AS 'Forma de Pagamento',
    SYS.M0_FILIAL AS 'Filial',
    SC6.C6_ITEM AS 'Item',
    SC6.C6_PRODUTO AS 'Cod Produto',
    SC6.C6_DESCRI AS 'Produto',
    SBM.BM_DESC AS 'Grupo Produto',
    SA1.A1_NREDUZ AS 'Nome CLiente',
    SA1.A1_CGC AS 'CNPJ Cliente',
    SA3.A3_NOME AS 'Vendedor',
    SC5.C5_EMISSAO AS 'Data Emissão',
    SC6.C6_ENTREG AS 'Data Entrega',
    SC6.C6_DATFAT AS 'Data Faturamento',
    SC6.C6_QTDVEN AS 'Qtd Vendida',
    SC6.C6_VALOR AS 'Valor',
    SC6.C6_CF AS 'CFOP',
    SC6.C6_TES AS 'TES',
    SC6.C6_NOTA AS 'NF',
    CASE SC5.C5_TPFRETE
        WHEN 'C' THEN 'CIF'
        WHEN 'F' THEN 'FOB'
        WHEN 'T' THEN 'Por Conta de Terceiros'
        WHEN 'R' THEN 'Por Conta do Remetente'
        WHEN 'D' THEN 'Por Conta do Destinatário'
        WHEN 'S' THEN 'Sem Frete'
        ELSE 'Não Informado'
    END AS CONDICAO_FRETE,
    CASE 
        WHEN SC5.C5_BLQ = '1' THEN 'Bloqueio de Regra (Azul)' -- Ocorre quando os itens e o cabeçalho do pedido de venda não estão de acordo com a definição
        WHEN SC5.C5_BLQ = '2' THEN 'Bloqueio de Verba (Laranja)' -- o Sistema verifica se o desconto concedido nos itens do pedido é maior que o permitido pela empresa. 
        WHEN (SC5.C5_LIBEROK = 'S' AND SC5.C5_NOTA = '') THEN 'Liberado (Amarelo)' -- submetido à liberação do Pedido mas não foi encerrado
        WHEN (SC5.C5_LIBEROK = '' AND SC5.C5_NOTA = '') THEN 'Em Aberto (Verde)' -- Não foi submetido à liberação
        WHEN SC5.C5_BLQ = ' ' AND SC5.C5_LIBEROK = 'R' THEN 'Pedido Rejeitado (X)' -- pedido ficou bloqueado
        WHEN TRIM(SC5.C5_NOTA) <> '' THEN 'Encerrado (Vermelho)' -- Já faturado 100% ou Eliminado resíduo
        ELSE 'Outros/Alçada (Roxo)'
    END AS STATUS_PEDIDO,
    CAST(C5_XMENNOT AS VARCHAR(100)) AS OBS
-- GERADOR ALVENARIA 350 GEN 380 SGV 7119 VOLVO TAD 8 43 GE 3008725820 WEG AG10 250 MI 00 AI 1111381665

FROM
    SC6010 AS SC6

    -- SC5 - Pedidos de Venda 
    LEFT JOIN
    SC5010 AS SC5 ON SC6.C6_FILIAL = SC5.C5_FILIAL -- LJ para a mesma filial
        AND ((SC6.C6_NOTA = SC5.C5_NOTA) AND (SC6.C6_SERIE = SC5.C5_SERIE))
        AND SC6.C6_NUM = SC5.C5_NUM -- por número de pedido de venda
        AND SC5.D_E_L_E_T_ <> '*' -- onde o pedido de venda não foi deletado

    -- SC9 - Pedidos Liberados
    LEFT JOIN
    SC9010 AS SC9 ON C9_FILIAL = C5_FILIAL
        AND C6_NUM + C6_PRODUTO + C6_ITEM = C9_PEDIDO + C9_PRODUTO + C9_ITEM
        AND SC9.D_E_L_E_T_ <> '*'

    -- SF4 - Tipos de entrada e saída
    LEFT JOIN
    SF4010 AS SF4 ON (SF4.F4_CODIGO) = (SC6.C6_TES)
        AND (SF4.F4_FILIAL) = (SC6.C6_FILIAL)
        AND (SF4.D_E_L_E_T_ <> '*' )

    -- SE4 - Condições de Pagamento
    LEFT JOIN
    SE4010 AS SE4 ON TRIM(SE4.E4_CODIGO) = TRIM(SC5.C5_CONDPAG)
        AND TRIM(SE4.E4_FILIAL) = SUBSTRING(SC5.C5_FILIAL, 1, 2)
        AND SE4.D_E_L_E_T_ <> '*'

    -- SA3 - Vendedores
    LEFT JOIN
    SA3010 AS SA3 ON SA3.A3_COD = SC5.C5_VEND1
        AND SA3.A3_FILIAL = SC5.C5_FILIAL
        AND SA3.D_E_L_E_T_ <> '*'

    -- SA1 - Clientes 
    LEFT JOIN
    SA1010 AS SA1 ON SA1.A1_COD + SA1.A1_LOJA = C5_CLIENT + C5_LOJAENT
        AND SA1.A1_FILIAL = SUBSTRING(SC5.C5_FILIAL, 1, 2)
        AND SA1.D_E_L_E_T_ <> '*'

    -- SB1 - Produtos
    LEFT JOIN SB1010 AS SB1 ON SC6.C6_PRODUTO = SB1.B1_COD
        AND SB1.D_E_L_E_T_ <> '*'
        AND SUBSTRING(SC6.C6_FILIAL,1,2) = SB1.B1_FILIAL

    -- SBM - Grupos de Produto
    LEFT JOIN SBM010 AS SBM ON SBM.BM_GRUPO = SB1.B1_GRUPO
        AND BM_FILIAL = ' '

    -- SYS_COMPANY
    LEFT JOIN SYS_COMPANY AS SYS ON SC6.C6_FILIAL = M0_CODFIL
        AND SYS.D_E_L_E_T_ = ''
        AND M0_NOME = 'BRG Geradores'

WHERE 
    SC6.D_E_L_E_T_ <> '*' -- Retira os itens dos pedidos que foram deletados
    AND SC6.C6_FILIAL = '0101'
    -- AND TRIM(SC5.C5_XUSER) IN ('Livia Pires', 'Comercial BRG', 'David Martins dos Sa') -- Usuários do Protheus do Time Comercial BRG 
    AND SC6.C6_NUMORC = '        ' -- Quer dizer que o orçamento não veio do Protheus e sim do site de vendas
    AND TRIM(SF4.F4_DUPLIC) = 'S' -- Gera Financeiro
    AND TRIM(C6_PRODUTO) <> 'B0010046'
    AND SC5.C5_XUSER <> '                    '

    -- Filtros Grupo e Codigo fiscal de Operação
    AND SB1.B1_GRUPO NOT IN ('A000', 'B000', 'F000', 'H000', 'S000', 'V000', 'M000', 'P000', 'MT00', 'FR00', 'TI00', 'SI00', 'FM00', 'MV00', 'KT01', 'GDES', 'DESM', 'A000', 'D000', 'V000', 'TF00')
    AND SC5.C5_CLIENT NOT IN ('27379581', '04675878','05958492') -- Remover GRID e BRG
    AND C6_CF IN ('5101', '6116', '6108', '5405', '5404', '6102', '5102', '5116', '6109', '6551', '6107', '5933', '6404', '6101', '7102', '6124', '6120', '6119', '6933', '5551', '6252','7101')

    AND B1_GRUPO <> 'E000'

ORDER BY SC5.C5_EMISSAO DESC;