#!/bin/bash
set -e

containers=$(yq e -o=json '.containers' config.yaml)

# Check if containers exist
if [[ -z "$containers" ]]; then
    echo "Error: No containers found in config.yaml"
    exit 1
fi

# Get GitHub owner
GITHUB_OWNER="${GITHUB_OWNER:-$(echo $GITHUB_REPOSITORY | cut -d'/' -f1)}"

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Error: GITHUB_TOKEN is not set. Exiting."
    exit 1
fi

# Login to GitHub Container Registry
echo "$GITHUB_TOKEN" | docker login ghcr.io -u "$GITHUB_OWNER" --password-stdin

# Loop through each container config and build images
echo "$containers" | jq -c '.[]' | while read -r container; do
    IMAGE_NAME=$(echo "$container" | jq -r '.ImageName')
    OLLAMA_VERSION=$(echo "$container" | jq -r '.Ollama')
    MODELS=$(echo "$container" | jq -r '.Models[]' | tr '\n' ' ')

    echo "Building image: $IMAGE_NAME with Ollama version $OLLAMA_VERSION and models: $MODELS"

    # Create a temporary Dockerfile
    cat > Dockerfile <<EOF
FROM ollama/ollama:$OLLAMA_VERSION
ARG MODELS="$MODELS"
ENV OLLAMA_KEEP_ALIVE=24h
RUN ollama serve & server=\$! ; sleep 5 ; for m in \$MODELS ; do ollama pull \$m ; done ; kill \$server
EOF

    # Build and push the image
    docker build --cache-from=ghcr.io/$GITHUB_OWNER/$IMAGE_NAME -t ghcr.io/$GITHUB_OWNER/$IMAGE_NAME .
    docker push ghcr.io/$GITHUB_OWNER/$IMAGE_NAME
done
