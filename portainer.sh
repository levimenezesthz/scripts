#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
YELLOW='\033[0;33m'

export DEBIAN_FRONTEND=noninteractive

####################################################################
# PREINSTALAÇÃO #################################################### 
####################################################################
echo -e "${YELLOW}[ PROCESS ]${NC} - ATUALIZANDO SISTEMA E INSTALANDO PRÉ-REQUISITOS"
apt -yq update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Repositorios atualizados."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Um ou mais repositorio NÃO atualizado."
fi

apt -yq upgrade > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Sistema atualizado."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Sistema NÃO atualizado."
fi

apt install -yq ca-certificates curl gnupg lsb-release > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Pré-requisitos instalados."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Pré-requisitos NÃO instalados."
fi
####################################################################
# INSTALAÇÃO DO DOCKER SWARM ####################################### 
####################################################################

echo -e "${YELLOW}[ PROCESS ]${NC} - INSTALANDO DOCKER SWARM"
mkdir -p /etc/apt/keyrings > /dev/null 2>&1 && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Chave do repositorio Docker configurada."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Chave do repositorio Docker NÃO configurada."
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null 2>&1 && apt update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Repositorio oficial do Docker configurado."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Repositorio oficial do Docker NÃO configurado."
fi

apt install -yq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Docker Swarm instalado."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Docker Swarm NÃO instalado."
fi

docker swarm init > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Docker Swarm configurado."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Docker Swarm NÃO configurado."
fi

docker network create --driver bridge --attachable internal 
docker network create --driver overlay --attachable external

####################################################################
# INSTALAÇÃO DO PORTAINER ########################################## 
####################################################################

echo -e "${YELLOW}[ PROCESS ]${NC} - INSTALANDO PORTAINER CE"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/portainer.yaml -o portainer.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Stack do portainer carregado."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Stack do portainer NÃO carregado."
fi

docker stack deploy --prune --resolve-image always -c portainer.yaml portainer > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Portainer instalado."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Portainer NÃO instalado."
fi

####################################################################
# INSTALAÇÃO DO TRAEFIK ############################################ 
####################################################################

echo -e "${YELLOW}[ PROCESS ]${NC} - INSTALANDO TRAEFIK"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/traefik.yaml -o traefik.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Stack do traefik carregada."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Stack do traefik NÃO carregado."
fi

docker network create --driver overlay reverse_proxy

docker stack deploy --prune --resolve-image always -c traefik.yaml traefik > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESS_ ]${NC} - Traefik instalada."
else
    echo -e "${RED}[ ERRO___ ]${NC} - Traefik NÃO instalado."
fi

