#!/bin/bash

# Atualizar o sistema e instalar dependências essenciais
echo "Atualizando pacotes do sistema..."
sudo apt update && sudo apt upgrade -y

# Instalar pacotes necessários
echo "Instalando pacotes necessários..."
sudo apt install -y curl git python3-pip python3-dev docker.io docker-compose

# Habilitar e iniciar o Docker
echo "Habilitando e iniciando o Docker..."
sudo systemctl enable --now docker

# Verificar se o Docker e Docker Compose estão instalados corretamente
echo "Verificando versões do Docker e Docker Compose..."
docker --version
docker-compose --version

# Adicionar o usuário ao grupo 'docker' para execução sem 'sudo'
echo "Adicionando usuário ao grupo docker para execução sem sudo..."
sudo usermod -aG docker $USER

# Instalar dependências Python (selenium, flask)
echo "Instalando dependências Python (Selenium, Flask)..."
pip3 install selenium flask

# Clonar o repositório do projeto
echo "Clonando repositório do projeto..."
git clone https://github.com/macbservices/automation-project.git /home/$USER/automation-project

# Garantir permissões corretas no diretório do projeto
echo "Configurando permissões do diretório do projeto..."
sudo chown -R $USER:$USER /home/$USER/automation-project
sudo chmod -R 755 /home/$USER/automation-project

# Navegar até o diretório do projeto
cd /home/$USER/automation-project

# Corrigir o arquivo docker-compose.yml (ajustar para versão 3.3)
echo "Corrigindo docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: "3.3"
services:
  automation-app:
    build:
      context: .
    ports:
      - "5000:5000"
    depends_on:
      - chrome-container

  chrome-container:
    image: selenium/standalone-chrome
    ports:
      - "4444:4444"
EOF

# Subir os containers com Docker Compose
echo "Iniciando containers Docker..."
docker-compose up -d

# Finalizando e informando sobre o status
echo "Instalação concluída! O painel está disponível em: http://painel.macbvendas.com.br:5000"
