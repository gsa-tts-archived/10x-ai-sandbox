FROM node:20.15.1

# Install Python 3.11
RUN apt update && apt show python3 && apt install python3 && apt install python3-pip python3-venv -y

# Set the working directory
WORKDIR /workspace

# Expose port 8080
EXPOSE 8080

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install cypress with zscaler root cert
COPY z-root-public.pem ./
RUN NODE_EXTRA_CA_CERTS=/workspace/z-root-public.pem npm install cypress

# Install Node.js dependencies
RUN npm install

# Create and activate virtual environment, then install Python dependencies
COPY backend/requirements.txt ./
RUN python3 -m venv /workspace/venv \
    && . /workspace/venv/bin/activate \
    && pip install --no-cache-dir -r requirements.txt

RUN rm -rf requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Define local variables
ARG COMBINED_CERT_PATH=/workspace/venv/lib/python3.11/site-packages/certifi/cacert.pem

# Set environment variables for CA certificates
ENV REQUESTS_CA_BUNDLE=$COMBINED_CERT_PATH
ENV SSL_CERT_FILE=$COMBINED_CERT_PATH

# Append z-root-public.pem to the combined certificate path
RUN cat z-root-public.pem >> ${COMBINED_CERT_PATH}

# Build the frontend application with increased memory
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm run build

# Run the install_ollama.sh script
RUN ./install_ollama.sh

# Set the custom start script as the entrypoint
ENTRYPOINT ["./start.sh"]
