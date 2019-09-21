bld:
	docker build -t iamsalnikov/swagger:latest .

run-example:
	docker run --rm -p 80:8080 -v `pwd`/example:/openapi iamsalnikov/swagger