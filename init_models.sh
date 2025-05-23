#!/bin/bash

# --- Démarrer le serveur Ollama en arrière-plan ---
# La commande par défaut de l'image ollama est "ollama serve".
# Nous la lançons en arrière-plan (`&`) pour qu'elle ne bloque pas l'exécution du script.
# On utilise `exec "$@"` à la fin pour s'assurer que `ollama serve`
# devient le PID 1 du conteneur et gère correctement les signaux (SIGTERM, etc.).

# Lancer ollama serve en arrière-plan
echo "Démarrage du serveur Ollama en arrière-plan..."
/usr/bin/ollama serve &
OLLAMA_PID=$! # Garde l'ID du processus Ollama

# --- Attendre que le serveur Ollama soit prêt ---
# C'est crucial pour s'assurer que l'API est accessible avant de tenter de télécharger des modèles.
echo "Attente de la disponibilité du serveur Ollama..."
until curl --output /dev/null --silent --head --fail http://localhost:11434; do
  echo -n "."
  sleep 1
done
echo "\nServeur Ollama prêt."

# --- Télécharger les modèles si nécessaire (idempotent) ---
# Vous pouvez lister les modèles que vous voulez ici.
# La boucle vérifie si chaque modèle est déjà présent avant de le télécharger.
MODELS_TO_PULL=("deepseek-r1:1.5b") # Ajoutez/modifiez vos modèles ici

for model in "${MODELS_TO_PULL[@]}"; do
  if ! ollama list | grep -q "$model"; then
    echo "Téléchargement du modèle $model..."
    ollama pull "$model" || echo "AVERTISSEMENT : Échec du téléchargement du modèle $model. Le conteneur continuera."
  else
    echo "Le modèle $model est déjà présent (pas besoin de le télécharger)."
  fi
done

echo "Initialisation des modèles terminée."

# --- Attendre que le processus Ollama principal se termine (ce qu'il ne fera pas, sauf si erreur) ---
# Cela s'assure que le script attend la fin du processus Ollama lancé en arrière-plan.
# En pratique, `ollama serve` tourne indéfiniment, donc ce script maintiendra le conteneur actif.
wait $OLLAMA_PID