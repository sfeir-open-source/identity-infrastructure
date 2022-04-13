FROM docker.io/library/node:17.4.0-bullseye-slim@sha256:127e7abf453152266a11ccbed1510dff5241b671855e32611d19fb348a8f4a41 AS base

# Define the current directory based on defacto community standard
WORKDIR /usr/src/app

FROM base AS runtime

# Pull production only depedencies
COPY package.json yarn.lock ./
RUN yarn install --production

FROM runtime AS builder

# Pull all depedencies
RUN yarn install

FROM builder AS source

# Copy source
COPY . .

FROM source AS build

# Build application
ENV NODE_ENV=production
RUN yarn build

FROM runtime

# Switch to the node default non-root user
USER node

# Copy build
COPY --from=build /usr/src/app/next.config.js ./next.config.js
COPY --from=build /usr/src/app/.next ./.next
COPY --from=build /usr/src/app/public ./public

# Set entrypoint
EXPOSE 3000
CMD [ "yarn", "start" ]
