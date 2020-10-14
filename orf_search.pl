#!/usr/bin/perl -w
# fait tourner glimmer from scratch sur un ensemble de fichier dans le fichier

# ./script/orf_search.pl ./Data 

@files = glob("$ARGV[0]/*");    # recupere les noms des fichiers contenu dans le fichier passe en argument


 
foreach $file (@files) {
    open(IN, $file);
    @decoupe1 = split('/', $file);
    @decoupe2 = split('.fa', $decoupe1[2]);
    $seq_name = $decoupe2[0];    
    
    system "./script/glimmer3.02/scripts/g3-from-scratch.csh $file ./script/glimmer3.02/scripts/run/$seq_name"; 

    close(IN);
}
