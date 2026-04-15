USE [BankenSystem]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_BerechneZinsanteil]    Script Date: 10.04.2026 10:21:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/* Purpose: 
Calculates the interest portion of a monthly loan installment
Berechnet den Zinsanteil einer monatlichen Kreditrate

 The annual interest rate is divided by 12 to get the monthly rate, then multiplied by the remaining balance to get the interest for this month.
 Der Jahreszinssatz wird durch 12 geteilt um den Monatszins zu erhalten,dann mit dem Restbetrag multipliziert um den Zinsanteil zu berechnen.

 Used/Verwendet in sp_ZahlungEintragen 
*/

CREATE OR ALTER  FUNCTION [dbo].[fn_BerechneZinsanteil]
(
    @Restschuld     DECIMAL(12,2),
    @Jahreszinssatz DECIMAL(5,2)
)
RETURNS DECIMAL(12,2)
AS BEGIN
    -- Balance × (AnnualRate / 100 / 12)
    RETURN ROUND(@Restschuld * (@Jahreszinssatz / 100.0 / 12.0), 2);
END;
GO


--SELECT dbo.fn_BerechneZinsanteil(20000.00, 4.5) AS [Zinsanteil] -- Zinsanteil=75.00

