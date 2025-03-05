FROM node:23.7.0-alpine3.20

RUN apk add --no-cache bash curl

RUN npm config set cache /home/node/app/.npm-cache --global

RUN npm i -g @nestjs/cli@^11.0.0

RUN mkdir -p /home/node/app/node_modules

WORKDIR /home/node/app

COPY package.json yarn.* tsconfig.* ./

RUN yarn --ignore-platform

CMD [ "yarn", "start:dev" ]

