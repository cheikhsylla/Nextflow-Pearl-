#!/usr/bin/perl -w
# lit les fichier predict de glimmer from scratch et recupere les sequences des orf qui ont été trouvées

# ./script/orf_seq.pl ./script/glimmer3.02/scripts/run

@files = glob("$ARGV[0]/*");    # recupere les noms des fichiers contenu dans le fichier passe en argument

system"mkdir ./Result";
system"mkdir ./Result/ORF";

foreach $file (@files) {
    if ($file =~ /predict/) {
        open(IN, $file);
        @decoupe1 = split('/', $file);
        @decoupe2 = split('predict', $decoupe1[5]);
        $name = $decoupe2[0];
        chop($name);    # supprime le point à la fin du nom
        #print(">$name\n"); 
    
        system "./script/orf_seq_appel.pl $file $name ./Data > ./Result/ORF/$name.fa";
    }
    close(IN);
}
