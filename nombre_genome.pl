#!/usr/bin/perl -w

# ./script/nombre_genome.pl ./Data > result.csv

@files = glob("$ARGV[0]/*");    # recupere les noms des fichiers contenu dans le fichier passe en argumehnt

print("fichier \t nombre de chromosome \t taille théorique \t taille en nucleotides(lu)\n");
 
foreach $file (@files) {
    open(IN, $file);
    $nb_nt = 0;
    $nb_chromosome = 0;
    while (<IN>) {  
        chomp;
        if (/^>/) {  
            $nb_chromosome = $nb_chromosome+1;
            @decoupe1 = split('Chromosome:1:', $_);
            @decoupe2 = split(':', $decoupe1[1]);
            $taille_theorique = $decoupe2[0];
        }
        else {  # on est sur une ligne
            $nb_nt = $nb_nt + length($_);
        } 
    }
    print("$file \t $nb_chromosome \t $taille_theorique \t $nb_nt\n");
    close($file);
}
