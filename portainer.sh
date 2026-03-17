#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

################# ATUALIZAÇÃO DOS REPOSITÓRIOS
echo "\e[34m[- ATUALIZANDO REPOSITÓRIOS\e[0m"
apt -yq update; then
    echo "\e[32m[ SUCESSO ]\e[0m - Repositorios atualizados."
else
    echo "\e[31m[ ERRO ]\e[0m - Um ou mais repositorio não atualizado."
fi

################# ATUALIZAÇÃO DO SISTEMA
echo "\e[34m[- ATUALIZANDO SISTEMA OPERACIONAL\e[0m"
apt -yq upgrade; then
    echo "\e[32m[ SUCESSO ]\e[0m - Sistema atualizado."
else
    echo "\e[31m[ ERRO ]\e[0m - Sistema não atualizado."
fi

################# INSTALAÇÃO DO DOCKER
echo "\e[34m[- INSTALANDO DOCKER SWARM\e[0m"
apt -yq install docker.io; then
    echo "\e[32m[ SUCESSO ]\e[0m - Docker Swarm instalado"
else
    echo "\e[31m[ ERRO ]\e[0m - Docker Swarm não instalado."
fi


################# CONFIGURANDO DOCKER SWARM
echo "\e[34m[- CONFIGURANDO DOCKER SWARM\e[0m"
docker swarm init; then
    echo "\e[32m[ SUCESSO ]\e[0m - Docker Swarm configurado"
else
    echo "\e[31m[ ERRO ]\e[0m - Docker Swarm não configurado."
fi

################# INSTALANDO PORTAINER CE
echo "\e[34m[- INSTALANDO PORTAINER CE\e[0m"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/portainer.yaml -o portainer.yaml; then
    echo "\e[32m[ SUCESSO ]\e[0m - Stack do portainer carregado"
else
    echo "\e[31m[ ERRO ]\e[0m - Stack do portainer não carregado."
fi

docker stack deploy --prune --resolve-image always -c portainer.yaml portainer; then
    echo "\e[32m[ SUCESSO ]\e[0m - Portainer instalado"
else
    echo "\e[31m[ ERRO ]\e[0m - Portainer não instalado."
fi

echo "\e[34m[- INSTALANDO TRAEFIK CE\e[0m"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/traefik.yaml -o traefik.yaml; then
    echo "\e[32m[ SUCESSO ]\e[0m - Stack do traefik carregado"
else
    echo "\e[31m[ ERRO ]\e[0m - Stack do traefik não carregado."
fi

docker stack deploy --prune --resolve-image always -c traefik.yaml traefik; then
    echo "\e[32m[ SUCESSO ]\e[0m - Traefik instalado"
else
    echo "\e[31m[ ERRO ]\e[0m - Traefik não instalado."
fi

