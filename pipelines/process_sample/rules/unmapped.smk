rule unmapped_all_v_all:
    input:
        reads=config["output_path"] + "/binned_{sample}/no_hit.fastq"
    output:
        config["output_path"] + "/binned_{sample}/de_novo/all_v_all.paf"
    shell:
        "minimap2 -x ava-ont {input.reads} {input.reads} > {output}"

rule miniasm:
    input:
        reads=config["output_path"] + "/binned_{sample}/no_hit.fastq",
        map=config["output_path"] + "/binned_{sample}/de_novo/all_v_all.paf"
    output:
        config["output_path"] + "/binned_{sample}/de_novo/draft_with_error.gfa"
    shell:
        "miniasm -f {input.reads} {input.map} > {output}"

rule gfa_to_fasta:
    input:
        config["output_path"] + "/binned_{sample}/de_novo/draft_with_error.gfa"
    output:
        config["output_path"] + "/binned_{sample}/de_novo/draft_with_error.fasta"
    shell:
        """
        awk '$1 ~/S/ {print ">"$2"\n"$3}' {input} > {output}
        """