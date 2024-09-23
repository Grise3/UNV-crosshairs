#!/bin/bash

# Chemin vers le fichier de configuration
config_file="server.cfg"

# Fonction pour mettre à jour une ligne avec une explication
update_value() {
    local description="$1"
    local var_name="$2"
    local current_value=$(grep -E "^set $var_name " "$config_file" | awk '{print $3}' | tr -d '"')

    echo -e "\n$description"
    read -p "Valeur actuelle: $current_value. Entrez la nouvelle valeur (ou appuyez sur Entrée pour conserver) : " user_input

    # Si l'utilisateur ne fournit pas de nouvelle valeur, conserver l'ancienne
    if [[ -z "$user_input" ]]; then
        user_input="$current_value"
    fi

    # Modifie la ligne correspondante
    sed -i "s|^set $var_name .*|set $var_name \"$user_input\"|" "$config_file"
    echo "La valeur de '$var_name' a été mise à jour à $user_input."
}

# Fonction pour gérer les sections commentées (comme rcon password)
uncomment_and_update() {
    local description="$1"
    local var_name="$2"

    echo -e "\n$description"
    read -p "Souhaitez-vous définir une valeur pour $var_name ? (oui/non) : " decision

    if [[ "$decision" == "oui" ]]; then
        read -p "Entrez la valeur pour $var_name : " user_input
        sed -i "s|//set $var_name .*|set $var_name \"$user_input\"|" "$config_file"
        echo "La valeur de '$var_name' a été mise à jour à $user_input."
    else
        echo "La ligne '$var_name' est restée commentée."
    fi
}

# Explication des paramètres et mise à jour interactive
echo "=== Mise à jour du fichier server.cfg ==="

update_value "Affichage du serveur. 0 - Public, 1 - Masqué, 2 - Pas de réponses, 3 - Connexions LAN uniquement" "server.private"
update_value "Pour rejoindre le serveur : 0 - Pas de mot de passe requis, 1 - Mot de passe requis pour rejoindre. Le mot de passe sera définit à la fin." "g_needpass"



# RCON Password
uncomment_and_update "Mot de passe RCON pour gérer le serveur à distance. Voci le fonctionnement : l'utilisateur doit faire '/rcon.client.password [mot de passe identique à celui du server] ce qui lui permetera de changer les paramètres du serveur à distance. Exemple : /rcon sv_hostname pour changer le nom du serveur. METTEZ UN MOT DE PASSE FORT'" "rcon.server.password"

update_value "Nom d'affichage du serveur dans la liste publique" "sv_hostname"
update_value "Message du jour pour les joueurs" "g_motd"
update_value "Nombre maximal de clients" "sv_maxclients"
update_value "Durée limite de jeu (0 = pas de limite)" "timelimit"
update_value "Nombre de bots par défaut à remplir" "g_bot_defaultFill"
update_value "Rotation initiale des cartes" "g_initialMapRotation"
update_value "Première carte à charger" "map"

# Si g_needpass est à 1, demander le mot de passe
needpass_value=$(grep -E '^set g_needpass ' "$config_file" | awk '{print $3}')
if [[ "$needpass_value" == "1" ]]; then
    update_value "// Mot de passe pour rejoindre le serveur" "g_password"
fi
echo -e "\n=== Mise à jour du fichier de configuration terminée ==="

