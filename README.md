# datascience-notebook-gpu

## Requirements
```
NVIDIA Docker>=2.0.*
CUDA==10.1
NVIDIA GPU such as GeForce series
```

## Usage

### Pull image
```
docker pull chck/datascience-notebook-gpu:ubuntu18.04
```

### Run container
```
docker run --rm -it -p 8887:8888 chck/datascience-notebook-gpu:ubuntu18.04
```

### Access JupyterLab
```
open http://(127.0.0.1 or CONTAINER_REMOTE_IP):8887
```
