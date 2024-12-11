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
COPY z-root.pem ./
RUN NODE_EXTRA_CA_CERTS=/workspace/z-root.pem npm install cypress

# Install Node.js dependencies
RUN npm install

# Create and activate virtual environment, then install Python dependencies
COPY backend/requirements.txt ./
RUN python3 -m venv /workspace/venv \
    && . /workspace/venv/bin/activate \
    && pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Build the frontend application with increased memory
ENV NODE_OPTIONS="--max-old-space-size=4096"
RUN npm run build

# Command to run the application
CMD ["ls"]
