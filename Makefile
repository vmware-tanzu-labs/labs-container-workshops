PORTAL_NAME = labs-container-workshops
REGISTRY = localhost:5001

# Use the default "all" target the first time you want to deploy the workshop.

all: publish-workshops deploy-workshops

# Use the "publish-workshops" target to build and publish OCI image artefacts
# which contain the workshop content files for each workshop. The artefact will
# be pushed to the configured image registry.

publish-workshops:
	imgpkg push -i $(REGISTRY)/$(PORTAL_NAME)-files:latest -f .

# Use the "deploy-workshops" target to deploy the workshop to your Kubernetes
# cluster. This will wait for the deployment of the training portal to be
# completed before returning.

deploy-workshops: update-workshops
	kubectl apply -f resources/trainingportal.yaml
	STATUS=1; ATTEMPTS=0; ROLLOUT_STATUS_CMD="kubectl rollout status deployment/training-portal -n $(PORTAL_NAME)-ui"; until [ $$STATUS -eq 0 ] || $$ROLLOUT_STATUS_CMD || [ $$ATTEMPTS -eq 5 ]; do sleep 5; $$ROLLOUT_STATUS_CMD; STATUS=$$?; ATTEMPTS=$$((ATTEMPTS + 1)); done

# Use the "update-workshop" target to update the workshop definition. When the
# training portal is configured to detect changes to the workshop definition
# the existing workshop environment will be shutdown and a new one created which
# uses the new workshop definition.

update-workshops:
	for file in workshops/*/resources/workshop.yaml; do kubectl apply -f $$file; done

# Use the "delete-workshops" target to delete the workshop from your Kubernetes
# cluster. This will wait for the deployment of the training portal to be
# finished before returning.

delete-workshops:
	-kubectl delete -f resources/trainingportal.yaml --cascade=foreground
	-for file in workshops/*/resources/workshop.yaml; do kubectl delete -f $$file; done

# Use the "open-workshops" target to open a web browser on the training portal
# which provides access to the workshop.

open-workshops:
	URL=`kubectl get trainingportal/$(PORTAL_NAME) -o go-template={{.status.educates.url}}`; (test -x /usr/bin/xdg-open && xdg-open $$URL) || (test -x /usr/bin/open && open $$URL) || true
