#!/usr/bin/perl -w

## Prend en argument un dossier qui contient des fichier fasta et cree une base de donnees blastp pour chaque fichier

# ./script/blast_make_db.pl ./Result/DataBase

@files = glob("$ARGV[0]/*.fa");

foreach $infile(@files) {
    # ----- Recuperation du nom de la souche ----- 
    @decoupe1 = split('/', $infile);
    @decoupe2 = split('fa', $decoupe1[3]);
    $souche = $decoupe2[0];
    chop($souche);
  
    system "makeblastdb -in $infile -out ./Result/DataBase/$souche -parse_seqids -dbtype prot";

}
