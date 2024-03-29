# FROM ubuntu:focal
FROM --platform=linux/amd64 nvidia/cuda:11.6.0-devel-ubuntu20.04 

# installing packages required for installation
RUN echo "downloading basic packages for installation"
RUN apt-get update
RUN apt-get install -y tmux wget curl git
RUN apt-get install -y libstdc++6 gcc

# checking installation of tools
RUN gcc --version
RUN nvcc --version

# clone git repository
RUN git clone https://github.com/awesome-bio/lab-alphafold.git

# download instructions from YoshitakaMo localcolabfold work
# RUN echo "downloading instructions and starting install"
# RUN wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabbatch_linux.sh

#####################
# install colabfold
# RUN cd lab-alphafold
# RUN bash install_colabbatch_linux.sh
# manually running installation in docker
RUN type wget || { echo "wget command is not installed. Please install it at first using apt or yum." ; exit 1 ; }
RUN type curl || { echo "curl command is not installed. Please install it at first using apt or yum. " ; exit 1 ; }

# defining variable, do not change
ARG COLABFOLDDIR="/src"

RUN mkdir -p ${COLABFOLDDIR}
RUN cd ${COLABFOLDDIR}
RUN wget https://git.scicore.unibas.ch/schwede/openstructure/-/raw/7102c63615b64735c4941278d92b554ec94415f8/modules/mol/alg/src/stereo_chemical_props.txt --no-check-certificate
RUN wget -q -P . https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash ./Miniconda3-latest-Linux-x86_64.sh -b -p ${COLABFOLDDIR}/conda
RUN rm Miniconda3-latest-Linux-x86_64.sh
RUN . "${COLABFOLDDIR}/conda/etc/profile.d/conda.sh"
ENV PATH="${COLABFOLDDIR}/conda/condabin:${PATH}"
RUN conda create --name colabfold-conda python=3.7 -y
# Switch to the new environment:
SHELL ["conda", "run", "-n", "colabfold-conda", "/bin/bash", "-c"] 
RUN conda update -n base conda -y
RUN conda install -c conda-forge python=3.7 cudnn==8.2.1.32 cudatoolkit==11.1.1 openmm==7.5.1 pdbfixer -y
# patch to openmm
RUN wget -qnc https://raw.githubusercontent.com/deepmind/alphafold/main/docker/openmm.patch --no-check-certificate
RUN wc /openmm.patch
RUN (cd /src/conda/envs/colabfold-conda/lib/python3.7/site-packages; patch -s -p0 < /openmm.patch)
RUN mv /stereo_chemical_props.txt /colabfold_batch
RUN rm openmm.patch
# Download the updater
RUN wget -qnc https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/update_linux.sh --no-check-certificate
RUN chmod +x update_linux.sh
# install alignment tools
RUN conda install -c conda-forge -c bioconda kalign3=3.2.2 hhsuite=3.3.0 -y
# install ColabFold and Jaxlib
RUN /src/conda/envs/colabfold-conda/bin/python3.7 -m pip install "colabfold[alphafold] @ git+https://github.com/sokrypton/ColabFold"
RUN /src/conda/envs/colabfold-conda/bin/python3.7 -m pip install https://storage.googleapis.com/jax-releases/cuda111/jaxlib-0.1.72+cuda111-cp37-none-manylinux2010_x86_64.whl
RUN /src/conda/envs/colabfold-conda/bin/python3.7 -m pip install jax==0.2.25

# hack to share the parameter files in a workstation.
RUN (cd /src/conda/envs/colabfold-conda/lib/python3.7/site-packages/colabfold; sed -i -e "s#props_path = \"stereo_chemical_props.txt\"#props_path = \"/colabfold_batch/stereo_chemical_props.txt\"#" batch.py)
RUN (cd /src/conda/envs/colabfold-conda/lib/python3.7/site-packages/alphafold/relax; sed -i -e 's/CPU/CUDA/g' amber_minimize.py)

# bin directory to run with cachebust
ARG CACHEBUST=2
RUN (cd /lab-alphafold; git pull) 
RUN mkdir -p /src/bin
RUN mv /lab-alphafold/colabfold_batch /src/bin/colabfold_batch
RUN chmod +x /src/bin/colabfold_batch

# # complete installation
ENV PATH="/src/bin:$PATH"