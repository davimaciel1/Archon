FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# Copiar todo o conteúdo do diretório original_archon
COPY original_archon/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY original_archon/ .

# Criar diretório .streamlit e configurar
RUN mkdir -p ~/.streamlit

# Configurar Streamlit para funcionar atrás de proxy
RUN echo "\
[server]\n\
port = 8501\n\
address = '0.0.0.0'\n\
headless = true\n\
enableCORS = false\n\
enableXsrfProtection = false\n\
enableWebsocketCompression = false\n\
\n\
[browser]\n\
gatherUsageStats = false\n\
serverAddress = 'uk4o88o4sw0gwo804ko04skg.49.12.191.119.sslip.io'\n\
serverPort = 80\n\
" > ~/.streamlit/config.toml

EXPOSE 8501

HEALTHCHECK CMD curl --fail http://localhost:8501/_stcore/health || exit 1

CMD ["streamlit", "run", "streamlit_ui.py", "--server.port=8501", "--server.address=0.0.0.0", "--server.headless=true", "--server.enableCORS=false", "--server.enableXsrfProtection=false"]