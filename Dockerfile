FROM ubuntu:22.04

# Set up the locale and timezone
ENV LANG=en_US.UTF-8
ENV TZ=America/New_York
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6
ENV XDG_RUNTIME_DIR=/home/user_dev/tmp_xdg


# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    ffmpeg \
    libsm6 \
    libxext6 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    cmake \
    git \
    pkgconf \
    libyaml-cpp-dev \
    python3-dev \
    python3-pip\
    nano \
    wget \
    && rm -rf /var/lib/apt/lists/*


# Install miniconda
RUN  apt-get update && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "--login", "-c"]

RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r && \
    conda create -n "view_synthesis" python=3.10.12 -y && \
    conda activate view_synthesis && \
    conda install nvidia/label/cuda-12.6.1::cuda -y && \
    pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126 && \
    pip3 install plyfile && \
    pip3 install tqdm && \
    pip3 install open3d && \
    pip3 install opencv-python && \
    pip3 install joblib &&\
    pip3 install pillow && \
    rm -rf /var/lib/apt/lists/*



# Copying Required Files to the Container
COPY config/ /config

# Setting up non-root user: could be overwriten during docker run
ARG USERNAME=user_dev
ARG USER_UID=1001
ARG USER_GID=$USER_UID

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
  && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
  && mkdir /home/$USERNAME/.config && chown $USER_UID:$USER_GID /home/$USERNAME/.config

#Set up passwordless sudo
RUN apt-get update && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    && rm -rf /var/lib/apt/lists/*

# Make a data directory for voulume mounting
RUN cd /home/$USERNAME \
    && mkdir code_ws \
    && chown $USER_UID:$USER_GID code_ws

# Make a data directory for voulume mounting
RUN cd /home/$USERNAME \    
    && mkdir tmp_xdg \
    && chown $USER_UID:$USER_GID tmp_xdg \
    && chmod 700 tmp_xdg

RUN echo "export XDG_RUNTIME_DIR=/home/$USERNAME/tmp_xdg" >> /home/$USERNAME/.bashrc
RUN echo "export LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6" >> /home/$USERNAME/.bashrc
RUN echo "export RUNLEVEL=3" >> /home/$USERNAME/.bashrc

COPY entrypoint.sh /entrypoint.sh


# Copy source, model and pyroject files to the container
COPY src /home/$USERNAME/code_ws/src
COPY model /home/$USERNAME/code_ws/model
COPY data /home/$USERNAME/code_ws/data
COPY README.md /home/$USERNAME/code_ws/

WORKDIR /home/$USERNAME/code_ws/

# RUN uv init && uv sync

# # Activate the virtual environment
# RUN source /home/$USERNAME/code_ws/.venv/bin/activate

# Set up entrypoint and default command
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
# Command to source bashrc
CMD ["/bin/bash", "-l"]


