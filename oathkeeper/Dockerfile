FROM oryd/oathkeeper:v0.38@sha256:44d22a42c24ba77cea84ea1523616781d4461284b2f2f8adf6a5602a0aecd3fc

# Copy config source
COPY etc/oathkeeper.yaml /etc/ory/oathkeeper/oathkeeper.yaml
COPY etc/access-rules.yaml /etc/ory/oathkeeper/access-rules.yaml

# Override the default command with oathkeeper config
CMD [ "serve", "proxy", "-c", "/etc/ory/oathkeeper/oathkeeper.yaml" ]
