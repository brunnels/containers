mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/lib"

export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"

if [ ! -f "$HOME/.inputrc" ] ; then
    echo '$include /etc/inputrc' > "$HOME/.inputrc"
    echo '"\e[A": history-substring-search-backward' >> "$HOME/.inputrc"
    echo '"\e[B": history-substring-search-forward' >> "$HOME/.inputrc"
    echo 'set show-all-if-ambiguous on' >> "$HOME/.inputrc"
    echo 'set completion-ignore-case on' >> "$HOME/.inputrc"
fi
