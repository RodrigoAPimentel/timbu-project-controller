ARG BASE_IMAGE

FROM ${BASE_IMAGE}

ARG NODE_ENV

RUN apk add --no-cache bash curl
RUN npm config set cache /home/node/app/.npm-cache --global
RUN npm i -g @nestjs/cli@^11.0.0
RUN mkdir -p /home/node/app/node_modules

WORKDIR /home/node/app

COPY package.json yarn.* tsconfig.* ./
COPY .env ./

RUN if [ "$NODE_ENV" = "production" ]; then \
    yarn build && \
    yarn install --production --ignore-platform; \
    else \
    yarn install --ignore-platform; \
    fi

CMD if [ "$NODE_ENV" = "production" ]; then \
    yarn start:prod; \
    else \
    yarn start:dev; \
    fi

