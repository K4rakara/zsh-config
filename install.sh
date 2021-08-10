#!/bin/zsh

cat ./.zprofile \
  | sed 's/\$BLOAT_DIR/'"${BLOAT_DIR}"'/' \
  > "${ZPROFILE}";

cat ./.zshrc \
  | sed 's/\$BLOAT_DIR/'"${BLOAT_DIR}"'/' \
  > "${ZSHRC}";

mkdir -p "${BLOAT_DIR}";

cp -r ./bloat "${BLOAT_DIR}";

chmod a+x ${BLOAT_DIR}/*;

