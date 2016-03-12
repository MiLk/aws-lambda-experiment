WORK_DIR = $(shell pwd)
VIRTUALENV = $(shell if hash virtualenv2 &>/dev/null; then \
	echo "virtualenv2"; \
else \
	echo "virtualenv"; \
fi)
PYTHON_VERSION = $(lastword $(sort $(wildcard $(addsuffix /python2.?,$(subst :, ,$(PATH))))))

.PHONY: all clean python-deps build update

all: python-deps build update

clean:
	rm -rf build venv

python-deps:
	@if [[ -z "$(PYTHON_VERSION)"  ]]; then echo "error: couldn't find a valid version of python installed"; false; fi
	@if ! hash $(VIRTUALENV) &>/dev/null; then echo "error: couldn't find a valid version of virtualenv installed"; false; fi
	if [[ ! -d venv  ]]; then $(VIRTUALENV) --python=$(PYTHON_VERSION) venv; fi
	venv/bin/pip install --upgrade pip
	venv/bin/pip install --upgrade -r requirements.txt

build:
	@mkdir -p build
	cd venv/lib/python2.7/site-packages && \
		zip -r $(WORK_DIR)/build/Registration.zip *
	cd src && \
		zip -r $(WORK_DIR)/build/Registration.zip Registration.py

update:
	aws lambda update-function-code \
	  --region ap-northeast-1 \
		--profile lambda \
		--function-name Registration \
		--zip-file fileb://$(WORK_DIR)/build/Registration.zip