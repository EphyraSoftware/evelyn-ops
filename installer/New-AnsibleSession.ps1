if (-Not (Test-Path ansible-host/ssh)) {
    New-Item -Name "ansible-host/ssh" -ItemType "directory"
}

if (-Not (Test-Path ansible-host/ssh/id_rsa)) {
    ssh-keygen -b 2048 -t rsa -f "${pwd}/ansible-host/ssh/id_rsa" -q -N `"`"
}

Push-Location ansible-host
docker buildx build -t ansible-host .
Pop-Location

docker run --rm -it -u 0 --network host -v "${pwd}/play:/play" ansible-host bash
