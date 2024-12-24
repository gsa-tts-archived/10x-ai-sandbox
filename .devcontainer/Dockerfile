# FROM node:20.15.1
# FROM python:3.X-slim
FROM cloudfoundry/cflinuxfs4:1.232.0

# Set the working directory
WORKDIR /workspace

# Install Python 3.11
RUN apt-get update \
    && apt-get install -y \
    build-essential \
    curl \
    gnupg \
    ca-certificates 

RUN apt-get autoclean && apt-get clean && apt-get install -y \
    python3.11 \
    python3.11-venv \
    python3-pip 

# RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Create and activate virtual environment, then install Python dependencies
COPY backend/requirements.txt requirements.txt
RUN python3.11 -m venv /workspace/venv \
    && . /workspace/venv/bin/activate \
    && pip install --no-cache-dir -r requirements.txt

COPY z-root-public.crt /usr/local/share/ca-certificates
RUN update-ca-certificates

# Download and install Node.js version 20.18.0
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - 
RUN apt-get install -y nodejs=20.18.0-1nodesource1 
RUN apt-mark hold nodejs 
RUN rm -rf /var/lib/apt/lists/*

# Display Node.js and npm versions for verification (optional)
RUN node -v
RUN npm -v

# Expose port 8080
EXPOSE 8080

RUN echo "break the cache"

RUN rm -rf workspace/package-lock.json workspace/node_modules

# Install Node.js dependencies
COPY package.json ./
# COPY package-lock.json ./
RUN npm install -g yarn
RUN NODE_EXTRA_CA_CERTS=/usr/local/share/ca-certificates/z-root-public.crt yarn install

# mv build files so git clone won't complain about non-empty dir
RUN mkdir /tmp/build && mv /workspace/* /tmp/build

# Clone the repository to a temp directory
RUN git clone --branch open-webui-devcontainer https://github.com/GSA-TTS/10x-ai-sandbox.git /workspace

# restore build files now that we've cloned the repo
RUN mv /tmp/build/* /workspace

# Build the frontend application with increased memory
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm run build

# can be remove after push
COPY start.sh ./start.sh
COPY z-root-public.crt ./z-root-public.crt

# Define local variables
ARG COMBINED_CERT_PATH=/workspace/venv/lib/python3.11/site-packages/certifi/cacert.pem
RUN cat /workspace/z-root-public.crt >> ${COMBINED_CERT_PATH}
ENV REQUESTS_CA_BUNDLE=$COMBINED_CERT_PATH
ENV SSL_CERT_FILE=$COMBINED_CERT_PATH

# # Run the install_ollama.sh script
# RUN ./install_ollama.sh
# RUN ollama serve & sleep 5 && ollama pull llama3.2

CMD ["nohup", "./start.sh", "&", "sleep", "infinity"]
