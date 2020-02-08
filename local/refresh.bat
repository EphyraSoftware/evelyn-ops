call down
call up
pushd ..\evelyn-services\environments\local
del terraform.tfstate
echo "Sleeping for 150 seconds before configuring environment"
timeout /t 150
terraform init
terraform apply -auto-approve
popd