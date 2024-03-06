FROM node:lts-alpine3.18 AS build-env

RUN npm install pnpm -g

COPY . /app

WORKDIR /app

RUN pnpm install && \
    pnpm build

FROM node:lts-alpine3.18

WORKDIR /app


COPY --from=build-env /app ./

CMD npm start

EXPOSE 3000
