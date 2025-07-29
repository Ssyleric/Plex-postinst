#!/bin/bash

PATCHED="/root/plexmediaserver.postinst.patched"
TARGET="/var/lib/dpkg/info/plexmediaserver.postinst"

echo "🔍 Vérification des fichiers..."
if [ ! -f "$PATCHED" ]; then
  echo "❌ Patch introuvable : $PATCHED"
  exit 1
fi

echo "🩹 Restauration du script postinst corrigé..."
cp "$PATCHED" "$TARGET"
chmod 755 "$TARGET"

echo "🚀 Reconfiguration du paquet plexmediaserver..."
dpkg --configure plexmediaserver

echo "✅ Script postinst restauré et Plex reconfiguré."
root@plex:/# 
