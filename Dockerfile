FROM ollama/ollama:$OLLAMA_VERSION
ARG MODELS="$MODELS"
ENV OLLAMA_KEEP_ALIVE=24h
RUN ollama serve & server=\$! ; sleep 5 ; for m in \$MODELS ; do ollama pull \$m ; done ; kill \$server