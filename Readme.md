This is a swagger container that works with separated files.

I am sure, there is a better solution than mine.

## Why

The main problem of the official docker-image is that it doesn't work with separated API files. For example, we have two files:
```
openapi/
    index.yaml
    entities.yaml
```

In `index.yaml` file we include entities from `entities.yaml` file via `$ref` directive. If we try to render our files using official swagger image:

```
docker run --rm -v /path/to/openapi:/doc -e SWAGGER_JSON=/doc/index.yaml -p 80:8080 swaggerapi/swagger-ui
```

we will see our `index.yaml` file, but it may contains errors about `entities.yaml` file - 404. Frontend tryes to receive content of `entities.yaml` file, but nginx under it can't resolve this file, because it doesn't exist in document root folder. We may try to mount api folder to `/usr/share/nginx/html` inside container but it won't work because in that case we replace whole needed content with our files. If we try to mount our folder somewhere inside `/usr/share/nginx/html` then we will have problems with routing.  

## Solution

I've created an image that solves this problem. All that you need is mount your directory with api files to `/openapi` inside container. For example:

```
docker run --rm -v /path/to/api:/openapi -p 80:8080 iamsalnikov/swagger
```

By default it will use `/openapi/index.yaml` file as an index file to render API documentation. If you need to use different file - specify it via `SWAGGER_JSON` environment variable:

```
docker run --rm -v /path/to/api:/openapi -p 80:8080 -e SWAGGER_JSON=/openapi/entrypoint.yaml iamsalnikov/swagger
```

### How it works inside

I configured nginx to search requested files inside `/usr/share/nginx/html` first and then inside `/openapi`.