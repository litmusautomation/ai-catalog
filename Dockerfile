ARG OLLAMA_VERSION=latest
FROM ollama/ollama:$OLLAMA_VERSION
ENV OLLAMA_KEEP_ALIVE=24h
ARG MODELS
RUN echo "MODELS LIST:"$MODELS
RUN ollama serve & server=$! ; sleep 5 ; for m in $(echo "$MODELS"); do echo "Pulling $m"; ollama pull "$m"; done ; kill $server
