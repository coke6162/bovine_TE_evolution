All bash scripts were written to be run using SLURM on the HPC cluster at the University of Colorado Boulder. Some scripts are written to be run in parallel as [job arrays](https://slurm.schedmd.com/job_array.html).

These scripts assume all samples are named as described in download_assemblies.sbatch. For simplicity all input and output files are written to the same directory.

Run the scripts in the following order:
1. [download_assemblies.sbatch]()
2. [RepeatMasker.sbatch]() (via [run_RepeatMasker.sh]())

Required packages:
* RepeatMasker v4.1.0 (https://www.repeatmasker.org/)

Note that this analysis uses the RepeatMasker-RepBase Sequence Database (release 20181026). The RepeatMasker installation by default includes the Libraries/RMRBSeqs.embl database file. Convert this to RMRBSeqs.fasta using the util/buildRMLibFromEMBL.pl script.