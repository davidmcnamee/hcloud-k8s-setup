
.PHONY: up
up:
	terraform init
	terraform apply -auto-approve -var-file="env.tfvars"
	terraform output --raw kubeconfig > ~/.kube/config

.PHONY: down
down:
#	source env.tfvars && HCLOUD_TOKEN=$$hcloud_token hcloud load-balancer delete kube-hetzner
	terraform destroy -auto-approve -var-file="env.tfvars"

