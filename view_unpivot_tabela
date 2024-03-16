SELECT 
  mes,
  CASE
    WHEN categoria = 'fatura_cartao'
      THEN 'Cartão'
    WHEN categoria = 'fatura_internet'
      THEN 'Internet'
    ELSE 
      CONCAT(
        UPPER(SUBSTRING(categoria, 1, 1)),
        LOWER(SUBSTRING(categoria, 2))
      )
  END AS categoria,
  valor_fatura,
  saldo_conta,
  CONCAT(
    UPPER(SUBSTRING(status, 1, 1)),
    LOWER(SUBSTRING(status, 2))
  ) AS status
FROM dataset_pbi.gastos_previstos
UNPIVOT
   (valor_fatura FOR categoria IN
      (fatura_cartao, fatura_internet, outros)
) AS unpvt_cols_categorias;
