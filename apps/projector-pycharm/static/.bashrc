
source "$PROJECTOR_DIR/log_line.sh"

export REQUESTS_CA_BUNDLE='/etc/ssl/certs/ca-certificates.crt'
export SSL_CERT_FILE='/etc/ssl/certs/ca-certificates.crt'

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

# just going to assume if kubecolor is installed then kubectl is too
if [ -x "$(command -v kubecolor)" ]; then
    alias kubectl="kubecolor"
    alias k="kubecolor"
    source <(kubectl completion bash)
    complete -o default -F __start_kubectl kubecolor
    complete -o default -F __start_kubectl k
fi
