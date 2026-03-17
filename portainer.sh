#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color (reset)

export DEBIAN_FRONTEND=noninteractive

################# ATUALIZAÇÃO DOS REPOSITÓRIOS
echo "${BLUE}- ATUALIZANDO REPOSITÓRIOS${NC}"
apt -yq update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Repositorios atualizados."
else
    echo "${RED}[ ERRO ]${NC} - Um ou mais repositorio não atualizado."
fi

################# ATUALIZAÇÃO DO SISTEMA
echo "${BLUE}[- ATUALIZANDO SISTEMA OPERACIONAL${NC}"
apt -yq upgrade > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Sistema atualizado."
else
    echo "${RED}[ ERRO ]${NC} - Sistema não atualizado."
fi

################# INSTALAÇÃO DO DOCKER
echo "${BLUE}[- INSTALANDO DOCKER SWARM${NC}"
apt -yq install docker.io > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Docker Swarm instalado"
else
    echo "${RED}[ ERRO ]${NC} - Docker Swarm não instalado."
fi


################# CONFIGURANDO DOCKER SWARM
echo "${BLUE}[- CONFIGURANDO DOCKER SWARM${NC}"
docker swarm init > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Docker Swarm configurado"
else
    echo "${RED}[ ERRO ]${NC} - Docker Swarm não configurado."
fi

################# INSTALANDO PORTAINER CE
echo "${BLUE}[- INSTALANDO PORTAINER CE${NC}"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/portainer.yaml -o portainer.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Stack do portainer carregado"
else
    echo "${RED}[ ERRO ]${NC} - Stack do portainer não carregado."
fi

docker stack deploy --prune --resolve-image always -c portainer.yaml portainer > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Portainer instalado"
else
    echo "${RED}[ ERRO ]${NC} - Portainer não instalado."
fi

################# INSTALANDO TRAEFIK CE
echo "${BLUE}[- INSTALANDO TRAEFIK CE${NC}"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/traefik.yaml -o traefik.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Stack do traefik carregado"
else
    echo "${RED}[ ERRO ]${NC} - Stack do traefik não carregado."
fi

docker stack deploy --prune --resolve-image always -c traefik.yaml traefik > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "${GREEN}[ SUCESSO ]${NC} - Traefik instalado"
else
    echo "${RED}[ ERRO ]${NC} - Traefik não instalado."
fi

