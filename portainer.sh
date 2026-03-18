#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'
BLUE='\033[0;34m'

export DEBIAN_FRONTEND=noninteractive

####################################################################
# PREINSTALAÇÃO #################################################### 
####################################################################
echo -e "${BLUE}[ PROCESS ]${NC} - ATUALIZANDO SISTEMA"
apt -yq update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Repositorios atualizados."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Um ou mais repositorio NÃO atualizado."
fi

apt -yq upgrade > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Sistema atualizado."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Sistema NÃO atualizado."
fi

####################################################################
# INSTALAÇÃO DO DOCKER SWARM ####################################### 
####################################################################

echo -e "${BLUE}[ PROCESS ]${NC} - INSTALANDO DOCKER SWARM"

sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Chave do repositorio Docker configurada."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Chave do repositorio Docker NÃO configurada."
fi

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list && apt update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Repositorio oficial do Docker configurado."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Repositorio oficial do Docker NÃO configurado."
fi

apt -yq install docker.io > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Docker Swarm instalado."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Docker Swarm NÃO instalado."
fi

docker swarm init > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Docker Swarm configurado."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Docker Swarm NÃO configurado."
fi

####################################################################
# INSTALAÇÃO DO PORTAINER ########################################## 
####################################################################

echo -e "${BLUE}[ PROCESS ]${NC} - INSTALANDO PORTAINER CE"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/portainer.yaml -o portainer.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Stack do portainer carregado."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Stack do portainer NÃO carregado."
fi

docker stack deploy --prune --resolve-image always -c portainer.yaml portainer > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Portainer instalado."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Portainer NÃO instalado."
fi

####################################################################
# INSTALAÇÃO DO TRAEFIK ############################################ 
####################################################################

echo -e "${BLUE}[ PROCESS ]${NC} - INSTALANDO TRAEFIK"

curl -L https://raw.githubusercontent.com/levimenezesthz/scripts/refs/heads/main/traefik.yaml -o traefik.yaml > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Stack do traefik carregada."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Stack do traefik NÃO carregado."
fi

docker stack deploy --prune --resolve-image always -c traefik.yaml traefik > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[ SUCESSO ]${NC} - Traefik instalada."
else
    echo -e "${RED}[ _ERRO_ ]${NC} - Traefik NÃO instalado."
fi

