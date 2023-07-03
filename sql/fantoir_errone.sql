WITH
f
AS
(SELECT code_insee,
        fantoir
 FROM   bano_points_nommes
 WHERE  fantoir IS NOT NULL AND
        source = 'OSM' AND
        fantoir not like '%b'
EXCEPT
SELECT  code_insee,
        fantoir
FROM	 topo)
SELECT DISTINCT v.fantoir,
       nom,
       ST_X(geometrie),
       ST_Y(geometrie),
       libelle
FROM   bano_points_nommes v
JOIN   (SELECT com AS code_insee,
               libelle
       FROM cog_commune) c
USING  (code_insee)
JOIN   f
USING  (fantoir)
WHERE  source = 'OSM'
ORDER BY 1;