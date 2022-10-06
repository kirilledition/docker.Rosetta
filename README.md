# Build Rosetta suit inside docker

[Rosetta](https://www.rosettacommons.org/software) software suite includes algorithms for computational modeling and analysis of protein structures.

Repository contains dockerfile that builds software suit and all dependencies.
You could build rosetta programs as static binaries. Then you can copy them from resulting container to your local machine. There are other ways to build this software, you should be able to use them from container anyway.

Provided dockerfile builds mpi version of Rosetta application. Feel free to change it to your needs by passing BUILD_BINARIES, you can find documentation for building parameters [here](https://www.rosettacommons.org/docs/latest/build_documentation/Build-Documentation#setting-up-rosetta-3_alternative-setup-for-individual-workstations_scons-mac-linux).

`docker build` accepts build arguments


MAKE_JOBS - number of jobs that is provided for all make commands

USERNAME, PASSWORD - credentials in license document for downloading source code
ROSETTACOMMONS_CONDA_USERNAME, ROSETTACOMMONS_CONDA_PASSWORD - pyRosetta specific credentials. If not passed, will not be built

# ROSETTAFOLDDB_PATH points to a folder with the databases untar'ed (bfd, pdb100_2021Mar03, UniRef30_2020_06)
export ROSETTAFOLDDB_PATH=/home/jcastellanos/RosettaFoldDBs


 docker run -it --gpus=all -v $ROSETTAFOLDDB_PATH/bfd:/RoseTTaFold/bfd -v $ROSETTAFOLDDB_PATH/pdb100_2021Mar03:/RoseTTaFold/pdb100_2021Mar03 -v  $ROSETTAFOLDDB_PATH/UniRef30_2020_06:/RoseTTaFold/UniRef30_2020_06 -v $(pwd):$(pwd) -w $(pwd) rosettafold:main-latest run_pyrosetta_ver.sh input.fa .
