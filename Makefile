.PHONY: account-container-image
account-container-image:
	docker buildx build \
		--tag ghcr.io/sfeir-open-source/identity-infrastructure/account \
		--label org.opencontainers.image.version=0.1.0 \
		--label org.opencontainers.image.source=https://github.com/sfeir-open-source/identity-infrastructure \
		--push \
		identity-foundation-account

.PHONY: app-container-image
app-container-image:
	docker buildx build \
		--tag ghcr.io/sfeir-open-source/identity-infrastructure/app \
		--label org.opencontainers.image.version=0.1.0 \
		--label org.opencontainers.image.source=https://github.com/sfeir-open-source/identity-infrastructure \
		--push \
		identity-foundation-app
