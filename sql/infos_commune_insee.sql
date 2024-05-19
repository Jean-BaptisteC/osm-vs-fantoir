SELECT  nom,
        ST_X(p),
        ST_Y(p),
        COALESCE(date_debut,'01-10-1970'),
        commune_composee,
        json_bounds,
        nb_adresses_osm,
        nb_adresses_ban,
        nb_nom_adr_osm,
        nb_nom_osm,
        nb_nom_ban,
        nb_nom_cadastre,
        nb_nom_topo
FROM    (SELECT nom,
                ST_AsGeoJSON(ST_BoundingDiagonal(geometrie)) json_bounds,
                ST_Centroid(geometrie) p,
                admin_level,
                code_insee,
                code_insee AS code_zone
        FROM    polygones_insee
        WHERE   admin_level in (8,9) AND
                code_insee = '__code_insee__'
        ORDER BY admin_level
        LIMIT 1)a
JOIN    bano_stats_communales
USING   (code_insee)
LEFT OUTER JOIN  (SELECT code_zone,
                         date_debut
                 FROM    batch
                 WHERE   code_zone = '__code_insee__' AND
                         etape = 'rapprochement') r
USING   (code_zone)
CROSS JOIN (SELECT COALESCE(MAX(c),0) commune_composee
           FROM   (SELECT 1 AS c 
                  FROM    ban
                  WHERE   code_insee = '__code_insee__' AND
                          nom_ancienne_commune IS NOT NULL LIMIT 1)a)b
