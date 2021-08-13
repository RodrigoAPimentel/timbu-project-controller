FROM node:14.14.0-alpine3.12

WORKDIR /frontend

ENV PATH /frontend/node_modules/.bin:$PATH

COPY package.json ./

RUN npm install --silent

COPY . ./

CMD ["npm", "run", "dev"]
