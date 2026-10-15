# Enshrouded Proton image for Pterodactyl

This repository builds a custom image based on `ghcr.io/ptero-eggs/steamcmd:proton` and installs GE-Proton 11-9. It is intended as a test of the reported Enshrouded Steamworks initialization issue (`No SteamUtils011` / `Failed to create Steamworks`) after the Enshrouded 1.0 update.

## Image

After the GitHub Actions workflow completes successfully, the image should be available at:

```
ghcr.io/shinzoop1/enshrouded-proton-image:latest
```

The first package may need its visibility set to Public under GitHub → Packages so Pterodactyl nodes can pull it without registry credentials.

## Pterodactyl use

1. Stop the server and make a backup before testing.
2. Change only the Docker image to `ghcr.io/shinzoop1/enshrouded-proton-image:latest`.
3. Keep the existing Enshrouded egg, install settings, variables, and startup command for this first test.
4. Start the server and inspect the console for the Steamworks error.

If the image fails to pull or start, switch the image back to `ghcr.io/ptero-eggs/steamcmd:proton`. Do not delete or reinstall the server files to test an image change.

## Important caveat

This is a proposed compatibility test, not a confirmed fix. The container build succeeding does not prove Enshrouded will start correctly; verify the actual server logs before treating the issue as resolved.
