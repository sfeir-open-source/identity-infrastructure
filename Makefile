all:
	docker compose build

.PHONY: deploy-identity-foundation-account
deploy-identity-foundation-account:
	gcloud beta run deploy \
		identity-foundation-account \
		--max-instances 1 \
		--allow-unauthenticated \
		--source identity-foundation-account \
		--port 80 \
		--ingress all

.PHONY: deploy-identity-foundation-app
deploy-identity-foundation-app:
	gcloud beta run deploy \
		identity-foundation-app \
		--max-instances 1 \
		--allow-unauthenticated \
		--source identity-foundation-app \
		--port 3000 \
		--ingress all

.PHONY: deploy-oathkeeper-proxy
deploy-oathkeeper-proxy:
	gcloud beta run deploy \
		oathkeeper-proxy \
		--max-instances 1 \
		--service-account oathkeeper@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com \
		--allow-unauthenticated \
		--source oathkeeper \
		--port 4455 \
		--update-secrets /secrets/ory/oathkeeper/id_token.jwks.json=oathkeeper-idtoken-jwks:latest \
		--ingress all

.PHONY: deploy-oathkeeper-api
deploy-oathkeeper-api:
	gcloud beta run deploy \
		oathkeeper-api \
		--max-instances 1 \
		--service-account oathkeeper@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com \
		--allow-unauthenticated \
		--source oathkeeper \
		--port 4456 \
		--update-secrets /secrets/ory/oathkeeper/id_token.jwks.json=oathkeeper-idtoken-jwks:latest \
		--ingress all

.PHONY: deploy-oathkeeper-idtoken-jwks-version
deploy-oathkeeper-idtoken-jwks-version:
	gcloud secrets versions add \
		oathkeeper-idtoken-jwks \
		--data-file oathkeeper/id_token.jwks.json

.PHONY: deploy-oathkeeper-idtoken-jwks
deploy-oathkeeper-idtoken-jwks:
	gcloud secrets create \
		oathkeeper-idtoken-jwks

.PHONY: deploy-oathkeeper-service-account
deploy-oathkeeper-service-account:
	gcloud iam service-accounts create oathkeeper \
		--description="Oathkeeper Service Account" \
		--display-name="Oathkeeper"

.PHONY: deploy-oathkeeper-service-account-secret-accessor
deploy-oathkeeper-service-account-secret-accessor:
	gcloud projects add-iam-policy-binding ${GOOGLE_CLOUD_PROJECT} \
		--member=serviceAccount:oathkeeper@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com \
		--role=roles/secretmanager.secretAccessor
