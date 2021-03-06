pkgname=df-lnp-arch


## arg 1 : the source directory
## arg 2 : the backup directory
update() {
    src_directory="$1"
    backup_directory="$2"

        mkdir -p $backup_directory
        for file in $(ls -A "$src_directory"); do
            echo "$src_directory/$file"
            mv  "$src_directory/$file" $backup_directory
        done
        echo "Save $src_directory"

        # New installation
        su $user -c "cp -r /opt/$pkgname/{*,.files_to_save} \"$src_directory\""

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

        file=.files_to_save
        cp -ru $file "$src_directory/$file"
        echo "Restored $file"

        # SoundSense comes preconfigured to expect gamelog.txt to be in ../
        # however this is not the case for the LNP.
        # This modifies the configuration.xml file so users don't get an annoying
        # pop-up on start looking for gamelog.txt.
  
        # substitute "foo" with "bar" ONLY for lines which contain "baz"
        # sed '/baz/s/foo/bar/g'
        # NOTE: Like in ask_for_preferred_install_dir, use custom ; delimeter so as not to
        # screw up sed with file paths.
        
        sed -ibak "/\<gamelog/s;path=\"../gamelog.txt\";path=\"$src_directory/df_linux/gamelog.txt;g" "$src_directory/LNP/utilities/soundsense/configuration.xml" 

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
        sed -i "\;${locations[$i]};d" /etc/$pkgname/${users[$i]}
        echo "Reference to ${locations[$i]} removed"
    done
        


}




post_install() {
    echo "Installation procedure"

    DEFAULT_INSTALL="bin/Dwarf Fortress" # Will hahe a trailing $HOME

    users_valid=false

    # List the existing installations
    for user in $(ls /etc/$pkgname); do
        while read src_directory; do
            echo "$user have already an installation in $src_directory"
        done < /etc/$pkgname/$user
    done

    while [ $users_valid != "true" ]; do
        echo ""
        read -p "For which users install df-lnp ? " users

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
        echo "$INSTALL_DIR" >"/etc/$pkgname/$user"

        if [ ! -d "$INSTALL_DIR/LNP/" ] || [ ! -d "$INSTALL_DIR/df_linux" ]
        then mkdir -p $INSTALL_DIR
            su $user -c "cp -r /opt/df-lnp-arch/{*,.files_to_save} \"$INSTALL_DIR\""

            sed -ibak "/\<gamelog/s;path=\"../gamelog.txt\";path=\"$INSTALL_DIR/df_linux/gamelog.txt;g" "$INSTALL_DIR/LNP/utilities/soundsense/configuration.xml" 
            echo "Dwarf Fortress installed in $INSTALL_DIR"
        else update "$INSTALL_DIR" /tmp/$pkgname-$(date +%s)/$user/backup_1/
        fi

    done

    echo ""
    echo "If you want later to add an other installation of Dwaf Fortress, or remove it, run 'sudo df-lnp-install'"
}

usage() { 
    echo "Usage: df-lnp-installer [OPTIONS]"
    echo ""
    echo "Options:"
    echo "--install  # Install a new installation using the existing package."
    echo "--remove   # Remove an old installation either completely or olny stop the auto update feature."
}

if [ -n $1 ] && [ -z $2 ]
then case "$1" in
    '--install') post_install ;;
    '--remove') remove_installation ;;
    *) usage ;;
    esac
else usage
fi



