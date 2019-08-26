# rampart-polio

This pipeline complements [``RAMPART``](https://github.com/artic-network/rampart) and continues downstream analysis to consensus level.

## background

Resources to aid in sequencing poliovirus in a clinical or field setting using nanopore technology. The bioinformatic pipeline was developed using [snakemake](https://snakemake.readthedocs.io/en/stable/). 


<img src="https://github.com/aineniamh/rampart-polio/blob/master/figures/polio_rampart.png">

## setup

Clone this repository:

```bash
git clone https://github.com/aineniamh/rampart-polio.git
```

and create the conda environment:

```bash
conda env create -f rampart-polio/environment.yml
```

Activate the conda environment:

```bash
conda activate rampart-polio
```
## run analysis pipeline

This pipeline assumes the reads have been run through [``RAMPART``](https://github.com/artic-network/rampart). It accepts basecalled reads and a csv file that contains barcoding and mapping information. This pipeline can be customised by modifying the variables in ``pipelines/analysis_master/config.yaml`` or by overwriting them in place with a command-line call.

If you modify the ``config.yaml`` file, to run the analysis, simply type:
```bash
snakemake --snakefile pipelines/analysis_master/Snakefile.smk
```

To overwrite the config parameters on the command line:

```bash
snakemake \
--snakefile pipelines/analysis_master/Snakefile.smk \
--config \
input_path=path/to/basecalled \
annotated_path=path/to/csv \
output_path=path/to/output \
sample=Sample01 \
barcodes=NB01,NB02,NB03 \
min_length: 500 \
max_length: 2500 \
```

## RAMPART pipeline and analysis

The analysis pipeline can be run independently as part of a stand-alone analysis or can be run as part of the RAMPART pipeline. 

> *Recommendation:* Run the latest high-accuracy model of guppy.

1. Start the sequencing run with ``MinKnow``, use live basecalling with ``guppy``.
2. Start ``RAMPART``. In the future, there will have a desktop application to do this, currently it is launched in the terminal, instructions can be found [here](https://github.com/artic-network/rampart).
3. The server process of ``RAMPART`` watches the directory where the reads will be produced.
4. This snakemake takes each file produced in real-time, demultiplexes (i.e. separates out the barcodes), and trims the fastq reads using [``porechop``](https://github.com/rambaut/Porechop), barcode labels are written to the header of each read.
5. Reads are mapped against a panel of references using [``minimap2``](https://github.com/lh3/minimap2) and the identity of the best hit is added to  a csv report. Other information, such as mapping coordinates and reference length are also reported (either in the read header or in a a csv report). The barcode information is also parsed from the read header and output as a report.
6. This information is parsed by an internal ``RAMPART`` script and pushed to the front-end for vizualisation. For each sample, the depth of coverage is shown in real-time as the reads are being produced.
7. Once sufficient depth is achieved, the anaysis pipeline can be started by clicking in ``RAMPART``'s GUI (future) or by calling ``snakemake`` on the command line. Choose the sample you want to run the analysis on, with the relevant barcodes that correspond to the sample.
8. The first step is the ``bin_to_fastq`` pipeline. [``BinLorry``](https://github.com/rambaut/binlorry) parses through the fastq files with barcode labels, pulling out the relevant reads and binning them into a single fastq file for that sample. It also applies a read-length filter, that you can customise in the GUI, and can filter by reference match, in cases of mixed-samples.
9. A process (the ``assess_sample`` pipeline) determines how many analyses to run per sample. Based on customisable ``min_reads`` and ``min_pcent`` parameters, the process checks whether there are multiple different virus genotypes within that sample and determines the number of parallel analyses that will be needed (one per type of virus).
10. The ``make_consensus`` pipeline then implements a neural-network consensus polishing algorithm. [``racon``](https://github.com/isovic/racon) and [``minimap2``](https://github.com/lh3/minimap2) are run iteratively four times against the fastq reads, generating a better consensus each time, and then a final polishing consensus-generation step is performed using [``medaka``](https://github.com/nanoporetech/medaka).
11. A markdown report is generated, summarising the viral profile of each sample.
