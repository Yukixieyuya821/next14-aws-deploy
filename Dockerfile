FROM 188635254879.dkr.ecr.us-east-1.amazonaws.com/myvocal.ai:node20 AS build-env

RUN npm install pnpm -g

COPY . /app

WORKDIR /app

RUN pnpm install && \
    pnpm build

FROM 188635254879.dkr.ecr.us-east-1.amazonaws.com/myvocal.ai:node20

WORKDIR /app


COPY --from=build-env /app ./

CMD npm start

EXPOSE 3000
