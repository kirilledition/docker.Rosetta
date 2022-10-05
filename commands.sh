docker build \
    --build-arg MAKE_JOBS=32 \
    --build-arg USERNAME=username \
    --build-arg PASSWORD=password \
    -t kirill/rosetta.mpi \
    .

docker run \
    --rm \
    -it \
    -v "$(pwd)"/data:/data \
    -v "$(pwd)"/result:/home \
    --name kirill.rosetta \
    kirill/rosetta \
    /home/rosetta.source.release-314/main/source/bin/ddg_monomer.cxx11thread.linuxgccrelease \
        -in:file: /data/structure.pdb \
        -ddg::mut_file /data/mutations.mutfile \
        -multithreading:total_threads 10
