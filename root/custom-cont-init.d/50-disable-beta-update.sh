#!/usr/bin/with-contenv bash
CONF_DIR="/config/.config/BambuStudio"
CONF="$CONF_DIR/BambuStudio.conf"

# Pre-seed BEFORE Bambu launches: if no config exists yet, create one with the
# beta flag already false, so the app never shows the beta prompt on first run.
mkdir -p "$CONF_DIR"
if [ ! -f "$CONF" ]; then
  echo '{ "app": { "enable_beta_version_update": "false" } }' > "$CONF"
  chown -R abc:abc "$CONF_DIR"
fi

# Watcher backup: if the app ever rewrites the flag to true, flip it back.
disable_beta() {
  if [ -f "$CONF" ] && [ "$(jq -r '.app.enable_beta_version_update // "false"' "$CONF")" = "true" ]; then
    tmp=$(mktemp)
    jq '.app.enable_beta_version_update = "false"' "$CONF" > "$tmp" && mv "$tmp" "$CONF"
    chown abc:abc "$CONF"
  fi
}
(
  for i in $(seq 1 120); do disable_beta; sleep 1; done
  while true; do disable_beta; sleep 30; done
) &
