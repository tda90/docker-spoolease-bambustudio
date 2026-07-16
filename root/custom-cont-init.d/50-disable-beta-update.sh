#!/usr/bin/with-contenv bash
CONF="/config/.config/BambuStudio/BambuStudio.conf"

disable_beta() {
  if [ -f "$CONF" ] && [ "$(jq -r '.app.enable_beta_version_update // false' "$CONF")" = "true" ]; then
    tmp=$(mktemp)
    jq '.app.enable_beta_version_update = false' "$CONF" > "$tmp" && mv "$tmp" "$CONF"
    chown abc:abc "$CONF"
  fi
}

(
  # Aggressive for the first ~2 minutes to catch the first-run config write fast,
  # then relax to a light background check.
  for i in $(seq 1 120); do
    disable_beta
    sleep 1
  done
  while true; do
    disable_beta
    sleep 30
  done
) &
