# Dark Souls: Prepare to Die Edition (+dsfix)

Dark Souls: Prepare to Die Edition - Steam version + dsfix install

1. Download [dsfix](https://www.nexusmods.com/darksouls/mods/19)

2. Install dsfix: `unzip DSFix\ 2.4-19-2-4.zip -d ~/.local/share/Steam/steamapps/common/Dark\ Souls\ Prepare\ to\ Die\ Edition/DATA/`

3. Enable dsfix: `sed -i 's/^\(unlockFPS\) 0/\1 1/' ~/.local/share/Steam/steamapps/common/Dark\ Souls\ Prepare\ to\ Die\ Edition/DATA/DSfix.ini`

4. Set launch options: `WINEDLLOVERRIDES="DINPUT8.dll=n,b" %command%`
