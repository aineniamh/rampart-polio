# rampart-polio

Repository for a snakemake pipeline for running analysis for the artic-polio MinION sequencing project in collaboration with the Grassly lab.

## background

Resources to aid in sequencing poliovirus in a clinical or field setting using nanopore technology. The bioinformatic pipeline was developed using [snakemake](https://snakemake.readthedocs.io/en/stable/). 


<!-- <img src="https://github.com/aineniamh/rampart-polio/blob/master/figures/polio_rampart.png"> -->


## run analysis pipeline

```bash
snakemake 
--snakefile pipelines/analysis_master/Snakefile.smk \
--config input_path=path/to/basecalled \
annotated_path=path/to/csv \
output_path=path/to/output
```
