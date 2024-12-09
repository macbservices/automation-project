#!/bin/bash

# Atualizar o sistema
apt update && apt upgrade -y

# Instalar Docker e dependências
apt install -y curl wget vim gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" > /etc/apt/sources.list.d/docker.list
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Criar diretório do projeto
mkdir -p /opt/automation-project
cd /opt/automation-project

# Criar arquivos do projeto
cat <<EOF > Dockerfile
# Usar imagem oficial do Python
FROM python:3.9-slim

WORKDIR /app
COPY requirements.txt .
COPY app.py .

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "app.py"]
EOF

cat <<EOF > requirements.txt
Flask==2.1.3
Flask-Cors==3.0.10
selenium==4.5.0
EOF

cat <<EOF > app.py
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({"message": "Hello, World!"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
EOF

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

# Construir e iniciar os containers
docker-compose up -d

echo "Projeto configurado com sucesso. Acesse: http://170.254.135.110:5000"
