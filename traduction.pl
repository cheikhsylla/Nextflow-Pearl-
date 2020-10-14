#!/usr/bin/perl -w
# fonction par appel du script tradcution_appel.pl et traduit tous les fichier contrenu dans le dossier contenu en argument. Le dossier contient des fichiers fasta contenants des orf

# ./script/traduction.pl ./Result/ORF

@orf_files = glob("$ARGV[0]/*");    # recupere les noms des fichiers contenu dans le fichier passe en argument

system"mkdir ./Result/Protein_filtre";

foreach $orf_file (@orf_files) {
    open(IN, $orf_file);
    ## Recuperation du nom de la souche ;:
    @decoupe1 = split('/', $orf_file);
    @decoupe2 = split('fa', $decoupe1[3]);
    $souche = $decoupe2[0];
    chop($souche);    # supprime le point à la fin du nom
    # print("$name\n");

    #system"./script/traduction_appel.pl ./script/code_genetique.txt $orf_file $souche";
    system"./script/traduction_appel.pl ./script/code_genetique.txt $orf_file $souche > ./Result/Protein_filtre/$souche.fa";

    close(IN);
}
