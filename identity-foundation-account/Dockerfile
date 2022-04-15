FROM docker.io/library/node:17.4.0-bullseye-slim@sha256:127e7abf453152266a11ccbed1510dff5241b671855e32611d19fb348a8f4a41 AS assets

# Define the current directory based on defacto community standard
WORKDIR /usr/src/app

# Pull depedencies
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy source
COPY postcss.config.js tailwind.config.js ./
COPY assets assets
COPY src src

# Build assets
ENV NODE_ENV=production
RUN yarn build

FROM docker.io/library/php:7.2-apache@sha256:4dc0f0115acf8c2f0df69295ae822e49f5ad5fe849725847f15aa0e5802b55f8

# Copy assets build
COPY --from=assets /usr/src/app/public/css /var/www/html/css

# Copy source
COPY src /var/www/html
