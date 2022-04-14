all:
	docker compose build

.PHONY: deploy-identity-foundation-account
deploy-identity-foundation-account:
	gcloud run deploy \
		identity-foundation-account \
		--source identity-foundation-account \
		--port 80

.PHONY: deploy-identity-foundation-app
deploy-identity-foundation-app:
	gcloud run deploy \
		identity-foundation-app \
		--source identity-foundation-app \
		--port 3000
