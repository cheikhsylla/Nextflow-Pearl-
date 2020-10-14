#!/usr/bin/perl -w

# ./script/blast.pl -in ./Result/DataBase -q Escherichia_coli_apec_o1 


## Gestion des arguments ##
%hash_argv = @ARGV;

$dossier_file = $hash_argv{'-in'};
$q = $hash_argv{'-q'};  # 'all' ou 'nom_souche'

system "mkdir ./Result/BLASTp";

@files = glob("$dossier_file/*.fa"); # lit que les *.fa

# ----- Creation tableau avec tous les noms des souches ----- 
undef @all_souche;
foreach $infile(@files) {
    @decoupe1 = split('/', $infile);
    @decoupe2 = split('fa', $decoupe1[3]);
    $souche = $decoupe2[0];
    chop($souche);
    push(@all_souche, $souche);
}

# ----- Run BLAST sur tout------
if ($q eq 'all') {
    foreach $query (@all_souche) {
        system "mkdir ./Result/BLASTp/$query";
        foreach $subject (@all_souche) {
        $file_result = "./Result/BLASTp/$query/blast_".$query."_vs_".$subject;
        system "blastp -query ./Result/DataBase/$query.fa -db ./Result/DataBase/$subject -outfmt '7  qseqid sseqid qlen slen length pident evalue' -out $file_result";
        }
    }
}
else {
    system "mkdir ./Result/BLASTp/$q";
    $i = 1;
    foreach $subject (@all_souche) {
        $nb_seq = scalar(@all_souche);
        $file_result = "./Result/BLASTp/$q/blast_".$q."_vs_".$subject;
        system "blastp -query ./Result/DataBase/$q.fa -db ./Result/DataBase/$subject -outfmt '7  qseqid sseqid qlen slen length pident evalue' -out $file_result";
        system "echo $q vs $subject : Fait\t $i/$nb_seq\n";
        $i++;
    }
}
