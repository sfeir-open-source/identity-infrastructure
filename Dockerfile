# Use the official lightweight Node.js 12 image.
# https://hub.docker.com/_/node
FROM docker.io/library/node:17.4.0-bullseye AS build-env

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure copying both package.json AND yarn.lock.
# Copying this first prevents re-running npm install on every code change.
COPY package.json yarn.lock ./

# Install production dependencies.
ENV NODE_ENV production
RUN yarn install --frozen-lockfile

# Copy local code to the container image.
COPY . .

# Copy files it into distroless image.
FROM gcr.io/distroless/nodejs-debian11:16

# Run as a non root user.
USER nonroot
WORKDIR /usr/src/app

COPY --from=build-env --chown=nonroot:nonroot /usr/src/app ./

# Run the web service on container startup.
EXPOSE 3000
CMD [ "dist/server.js" ]
