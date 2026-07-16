# docker-spoolease-bambustudio

Web-accessible [SpoolEase Custom Bambu Studio](https://github.com/yanshay/SpoolEase-BambuStudio) running in a browser — a self-hosted, containerized slicer with integrated [SpoolEase](https://spoolease.io) filament management.

This image packages [yanshay's SpoolEase fork of Bambu Studio](https://github.com/yanshay/SpoolEase-BambuStudio), built on the [linuxserver/docker-bambustudio](https://github.com/linuxserver/docker-bambustudio) Selkies web-desktop base, with the upstream Bambu Studio build swapped for the SpoolEase fork.

## Access

Served over HTTPS only. After starting the container, open `https://<host-ip>:3001` and accept the self-signed certificate warning.

## Notes

- **Unofficial, community-maintained.** Not affiliated with Bambu Lab. The SpoolEase fork is maintained by [yanshay](https://github.com/yanshay).
- Bambu Studio's beta-update prompt is disabled in this image, so it won't offer to replace the SpoolEase fork with upstream Bambu Studio.
- Behaviour is otherwise identical to the upstream `linuxserver/bambustudio` image.

## Connecting a printer

Bambu Studio discovers printers via mDNS/SSDP broadcast, which does **not** cross Docker's bridge network. To connect a LAN-only printer, add it **manually by IP**:

**Device → "Bind with Access Code"** → enter the printer's IP address + access code (shown on the printer under Settings → LAN Only).

If the printer is on a separate VLAN, ensure the host can route to it. For automatic discovery, run the container with host networking on the printer's subnet.

## Credits

- [SpoolEase](https://spoolease.io) and the [Bambu Studio fork](https://github.com/yanshay/SpoolEase-BambuStudio) by [yanshay](https://github.com/yanshay)
- Base image: [linuxserver/docker-bambustudio](https://github.com/linuxserver/docker-bambustudio)
- [Bambu Studio](https://github.com/bambulab/BambuStudio) by Bambu Lab (AGPL-3.0)

## License

AGPL-3.0, matching upstream Bambu Studio.

## Acknowledgements & disclosure

This container packaging and its CI pipeline were assembled with AI assistance (Claude) — the Dockerfile adaptation, the build workflow, and the configuration tweaks. It is a community packaging effort and is provided as-is; please review before use.

**All credit for the actual application belongs to [yanshay](https://github.com/yanshay)**, who created and maintains the [SpoolEase](https://spoolease.io) project and the [SpoolEase Bambu Studio fork](https://github.com/yanshay/SpoolEase-BambuStudio) that this image runs. This repository only packages that work into a container; it does not modify the slicer itself beyond disabling the upstream beta-update prompt to prevent the fork being overwritten.

If you find SpoolEase useful, support the original project rather than this packaging repo.
