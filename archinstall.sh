#!/bin/bashsudo systemctl start NetworkManager.service

# arch personal auto installer

NO_FORMAT="\033[0m"
F_UNDERLINED="\033[4m"
C_GREY3="\033[38;5;232m"
C_DARKTURQUOISE="\033[48;5;44m"
F_DIM="\033[2m"
C_WHITE="\033[38;5;15m"

clear
echo -e "${F_UNDERLINED}${C_GREY3}${C_DARKTURQUOISE}Welcome to my Arch Linux auto-installer! by huker667${NO_FORMAT}"
echo "version v1.5"
echo "----------------------------------------------------------"
echo
echo "Detecting disks"
fdisk -l
echo 
echo "----------------------------------------------------------"
echo
echo "Choose installation method:"
echo 
echo "1) Fast installation on NVMe (EFI, rootты)"
echo "2) Disk split into 2 parts (EFI, root)"
echo "3) Enter 3 partitions manually (EFI, root)"
echo "4) Enter 3 partitions manually (EFI, root, swap)"
echo "5) Disk split into 3 parts (EFI, root, swap)"
echo "6) Exit"
echo "Warning: ALL data on the selected disk will be erased!!!"

read fd

clear
echo "----------------------------------------------------------"
echo
echo "Choose file system for root partition:"
echo 
echo "1) ext4 (stable and fast)"
echo "2) btrfs (good for SSD)"
echo "6) exit"
echo "Warning: ALL data on the selected disk will be erased!!!"
read fs
case $fs in
1)
 ffs="ext4"
 ffs2="ext4"
 ;;
2)
 ffs="btrfs -f"
 ffs2="btrfs"
 ;;
6)
 exit 0
 ;;
*)
 clear
 echo "----------------------------------------------------------"
 echo "You did not select an option. Exiting..."
 exit 0
 ;;
esac
clear
case $fd in

1)
 efi="/dev/nvme0n1p1"
 root="/dev/nvme0n1p2"
 sleep 1s
 echo "formatting in 3..."
 sleep 1s
 echo "formatting in 2..."
 sleep 1s
 echo "formatting in 1..."
 sleep 1s
 echo "doing force formatting $root in $ffs."
 mkfs.$ffs $root 
 echo "doing formatting $efi in fat32 for efi bootloader."
 mkfs.fat -F 32 $efi
 ;;

2)
 fdisk -l
 echo "input disk name:"
 read disk
 sleep 1s
 echo "formatting in 3..."
 sleep 1s
 echo "formatting in 2..."
 sleep 1s
 echo "formatting in 1..."
 sleep 1s
 echo "creating table on $disk"
 parted $disk --script mklabel gpt
 echo "creating efi with 2 gb in fat32"
 parted $disk --script mkpart primary fat32 1MiB 2048MiB
 parted $disk --script set 1 esp on
 echo "creating partiotion for linux system"
 parted $disk --script mkpart primary $ffs2 2048MiB 100%
 efi="${disk}1"
 root="${disk}2"
 echo "formatting $efi в fat32"
 mkfs.fat -F 32 "$efi"
 echo "formatting $root в btrfs"
 mkfs.$ffs $root
 echo "efi: $efi"
 echo "root: $root"
  ;;

3)
 fdisk -l
 echo "enter efi partition device path (e.g., /dev/sda1):"
 read efi
 echo "enter linux root partition device path (e.g., /dev/sda2):"
 read root
 sleep 1s
 echo "formatting in 3..."
 sleep 1s
 echo "formatting in 2..."
 sleep 1s
 echo "formatting in 1..."
 sleep 1s
 echo "formatting $root with btrfs "
 mkfs.$ffs $root

 echo "Formatting $efi with fat32 for efi"
 mkfs.fat -F 32 "$efi"

 echo "efi: $efi"
 echo "root: $root"
 ;;

4)
 fdisk -l
 echo "enter efi partition device path (e.g., /dev/sda1):"
 read efi
 echo "enter linux root partition device path (e.g., /dev/sda2):"
 read root
 echo "enter swap partition device path:"
 read swap
 sleep 1s
 echo "formatting in 3..."
 sleep 1s
 echo "formatting in 2..."
 sleep 1s
 echo "formatting in 1..."
 sleep 1s
 echo "formatting $root with btrfs "
 mkfs.$ffs $root
 sleep 1s
 echo "formatting $efi with fat32 for efi"
 mkfs.fat -F 32 "$efi"
 sleep 1s
 echo "formatting $swap for swap"
 mkswap $swap
 swapon $swap
 echo "efi: $efi"
 echo "root: $root"
 echo "swap: $swap"
 
 ;;
