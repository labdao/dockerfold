FROM ubuntu:focal

# installing packages required for installation
RUN echo "downloading basic packages for installation"
RUN mkdir app
RUN apt-get update
RUN apt-get install -y tmux wget curl git

# download instructions
RUN echo "downloading instructions and starting install"
RUN cd app
RUN wget https://raw.githubusercontent.com/YoshitakaMo/localcolabfold/main/install_colabfold_linux.sh
RUN bash install_colabfold_linux.sh

