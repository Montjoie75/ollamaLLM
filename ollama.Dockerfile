# Base sur l'image officielle d'Ollama.
ARG OLLAMA_VERSION=latest
FROM ollama/ollama:${OLLAMA_VERSION}

# --- AJOUTEZ CES LIGNES POUR INSTALLER curl ---
# Update les paquets et installe curl
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*
# --- FIN DE L'AJOUT ---

# Copier le script d'initialisation dans le conteneur.
COPY init_models.sh /usr/local/bin/init_models.sh

# Rendre le script exécutable.
RUN chmod +x /usr/local/bin/init_models.sh

# Définir le point d'entrée du conteneur pour exécuter notre script.
ENTRYPOINT ["/usr/local/bin/init_models.sh"]

# La commande par défaut qui sera passée à notre ENTRYPOINT si aucune autre n'est spécifiée.
CMD ["ollama", "serve"]