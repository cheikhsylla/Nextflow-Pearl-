#!/usr/bin/perl -w

# ./script/traduction_appel.pl ./script/code_genetique.txt $orf_file $souche > ./Result/Protein_filtre/$souche.fa

## ------ Extraction code genetique :
$codeGen = $ARGV[0];
open(CodeGen, $codeGen) || die("Imposible d'ouvrir le fichier $codeGen : $!");
undef %code1;   ## Hash du code genet a 1 lettre
undef %code3;   ## Hash du code genet a 3 lettres
while (<CodeGen>) {
    chomp;
    ($codon, $aa3, $aa1) = split(/\t/, $_);
    $code1{$codon} = "$aa1";
    $code3{$codon} = "$aa3";
}

## ----- Seuil sur la taille des proteines :
$seuil_min = 30;
$seuil_max = 5000;

## ----- Traitement du fichier fasta contenant les ORF :
open(IN, $ARGV[1])|| die("Imposible d'ouvrir le fichier $ARGV[1] : $!");;
while(<IN>) {
    chomp;
    if (/^>/) {
        @decoupe1 = split('-', $_);
        @decoupe2 = split('orf', $decoupe1[1]);
        $id_prot = $decoupe2[1];
        $seq_adn="";
    }
    else {
        $seq_adn = $_;
        undef $seq_prot;
        undef @adn_codon;
        @adn_codon = decoupe_en_codon($seq_adn);
        $seq_prot = traduction(@adn_codon); 

        ## Ecriture de la sequence dans le fichier de sortie si respect des seuils
        unless (length($seq_prot) > $seuil_max || length($seq_prot) < $seuil_min) {
            print(">$ARGV[2]-prot$id_prot\n");
            print("$seq_prot\n");
        }
        $seq_prot="";
    }
}




### ------ FONCTIONS ------- ###
## FONCTION : découper ADN en codon
sub decoupe_en_codon {
## Prend en parametre la position de depart de la lecture et une chaine contenant une sequence ADN. Renvoie un tableau dont chaque case contient un codon. 
    my ($seq_adn) = @_;
    undef @tab_adn_codon;
    for($i = 0; $i <= length($seq_adn)-2; $i = $i+3) {
        $current = substr($seq_adn, $i, 3);    ## decoupe sequence en codon de 3 nucleotides
        push(@tab_adn_codon, $current);
    }
    return @tab_adn_codon;
}

## FONCTION : traduction
sub traduction {
## Prend en parametre un tableau contenant une seq adn decoupée en codon et renvoie en sorti une chaine de caractere contenant la sequence proteique
    my (@seq_codon) = @_;
    $protein ="";
    foreach $codon(@seq_codon) {
        if (exists $code1{$codon}) {    # Si le codon est reconnu
            $protein .= $code1{$codon};  
        }
        elsif(!exists $code1{$codon}) {
            $protein .= 'X';
        }
    }
    return $protein;
}



close(CodeGen);
close(IN);
