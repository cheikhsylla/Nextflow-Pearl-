#!/usr/bin/perl -w

# ./script/orf_seq_appel.pl $file ./Data > ./Result/ORF/$name.fa

print("\$Predict file =======> ./Result/Glimmer/$ARGV[0]\n");
print("Dossier ======> $ARGV[1]\n");
## Recuperation de la sequence du chromosome
@decoupe1 = split('.fa', $ARGV[0]);
$name = $decoupe1[0];
$data_file = $ARGV[1]."/".$name.".fa";
$seq ='';
print("data file ====> $data_file");
open(IN2, $data_file)|| die("Imposible d'ouvrir le fichier $data_file : $!");
while (<IN2>) {
    chomp;
    unless (/^>/) {
	    $seq .= $_;
    }
}
close(IN2);


## Parcours du fichier predict
open(IN, "./Result/Glimmer/$ARGV[0]") || die("Imposible d'ouvrir le fichier $IN : $!");
print("souche =====> ".$name."\n");
print("data_file =====> ".$data_file."\n");
while (<IN>) {  
    chomp;
    $current_line = $_;
    unless (/^>/) { 
        @ligne = split(' ', $current_line);
        $orf_name = $ligne[0];
        $coord1 = $ligne[1];
        $coord2 = $ligne[2];
        $taille = $coord2-$coord1;
        if ($coord2 < $coord1) {    # si orf sur brin inverse
            $taille = abs($taille);
            $orf_a_ecrire = substr($seq, $coord2-1, $taille+1);
            $orf_a_ecrire = reverse($orf_a_ecrire);
            $orf_a_ecrire =~ tr/ACGT/TGCA/;     # complementaire
        }
        else {
            $orf_a_ecrire = substr($seq, $coord1-1, $taille+1);
        }                
        print(">$name-$orf_name\n$orf_a_ecrire\n");
    } 
}
close(IN);
