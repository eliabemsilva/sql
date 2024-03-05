WITH Horas_Int AS (
    SELECT
        Id_Colaborador,
        SUM(
            CAST(LEFT(Horas_Trabalhadas,STRPOS(Horas_Trabalhadas,':')-1) AS INT))+
            FLOOR(SUM(CAST(RIGHT(Horas_Trabalhadas,STRPOS(REVERSE(Horas_Trabalhadas),':')-1) AS INT))/60
        ) AS Horas,
        FLOOR(((SUM(CAST(RIGHT(Horas_Trabalhadas,STRPOS(REVERSE(Horas_Trabalhadas),':')-1) AS INT))/60)-
                FLOOR(SUM(CAST(RIGHT(Horas_Trabalhadas,STRPOS(REVERSE(Horas_Trabalhadas),':')-1) AS INT))/60))*60
        ) AS Minutos
    FROM `dataset_pbi.ft_batida_ponto` 
    GROUP BY Id_Colaborador      
) 
SELECT
    Nome_Colaborador AS Colaborador,
    Cargo,
    Time,
    CONCAT(CAST(SUM(hi.Horas) AS STRING), ':', CAST(SUM(hi.Minutos) AS STRING)) AS Horas_Totais,
    CASE 
        WHEN SUM(hi.Horas) = 40 AND SUM(hi.Minutos) = 0
            THEN 'OK 🟩' 
        WHEN SUM(hi.Horas) > 40 OR (SUM(hi.Horas) = 40 AND SUM(hi.Minutos) > 0)
            THEN 'HORAS EXTRAS 🟨' 
        ELSE 'HORAS FALTANTES 🟧' 
    END AS Situacao_Banco_Horas
FROM Horas_Int hi
INNER JOIN `dataset_pbi.dim_colaborador` co
    ON hi.Id_Colaborador = co.Id_Colaborador
GROUP BY Colaborador, Cargo, Time
ORDER BY SUM(hi.Horas) DESC, SUM(hi.Minutos) DESC;
