
.PHONY: up
up:
	terraform apply -auto-approve

.PHONY: down
down:
	hcloud load-balancer delete k3s &
	terraform destroy -auto-approve

