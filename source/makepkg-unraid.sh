#!/bin/bash
PLUGIN_NAME="rcon"
BASE_DIR="/usr/local/emhttp/plugins"
TMP_DIR="/tmp/${PLUGIN_NAME}_"$(echo $RANDOM)""
VERSION="$(date +'%Y.%m.%d')"
RCON_VERSION="$(wget -qO- https://api.github.com/repos/gorcon/rcon-cli/releases/latest | grep tag_name | cut -d '"' -f4 | cut -d 'v' -f2)"

mkdir -p $TMP_DIR/$VERSION/usr/bin
cd $TMP_DIR/$VERSION
cp --parents -R $BASE_DIR/$PLUGIN_NAME/ $TMP_DIR/$VERSION/
wget -q -O $TMP_DIR/rcon.tar.gz https://github.com/gorcon/rcon-cli/releases/download/v${RCON_VERSION}/rcon-${RCON_VERSION}-amd64_linux.tar.gz
tar -C $TMP_DIR --strip-components=1 -xvf $TMP_DIR/rcon.tar.gz
cp $TMP_DIR/rcon $TMP_DIR/$VERSION/usr/bin/rcon
rm -f $(ls $TMP_DIR/* 2>/dev/null|grep -v "$VERSION")
chmod -R 755 $TMP_DIR/$VERSION/
rm $TMP_DIR/$VERSION/$BASE_DIR/$PLUGIN_NAME/README.md
makepkg -l y -c y $TMP_DIR/${PLUGIN_NAME}-$VERSION.txz
md5sum $TMP_DIR/${PLUGIN_NAME}-$VERSION.txz | awk '{print $1}' > $TMP_DIR/${PLUGIN_NAME}-$VERSION.txz.md5
rm -R $TMP_DIR/$VERSION/
chmod 755 $TMP_DIR/*