# scripts
## OVERVIEW
Repository of general-use scripts.

## SCRIPTS
- backup: backup script that creates tgz archives
- dotfiles: wrapper script for managing dotfiles using a git repository
- due: kanban board based task manager
- dye: change color scheme using sed replacement
- veil: encrypted group-key based password store
#### DEPRECATED
- flash: terminal-based flash card store for studying
- stash: encrypted hierarchical key-value store
- taskhammer: kanban board based task manager
- spread: remotely execute a command on a cluster of hosts
- stash: encrypted hierarchical key-value store

## INSTALL
- [debian trixie](https://medium.com/@inatagan/installing-debian-with-btrfs-snapper-backups-and-grub-btrfs-27212644175f)
- [swayfx](https://github.com/WillPower3309/swayfx/issues/475)
#### base packages
- alacritty
- fzf
- mako
- neovim
- pipewire / wireplumber
- sway / [swayfx](https://github.com/WillPower3309/swayfx)
- tlp (update 75/80 threshold)
- waybar
#### dev packages
- docker
- golang
- protoc
- rustup
- sdkman
#### misc
- Install and setup fonts
```
sudo apt install fonts-font-awesome fonts-inconsolata fonts-noto

cat <<'EOF' > ~/.config/fontconfig/conf.d/99-font-awesome-fallback.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias>
    <family>Inconsolata</family>
    <prefer>
      <family>Inconsolata</family>
      <family>FontAwesome</family>
    </prefer>
  </alias
</fontconfig>
EOF

fc-cache -fv
```

## TODO
