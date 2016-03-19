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
		zip -r $(WORK_DIR)/build/Authorizer.zip * && \
		zip -r $(WORK_DIR)/build/RequestToken.zip * && \
		zip -r $(WORK_DIR)/build/Registration.zip * && \
		zip -r $(WORK_DIR)/build/Login.zip *
	cd src && \
		zip -r $(WORK_DIR)/build/Authorizer.zip Authorizer.py && \
		zip -r $(WORK_DIR)/build/Secured.zip Secured.py && \
		zip -r $(WORK_DIR)/build/RequestToken.zip RequestToken.py && \
		zip -r $(WORK_DIR)/build/Registration.zip Registration.py && \
		zip -r $(WORK_DIR)/build/Login.zip Login.py

update:
	aws lambda update-function-code \
	  	--region ap-northeast-1 \
		--profile lambda \
		--function-name Registration \
		--zip-file fileb://$(WORK_DIR)/build/Registration.zip
	aws lambda update-function-code \
		--region ap-northeast-1 \
		--profile lambda \
		--function-name Login \
		--zip-file fileb://$(WORK_DIR)/build/Login.zip
	aws lambda update-function-code \
		--region ap-northeast-1 \
		--profile lambda \
		--function-name Authorizer \
		--zip-file fileb://$(WORK_DIR)/build/Authorizer.zip
	aws lambda update-function-code \
		--region ap-northeast-1 \
		--profile lambda \
		--function-name Secured \
		--zip-file fileb://$(WORK_DIR)/build/Secured.zip
	aws lambda update-function-code \
		--region ap-northeast-1 \
		--profile lambda \
		--function-name RequestToken \
		--zip-file fileb://$(WORK_DIR)/build/RequestToken.zip

.PHONY: create-lambda

create-lambda:
	aws lambda create-function \
		--function-name Registration \
		--zip-file fileb://$(WORK_DIR)/build/Registration.zip \
		--role arn:aws:iam::990529572879:role/execution-role \
		--handler Registration.lambda_handler \
		--runtime python2.7 \
		--region ap-northeast-1  \
		--profile lambda
	aws lambda create-function \
		--function-name Login \
		--zip-file fileb://$(WORK_DIR)/build/Login.zip \
		--role arn:aws:iam::990529572879:role/execution-role \
		--handler Login.lambda_handler \
		--runtime python2.7 \
		--region ap-northeast-1  \
		--profile lambda
	aws lambda create-function \
		--function-name Authorizer \
		--zip-file fileb://$(WORK_DIR)/build/Authorizer.zip \
		--role arn:aws:iam::990529572879:role/execution-role \
		--handler Authorizer.lambda_handler \
		--runtime python2.7 \
		--region ap-northeast-1  \
		--profile lambda
	aws lambda create-function \
		--function-name Secured \
		--zip-file fileb://$(WORK_DIR)/build/Secured.zip \
		--role arn:aws:iam::990529572879:role/execution-role \
		--handler Secured.lambda_handler \
		--runtime python2.7 \
		--region ap-northeast-1  \
		--profile lambda
	aws lambda create-function \
		--function-name RequestToken \
		--zip-file fileb://$(WORK_DIR)/build/RequestToken.zip \
		--role arn:aws:iam::990529572879:role/execution-role \
		--handler RequestToken.lambda_handler \
		--runtime python2.7 \
		--region ap-northeast-1  \
		--profile lambda
