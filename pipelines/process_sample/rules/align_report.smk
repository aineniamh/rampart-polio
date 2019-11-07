rule makeblastdb:
    input:
        "references/VP1_Database_wt_and_sabin.fasta"
    output:
        "references/VP1_Database_wt_and_sabin.fasta.nhr"
    shell:
        "makeblastdb -in {input} -dbtype nucl"

rule whoami:
    input:
        consensus= config["output_path"] + "/binned_{sample}/medaka/{analysis_stem}/consensus.fasta",
        db="references/VP1_Database_wt_and_sabin.fasta",
        db_hidden="references/VP1_Database_wt_and_sabin.fasta.nhr"
    output:
        config["output_path"] + "/binned_{sample}/blast/{analysis_stem}.blast.csv"
    shell:
        "blastn -task blastn -db {input.db} "
        "-query {input.consensus} -out {output} "
        "-num_threads 1 -outfmt 10"

rule makeblastdb_detailed:
    input:
        "references/VP1_Database_DetailedPV.fasta"
    output:
        "references/VP1_Database_DetailedPV.fasta.nhr"
    shell:
        "makeblastdb -in {input} -dbtype nucl"

rule whoami_detailed:
    input:
        consensus= config["output_path"] + "/binned_{sample}/medaka/{analysis_stem}/consensus.fasta",
        db="references/VP1_Database_DetailedPV.fasta",
        db_hidden="references/VP1_Database_DetailedPV.fasta.nhr"
    output:
        config["output_path"] + "/binned_{sample}/blast/{analysis_stem}.detailed.blast.csv"
    shell:
        "blastn -task blastn -db {input.db} "
        "-query {input.consensus} -out {output} "
        "-num_threads 1 -outfmt 10"

rule make_report:
    input:
        blast=config["output_path"] + "/binned_{sample}/blast/{analysis_stem}.blast.csv",
        consensus= config["output_path"] + "/binned_{sample}/medaka/{analysis_stem}/consensus.fasta",
        db="references/VP1_Database_wt_and_sabin.fasta",
        blast_detailed=config["output_path"] + "/binned_{sample}/blast/{analysis_stem}.detailed.blast.csv",
        db_detailed="references/VP1_Database_DetailedPV.fasta"
    params:
        barcode="{sample}"
    output:
        report=config["output_path"] + "/binned_{sample}/report/{analysis_stem}.report.md",
        seqs=config["output_path"] + "/binned_{sample}/report/{analysis_stem}.fasta"
    shell:
        "python rules/generate_report.py "
        "--blast_file {input.blast} --detailed_blast_file {input.blast_detailed} "
        "--blast_db {input.db} --detailed_blast_db {input.db_detailed} "
        "--consensus {input.consensus} "
        "--output_report {output.report} --output_seqs {output.seqs} "
        "--sample {params.barcode}"
