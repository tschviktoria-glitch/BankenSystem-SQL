USE [BankenSystem]
GO

/****** Object:  UserDefinedFunction [dbo].[fn_BerechneTilgungsanteil]    Script Date: 10.04.2026 10:15:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- Fucntion 2
CREATE  OR ALTER FUNCTION [dbo].[fn_BerechneTilgungsanteil]
(
    @MonatsRate  DECIMAL(12,2),
    @Zinsanteil  DECIMAL(12,2)
)
RETURNS DECIMAL(12,2)
AS BEGIN
    RETURN ROUND(@MonatsRate - @Zinsanteil, 2);
END;
GO



-- Test Script
-- Expected: 75.00
-- How much principal if rate=455.35 and interest=75.00?
SELECT dbo.fn_BerechneTilgungsanteil(455.35, 75.00) AS [Tilgungsanteil];
-- Expected: 380.35

