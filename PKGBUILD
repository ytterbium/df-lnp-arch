# Maintainer: Your Name <youremail@domain.com>

_installation="home/$USER/bin/Dwarf Fortress" # Don't put a trailing slash !

pkgname=df-lnp-installer
pkgver=0.3.1
pkgrel=1
pkgdesc="Installer for the Lazy Newby Pack to run Dwarf Fortress"
arch=(x86_64)
url="https://github.com/andrewd18/df-lnp-installer"
license=('GPL3')
groups=()
depends=(gtk2 glu sdl_image libsndfile openal sdl_ttf glew)
# For 64 bits:
depends=(gcc-multilib lib32-gtk2 lib32-glu lib32-sdl_image lib32-libsndfile lib32-openal
        lib32-libxdamage lib32-ncurses lib32-sdl_ttf lib32-glew)
# For the LNP
depends=(xterm lib32-libjpeg-turbo qt4) #qt5-script for splintermind attributes
makedepends=(git mercurial)
optdepends=()
provides=()
conflicts=()
replaces=()
backup=()
options=()
install="$pkgname.install"
changelog=
source=(hg+https://code.google.com/r/dwarftherapist
        fix_file_path.diff
        https://drone.io/bitbucket.org/Dricus/lazy-newbpack/files/target/lazy-newbpack-linux-0.5.3-SNAPSHOT-20130822-1652.tar.bz2
        http://www.bay12games.com/dwarves/df_34_11_linux.tar.bz2
        git://github.com/svenstaro/dwarf_fortress_unfuck.git
        http://dethware.org/dfhack/download/dfhack-0.34.11-r3-Linux.tar.gz
        http://dffd.wimbli.com/download.php?id=7248\&f=Utility_Plugins_v0.36-Windows-0.34.11.r3.zip.zip
        http://df.zweistein.cz/soundsense/soundSense_42_186.zip)
noextract=()
#md5sums=() #generate with 'makepkg -g'
md5sums=('SKIP'
         'e5109f6cadbd19865f72a8ad86279d92'
         '7546f2829be94b6ab917743b7ee58a32'
         '33e26a93e5914f7545fa1aaa53706eeb'
         'SKIP'
         '1de4283f17350dd6057a81644cd678f0'
         '6304edcd1321c1a4aa42edb27bdaa7a5'
         'd75f5e44d54ee995cbe5315e75365a53')


prepare() {
  cd "$srcdir/dwarftherapist"
  patch -Np0 < "${srcdir}/fix_file_path.diff"


  # Replace SoundSense shell script with a duplicate that uses Unix line endings.
  cd $srcdir/soundsense
  tr -d '\015' <"soundSense.sh"  >"soundsense_unix.sh"
  mv -f "soundsense_unix.sh" "soundSense.sh"
}
build() {
  cd "$srcdir/dwarftherapist"
  echo `pwd`
  qmake-qt4 dwarftherapist.pro
  #make


  cd "$srcdir/dwarf_fortress_unfuck"
  make
      }
package() {
  install -d "$pkgdir/$_installation"

  # install lnp
  cd "$srcdir"
  install -Dm755 lazy-newbpack-gui-0.5.3-SNAPSHOT.jar startlnp "$pkgdir/$_installation/"
  cp -r LNP "$pkgdir/$_installation/LNP"
  # yaml to save
 
  # install df vanilla

  cp -r $srcdir/df_linux/ "$pkgdir/$_installation/"
  # Yay for precompiled stuff with junk permissions! :D
  find "$pkgdir/$_installation/df_linux" -type d -exec chmod 755 {} +
  find "$pkgdir/$_installation/df_linux" -type f -exec chmod 644 {} +
  chmod 755 "$pkgdir/$_installation/df_linux/df"
  chmod 755 "$pkgdir/$_installation/df_linux/libs/Dwarf_Fortress"
  
  # unfunck graphic.so
  install -Dm755 $srcdir/dwarf_fortress_unfuck/libs/libgraphics.so \
    "$pkgdir/$_installation/df_linux/libs/libgraphics.so"

  ln -s /usr/lib32/libpng.so "$pkgdir/$_installation/df_linux/libs/libpng.so.3"
  rm "$pkgdir/$_installation/df_linux/libs/"{libgcc_s.so.1,libstdc++.so.6}

  # install dfhack 
  cd "$srcdir"
  cp -r stonesense hack "$pkgdir/$_installation/df_linux" # dfusion ?
  install -Dm755 dfhack.init-example "$pkgdir/$_installation/df_linux"
  install -Dm644 dfhack dfhack-run "$pkgdir/$_installation/df_linux"

  # install falconne_dfhack_plugins
  cd "$srcdir/Linux" 
  install -Dm644 * "$pkgdir/$_installation/df_linux/hack/plugins/"

  cd $srcdir/soundsense
  # Make soundSense shell script executable.
  chmod +x "soundSense.sh"
  # install soundsense
  cp -r $srcdir/soundsense/ "$pkgdir/$_installation/LNP/utilities"

  
  install -d "$pkgdir/$_installation/LNP/utilities/dwarf_therapist"
  cd "$srcdir/dwarftherapist"
  #install -Dm755 bin/release/DwarfTherapist "${pkgdir}/$_installation/LNP/utilities/dwarf_therapist/"
    }
