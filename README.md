 Overview :
 ==========
 
df-lnp-arch is an installer of the Dwarf Fortress Lazy Newb Pack for the Arch Linux/Manjaro users . It is freely inspired by the [df-lnp-installer](https://github.com/andrewd18/df-lnp-installer).

Installation :
==============

1. Clone the git repository with `git clone https://github.com/ytterbium/df-lnp-arch.git`
2. Go to the cloned directory with `cd df-lnp-arch`
3. Create the package with `makepkg`
4. Install the package with `sudo pacman -U df-lnp-arch-version_of_package.tar.xz`
5. Follow the prompts
6. Once DF is installed, enter the DF folder and run ./startlnp.
7. Start the SoundSense r42 utility from the Utilities tab.
8. Click the "Pack Update" tab.
9. Click "Start Automatic Update".
10. Get a Dwarven Ale; it's going to be a while.
11. Once finished, close SoundSense, and muck about with LNP as normal.

Update :
=======

1. Update your git repository with git pull 
2. Recreate a package with makepkg
3. Install the package with 'sudo pacman -U df-lnp-arch-new_version.tar.xz
