FROM nvidia/cuda:10.1-devel-ubuntu18.04

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
        libssl-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        git \
        curl \
        file \
        wget \
        libopenblas-dev \
        gcc-8 \
        g++-8 \
        locales \
        locales-all \
        graphviz \
        python3.7 \
        python3.7-dev \
        python3-pip \
        python3-setuptools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# tsne-cuda
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
RUN wget https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5-Linux-x86_64.sh \
    -q -O /tmp/cmake-install.sh && \
    chmod u+x /tmp/cmake-install.sh && \
    mkdir /usr/bin/cmake && \
    /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake && \
    rm /tmp/cmake-install.sh
ENV PATH="/usr/bin/cmake/bin:${PATH}"
RUN git clone https://github.com/CannyLab/tsne-cuda.git && \
    cd tsne-cuda && \
    git submodule sync && \
    git submodule update -i && \
    cd build && \
    cmake .. && \
    make
RUN cd tsne-cuda/build/python && \
    python3 setup.py install

# pip dependencies
RUN pip3 install wheel && \
    pip3 install jupyterlab
RUN jupyter serverextension enable --py jupyterlab && \
    jupyter notebook --generate-config && \
    sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" ~/.jupyter/jupyter_notebook_config.py

WORKDIR /notebooks
EXPOSE 8888

ENTRYPOINT ["bash", "-lc"]

CMD ["jupyter lab --notebook-dir=/notebooks --no-browser --allow-root"]