5)
  fdisk -l
  echo "input disk name:"
  read -r disk
  sleep 1s
  echo "formatting in 3..."
  sleep 1s
  echo "formatting in 2..."
  sleep 1s
  echo "formatting in 1..."
  sleep 1s
  echo "creating table on $disk"
  parted $disk --script mklabel gpt
  echo "creating EFI partition 2 GB in fat32"
  parted $disk --script mkpart primary fat32 1MiB 2048MiB
  parted $disk --script set 1 esp on
  echo "creating Linux root partition"
  parted $disk --script mkpart primary $ffs2 2048MiB 100%
  efi="${disk}1"
  root="${disk}2"
  RAM_MB=$(grep MemTotal /proc/meminfo | awk '{print int($2/1024)}')
  SWAP_MB=$(( RAM_MB / 2 ))
  ROOT_END=$(parted $disk --script unit MiB print | grep "^ 2" | awk '{print $3}' | sed 's/MiB//')
  SWAP_START=$ROOT_END
  SWAP_END=$(( ROOT_END + SWAP_MB ))
  parted $disk --script mkpart primary linux-swap ${SWAP_START}MiB ${SWAP_END}MiB
  swap="${disk}3"
  mkfs.fat -F 32 "$efi"
  mkfs.$ffs $root
  mkswap $swap
  swapon $swap
  echo "efi: $efi"
  echo "root: $root"
  echo "swap: $swap"
  ;;
6)
 exit 0
 ;;
*)
 echo "----------------------------------------------------------"
 echo "You did not select an option. Exiting..."
 exit 0
 ;;


esac

echo "Your partitions now look like this------------------------"
echo
fdisk -l
echo
echo "----------------------------------------------------------"
echo
read -p "Press Enter to continue installation..."
clear
echo "I will do mounting for $root in /mnt and $efi in /mnt/boot for efi"
mount $root /mnt
mount --mkdir $efi /mnt/boot

echo ">>> pacstrap -K /mnt base linux linux-firmware"
pacstrap -K /mnt base linux linux-firmware

echo ">>> genfstab -U /mnt >> /mnt/etc/fsta"
genfstab -U /mnt >> /mnt/etc/fstab
clear
echo "----------------------------------------------------------"
echo
echo "The basic installation of Arch Linux is complete."
echo
echo "----------------------------------------------------------"
echo
read -p "Press Enter to enter configuration step..."
clear

echo 'Setting clock to Europe/Moscow...'
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime" || { echo -e "\e[31mExecuting command in chroot failed! Please check your live enviroment. \e[0m"; exit 1; }
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
echo 'Generating locales...'
arch-chroot /mnt /bin/bash -c "sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "sed -i 's/^#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
clear
echo 'Enter hostname for your Arch Linux:'
read hostnames
arch-chroot /mnt /bin/bash -c "echo $hostnames > /etc/hostname"
clear
echo 'Please set password for root:'
arch-chroot /mnt /bin/bash -c "passwd"
clear
echo "----------------------------------------------------------"
echo
echo 'Choose bootloader:'
echo '1) GRUB'
echo '2) EFISTUB'
echo '4) No bootloader'
echo
echo "----------------------------------------------------------"
read bl
case $bl in
1)
 echo 'Installing grub bootloader...'
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm grub efibootmgr"
 arch-chroot /mnt /bin/bash -c "mkdir -p /boot/efi"
 arch-chroot /mnt /bin/bash -c "mount $efi /boot/efi"
 arch-chroot /mnt /bin/bash -c "grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB"
 arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
 ;;
2)
 echo 'Installing efistub bootloader...'
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm efibootmgr"
 arch-chroot /mnt /bin/bash -c "mkdir -p /boot/efi"
 arch-chroot /mnt /bin/bash -c "mount $efi /boot/efi"
 EFI_DISK=${efi%%[0-9]*}
 EFI_PART_NUM=${efi##*[0-9]}
 arch-chroot /mnt /bin/bash -c "efibootmgr --create --disk $EFI_DISK --part $EFI_PART_NUM --label 'Arch Linux' --loader '\vmlinuz-linux' --unicode \"root=UUID=\$(blkid -s UUID -o value $root) rw initrd=\\\\initramfs-linux.img\" --verbose"
 ;;
4)
 echo 'No bootloader...'
 ;;
