pkgname=df-lnp-arch


## arg 1 : the source directory
## arg 2 : the backup directory
update() {
    src_directory=$1
    backup_directory=$2

        mkdir -p $backup_directory
        mv "$src_directory" $backup_directory
        echo "Save $src_directory"

        # New installation
        su $user -c "cp -rn /opt/$pkgname/ \"$src_directory\""

        echo "Fresh installation in $src_directory"

        # Restore save
        cd $backup_directory
        source .files_to_save # list of files

        for file in $FILES_TO_SAVE; do
            if [ -e $file ]
            then cp -ru $file "$src_directory/$file"
                echo "Restored $file"
            else echo "$file doesn't exist"
            fi
        done
}

# remove a df installation
# Serve only in install script
remove_installation() {
    echo ""
    let "a=0"

    for user in $(ls /etc/$pkgname); do
        while read src_directory; do
            if [ "$src_directory" ] # If the line is not empty
            then let "a+=1"
                locations[$a]=$src_directory
                users[$a]=$user

                echo "[$a] $src_directory"
            fi
        done < /etc/$pkgname/$user
    done

    echo -n "Number(s) of installation to remove : "
    read to_rm

    for i in $to_rm; do
        echo  "For ${locations[$i]}, do you want to remove all your installation ? (Else, remove only the autoupdate function)"
        echo -n "([yes]/no) "
        read rm 
        if [ $rm='no' ]
        then rm -r "${locations[$i]}"
            echo "${locations[$i]} removed"
        fi
        sed -i "/$(echo ${locations[$i]} | sed -e 's/[\/&]/\\&/g')/d" /etc/$pkgname/${users[$i]}
        echo "Reference to ${locations[$i]} removed"
    done
        


}




post_install() {
    echo "Installation procedure"

    DEFAULT_INSTALL="bin/Dwarf Fortress3" # Will hahe a trailing $HOME

    users_valid=false

    # List the existing installations
    for user in $(ls /etc/$pkgname); do
        while read src_directory; do
            echo "$user have already an installation in $src_directory"
        done < /etc/$pkgname/$user
    done

    while [ $users_valid != "true" ]; do
        echo ''
        echo -n "For which users install df-lnp ? "

        read users

        # Chek if every user is valid
        # Maybe TODO a better check up
        users_valid=true
        for user in $users; do
            if [ ! -d "/home/$user" ]
            then users_valid=false
                echo "$user is not a valid user"
            else echo "$user is a valid user"
            fi
        done
    done

    # Determine where should we install df
    for user in $users; do
        INSTALL_DIR="/home/$user/$DEFAULT_INSTALL"
        echo ""

        echo "For $user, where should Dwarf Fortress be installed? [$INSTALL_DIR]: "
        read PREFERRED_DIR
        
        # If the user entered a preferred directory, use that,
        # otherwise use the install directory.
        if [ -n "$PREFERRED_DIR" ]; then
        # Use sed and custom ; delimeter to replace the first instance of ~ with the user's home directory.
            INSTALL_DIR=$(echo "$PREFERRED_DIR" | sed "s;~;/home/$user;")
        fi

        # Save the preference
        echo "'$INSTALL_DIR'" >"/etc/$pkgname/$user"

        if [ ! -d "$INSTALL_DIR/LNP/" ] || [ ! -d "$INSTALL_DIR/df_linux" ]
            then su $user -c "cp -r /opt/df-lnp-arch/ \"$INSTALL_DIR\""
            echo "Dwarf Fortress installed in $INSTALL_DIR"
        else update "$INSTALL_DIR" /tmp/$pkgname-$(date +%s)/$user/backup_1/
        fi

    done

    echo ""
    echo "If you want later to add an other installation of Dwaf Fortress, run 'sudo df-lnp-install'"
}

usage() { 
    echo "Usage: df-lnp-installer [OPTIONS]"
    echo ""
    echo "Options:"
    echo "--install  # Install a new installation using the existing package."
    echo "--remove   # Remove an old installation either completely or olny stop the auto update feature."

if [ -n $1 ] && [ -z $2 ]
then case "$1" in
    '--install') post_install ;;
    '--remove') remove_installation ;;
    *) usage ;;
    esac
else usage
fi



