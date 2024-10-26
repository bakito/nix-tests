FROM ubuntu

COPY setup-*.sh /tmp
COPY --chown=bakito:bakito home.nix /tmp/home.nix