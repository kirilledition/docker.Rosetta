# Build Rosetta suit inside docker

[Rosetta](https://www.rosettacommons.org/software) software suite includes algorithms for computational modeling and analysis of protein structures.

Repository contains dockerfile that builds software suit and all dependencies.
You could build rosetta programs as static binaries. Then you can copy them from resulting container to your local machine. There are other ways to build this software, you should be able to use them from container anyway.

Provided dockerfile builds mpi version of ddg_monomer application. Feel free to change it to your needs, you can find documentation for building parameters [here](https://www.rosettacommons.org/docs/latest/build_documentation/Build-Documentation#setting-up-rosetta-3_alternative-setup-for-individual-workstations_scons-mac-linux).

`docker build` accepts build arguments


MAKE_JOBS - number of jobs that is provided for all make commands

USERNAME, PASSWORD - credentials in license document for downloading source code
