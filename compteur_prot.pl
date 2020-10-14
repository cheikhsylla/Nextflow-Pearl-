#!/usr/bin/perl -w
## Parcours tous les fichiers presents dans le dossier passe en argument et compte le nombre de prot, les tailles min/max/moyenne. Genere un fichier csv en sorti.

# ./script/compteur_prot.pl ./Result/Protein_filtre > ./Result/Statistiques/comptage_prot_filtre.csv

@files = glob("$ARGV[0]/*");    # recupere les noms des fichiers contenu dans le fichier passe en argumehnt

print("Genome \t Nombre de proteines \t Taille min \t Taille max \t Taille moyenne\n");
 
foreach $file (@files) {
    open(IN, $file);
    $nb_prot = 0;
    $taille_min = 1000000;
    $taille_max = 0;
    $taille_cumul = 0;
    $taille_moyenne = 0;
    while (<IN>) {  
        chomp;
        if (/^>/) {  
            $nb_prot = $nb_prot + 1;
            ## nom du genome :
            @decoupe1 = split('/', $file);
            @decoupe2 = split('.fa', $decoupe1[3]);
            $genome = $decoupe2[0];;
        }
        else {  # lecture de la sequence proteique
            $taille_cumul = $taille_cumul + length($_);
            if (length($_)>$taille_max) {
                $taille_max = length($_); 
            }
            if (length($_)<$taille_min) {
                $taille_min = length($_); 
            }
        } 
    }
    $taille_moyenne = int($taille_cumul/$nb_prot);  # prend la partie entiere de la division
    print("$genome \t $nb_prot \t $taille_min \t $taille_max \t $taille_moyenne\n");
    close($file);
}
