#!/usr/bin/python3

## Prend en argument un dossier qui contient des fichier avec les meilleurs hits blastp et cree un un hash qui contient la liste des genes presents dans chaque souche

# ./script/core_maker.py ./Result/Core2

import string, sys
from os import listdir
from os.path import isfile, join, isdir

d_in = sys.argv[1]
dicoBHR = {}


for dossier in listdir(d_in) : # parcours des sous-dossiers
    print(dossier)
    dicoBHR[dossier] = {}
    fichiers = [f for f in listdir(d_in+'/'+dossier) if isfile(join(d_in+'/'+dossier, f))] # récupère liste contenant nom des fichiers
    for f in fichiers : # parcours des fichiers
        print(f+"\n")
        subject = f.split("vs_")
        print(subject[1])
        bestHits = []
        if dossier != subject :
                    
