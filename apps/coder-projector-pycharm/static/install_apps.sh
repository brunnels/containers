#!/bin/bash

set -o pipefail
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/bash-completion/completions"

echo "installing sops..."
URL="$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | \
    jq -r '.assets[] | select(.name | test(".linux.amd64")) | select(.content_type == "application/octet-stream") | .browser_download_url')" \
 && curl -fsSL "$URL" -o sops \
 && mv sops "$HOME/.local/bin/sops" \
 && chmod 755 "$HOME/.local/bin/sops" \
 && "$HOME/.local/bin/sops" --version \
 && curl -s https://gitlab.archlinux.org/archlinux/packaging/packages/sops/-/raw/main/bash_autocomplete?ref_type=heads -o "$HOME/.local/share/bash-completion/completions/sops" \
 && echo ""

echo "installing helm..."
curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | USE_SUDO="false" HELM_INSTALL_DIR="$HOME/.local/bin/" bash \
 && chmod 755 "$HOME/.local/bin/helm" \
 && "$HOME/.local/bin/helm" version \
 && "$HOME/.local/bin/helm" completion bash > "$HOME/.local/share/bash-completion/completions/helm" \
 && echo ""

echo "installing kubectl..."
curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
 && mv kubectl "$HOME/.local/bin/kubectl" \
 && chmod 755 "$HOME/.local/bin/kubectl" \
 && "$HOME/.local/bin/kubectl" version --client \
 && "$HOME/.local/bin/kubectl" completion bash > "$HOME/.local/share/bash-completion/completions/kubectl" \
 && echo ""

echo "installing kubecolor..."
curl -fsSL "https://i.jpillora.com/kubecolor/kubecolor?as=kubecolor&type=script" | bash \
 && mv kubecolor $HOME/.local/bin/kubecolor \
 && chmod 755 $HOME/.local/bin/kubecolor \
 && printf "kubecolor version " && "$HOME/.local/bin/kubecolor" --kubecolor-version \
 && echo ""

echo "installing go task..."
curl -fsSL "https://i.jpillora.com/go-task/task?as=task&type=script" | bash \
 && mv task "$HOME/.local/bin/task" \
 && chmod 755 "$HOME/.local/bin/task" \
 && "$HOME/.local/bin/task" --version \
 && "$HOME/.local/bin/task" --completion bash > "$HOME/.local/share/bash-completion/completions/task" \
 && echo ""

add_line_if_not_exists() {
  local file="$1"
  local line="$2"

  if ! grep -qF -- "$line" "$file"; then
    echo "$line" >> "$file"
  fi
}

echo "installing direnv..."
curl -fsSL "https://i.jpillora.com/direnv/direnv?as=direnv&type=script" | bash \
 && mv direnv "$HOME/.local/bin/direnv" \
 && chmod 755 "$HOME/.local/bin/task" \
 && printf "direnv version " && "$HOME/.local/bin/direnv" --version \
 && echo "" \
 && add_line_if_not_exists "$HOME/.bashrc" 'eval "$(~/.local/bin/direnv hook bash)"'

echo "installing mise..."
curl -s https://mise.run | sh \
 && mise completion bash > "$HOME/.local/share/bash-completion/completions/mise" \
 && echo "" \
 && add_line_if_not_exists "$HOME/.bashrc" 'eval "$(~/.local/bin/mise activate bash)"'
