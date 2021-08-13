FROM node:14.14.0-alpine3.12

RUN apk add --no-cache bash curl

RUN npm config set cache /home/node/backend/.npm-cache --global

RUN npm i -g @nestjs/cli@^7.0.0

RUN mkdir -p /home/node/backend/node_modules

WORKDIR /home/node/backend

COPY package.json yarn.* ./

RUN yarn

CMD [ "yarn", "start:dev" ]

