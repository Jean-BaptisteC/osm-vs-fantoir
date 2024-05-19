#!./venv37/bin/python
# -*- coding: utf-8 -*-

import cgi
import cgitb
import json
import sys

import helpers as hp
import db
from sql import sql_get_data

cgitb.enable()

params = cgi.FieldStorage()
code_insee = params["insee"].value

nom_commune = []
lon_commune = None
lat_commune = None
date_debut = None
commune_composee = None
infos_commune = sql_get_data("infos_commune_insee", {"code_insee": code_insee})
if infos_commune:
    (
        nom_commune,
        lon_commune,
        lat_commune,
        date_debut,
        commune_composee,
        bounds,
        adresses_osm,
        adresses_ban,
        nb_nom_adr_osm,
        nom_osm,
        nom_ban,
        nom_cadastre,
        nom_topo,
    ) = infos_commune[0]

insee_commune_parente = None
nom_commune_parente = None
commune_parente = sql_get_data("commune_parente", {"code_insee": code_insee})
if commune_parente:
    insee_commune_parente, nom_commune_parente = commune_parente[0]

a_voisins = [
    [v[0], v[1], v[2]]
    for v in sql_get_data("voisins_insee", {"code_insee": code_insee})
]

data = [
    nom_commune,
    lon_commune,
    lat_commune,
    a_voisins,
    insee_commune_parente,
    nom_commune_parente,
    date_debut,
    commune_composee,
    json.loads(bounds),
    adresses_osm,
    adresses_ban,
    nom_osm,
    nom_ban,
    nb_nom_adr_osm,
    nom_cadastre,
    nom_topo,
]

print("Content-Type: application/json\n")
print(json.JSONEncoder().encode(data))
