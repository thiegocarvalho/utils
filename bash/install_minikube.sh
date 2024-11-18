#!/bin/bash

# Atualizar pacotes do sistema
echo "Atualizando pacotes do sistema..."
sudo apt-get update -y && sudo apt-get upgrade -y

# Instalar dependências necessárias para o Minikube e Docker
echo "Instalando dependências..."
sudo apt-get install -y apt-transport-https curl virtualbox docker.io

# Verificar se o Docker foi instalado corretamente
echo "Verificando instalação do Docker..."
if ! command -v docker &> /dev/null
then
    echo "Docker não instalado corretamente. Saindo."
    exit 1
fi

echo "Adicionando o usuário ao grupo docker..."
sudo usermod -aG docker $USER

# Instalar o Minikube
echo "Instalando o Minikube..."
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin/

# Verificar se o Minikube foi instalado corretamente
echo "Verificando instalação do Minikube..."
if ! command -v minikube &> /dev/null
then
    echo "Minikube não instalado corretamente. Saindo."
    exit 1
fi

# Iniciar o Minikube usando o driver Docker
echo "Iniciando o Minikube com o driver Docker..."
minikube start --driver=docker

# Verificar se o Minikube iniciou corretamente
if ! minikube status &> /dev/null
then
    echo "Falha ao iniciar o Minikube. Saindo."
    exit 1
fi

# Configurar kubectl para interagir com o cluster
echo "Configurando o kubectl..."
alias kubectl='minikube kubectl --'

# Confirmar a instalação
echo "Instalação concluída. Verificando status do cluster Kubernetes..."
kubectl get nodes

echo "Minikube instalado e configurado com Docker como driver!"
