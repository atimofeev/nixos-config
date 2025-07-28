# Proton

## Launching app from within game installation

```bash
STEAM_COMPAT_CLIENT_INSTALL_PATH=~/.local/share/Steam STEAM_COMPAT_DATA_PATH=~/.steam/steam/steamapps/compatdata/1222670 ~/.steam/steam/steamapps/common/'Proton - Experimental'/proton run ~/.steam/steam/steamapps/compatdata/1222670/pfx/drive_c/Program\ Files/Electronic\ Arts/EA\ Desktop/EA\ Desktop/EADesktop.exe
```

## Install apps into game installation

```bash
# Fix video playback
protontricks 287290 -q wmp11
```
