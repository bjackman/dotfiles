# -e is little-endian
# -g 4 is group into words

xxd -e -g 4 $*
