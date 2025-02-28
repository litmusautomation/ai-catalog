ARG OLLAMA_VERSION=latest
ARG MODELS
FROM ollama/ollama:$OLLAMA_VERSION
ENV OLLAMA_KEEP_ALIVE=24h
RUN ollama serve & server=$!
RUN sleep 5 ; for m in $MODELS ; do ollama pull $m ; done ; kill $server