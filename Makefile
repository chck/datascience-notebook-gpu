NAME:=chck/datascience-notebook-gpu
TAG:=ubuntu18.04
IMAGE:=$(NAME):$(TAG)

.PHONY: all
all: help

.PHONY: passwd  ## Generate hashed password
passwd:
	docker run --rm -it $(IMAGE) "python3 -c 'from notebook.auth import passwd;print(passwd())'"

.PHONY: build  ## Build image
build:
	docker build -t $(IMAGE) .

.PHONY: run  ## Run JupyterLab
run:
	docker run --runtime=nvidia --rm -it -p 8887:8888 -v $(LOCAL_NOTEBOOK_DIR):/notebooks $(IMAGE) "jupyter lab --notebook-dir=/notebooks --no-browser --allow-root --NotebookApp.password=$(NOTEBOOK_PASSWD)"

.PHONY: help ## View help
help:
	@grep -E '^.PHONY: [a-zA-Z_-]+.*?## .*$$' $(MAKEFILE_LIST) | sed 's/^.PHONY: //g' | awk 'BEGIN {FS = "## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
