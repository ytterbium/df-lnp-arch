# Maintainer: Your Name <youremail@domain.com>


pkgname=df-lnp-arch
pkgver=0.1
pkgrel=4
pkgdesc="Installer for the Lazy Newby Pack to run Dwarf Fortress"
arch=(x86_64)
url="https://github.com/andrewd18/df-lnp-installer"
license=('GPL3')
groups=()
depends=(gtk2 glu sdl_image libsndfile openal sdl_ttf glew sudo)
# For 64 bits:
depends=(gcc-multilib lib32-gtk2 lib32-glu lib32-sdl_image lib32-libsndfile lib32-openal
        lib32-libxdamage lib32-ncurses lib32-sdl_ttf lib32-glew)
# For the LNP
depends=(lib32-libjpeg-turbo qt5-script) #qt5-script for splintermind attributes
makedepends=(git mercurial)
optdepends=('xterm: A terminal is required to run DFhack. Select it in LNP/lnp.yaml' )
provides=()
conflicts=()
replaces=()
backup=()
options=()
install="$pkgname.install"
changelog=
source=(hg+https://code.google.com/r/splintermind-attributes
        fix_file_path_v2.diff
        lnp.yaml
        df-lnp-installer.sh
        .files_to_save
        https://drone.io/bitbucket.org/Dricus/lazy-newbpack/files/target/lazy-newbpack-linux-0.5.3-SNAPSHOT-20130822-1652.tar.bz2
        http://www.bay12games.com/dwarves/df_34_11_linux.tar.bz2
        git://github.com/svenstaro/dwarf_fortress_unfuck.git
        http://dethware.org/dfhack/download/dfhack-0.34.11-r3-Linux.tar.gz
        http://dffd.wimbli.com/download.php?id=7248\&f=Utility_Plugins_v0.36-Windows-0.34.11.r3.zip.zip
        http://df.zweistein.cz/soundsense/soundSense_42_186.zip
        DwarfTherapist.pdf::http://dffd.wimbli.com/download.php?id=7889\&f=Dwarf+Therapist.pdf)
noextract=()
#md5sums=() #generate with 'makepkg -g'
md5sums=('SKIP'
         '49b0891003ab10722fa5db00edb65740'
         '05ac7bd27418e8c455d78a369f1876ae'
         '001d14ded2e558ae413f64058bb09bc8'
         'df846366ca2388c97d36be51286499f2'
         '7546f2829be94b6ab917743b7ee58a32'
         '33e26a93e5914f7545fa1aaa53706eeb'
         'SKIP'
         '1de4283f17350dd6057a81644cd678f0'
         '6304edcd1321c1a4aa42edb27bdaa7a5'
         'd75f5e44d54ee995cbe5315e75365a53'
         '7ed4306cd12c76d6fd891eeb2ce63e2d')


prepare() {
  cd "$srcdir/splintermind-attributes"
  patch -Np1 < "${srcdir}/fix_file_path_v2.diff"


  # Replace SoundSense shell script with a duplicate that uses Unix line endings.
  cd $srcdir/soundsense
  tr -d '\015' <"soundSense.sh"  >"soundsense_unix.sh"
  mv -f "soundsense_unix.sh" "soundSense.sh"
}
build() {
  cd "$srcdir/splintermind-attributes"
  echo `pwd`
  qmake-qt5 dwarftherapist.pro
  make


  cd "$srcdir/dwarf_fortress_unfuck"
  make
      }
package() {
  install -d "$pkgdir/opt/$pkgname"

  # install lnp
  cd "$srcdir"
  install -Dm755 lazy-newbpack-gui-0.5.3-SNAPSHOT.jar startlnp "$pkgdir/opt/$pkgname/"
  cp -r LNP "$pkgdir/opt/$pkgname/LNP"
  install -m644 lnp.yaml "$pkgdir/opt/$pkgname/LNP/" # Default configuration
  # yaml to save
 
  # install df vanilla

  cp -r $srcdir/df_linux/ "$pkgdir/opt/$pkgname/"
  # Yay for precompiled stuff with junk permissions! :D
  find "$pkgdir/opt/$pkgname/df_linux" -type d -exec chmod 755 {} +
  find "$pkgdir/opt/$pkgname/df_linux" -type f -exec chmod 644 {} +
  chmod 755 "$pkgdir/opt/$pkgname/df_linux/df"
  chmod 755 "$pkgdir/opt/$pkgname/df_linux/libs/Dwarf_Fortress"
  
  # unfunck graphic.so
  install -Dm755 $srcdir/dwarf_fortress_unfuck/libs/libgraphics.so \
    "$pkgdir/opt/$pkgname/df_linux/libs/libgraphics.so"

  ln -s /usr/lib32/libpng.so "$pkgdir/opt/$pkgname/df_linux/libs/libpng.so.3"
  rm "$pkgdir/opt/$pkgname/df_linux/libs/"{libgcc_s.so.1,libstdc++.so.6}

  # install dfhack 
  cd "$srcdir"
  cp -r stonesense hack "$pkgdir/opt/$pkgname/df_linux" # dfusion ?
  install -Dm644 dfhack.init-example "$pkgdir/opt/$pkgname/df_linux"
  install -Dm755 dfhack dfhack-run "$pkgdir/opt/$pkgname/df_linux"

  # install falconne_dfhack_plugins
  cd "$srcdir/Linux" 
  install -Dm644 * "$pkgdir/opt/$pkgname/df_linux/hack/plugins/"

  cd $srcdir/soundsense
  # Replace SoundSense shell script with a duplicate that uses Unix line endings.
  # sed didn't work for some reason; using tr. :/
  tr -d '\015' <"soundSense.sh" >"soundsense_unix.sh"
  mv -f soundsense_unix.sh soundSense.sh

  # Make soundSense shell script executable.
  chmod +x "soundSense.sh"
  # install soundsense
  cp -r $srcdir/soundsense/ "$pkgdir/opt/$pkgname/LNP/utilities"

  # install dwarftherapist
  install -d "$pkgdir/opt/$pkgname/LNP/utilities/dwarf_therapist"
  cd "$srcdir/splintermind-attributes"
  install -Dm755 bin/release/DwarfTherapist "${pkgdir}/opt/$pkgname/LNP/utilities/dwarf_therapist/"
  # install its config file
  cp -r "etc/" "$pkgdir/opt/$pkgname/LNP/utilities/dwarf_therapist/"

  install -d "$pkgdir/etc/$pkgname" # Where to save users  configuration
  install -Dm744 $srcdir/df-lnp-installer.sh "$pkgdir/bin/df-lnp-installer"

  install -Dm644 "$srcdir/.files_to_save" "$pkgdir/opt/$pkgname" # Where to put the flies to save. One for each installation

  install -Dm644 "$srcdir/DwarfTherapist.pdf" "$pkgdir/opt/$pkgname/" # A guide to Dwarf Therapist
    }
