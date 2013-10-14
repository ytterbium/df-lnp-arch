users_valid=false
while [ $users_valid != "true" ]; do
    echo ''
    echo -n "For which users install df-lnp ? "

    read users

    # Chek if every user is valid
    users_valid=true
    for user in $users; do
        if [ ! -d "/home/$user" ]
        then users_valid=false
        fi
    done
done

