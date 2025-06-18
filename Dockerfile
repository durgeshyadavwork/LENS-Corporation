FROM node:18

WORKDIR /usr/src/app

EXPOSE 3000

COPY . .

RUN npm install



CMD ["node", "index.js"]




