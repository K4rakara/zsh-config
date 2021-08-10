source <(\
    cat ~/.config/user-dirs.dirs \
  | sed 's/^/export /' \
  | sed 's/$/;/' \
);

export CARGO_HOME="${HOME}/.opt/cargo";
export EDITOR="nvim";
export PATH="${HOME}/.local/bin:${PATH}";
export RUSTUP_HOME="${HOME}/.opt/rustup";

[[ -e "${HOME}/.env" ]] && source "${HOME}/.env";

[[ -z "${SKIP_LOGIN_PROMPT}" ]] && source $BLOAT_DIR/login.sh;

