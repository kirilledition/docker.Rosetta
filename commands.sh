docker build \
    --build-arg MAKE_JOBS=32 \
    --build-arg USERNAME=username \
    --build-arg PASSWORD=password \
    -t kirill/rosetta.mpi \
    .

docker run \
    --rm \
    -it \
    -v "$(pwd)"/input:/input \
    -v "$(pwd)"/result:/result \
    --name kirill.rosetta \
    kirill/rosetta.mpi \
    /bin/bash -c "
    cd /result;
    mpirun --allow-run-as-root -n 10 \
    /home/rosetta.source.release-314/main/source/bin/ddg_monomer.mpi.linuxgccrelease \
        -in:file:s /input/wildtype_structure_prediction_af2.pdb \
        -ddg::mut_file /input/mutfile"
