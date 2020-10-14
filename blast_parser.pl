#!/usr/bin/perl -w

## Prend en argument un dossier qui contient des fichier BLAST et cree un fichier pour chaque souche avec le meilleur hit, selon les seuils definis

# ./script/blast_parser.pl ./Result/blastTest

use List::Util qw[min max];

#### DEFINITION DES SEUILS #####
$seuil_couverture = 0.9;
$seuil_identite = 0.8;
$seuil_evalue = 1e-20;
################################

system"mkdir ./Result/Core";

@dossier = glob("$ARGV[0]/*");
foreach $dossier(@dossier) {
    # ----- Recuperation du nom de la souche ----- 
    @decoupe1 = split('/', $dossier);
    $souche_query = $decoupe1[3];

    system"mkdir ./Result/Core/".$souche_query;
    

    @files = glob("$dossier/*");
    foreach $file(@files) {
        @decoupe1 = split('vs_', $file);
        $souche_subject = $decoupe1[1];
        
        open(FILE, $file);
        open(STDOUT, ">./Result/Core/".$souche_query."/core_".$souche_query."_vs_".$souche_subject);
        while(<FILE>) {      
            $nb_ligne = 0;
            unless (/^#/) {
                
                if ($nb_ligne < 1) {
                    @ligne = split('\t', $_);
                    $query = $ligne[0];
                    $subject = $ligne[1];
                    $couverture = max($ligne[4]/$ligne[2], $ligne[4]/$ligne[3]);
                    $identite = $ligne[5];
                    $evalue = $ligne[6];

                    if ($evalue < $seuil_evalue && $couverture >= $seuil_couverture && $identite >= $seuil_identite) {
                        print STDOUT ( $_);
                    }
                }            
            }
            if (/^#/) {
                $nb_ligne = 0;
            }
            
        }
        
        close(FILE);
        close(STDOUT);
    }
    
}   

