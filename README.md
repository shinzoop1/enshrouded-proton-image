# Enshrouded Proton image for Pterodactyl

This image keeps the upstream Ptero SteamCMD entrypoint and installs the pinned **GE-Proton 11-9** runtime on Debian 13 (glibc 2.41). The earlier image used the Debian 12-based Proton yolk, which supplied Proton 10-34 and an older glibc.

## Image

```
ghcr.io/shinzoop1/enshrouded-proton-image:latest
```

The GitHub Actions workflow builds and publishes the image after changes to the Dockerfile. The package may need to be made Public under GitHub → Packages so Pterodactyl nodes can pull it without registry credentials.

## Pterodactyl use

1. Stop the server and back up its files before testing.
2. Change only the Docker image to `ghcr.io/shinzoop1/enshrouded-proton-image:latest`.
3. Keep the existing Enshrouded egg, install settings, variables, and startup command for the first test.
4. Start the server and inspect the console for the Steamworks initialization error.

If the image fails to pull or start, switch the image back to `ghcr.io/ptero-eggs/steamcmd:proton`. Do not delete or reinstall the server files to test an image change.

## Important caveat

The image build pins GE-Proton 11-9 and verifies that its Proton launcher exists. This is a compatibility test, not a guarantee that it resolves Enshrouded's `No SteamUtils011` error. Confirm the running version and server logs before treating the issue as resolved.
