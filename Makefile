NAME=restify-example

all: test docker

pull_deps:
	npm install

test: pull_deps
	npm test

docker:
	docker build -t "${NAME}" .

run:
	docker-compose rm -vf
	docker-compose build
	docker-compose up;