*)
 echo 'Incorrect choice'
 ;;
esac
clear
echo "----------------------------------------------------------"
echo
echo 'Choose window manager:'
echo '1) i3'
echo '2) KDE Plasma'
echo '3) Hyprland'
echo '4) No WM'
echo
echo "----------------------------------------------------------"
read wm
case $wm in
1)
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm i3 xorg-server xorg-xinit"
 ;;
2)
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm plasma wayland"
 ;;
3)
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm hyprland"
 ;;
4)
 echo 'No window manager will be installed.'
 ;;
*)
 echo 'Incorrect choice'
 ;;
esac
clear
echo "----------------------------------------------------------"
echo
echo 'Choose display manager:'
echo '1) sddm'
echo '2) ly'
echo '3) gdm'
echo '4) no display manager'
echo
echo "----------------------------------------------------------"

read dm
case $dm in
1)
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm sddm"
 arch-chroot /mnt /bin/bash -c "systemctl enable sddm.service"
 
 ;;
 
2)
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm ly"
 arch-chroot /mnt /bin/bash -c "systemctl enable ly.service"
 ;;
3)
 arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm gdm"
 arch-chroot /mnt /bin/bash -c "systemctl enable gdm.service"
 ;;
4)
 echo 'No display manager selected.'
 ;;
*)
 echo 'Incorrect choice'
 ;;
esac
clear
echo "----------------------------------------------------------"
echo
echo "Install NVIDIA drivers?"
echo
echo "1) Yes (proprietary nvidia package)"
echo "2) Yes (open source nouveau driver)"
echo "3) No (skip GPU drivers)"
echo
echo "----------------------------------------------------------"

read gpu
case $gpu in
1)
  arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm nvidia nvidia-utils nvidia-settings"
  ;;
2)
  arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm xf86-video-nouveau"
  ;;
3)
  echo "Skipping GPU driver installation."
  ;;
*)
  echo "Incorrect choice, skipping."
  ;;
esac
clear
echo 'Enabling systemd-networkd.service...'
arch-chroot /mnt /bin/bash -c "systemctl enable systemd-networkd.service"
echo 'Installing NetworkManager, dhcpcd and dhcp...'
arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm networkmanager dhcpcd dhcp"
arch-chroot /mnt /bin/bash -c "dhcpcd"
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager.service"
clear

read -p 'Enter username for new user: ' user

if [[ -z $user ]]; then
  echo "----------------------------------------------------------"
  echo 'Empty username, aborting user creation.'
  exit 1
fi

arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel,video,audio -s /bin/bash $user"
echo "Set password for $user:"
arch-chroot /mnt /bin/bash -c "passwd $user"

clear
echo 'Copying the Internet configuration of the boot iso to the installed system...'
cp -r /etc/iwd /mnt/etc/
cp -r /etc/netctl /mnt/etc/
cp -r /etc/systemd/network /mnt/etc/systemd/
cp /etc/resolv.conf /mnt/etc/
echo 'Done.'
echo
echo 'Do you wish to install the packages: sudo, touch, firefox, kitty? (y/n)'
read installpkgs

if [[ $installpkgs == "y" || $installpkgs == "Y" ]]; then
  arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm sudo"
  arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm touch"
  arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm firefox"
  arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm kitty"
  arch-chroot /mnt /bin/bash -c "echo '%wheel ALL=(ALL:ALL) ALL' >> /etc/sudoers"
else
  echo 'Skipping package installation.'
fi

echo
echo -e "${F_DIM}---------------------------------------------------------------${NO_FORMAT}"
echo "Installation ended. Wanna reboot or enter chroot?"
echo
echo "Command to chroot: arch-chroot /mnt /bin/bash"
echo "Command to reboot into your new system: reboot"
