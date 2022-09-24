ASDF_SH="$(brew --prefix asdf)/libexec/asdf.sh"
if [ -f $ASDF_SH ]; then
    source $ASDF_SH
fi