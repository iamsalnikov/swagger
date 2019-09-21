FROM swaggerapi/swagger-ui:latest

RUN mkdir /openapi
COPY nginx.conf /etc/nginx/nginx.conf

ENV SWAGGER_JSON=/openapi/index.yaml