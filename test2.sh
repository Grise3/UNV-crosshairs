cd tmp/UnvanquishedServer
config_file="config/server.cfg"

# Affiche les options disponibles
echo "Choisissez une option pour 'set server.private':"
echo "0 - Advertise everything"
echo "1 - Don't advertise but reply to status queries"
echo "2 - Don't reply to status queries but accept connections"
echo "3 - Only accept LAN connections"

# Demande à l'utilisateur de saisir une valeur
read -p "Entrez la valeur (0-3) : " user_input

# Vérifie si l'entrée est valide
if [[ "$user_input" =~ ^[0-3]$ ]]; then
    # Modifie la ligne correspondante dans le fichier de configuration
    sed -i "s/^set server.private .*/set server.private $user_input/" "$config_file"
    echo "La valeur de 'set server.private' a été mise à jour à $user_input."
else
    echo "Entrée invalide. Veuillez entrer un nombre entre 0 et 3."
fi



echo "Choisissez une option pour 'set g_needpass':"
echo "0 - Le serveur peut être rejoint sans mot de passe"
echo "1 - Exiger un mot de passe (voir g_password ci-dessous)"

# Demande à l'utilisateur de saisir une valeur
read -p "Entrez la valeur (0 ou 1) : " user_input

# Vérifie si l'entrée est valide
if [[ "$user_input" =~ ^[01]$ ]]; then
    # Modifie la ligne correspondante dans le fichier de configuration
    sed -i "s/^set g_needpass .*/set g_needpass $user_input/" "$config_file"
    echo "La valeur de 'set g_needpass' a été mise à jour à $user_input."
else
    echo "Entrée invalide. Veuillez entrer 0 ou 1."
fi




