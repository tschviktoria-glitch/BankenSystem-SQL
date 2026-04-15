
-- Test scripts of Scalar functions

-- Function1: dbo.fn_BerechneZinsanteil
-- Calculate Zinsanteil 
-- Test for Kunden1 Kredite1
SELECT dbo.fn_BerechneZinsanteil(20000.00, 4.5) AS [Zinsanteil] -- Zinsanteil=75.00


-- Function2: dbo.fn_BerechneTilgungsanteil
-- Calculates Tilgungsanteil
-- Takes Zinsanteil 75.00 and calcualtes Tilgungsanteil
-- How much principal if rate=455.35 and interest=75.00?

SELECT dbo.fn_BerechneTilgungsanteil(455.35, 75.00) AS [Tilgungsanteil]

-- Expected: 380.35