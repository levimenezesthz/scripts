#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'

export DEBIAN_FRONTEND=noninteractive

################# ATUALIZAÇÃO DOS REPOSITÓRIOS
echo "${BLUE}- ATUALIZANDO REPOSITÓRIOS${NC}"
apt -yq update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Repositorios atualizados."
else
    echo -e "${RED}[ ERRO ]${NC} - Um ou mais repositorio não atualizado."
fi

################# ATUALIZAÇÃO DO SISTEMA
echo "${BLUE}[- ATUALIZANDO SISTEMA OPERACIONAL${NC}"
apt -yq upgrade > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Sistema atualizado."
else
    echo -e "${RED}[ ERRO ]${NC} - Sistema não atualizado."
fi

################# INSTALAÇÃO DO DOCKER
echo "${BLUE}[- INSTALANDO DOCKER SWARM${NC}"
apt -yq install docker.io > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Docker Swarm instalado"
else
    echo -e "${RED}[ ERRO ]${NC} - Docker Swarm não instalado."
fi


################# CONFIGURANDO DOCKER SWARM
echo "${BLUE}[- CONFIGURANDO DOCKER SWARM${NC}"
docker swarm init > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Docker Swarm configurado"
else
    echo -e "${RED}[ ERRO ]${NC} - Docker Swarm não configurado."
fi

################# INSTALANDO PORTAINER CE
echo "${BLUE}[- INSTALANDO PORTAINER CE${NC}"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/portainer.yaml -o portainer.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Stack do portainer carregado"
else
    echo -e "${RED}[ ERRO ]${NC} - Stack do portainer não carregado."
fi

docker stack deploy --prune --resolve-image always -c portainer.yaml portainer > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Portainer instalado"
else
    echo -e "${RED}[ ERRO ]${NC} - Portainer não instalado."
fi

################# INSTALANDO TRAEFIK CE
echo "${BLUE}[- INSTALANDO TRAEFIK CE${NC}"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/traefik.yaml -o traefik.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Stack do traefik carregada"
else
    echo -e "${RED}[ ERRO ]${NC} - Stack do traefik não carregado."
fi

docker stack deploy --prune --resolve-image always -c traefik.yaml traefik > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Traefik instalada"
else
    echo -e "${RED}[ ERRO ]${NC} - Traefik não instalado."
fi

