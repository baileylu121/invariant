{ inputs, ... }:
{
  flake.modules.nixos.btrfs-impermanence = {
    imports = [
      inputs.impermanence.nixosModules.default
    ];

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"

        {
          directory = "/etc/ssh";
          mode = "0755";
        }
      ];
      files = [
        "/etc/machine-id"
      ];
    };

    boot.initrd.systemd.enable = true;

    boot.initrd.systemd.services.impermanence-setup = {
      unitConfig.DefaultDependencies = false;
      wantedBy = [ "initrd.target" ];
      after = [
        "initrd-root-device.target"
        "systemd-cryptsetup@cryptroot.service"
      ];
      before = [ "initrd-fs.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /btrfs_tmp
        mount /dev/mapper/cryptroot /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
    };

    security.sudo.extraConfig = "Defaults lecture = never";
  };
}
