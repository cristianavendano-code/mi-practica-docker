# Clonar y compilar Angular
FROM node:22-alpine AS build

RUN apk add --no-cache git
WORKDIR /app

ARG REPO_URL=https://github.com/cristianavendano-code/nombres-angular.git
ARG BRANCH=main

RUN git clone --depth 1 --branch ${BRANCH} ${REPO_URL} .
RUN npm ci || npm install
RUN npm run build

# Servir con Nginx
FROM nginx:alpine AS runtime

RUN rm -rf /usr/share/nginx/html/*

COPY --from=build /app/dist/nombres-angular/browser/ /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]


