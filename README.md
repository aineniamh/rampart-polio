# rampart-polio

Repository for a snakemake pipeline for running analysis for the artic-polio MinION sequencing project in collaboration with the Grassly lab.

## background

Resources to aid in sequencing poliovirus in a clinical or field setting using nanopore technology. The bioinformatic pipeline was developed using [snakemake](https://snakemake.readthedocs.io/en/stable/). 


<img src="https://github.com/aineniamh/rampart-polio/blob/master/figures/polio_rampart.png">


## run demux_map

```bash
snakemake \
--snakefile pipelines/demux_map/Snakefile \
--configfile pipelines/demux_map/config.yaml \
--config \
filename_stem=FAK42048_dd2780e2a05b66437f26aefe02f6af5817bb6020_5 \
input_path=path/to/data/basecalled/pass \
output_path=path/to/pipeline_output \
references_file=references.fasta \
barcodes=[19,20,21,22]
```
