mkdir tmp
cd tmp
wget --content-disposition https://unvanquished.net/download/zip
for f in [uU]nvanquished*; do
    mv "$f" "UnvanquishedServer.zip"
done

unzip UnvanquishedServer.zip
rm -r UnvanquishedServer.zip
for f in [uU]nvanquished*; do
    mv "$f" "UnvanquishedServer"
done
cd UnvanquishedServer


arch=$(uname -m)

case "$arch" in
    x86_64)
        unzip linux-amd64.zip
        ;;
    aarch64)
        unzip linux-arch64.zip
        ;;
    armhf)
        unzip linux-armhf.zip
        ;;
    i686)
        unzip linux-i686.zip
        ;;
    *)
        echo "Architecture non supportée : $arch"
        ;;
esac

rm -r linux-amd64.zip
rm -r linux-arch64.zip
rm -r linux-armhf.zip
rm -r linux-i686.zip
rm -r macos-amd64.zip
rm -r windows-amd64.zip
rm -r windows-i686.zip
rm -r linux-arm64.zip
echo =========== dir content ===========
ls
echo =========== end dir content ===========
mkdir config
mkdir game
cd game
wget --content-disposition https://raw.githubusercontent.com/Unvanquished/Unvanquished/refs/heads/master/dist/configs/game/admin.dat
wget --content-disposition https://raw.githubusercontent.com/Unvanquished/Unvanquished/refs/heads/master/dist/configs/game/maprotation.cfg
cd ../
mkdir config
cd config
wget --content-disposition https://raw.githubusercontent.com/Unvanquished/Unvanquished/refs/heads/master/dist/configs/config/server.cfg
mkdir map
cd map
wget --content-disposition https://raw.githubusercontent.com/Unvanquished/Unvanquished/refs/heads/master/dist/configs/config/map/default.cfg
cd ../..

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

clear

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

clear
# Vérifie la valeur de g_needpass
needpass_value=$(grep -E '^set g_needpass ' "$config_file" | awk '{print $3}')

if [[ "$needpass_value" == "1" ]]; then
    echo "Le serveur nécessite un mot de passe pour rejoindre."

    # Demande le mot de passe
    read -p "Entrez le mot de passe pour rejoindre le serveur : " user_input

    # Modifie la ligne correspondante pour g_password
    sed -i "s|//set g_password .*|set g_password \"$user_input\"|" "$config_file"

    echo "Le mot de passe pour rejoindre le serveur a été mis à jour."
else
    echo "Le serveur ne nécessite pas de mot de passe pour rejoindre."
fi

clear

# Demande si l'utilisateur veut mettre un mot de passe pour RCON
read -p "Voulez-vous définir un mot de passe pour le RCON ? (oui/non) : " rcon_choice

if [[ "$rcon_choice" == "oui" ]]; then
    read -p "Entrez le mot de passe RCON : " rcon_password
    # Modifie la ligne correspondante pour rcon.server.password
    sed -i "s|//set rcon.server.password .*|set rcon.server.password \"$rcon_password\"|" "$config_file"

    echo "Le mot de passe RCON a été mis à jour."
else
    echo "Aucun mot de passe RCON n'a été défini."
fi

clear


