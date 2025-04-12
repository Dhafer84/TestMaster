#!/bin/bash

set -e

JENKINS_URL=${JENKINS_URL:-"http://192.168.56.1:9090"}  # IP de la machine Jenkins
AGENT_NAME=${AGENT_NAME:-"agent-$(hostname)"}
SECRET=${SECRET:-"<TON_SECRET_ICI>"}
DOCKER_IMAGE=${DOCKER_IMAGE:-"jenkins/inbound-agent"}

echo "[INFO] Lancement du setup de l'agent Jenkins : $AGENT_NAME"

# Installer Docker si nécessaire
if ! command -v docker &> /dev/null; then
    echo "[INFO] Docker n'est pas installé. Installation..."
    curl -fsSL https://get.docker.com | sh
fi

# Supprimer conteneur existant
docker rm -f $AGENT_NAME 2>/dev/null || true

# Lancer le conteneur
docker run -d \
  --name $AGENT_NAME \
  --restart unless-stopped \
  -e JENKINS_URL=$JENKINS_URL \
  -e JENKINS_AGENT_NAME=$AGENT_NAME \
  -e JENKINS_SECRET=$SECRET \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /dev:/dev \
  --device /dev/ttyUSB0 \
  $DOCKER_IMAGE
