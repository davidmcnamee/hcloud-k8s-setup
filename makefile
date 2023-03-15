
.PHONY: up
up:
	terraform apply -auto-approve -var-file="env.tfvars"

.PHONY: down
down:
	hcloud load-balancer delete k3s &
	terraform destroy -auto-approve

