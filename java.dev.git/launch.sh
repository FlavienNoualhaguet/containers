#!/bin/bash

# Nom de l'image et du conteneur
IMAGE_NAME="tracks31/java.dev.git:V1.0"
CONTAINER_NAME=$(docker ps -a --filter "ancestor=tracks31/java.dev.git:V1.0" --format '{{.Names}}')

# Vérifier si le conteneur existe
if [[ ! -z "$CONTAINER_NAME" ]]; then
    echo "Container $CONTAINER_NAME existe"
    # Vérifier son statut
    STATUT=$(docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME")
    if [[ "$STATUT" == "running" ]]; then
        # Le conteneur est déjà en cours d'exécution
        echo "Le conteneur ($CONTAINER_NAME) est déjà en cours d'exécution."
        # Entrer dans le conteneur avec une session bash
        docker exec -it "$CONTAINER_NAME" /bin/bash
    else
        # Le conteneur existe mais n'est pas en cours d'exécution
        echo "Le conteneur existe mais n'est pas en cours d'exécution. Démarrage..."
        docker start "$CONTAINER_NAME"
        # Entrer dans le conteneur avec une session bash
        docker exec -it "$CONTAINER_NAME" /bin/bash
    fi
else
    # Le conteneur n'existe pas
    echo "Le conteneur n'existe pas. Création et démarrage..."
    docker run -it --name "java.dev.git:V1.0" -e DISPLAY=$DISPLAY -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --entrypoint /bin/bash tracks31/java.dev.git:V1.0
fi
