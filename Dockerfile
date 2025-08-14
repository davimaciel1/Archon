FROM python:3.11-slim

WORKDIR /app

RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Copiar todo o conteúdo do diretório original_archon
COPY original_archon/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY original_archon/ .

EXPOSE 8501

CMD ["streamlit", "run", "streamlit_ui.py", "--server.port=8501", "--server.address=0.0.0.0"]