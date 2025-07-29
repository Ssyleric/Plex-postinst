# 📘 README — Sauvegarde et restauration du script Plex `postinst` corrigé

## 📂️ Objectif

Ce fichier décrit :

* ✅ Comment **sauvegarder** le script corrigé (`postinst`) de `plexmediaserver`
* ♻️ Comment le **restaurer automatiquement** si Plex est à nouveau cassé après un `apt upgrade`

### ⚠️ Pourquoi Plex est cassé ?

Le paquet `.deb` officiel de Plex comporte un script `postinst` mal conçu :

* Il fait des comparaisons `-eq`, `-gt`, `=` sur des variables non initialisées
* Il échoue silencieusement avec des erreurs comme `[: -eq: unary operator expected]` ou `usermod: user '' does not exist`
* Il termine par `exit 255` même après une installation réussie

Ce README documente le correctif appliqué pour rendre l’installation fonctionnelle malgré ces défauts.

---

## ✅ 1. Sauvegarde du script `postinst` corrigé

Après avoir patché et validé l'installation de Plex, il est **essentiel de sauvegarder la version fonctionnelle du script** :

```bash
cp /var/lib/dpkg/info/plexmediaserver.postinst /root/plexmediaserver.postinst.patched
```

Ce fichier servira de référence propre pour toutes restaurations futures.

---

## 🛠️ 2. Script de restauration automatique

Un script est placé dans :

```bash
/home/scripts/repatch-plex.sh
```

Ce script permet de **restaurer automatiquement le script corrigé** et de relancer la configuration de Plex.

### 📄 Contenu du script

```bash
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
```

### ✅ Rendre le script exécutable

```bash
chmod +x /home/scripts/repatch-plex.sh
```

---

## ♻️ 3. En cas de mise à jour future cassée

Si `apt upgrade` brise de nouveau Plex (`exit 255`, erreurs de script, etc.) :

```bash
bash /home/scripts/repatch-plex.sh
```

Cela restaure immédiatement un `plexmediaserver` fonctionnel sans perte de données ni réinstallation.

---

## 🔒 4. Protection recommandée

Pour éviter qu’APT ne casse à nouveau Plex automatiquement :

```bash
apt-mark hold plexmediaserver
```

---

## 📦 Fichiers en jeu

| Fichier                                       | Rôle                                                         |
| --------------------------------------------- | ------------------------------------------------------------ |
| `/var/lib/dpkg/info/plexmediaserver.postinst` | Script original utilisé à chaque installation ou mise à jour |
| `/root/plexmediaserver.postinst.patched`      | Version corrigée et fonctionnelle                            |
| `/home/scripts/repatch-plex.sh`               | Script de restauration automatique                           |

---
