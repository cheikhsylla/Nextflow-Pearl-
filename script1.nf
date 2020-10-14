//     ./nextflow run script1.nf --indir ./Data --outdir testdir -resu
/* 
 * pipeline input parameters 
 */

params.indir = ""
params.outdir = ""
println "\nParamètre d'entrée => indir: $params.indir \n"
println "Dossier de sortie => outdir: $params.outdir \n"

listOfFiles = file("$params.indir/*.fa")
listOfSouche = listOfFiles
listOfSouche = listOfSouche.toString().replace(/.\/Data\//, "")
println(listOfFiles)
println(listOfSouche)

//Création d'un dossier qui prend comme nom 'Result'
myDir = file('Result')
succes_echec = myDir.mkdir()
println succes_echec ? "Directory created : $myDir" : "Directory already exists: $myDir"

//Création d'un dossier qui prend comme nom 'Glimmer'
myDir = file('Result/Glimmer')
succes_echec = myDir.mkdir()
println succes_echec ? "Directory created : $myDir" : "Directory already exists: $myDir"

def getFileName (file_name) { 
    return file_name.substring(0,7) 
} 


process Glimmer {
    //Execute glimmer (recherche d'ORF) sur tous les fichiers du dossier passé en argument 
    
    publishDir './Result/Glimmer/', mode: 'copy', overwrite: false // copy output    
    
    input:
        file fastafile from listOfFiles

    output:
        file "${fastafile}.*" into glimmer_output

    shell:
    """ 
    /home/tp-home008/jsabban/Documents/M2_AMI2B/BigData/Projet/script/glimmer3.02/scripts/g3-from-scratch.csh $fastafile ${fastafile}
    """
}


//Création d'un dossier qui prend comme nom 'ORF'
myDir = file('Result/ORF')
succes_echec = myDir.mkdir()
println succes_echec ? "Directory created : $myDir" : "Directory already exists: $myDir"

listOfPredict = file("Result/Glimmer/*.predict")
println(listOfPredict)

process orf_sequence_perl {
    //publishDir './Result/ORF/', mode: 'copy', overwrite: false // copy output    

	input: 
        //val souche from listOfSouche
	    file predict from listOfPredict

	output:
	    file "${predict}_orf.*" into orf_sequence_output
    
	shell:
    """
    /home/tp-home008/jsabban/Documents/M2_AMI2B/BigData/Projet/script/orf_seq_appel.pl $predict $params.indir ${predict}
	"""
}


/*
//Création d'un dossier qui prend comme nom 'Protein'
myDir = file('Result/Protein')
succes_echec = myDir.mkdir()
println succes_echec ? "Directory created : $myDir" : "Directory already exists: $myDir"

process traduction {

	input: 
	    file 'orf_seq_file' from orf_sequence_output

	output:
	    file 'traduction_file' into traduction_output_for_blastDB, traduction_output_for_blastp

	shell:
    """
	./traduction.pl ./Result/ORF
	"""
}

//Création d'un dossier qui prend comme nom 'DataBase'
myDir = file('Result/DataBase')
succes_echec = myDir.mkdir()
println succes_echec ? "Directory created : $myDir" : "Directory already exists: $myDir"

process blast_DB_maker {

	input:
	    file 'traduction_file' from traduction_output_for_blastDB

	output:
	    file 'blast_DB_file' into blast_DB_output

	shell:
	"""
	./script/blast_make_db.pl ./Result/DataBase
	"""
}

//Création d'un dossier qui prend comme nom 'BLASTp'
myDir = file('Result/BLASTp')
succes_echec = myDir.mkdir()
println succes_echec ? "Directory created : $myDir" : "Directory already exists: $myDir"


process blastP {

	input:
	    file 'traduction_file' from traduction_output_for_blastp

	output:
	    file 'blastP' into blastP_output

	shell:
	"""
	./script/blast.pl -in ./Result/DataBase -q all 
	"""
}

*/




