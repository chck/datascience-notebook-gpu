# datascience-notebook-gpu

[![dockeri.co](https://dockeri.co/image/chck/datascience-notebook-gpu)](https://hub.docker.com/r/chck/datascience-notebook-gpu)

## Requirements
```
NVIDIA GPU such as GeForce series
NVIDIA Docker>=2.0.*
CUDA==10.1

direnv>=2.15.*
```

## Usage

### Pull image
```
docker pull chck/datascience-notebook-gpu:ubuntu18.04
```

### Generate hashed password
```shell
make passwd

>Enter password:
>Verify password:
>sha1:xxxxxxxxxxxxxxxxxxx
```

### Apply hashed password via direnv with dotenv
```
vi .env
=====
NOTEBOOK_PASSWD=sha1:xxxxxxxxxxxxxxxxxxx
LOCAL_NOTEBOOK_DIR=/path/to/dir/
```

```
direnv allow .
```

### Run container
```
make run
```

### Access JupyterLab
``` 
open http://(127.0.0.1 or CONTAINER_REMOTE_IP):8887
```
