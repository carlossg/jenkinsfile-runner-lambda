LAMBDA_FUNCTION = jenkinsfile-runner
VERSION = 1.0-SNAPSHOT

.PHONY: all

all: clean build

clean:
	rm -rf target

target/docker.mk: Dockerfile
	docker build -t csanchez/jenkinsfile-runner-lambda .
	mkdir -p target
	touch target/docker.mk
	rm -rf target/opt

target/%/jenkins target/%/repo target/%/plugins target/%/bin/mvn target/%/bin/git: target/docker.mk
	docker run \
		-ti --rm \
		-v $(shell pwd)/target:/target --entrypoint bash csanchez/jenkinsfile-runner-lambda \
		-c "test -d /target/$* || cp -a /$* /target/"

target/jenkinsfile-runner-lambda-$(VERSION).jar: target/opt/jenkins target/opt/repo target/opt/plugins target/opt/bin/mvn target/opt/bin/git
	mvn package

build: target/jenkinsfile-runner-lambda-$(VERSION).jar

target/layer-jenkinsfile-runner.zip: target/opt/jenkins target/opt/repo
	cd target/opt && zip -r --symlinks ../layer-jenkinsfile-runner.zip bin/jenkinsfile-runner jenkins repo
target/layer-plugins.zip: target/opt/plugins
	cd target/opt && zip -r --symlinks ../layer-plugins.zip plugins
target/layer-tools.zip: target/opt/maven target/opt/bin/git target/opt/usr
	cd target/opt && zip -r --symlinks ../layer-tools.zip \
		usr \
		bin/git* libexec share \
		bin/mvn maven

target/layer-tools.json: target/layer-tools.zip
	aws lambda publish-layer-version --layer-name tools --compatible-runtimes java8 --zip-file fileb://target/layer-tools.zip > target/layer-tools.json
target/layer-jenkinsfile-runner.json: target/layer-jenkinsfile-runner.zip
	aws lambda publish-layer-version --layer-name jenkinsfile-runner --compatible-runtimes java8 --zip-file fileb://target/layer-jenkinsfile-runner.zip > target/layer-jenkinsfile-runner.json
target/layer-plugins.json: target/layer-plugins.zip
	aws lambda publish-layer-version --layer-name plugins --compatible-runtimes java8 --zip-file fileb://target/layer-plugins.zip > target/layer-plugins.json

publish-layers: target/layer-tools.json target/layer-plugins.json target/layer-jenkinsfile-runner.json
	$(eval tools_arn := $(shell cat target/layer-tools.json | jq .LayerVersionArn))
	$(eval jenkinsfile_runner_arn := $(shell cat target/layer-jenkinsfile-runner.json | jq .LayerVersionArn))
	$(eval plugins_arn := $(shell cat target/layer-plugins.json | jq .LayerVersionArn))
	@echo Updating function
	aws lambda update-function-configuration --function-name $(LAMBDA_FUNCTION) --memory-size 1024 --timeout 900 --runtime java8 \
		--layers $(tools_arn) $(jenkinsfile_runner_arn) $(plugins_arn)

publish-function: target/jenkinsfile-runner-lambda-$(VERSION).jar
	@echo Publishing function
	aws lambda update-function-code --function-name $(LAMBDA_FUNCTION) --zip-file fileb://target/jenkinsfile-runner-lambda-$(VERSION).jar

publish: publish-layers publish-function
