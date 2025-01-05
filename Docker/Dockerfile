FROM node:18-alpine

WORKDIR /home/node/app
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app

COPY --chown=node:node package*.json ./ 

USER node

RUN npm ci --only=production

COPY --chown=node:node . .


CMD ["npm", "start"]



