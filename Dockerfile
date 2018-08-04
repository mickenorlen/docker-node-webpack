FROM node:8.9-alpine

RUN apk update && apk upgrade && apk add yarn bash vim
