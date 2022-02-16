FROM node:16.14.0 as base

COPY . /app
WORKDIR /app
# Install deps
RUN npm i

EXPOSE 8091
CMD ["npm","run","start"]
