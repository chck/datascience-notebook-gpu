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
        locales \
        locales-all \
        graphviz \
        python3.7 \
        python3.7-dev \
        python3-pip \
        python3-setuptools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install wheel && \
    pip3 install jupyterlab
RUN jupyter serverextension enable --py jupyterlab
RUN jupyter notebook --generate-config
RUN sed -i -e "s/#c.NotebookApp.ip = 'localhost'/c.NotebookApp.ip = '0.0.0.0'/g" ~/.jupyter/jupyter_notebook_config.py
WORKDIR /notebooks
EXPOSE 8888

ENTRYPOINT ["bash", "-lc"]

CMD ["jupyter lab --notebook-dir=/notebooks --no-browser --allow-root"]
