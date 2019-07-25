FROM nvidia/cuda:10.1-devel-ubuntu18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
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
        python3-setuptools \
        libssl1.0-dev \
        nodejs-dev \
        node-gyp \
        npm \
        ffmpeg \
        libmecab-dev \
        mecab \
        mecab-ipadic-utf8 && \
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

# gcloud-sdk
ENV CLOUD_SDK_VERSION=253.0.0 \
    PATH="/google-cloud-sdk/bin:${PATH}"
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64
RUN /bin/bash -lc 'gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image'

# mecab-ipadic-neologd
RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git /tmp/neologd && \
    mkdir -p /usr/lib/x86_64-linux-gnu/mecab/dic && \
    /tmp/neologd/bin/install-mecab-ipadic-neologd -n -u -y && \
    rm -rf /tmp/neologd
ENV MECAB_DICDIR="/usr/lib/x86_64-linux-gnu/mecab/dic/mecab-ipadic-neologd"

# pip dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -U wheel && \
    pip3 install -r /tmp/requirements.txt
RUN jupyter serverextension enable --py jupyterlab && \
    jupyter notebook --generate-config && \
    sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" ~/.jupyter/jupyter_notebook_config.py && \
    jupyter labextension install @jupyter-widgets/jupyterlab-manager

WORKDIR /notebooks
EXPOSE 8888

ENTRYPOINT ["bash", "-lc"]

CMD ["jupyter lab --notebook-dir=/notebooks --no-browser --allow-root"]
