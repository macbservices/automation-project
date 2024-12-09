# Usar imagem oficial do Python
FROM python:3.9-slim

# Configurar o diretório de trabalho
WORKDIR /app

# Copiar os arquivos do projeto
COPY requirements.txt .
COPY app.py .

# Instalar as dependências do Python
RUN pip install --no-cache-dir -r requirements.txt

# Expor a porta 5000
EXPOSE 5000

# Comando para iniciar a aplicação
CMD ["python", "app.py"]
