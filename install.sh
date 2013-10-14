DEFAULT_INSTALL="bin/Dwarf Fortress3" # Will hahe a trailing $HOME
users_valid=false
while [ $users_valid != "true" ]; do
    echo ''
    echo  "For which users install df-lnp ? "

    read users

    # Chek if every user is valid
    users_valid=true
    for user in $users; do
        if [ ! -d "/home/$user" ]
        then users_valid=false
            echo "$user is not a valid user"
        fi
    done
done
echo -n ""
# Determine where should we install df
for user in $users; do
    INSTALL_DIR="/home/$user/$DEFAULT_INSTALL"

    echo -n "For $user, where should Dwarf Fortress be installed? [$INSTALL_DIR]: "
    read PREFERRED_DIR
    
    # If the user entered a preferred directory, use that,
    # otherwise use the install directory.
    if [ -n "$PREFERRED_DIR" ]; then
    # Use sed and custom ; delimeter to replace the first instance of ~ with the user's home directory.
        INSTALL_DIR=$(echo "$PREFERRED_DIR" | sed "s;~;$HOME;")
    fi

    su $user -c "cp -rn /opt/df-lnp-arch/ \"$INSTALL_DIR\""

done

