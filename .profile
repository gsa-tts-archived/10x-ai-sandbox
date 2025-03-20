#!/usr/bin/env bash

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$SCRIPT_DIR" || exit

if [ -n "$VCAP_APPLICATION" ]; then
    echo "Running inside a Cloud Foundry instance - setting paths and services"

    echo "PATH is set to: $PATH"
    echo "LD_LIBRARY_PATH is set to: $LD_LIBRARY_PATH"

    NEW_PATH="/home/vcap/deps/0/python/bin"
    echo "New path to add: $NEW_PATH"

    # Check if the new path is already in the PATH variable
    if [[ ":$PATH:" != *":$NEW_PATH:"* ]]; then
        echo "Adding $NEW_PATH to PATH..."
        export PATH="$NEW_PATH:$PATH"
    fi
    echo "Current PATH is now: $PATH"

    function vcap_get_service() {
        local path name
        name="$1"
        path="$2"
        echo "$VCAP_SERVICES" | jq --raw-output "try (.[][] | select(.name == \"$name\") | $path)"
    }

    function trim_url() {
        # Handle both forms of endpoint_url we have seen
        local trimmed_url=$(echo "$1" | sed -r 's/\/(openai.*)?$//')
        echo "$trimmed_url"
    }

    # TKTK - The service name should be configurable
    export VCAP_SERVICE_NAME_AZURE_AI_GPT4O="azure-ai-gpt-4o"

    export endpoint_url=$(vcap_get_service $VCAP_SERVICE_NAME_AZURE_AI_GPT4O .credentials.endpoint_url)

    if [ -n "$endpoint_url" ]; then
        echo "$VCAP_SERVICE_NAME_AZURE_AI_GPT40 endpoint_url is set to: $endpoint_url"

        export AZURE_OPENAI_ENDPOINT=$(trim_url "$endpoint_url")
        echo "AZURE_OPENAI_ENDPOINT is set to: $AZURE_OPENAI_ENDPOINT"

        export AZURE_OPENAI_GPT4OMNI_DEPLOYMENT_NAME=$(vcap_get_service $VCAP_SERVICE_NAME_AZURE_AI_GPT4O .credentials.deployment_name)
        echo "AZURE_OPENAI_GPT4OMNI_DEPLOYMENT_NAME is set to: $AZURE_OPENAI_GPT4OMNI_DEPLOYMENT_NAME"

        # TKTK - Assume we get this from the environment
        #export AZURE_OPENAI_API_VERSION=$(vcap_get_service $VCAP_SERVICE_NAME_AZURE_AI_GPT4O .credentials.model_version)
        echo "AZURE_OPENAI_API_VERSION is set to: $AZURE_OPENAI_API_VERSION"

        export AZURE_OPENAI_API_KEY=$(vcap_get_service $VCAP_SERVICE_NAME_AZURE_AI_GPT4O .credentials.api_key)
        echo "AZURE_OPENAI_API_KEY is set to: $(echo $AZURE_OPENAI_API_KEY | sed 's/^\(....\).*$/\1****/')"

    else
        "$VCAP_SERVICE_NAME_AZURE_AI_GPT40 not found in VCAP_SERVICES - gpt-4o defaulting to environment variables"
    fi

    echo "===========/startup/===========\n$(df -h | sed -n '2p')\n============================"
fi
