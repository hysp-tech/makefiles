.PHONY: notebook notebook-colab

notebook:  ## notebook
	jupyter notebook

notebook-colab:  ## notebook on colab
	jupyter notebook \
    --NotebookApp.allow_origin='https://colab.research.google.com' \
    --port=8888 \
    --NotebookApp.port_retries=0