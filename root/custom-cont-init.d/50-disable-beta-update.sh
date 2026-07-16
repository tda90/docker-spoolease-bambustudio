#!/usr/bin/with-contenv bash
   CONF="/config/.config/BambuStudio/BambuStudio.conf"
   (
     while true; do
       if [ -f "$CONF" ] && [ "$(jq -r '.app.enable_beta_version_update // false' "$CONF")" = "true" ]; then
         tmp=$(mktemp)
         jq '.app.enable_beta_version_update = false' "$CONF" > "$tmp" && mv "$tmp" "$CONF"
         chown abc:abc "$CONF"
       fi
       sleep 30
     done
   ) &
