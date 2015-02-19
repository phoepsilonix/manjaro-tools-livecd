#!/bin/bash

# Configure Desktop image

DIALOG(){
   # parameters: see dialog(1)
   # returns: whatever dialog did
   dialog --backtitle "$TITLE" --aspect 15 --yes-label "$_yes" --no-label "$_no" --cancel-label "$_cancel" "$@"
   return $?
}

set_dm_chroot(){
    local _dm
    # setup lightdm
    if [ -e "/usr/bin/lightdm" ] ; then
       mkdir -p ${DESTDIR}/run/lightdm  &>/dev/null
       chroot ${DESTDIR} getent group lightdm > /dev/null 2>&1 || groupadd -g 620 lightdm
       chroot ${DESTDIR} getent passwd lightdm > /dev/null 2>&1 || useradd -c 'LightDM Display Manager' -u 620 -g lightdm -d /var/run/lightdm -s /usr/bin/nologin lightdm
       chroot ${DESTDIR} passwd -l lightdm > /dev/null
       chown -R lightdm:lightdm ${DESTDIR}/run/lightdm  &>/dev/null
       if [ -e "/usr/bin/startxfce4" ] ; then
            sed -i -e 's/^.*user-session=.*/user-session=xfce/' ${DESTDIR}/etc/lightdm/lightdm.conf
            ln -s /usr/lib/lightdm/lightdm/gdmflexiserver ${DESTDIR}/usr/bin/gdmflexiserver
       fi
       chmod +r ${DESTDIR}/etc/lightdm/lightdm.conf &>/dev/null
       _dm="lightdm"
    fi

    # setup gdm
    if [ -e "/usr/bin/gdm" ] ; then
       chroot ${DESTDIR} getent group gdm >/dev/null 2>&1 || groupadd -g 120 gdm
       chroot ${DESTDIR} getent passwd gdm > /dev/null 2>&1 || usr/bin/useradd -c 'Gnome Display Manager' -u 120 -g gdm -d /var/lib/gdm -s /usr/bin/nologin gdm
       chroot ${DESTDIR} passwd -l gdm > /dev/null
       chroot ${DESTDIR} chown -R gdm:gdm /var/lib/gdm  &>/dev/null
       if [ -d "${DESTDIR}/var/lib/AccountsService/users" ] ; then
          echo "[User]" > ${DESTDIR}/var/lib/AccountsService/users/gdm
          if [ -e "/usr/bin/startxfce4" ] ; then
             echo "XSession=xfce" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
          fi
          if [ -e "/usr/bin/cinnamon-session" ] ; then
             echo "XSession=cinnamon" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
          fi
          if [ -e "/usr/bin/mate-session" ] ; then
             echo "XSession=mate" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
          fi
          if [ -e "/usr/bin/enlightenment_start" ] ; then
             echo "XSession=enlightenment" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
          fi
          if [ -e "/usr/bin/openbox-session" ] ; then
             echo "XSession=openbox" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
          fi
          if [ -e "/usr/bin/startlxde" ] ; then
             echo "XSession=LXDE" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
          fi
          if [ -e "/usr/bin/lxqt-session" ] ; then
             echo "XSession=LXQt" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
          fi
          echo "Icon=" >> ${DESTDIR}/var/lib/AccountsService/users/gdm
       fi
       _dm="gdm"
    fi

    # setup mdm
    if [ -e "/usr/bin/mdm" ] ; then
       chroot ${DESTDIR} getent group mdm >/dev/null 2>&1 || groupadd -g 128 mdm
       chroot ${DESTDIR} getent passwd mdm >/dev/null 2>&1 || usr/bin/useradd -c 'Linux Mint Display Manager' -u 128 -g mdm -d /var/lib/mdm -s /usr/bin/nologin mdm
       chroot ${DESTDIR} passwd -l mdm > /dev/null
       chroot ${DESTDIR} chown root:mdm /var/lib/mdm > /dev/null
       chroot ${DESTDIR} chmod 1770 /var/lib/mdm > /dev/null
       if [ -e "/usr/bin/startxfce4" ] ; then
             sed -i 's|default.desktop|xfce.desktop|g' ${DESTDIR}/etc/mdm/custom.conf
       fi
       if [ -e "/usr/bin/cinnamon-session" ] ; then
             sed -i 's|default.desktop|cinnamon.desktop|g' ${DESTDIR}/etc/mdm/custom.conf
       fi
       if [ -e "/usr/bin/openbox-session" ] ; then
             sed -i 's|default.desktop|openbox.desktop|g' ${DESTDIR}/etc/mdm/custom.conf
       fi
       if [ -e "/usr/bin/mate-session" ] ; then
             sed -i 's|default.desktop|mate.desktop|g' ${DESTDIR}/etc/mdm/custom.conf
       fi
       if [ -e "/usr/bin/startlxde" ] ; then
             sed -i 's|default.desktop|LXDE.desktop|g' ${DESTDIR}/etc/mdm/custom.conf
       fi
       if [ -e "/usr/bin/lxqt-session" ] ; then
             sed -i 's|default.desktop|lxqt.desktop|g' ${DESTDIR}/etc/mdm/custom.conf
       fi
       if [ -e "/usr/bin/enlightenment_start" ] ; then
             sed -i 's|default.desktop|enlightenment.desktop|g' ${DESTDIR}/etc/mdm/custom.conf
       fi
       _dm="mdm"
    fi

    # setup lxdm
    if [ -e "/usr/bin/lxdm" ] ; then
       if [ -z "`chroot ${DESTDIR} getent group "lxdm" 2> /dev/null`" ]; then
         chroot ${DESTDIR} groupadd --system lxdm  &>/dev/null
       fi
       if [ -e "/usr/bin/startxfce4" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/startxfce4|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/cinnamon-session" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/cinnamon-session|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/mate-session" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/mate-session|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/enlightenment_start" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/enlightenment_start|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/openbox-session" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/openbox-session|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/startlxde" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/lxsession|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/lxqt-session" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/lxqt-session|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/pekwm" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/pekwm|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       if [ -e "/usr/bin/i3" ] ; then
         sed -i -e 's|^.*session=.*|session=/usr/bin/i3|' ${DESTDIR}/etc/lxdm/lxdm.conf &>/dev/null
       fi
       chgrp -R lxdm ${DESTDIR}/var/lib/lxdm  &>/dev/null
       chgrp lxdm ${DESTDIR}/etc/lxdm/lxdm.conf  &>/dev/null
       chmod +r ${DESTDIR}/etc/lxdm/lxdm.conf  &>/dev/null
       _dm="lxdm"
    fi

    # setup kdm
    if [ -e "/usr/bin/kdm" ] ; then
       chroot ${DESTDIR} getent group kdm >/dev/null 2>&1 || groupadd -g 135 kdm &>/dev/null
       chroot ${DESTDIR} getent passwd kdm >/dev/null 2>&1 || useradd -u 135 -g kdm -d /var/lib/kdm -s /bin/false -r -M kdm &>/dev/null
       chroot ${DESTDIR} chown -R 135:135 var/lib/kdm &>/dev/null
       chroot ${DESTDIR} xdg-icon-resource forceupdate --theme hicolor &> /dev/null
       chroot ${DESTDIR} update-desktop-database -q
       _dm="kdm"
    fi

    # setup sddm
    if [ -e "/usr/bin/sddm" ] ; then
       chroot ${DESTDIR} getent group sddm > /dev/null 2>&1 || groupadd --system sddm
       chroot ${DESTDIR} getent passwd sddm > /dev/null 2>&1 || usr/bin/useradd -c "Simple Desktop Display Manager" --system -d /var/lib/sddm -s /usr/bin/nologin -g sddm sddm
       chroot ${DESTDIR} passwd -l sddm > /dev/null
       chroot ${DESTDIR} mkdir -p /var/lib/sddm
       chroot ${DESTDIR} chown -R sddm:sddm /var/lib/sddm > /dev/null
       sed -i -e "s|^User=.*|User=${username2}|" /etc/sddm.conf
       if [ -e "/usr/bin/startxfce4" ] ; then
         sed -i -e 's|^Session=.*|Session=xfce.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       if [ -e "/usr/bin/cinnamon-session" ] ; then
         sed -i -e 's|^Session=.*|Session=cinnamon.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       if [ -e "/usr/bin/openbox-session" ] ; then
         sed -i -e 's|^Session=.*|Session=openbox.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       if [ -e "/usr/bin/mate-session" ] ; then
         sed -i -e 's|^Session=.*|Session=mate.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       if [ -e "/usr/bin/lxsession" ] ; then
         sed -i -e 's|^Session=.*|Session=LXDE.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       if [ -e "/usr/bin/lxqt-session" ] ; then
         sed -i -e 's|^Session=.*|Session=lxqt.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       if [ -e "/usr/bin/enlightenment_start" ] ; then
         sed -i -e 's|^Session=.*|Session=enlightenment.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       if [ -e "/usr/bin/startkde" ] ; then
         sed -i -e 's|^Session=.*|Session=plasma.desktop|' ${DESTDIR}/etc/sddm.conf
       fi
       _dm="sddm"
    fi

    if [[ -e /run/openrc ]];then
	local _conf_xdm='DISPLAYMANAGER="'${_dm}'"'
	echo "set ${_conf_xdm}" >> /tmp/livecd.log
	sed -i -e "s|^.*DISPLAYMANAGER=.*|${_conf_xdm}|" ${DESTDIR}/etc/conf.d/xdm
    fi
}

hd_config(){
    # initialize special directories
    rm -v -rf ${DESTDIR}/sys ${DESTDIR}/proc ${DESTDIR}/dev &>/dev/null
    mkdir -p -v -m 1777 ${DESTDIR}/tmp &>/dev/null
    mkdir -p -v -m 1777 ${DESTDIR}/var/tmp &>/dev/null
    mkdir -p -v ${DESTDIR}/var/log/old &>/dev/null
    mkdir -p -v ${DESTDIR}/var/lock/sane &>/dev/null
    mkdir -p -v ${DESTDIR}/var/cache/pacman/pkg &>/dev/null
    mkdir -p -v ${DESTDIR}/boot/grub &>/dev/null
    mkdir -p -v ${DESTDIR}/usr/lib/locale &>/dev/null
    mkdir -p -v ${DESTDIR}/usr/share/icons/default &>/dev/null
    mkdir -p -v ${DESTDIR}/media &>/dev/null
    mkdir -p -v ${DESTDIR}/mnt &>/dev/null
    mkdir -p -v ${DESTDIR}/sys &>/dev/null
    mkdir -p -v ${DESTDIR}/proc &>/dev/null

    # create the basic devices (/dev/{console,null,zero}) on the target
    mkdir -p -v ${DESTDIR}/dev &>/dev/null &>/dev/null
    mknod ${DESTDIR}/dev/console c 5 1 &>/dev/null
    mknod ${DESTDIR}/dev/null c 1 3 &>/dev/null
    mknod ${DESTDIR}/dev/zero c 1 5 &>/dev/null

    # adjust permissions on /tmp and /var/tmp
    chmod -v 777 ${DESTDIR}/var/tmp &>/dev/null
    chmod -v o+t ${DESTDIR}/var/tmp &>/dev/null
    chmod -v 777 ${DESTDIR}/tmp &>/dev/null
    chmod -v o+t ${DESTDIR}/tmp &>/dev/null

    # install /etc/resolv.conf
    cp -vf /etc/resolv.conf ${DESTDIR}/etc/resolv.conf &>/dev/null

    echo "install configs for root" &>/dev/null
    cp -a ${DESTDIR}/etc/skel/. ${DESTDIR}/root/ &>/dev/null

    sed -i 's/^#\(en_US.*\)/\1/' ${DESTDIR}/etc/locale.gen &>/dev/null

    chroot_mount

    # copy generated xorg.xonf to target
    if [ -e "/etc/X11/xorg.conf" ] ; then
        echo "copying generated xorg.conf to target"
        cp /etc/X11/xorg.conf ${DESTDIR}/etc/X11/xorg.conf &>/dev/null
    fi

    #set_alsa

    DIALOG --infobox "${_setupalsa}"  6 40
    sleep 3
    # configure alsa
    #set_alsa
    configure_alsa

    # configure pulse
    chroot ${DESTDIR} pulseaudio-ctl normal
    # save settings
    chroot ${DESTDIR} alsactl -f /etc/asound.state store &>/dev/null

    DIALOG --infobox "${_syncpacmandb}" 0 0
    # enable default mirror
    cp -f ${DESTDIR}/etc/pacman.d/mirrorlist ${DESTDIR}/etc/pacman.d/mirrorlist.backup
    if [ ! -z "$(check_ping)" ] ; then
       chroot ${DESTDIR} pacman-mirrors -g &>/dev/null
    fi

    # copy random generated keys by pacman-init to target
    if [ -e "${DESTDIR}/etc/pacman.d/gnupg" ] ; then
       rm -rf ${DESTDIR}/etc/pacman.d/gnupg &>/dev/null
    fi
    cp -a /etc/pacman.d/gnupg ${DESTDIR}/etc/pacman.d/
    pacman-key --populate archlinux manjaro &>/dev/null

    # sync pacman databases
    sleep 3
    chroot ${DESTDIR} pacman -Syy &> /dev/null

    # Install drivers

    if [ -e "/opt/livecd/pacman-gfx.conf" ] ; then
       DIALOG --infobox "${_installvideodriver}"  6 40

       mkdir -p ${DESTDIR}/opt/livecd
       mount -o bind /opt/livecd ${DESTDIR}/opt/livecd > /tmp/mount.pkgs.log
       ls ${DESTDIR}/opt/livecd >> /tmp/mount.pkgs.log

       # Install xf86-video driver
       if  [ "${USENONFREE}" == "yes" ] || [ "${USENONFREE}" == "true" ]; then
	   if  [ "${VIDEO}" == "vesa" ]; then
           	chroot ${DESTDIR} mhwd --install pci video-vesa --pmconfig "/opt/livecd/pacman-gfx.conf" &>/dev/null
	   else
           	chroot ${DESTDIR} mhwd --auto pci nonfree 0300 --pmconfig "/opt/livecd/pacman-gfx.conf" &>/dev/null
	   fi
       else
	   if  [ "${VIDEO}" == "vesa" ]; then
           	chroot ${DESTDIR} mhwd --install pci video-vesa --pmconfig "/opt/livecd/pacman-gfx.conf" &>/dev/null
	   else
           	chroot ${DESTDIR} mhwd --auto pci free 0300 --pmconfig "/opt/livecd/pacman-gfx.conf" &>/dev/null
	   fi
       fi

       # Install network drivers
       chroot ${DESTDIR} mhwd --auto pci free 0200 --pmconfig "/opt/livecd/pacman-gfx.conf" &>/dev/null
       chroot ${DESTDIR} mhwd --auto pci free 0280 --pmconfig "/opt/livecd/pacman-gfx.conf" &>/dev/null

       umount ${DESTDIR}/opt/livecd
       rmdir ${DESTDIR}/opt/livecd
    fi

    # setup system services
    if [[ -e /run/systemd ]]; then
	DIALOG --infobox "${_setupsystemd}" 6 40
	sleep 3

	chroot ${DESTDIR} systemctl enable org.cups.cupsd.service &>/dev/null
	chroot ${DESTDIR} systemctl enable dcron.service &>/dev/null
	chroot ${DESTDIR} systemctl enable NetworkManager.service &>/dev/null
	chroot ${DESTDIR} systemctl enable remote-fs.target &>/dev/null
    else
	DIALOG --infobox "${_setupopenrc}" 6 40
	sleep 3

	chroot ${DESTDIR} rc-update add cups default &>/dev/null
	chroot ${DESTDIR} rc-update add cronie default &>/dev/null
	chroot ${DESTDIR} rc-update add metalog default &>/dev/null
    fi
    # for openrc (add comment for mounting /tmp as tmpfs in /etc/fstab)
    if [ -e /run/openrc ]; then
      echo "# Uncomment the line below to setup /tmp as tmpfs" >> ${DESTDIR}/etc/fstab
      echo "# tmpfs    /tmp    tmpfs    nodev,nosuid    0   0" >> ${DESTDIR}/etc/fstab
    fi

    DIALOG --infobox "${_setupdisplaymanager}" 6 40
    sleep 3

    #set_dm_chroot
    set_dm_chroot

    # fix some apps

    DIALOG --infobox "${_fixapps}" 6 40
    sleep 3

    # add BROWSER var
    echo "BROWSER=/usr/bin/xdg-open" >> ${DESTDIR}/etc/environment
    echo "BROWSER=/usr/bin/xdg-open" >> ${DESTDIR}/etc/skel/.bashrc
    echo "BROWSER=/usr/bin/xdg-open" >> ${DESTDIR}/etc/profile
    # add TERM var
    if [ -e "/bootmnt/${install_dir}/${arch}/mate-image.sqfs" ] ; then
       echo "TERM=mate-terminal" >> ${DESTDIR}/etc/environment
       echo "TERM=mate-terminal" >> ${DESTDIR}/etc/profile
    fi

    # Adjust Steam-Native when libudev.so.0 is available
    if [ -e "/usr/lib/libudev.so.0" ] || [ -e "/usr/lib32/libudev.so.0" ] ; then
       echo -e "STEAM_RUNTIME=0\nSTEAM_FRAME_FORCE_CLOSE=1" >> ${DESTDIR}/etc/environment
    fi

    # fix_gnome_apps
    chroot ${DESTDIR} glib-compile-schemas /usr/share/glib-2.0/schemas
    chroot ${DESTDIR} gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor
    chroot ${DESTDIR} dconf update

    if [ -e "/usr/bin/gnome-keyring-daemon" ] ; then
       chroot ${DESTDIR} setcap cap_ipc_lock=ep /usr/bin/gnome-keyring-daemon &>/dev/null
    fi

    # fix_ping_installation
    chroot ${DESTDIR} setcap cap_net_raw=ep /usr/bin/ping &>/dev/null
    chroot ${DESTDIR} setcap cap_net_raw=ep /usr/bin/ping6 &>/dev/null

    # remove .manjaro-chroot
    chroot ${DESTDIR} rm /.manjaro-tools &>/dev/null

    if [ -e "/usr/bin/live-installer" ] ; then
       chroot ${DESTDIR} pacman -R --noconfirm live-installer &>/dev/null
    fi

    if [ -e "/usr/bin/thus" ] ; then
       chroot ${DESTDIR} pacman -R --noconfirm thus &>/dev/null
    fi

    # remove virtualbox driver on real hardware
    if [ -z "$(mhwd | grep 0300:80ee:beef)" ] ; then
       chroot ${DESTDIR} pacman -Rsc --noconfirm $(pacman -Qq | grep virtualbox-guest-modules) &>/dev/null
    fi

    # set unique machine-id
    chroot ${DESTDIR} dbus-uuidgen --ensure=/etc/machine-id
    chroot ${DESTDIR} ln -s /etc/machine-id /var/lib/dbus/machine-id

    chroot_umount
}

# run_unsquashfs()
# runs unsquashfs on the target system, displays output
#
run_unsquashfs(){
    # all unsquashfs output goes to /tmp/unsquashfs.log, which we tail
    # into a dialog
    ( \
        touch /tmp/setup-unsquashfs-running
        echo "unsquashing $SQF_FILE..." > /tmp/unsquashfs.log; \
        echo >> /tmp/unsquashfs.log; \
        unsquashfs -f -da 32 -fr 32 -d $UNSQUASH_TARGET /bootmnt/${install_dir}/${arch}/$SQF_FILE >> /tmp/unsquashfs.log 2>&1
        rm -f /tmp/setup-unsquashfs-running
    ) &

    (
    c="0"
    while [ $c -ne 100 ]
    do
        sleep 2
        value=`cat /tmp/unsquashfs.log | grep -Eo " [0-9]*%" | sed -e "s|[^0-9]||g" | tail -1`
        sleep 2
        c=$value
        echo $c
        echo "###"
        echo "$c %"
        echo "###"
    done
    ) | DIALOG --title "$_unsquash_dialog_title" --gauge "$_unsquash_dialog_info1 $SQF_FILE $_unsquash_dialog_info2" 10 60 0

    # save unsquashfs.log
    mv "/tmp/unsquashfs.log" "/tmp/unsquashfs-$SQF_FILE.log"
}

# run_mount_sqf()
# runs mount on SQF_FILE
run_mount_sqf(){
    # mount SQF_FILE to CP_SOURCE
    mount /bootmnt/${install_dir}/${arch}/${SQF_FILE} ${CP_SOURCE} -t squashfs -o loop
}

# run_umount_sqf()
# runs umount on SQF_FILE
run_umount_sqf(){
    # umount SQF_FILE from CP_SOURCE
    umount ${CP_SOURCE}
}

# run_cp()
# runs cp on the target system, displays output
#
run_cp(){
    # all cp output goes to /tmp/cp.log, which we tail
    FILES_TOSYNC=$(unsquashfs -l /bootmnt/${install_dir}/${arch}/${SQF_FILE} | wc -l)
    (cp -av ${CP_SOURCE}/* ${CP_TARGET} | \
    pv -nls ${FILES_TOSYNC} | \
    grep -v ">" | grep "[0-9]*") 2>&1 | \
    DIALOG --title "$_unsquash_dialog_title" --gauge "$_unsquash_dialog_info1 $SQF_FILE $_unsquash_dialog_info2" 10 60 0

    # save cp.log
    #mv "/tmp/cp.log" "/tmp/cp-$SQF_FILE.log"
}

# run_mkinitcpio()
# runs mkinitcpio on the target system, displays output
#
run_mkinitcpio(){
    chroot_mount
    # fix fsck.btrfs issue
    chroot "$DESTDIR" ln -sf /bin/true /usr/bin/fsck.btrfs &> /dev/null

    # fix fsck.nilfs2 issue
    chroot "$DESTDIR" ln -sf /bin/true /usr/bin/fsck.nilfs2 &> /dev/null

    # all mkinitcpio output goes to /tmp/mkinitcpio.log, which we tail
    # into a dialog
    ( \
    touch /tmp/setup-mkinitcpio-running
    echo "${_runninginitcpio}" >> /tmp/mkinitcpio.log; \
    chroot "$DESTDIR" /usr/bin/mkinitcpio -p "$manjaro_kernel" >>/tmp/mkinitcpio.log 2>&1
    echo >> /tmp/mkinitcpio.log
    rm -f /tmp/setup-mkinitcpio-running
    ) &

    sleep 2

    DIALOG --title "${_runninginitcpiotitle}" --no-kill --tailboxbg "/tmp/mkinitcpio.log" 18 70
    while [ -f /tmp/setup-mkinitcpio-running ]; do
        /bin/true
    done

    chroot_umount
}

# installsystem_unsquash()
# installs to the target folder
installsystem_unsquash(){
    #DIALOG --msgbox "${_installationwillstart}" 0 0
    #clear
    mkdir -p ${DESTDIR}
    #unsquashfs -f -d ${DESTDIR} /bootmnt/${install_dir}/${arch}/root-image.sqfs
    UNSQUASH_TARGET=${DESTDIR}
    SQF_FILE=root-image.sqfs
    run_unsquashfs
    echo $? > /tmp/.install-retcode
    if [ $(cat /tmp/.install-retcode) -ne 0 ]; then echo -e "\n${_installationfail}" >>/tmp/unsquasherror.log
    else echo -e "\n => Root-Image: ${_installationsuccess}" >>/tmp/unsquasherror.log
    fi
    sed -i '/dir_scan: failed to open directory [^ ]*, because File exists/d' /tmp/unsquasherror.log

    #unsquashfs -f -d ${DESTDIR} /bootmnt/${install_dir}/${arch}/de-image.sqfs
    UNSQUASH_TARGET=${DESTDIR}
    SQF_FILE=${DESKTOP_IMG}.sqfs
    run_unsquashfs
    echo $? > /tmp/.install-retcode
    if [ $(cat /tmp/.install-retcode) -ne 0 ]; then echo -e "\n${_installationfail}" >>/tmp/unsquasherror.log
    else echo -e "\n => ${DESKTOP}-Image: ${_installationsuccess}" >>/tmp/unsquasherror.log
    fi
    sed -i '/dir_scan: failed to open directory [^ ]*, because File exists/d' /tmp/unsquasherror.log

    # finished, display scrollable output
    local _result=''
    if [ $(cat /tmp/.install-retcode) -ne 0 ]; then
      _result="${_installationfail}"
      BREAK="break"
    else
      _result="${_installationsuccess}"
    fi
    rm /tmp/.install-retcode

    DIALOG --title "$_result" --exit-label "${_continue_label}" \
        --textbox "/tmp/unsquasherror.log" 18 60 || return 1

    # ensure the disk is synced
    sync

    if [ "${BREAK}" = "break" ]; then
       break
    fi

    S_INSTALL=1
    NEXTITEM=4

    # automagic time!
    # any automatic configuration should go here
    DIALOG --infobox "${_configuringsystem}" 6 40
    sleep 3

    hd_config
    auto_fstab
    _system_is_installed=1
}


dogrub_mkconfig(){
    chroot_mount

    # prepare grub.cfg
    chroot ${DESTDIR} mkdir -p /boot/grub/locale
    chroot ${DESTDIR} cp /usr/share/locale/en@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo

    # remove splash if no plymouth was found
    if [ ! -e ${DESTDIR}/etc/plymouth/plymouthd.conf ] ; then
       sed -i -e "s,GRUB_CMDLINE_LINUX_DEFAULT=.*,GRUB_CMDLINE_LINUX_DEFAULT=\"`cat $DESTDIR/etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT | cut -d'"' -f2 | sed s'/splash//'g | sed s'/quiet//'g`\",g" $DESTDIR/etc/default/grub
    fi

    # generate resume string for suspend to disk
    [ -z "${swap_partition}" -o "${swap_partition}" = "NONE" ] || sed -i -e "s,GRUB_CMDLINE_LINUX_DEFAULT=.*,GRUB_CMDLINE_LINUX_DEFAULT=\"`cat $DESTDIR/etc/default/grub | grep GRUB_CMDLINE_LINUX_DEFAULT | cut -d'"' -f2` resume=UUID=`blkid -s UUID -o value -p ${swap_partition}`\",g" $DESTDIR/etc/default/grub

    # grub.cfg workaround for net-install
    if [ "$DESKTOP_IMG" == "net-image" ]
       sed -i -e 's|GRUB_SAVEDEFAULT=true|#GRUB_SAVEDEFAULT=true|g' $DESTDIR/etc/default/grub
    fi

    # create grub.cfg
    chroot ${DESTDIR} grub-mkconfig -o "/${GRUB_PREFIX_DIR}/grub.cfg" >> /tmp/grub.log 2>&1

    chroot_umount
}

_rm_kalu(){
    local base_check_virtualbox=`dmidecode | grep innotek`
    local base_check_vmware=`dmidecode | grep VMware`
    local base_check_qemu=`dmidecode | grep QEMU`
    local base_check_vpc=`dmidecode | grep Microsoft`

    if [ -n "$base_check_virtualbox" ]; then
       pacman -R kalu --noconfirm --noprogressbar --root ${DESTDIR} &> /dev/null
    elif [ -n "$base_check_vmware" ]; then
       pacman -R kalu --noconfirm --noprogressbar --root ${DESTDIR} &> /dev/null
    elif [ -n "$base_check_qemu" ]; then
       pacman -R kalu --noconfirm --noprogressbar --root ${DESTDIR} &> /dev/null
    elif [ -n "$base_check_vpc" ]; then
       pacman -R kalu --noconfirm --noprogressbar --root ${DESTDIR} &> /dev/null
    fi
}

_post_process(){
    ## POSTPROCESSING ##
    # /etc/locale.gen
    #
    DIALOG --infobox "${_localegen}" 0 0
    chroot ${DESTDIR} locale-gen &> /dev/null

    # installing localization packages
    if [ -e "/bootmnt/${install_dir}/${arch}/lng-image.sqfs" ] ; then
       configure_translation_pkgs
       ${PACMAN_LNG} -Sy
       if [ -e "/bootmnt/${install_dir}/${arch}/kde-image.sqfs" ] ; then
          ${PACMAN_LNG} -S ${KDE_LNG_INST} &> /dev/null
       fi
       if [ -e "/usr/bin/firefox" ] ; then
          ${PACMAN_LNG} -S ${FIREFOX_LNG_INST} &> /dev/null
       fi
       if [ -e "/usr/bin/thunderbird" ] ; then
          ${PACMAN_LNG} -S ${THUNDER_LNG_INST} &> /dev/null
       fi
       if [ -e "/usr/bin/libreoffice" ] ; then
          ${PACMAN_LNG} -S ${LIBRE_LNG_INST} &> /dev/null
       fi
       if [ -e "/usr/bin/hunspell" ] ; then
          ${PACMAN_LNG} -S ${HUNSPELL_LNG_INST} &> /dev/null
       fi
    fi

    # check if we are running inside a virtual machine and unistall kalu
    if [ -e "${DESTDIR}/usr/bin/kalu" ] ; then
       _rm_kalu
    fi

    # /etc/localtime
    cp /etc/localtime ${DESTDIR}/etc/localtime &> /dev/null
    if [ -e "/etc/adjtime" ] ; then
       cp /etc/adjtime ${DESTDIR}/etc/adjtime &> /dev/null
    fi

    sleep 3
    # add resume hook for suspend to disk
    [ -z "${swap_partition}" -o "${swap_partition}" = "NONE" ] || if [ "x$(cat $DESTDIR/etc/mkinitcpio.conf | grep '^HOOKS=' | grep -v '^#' | grep resume)" == "x" ]; then
       hooks=""
       for hook in $(cat $DESTDIR/etc/mkinitcpio.conf | grep '^HOOKS=' | grep -v '^#' | cut -d'"' -f2) ; do
           if [ "$hook" == "filesystems" ] && [ "$replaced" == "" ]; then
              hook="resume filesystems"
              replaced="1"
           fi
           hooks="${hooks} ${hook}"
       done
       hooks=$(echo "${hooks}" | sed 's/^ *//;s/ *$//;s/ \{1,\}/ /g')
       if [ "x$(echo \"${hooks}\" | grep resume)" == "x" ]; then
          hooks="${hooks} resume"
       fi
       sed -i -e "s/^HOOKS=.*/HOOKS=\"${hooks}\"/g" $DESTDIR/etc/mkinitcpio.conf
    fi

    # create kernel images
    run_mkinitcpio
    sleep 3

    ## END POSTPROCESSING ##
    # TODO add end cleaning

    S_CONFIG=1
    NEXTITEM=5
    _system_is_configured=1
}

# Disable swap and all mounted partitions for the destination system. Unmount
# the destination root partition last!

# Umount all mounted partitions
_umounthdds(){
    for UPART in $(findpartitions); do
        umount $(mount | grep ${UPART} | grep -v /bootmnt | sed 's|\ .*||g') >/dev/null 2>&1
    done
}

# activate_dmraid()
# activate dmraid devices
activate_dmraid(){
    if [[ -e /usr/bin/dmraid ]]; then
        DIALOG --infobox "${_activate_dmraid}" 0 0
        /usr/bin/dmraid -ay -I -Z >/dev/null 2>&1
    fi
}

# activate_lvm2
# activate lvm2 devices
activate_lvm2(){
    ACTIVATE_LVM2=""
    if [[ -e /usr/bin/lvm ]]; then
        OLD_LVM2_GROUPS=${LVM2_GROUPS}
        OLD_LVM2_VOLUMES=${LVM2_VOLUMES}
        DIALOG --infobox "${_scanning_lvm2}" 0 0
        /usr/bin/lvm vgscan --ignorelockingfailure >/dev/null 2>&1
        DIALOG --infobox "${_activate_lvm2}" 0 0
        /usr/bin/lvm vgchange --ignorelockingfailure --ignoremonitoring -ay >/dev/null 2>&1
        LVM2_GROUPS="$(vgs -o vg_name --noheading 2>/dev/null)"
        LVM2_VOLUMES="$(lvs -o vg_name,lv_name --noheading --separator - 2>/dev/null)"
        [[ "${OLD_LVM2_GROUPS}" = "${LVM2_GROUPS}" && "${OLD_LVM2_GROUPS}" = "${LVM2_GROUPS}" ]] && ACTIVATE_LVM2="no"
    else
        ACTIVATE_LVM2="no"
    fi
}

# activate_raid
# activate md devices
activate_raid(){
    ACTIVATE_RAID=""
    if [[ -e /usr/bin/mdadm ]]; then
        DIALOG --infobox "${_activate_raid}" 0 0
        /usr/bin/mdadm --assemble --scan >/dev/null 2>&1 || ACTIVATE_RAID="no"
    else
        ACTIVATE_RAID="no"
    fi
}

# activate_luks
# activate luks devices
activate_luks(){
    ACTIVATE_LUKS=""
    if [[ -e /usr/bin/cryptsetup ]]; then
        DIALOG --infobox "${_scanning_luks}" 0 0
        if [[ "$(${_BLKID} | grep "TYPE=\"crypto_LUKS\"")" ]]; then
            for PART in $(${_BLKID} | grep "TYPE=\"crypto_LUKS\"" | sed -e 's#:.*##g'); do
                # skip already encrypted devices, device mapper!
                OPEN_LUKS=""
                for devpath in $(ls /dev/mapper 2>/dev/null | grep -v control); do
                    [[ "$(cryptsetup status ${devpath} | grep ${PART})" ]] && OPEN_LUKS="no"
                done
                if ! [[ "${OPEN_LUKS}" = "no" ]]; then
                    RUN_LUKS=""
                    DIALOG --yesno "${_setup_luks} $PART ?" 0 0 && RUN_LUKS="1"
                    [[ "${RUN_LUKS}" = "1" ]] && _enter_luks_name && _enter_luks_passphrase && _opening_luks
                    [[ "${RUN_LUKS}" = "" ]] && ACTIVATE_LUKS="no"
                else
                    ACTIVATE_LUKS="no"
                fi
            done
        else
            ACTIVATE_LUKS="no"
        fi
    else
        ACTIVATE_LUKS="no"
    fi
}

# activate_special_devices()
# activate special devices:
# activate dmraid, lvm2 and raid devices, if not already activated during bootup!
# run it more times if needed, it can be hidden by each other!

activate_special_devices(){
    ACTIVATE_RAID=""
    ACTIVATE_LUKS=""
    ACTIVATE_LVM2=""
    activate_dmraid
    while ! [[ "${ACTIVATE_LVM2}" = "no" && "${ACTIVATE_RAID}" = "no"  && "${ACTIVATE_LUKS}" = "no" ]]; do
        activate_raid
        activate_lvm2
        activate_luks
    done
}

# destdir_mounts()
# check if PART_ROOT is set and if something is mounted on ${DESTDIR}
destdir_mounts(){
    # Don't ask for filesystem and create new filesystems
    ASK_MOUNTPOINTS=""
    PART_ROOT=""
    # check if something is mounted on ${DESTDIR}
    PART_ROOT="$(mount | grep "${DESTDIR} " | cut -d' ' -f 1)"
    # Run mountpoints, if nothing is mounted on ${DESTDIR}
    if [[ "${PART_ROOT}" = "" ]]; then
        DIALOG --msgbox "${_destdir_1}${DESTDIR}${_destdir_2}" 0 0
        mountpoints || return 1
    fi
}

# lists additional linux blockdevices
additional_blockdevices(){
    # Include additional controllers:
    # Mylex DAC960 PCI RAID controller, Compaq Next Generation Drive Array,
    # Compaq Intelligent Drive Array
    for i in ${EXTRA_CONTROLLER}; do
        for dev in $(ls ${block} 2>/dev/null | egrep "^${i}"); do
            for k in $(ls ${block}/${dev} 2>/dev/null | egrep "${dev}*p"); do
                if [[ -d "${block}/${dev}/${k}" ]]; then
                    echo "/dev/${i}/$(echo ${dev} | sed -e 's#.*\!##g')"
                    [[ "${1}" ]] && echo ${1}
                    break
                fi
            done
        done
    done
    # Include MMC devices
    for dev in $(ls ${block} 2>/dev/null | egrep '^mmcblk'); do
        for i in $(ls ${block}/${dev} 2>/dev/null | egrep ${dev}p); do
            if [[ -d "${block}/${dev}/${i}" ]]; then
                echo "/dev/${dev}"
                [[ "${1}" ]] && echo ${1}
                break
            fi
        done
    done
}

# lists additional linux blockdevices partitions
additional_blockdevices_partitions(){
    # Mylex DAC960 PCI RAID controller, Compaq Next Generation Drive Array,
    # Compaq Intelligent Drive Array
    for k in ${EXTRA_CONTROLLER}; do
        for dev in $(ls ${block} 2>/dev/null | egrep "^${k}"); do
            for i in $(ls ${block}/${dev} 2>/dev/null | egrep "${dev}*p"); do
                if [[ -d "${block}/${dev}/${i}" ]]; then
                    disk="${k}/$(echo ${dev} | sed -e 's#.*\!##g')"
                    part="${k}/$(echo ${i} | sed -e 's#.*\!##g')"
                    # exclude checks:
                    #- part of raid device
                    #  $(cat /proc/mdstat 2>/dev/null | grep ${part})
                    #- part of lvm2 device
                    #  $(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "LVM2_member")
                    #- part of luks device
                    #  $(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "crypto_LUKS")
                    #- extended partition on device
                    #  $(sfdisk -c /dev/${disk} $(echo ${part} | sed -e "s#${disk}\p##g" 2>/dev/null | grep "5")
                    #- bios_grub partitions
                    # $(echo ${part} | grep "[a-z]$(parted -s /dev/${disk} print 2>/dev/null | grep bios_grub | cut -d " " -f 2)$")
                    if ! [[ "$(cat /proc/mdstat 2>/dev/null | grep ${part})" || "$(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "LVM2_member")" || "$(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "crypto_LUKS")" || "$(sfdisk -c /dev/${disk} $(echo ${part} | sed -e "s#${disk}\p##g") 2>/dev/null | grep "5")" || "$(echo ${part} | grep "[a-z]$(parted -s /dev/${disk} print 2>/dev/null | grep bios_grub | cut -d " " -f 2)$")" ]]; then
                        echo "/dev/${part}"
                        [[ "${1}" ]] && echo ${1}
                    fi
                fi
            done
        done
    done
    # Include MMC devices
    for dev in $(ls ${block} 2>/dev/null | egrep '^mmcblk'); do
        for i in $(ls ${block}/${dev} 2>/dev/null | egrep ${dev}p); do
            if [[ -d "${block}/${dev}/${i}" ]]; then
                # exclude checks:
                #- part of raid device
                #  $(cat /proc/mdstat 2>/dev/null | grep ${i})
                #- part of lvm2 device
                #  $(${_BLKID} -p -i -o value -s TYPE /dev/${i} | grep "LVM2_member")
                #- part of luks device
                #  $(${_BLKID} -p -i -o value -s TYPE /dev/${i} | grep "crypto_LUKS")
                #- extended partition on device
                #  $(sfdisk -c /dev/${dev} $(echo ${i} | sed -e "s#${dev}\p##g" 2>/dev/null | grep "5")
                #- bios_grub partitions
                # $(echo ${i} | grep "[a-z]$(parted -s /dev/${dev} print 2>/dev/null | grep bios_grub | cut -d " " -f 2)$")
                if ! [[ "$(cat /proc/mdstat 2>/dev/null | grep ${i})" || "$(${_BLKID} -p -i -o value -s TYPE /dev/${i} | grep "LVM2_member")" || $(${_BLKID} -p -i -o value -s TYPE /dev/${i} | grep "crypto_LUKS") || "$(sfdisk -c /dev/${dev} $(echo ${i} | sed -e "s#${dev}\p##g") 2>/dev/null | grep "5")" || "$(echo ${i} | grep "[a-z]$(parted -s /dev/${dev} print 2>/dev/null | grep bios_grub | cut -d " " -f 2)$")" ]]; then
                    echo "/dev/${i}"
                    [[ "${1}" ]] && echo ${1}
                fi
            fi
        done
    done
}

# list none partitionable raid md devices
raid_devices(){
    for devpath in $(ls ${block} 2>/dev/null | egrep '^md'); do
        if ! [[ "$(ls ${block}/${devpath} 2>/dev/null | egrep ${devpath}p)" ]]; then
            # exlude md partitions which are part of lvm or luks
            if ! [[ "$(${_BLKID} -p -i /dev/${devpath} | grep "TYPE=\"LVM2_member\"")" || "$(${_BLKID} -p -i /dev/${devpath} | grep "TYPE=\"crypto_LUKS\"")" ]]; then
                    echo "/dev/${devpath}"
                    [[ "${1}" ]] && echo ${1}
            fi
        fi
    done
}

# lists default linux partitionable raid devices
partitionable_raid_devices(){
    for dev in $(ls ${block} 2>/dev/null | egrep '^md'); do
        for i in $(ls ${block}/${dev} 2>/dev/null | egrep "${dev}\!*p"); do
            if [[ -d "${block}/${dev}/${i}" ]]; then
                echo "/dev/${dev}"
                [[ "${1}" ]] && echo ${1}
                break
            fi
        done
    done
}

# lists default linux partitionable raid devices
partitionable_raid_devices_partitions(){
    for dev in $(ls ${block} 2>/dev/null | egrep '^md'); do
        for i in $(ls ${block}/${dev} 2>/dev/null | egrep ${dev}p); do
            if [[ -d "${block}/${dev}/${i}" ]]; then
                # exlude md partitions which are part of lvm or luks
                if ! [[ "$(${_BLKID} -p -i /dev/${i} | grep "TYPE=\"LVM2_member\"")" || ! "$(${_BLKID} -p -i /dev/${i} | grep "TYPE=\"crypto_LUKS\"")" ]]; then
                    echo "/dev/${i}"
                    [[ "${1}" ]] && echo ${1}
                fi
            fi
        done
    done
}

# lists default linux dmraid devices
dmraid_devices(){
    if [[ -d /dev/mapper ]]; then
        for fakeraid in $(dmraid -s -c); do
                if [[ "$(echo ${fakeraid} | grep '_')" ]]; then
                    echo "/dev/mapper/${fakeraid}"
                    [[ "${1}" ]] && echo ${1}
                fi
        done
    fi
}

# check_dm_devices
# - remove part of encrypted devices
# - remove part of lvm
# - remove part ot raid
check_dm_devices(){
    for devpath in $(ls /dev/mapper 2>/dev/null | grep -v control); do
        k="$(${_BLKID} -p -i /dev/mapper/${devpath} 2>/dev/null | grep "TYPE=\"crypto_LUKS\"" | sed -e 's#:.*##g')"
        partofcrypt="${partofcrypt} ${k}"
    done
    for devpath in $(ls /dev/mapper 2>/dev/null | grep -v control); do
        k="$(${_BLKID} -p -i /dev/mapper/${devpath} 2>/dev/null | grep "TYPE=\"LVM2_member\"" | sed -e 's#:.*##g')"
        partoflvm="${partoflvm} ${k}"
    done
    for devpath in $(ls /dev/mapper 2>/dev/null | grep -v control); do
        k="$(${_BLKID} -p -i /dev/mapper/${devpath} 2>/dev/null | grep "TYPE=\"linux_raid_member\"" | sed -e 's#:.*##g')"
        partofraid="${partofraid} ${k}"
    done
}

# dm_devices
# - show device mapper devices
dm_devices(){
    check_dm_devices
    for i in $(dmraid -s -c); do
        EXCLUDE_DMRAID=""
        if [[ "$(echo ${i} | grep '_')" ]]; then
             EXCLUDE_DMRAID="${EXCLUDE_DMRAID} -e ${i} "
        fi
    done
    if [[ -d /dev/mapper ]]; then
        for devpath in $(ls /dev/mapper 2>/dev/null | grep -v -e control ${EXCLUDE_DMRAID}); do
            if ! [[ "$(ls ${partofcrypt} 2>/dev/null | grep /dev/mapper/${devpath}$)" || "$(ls ${partoflvm} 2>/dev/null | grep /dev/mapper/${devpath}$)" || "$(ls ${partofraid} 2>/dev/null | grep /dev/mapper/${devpath}$)" ]]; then
                echo "/dev/mapper/${devpath}"
                [[ "${1}" ]] && echo ${1}
            fi
        done
    fi
}

# dmraid_partitions
# - show dmraid partitions
dmraid_partitions(){
    check_dm_devices
    if [[ -d /dev/mapper ]]; then
        for fakeraid in $(dmraid -s -c); do
            if [[ "$(echo ${fakeraid} | grep '_')" ]]; then
                for k in $(ls /dev/mapper/${fakeraid}*); do
                    devpath=$(basename ${k})
                    if ! [[ "$(dmraid -s -c | grep ${devpath}$)" || "$(ls ${partofcrypt} 2>/dev/null | grep /dev/mapper/${devpath}$)" || "$(ls ${partoflvm} 2>/dev/null | grep /dev/mapper/${devpath}$)" || "$(ls ${partofraid} 2>/dev/null | grep /dev/mapper/${devpath}$)" ]]; then
                        echo "/dev/mapper/${devpath}"
                        [[ "${1}" ]] && echo ${1}
                    fi
                done
            fi
        done
    fi
}

# do sanity checks on partitions, argument comes ${devpath} loop
default_partition_check(){
        disk=$(basename ${devpath})
        for part in $(ls ${block}/${disk} 2>/dev/null | egrep -v ^${disk}p | egrep ^${disk}); do
            # exclude checks:
            #- part of raid device
            #  $(cat /proc/mdstat 2>/dev/null | grep ${part})
            #- part of lvm2 device
            #  $(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "LVM2_member")
            #- part of luks device
            #  $(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "crypto_LUKS")
            #- extended partition
            #  $(sfdisk -c /dev/${disk} $(echo ${part} | sed -e "s#${disk}##g") 2>/dev/null | grep "5")
            #- extended partition on raid partition device and mmc device
            #  $(sfdisk -c /dev/${disk} $(echo ${part} | sed -e "s#${disk}\p##g" 2>/dev/null | grep "5")
            #- bios_grub partitions
            # $(echo ${part} | grep "[a-z]$(parted -s /dev/${disk} print 2>/dev/null | grep bios_grub | cut -d " " -f 2)$")
            if ! [[ "$(cat /proc/mdstat 2>/dev/null | grep ${part})" || "$(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "LVM2_member")" || "$(${_BLKID} -p -i -o value -s TYPE /dev/${part} | grep "crypto_LUKS")" || "$(sfdisk -c /dev/${disk} $(echo ${part} | sed -e "s#${disk}##g") 2>/dev/null | grep "5")" || "$(sfdisk -c /dev/${disk} $(echo ${part} | sed -e "s#${disk}\p##g") 2>/dev/null | grep "5")" || "$(echo ${part} | grep "[a-z]$(parted -s /dev/${disk} print 2>/dev/null | grep bios_grub | cut -d " " -f 2)$")" ]]; then
                if [[ -d ${block}/${disk}/${part} ]]; then
                    echo "/dev/${part}"
                    [[ "${1}" ]] && echo ${1}
                fi
            fi
        done
}

finddisks(){
    default_blockdevices ${1}
    additional_blockdevices ${1}
    dmraid_devices ${1}
    partitionable_raid_devices ${1}
}

findpartitions(){
    for devpath in $(finddisks); do
        default_partition_check ${1}
    done
    additional_blockdevices_partitions ${1}
    dm_devices ${1}
    dmraid_partitions ${1}
    raid_devices ${1}
    partitionable_raid_devices_partitions ${1}
}

# don't check on raid devices!
findbootloaderdisks(){
    if ! [[ "${USE_DMRAID}" = "1" ]]; then
        default_blockdevices ${1}
        additional_blockdevices ${1}
    else
        dmraid_devices ${1}
    fi
}

# don't list raid devices, lvm2 and devicemapper!
findbootloaderpartitions(){
    if ! [[ "${USE_DMRAID}" = "1" ]]; then
        for devpath in $(findbootloaderdisks); do
            default_partition_check ${1}
        done
        additional_blockdevices_partitions ${1}
    else
        dmraid_partitions ${1}
    fi
}

# find any gpt/guid formatted disks
find_gpt(){
    GUID_DETECTED=""
    for i in $(finddisks); do
        [[ "$(${_BLKID} -p -i -o value -s PTTYPE ${i})" == "gpt" ]] && GUID_DETECTED="1"
    done
}

# freeze and unfreeze xfs, as hack for grub(2) installing
freeze_xfs(){
    sync
    if [[ -x /usr/bin/xfs_freeze ]]; then
        if [[ "$(cat /proc/mounts | grep "${DESTDIR}/boot " | grep " xfs ")" ]]; then
            /usr/bin/xfs_freeze -f ${DESTDIR}/boot >/dev/null 2>&1
            /usr/bin/xfs_freeze -u ${DESTDIR}/boot >/dev/null 2>&1
        fi
        if [[ "$(cat /proc/mounts | grep "${DESTDIR} " | grep " xfs ")" ]]; then
            /usr/bin/xfs_freeze -f ${DESTDIR} >/dev/null 2>&1
            /usr/bin/xfs_freeze -u ${DESTDIR} >/dev/null 2>&1
        fi
    fi
}

mapdev(){
    partition_flag=0
    device_found=0
    # check if we use hd sd  or vd device
    if ! [[ "$(echo ${1} | grep /dev/sd)" || "$(echo ${1} | grep /dev/hd)" || "$(echo ${1} | grep /dev/vd)" ]]; then
        linuxdevice=$(echo ${1} | sed -e 's#p[0-9].*$##')
    else
        linuxdevice=$(echo ${1} | sed -e 's#[0-9].*$##g')
    fi
    if ! [[ "$(echo ${1} | grep /dev/sd)" || "$(echo ${1} | grep /dev/hd)" || "$(echo ${1} | grep /dev/vd)" ]]; then
        if [[ "$(echo ${1} | egrep 'p[0-9].*$')" ]]; then
            pnum=$(echo ${1} | sed -e 's#.*p##g')
            partition_flag=1
        fi
    else
        if [[ "$(echo ${1} | egrep '[0-9]$')" ]]; then
            # /dev/hdXY
            pnum=$(echo ${1} | cut -b9-)
            partition_flag=1
        fi
    fi
    for  dev in ${devs}; do
        if [[ "(" = $(echo ${dev} | cut -b1) ]]; then
            grubdevice="${dev}"
        else
            if [[ "${dev}" = "${linuxdevice}" ]]; then
                device_found=1
                break
            fi
        fi
    done
    if [[ "${device_found}" = "1" ]]; then
        if [[ "${partition_flag}" = "0" ]]; then
            echo "${grubdevice}"
        else
            grubdevice_stringlen=${#grubdevice}
            grubdevice_stringlen=$((${grubdevice_stringlen} - 1))
            grubdevice=$(echo ${grubdevice} | cut -b1-${grubdevice_stringlen})
            echo "${grubdevice},${pnum})"
        fi
    else
        echo "DEVICE NOT FOUND"
    fi
}

# geteditor()
# prompts the user to choose an editor
# sets EDITOR global variable
#
geteditor(){
    if ! [[ "${EDITOR}" ]]; then
        DIALOG --menu "${_geteditor}" 10 35 3 \
        "1" "${_nano}" \
        "2" "vi" 2>${ANSWER} || return 1
        case $(cat ${ANSWER}) in
            "1") EDITOR="nano" ;;
            "2") EDITOR="vi" ;;
        esac
    fi
}


# Get a list of available disks for use in the "Available disks" dialogs. This
# will print the mountpoints as follows, getting size info from /sys:
#   /dev/sda: 64000 MB
#   /dev/sdb: 64000 MB
_getavaildisks(){
    for i in $(finddisks); do
            if [[ "$(echo "${i}" | grep '/dev/mapper')" ]]; then
                # device mapper is always 512 aligned!
                # only dmraid device can be here
                echo -n "${i} : "; echo $(($(expr 512 '*' $(dmsetup status ${i} | cut -f2 -d " "))/1000000)) MB; echo "\n"
            # special block devices
            elif [[  "$(echo "${i}" | grep "/dev/rd")" ]]; then
                echo -n "${i}: "; echo $(($(expr $(cat ${block}/rd\!$(basename ${i} | sed -e 's#p.*##g')/queue/logical_block_size) '*' $(cat ${block}/rd\!$(basename ${i} | sed -e 's#p.*##g')/size))/1000000)) MB; echo "\n"
            elif [[  "$(echo "${i}" | grep "/dev/cciss")" ]]; then
                echo -n "${i}: "; echo $(($(expr $(cat ${block}/cciss\!$(basename ${i} | sed -e 's#p.*##g')/queue/logical_block_size) '*' $(cat ${block}/cciss\!$(basename ${i} | sed -e 's#p.*##g')/size))/1000000)) MB; echo "\n"
            elif [[  "$(echo "${i}" | grep "/dev/ida")" ]]; then
                echo -n "${i}: "; echo $(($(expr $(cat ${block}/ida\!$(basename ${i} | sed -e 's#p.*##g')/queue/logical_block_size) '*' $(cat ${block}/ida\!$(basename ${i} | sed -e 's#p.*##g')/size))/1000000)) MB; echo "\n"
            else
                echo -n "${i} : "; echo $(($(expr $(cat ${block}/$(basename ${i})/queue/logical_block_size) '*' $(cat ${block}/$(basename ${i})/size))/1000000)) MB; echo "\n"
            fi
    done
}

# Get a list of available partitions for use in the "Available Mountpoints" dialogs. This
# will print the mountpoints as follows, getting size info from /sys:
#   /dev/sda1: 640 MB
#   /dev/sdb2: 640 MB
_getavailpartitions(){
    for i in $(findpartitions); do
        # mmc and raid partitions
        if [[ "$(echo "${i}" | grep '/dev/md_d[0-9]')"  ||  "$(echo "${i}" | grep '/dev/md[0-9]p')" || "$(echo "${i}" | grep '/dev/mmcblk')" ]]; then
            echo -n "${i}: "; echo $(($(expr $(cat ${block}/$(basename ${i} | sed -e 's#p.*##g')/queue/logical_block_size) '*' $(cat ${block}/$(basename ${i} | sed -e 's#p.*##g')/$(basename ${i})/size))/1000000)) MB; echo "\n"
        # special block devices
        elif [[  "$(echo "${i}" | grep "/dev/rd")" ]]; then
                echo -n "${i}: "; echo $(($(expr $(cat ${block}/rd\!$(basename ${i} | sed -e 's#p.*##g')/queue/logical_block_size) '*' $(cat ${block}/rd\!$(basename ${i} | sed -e 's#p.*##g')/rd\!$(basename ${i})/size))/1000000)) MB; echo "\n"
        elif [[  "$(echo "${i}" | grep "/dev/cciss")" ]]; then
                echo -n "${i}: "; echo $(($(expr $(cat ${block}/cciss\!$(basename ${i} | sed -e 's#p.*##g')/queue/logical_block_size) '*' $(cat ${block}/cciss\!$(basename ${i} | sed -e 's#p.*##g')/cciss\!$(basename ${i})/size))/1000000)) MB; echo "\n"
        elif [[  "$(echo "${i}" | grep "/dev/ida")" ]]; then
                echo -n "${i}: "; echo $(($(expr $(cat ${block}/ida\!$(basename ${i} | sed -e 's#p.*##g')/queue/logical_block_size) '*' $(cat ${block}/ida\!$(basename ${i} | sed -e 's#p.*##g')/ida\!$(basename ${i})/size))/1000000)) MB; echo "\n"
        # raid device
        elif [[ "$(echo "${i}" | grep -v 'p' |grep '/dev/md')" ]]; then
            echo -n "${i}: "; echo $(($(expr $(cat ${block}/$(basename ${i})/queue/logical_block_size) '*' $(cat ${block}/$(basename ${i})/size))/1000000)) MB; echo "\n"
        # mapper devices
        elif [[ "$(echo "${i}" | grep '/dev/mapper')" ]]; then
            # mapper devices are always 512 aligned
            # crypt device
            if [[ "$(cryptsetup status ${i} 2>/dev/null)" ]]; then
                echo -n "${i}: "; echo $(($(expr 512 '*' $(cryptsetup status $(basename ${i}) | grep " size:" | sed -e 's#sectors##g' -e 's#size:##g'))/1000000)) MB; echo "\n"
            # dmraid device
            elif [[ "$(dmsetup info ${i} | grep 'DMRAID')"  ]]; then
                [[ "$(echo ${i} | grep 'p*[0-9]$')" ]] && echo -n "${i}: "; echo $(($(expr 512 '*' $(dmsetup status ${i} | cut -f2 -d " "))/1000000)) MB; echo "\n"
            # mapper device
            else
                echo -n "${i}: "; echo $(lvs -o lv_size --noheading --units m ${i} | sed -e 's#m##g') MB; echo "\n"
            fi
        else
            echo -n "${i}: "; echo $(($(expr $(cat ${block}/$(basename ${i} | sed -e 's#[0-9].*##g')/queue/logical_block_size) '*' $(cat ${block}/$(basename ${i} | sed -e 's#[0-9].*##g')/$(basename ${i})/size))/1000000)) MB; echo "\n"
        fi
    done
}


# Disable all luks encrypted devices

#_dmraid_update
_dmraid_update(){
    DIALOG --infobox "${_deactivateraid}" 0 0
    dmraid -an >/dev/null 2>&1
    if [[ "${DETECTED_LVM}" = "1" || "${DETECTED_LUKS}" = "1" ]]; then
        DIALOG --defaultno --yesno "${_setupraid}" 0 0 && RESETDM="1"
        if [[ "${RESETDM}" = "1" ]]; then
            DIALOG --infobox "${_resetraid}" 0 0
            dmsetup remove_all >/dev/null 2>&1
        fi
    else
        DIALOG --infobox "${_resetdm}" 0 0
        dmsetup remove_all >/dev/null 2>&1
    fi
    DIALOG --infobox "${_reactivatedm}" 0 0
    dmraid -ay -Z >/dev/null 2>&1
}

#helpbox for raid
_helpraid(){
DIALOG --msgbox "${_help_raid}" 0 0
}

# Create raid or raid_partition
_raid(){
    MDFINISH=""
    while [[ "${MDFINISH}" != "DONE" ]]; do
        activate_special_devices
        : >/tmp/.raid
        : >/tmp/.raid-spare
        # check for devices
        PARTS="$(findpartitions _)"
        ALREADYINUSE=""
        #hell yeah, this is complicated! kill software raid devices already in use.
        ALREADYINUSE=$(cat /proc/mdstat 2>/dev/null | grep ^md | sed -e 's# :.*linear##g' -e 's# :.*raid[0-9][0-9]##g' -e 's# :.*raid[0-9]##g' -e 's#\[[0-9]\]##g')
        for i in ${ALREADYINUSE}; do
            PARTS=$(echo ${PARTS} | sed -e "s#/dev/${i}\ _##g" -e "s#/dev/${i}\p[0-9]\ _##g")
            k=$(echo /dev/${i} | sed -e 's#[0-9]##g')
            if ! [[ "$(echo ${k} | grep ^md)" ]]; then
                PARTS=$(echo ${PARTS} | sed -e "s#${k}\ _##g")
            fi
        done
        # skip encrypted mapper devices which contain raid devices
        ALREADYINUSE=""
        for i in $(ls /dev/mapper/* 2>/dev/null | grep -v control); do
            cryptsetup status ${i} 2>/dev/null | grep -q "device:.*/dev/md" && ALREADYINUSE="${ALREADYINUSE} ${i}"
        done
        # skip lvm with raid devices
        for devpath in $(pvs -o pv_name --noheading); do
            # skip simple lvm device with raid device
            if [[ "$(echo ${devpath} | grep /dev/md)" ]]; then
                killvolumegroup="$(echo $(pvs -o vg_name --noheading ${devpath}))"
                ALREADYINUSE="${ALREADYINUSE} $(ls /dev/mapper/${killvolumegroup}-*)"
            fi
            # skip encrypted raid device
            if [[ "$(echo ${devpath} | grep dm-)" ]]; then
                if [[ "$(cryptsetup status $(basename ${devpath}) | grep "device:.*/dev/md")" ]]; then
                   killvolumegroup="$(echo $(pvs -o vg_name --noheading ${devpath}))"
                   ALREADYINUSE="${ALREADYINUSE} $(ls /dev/mapper/${killvolumegroup}-*)"
                fi
            fi
        done
        # skip already encrypted volume devices with raid device
        for devpath in $(ls /dev/mapper/ 2>/dev/null | grep -v control); do
            realdevice="$(cryptsetup status ${devpath} 2>/dev/null | grep "device:.*/dev/mapper/" | sed -e 's#.*\ ##g')"
            if [[ "$(lvs ${realdevice} 2>/dev/null)" ]]; then
                vg="$(echo $(lvs -o vg_name --noheading ${realdevice}))"
                if [[ "$(pvs -o pv_name,vg_name --noheading | grep "${vg}$" | grep "/dev/md")" ]]; then
                   ALREADYINUSE="${ALREADYINUSE} /dev/mapper/${devpath}"
                fi
            fi
        done
        for i in ${ALREADYINUSE}; do
            PARTS=$(echo ${PARTS} | sed -e "s#${i}\ _##g")
        done
        # break if all devices are in use
        if [[ "${PARTS}" = "" ]]; then
            DIALOG --msgbox "${_alldm}" 0 0
            return 1
        fi
        # enter raid device name
        RAIDDEVICE=""
        while [[ "${RAIDDEVICE}" = "" ]]; do
            if [[ "${RAID_PARTITION}" = "" ]]; then
                DIALOG --inputbox "${_enter_node}" 15 65 "/dev/md0" 2>${ANSWER} || return 1
            fi
            if [[ "${RAID_PARTITION}" = "1" ]]; then
                DIALOG --inputbox "${_enter_node2}" 15 65 "/dev/md_d0" 2>${ANSWER} || return 1
            fi
            RAIDDEVICE=$(cat ${ANSWER})
            if [[ "$(cat /proc/mdstat 2>/dev/null | grep "^$(echo ${RAIDDEVICE} | sed -e 's#/dev/##g')")" ]]; then
                DIALOG --msgbox "${_error_node}" 8 65
                RAIDDEVICE=""
            fi
        done
        RAIDLEVELS="linear - raid0 - raid1 - raid4 - raid5 - raid6 - raid10 -"
        DIALOG --menu "${_raid_level}" 21 50 11 ${RAIDLEVELS} 2>${ANSWER} || return 1
        LEVEL=$(cat ${ANSWER})
        # raid5 and raid10 support parity parameter
        PARITY=""
        if [[ "${LEVEL}" = "raid5" || "${LEVEL}" = "raid6" || "${LEVEL}" = "raid10" ]]; then
            PARITYLEVELS="left-asymmetric - left-symmetric - right-asymmetric - right-symmetric -"
            DIALOG --menu "${_select_partiy}" 21 50 13 ${PARITYLEVELS} 2>${ANSWER} || return 1
            PARTIY=$(cat ${ANSWER})
        fi
        # show all devices with sizes
        DIALOG --msgbox "DISKS:\n$(_getavaildisks)\n\nPARTITIONS:\n$(_getavailpartitions)" 0 0
        # select the first device to use, no missing option available!
        RAIDNUMBER=1
        DIALOG --menu "${__select_dv} ${RAIDNUMBER}" 21 50 13 ${PARTS} 2>${ANSWER} || return 1
        PART=$(cat ${ANSWER})
        echo "${PART}" >>/tmp/.raid
        while [[ "${PART}" != "DONE" ]]; do
            RAIDNUMBER=$((${RAIDNUMBER} + 1))
            # clean loop from used partition and options
            PARTS="$(echo ${PARTS} | sed -e "s#${PART}\ _##g" -e 's#MISSING\ _##g' -e 's#SPARE\ _##g')"
            # raid0 doesn't support missing devices
            ! [[ "${LEVEL}" = "raid0" || "${LEVEL}" = "linear" ]] && MDEXTRA="MISSING _"
            # add more devices
            DIALOG --menu "${_select_addv} ${RAIDNUMBER}" 21 50 13 ${PARTS} ${MDEXTRA} DONE _ 2>${ANSWER} || return 1
            PART=$(cat ${ANSWER})
            SPARE=""
            ! [[ "${LEVEL}" = "raid0" || "${LEVEL}" = "linear" ]] && DIALOG --yesno --defaultno "Would you like to use ${PART} as spare device?" 0 0 && SPARE="1"
            [[ "${PART}" = "DONE" ]] && break
            if [[ "${PART}" = "MISSING" ]]; then
                DIALOG --yesno "${_degraded_raid} ${RAIDDEVICE}?" 0 0 && DEGRADED="missing"
                echo "${DEGRADED}" >>/tmp/.raid
            else
                if [[ "${SPARE}" = "1" ]]; then
                    echo "${PART}" >>/tmp/.raid-spare
                else
                    echo "${PART}" >>/tmp/.raid
                fi
            fi
        done
        # final step ask if everything is ok?
        DIALOG --yesno "${_question_raid1} ${RAIDDEVICE} ${_question_raid2}\n\nLEVEL:\n${LEVEL}\n\nDEVICES:\n$(for i in $(cat /tmp/.raid); do echo "${i}\n";done)\nSPARES:\n$(for i in $(cat /tmp/.raid-spare); do echo "${i}\n";done)" 0 0 && MDFINISH="DONE"
    done
    _createraid
}

# create raid device
_createraid(){
    DEVICES="$(echo -n $(cat /tmp/.raid))"
    SPARES="$(echo -n $(cat /tmp/.raid-spare))"
    # combine both if spares are available, spares at the end!
    [[ -n ${SPARES} ]] && DEVICES="${DEVICES} ${SPARES}"
    # get number of devices
    RAID_DEVICES="$(cat /tmp/.raid | wc -l)"
    SPARE_DEVICES="$(cat /tmp/.raid-spare | wc -l)"
    # generate options for mdadm
    RAIDOPTIONS="--force --run --level=${LEVEL}"
    [[ "$(echo ${RAIDDEVICE} | grep /md_d[0-9])" ]] && RAIDOPTIONS="${RAIDOPTIONS} -a mdp"
    ! [[ "${RAID_DEVICES}" = "0" ]] && RAIDOPTIONS="${RAIDOPTIONS} --raid-devices=${RAID_DEVICES}"
    ! [[ "${SPARE_DEVICES}" = "0" ]] && RAIDOPTIONS="${RAIDOPTIONS} --spare-devices=${SPARE_DEVICES}"
    ! [[ "${PARITY}" = "" ]] && RAIDOPTIONS="${RAIDOPTIONS} --layout=${PARITY}"
    DIALOG --infobox "Creating ${RAIDDEVICE}..." 0 0
    mdadm --create ${RAIDDEVICE} ${RAIDOPTIONS} ${DEVICES} >${LOG} 2>&1
    if [[ $? -gt 0 ]]; then
        DIALOG --msgbox "Error creating ${RAIDDEVICE} (see ${LOG} for details)." 0 0
        return 1
    fi
    if [[ "$(echo ${RAIDDEVICE} | grep /md_d[0-9])" ]]; then
        # switch for mbr usage
        set_guid
        if [[ "${GUIDPARAMETER}" = "" ]]; then
            DIALOG --msgbox "${_parted_raid}" 18 70
            clear
            parted ${RAIDDEVICE} print
            parted ${RAIDDEVICE}
        else
            DISC=${RAIDDEVICE}
            RUN_CGDISK="1"
            CHECK_BIOS_BOOT_GRUB=""
            CHECK_UEFISYS_PART=""
            check_gpt
        fi
    fi
}

# help for lvm
_helplvm(){
DIALOG --msgbox "${_help_lvm}" 0 0
}

# Creates physical volume
_createpv(){
    PVFINISH=""
    while [[ "${PVFINISH}" != "DONE" ]]; do
        activate_special_devices
        : >/tmp/.pvs-create
        PVDEVICE=""
        PARTS="$(findpartitions _)"
        ALREADYINUSE=""
        # skip volume devices
        for i in $(ls /dev/mapper/* | grep -v control); do
            [[ "$(lvs ${i} 2>/dev/null)" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
        done
        # skip already encrypted volume devices
        for devpath in $(ls /dev/mapper/ 2>/dev/null | grep -v control); do
            realdevice="$(cryptsetup status ${devpath} 2>/dev/null | grep "device:.*/dev/mapper/" | sed -e 's#.*\ ##g')"
            if ! [[ "${realdevice}" = "" ]]; then
                [[ "$(lvs ${realdevice} 2>/dev/null)" ]] && ALREADYINUSE="${ALREADYINUSE} /dev/mapper/${devpath}"
            fi
        done
        # skip md devices, which already have lvm devices!
        for i in ${PARTS}; do
            mdcheck="$(echo ${i} | sed -e 's#/dev/##g')"
            if ! [[ "$(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null)" = "" ]]; then
                for k in $(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null); do
                    # check encrypted volume
                    realdevice="$(cryptsetup status $(cat ${k}/dm/name) 2>/dev/null | grep "device:.*/dev/mapper/" | sed -e 's#.*\ ##g')"
                    [[ "$(lvs ${realdevice} 2>/dev/null)" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                    # check on normal lvs
                    [[ "$(lvs /dev/mapper/$(cat ${k}/dm/name) 2>/dev/null)" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                done
            fi
        done
        # skip md partition devices, which already have lvm devices!
        for i in ${PARTS}; do
            mdcheck="$(echo ${i} | grep /dev/md*p | sed -e 's#p.*##g' -e 's#/dev/##g')"
            if [[ "$(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null)" != "" && "${mdcheck}" != "" ]]; then
                for k in $(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null); do
                    # check encrypted volume
                    realdevice="$(cryptsetup status $(cat ${k}/dm/name) 2>/dev/null | grep "device:.*/dev/mapper/" | sed -e 's#.*\ ##g')"
                    [[ "$(lvs ${realdevice} 2>/dev/null)" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                   # check on normal lvs
                    [[ "$(lvs /dev/mapper/$(cat ${k}/dm/name) 2>/dev/null)" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                done
            fi
        done
        for i in ${ALREADYINUSE}; do
            PARTS=$(echo ${PARTS} | sed -e "s#${i}\ _##g")
        done
        # break if all devices are in use
        if [[ "${PARTS}" = "" ]]; then
            DIALOG --msgbox "${_no_raid_left}" 0 0
            return 1
        fi
        # show all devices with sizes
        DIALOG --msgbox "DISKS:\n$(_getavaildisks)\n\nPARTITIONS:\n$(_getavailpartitions)\n\n" 0 0
        # select the first device to use
        DEVNUMBER=1
        DIALOG --menu "Select device number ${DEVNUMBER} for physical volume" 21 50 13 ${PARTS} 2>${ANSWER} || return 1
        PART=$(cat ${ANSWER})
        echo "${PART}" >>/tmp/.pvs-create
        while [[ "${PART}" != "DONE" ]]; do
            DEVNUMBER=$((${DEVNUMBER} + 1))
            # clean loop from used partition and options
            PARTS="$(echo ${PARTS} | sed -e "s#${PART}\ _##g")"
            # add more devices
            DIALOG --menu "${_select_dvnr1} ${DEVNUMBER} ${_select_dvnr2}" 21 50 13 ${PARTS} DONE _ 2>${ANSWER} || return 1
            PART=$(cat ${ANSWER})
            [[ "${PART}" = "DONE" ]] && break
            echo "${PART}" >>/tmp/.pvs-create
        done
        # final step ask if everything is ok?
        DIALOG --yesno "${_create_vm}\n$(cat /tmp/.pvs-create | sed -e 's#$#\\n#g')" 0 0 && PVFINISH="DONE"
    done
    DIALOG --infobox "${_creating_vm} ${PART}..." 0 0
    PART="$(echo -n $(cat /tmp/.pvs-create))"
    pvcreate ${PART} >${LOG} 2>&1
    if [[ $? -gt 0 ]]; then
        DIALOG --msgbox "Error creating physical volume on ${PART} (see ${LOG} for details)." 0 0
        return 1
    fi
}

#find physical volumes that are not in use
findpv(){
    for i in $(pvs -o pv_name --noheading);do
        if [[ "$(pvs -o vg_name --noheading ${i})" = "      " ]]; then
                if [[ "$(echo ${i} | grep /dev/dm-)" ]]; then
                    for k in $(ls /dev/mapper | grep -v control); do
                        if [[ -h /dev/mapper/${k} ]]; then
                            pv="$(basename ${i})"
                            if [[ "$(readlink /dev/mapper/${k} | grep ${pv}$)" ]]; then
                                echo "${i}" | sed -e "s#/dev/dm-.*#/dev/mapper/${k}#g"
                                [[ "${1}" ]] && echo ${1}
                            fi
                        fi
                    done
                else
                    echo "${i}"
                    [[ "${1}" ]] && echo ${1}
                fi
        fi
    done
}

getavailablepv(){
    for i in "$(pvs -o pv_name,pv_size --noheading --units m)"; do
            if [[ "$(echo ${i} | grep /dev/dm-)" ]]; then
                for k in $(ls /dev/mapper | grep -v control); do
                    if [[ -h /dev/mapper/${k} ]]; then
                        pv="$(basename ${i})"
                        if [[ "$(readlink /dev/mapper/${k} | grep ${pv}$)" ]]; then
                            echo "${i}" | sed -e "s#/dev/dm-.* #/dev/mapper/${k} #g" | sed -e 's#$#\\n#'
                        fi
                    fi
                 done
            else
                echo "${i}" | sed -e 's#$#\\n#'
            fi
    done
}

#find volume groups that are not already full in use
findvg(){
    for dev in $(vgs -o vg_name --noheading);do
        if ! [[ "$(vgs -o vg_free --noheading --units m ${dev} | grep " 0m$")" ]]; then
            echo "${dev}"
            [[ "${1}" ]] && echo ${1}
        fi
    done
}

getavailablevg(){
    for i in $(vgs -o vg_name,vg_free --noheading --units m); do
        if ! [[ "$(echo ${i} | grep " 0m$")" ]]; then
            echo ${i} | sed -e 's#$#\\n#'
        fi
    done
}

# Creates volume group
_createvg(){
    VGFINISH=""
    while [[ "${VGFINISH}" != "DONE" ]]; do
        : >/tmp/.pvs
        VGDEVICE=""
        PVS=$(findpv _)
        # break if all devices are in use
        if [[ "${PVS}" = "" ]]; then
            DIALOG --msgbox "${_no_vg_left}" 0 0
            return 1
        fi
        # enter volume group name
        VGDEVICE=""
        while [[ "${VGDEVICE}" = "" ]]; do
            DIALOG --inputbox "${_enter_vg}\nfoogroup\n<yourvolumegroupname>\n\n" 15 65 "foogroup" 2>${ANSWER} || return 1
            VGDEVICE=$(cat ${ANSWER})
            if [[ "$(vgs -o vg_name --noheading 2>/dev/null | grep "^  $(echo ${VGDEVICE})")" ]]; then
                DIALOG --msgbox "${_error_vg}" 8 65
                VGDEVICE=""
            fi
        done
        # show all devices with sizes
        DIALOG --msgbox "Physical Volumes:\n$(getavailablepv)\n\n${_info_vg}" 0 0
        # select the first device to use, no missing option available!
        PVNUMBER=1
        DIALOG --menu "${_select_pvg} ${PVNUMBER} ${_for} ${VGDEVICE}" 21 50 13 ${PVS} 2>${ANSWER} || return 1
        PV=$(cat ${ANSWER})
        echo "${PV}" >>/tmp/.pvs
        while [[ "${PVS}" != "DONE" ]]; do
            PVNUMBER=$((${PVNUMBER} + 1))
            # clean loop from used partition and options
            PVS="$(echo ${PVS} | sed -e "s#${PV}\ _##g")"
            # add more devices
            DIALOG --menu "${_select_ad_pvg} ${PVNUMBER} ${_for} ${VGDEVICE}" 21 50 13 ${PVS} DONE _ 2>${ANSWER} || return 1
            PV=$(cat ${ANSWER})
            [[ "${PV}" = "DONE" ]] && break
            echo "${PV}" >>/tmp/.pvs
        done
        # final step ask if everything is ok?
        DIALOG --yesno "${_create_vg}\n\n${VGDEVICE}\n\nPhysical Volumes:\n$(cat /tmp/.pvs | sed -e 's#$#\\n#g')" 0 0 && VGFINISH="DONE"
    done
    DIALOG --infobox "${_creating_vg} ${VGDEVICE}..." 0 0
    PV="$(echo -n $(cat /tmp/.pvs))"
    vgcreate ${VGDEVICE} ${PV} >${LOG} 2>&1
    if [[ $? -gt 0 ]]; then
        DIALOG --msgbox "Error creating Volume Group ${VGDEVICE} (see ${LOG} for details)." 0 0
        return 1
    fi
}

# Creates logical volume
_createlv(){
    LVFINISH=""
    while [[ "${LVFINISH}" != "DONE" ]]; do
        LVDEVICE=""
        LV_SIZE_SET=""
        LVS=$(findvg _)
        # break if all devices are in use
        if [[ "${LVS}" = "" ]]; then
            DIALOG --msgbox "No Volume Groups with free space available for Logical Volume creation." 0 0
            return 1
        fi
        # show all devices with sizes
        DIALOG --msgbox "Volume Groups:\n$(getavailablevg)\n\nVolume Groups that are not shown, are already 100% in use!" 0 0
        DIALOG --menu "Select Volume Group" 21 50 13 ${LVS} 2>${ANSWER} || return 1
        LV=$(cat ${ANSWER})
        # enter logical volume name
        LVDEVICE=""
        while [[ "${LVDEVICE}" = "" ]]; do
            DIALOG --inputbox "Enter the Logical Volume name:\nfooname\n<yourvolumename>\n\n" 15 65 "fooname" 2>${ANSWER} || return 1
            LVDEVICE=$(cat ${ANSWER})
            if [[ "$(lvs -o lv_name,vg_name --noheading 2>/dev/null | grep " $(echo ${LVDEVICE}) $(echo ${LV})"$)" ]]; then
                DIALOG --msgbox "ERROR: You have defined 2 identical Logical Volume names! Please enter another name." 8 65
                LVDEVICE=""
            fi
        done
        while [[ "${LV_SIZE_SET}" = "" ]]; do
            LV_ALL=""
            DIALOG --inputbox "Enter the size (MB) of your Logical Volume,\nMinimum value is > 0.\n\nVolume space left: $(vgs -o vg_free --noheading --units m ${LV})B\n\nIf you enter no value, all free space left will be used." 10 65 "" 2>${ANSWER} || return 1
                LV_SIZE=$(cat ${ANSWER})
                if [[ "${LV_SIZE}" = "" ]]; then
                    DIALOG --yesno "Would you like to create Logical Volume with no free space left?" 0 0 && LV_ALL="1"
                    if ! [[ "${LV_ALL}" = "1" ]]; then
                         LV_SIZE=0
                    fi
                fi
                if [[ "${LV_SIZE}" = "0" ]]; then
                    DIALOG --msgbox "ERROR: You have entered a invalid size, please enter again." 0 0
                else
                    if [[ "${LV_SIZE}" -ge "$(vgs -o vg_free --noheading --units m | sed -e 's#m##g')" ]]; then
                        DIALOG --msgbox "ERROR: You have entered a too large size, please enter again." 0 0
                    else
                        LV_SIZE_SET=1
                    fi
                fi
        done
        #Contiguous doesn't work with +100%FREE
        LV_CONTIGUOUS=""
        [[ "${LV_ALL}" = "" ]] && DIALOG --defaultno --yesno "Would you like to create Logical Volume as a contiguous partition, that means that your space doesn't get partitioned over one or more disks nor over non-contiguous physical extents.\n(usefull for swap space etc.)?" 0 0 && LV_CONTIGUOUS="1"
        if [[ "${LV_CONTIGUOUS}" = "1" ]]; then
            CONTIGUOUS=yes
            LV_EXTRA="-C y"
        else
            CONTIGUOUS=no
            LV_EXTRA=""
        fi
        [[ "${LV_SIZE}" = "" ]] && LV_SIZE="All free space left"
        # final step ask if everything is ok?
        DIALOG --yesno "Would you like to create Logical Volume ${LVDEVICE} like this?\nVolume Group:\n${LV}\nVolume Size:\n${LV_SIZE}\nContiguous Volume:\n${CONTIGUOUS}" 0 0 && LVFINISH="DONE"
    done
    DIALOG --infobox "Creating Logical Volume ${LVDEVICE}..." 0 0
    if [[ "${LV_ALL}" = "1" ]]; then
        lvcreate ${LV_EXTRA} -l +100%FREE ${LV} -n ${LVDEVICE} >${LOG} 2>&1
    else
        lvcreate ${LV_EXTRA} -L ${LV_SIZE} ${LV} -n ${LVDEVICE} >${LOG} 2>&1
    fi
    if [[ $? -gt 0 ]]; then
        DIALOG --msgbox "Error creating Logical Volume ${LVDEVICE} (see ${LOG} for details)." 0 0
        return 1
    fi
}

# enter luks name
_enter_luks_name(){
    LUKSDEVICE=""
    while [[ "${LUKSDEVICE}" = "" ]]; do
        DIALOG --inputbox "Enter the name for luks encrypted device ${PART}:\nfooname\n<yourname>\n\n" 15 65 "fooname" 2>${ANSWER} || return 1
        LUKSDEVICE=$(cat ${ANSWER})
        if ! [[ "$(cryptsetup status ${LUKSDEVICE} | grep inactive)" ]]; then
            DIALOG --msgbox "ERROR: You have defined 2 identical luks encryption device names! Please enter another name." 8 65
            LUKSDEVICE=""
        fi
    done
}

# enter luks passphrase
_enter_luks_passphrase (){
    LUKSPASSPHRASE=""
    while [[ "${LUKSPASSPHRASE}" = "" ]]; do
        DIALOG --insecure --passwordbox "Enter passphrase for luks encrypted device ${PART}:" 0 0 2>${ANSWER} || return 1
        LUKSPASS=$(cat ${ANSWER})
        DIALOG --insecure --passwordbox "Retype passphrase for luks encrypted device ${PART}:" 0 0 2>${ANSWER} || return 1
        LUKSPASS2=$(cat ${ANSWER})
        if [[ "${LUKSPASS}" = "${LUKSPASS2}" ]]; then
            LUKSPASSPHRASE=${LUKSPASS}
            echo ${LUKSPASSPHRASE} > /tmp/passphrase-${LUKSDEVICE}
            LUKSPASSPHRASE=/tmp/passphrase-${LUKSDEVICE}
        else
             DIALOG --msgbox "Passphrases didn't match, please enter again." 0 0
        fi
    done
}

# opening luks
_opening_luks(){
    DIALOG --infobox "Opening encrypted ${PART}..." 0 0
    luksOpen_success="0"
    while [[ "${luksOpen_success}" = "0" ]]; do
        cryptsetup luksOpen ${PART} ${LUKSDEVICE} >${LOG} <${LUKSPASSPHRASE} && luksOpen_success=1
        if [[ "${luksOpen_success}" = "0" ]]; then
            DIALOG --msgbox "Error: Passphrases didn't match, please enter again." 0 0
            _enter_luks_passphrase || return 1
        fi
    done
    DIALOG --yesno "Would you like to save the passphrase of luks device in /etc/$(basename ${LUKSPASSPHRASE})?\nName:${LUKSDEVICE}" 0 0 || LUKSPASSPHRASE="ASK"
    echo ${LUKSDEVICE} ${PART} /etc/$(basename ${LUKSPASSPHRASE}) >> /tmp/.crypttab
}

# help for luks
_helpluks(){
	DIALOG --msgbox "${_help_luks}" 0 0
}

# create luks device
_luks(){
    NAME_SCHEME_PARAMETER_RUN=""
    LUKSFINISH=""
    while [[ "${LUKSFINISH}" != "DONE" ]]; do
        activate_special_devices
        PARTS="$(findpartitions _)"
        ALREADYINUSE=""
        # skip already encrypted devices, device mapper!
        for devpath in $(ls /dev/mapper 2>/dev/null | grep -v control); do
            [[ "$(cryptsetup status ${devpath})" ]] && ALREADYINUSE="${ALREADYINUSE} /dev/mapper/${devpath}"
        done
        # skip already encrypted devices, device mapper with encrypted parts!
        for devpath in $(pvs -o pv_name --noheading); do
             if [[ "$(echo ${devpath} | grep dm-)" ]]; then
                if [[ "$(cryptsetup status $(basename ${devpath}))" ]]; then
                   killvolumegroup="$(echo $(pvs -o vg_name --noheading ${devpath}))"
                   ALREADYINUSE="${ALREADYINUSE} $(ls /dev/mapper/${killvolumegroup}-*)"
                fi
             fi
             # remove hidden crypt by md device
             if [[ "$(echo ${devpath} | grep /dev/md)" ]]; then
                 mdcheck="$(echo ${devpath} | sed -e 's#/dev/##g')"
                 if ! [[ "$(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null)" = "" ]]; then
                     for k in $(find ${block}/${mdcheck}/slaves/ -name 'dm*'); do
                         if [[ "$(cryptsetup status $(cat ${k}/dm/name))" ]]; then
                             killvolumegroup="$(echo $(pvs -o vg_name --noheading ${devpath}))"
                             ALREADYINUSE="${ALREADYINUSE} $(ls /dev/mapper/${killvolumegroup}-*)"
                         fi
                     done
                 fi
             fi
        done
        # skip md devices, which already has encrypted devices!
        for i in ${PARTS}; do
            mdcheck="$(echo ${i} | sed -e 's#/dev/##g')"
            if ! [[ "$(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null)" = "" ]]; then
                for k in $(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null); do
                    [[ "$(cryptsetup status $(cat ${k}/dm/name))"  ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                    # check lvm devices if encryption was used!
                    if [[ "$(lvs /dev/mapper/$(cat ${k}/dm/name) 2>/dev/null)" ]]; then
                        for devpath in ${ALREADYINUSE}; do
                            [[ "$(echo ${devpath} | grep "/dev/mapper/$(cat ${k}/dm/name)"$)" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                        done
                    fi
                done
            fi
        done
        # skip md partition devices, which already has encrypted devices!
        for i in ${PARTS}; do
            mdcheck="$(echo ${i} | grep /dev/md*p | sed -e 's#p.*##g' -e 's#/dev/##g')"
            if [[ "$(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null)" != "" && "${mdcheck}" != "" ]]; then
                for k in $(find ${block}/${mdcheck}/slaves/ -name 'dm*' 2>/dev/null); do
                    [[ "$(cryptsetup status $(cat ${k}/dm/name))" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                    # check lvm devices if encryption was used!
                    if [[ "$(lvs /dev/mapper/$(cat ${k}/dm/name) 2>/dev/null)" ]]; then
                        for devpath in ${ALREADYINUSE}; do
                            [[ "$(echo ${devpath} | grep "/dev/mapper/$(cat ${k}/dm/name)"$)" ]] && ALREADYINUSE="${ALREADYINUSE} ${i}"
                        done
                    fi
                done
            fi
        done
        for i in ${ALREADYINUSE}; do
            PARTS=$(echo ${PARTS} | sed -e "s#${i}\ _##g")
        done
        # break if all devices are in use
        if [[ "${PARTS}" = "" ]]; then
            DIALOG --msgbox "No devices left for luks encryption." 0 0
            return 1
        fi
        # show all devices with sizes
        DIALOG --msgbox "DISKS:\n$(_getavaildisks)\n\nPARTITIONS:\n$(_getavailpartitions)\n\n" 0 0
        DIALOG --menu "Select device for luks encryption" 21 50 13 ${PARTS} 2>${ANSWER} || return 1
        PART=$(cat ${ANSWER})
        # enter luks name
        _enter_luks_name
        ### TODO: offer more options for encrypt!
        # final step ask if everything is ok?
        DIALOG --yesno "Would you like to encrypt luks device below?\nName:${LUKSDEVICE}\nDevice:${PART}\n" 0 0 && LUKSFINISH="DONE"
    done
    _enter_luks_passphrase
    DIALOG --infobox "Encrypting ${PART}..." 0 0
    cryptsetup -c aes-cbc-essiv:sha256 -s 128 luksFormat ${PART} >${LOG} <${LUKSPASSPHRASE}
    _opening_luks
}

check_gpt(){
    GUID_DETECTED=""
    [[ "$(${_BLKID} -p -i -o value -s PTTYPE ${DISC})" == "gpt" ]] && GUID_DETECTED="1"

    if [[ "${GUID_DETECTED}" == "" ]]; then
        DIALOG --defaultno --yesno "Setup detected no GUID (gpt) partition table on ${DISC}.\n\nDo you want to convert the existing MBR table in ${DISC} to a GUID (gpt) partition table?\n\nNOTE:\nBIOS-GPT boot may not work in some Lenovo systems (irrespective of the bootloader used). " 0 0 || return 1
        sgdisk --mbrtogpt ${DISC} > ${LOG} && GUID_DETECTED="1"
    fi

    if [[ "${GUID_DETECTED}" == "1" ]]; then
        if [[ "${CHECK_UEFISYS_PART}" == "1" ]]; then
            check_uefisyspart
        fi

        if [[ "${CHECK_BIOS_BOOT_GRUB}" == "1" ]]; then
            if ! [[ "$(sgdisk -p ${DISC} | grep 'EF02')" ]]; then
                DIALOG --msgbox "Setup detected no BIOS BOOT PARTITION in ${DISC}. Please create a >=1 MB BIOS Boot partition for grub-bios GPT support." 0 0
                RUN_CGDISK="1"
            fi
        fi
    fi

    if [[ "${RUN_CGDISK}" == "1" ]]; then
        DIALOG --msgbox "Now you'll be put into cgdisk where you can partition your hard drive.\nYou should make a swap partition and as many data partitions as you will need." 18 70
        clear && cgdisk ${DISC}
    fi
}

## check and mount UEFI SYSTEM PARTITION at /boot/efi
check_uefisyspart(){

    if [[ "$(${_BLKID} -p -i -o value -s PTTYPE ${DISC})" != "gpt" ]]; then
        DIALOG --msgbox "Setup detected no GUID (gpt) partition table on ${DISC}.\nUEFI boot requires ${DISC} to be partitioned as GPT.\nSetup will now try to non-destructively convert ${DISC} to GPT using sgdisk." 0 0
        sgdisk --mbrtogpt "${DISC}" > "${LOG}" && GUID_DETECTED="1"
    fi

    if [[ ! "$(sgdisk -p ${DISC} | grep 'EF00')" ]]; then
        DIALOG --msgbox "Setup detected no UEFI SYSTEM PARTITION in ${DISC}. You will now be put into cgdisk. Please create a >=512 MiB partition with gdisk type code EF00 .\nWhen prompted (later) to format as FAT32, say Yes.\nIf you already have a >=512 MiB FAT32 UEFI SYSTEM Partition, check whether that partition has EF00 gdisk type code." 0 0
        clear && cgdisk "${DISC}"
        RUN_CGDISK=""
    fi

    if [[ "$(sgdisk -p ${DISC} | grep 'EF00')" ]]; then
        UEFISYS_PART_NUM="$(sgdisk -p ${DISC} | grep 'EF00' | tail -n +1 | awk '{print $1}')"
        UEFISYS_PART="${DISC}${UEFISYS_PART_NUM}"

        if [[ "$(${_BLKID} -p -i -o value -s TYPE ${UEFISYS_PART})" == "vfat" ]]; then
            if [[ "$(${_BLKID} -p -i -o value -s VERSION ${UEFISYS_PART})" != "FAT32" ]]; then
                ## Check whether UEFISYS is FAT32 (specifically), otherwise warn the user (but do not exit).
                DIALOG --defaultno --yesno "UEFI SYSTEM PARTIION ${UEFISYS_PART} is not FAT32 formatted. Some UEFI firmwares may not work properly with a FAT16 or FAT12 filesystem in the UEFISYS partition.\nDo you want to format ${UEFISYS_PART} as FAT32?" 0 0 && _FORMAT_UEFISYS_FAT32="1"
            fi
        else
            ## Check whether UEFISYS is FAT, otherwise inform the user and offer to format the partition as FAT32.
            DIALOG --defaultno --yesno "UEFI Specification requires UEFI SYSTEM PARTIION to be formatted as FAT32.\nDo you want to format ${UEFISYS_PART} as FAT32?" 0 0 && _FORMAT_UEFISYS_FAT32="1"
        fi

        umount "${DESTDIR}/boot/efi" &> /dev/null
        umount "${UEFISYS_PART}" &> /dev/null
        rm -rf "${DESTDIR}/boot/efi"

        if [[ "${_FORMAT_UEFISYS_FAT32}" == "1" ]]; then
            mkfs.vfat -F32 -n "ESP" "${UEFISYS_PART}"
        fi

        mkdir -p "${DESTDIR}/boot/efi"

        if [[ "$(${_BLKID} -p -i -o value -s TYPE ${UEFISYS_PART})" == "vfat" ]]; then
            mount -o rw,flush -t vfat "${UEFISYS_PART}" "${DESTDIR}/boot/efi"
        else
            DIALOG --msgbox "${UEFISYS_PART} is not formatted using FAT filesystem. Setup will go ahead but there might be issues using non-FAT FS for UEFISYS partition." 0 0

            mount -o rw "${UEFISYS_PART}" "${DESTDIR}/boot/efi"
        fi

        ## Fix (possible) case-sensitivity issues
        if [[ -d "${DESTDIR}/boot/efi/efi" ]]; then
            mv "${DESTDIR}/boot/efi/efi" "${DESTDIR}/boot/efi/EFI_"
            mv "${DESTDIR}/boot/efi/EFI_" "${DESTDIR}/boot/efi/EFI"
        fi

        [[ ! -d "${DESTDIR}/boot/efi/EFI" ]] && mkdir -p "${DESTDIR}/boot/efi/EFI"
    else
        DIALOG --msgbox "Setup did not find any UEFI SYSTEM PARTITION in ${DISC}. Please create a >=512MiB FAT32 partition with gdisk type code EFOO and try again." 0 0
        return 1
    fi

}



# scan and update btrfs devices
btrfs_scan(){
    btrfs device scan >/dev/null 2>&1
}

# mount btrfs for checks
mount_btrfs(){
    btrfs_scan
    BTRFSMP="$(mktemp -d /tmp/brtfsmp.XXXX)"
    mount ${PART} ${BTRFSMP}
}

# unmount btrfs after checks done
umount_btrfs(){
    umount ${BTRFSMP}
    rm -r ${BTRFSMP}
}

# Set BTRFS_DEVICES on detected btrfs devices
find_btrfs_raid_devices(){
    btrfs_scan
    if [[ "${DETECT_CREATE_FILESYSTEM}" = "no" && "${FSTYPE}" = "btrfs" ]]; then
        for i in $(btrfs filesystem show ${PART} | cut -d " " -f 11); do
            BTRFS_DEVICES="${BTRFS_DEVICES}#${i}"
        done
    fi
}

find_btrfs_raid_bootloader_devices(){
    btrfs_scan
    BTRFS_COUNT=1
    if [[ "$(${_BLKID} -p -i  ${bootdev} -o value -s TYPE)" = "btrfs" ]]; then
        BTRFS_DEVICES=""
        for i in $(btrfs filesystem show ${bootdev} | cut -d " " -f 11); do
            BTRFS_DEVICES="${BTRFS_DEVICES}#${i}"
            BTRFS_COUNT=$((${BTRFS_COUNT}+1))
        done
    fi
}

# find btrfs subvolume
find_btrfs_subvolume(){
    if [[ "${DETECT_CREATE_FILESYSTEM}" = "no" ]]; then
        # existing btrfs subvolumes
        mount_btrfs
        for i in $(btrfs subvolume list ${BTRFSMP} | cut -d " " -f 7); do
            echo ${i}
            [[ "${1}" ]] && echo ${1}
        done
        umount_btrfs
    fi
}

find_btrfs_bootloader_subvolume(){
    BTRFS_SUBVOLUME_COUNT=1
    if [[ "$(${_BLKID} -p -i ${bootdev} -o value -s TYPE)" = "btrfs" ]]; then
        BTRFS_SUBVOLUMES=""
        PART="${bootdev}"
        mount_btrfs
        for i in $(btrfs subvolume list ${BTRFSMP} | cut -d " " -f 7); do
            BTRFS_SUBVOLUMES="${BTRFS_SUBVOLUMES}#${i}"
            BTRFS_SUBVOLUME_COUNT=$((${BTRFS_COUNT}+1))
        done
        umount_btrfs
    fi
}

# subvolumes already in use
subvolumes_in_use(){
    SUBVOLUME_IN_USE=""
    for i in $(grep ${PART}[:#] /tmp/.parts); do
        if [[ "$(echo ${i} | grep ":btrfs:")" ]]; then
            SUBVOLUME_IN_USE="${SUBVOLUME_IN_USE} $(echo ${i} | cut -d: -f 9)"
        fi
    done
}

# ask for btrfs compress option
btrfs_compress(){
    BTRFS_COMPRESS="NONE"
    BTRFS_COMPRESSLEVELS="lzo - zlib -"
    if [[ "${BTRFS_SUBVOLUME}" = "NONE" ]]; then
        DIALOG --defaultno --yesno "Would you like to compress the data on ${PART}?" 0 0 && BTRFS_COMPRESS="compress"
    else
        DIALOG --defaultno --yesno "Would you like to compress the data on ${PART} subvolume=${BTRFS_SUBVOLUME}?" 0 0 && BTRFS_COMPRESS="compress"
    fi
    if [[ "${BTRFS_COMPRESS}" = "compress" ]]; then
        DIALOG --menu "Select the compression method you want to use" 21 50 9 ${BTRFS_COMPRESSLEVELS} 2>${ANSWER} || return 1
        BTRFS_COMPRESS="compress=$(cat ${ANSWER})"
    fi
}

# ask for btrfs ssd option
btrfs_ssd(){
    BTRFS_SSD="NONE"
    if [[ "${BTRFS_SUBVOLUME}" = "NONE" ]]; then
        DIALOG --defaultno --yesno "Would you like to optimize the data for ssd disk usage on ${PART}?" 0 0 && BTRFS_SSD="ssd"
    else
        DIALOG --defaultno --yesno "Would you like to optimize the data for ssd disk usage on ${PART} subvolume=${BTRFS_SUBVOLUME}?" 0 0 && BTRFS_SSD="ssd"
    fi
}

# values that are only needed for btrfs creation
clear_btrfs_values(){
    : >/tmp/.btrfs-devices
    LABEL_NAME=""
    FS_OPTIONS=""
    BTRFS_DEVICES=""
    BTRFS_LEVEL=""
}

# do not ask for btrfs filesystem creation, if already prepared for creation!
check_btrfs_filesystem_creation(){
    DETECT_CREATE_FILESYSTEM="no"
    SKIP_FILESYSTEM="no"
    SKIP_ASK_SUBVOLUME="no"
    for i in $(grep ${PART}[:#] /tmp/.parts); do
        if [[ "$(echo ${i} | grep ":btrfs:")" ]]; then
            FSTYPE="btrfs"
            SKIP_FILESYSTEM="yes"
            # check on filesystem creation, skip subvolume asking then!
            [[ "$(echo ${i} | cut -d: -f 4 | grep yes)" ]] && DETECT_CREATE_FILESYSTEM="yes"
            [[ "${DETECT_CREATE_FILESYSTEM}" = "yes" ]] && SKIP_ASK_SUBVOLUME="yes"
        fi
    done
}

# remove devices with no subvolume from list and generate raid device list
btrfs_parts(){
     if [[ -s /tmp/.btrfs-devices ]]; then
         BTRFS_DEVICES=""
         for i in $(cat /tmp/.btrfs-devices); do
             BTRFS_DEVICES="${BTRFS_DEVICES}#${i}"
             # remove device if no subvolume is used!
             [[ "${BTRFS_SUBVOLUME}" = "NONE"  ]] && PARTS="$(echo ${PARTS} | sed -e "s#${i}\ _##g")"
         done
     else
         [[ "${BTRFS_SUBVOLUME}" = "NONE"  ]] && PARTS="$(echo ${PARTS} | sed -e "s#${PART}\ _##g")"
     fi
}

# choose raid level to use on btrfs device
btrfs_raid_level(){
    BTRFS_RAIDLEVELS="NONE - raid0 - raid1 - raid10 - single -"
    BTRFS_RAID_FINISH=""
    BTRFS_LEVEL=""
    BTRFS_DEVICE="${PART}"
    : >/tmp/.btrfs-devices
    DIALOG --msgbox "BTRFS RAID OPTIONS:\n\nBTRFS has options to control the raid configuration for data and metadata.\nValid choices are raid0, raid1, raid10 and single.\nsingle means that no duplication of metadata is done, which may be desired when using hardware raid. raid10 requires at least 4 devices.\n\nIf you don't need this feature select NONE." 0 0
    while [[ "${BTRFS_RAID_FINISH}" != "DONE" ]]; do
        DIALOG --menu "Select the raid level you want to use" 21 50 9 ${BTRFS_RAIDLEVELS} 2>${ANSWER} || return 1
        BTRFS_LEVEL=$(cat ${ANSWER})
        if [[ "${BTRFS_LEVEL}" = "NONE" ]]; then
            echo "${BTRFS_DEVICE}" >>/tmp/.btrfs-devices
            break
        else
            # take selected device as 1st device, add additional devices in part below.
            select_btrfs_raid_devices
        fi
    done
}

# select btrfs raid devices
select_btrfs_raid_devices (){
    # show all devices with sizes
    # DIALOG --msgbox "DISKS:\n$(_getavaildisks)\n\nPARTITIONS:\n$(_getavailpartitions)" 0 0
    # select the second device to use, no missing option available!
    : >/tmp/.btrfs-devices
    BTRFS_PART="${BTRFS_DEVICE}"
    BTRFS_PARTS="${PARTS}"
    echo "${BTRFS_PART}" >>/tmp/.btrfs-devices
    BTRFS_PARTS="$(echo ${BTRFS_PARTS} | sed -e "s#${BTRFS_PART}\ _##g")"
    RAIDNUMBER=2
    DIALOG --menu "Select device ${RAIDNUMBER}" 21 50 13 ${BTRFS_PARTS} 2>${ANSWER} || return 1
    BTRFS_PART=$(cat ${ANSWER})
    echo "${BTRFS_PART}" >>/tmp/.btrfs-devices
    while [[ "${BTRFS_PART}" != "DONE" ]]; do
        BTRFS_DONE=""
        RAIDNUMBER=$((${RAIDNUMBER} + 1))
        # RAID10 need 4 devices!
        [[ "${RAIDNUMBER}" -ge 3 && ! "${BTRFS_LEVEL}" = "raid10" ]] && BTRFS_DONE="DONE _"
        [[ "${RAIDNUMBER}" -ge 5 && "${BTRFS_LEVEL}" = "raid10" ]] && BTRFS_DONE="DONE _"
        # clean loop from used partition and options
        BTRFS_PARTS="$(echo ${BTRFS_PARTS} | sed -e "s#${BTRFS_PART}\ _##g")"
        # add more devices
        DIALOG --menu "Select device ${RAIDNUMBER}" 21 50 13 ${BTRFS_PARTS} ${BTRFS_DONE} 2>${ANSWER} || return 1
        BTRFS_PART=$(cat ${ANSWER})
        [[ "${BTRFS_PART}" = "DONE" ]] && break
        echo "${BTRFS_PART}" >>/tmp/.btrfs-devices
     done
     # final step ask if everything is ok?
     DIALOG --yesno "Would you like to create btrfs raid like this?\n\nLEVEL:\n${BTRFS_LEVEL}\n\nDEVICES:\n$(for i in $(cat /tmp/.btrfs-devices); do echo "${i}\n"; done)" 0 0 && BTRFS_RAID_FINISH="DONE"
}

# prepare new btrfs device
prepare_btrfs(){
    btrfs_raid_level || return 1
    prepare_btrfs_subvolume || return 1
}

# prepare btrfs subvolume
prepare_btrfs_subvolume(){
    DOSUBVOLUME="no"
    BTRFS_SUBVOLUME="NONE"
    if [[ "${SKIP_ASK_SUBVOLUME}" = "no" ]]; then
        DIALOG --defaultno --yesno "Would you like to create a new subvolume on ${PART}?" 0 0 && DOSUBVOLUME="yes"
    else
        DOSUBVOLUME="yes"
    fi
    if [[ "${DOSUBVOLUME}" = "yes" ]]; then
        BTRFS_SUBVOLUME="NONE"
        while [[ "${BTRFS_SUBVOLUME}" = "NONE" ]]; do
            DIALOG --inputbox "Enter the SUBVOLUME name for the device, keep it short\nand use no spaces or special\ncharacters." 10 65 2>${ANSWER} || return 1
            BTRFS_SUBVOLUME=$(cat ${ANSWER})
            check_btrfs_subvolume
        done
    else
        BTRFS_SUBVOLUME="NONE"
    fi
}

# check btrfs subvolume
check_btrfs_subvolume(){
    [[ "${DOMKFS}" = "yes" && "${FSTYPE}" = "btrfs" ]] && DETECT_CREATE_FILESYSTEM="yes"
    if [[ "${DETECT_CREATE_FILESYSTEM}" = "no" ]]; then
        mount_btrfs
        for i in $(btrfs subvolume list ${BTRFSMP} | cut -d " " -f 7); do
            if [[ "$(echo ${i} | grep "${BTRFS_SUBVOLUME}"$)" ]]; then
                DIALOG --msgbox "ERROR: You have defined 2 identical SUBVOLUME names or an empty name! Please enter another name." 8 65
                BTRFS_SUBVOLUME="NONE"
            fi
        done
        umount_btrfs
    else
        subvolumes_in_use
        if [[ "$(echo ${SUBVOLUME_IN_USE} | egrep "${BTRFS_SUBVOLUME}")" ]]; then
            DIALOG --msgbox "ERROR: You have defined 2 identical SUBVOLUME names or an empty name! Please enter another name." 8 65
            BTRFS_SUBVOLUME="NONE"
        fi
    fi
}

# create btrfs subvolume
create_btrfs_subvolume(){
    mount_btrfs
    btrfs subvolume create ${BTRFSMP}/${_btrfssubvolume} >${LOG}
    # change permission from 700 to 755
    # to avoid warnings during package installation
    chmod 755 ${BTRFSMP}/${_btrfssubvolume}
    umount_btrfs
}

# choose btrfs subvolume from list
choose_btrfs_subvolume (){
    BTRFS_SUBVOLUME="NONE"
    SUBVOLUMES_DETECTED="no"
    SUBVOLUMES=$(find_btrfs_subvolume _)
    # check if subvolumes are present
    [[ -n "${SUBVOLUMES}" ]] && SUBVOLUMES_DETECTED="yes"
    subvolumes_in_use
    for i in ${SUBVOLUME_IN_USE}; do
        SUBVOLUMES=$(echo ${SUBVOLUMES} | sed -e "s#${i}\ _##g")
    done
    if [[ -n "${SUBVOLUMES}" ]]; then
        DIALOG --menu "Select the subvolume to mount" 21 50 13 ${SUBVOLUMES} 2>${ANSWER} || return 1
        BTRFS_SUBVOLUME=$(cat ${ANSWER})
    else
        if [[ "${SUBVOLUMES_DETECTED}" = "yes" ]]; then
            DIALOG --msgbox "ERROR: All subvolumes of the device are already in use. Switching to create a new one now." 8 65
            SKIP_ASK_SUBVOLUME=yes
            prepare_btrfs_subvolume || return 1
        fi
    fi
}

# boot on btrfs subvolume is not supported
check_btrfs_boot_subvolume(){
    if [[ "${MP}" = "/boot" && "${FSTYPE}" = "btrfs" && ! "${BTRFS_SUBVOLUME}" = "NONE" ]]; then
        DIALOG --msgbox "ERROR: \n/boot on a btrfs subvolume is not supported by any bootloader yet!" 8 65
        FILESYSTEM_FINISH="no"
    fi
}

# btrfs subvolume menu
btrfs_subvolume(){
    FILESYSTEM_FINISH=""
    if [[ "${FSTYPE}" = "btrfs" && "${DOMKFS}" = "no" ]]; then
        if [[ "${ASK_MOUNTPOINTS}" = "1" ]]; then
            # create subvolume if requested
            # choose btrfs subvolume if present
            prepare_btrfs_subvolume || return 1
            if [[ "${BTRFS_SUBVOLUME}" = "NONE" ]]; then
                choose_btrfs_subvolume || return 1
            fi
        else
            # use device if no subvolume is present
            choose_btrfs_subvolume || return 1
        fi
        btrfs_compress
        btrfs_ssd
    fi
    FILESYSTEM_FINISH="yes"
}

select_filesystem(){
    FILESYSTEM_FINISH=""
    # don't allow vfat as / filesystem, it will not work!
    # don't allow ntfs as / filesystem, this is stupid!
    FSOPTS=""
    [[ "$(which mkfs.ext2 2>/dev/null)" ]] && FSOPTS="${FSOPTS} ext2 Ext2"
    [[ "$(which mkfs.ext3 2>/dev/null)" ]] && FSOPTS="${FSOPTS} ext3 Ext3"
    [[ "$(which mkfs.ext4 2>/dev/null)" ]] && FSOPTS="${FSOPTS} ext4 Ext4"
    [[ "$(which mkfs.btrfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} btrfs Btrfs-(Experimental)"
    [[ "$(which mkfs.nilfs2 2>/dev/null)" ]] && FSOPTS="${FSOPTS} nilfs2 Nilfs2-(Experimental)"
    [[ "$(which mkreiserfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} reiserfs Reiser3"
    [[ "$(which mkfs.xfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} xfs XFS"
    [[ "$(which mkfs.jfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} jfs JFS"
    [[ "$(which mkfs.ntfs 2>/dev/null)" && "${DO_ROOT}" = "DONE" ]] && FSOPTS="${FSOPTS} ntfs-3g NTFS"
    [[ "$(which mkfs.vfat 2>/dev/null)" && "${DO_ROOT}" = "DONE" ]] && FSOPTS="${FSOPTS} vfat VFAT"
    DIALOG --menu "Select a filesystem for ${PART}" 21 50 13 ${FSOPTS} 2>${ANSWER} || return 1
    FSTYPE=$(cat ${ANSWER})
}

enter_mountpoint(){
    FILESYSTEM_FINISH=""
    MP=""
    while [[ "${MP}" = "" ]]; do
        DIALOG --inputbox "Enter the mountpoint for ${PART}" 8 65 "/boot" 2>${ANSWER} || return 1
        MP=$(cat ${ANSWER})
        if grep ":${MP}:" /tmp/.parts; then
            DIALOG --msgbox "ERROR: You have defined 2 identical mountpoints! Please select another mountpoint." 8 65
            MP=""
        fi
    done
}

# set sane values for paramaters, if not already set
check_mkfs_values(){
    # Set values, to not confuse mkfs call!
    [[ "${FS_OPTIONS}" = "" ]] && FS_OPTIONS="NONE"
    [[ "${BTRFS_DEVICES}" = "" ]] && BTRFS_DEVICES="NONE"
    [[ "${BTRFS_LEVEL}" = "" ]] && BTRFS_LEVEL="NONE"
    [[ "${BTRFS_SUBVOLUME}" = "" ]] && BTRFS_SUBVOLUME="NONE"
    [[ "${DOSUBVOLUME}" = "" ]] && DOSUBVOLUME="no"
    [[ "${LABEL_NAME}" = "" && -n "$(${_BLKID} -p -i -o value -s LABEL ${PART})" ]] && LABEL_NAME="$(${_BLKID} -p -i -o value -s LABEL ${PART})"
    [[ "${LABEL_NAME}" = "" ]] && LABEL_NAME="NONE"
}

create_filesystem(){
    FILESYSTEM_FINISH=""
    LABEL_NAME=""
    FS_OPTIONS=""
    BTRFS_DEVICES=""
    BTRFS_LEVEL=""
    DIALOG --yesno "Would you like to create a filesystem on ${PART}?\n\n(This will overwrite existing data!)" 0 0 && DOMKFS="yes"
    if [[ "${DOMKFS}" = "yes" ]]; then
        while [[ "${LABEL_NAME}" = "" ]]; do
            DIALOG --inputbox "Enter the LABEL name for the device, keep it short\n(not more than 12 characters) and use no spaces or special\ncharacters." 10 65 \
            "$(${_BLKID} -p -i -o value -s LABEL ${PART})" 2>${ANSWER} || return 1
            LABEL_NAME=$(cat ${ANSWER})
            if grep ":${LABEL_NAME}$" /tmp/.parts; then
                DIALOG --msgbox "ERROR: You have defined 2 identical LABEL names! Please enter another name." 8 65
                LABEL_NAME=""
            fi
        done
        if [[ "${FSTYPE}" = "btrfs" ]]; then
            prepare_btrfs || return 1
            btrfs_compress
            btrfs_ssd
        fi
        DIALOG --inputbox "Enter additional options to the filesystem creation utility.\nUse this field only, if the defaults are not matching your needs,\nelse just leave it empty." 10 70  2>${ANSWER} || return 1
        FS_OPTIONS=$(cat ${ANSWER})
    fi
    FILESYSTEM_FINISH="yes"
}



# _mkfs()
# Create and mount filesystems in our destination system directory.
#
# args:
#  domk: Whether to make the filesystem or use what is already there
#  device: Device filesystem is on
#  fstype: type of filesystem located at the device (or what to create)
#  dest: Mounting location for the destination system
#  mountpoint: Mount point inside the destination system, e.g. '/boot'

# returns: 1 on failure
_mkfs(){
    local _domk=${1}
    local _device=${2}
    local _fstype=${3}
    local _dest=${4}
    local _mountpoint=${5}
    local _labelname=${6}
    local _fsoptions=${7}
    local _btrfsdevices="$(echo ${8} | sed -e 's|#| |g')"
    local _btrfslevel=${9}
    local _btrfssubvolume=${10}
    local _dosubvolume=${11}
    local _btrfscompress=${12}
    local _btrfsssd=${13}
    # correct empty entries
    [[ "${_fsoptions}" = "NONE" ]] && _fsoptions=""
    [[ "${_btrfsssd}" = "NONE" ]] && _btrfsssd=""
    [[ "${_btrfscompress}" = "NONE" ]] && _btrfscompress=""
    [[ "${_btrfssubvolume}" = "NONE" ]] && _btrfssubvolume=""
    # add btrfs raid level, if needed
    [[ ! "${_btrfslevel}" = "NONE" && "${_fstype}" = "btrfs" ]] && _fsoptions="${_fsoptions} -d ${_btrfslevel}"
    # we have two main cases: "swap" and everything else.
    if [[ "${_fstype}" = "swap" ]]; then
        swapoff ${_device} >/dev/null 2>&1
        if [[ "${_domk}" = "yes" ]]; then
            mkswap -L ${_labelname} ${_device} >${LOG} 2>&1
            if [[ $? != 0 ]]; then
                DIALOG --msgbox "Error creating swap: mkswap ${_device}" 0 0
                return 1
            fi
        fi
        swapon ${_device} >${LOG} 2>&1
        if [[ $? != 0 ]]; then
            DIALOG --msgbox "Error activating swap: swapon ${_device}" 0 0
            return 1
        fi
    else
        # make sure the fstype is one we can handle
        local knownfs=0
        for fs in xfs jfs reiserfs ext2 ext3 ext4 btrfs nilfs2 ntfs-3g vfat; do
            [[ "${_fstype}" = "${fs}" ]] && knownfs=1 && break
        done
        if [[ ${knownfs} -eq 0 ]]; then
            DIALOG --msgbox "unknown fstype ${_fstype} for ${_device}" 0 0
            return 1
        fi
        # if we were tasked to create the filesystem, do so
        if [[ "${_domk}" = "yes" ]]; then
            local ret
            case ${_fstype} in
                xfs)      mkfs.xfs ${_fsoptions} -L ${_labelname} -f ${_device} >${LOG} 2>&1; ret=$? ;;
                jfs)      yes | mkfs.jfs ${_fsoptions} -L ${_labelname} ${_device} >${LOG} 2>&1; ret=$? ;;
                reiserfs) yes | mkreiserfs ${_fsoptions} -l ${_labelname} ${_device} >${LOG} 2>&1; ret=$? ;;
                ext2)     mkfs.ext2 ${_fsoptions} -F -L ${_labelname} ${_device} >${LOG} 2>&1; ret=$? ;;
                ext3)     mke2fs ${_fsoptions} -F -L ${_labelname} -t ext3 ${_device} >${LOG} 2>&1; ret=$? ;;
                ext4)     mke2fs ${_fsoptions} -F -L ${_labelname} -t ext4 ${_device} >${LOG} 2>&1; ret=$? ;;
                btrfs)    mkfs.btrfs ${_fsoptions} -L ${_labelname} ${_btrfsdevices} >${LOG} 2>&1; ret=$? ;;
                nilfs2)   mkfs.nilfs2 ${_fsoptions} -L ${_labelname} ${_device} >${LOG} 2>&1; ret=$? ;;
                ntfs-3g)  mkfs.ntfs ${_fsoptions} -L ${_labelname} ${_device} >${LOG} 2>&1; ret=$? ;;
                vfat)     mkfs.vfat ${_fsoptions} -n ${_labelname} ${_device} >${LOG} 2>&1; ret=$? ;;
                # don't handle anything else here, we will error later
            esac
            if [[ ${ret} != 0 ]]; then
                DIALOG --msgbox "Error creating filesystem ${_fstype} on ${_device}" 0 0
                return 1
            fi
            sleep 2
        fi
        if [[ "${_fstype}" = "btrfs" && -n "${_btrfssubvolume}" && "${_dosubvolume}" = "yes" ]]; then
            create_btrfs_subvolume
        fi
        btrfs_scan
        sleep 2
        # create our mount directory
        mkdir -p ${_dest}${_mountpoint}
        # prepare btrfs mount options
        _btrfsmountoptions=""
        [[ -n "${_btrfssubvolume}" ]] && _btrfsmountoptions="subvol=${_btrfssubvolume}"
        [[ -n "${_btrfscompress}" ]] && _btrfsmountoptions="${_btrfsmountoptions} ${_btrfscompress}"
        [[ -n "${_btrfsssd}" ]] && _btrfsmountoptions="${_btrfsmountoptions} ${_btrfsssd}"
        _btrfsmountoptions="$(echo ${_btrfsmountoptions} | sed -e 's#^ ##g' | sed -e 's# #,#g')"
        # mount the bad boy
        if [[ "${_fstype}" = "btrfs" && -n "${_btrfsmountoptions}" ]]; then
            mount -t ${_fstype} -o ${_btrfsmountoptions} ${_device} ${_dest}${_mountpoint} >${LOG} 2>&1
        else
            mount -t ${_fstype} ${_device} ${_dest}${_mountpoint} >${LOG} 2>&1
        fi
        if [[ $? != 0 ]]; then
            DIALOG --msgbox "Error mounting ${_dest}${_mountpoint}" 0 0
            return 1
        fi
        # change permission of base directories to correct permission
        # to avoid btrfs issues
        if [[ "${_mountpoint}" = "/tmp" ]]; then
            chmod 1777 ${_dest}${_mountpoint}
        elif [[ "${_mountpoint}" = "/root" ]]; then
            chmod 750 ${_dest}${_mountpoint}
        else
            chmod 755 ${_dest}${_mountpoint}
        fi
    fi
    # add to .device-names for config files
    local _fsuuid="$(getfsuuid ${_device})"
    local _fslabel="$(getfslabel ${_device})"

    if [[ "${GUID_DETECTED}" == "1" ]]; then
        local _partuuid="$(getpartuuid ${_device})"
        local _partlabel="$(getpartlabel ${_device})"

        echo "# DEVICE DETAILS: ${_device} PARTUUID=${_partuuid} PARTLABEL=${_partlabel} UUID=${_fsuuid} LABEL=${_fslabel}" >> /tmp/.device-names
    else
        echo "# DEVICE DETAILS: ${_device} UUID=${_fsuuid} LABEL=${_fslabel}" >> /tmp/.device-names
    fi

    # add to temp fstab
    if [[ "${NAME_SCHEME_PARAMETER}" == "FSUUID" ]]; then
        if [[ -n "${_fsuuid}" ]]; then
            _device="UUID=${_fsuuid}"
        fi
    elif [[ "${NAME_SCHEME_PARAMETER}" == "FSLABEL" ]]; then
        if [[ -n "${_fslabel}" ]]; then
            _device="LABEL=${_fslabel}"
        fi
    else
        if [[ "${GUID_DETECTED}" == "1" ]]; then
           if [[ "${NAME_SCHEME_PARAMETER}" == "PARTUUID" ]]; then
               if [[ -n "${_partuuid}" ]]; then
                   _device="PARTUUID=${_partuuid}"
               fi
           elif [[ "${NAME_SCHEME_PARAMETER}" == "PARTLABEL" ]]; then
               if [[ -n "${_partlabel}" ]]; then
                   _device="PARTLABEL=${_partlabel}"
               fi
           fi
        fi
    fi

    if [[ "${_fstype}" = "btrfs" && -n "${_btrfsmountoptions}" ]]; then
        echo -n "${_device} ${_mountpoint} ${_fstype} defaults,${_btrfsmountoptions} 0 " >>/tmp/.fstab
    else
        echo -n "${_device} ${_mountpoint} ${_fstype} defaults 0 " >>/tmp/.fstab
    fi
    if [[ "${_fstype}" = "swap" ]]; then
        echo "0" >>/tmp/.fstab
    else
        echo "1" >>/tmp/.fstab
    fi
}

# auto_fstab()
# preprocess fstab file
# comments out old fields and inserts new ones
# according to partitioning/formatting stage
#
auto_fstab(){
    # Modify fstab
    if [[ "${S_MKFS}" = "1" || "${S_MKFSAUTO}" = "1" ]]; then
        if [[ -f /tmp/.device-names ]]; then
            sort /tmp/.device-names >>${DESTDIR}/etc/fstab
        fi
        if [[ -f /tmp/.fstab ]]; then
            # clean fstab first from /dev entries
            sed -i -e '/^\/dev/d' ${DESTDIR}/etc/fstab
            sort /tmp/.fstab >>${DESTDIR}/etc/fstab
        fi
    fi
}

# auto_mdadm()
# add mdadm setup to existing /etc/mdadm.conf
auto_mdadm()
{
    if [[ -e ${DESTDIR}/etc/mdadm.conf ]];then
        if [[ "$(cat /proc/mdstat | grep ^md)" ]]; then
            DIALOG --infobox "Adding raid setup to ${DESTDIR}/etc/mdadm.conf ..." 4 40
            mdadm -Ds >> ${DESTDIR}/etc/mdadm.conf
        fi
    fi
}

getrootfstype(){
    ROOTFS="$(getfstype ${PART_ROOT})"
}

getrootflags(){
    # remove rw for all filesystems and gcpid for nilfs2
    ROOTFLAGS=""
    ROOTFLAGS="$(findmnt -m -n -o options -T ${DESTDIR} | sed -e 's/^rw//g' -e 's/,gcpid=.*[0-9]//g')"
    [[ -n "${ROOTFLAGS}" ]] && ROOTFLAGS="rootflags=${ROOTFLAGS}"
}

getraidarrays(){
    RAIDARRAYS=""
    if ! [[ "$(grep ^ARRAY ${DESTDIR}/etc/mdadm.conf)" ]]; then
        RAIDARRAYS="$(echo -n $(cat /proc/mdstat 2>/dev/null | grep ^md | sed -e 's#\[[0-9]\]##g' -e 's# :.* raid[0-9]##g' -e 's#md#md=#g' -e 's# #,/dev/#g' -e 's#_##g'))"
    fi
}

getcryptsetup(){
    CRYPTSETUP=""
    if ! [[ "$(cryptsetup status $(basename ${PART_ROOT}) | grep inactive)" ]]; then
        #avoid clash with dmraid here
        if [[ "$(cryptsetup status $(basename ${PART_ROOT}))" ]]; then
            if [[ "${NAME_SCHEME_PARAMETER}" == "FSUUID" ]]; then
                CRYPTDEVICE="UUID=$(echo $(${_BLKID} -p -i -s UUID -o value $(cryptsetup status $(basename ${PART_ROOT}) | grep device: | sed -e 's#device:##g')))"
            elif [[ "${NAME_SCHEME_PARAMETER}" == "FSLABEL" ]]; then
                CRYPTDEVICE="LABEL=$(echo $(${_BLKID} -p -i -s LABEL -o value $(cryptsetup status $(basename ${PART_ROOT}) | grep device: | sed -e 's#device:##g')))"
            else
                CRYPTDEVICE="$(echo $(cryptsetup status $(basename ${PART_ROOT}) | grep device: | sed -e 's#device:##g'))"
            fi
            CRYPTNAME="$(basename ${PART_ROOT})"
            CRYPTSETUP="cryptdevice=${CRYPTDEVICE}:${CRYPTNAME}"
        fi
    fi
}

getrootpartuuid(){
    _rootpart="${PART_ROOT}"
    _partuuid="$(getpartuuid ${PART_ROOT})"
    if [[ -n "${_partuuid}" ]]; then
        _rootpart="PARTUUID=${_partuuid}"
    fi
}

getrootpartlabel(){
    _rootpart="${PART_ROOT}"
    _partlabel="$(getpartlabel ${PART_ROOT})"
    if [[ -n "${_partlabel}" ]]; then
        _rootpart="PARTLABEL=${_partlabel}"
    fi
}

getrootfsuuid(){
    _rootpart="${PART_ROOT}"
    _fsuuid="$(getfsuuid ${PART_ROOT})"
    if [[ -n "${_fsuuid}" ]]; then
        _rootpart="UUID=${_fsuuid}"
    fi
}

getrootfslabel(){
    _rootpart="${PART_ROOT}"
    _fslabel="$(getfslabel ${PART_ROOT})"
    if [[ -n "${_fslabel}" ]]; then
        _rootpart="LABEL=${_fslabel}"
    fi
}

# basic checks needed for all bootloaders
common_bootloader_checks(){
    activate_special_devices
    getrootfstype
    getraidarrays
    getcryptsetup
    getrootflags

    if [[ "${GUID_DETECTED}" == "1" ]]; then
        [[ "${NAME_SCHEME_PARAMETER}" == "PARTUUID" ]] && getrootpartuuid
        [[ "${NAME_SCHEME_PARAMETER}" == "PARTLABEL" ]] && getrootpartlabel
    fi

    [[ "${NAME_SCHEME_PARAMETER}" == "FSUUID" ]] && getrootfsuuid
    [[ "${NAME_SCHEME_PARAMETER}" == "FSLABEL" ]] && getrootfslabel
}

# look for a separately-mounted /boot partition
check_bootpart(){
    subdir=""
    bootdev="$(mount | grep "${DESTDIR}/boot " | cut -d' ' -f 1)"
    if [[ "${bootdev}" == "" ]]; then
        subdir="/boot"
        bootdev="${PART_ROOT}"
    fi
}

# check for btrfs bootpart and abort if detected
abort_btrfs_bootpart(){
        FSTYPE="$(${_BLKID} -p -i ${bootdev} -o value -s TYPE)"
        if [[ "${FSTYPE}" = "btrfs" ]]; then
            DIALOG --msgbox "Error:\nYour selected bootloader cannot boot from btrfs partition with /boot on it." 0 0
            return 1
        fi
}

# check for nilfs2 bootpart and abort if detected
abort_nilfs_bootpart(){
        FSTYPE="$(${_BLKID} -p -i ${bootdev} -o value -s TYPE)"
        if [[ "${FSTYPE}" = "nilfs2" ]]; then
            DIALOG --msgbox "Error:\nYour selected bootloader cannot boot from nilfs2 partition with /boot on it." 0 0
            return 1
        fi
}

do_uefi_common(){

    DISC="$(df -T "${DESTDIR}/boot" | tail -n +2 | awk '{print $1}' | sed 's/\(.\{8\}\).*/\1/')"

    if [[ "${DISC}" != "" ]]; then
        CHECK_UEFISYS_PART="1"
        CHECK_BIOS_BOOT_GRUB=""
        RUN_CGDISK=""
        # check_gpt
        check_uefisyspart
    fi

}

do_uefi_x86_64(){

    export _UEFI_ARCH="x86_64"
    export _SPEC_UEFI_ARCH="x64"

    do_uefi_common

}

do_uefi_i386(){

    export _UEFI_ARCH="i386"
    export _SPEC_UEFI_ARCH="ia32"

    do_uefi_common

}

do_uefi_efibootmgr(){

    modprobe -q efivars

    if [[ "$(lsmod | grep ^efivars)" ]]; then
        chroot_mount

        if [[ -d "${DESTDIR}/sys/firmware/efi/vars" ]]; then
            cat << EFIBEOF > "${DESTDIR}/efibootmgr_run.sh"
#!/usr/bin/env bash

for _bootnum in \$(efibootmgr | grep '^Boot[0-9]' | fgrep -i "${_EFIBOOTMGR_LABEL}" | cut -b5-8) ; do
    efibootmgr --bootnum "\${_bootnum}" --delete-bootnum
done

echo
efibootmgr --verbose --create --gpt --disk "${_EFIBOOTMGR_DISC}" --part "${_EFIBOOTMGR_PART_NUM}" --write-signature --label "${_EFIBOOTMGR_LABEL}" --loader \'\\EFI\\${_EFIBOOTMGR_LOADER_DIR}\\${_EFIBOOTMGR_LOADER_FILE}\'
echo

EFIBEOF

            chmod a+x "${DESTDIR}/efibootmgr_run.sh"
            chroot "${DESTDIR}" "/bin/bash" "/efibootmgr_run.sh" &>"/tmp/efibootmgr_run.log"
            mv "${DESTDIR}/efibootmgr_run.sh" "/tmp/efibootmgr_run.sh"
        else
            DIALOG --msgbox "${DESTDIR}/sys/firmware/efi/vars/ directory not found. Check whether you have booted in UEFI boot mode, manually load efivars kernel module and create a boot entry for ${_EFIBOOTMGR_LABEL} in the UEFI Boot Manager." 0 0
        fi

        chroot_umount
    else
        DIALOG --msgbox "efivars kernel module was not loaded properly. Manually load it and create a boot entry for DISC ${_EFIBOOTMGR_DISC} , PART ${_EFIBOOTMGR_PART_NUM} and LOADER \\EFI\\${_EFIBOOTMGR_LOADER_DIR}\\${_EFIBOOTMGR_LOADER_FILE} , in UEFI Boot Manager using efibootmgr." 0 0
    fi

    unset _EFIBOOTMGR_LABEL
    unset _EFIBOOTMGR_DISC
    unset _EFIBOOTMGR_PART_NUM
    unset _EFIBOOTMGR_LOADER_DIR
    unset _EFIBOOTMGR_LOADER_FILE

}

do_apple_efi_hfs_bless(){

    modprobe -q -r efivars || true

    ## Grub upstream bzr mactel branch => http://bzr.savannah.gnu.org/lh/grub/branches/mactel/changes
    ## Fedora's mactel-boot => https://bugzilla.redhat.com/show_bug.cgi?id=755093
    DIALOG --msgbox "TODO: Apple Mac EFI Bootloader Setup" 0 0

}

do_uefi_bootmgr_setup(){

    _uefisysdev="$(df -T "${DESTDIR}/boot/efi" | tail -n +2 | awk '{print $1}')"
    _DISC="$(echo "${_uefisysdev}" | sed 's/\(.\{8\}\).*/\1/')"
    UEFISYS_PART_NUM="$(${_BLKID} -p -i -s PART_ENTRY_NUMBER -o value "${_uefisysdev}")"

    _BOOTMGR_DISC="${_DISC}"
    _BOOTMGR_PART_NUM="${UEFISYS_PART_NUM}"

    if [[ "$(cat "/sys/class/dmi/id/sys_vendor")" == 'Apple Inc.' ]] || [[ "$(cat "/sys/class/dmi/id/sys_vendor")" == 'Apple Computer, Inc.' ]]; then
        do_apple_efi_hfs_bless
    else
        ## For all the non-Mac UEFI systems
        _EFIBOOTMGR_LABEL="${_BOOTMGR_LABEL}"
        _EFIBOOTMGR_DISC="${_BOOTMGR_DISC}"
        _EFIBOOTMGR_PART_NUM="${_BOOTMGR_PART_NUM}"
        _EFIBOOTMGR_LOADER_DIR="${_BOOTMGR_LOADER_DIR}"
        _EFIBOOTMGR_LOADER_FILE="${_BOOTMGR_LOADER_FILE}"
        do_uefi_efibootmgr
    fi

    unset _BOOTMGR_LABEL
    unset _BOOTMGR_DISC
    unset _BOOTMGR_PART_NUM
    unset _BOOTMGR_LOADER_DIR
    unset _BOOTMGR_LOADER_FILE

}

doefistub_uefi_common(){

    [[ "$(uname -m)" == "x86_64" ]] && __CARCH="x86_64"
    [[ "$(uname -m)" == "i686" ]] && __CARCH="i386"

    if [[ "${__CARCH}" != "${_UEFI_ARCH}" ]]; then
        DIALOG --msgbox "EFISTUB requires Kernel and UEFI arch to match, and requires CONFIG_EFI_STUB enabled kernel. Please install matching MANJARO Kernel and try again." 0 0
    elif [[ "${KERNELPKG}" == "linux-lts" ]]; then
        mkdir -p "${DESTDIR}/boot/efi/EFI/efilinux/"
        cp -f "${DESTDIR}/usr/lib/efilinux/efilinux${_SPEC_UEFI_ARCH}.efi" "${DESTDIR}/boot/efi/EFI/efilinux/efilinux${_SPEC_UEFI_ARCH}.efi"

        _EFILINUX="1"
        _CONTINUE="1"
    else
        _CONTINUE="1"
    fi

    if [[ "${_CONTINUE}" == "1" ]]; then
        bootdev=""
        grubdev=""
        complexuuid=""
        FAIL_COMPLEX=""
        USE_DMRAID=""
        RAID_ON_LVM=""
        common_bootloader_checks

        _EFISTUB_KERNEL="${VMLINUZ/linux/manjaro}.efi"
        [[ "${_EFILINUX}" == "1" ]] && _EFISTUB_KERNEL="${VMLINUZ/linux/manjaro}"
        _EFISTUB_INITRAMFS="${INITRAMFS/linux/manjaro}"

        mkdir -p "${DESTDIR}/boot/efi/EFI/manjaro/"

        rm -f "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_KERNEL}"
        rm -f "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}.img"
        rm -f "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}-fallback.img"

        cp -f "${DESTDIR}/boot/${VMLINUZ}" "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_KERNEL}"
        cp -f "${DESTDIR}/boot/${INITRAMFS}.img" "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}.img"
        cp -f "${DESTDIR}/boot/${INITRAMFS}-fallback.img" "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}-fallback.img"

        #######################

        cat << CONFEOF > "${DESTDIR}/etc/systemd/system/efistub_copy.path"
[Unit]
Description=Copy EFISTUB Kernel and Initramfs to UEFISYS Partition

[Path]
PathChanged=/boot/${INITRAMFS}-fallback.img
Unit=efistub_copy.service

[Install]
WantedBy=multi-user.target
CONFEOF

        cat << CONFEOF > "${DESTDIR}/etc/systemd/system/efistub_copy.service"
[Unit]
Description=Copy EFISTUB Kernel and Initramfs to UEFISYS Partition

[Service]
Type=oneshot
ExecStart=/bin/cp -f /boot/${VMLINUZ} /boot/efi/EFI/manjaro/${_EFISTUB_KERNEL}
ExecStart=/bin/cp -f /boot/${INITRAMFS}.img /boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}.img
ExecStart=/bin/cp -f /boot/${INITRAMFS}-fallback.img /boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}-fallback.img
CONFEOF

        chroot "${DESTDIR}" /usr/bin/systemctl enable efistub_copy.path

        if [[ "${SYSTEMD}" != "1" ]]; then

            cat << CONFEOF > "${DESTDIR}/usr/local/bin/efistub_copy.sh"
/bin/cp -f /boot/${VMLINUZ} /boot/efi/EFI/manjaro/${_EFISTUB_KERNEL}
/bin/cp -f /boot/${INITRAMFS}.img /boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}.img
/bin/cp -f /boot/${INITRAMFS}-fallback.img /boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}-fallback.img
CONFEOF

            cat << CONFEOF > "${DESTDIR}/etc/incron.d/efistub_copy.conf"
/boot/${INITRAMFS}-fallback.img IN_CLOSE_WRITE /usr/local/bin/efistub_copy.sh
CONFEOF

            DIALOG --msgbox "Add incrond to the DAEMONS list in /etc/rc.conf ." 0 0
        fi

        ###########################

        _bootdev="$(df -T "${DESTDIR}/boot" | tail -n +2 | awk '{print $1}')"
        _rootdev="$(df -T "${DESTDIR}/" | tail -n +2 | awk '{print $1}')"
        _uefisysdev="$(df -T "${DESTDIR}/boot/efi" | tail -n +2 | awk '{print $1}')"

        ROOT_PART_FS_UUID="$(getfsuuid "${_rootdev}")"
        ROOT_PART_FS_LABEL="$(getfslabel "${_rootdev}")"
        ROOT_PART_GPT_GUID="$(getpartuuid "${_rootdev}")"
        ROOT_PART_GPT_LABEL="$(getpartlabel "${_rootdev}")"

        getrootfstype

        UEFISYS_PART_FS_UUID="$(getfsuuid "${_uefisysdev}")"
        UEFISYS_PART_FS_LABEL="$(getfslabel "${_uefisysdev}")"
        UEFISYS_PART_GPT_GUID="$(getpartuuid "${_uefisysdev}")"
        UEFISYS_PART_GPT_LABEL="$(getpartlabel "${_uefisysdev}")"

        [[ "${NAME_SCHEME_PARAMETER}" == "FSUUID" ]] && _rootpart="UUID=${ROOT_PART_FS_UUID}"
        [[ "${NAME_SCHEME_PARAMETER}" == "PARTUUID" ]] && _rootpart="PARTUUID=${ROOT_PART_GPT_GUID}"
        [[ "${NAME_SCHEME_PARAMETER}" == "FSLABEL" ]] && _rootpart="LABEL=${ROOT_PART_FS_LABEL}"
        [[ "${NAME_SCHEME_PARAMETER}" == "PARTLABEL" ]] && _rootpart="PARTLABEL=${ROOT_PART_GPT_LABEL}"
        [[ "${_rootpart}" == "" ]] && _rootpart="${_rootdev}"

        ## TODO: All complex stuff like dmraid, cyptsetup etc. for kernel parameters - common_bootloader_checks ?
        _PARAMETERS_UNMOD="root=${_rootpart} ${ROOTFLAGS} rootfstype=${ROOTFS} ${RAIDARRAYS} ${CRYPTSETUP} ro pci=nocrs add_efi_memmap initrd=\\EFI\\manjaro\\${_EFISTUB_INITRAMFS}.img"
        _PARAMETERS_MOD=$(echo "${_PARAMETERS_UNMOD}" | sed -e 's#   # #g' | sed -e 's#  # #g')

        if [[ "${_EFILINUX}" == "1" ]]; then
            cat << CONFEOF > "${DESTDIR}/boot/efi/EFI/efilinux/efilinux.cfg"
-f \\EFI\\manjaro\\${_EFISTUB_KERNEL} ${_PARAMETERS_MOD} initrd=\\EFI\\manjaro\\${_EFISTUB_INITRAMFS}-fallback.img
CONFEOF
        fi

        # cat << CONFEOF > "${DESTDIR}/boot/efi/EFI/manjaro/linux.conf"
# ${_PARAMETERS_MOD}
# CONFEOF

        ###################################

        if [[ -e "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_KERNEL}" ]] && [[ -e "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}.img" ]]; then
            DIALOG --msgbox "The EFISTUB Kernel and initramfs have been copied to /boot/efi/EFI/manjaro/${_EFISTUB_KERNEL} and /boot/efi/EFI/manjaro/${_EFISTUB_INITRAMFS}.img respectively." 0 0

            if [[ "${_EFILINUX}" == "1" ]]; then
                DIALOG --msgbox "You will now be put into the editor to edit efilinux.cfg . After you save your changes, exit the editor." 0 0
                geteditor || return 1
                "${EDITOR}" "${DESTDIR}/boot/efi/EFI/efilinux/efilinux.cfg"
            # else
                # _BOOTMGR_LABEL="Manjaro Linux (EFISTUB)"
                # _BOOTMGR_LOADER_DIR="manjaro"
                # _BOOTMGR_LOADER_FILE="${_EFISTUB_KERNEL}"
                # do_uefi_bootmgr_setup

                # DIALOG --msgbox "You will now be put into the editor to edit linux.conf . After you save your changes, exit the editor." 0 0
                # geteditor || return 1
                # "${EDITOR}" "${DESTDIR}/boot/efi/EFI/manjaro/linux.conf"

                # DIALOG --defaultno --yesno "Do you want to copy /boot/efi/EFI/manjaro/${_EFISTUB_KERNEL} to /boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi .\n\nThis might be needed in some systems where efibootmgr may not work due to firmware issues." 0 0 && _UEFISYS_EFI_BOOT_DIR="1"

                # if [[ "${_UEFISYS_EFI_BOOT_DIR}" == "1" ]]; then
                    # mkdir -p "${DESTDIR}/boot/efi/EFI/boot"

                    # rm -f "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"
                    # rm -f "${DESTDIR}/boot/efi/EFI/boot/linux.conf"

                    # cp -f "${DESTDIR}/boot/efi/EFI/manjaro/${_EFISTUB_KERNEL}" "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"
                    # cp -f "${DESTDIR}/boot/efi/EFI/boot/linux.conf" "${DESTDIR}/boot/efi/EFI/boot/linux.conf"
                # fi
            fi

            DIALOG --menu "Select which UEFI Boot Manager to install, to provide a menu for EFISTUB kernels?" 13 55 3 \
                "rEFInd_UEFI_${UEFI_ARCH}" "rEFInd ${UEFI_ARCH} UEFI Boot Manager" \
                "GUMMIBOOT_UEFI_${UEFI_ARCH}" "Simple Text Mode ${UEFI_ARCH} UEFI Boot Manager" \
                "NONE" "No Boot Manager" 2>${ANSWER} || CANCEL=1
            case $(cat ${ANSWER}) in
                "GUMMIBOOT_UEFI_${UEFI_ARCH}") dogummiboot_uefi_common ;;
                "rEFInd_UEFI_${UEFI_ARCH}") dorefind_uefi_common ;;
                "NONE") return 0 ;;
            esac
        else
            DIALOG --msgbox "Error setting up EFISTUB kernel and initramfs in /boot/efi." 0 0
        fi
    fi

}

do_efistub_uefi_x86_64(){

    do_uefi_x86_64

    doefistub_uefi_common

}

do_efistub_uefi_i686(){

    do_uefi_i386

    doefistub_uefi_common

}

dogummiboot_uefi_common(){

    DIALOG --msgbox "Setting up gummiboot-efi now ..." 0 0

    mkdir -p "${DESTDIR}/boot/efi/EFI/gummiboot/"
    cp -f "${DESTDIR}/usr/lib/gummiboot/gummiboot${_SPEC_UEFI_ARCH}.efi" "${DESTDIR}/boot/efi/EFI/gummiboot/gummiboot${_SPEC_UEFI_ARCH}.efi"

    if [[ "${_EFILINUX}" == "1" ]]; then
        cat << GUMEOF > "${DESTDIR}/boot/efi/loader/entries/manjaro-lts.conf"
title   Manjaro Linux LTS via EFILINUX
efi     /EFI/efilinux/efilinux${_SPEC_UEFI_ARCH}.efi
options $(cat "${DESTDIR}/boot/efi/EFI/efilinux/efilinux.cfg")
GUMEOF

        cat << GUMEOF > "${DESTDIR}/boot/efi/loader/entries/manjaro-lts-fallback.conf"
title   Manjaro Linux LTS via EFILINUX  - fallback initramfs
efi     /EFI/efilinux/efilinux${_SPEC_UEFI_ARCH}.efi
options $(cat "${DESTDIR}/boot/efi/EFI/efilinux/efilinux.cfg") initrd=\\EFI\\manjaro\\${_EFISTUB_INITRAMFS}-fallback.img
GUMEOF

        cat << GUMEOF > "${DESTDIR}/boot/efi/loader/loader.conf"
timeout 5
default manjaro-lts
GUMEOF

    else
        cat << GUMEOF > "${DESTDIR}/boot/efi/loader/entries/manjaro.conf"
title   Manjaro Linux
linux   /EFI/manjaro/${_EFISTUB_KERNEL}
initrd  /EFI/manjaro/${_EFISTUB_INITRAMFS}.img
options ${_PARAMETERS_MOD}
GUMEOF

        cat << GUMEOF > "${DESTDIR}/boot/efi/loader/entries/manjaro-fallback.conf"
title   Manjaro Linux fallback initramfs
linux   /EFI/manjaro/${_EFISTUB_KERNEL}
initrd  /EFI/manjaro/${_EFISTUB_INITRAMFS}-fallback.img
options ${_PARAMETERS_MOD}
GUMEOF

        cat << GUMEOF > "${DESTDIR}/boot/efi/loader/loader.conf"
timeout 5
default manjaro
GUMEOF

    fi

    if [[ -e "${DESTDIR}/boot/efi/EFIgummiboot/gummiboot${_SPEC_UEFI_ARCH}.efi" ]]; then
        _BOOTMGR_LABEL="Manjaro Linux (gummiboot)"
        _BOOTMGR_LOADER_DIR="gummiboot"
        _BOOTMGR_LOADER_FILE="gummiboot${_SPEC_UEFI_ARCH}.efi"
        do_uefi_bootmgr_setup

        DIALOG --msgbox "gummiboot-efi has been setup successfully." 0 0

        DIALOG --msgbox "You will now be put into the editor to edit loader.conf and gummiboot menu entry files . After you save your changes, exit the editor." 0 0
        geteditor || return 1

        if [[ "${_EFILINUX}" == "1" ]]; then
            "${EDITOR}" "${DESTDIR}/boot/efi/loader/entries/manjaro-lts.conf"
            "${EDITOR}" "${DESTDIR}/boot/efi/loader/entries/manjaro-lts-fallback.conf"
        else
            "${EDITOR}" "${DESTDIR}/boot/efi/loader/entries/manjaro.conf"
            "${EDITOR}" "${DESTDIR}/boot/efi/loader/entries/manjaro-fallback.conf"
        fi

        "${EDITOR}" "${DESTDIR}/boot/efi/loader/loader.conf"

        DIALOG --defaultno --yesno "Do you want to copy /boot/efi/EFI/gummiboot/gummiboot${_SPEC_UEFI_ARCH}.efi to /boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi ?\n\nThis might be needed in some systems where efibootmgr may not work due to firmware issues." 0 0 && _UEFISYS_EFI_BOOT_DIR="1"

        if [[ "${_UEFISYS_EFI_BOOT_DIR}" == "1" ]]; then
            mkdir -p "${DESTDIR}/boot/efi/EFI/boot"
            rm -f "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"
            cp -f "${DESTDIR}/boot/efi/EFI/gummiboot/gummiboot${_SPEC_UEFI_ARCH}.efi" "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"
        fi
    else
        DIALOG --msgbox "Error setting up gummiboot-efi." 0 0
    fi

}

dorefind_uefi_common(){

    DIALOG --msgbox "Setting up refind-efi now ..." 0 0

    mkdir -p "${DESTDIR}/boot/efi/EFI/refind/"
    cp -f "${DESTDIR}/usr/lib/refind/refind${_SPEC_UEFI_ARCH}.efi" "${DESTDIR}/boot/efi/EFI/refind/refind${_SPEC_UEFI_ARCH}.efi"
    cp -r "${DESTDIR}/usr/share/refind/icons" "${DESTDIR}/boot/efi/EFI/refind/icons"

    mkdir -p "${DESTDIR}/boot/efi/EFI/tools/"
    cp -rf "${DESTDIR}/usr/lib/refind/drivers_${_SPEC_UEFI_ARCH}" "${DESTDIR}/boot/efi/EFI/tools/drivers_${_SPEC_UEFI_ARCH}"

    _REFIND_CONFIG="${DESTDIR}/boot/efi/EFI/refind/refind.conf"
    cp -f "${DESTDIR}/usr/lib/refind/config/refind.conf" "${_REFIND_CONFIG}"

    sed 's|^timeout 20|timeout 5|g' -i "${_REFIND_CONFIG}"
    sed 's|^#hideui singleuser|hideui singleuser|g' -i "${_REFIND_CONFIG}"
    sed 's|^#resolution 1024 768|resolution 1024 768|g' -i "${_REFIND_CONFIG}"
    sed 's|^#use_graphics_for osx,linux|use_graphics_for osx|g' -i "${_REFIND_CONFIG}"
    sed 's|^#showtools shell, about, reboot|showtools shell,about,reboot,shutdown,exit|g' -i "${_REFIND_CONFIG}"
    sed 's|^#scan_driver_dirs EFI/tools/drivers,drivers|scan_driver_dirs EFI/tools/drivers_${_SPEC_UEFI_ARCH}|g' -i "${_REFIND_CONFIG}"
    sed 's|^#scanfor internal,external,optical,manual|scanfor manual,internal,external,optical|g' -i "${_REFIND_CONFIG}"
    sed 's|^#scan_delay 5|scan_delay 1|g' -i "${_REFIND_CONFIG}"
    sed 's|^#also_scan_dirs boot,EFI/linux/kernels|also_scan_dirs boot|g' -i "${_REFIND_CONFIG}"
    sed 's|^#dont_scan_dirs EFI/boot|dont_scan_dirs EFI/boot|g' -i "${_REFIND_CONFIG}"
    sed 's|^#scan_all_linux_kernels|scan_all_linux_kernels|g' -i "${_REFIND_CONFIG}"
    sed 's|^#max_tags 0|max_tags 0|g' -i "${_REFIND_CONFIG}"

    if [[ "${_EFILINUX}" == "1" ]]; then
        cat << REFINDEOF >> "${_REFIND_CONFIG}"

menuentry "Manjaro Linux LTS via EFILINUX" {
	icon /EFI/refind/icons/os_linux.icns
	loader /EFI/efilinux/efilinux${_SPEC_UEFI_ARCH}.efi
	options "$(cat "${DESTDIR}/boot/efi/EFI/efilinux/efilinux.cfg")"
}

menuentry "Manjaro Linux LTS via EFILINUX - fallback initramfs" {
	icon /EFI/refind/icons/os_linux.icns
	loader /EFI/efilinux/efilinux${_SPEC_UEFI_ARCH}.efi
	options "$(cat "${DESTDIR}/boot/efi/EFI/efilinux/efilinux.cfg") initrd=\\EFI\\manjaro\\${_EFISTUB_INITRAMFS}-fallback.img"
}

REFINDEOF

    else
        cat << REFINDEOF > "${DESTDIR}/boot/efi/EFI/manjaro/refind_linux.conf"
"Boot with Defaults"              "${_PARAMETERS_MOD}"
"Boot with fallback initramfs"    "${_PARAMETERS_MOD} initrd=\\EFI\\manjaro\\${_EFISTUB_INITRAMFS}-fallback.img"
REFINDEOF

    fi

    if [[ -e "${DESTDIR}/boot/efi/EFI/refind/refind${_SPEC_UEFI_ARCH}.efi" ]]; then
        _BOOTMGR_LABEL="Manjaro Linux (rEFInd)"
        _BOOTMGR_LOADER_DIR="refind"
        _BOOTMGR_LOADER_FILE="refind${_SPEC_UEFI_ARCH}.efi"
        do_uefi_bootmgr_setup

        DIALOG --msgbox "refind-efi has been setup successfully." 0 0

        DIALOG --msgbox "You will now be put into the editor to edit refind.conf (and maybe refind_linux.conf) . After you save your changes, exit the editor." 0 0
        geteditor || return 1
        "${EDITOR}" "${_REFIND_CONFIG}"
        [[ "${_EFILINUX}" != "1" ]] && "${EDITOR}" "${DESTDIR}/boot/efi/EFI/manjaro/refind_linux.conf"

        DIALOG --defaultno --yesno "Do you want to copy /boot/efi/EFI/refind/refind${_SPEC_UEFI_ARCH}.efi to /boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi ?\n\nThis might be needed in some systems where efibootmgr may not work due to firmware issues." 0 0 && _UEFISYS_EFI_BOOT_DIR="1"

        if [[ "${_UEFISYS_EFI_BOOT_DIR}" == "1" ]]; then
            mkdir -p "${DESTDIR}/boot/efi/EFI/boot"

            rm -f "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"
            rm -f "${DESTDIR}/boot/efi/EFI/boot/refind.conf"
            rm -rf "${DESTDIR}/boot/efi/EFI/boot/icons"

            cp -f "${DESTDIR}/boot/efi/EFI/refind/refind${_SPEC_UEFI_ARCH}.efi" "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"
            cp -f "${_REFIND_CONFIG}" "${DESTDIR}/boot/efi/EFI/boot/refind.conf"
            cp -rf "${DESTDIR}/boot/efi/EFI/refind/icons" "${DESTDIR}/boot/efi/EFI/boot/icons"
        fi
    else
        DIALOG --msgbox "Error setting up refind-efi." 0 0
    fi

}

# install syslinux and run preparation
prepare_syslinux(){
    USE_DMRAID=""
    common_bootloader_checks
}

# common syslinux funtion
common_syslinux(){
    DEVS="$(findbootloaderdisks _)"
    DEVS="${DEVS} $(findbootloaderpartitions _)"

    if [[ "${DEVS}" == "" ]]; then
        DIALOG --msgbox "No hard drives were found" 0 0
        return 1
    fi

    DIALOG --menu "Select the boot device where the ${SYSLINUX} bootloader will be installed (usually the MBR)" 14 55 7 ${DEVS} 2>${ANSWER} || return 1
    ROOTDEV=$(cat ${ANSWER})

    # generate config file
    TEMPDIR=/tmp

    # check if GPT/GUID is used
    GUID_DETECTED=""
    [[ "$(${_BLKID} -p -i -o value -s PTTYPE ${ROOTDEV})" == "gpt" ]] && GUID_DETECTED="1"

    PARTITION_NUMBER=$(echo ${bootdev} | sed -e 's#.*[a-z]##g')
    if [[ "${GUID_DETECTED}" == '1' ]]; then
        # Set Legacy BIOS Bootable GPT Partition Attribute using sgdisk
        if ! [[ "$(sgdisk -i ${PARTITION_NUMBER} ${ROOTDEV} | grep '^Attribute' | grep '4$')" ]]; then
            sgdisk ${ROOTDEV} --attributes=${PARTITION_NUMBER}:set:2
        fi
    else
        # mark the partition with /boot as active in MBR
        parted -s ${ROOTDEV} set ${PARTITION_NUMBER} boot on >${LOG}
    fi

    [[ -e "${TEMPDIR}/${SYSLINUX_CONF}" ]] && rm -f "${TEMPDIR}/${SYSLINUX_CONF}"

    cat << EOF > "${TEMPDIR}/${SYSLINUX_CONF}"
DEFAULT vesamenu.c32
PROMPT 0
MENU TITLE Manjaro Linux
MENU BACKGROUND ${subdir}/${SYSLINUX_DIR}/splash.png
TIMEOUT 300

MENU WIDTH 78
MENU MARGIN 4
MENU ROWS 10
MENU VSHIFT 10
MENU TIMEOUTROW 15
MENU TABMSGROW 13
MENU CMDLINEROW 11
MENU HELPMSGROW 17
MENU HELPMSGENDROW 29

# Refer to http://syslinux.zytor.com/wiki/index.php/Doc/menu

MENU COLOR border       30;44   #40ffffff #a0000000 std
MENU COLOR title        1;36;44 #9033ccff #a0000000 std
MENU COLOR sel          7;37;40 #e0ffffff #20ffffff all
MENU COLOR unsel        37;44   #50ffffff #a0000000 std
MENU COLOR help         37;40   #c0ffffff #a0000000 std
MENU COLOR timeout_msg  37;40   #80ffffff #00000000 std
MENU COLOR timeout      1;37;40 #c0ffffff #00000000 std
MENU COLOR msg07        37;40   #90ffffff #a0000000 std
MENU COLOR tabmsg       31;40   #30ffffff #00000000 std

ONTIMEOUT manjaro
EOF
    sort /tmp/.device-names >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "label manjaro" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "TEXT HELP" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "Boot Manjaro Linux" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "ENDTEXT" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "MENU LABEL Manjaro Linux" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "LINUX ${subdir}/${VMLINUZ}" >> "${TEMPDIR}/${SYSLINUX_CONF}"

    if [[ "${NAME_SCHEME_PARAMETER}" == "FSUUID" || "${NAME_SCHEME_PARAMETER}" == "FSLABEL" ]]; then
        echo "append initrd=${subdir}/${INITRAMFS}.img root=${_rootpart} ${ROOTFLAGS} rootfstype=${ROOTFS} ${RAIDARRAYS} ${CRYPTSETUP} ro" | sed -e 's#  # #g' >> "${TEMPDIR}/${SYSLINUX_CONF}"
    else
        echo "append initrd=${subdir}/${INITRAMFS}.img root=${PART_ROOT} ${ROOTFLAGS} rootfstype=${ROOTFS} ${RAIDARRAYS} ${CRYPTSETUP} ro" | sed -e 's#  # #g' >> "${TEMPDIR}/${SYSLINUX_CONF}"
    fi

    echo "label fallback" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "TEXT HELP" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "Boot Manjaro Linux Fallback" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "ENDTEXT" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "MENU LABEL Manjaro Linux Fallback" >> "${TEMPDIR}/${SYSLINUX_CONF}"
    echo "LINUX ${subdir}/${VMLINUZ}" >> "${TEMPDIR}/${SYSLINUX_CONF}"

    if [[ "${NAME_SCHEME_PARAMETER}" == "FSUUID" || "${NAME_SCHEME_PARAMETER}" == "FSLABEL" ]]; then
        echo "append initrd=${subdir}/${INITRAMFS}-fallback.img root=${_rootpart} ${ROOTFLAGS} rootfstype=${ROOTFS} ${RAIDARRAYS} ${CRYPTSETUP}" | sed -e 's#  # #g' >> "${TEMPDIR}/${SYSLINUX_CONF}"
    else
        echo "append initrd=${subdir}/${INITRAMFS}-fallback.img root=${PART_ROOT} ${ROOTFLAGS} rootfstype=${ROOTFS} ${RAIDARRAYS} ${CRYPTSETUP}" | sed -e 's#  # #g' >> "${TEMPDIR}/${SYSLINUX_CONF}"
    fi

    # edit config file
    DIALOG --msgbox "Before installing ${SYSLINUX}, you must review the configuration file.  You will now be put into the editor.  After you save your changes and exit the editor, ${SYSLINUX} will be installed." 0 0
    geteditor || return 1
    "${EDITOR}" "${TEMPDIR}/${SYSLINUX_CONF}"

    # install syslinux
    DIALOG --infobox "Installing the ${SYSLINUX} bootloader..." 0 0
    ! [[ -d "${DESTDIR}/boot/${SYSLINUX_DIR}" ]] && mkdir -p "${DESTDIR}/boot/${SYSLINUX_DIR}"
    cp -f "${TEMPDIR}/${SYSLINUX_CONF}" "${DESTDIR}/boot/${SYSLINUX_DIR}/${SYSLINUX_CONF}"
    cp -f "${DESTDIR}/usr/lib/syslinux"/*.c32 "${DESTDIR}/boot/${SYSLINUX_DIR}"
}

# finish_syslinux
finish_syslinux (){
    MBR="${DESTDIR}/usr/lib/syslinux/mbr.bin"
    GPTMBR="${DESTDIR}/usr/lib/syslinux/gptmbr.bin"

    CHECKDEV=$(echo ${ROOTDEV} | sed 's|/dev/||g')

    ## Install MBR boot code only if the selected ROOTDEV is a DISC and not a partition
    if [[ -e "${block}/${CHECKDEV}" ]]; then
        ## check if GPT/GUID is used
        GUID_DETECTED=""
        [[ "$(${_BLKID} -p -i -o value -s PTTYPE ${ROOTDEV})" == "gpt" ]] && GUID_DETECTED="1"

        if [[ "${GUID_DETECTED}" == '1' ]]; then
            cat "${GPTMBR}" > "${ROOTDEV}"
        else
            cat "${MBR}" > "${ROOTDEV}"
        fi
    fi

    [[ -f "${_MEDIA}/boot/syslinux/splash.png" ]] && cp -f "${_MEDIA}/boot/syslinux/splash.png" "${DESTDIR}/boot/${SYSLINUX_DIR}"
    chroot_umount

    if [[ -e "${DESTDIR}/boot/${SYSLINUX_DIR}/ldlinux.sys" ]]; then
        DIALOG --msgbox "${SYSLINUX} was successfully installed." 0 0
    else
        DIALOG --msgbox "Error installing ${SYSLINUX}. (see ${LOG} for output)" 0 0
        chroot_umount
        return 1
    fi
}

# install extlinux bootloader
dosyslinux_bios (){
    bootdev=""
    SYSLINUX_PACKAGES="syslinux"
    SYSLINUX=EXTLINUX
    SYSLINUX_PROGRAM=extlinux
    SYSLINUX_DIR=syslinux
    SYSLINUX_CONF=syslinux.cfg
    SYSLINUX_OPTS=""

    prepare_syslinux
    check_bootpart
    abort_nilfs_bootpart || return 1

    # extlinux only can boot from ext2/3/4 and btrfs partitions!
    FSTYPE="$(${_BLKID} -p -i -o value -s TYPE ${bootdev})"
    if ! [[ "${FSTYPE}" == "ext2" || "${FSTYPE}" == "ext3" || "${FSTYPE}" == "ext4" || "${FSTYPE}" == "btrfs" || "${FSTYPE}" == "vfat" ]]; then
        DIALOG --msgbox "Error:\nCouldn't find ext2/3/4 , btrfs or vfat partition with /boot on it." 0 0
        return 1
    fi

    # extlinux cannot boot from any raid partition, encrypted and dmraid device
    if [[ "$(echo ${bootdev} | grep /dev/md*p)" || "$(echo ${bootdev} | grep /dev/mapper)" ]]; then
        DIALOG --msgbox "Error:\n${SYSLINUX} cannot boot from any raid partition, encrypted or dmraid device." 0 0
        return 1
    fi

    # check if raid1 device is used, else fail.
    if [[ "$(echo ${bootdev} | grep /dev/md)" ]]; then
        if ! [[ "$(mdadm --detail ${bootdev} | grep Level | sed -e 's#.*:\ ##g')" = "raid1" ]]; then
            DIALOG --msgbox "Error:\n${SYSLINUX} cannot boot from non raid1 devices." 0 0
            return 1
        else
            SYSLINUX_OPTS="--raid"
        fi
    fi

    # extlinux cannot boot from btrfs raid
    find_btrfs_raid_bootloader_devices
    if [[ ${BTRFS_COUNT} -ge 3 ]]; then
        DIALOG --msgbox "Error:\n${SYSLINUX} cannot boot from any btrfs raid." 0 0
        return 1
    fi

    # extlinux cannot boot from btrfs subvolume
    find_btrfs_bootloader_subvolume
    if [[ ${BTRFS_SUBVOLUME_COUNT} -ge 3 ]]; then
        DIALOG --msgbox "Error:\n${SYSLINUX} cannot boot from btrfs subvolume." 0 0
        return 1
    fi

    common_syslinux
    chroot_mount
    chroot ${DESTDIR} ${SYSLINUX_PROGRAM} ${SYSLINUX_OPTS} --install /boot/${SYSLINUX_DIR} >${LOG} 2>&1
    finish_syslinux
}

dogrub_common_before(){
    ##### Check whether the below limitations still continue with ver 2.00~beta4
    ### Grub(2) restrictions:
    # - Encryption is not recommended for grub(2) /boot!

    bootdev=""
    grubdev=""
    complexuuid=""
    FAIL_COMPLEX=""
    USE_DMRAID=""
    RAID_ON_LVM=""
    common_bootloader_checks

    if ! [[ "$(dmraid -r | grep ^no )" ]]; then
        DIALOG --yesno "Setup detected dmraid device.\nDo you want to install grub on this device?" 0 0 && USE_DMRAID="1"
    fi
}

dogrub_config(){

    ########

    BOOT_PART_FS_UUID="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_uuid" "${DESTDIR}/boot" 2>/dev/null)"
    BOOT_PART_FS="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs" "${DESTDIR}/boot" 2>/dev/null)"

    BOOT_PART_FS_LABEL="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_label" "${DESTDIR}/boot" 2>/dev/null)"
    BOOT_PART_DRIVE="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="drive" "${DESTDIR}/boot" 2>/dev/null)"

    BOOT_PART_HINTS_STRING="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="hints_string" "${DESTDIR}/boot" 2>/dev/null)"

    ########

    ROOT_PART_FS_UUID="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_uuid" "${DESTDIR}/" 2>/dev/null)"
    ROOT_PART_FS="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs" "${DESTDIR}/" 2>/dev/null)"

    ROOT_PART_FS_LABEL="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_label" "${DESTDIR}/" 2>/dev/null)"
    ROOT_PART_DEVICE="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="device" "${DESTDIR}/" 2>/dev/null)"

    ROOT_PART_HINTS_STRING="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="hints_string" "${DESTDIR}/" 2>/dev/null)"

    ########

    USR_PART_FS_UUID="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_uuid" "${DESTDIR}/usr" 2>/dev/null)"
    USR_PART_FS="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs" "${DESTDIR}/usr" 2>/dev/null)"

    USR_PART_FS_LABEL="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_label" "${DESTDIR}/usr" 2>/dev/null)"

    USR_PART_HINTS_STRING="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="hints_string" "${DESTDIR}/usr" 2>/dev/null)"

    ########

    if [[ "${GRUB_UEFI}" == "1" ]]; then
        UEFISYS_PART_FS_UUID="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_uuid" "${DESTDIR}/boot/efi" 2>/dev/null)"

        UEFISYS_PART_FS_LABEL="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_label" "${DESTDIR}/boot/efi" 2>/dev/null)"
        UEFISYS_PART_DRIVE="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="drive" "${DESTDIR}/boot/efi" 2>/dev/null)"

        UEFISYS_PART_HINTS_STRING="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="hints_string" "${DESTDIR}/boot/efi" 2>/dev/null)"
    fi

    ########

    ## udev 180 onwards
    if [[ "$(${_BLKID} -p -i  -o value -s PART_ENTRY_SCHEME ${ROOT_PART_DEVICE})" == 'gpt' ]]; then
        ROOT_PART_GPT_GUID="$(${_BLKID} -p -i -o value -s PART_ENTRY_UUID ${ROOT_PART_DEVICE})"
        ROOT_PART_GPT_LABEL="$(${_BLKID} -p -i -o value -s PART_ENTRY_NAME ${ROOT_PART_DEVICE})"
    fi

    ########

    if [[ "${ROOT_PART_FS_UUID}" == "${BOOT_PART_FS_UUID}" ]]; then
        subdir="/boot"
    else
        subdir=""
    fi

    ########

    ## Move old config file, if any
    mv "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg" "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg.bak" || true

    ## Ignore if the insmod entries are repeated - there are possibilities of having /boot in one disk and root-fs in altogether different disk
    ## with totally different configuration.

    cat << EOF > "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

if [ "\${grub_platform}" == "efi" ]; then
    set _UEFI_ARCH="\${grub_cpu}"

    if [ "\${grub_cpu}" == "x86_64" ]; then
        set _SPEC_UEFI_ARCH="x64"
    fi

    if [ "\${grub_cpu}" == "i386" ]; then
        set _SPEC_UEFI_ARCH="ia32"
    fi
fi

EOF

    cat << EOF >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

insmod part_gpt
insmod part_msdos

# Include fat fs module - required for uefi systems.
insmod fat

insmod ${BOOT_PART_FS}
insmod ${ROOT_PART_FS}
insmod ${USR_PART_FS}

insmod search_fs_file
insmod search_fs_uuid
insmod search_label

insmod linux
insmod chain

set pager="1"
# set debug="all"

set locale_dir="\${prefix}/locale"

EOF

    [[ "${USE_RAID}" == "1" ]] && echo "insmod raid" >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"
    ! [[ "${RAID_ON_LVM}" == "" ]] && echo "insmod lvm" >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

    cat << EOF >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

if [ -e "\${prefix}/\${grub_cpu}-\${grub_platform}/all_video.mod" ]; then
    insmod all_video
else
    if [ "\${grub_platform}" == "efi" ]; then
        insmod efi_gop
        insmod efi_uga
    fi

    if [ "\${grub_platform}" == "pc" ]; then
        insmod vbe
        insmod vga
    fi

    insmod video_bochs
    insmod video_cirrus
fi

insmod font

search --fs-uuid --no-floppy --set=usr_part ${USR_PART_HINTS_STRING} ${USR_PART_FS_UUID}
search --fs-uuid --no-floppy --set=root_part ${ROOT_PART_HINTS_STRING} ${ROOT_PART_FS_UUID}

if [ -e "(\${usr_part})/share/grub/unicode.pf2" ]; then
    set _fontfile="(\${usr_part})/share/grub/unicode.pf2"
else
    if [ -e "(\${root_part})/usr/share/grub/unicode.pf2" ]; then
        set _fontfile="(\${root_part})/usr/share/grub/unicode.pf2"
    else
        if [ -e "\${prefix}/fonts/unicode.pf2" ]; then
            set _fontfile="\${prefix}/fonts/unicode.pf2"
        fi
    fi
fi

if loadfont "\${_fontfile}" ; then
    insmod gfxterm
    set gfxmode="auto"

    terminal_input console
    terminal_output gfxterm
fi

EOF

    echo "" >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"
    sort "/tmp/.device-names" >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"
    echo "" >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

    if [[ "${NAME_SCHEME_PARAMETER}" == "FSUUID" ]]; then
        GRUB_ROOT_DRIVE="search --fs-uuid --no-floppy --set=root ${BOOT_PART_HINTS_STRING} ${BOOT_PART_FS_UUID}"
        _rootpart="UUID=${ROOT_PART_FS_UUID}"

    elif [[ "${NAME_SCHEME_PARAMETER}" == "PARTUUID" ]]; then
        GRUB_ROOT_DRIVE="search --fs-uuid --no-floppy --set=root ${BOOT_PART_HINTS_STRING} ${BOOT_PART_FS_UUID}" # GRUB(2) does not yet support PARTUUID
        _rootpart="PARTUUID=${ROOT_PART_GPT_GUID}"

    elif [[ "${NAME_SCHEME_PARAMETER}" == "FSLABEL" ]]; then
        GRUB_ROOT_DRIVE="search --label --no-floppy --set=root ${BOOT_PART_HINTS_STRING} ${BOOT_PART_FS_LABEL}"
        _rootpart="LABEL=${ROOT_PART_FS_LABEL}"

    elif [[ "${NAME_SCHEME_PARAMETER}" == "PARTLABEL" ]]; then
        GRUB_ROOT_DRIVE="search --label --no-floppy --set=root ${BOOT_PART_HINTS_STRING} ${BOOT_PART_FS_LABEL}" # GRUB(2) does not yet support PARTLABEL
        _rootpart="PARTLABEL=${ROOT_PART_GPT_LABEL}"

    else
        GRUB_ROOT_DRIVE="set root="${BOOT_PART_DRIVE}""
        _rootpart="${ROOT_PART_DEVICE}"

    fi

    # fallback to device if no label or uuid can be detected, eg. luks device
    if [[ -z "${ROOT_PART_FS_UUID}" ]] && [[ -z "${ROOT_PART_FS_LABEL}" ]]; then
        _rootpart="${ROOT_PART_DEVICE}"
    fi

    LINUX_UNMOD_COMMAND="linux ${subdir}/${VMLINUZ} root=${_rootpart} ${ROOTFLAGS} rootfstype=${ROOTFS} ${RAIDARRAYS} ${CRYPTSETUP} ro"
    LINUX_MOD_COMMAND=$(echo "${LINUX_UNMOD_COMMAND}" | sed -e 's#   # #g' | sed -e 's#  # #g')

    ## create default kernel entry

    NUMBER="0"

    cat << EOF >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

# (${NUMBER}) Manjaro Linux
menuentry "Manjaro Linux" {
    set gfxpayload="keep"
    ${GRUB_ROOT_DRIVE}
    ${LINUX_MOD_COMMAND}
    initrd ${subdir}/${INITRAMFS}.img
}

EOF

    NUMBER=$((${NUMBER}+1))

    ## create kernel fallback entry
    cat << EOF >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

# (${NUMBER}) Manjaro Linux Fallback
menuentry "Manjaro Linux Fallback" {
    set gfxpayload="keep"
    ${GRUB_ROOT_DRIVE}
    ${LINUX_MOD_COMMAND}
    initrd ${subdir}/${INITRAMFS}-fallback.img
}

EOF

    NUMBER=$((${NUMBER}+1))

    cat << EOF >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

if [ "\${grub_platform}" == "efi" ]; then

    ## UEFI Shell 2.0
    ## Will work only in grub(2) uefi
    #menuentry "UEFI \${_UEFI_ARCH} Shell 2.0 - For Spec. Ver. >=2.3 systems" {
    #    search --fs-uuid --no-floppy --set=root ${UEFISYS_PART_HINTS_STRING} ${UEFISYS_PART_FS_UUID}
    #    chainloader /efi/tools/shell\${_SPEC_UEFI_ARCH}.efi
    #}

    ## UEFI Shell 1.0
    ## Will work only in grub(2) uefi
    #menuentry "UEFI \${_UEFI_ARCH} Shell 1.0 - For Spec. Ver. <2.3 systems" {
    #    search --fs-uuid --no-floppy --set=root ${UEFISYS_PART_HINTS_STRING} ${UEFISYS_PART_FS_UUID}
    #    chainloader /efi/tools/shell\${_SPEC_UEFI_ARCH}_old.efi
    #}

fi

EOF

    NUMBER=$((${NUMBER}+1))

    cat << EOF >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

if [ "\${grub_platform}" == "efi" ]; then

    ## Windows x86_64 UEFI
    ## Will work only in grub(2) uefi x86_64
    #menuentry \"Microsoft Windows x86_64 UEFI-GPT\" {
    #    insmod part_gpt
    #    insmod fat
    #    insmod search_fs_uuid
    #    insmod chain
    #    search --fs-uuid --no-floppy --set=root ${UEFISYS_PART_HINTS_STRING} ${UEFISYS_PART_FS_UUID}
    #    chainloader /efi/Microsoft/Boot/bootmgfw.efi
    #}

fi

EOF

    NUMBER=$((${NUMBER}+1))

    ## TODO: Detect actual Windows installation if any
    ## create example file for windows
    cat << EOF >> "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

if [ "\${grub_platform}" == "pc" ]; then

    ## Windows BIOS
    ## Will work only in grub(2) bios
    #menuentry \"Microsoft Windows 7 BIOS-MBR\" {
    #    insmod part_msdos
    #    insmod ntfs
    #    insmod search_fs_uuid
    #    insmod ntldr
    #    search --fs-uuid --no-floppy --set=root 69B235F6749E84CE
    #    ntldr /bootmgr
    #}

fi

EOF

    ## copy unicode.pf2 font file
    cp -f "${DESTDIR}/usr/share/grub/unicode.pf2" "${DESTDIR}/${GRUB_PREFIX_DIR}/fonts/unicode.pf2"

    ## Edit grub.cfg config file
    DIALOG --msgbox "You must now review the grub(2) configuration file.\n\nYou will now be put into the editor. After you save your changes, exit the editor." 0 0
    geteditor || return 1
    "${EDITOR}" "${DESTDIR}/${GRUB_PREFIX_DIR}/grub.cfg"

    unset BOOT_PART_FS_UUID
    unset BOOT_PART_FS
    unset BOOT_PART_FS_LABEL
    unset BOOT_PART_DRIVE

    unset ROOT_PART_FS_UUID
    unset ROOT_PART_FS
    unset ROOT_PART_FS_LABEL
    unset ROOT_PART_DEVICE

    unset GRUB_ROOT_DRIVE
    unset LINUX_UNMOD_COMMAND
    unset LINUX_MOD_COMMAND

}

dogrub_bios(){

    dogrub_common_before

    # try to auto-configure GRUB(2)...
    if [[ "${PART_ROOT}" != "" ]]; then
        check_bootpart

        # check if raid, raid partition, dmraid or device devicemapper is used
        if [[ "$(echo ${bootdev} | grep /dev/md)" ]] || [[ "$(echo ${bootdev} | grep /dev/mapper)" ]]; then
            # boot from lvm, raid, partitioned raid and dmraid devices is supported
            FAIL_COMPLEX="0"

            if [[ "$(cryptsetup status ${bootdev})" ]]; then
                # encryption devices are not supported
                FAIL_COMPLEX="1"
            fi
        fi

        if [[ "${FAIL_COMPLEX}" == "0" ]]; then
            grubdev=$(basename ${bootdev})
            complexuuid=$(getfsuuid ${bootdev})
            # check if mapper is used
            if  [[ "$(echo ${bootdev} | grep /dev/mapper)" ]]; then
                RAID_ON_LVM="0"

                #check if mapper contains a md device!
                for devpath in $(pvs -o pv_name --noheading); do
                    if [[ "$(echo ${devpath} | grep -v /dev/md*p | grep /dev/md)" ]]; then
                        detectedvolumegroup="$(echo $(pvs -o vg_name --noheading ${devpath}))"

                        if [[ "$(echo /dev/mapper/${detectedvolumegroup}-* | grep ${bootdev})" ]]; then
                            # change bootdev to md device!
                            bootdev=$(pvs -o pv_name --noheading ${devpath})
                            RAID_ON_LVM="1"
                            break
                        fi
                    fi
                done
            fi

            #check if raid is used
            USE_RAID=""
            if [[ "$(echo ${bootdev} | grep /dev/md)" ]]; then
                USE_RAID="1"
            fi
        else
            # use normal device
            grubdev=$(mapdev ${bootdev})
        fi
    fi


    # A switch is needed if complex ${bootdev} is used!
    # - LVM and RAID ${bootdev} needs the MBR of a device and cannot be used itself as ${bootdev}
    if [[ "${FAIL_COMPLEX}" == "0" ]]; then
        DEVS="$(findbootloaderdisks _)"

        if [[ "${DEVS}" == "" ]]; then
            DIALOG --msgbox "No hard drives were found" 0 0
            return 1
        fi

        DIALOG --menu "Select the boot device where the GRUB(2) bootloader will be installed." 14 55 7 ${DEVS} 2>${ANSWER} || return 1
        bootdev=$(cat ${ANSWER})
    else
        DEVS="$(findbootloaderdisks _)"

        ## grub-bios install to partition is not supported
        # DEVS="${DEVS} $(findbootloaderpartitions _)"

        if [[ "${DEVS}" == "" ]]; then
            DIALOG --msgbox "No hard drives were found" 0 0
            return 1
        fi

        DIALOG --menu "Select the boot device where the GRUB(2) bootloader will be installed (usually the MBR  and not a partition)." 14 55 7 ${DEVS} 2>${ANSWER} || return 1
        bootdev=$(cat ${ANSWER})
    fi

    if [[ "$(${_BLKID} -p -i -o value -s PTTYPE ${bootdev})" == "gpt" ]]; then
        CHECK_BIOS_BOOT_GRUB="1"
        CHECK_UEFISYS_PART=""
        RUN_CGDISK=""
        DISC="${bootdev}"
        check_gpt
    else
        if [[ "${FAIL_COMPLEX}" == "0" ]]; then
            DIALOG --defaultno --yesno "Warning:\nSetup detected no GUID (gpt) partition table.\n\nGrub(2) has only space for approx. 30k core.img file. Depending on your setup, it might not fit into this gap and fail.\n\nDo you really want to install grub(2) to a msdos partition table?" 0 0 || return 1
        fi
    fi

    if [[ "${FAIL_COMPLEX}" == "1" ]]; then
        DIALOG --msgbox "Error:\nGrub(2) cannot boot from ${bootdev}, which contains /boot!\n\nPossible error sources:\n- encrypted devices are not supported" 0 0
        return 1
    fi

    DIALOG --infobox "Installing the GRUB(2) BIOS bootloader..." 0 0
    # freeze and unfreeze xfs filesystems to enable grub(2) installation on xfs filesystems
    freeze_xfs
    chroot_mount

    chroot "${DESTDIR}" "/usr/bin/grub-install" \
        --directory="/usr/lib/grub/i386-pc" \
        --target="i386-pc" \
        --boot-directory="/boot" \
        --recheck \
        --debug \
        "${bootdev}" &>"/tmp/grub_bios_install.log"

    chroot_umount

    mkdir -p "${DESTDIR}/boot/grub/locale"
    cp -f "${DESTDIR}/usr/share/locale/en@quot/LC_MESSAGES/grub.mo" "${DESTDIR}/boot/grub/locale/en.mo"

    if [[ -e "${DESTDIR}/boot/grub/i386-pc/core.img" ]]; then
        GRUB_PREFIX_DIR="boot/grub"
        GRUB_BIOS="1"
        #dogrub_config
	swap_partition=$(swapon -s | grep dev -m1 | cut -d" " -f1)
        dogrub_mkconfig
        GRUB_BIOS=""
        DIALOG --msgbox "GRUB(2) BIOS has been successfully installed." 0 0
    else
        DIALOG --msgbox "Error installing GRUB(2) BIOS.\nCheck /tmp/grub_bios_install.log for more info.\n\nYou probably need to install it manually by chrooting into ${DESTDIR}.\nDon't forget to bind /dev and /proc into ${DESTDIR} before chrooting." 0 0
        return 1
    fi

}

dogrub_uefi_common(){

    dogrub_common_before

    chroot_mount

    chroot "${DESTDIR}" "/usr/bin/grub-install" \
        --directory="/usr/lib/grub/${_UEFI_ARCH}-efi" \
        --target="${_UEFI_ARCH}-efi" \
        --efi-directory="/boot/efi" \
        --bootloader-id="manjaro_grub" \
        --boot-directory="/boot" \
        --recheck \
        --debug &>"/tmp/grub_uefi_${_UEFI_ARCH}_install.log"

    chroot_umount

    mkdir -p "${DESTDIR}/boot/grub/locale"
    cp -f "${DESTDIR}/usr/share/locale/en@quot/LC_MESSAGES/grub.mo" "${DESTDIR}/boot/grub/locale/en.mo"

    BOOT_PART_FS_UUID="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs_uuid" "${DESTDIR}/boot" 2>/dev/null)"
    BOOT_PART_FS="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="fs" "${DESTDIR}/boot" 2>/dev/null)"

    BOOT_PART_HINTS_STRING="$(LD_LIBRARY_PATH="${DESTDIR}/usr/lib:${DESTDIR}/lib" "${DESTDIR}/usr/bin/grub-probe" --target="hints_string" "${DESTDIR}/boot" 2>/dev/null)"

    [[ -e "${DESTDIR}/boot/grub/grub.cfg" ]] && mv "${DESTDIR}/boot/grub/grub.cfg" "${DESTDIR}/boot/grub/grub.cfg.save"

    cat << EOF > "${DESTDIR}/boot/grub/grub.cfg"

insmod usbms
insmod usb_keyboard

insmod part_gpt
insmod part_msdos

insmod fat
insmod iso9660
insmod udf
insmod ${BOOT_PART_FS}

insmod ext2
insmod reiserfs
insmod ntfs
insmod hfsplus

insmod linux
insmod chain

search --fs-uuid --no-floppy --set=root ${BOOT_PART_HINTS_STRING} ${BOOT_PART_FS_UUID}

if [ -f "(\${root})/grub/grub.cfg" ]; then
    set prefix="(\${root})/grub"
    source "(\${root})/grub/grub.cfg"
else
    if [ -f "(\${root})/boot/grub/grub.cfg" ]; then
        set prefix="(\${root})/boot/grub"
        source "(\${root})/boot/grub/grub.cfg"
    fi
fi

EOF

    cp -f "${DESTDIR}/boot/grub/grub.cfg" "${DESTDIR}/boot/efi/EFI/manjaro_grub/grub${_SPEC_UEFI_ARCH}_standalone.cfg"

    __WD="${PWD}/"

    cd "${DESTDIR}/"

    chroot_mount

    chroot "${DESTDIR}" "/usr/bin/grub-mkstandalone" \
        --directory="/usr/lib/grub/${_UEFI_ARCH}-efi" \
        --format="${_UEFI_ARCH}-efi" \
        --compression="xz" \
        --output="/boot/efi/EFI/manjaro_grub/grub${_SPEC_UEFI_ARCH}_standalone.efi" \
        "boot/grub/grub.cfg" &>"/tmp/grub_${_UEFI_ARCH}_uefi_mkstandalone.log"

    chroot_umount

    cd "${__WD}/"

    [[ -e "${DESTDIR}/boot/grub/grub.cfg.save" ]] && mv "${DESTDIR}/boot/grub/grub.cfg.save" "${DESTDIR}/boot/grub/grub.cfg"

    cat "/tmp/grub_uefi_${_UEFI_ARCH}_install.log" >> "${LOG}"

    if [[ -e "${DESTDIR}/boot/efi/EFI/manjaro_grub/grub${_SPEC_UEFI_ARCH}.efi" ]] && [[ -e "${DESTDIR}/boot/grub/${_UEFI_ARCH}-efi/core.efi" ]]; then
        _BOOTMGR_LABEL="Manjaro Linux (GRUB)"
        _BOOTMGR_LOADER_DIR="manjaro_grub"
        _BOOTMGR_LOADER_FILE="grub${_SPEC_UEFI_ARCH}.efi"
        do_uefi_bootmgr_setup

        DIALOG --msgbox "GRUB(2) UEFI ${_UEFI_ARCH} has been successfully installed." 0 0

        GRUB_PREFIX_DIR="boot/grub"
        GRUB_UEFI="1"
        #dogrub_config
        dogrub_mkconfig
        GRUB_UEFI=""

        DIALOG --defaultno --yesno "Do you want to copy /boot/efi/EFI/manjaro_grub/grub${_SPEC_UEFI_ARCH}.efi to /boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi ?\n\nThis might be needed in some systems where efibootmgr may not work due to firmware issues." 0 0 && _UEFISYS_EFI_BOOT_DIR="1"

        if [[ "${_UEFISYS_EFI_BOOT_DIR}" == "1" ]]; then
            mkdir -p "${DESTDIR}/boot/efi/EFI/boot"

            rm -f "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"

            cp -f "${DESTDIR}/boot/efi/EFI/manjaro_grub/grub${_SPEC_UEFI_ARCH}.efi" "${DESTDIR}/boot/efi/EFI/boot/boot${_SPEC_UEFI_ARCH}.efi"
        fi
    else
        DIALOG --msgbox "Error installing GRUB UEFI ${_UEFI_ARCH}.\nCheck /tmp/grub_uefi_${_UEFI_ARCH}_install.log for more info.\n\nYou probably need to install it manually by chrooting into ${DESTDIR}.\nDon't forget to bind /dev, /sys and /proc into ${DESTDIR} before chrooting." 0 0
        return 1
    fi

}

dogrub_uefi_x86_64(){

    do_uefi_x86_64

    dogrub_uefi_common

}

dogrub_uefi_i386(){

    do_uefi_i386

    dogrub_uefi_common

}

# menu for md creation
_createmd(){
    NEXTITEM=""
    MDDONE=0
    while [[ "${MDDONE}" = "0" ]]; do
        if [[ -n "${NEXTITEM}" ]]; then
            DEFAULT="--default-item ${NEXTITEM}"
        else
            DEFAULT=""
        fi
        CANCEL=""
        dialog ${DEFAULT} --backtitle "${TITLE}" --menu "Create Software Raid" 12 60 5 \
            "1" "Raid Help" \
            "2" "Reset Software Raid completely" \
            "3" "Create Software Raid" \
            "4" "Create Partitionable Software Raid" \
            "5" "Return to Previous Menu" 2>${ANSWER} || CANCEL="1"
        NEXTITEM="$(cat ${ANSWER})"
        case $(cat ${ANSWER}) in
            "1")
                _helpraid ;;
            "2")
                _stopmd ;;
            "3")
                RAID_PARTITION=""
                _raid ;;
            "4")
                RAID_PARTITION="1"
                _raid ;;
              *)
                MDDONE=1 ;;
        esac
    done
    if [[ "${CANCEL}" = "1" ]]; then
        NEXTITEM="1"
    else
        NEXTITEM="4"
    fi
}

# menu for lvm creation
_createlvm(){
    NEXTITEM=""
    LVMDONE=0
    while [[ "${LVMDONE}" = "0" ]]; do
        if [[ -n "${NEXTITEM}" ]]; then
            DEFAULT="--default-item ${NEXTITEM}"
        else
            DEFAULT=""
        fi
        CANCEL=""
        dialog ${DEFAULT} --backtitle "${TITLE}" --menu "Create physical volume, volume group or logical volume" 13 60 7 \
            "1" "LVM Help" \
            "2" "Reset Logical Volume completely" \
            "3" "Create Physical Volume" \
            "4" "Create Volume Group" \
            "5" "Create Logical Volume" \
            "6" "Return to Previous Menu" 2>${ANSWER} || CANCEL="1"
        NEXTITEM="$(cat ${ANSWER})"
        case $(cat ${ANSWER}) in
            "1")
                _helplvm ;;
            "2")
                _stoplvm ;;
            "3")
                _createpv ;;
            "4")
                _createvg ;;
            "5")
                _createlv ;;
              *)
                LVMDONE=1 ;;
        esac
    done
    if [[ "${CANCEL}" = "1" ]]; then
        NEXTITEM="2"
    else
        NEXTITEM="4"
    fi
}

# menu for luks creation
_createluks(){
    NEXTITEM=""
    LUKSDONE=0
    while [[ "${LUKSDONE}" = "0" ]]; do
        if [[ -n "${NEXTITEM}" ]]; then
            DEFAULT="--default-item ${NEXTITEM}"
        else
            DEFAULT=""
        fi
        CANCEL=""
        dialog ${DEFAULT} --backtitle "${TITLE}" --menu "Create Luks Encryption" 12 60 5 \
            "1" "Luks Help" \
            "2" "Reset Luks Encryption completely" \
            "3" "Create Luks" \
            "4" "Return to Previous Menu" 2>${ANSWER} || CANCEL="1"
        NEXTITEM="$(cat ${ANSWER})"
        case $(cat ${ANSWER}) in
            "1")
                _helpluks ;;
            "2")
                _stopluks ;;
            "3")
                _luks ;;
              *)
                LUKSDONE=1 ;;
        esac
    done
    if [[ "${CANCEL}" = "1" ]]; then
        NEXTITEM="3"
    else
        NEXTITEM="4"
    fi
}

install_bootloader_uefi_x86_64(){

    DIALOG --menu "Which x86_64 UEFI bootloader would you like to use?" 13 55 2 \
        "GRUB_UEFI_x86_64" "GRUB(2) x86_64 UEFI" \
        "EFISTUB_x86_64" "Only x86_64 Kernels" 2>${ANSWER} || CANCEL=1
    case $(cat ${ANSWER}) in
        "GRUB_UEFI_x86_64") dogrub_uefi_x86_64 ;;
        "EFISTUB_x86_64") do_efistub_uefi_x86_64 ;;
    esac

}

install_bootloader_uefi_i386(){

    DIALOG --menu "Which i386 UEFI bootloader would you like to use?" 13 55 2 \
        "GRUB_UEFI_i386" "GRUB(2) i386 UEFI" \
        "EFISTUB_i686" "Only i686 Kernels" 2>${ANSWER} || CANCEL=1
    case $(cat ${ANSWER}) in
        "GRUB_UEFI_i386") dogrub_uefi_i386 ;;
        "EFISTUB_i686") do_efistub_uefi_i686 ;;
    esac

}

install_bootloader_bios(){

    DIALOG --menu "Which BIOS bootloader would you like to use?" 11 50 4 \
        "GRUB_BIOS" "GRUB(2) BIOS" \
        "SYSLINUX_BIOS" "SYSLINUX/EXTLINUX" 2>${ANSWER} || CANCEL=1
    case $(cat ${ANSWER}) in
        "GRUB_BIOS") dogrub_bios ;;
        "SYSLINUX_BIOS") dosyslinux_bios ;;
    esac

}

install_bootloader_menu(){

    DIALOG --menu "What is your boot system type?" 10 40 3 \
        "BIOS" "BIOS" \
        "UEFI_x86_64" "x86_64 UEFI" \
        "UEFI_i386" "i386 UEFI" 2>${ANSWER} || CANCEL=1
    case $(cat ${ANSWER}) in
        "BIOS") install_bootloader_bios ;;
        "UEFI_x86_64") install_bootloader_uefi_x86_64 ;;
        "UEFI_i386") install_bootloader_uefi_i386 ;;
    esac

    if [[ "${CANCEL}" = "1" ]]; then
        NEXTITEM="5"
    else
        NEXTITEM="6"
    fi
}

# lists default linux blockdevices
default_blockdevices(){
    # ide devices
    for dev in $(ls ${block} 2>/dev/null | egrep '^hd'); do
        if [[ "$(cat ${block}/${dev}/device/media)" = "disk" ]]; then
            if ! [[ "$(cat ${block}/${dev}/size)" = "0" ]]; then
                if ! [[ "$(cat /proc/mdstat 2>/dev/null | grep "${dev}\[")" || "$(dmraid -rc | grep /dev/${dev})" ]]; then
                    echo "/dev/${dev}"
                    [[ "${1}" ]] && echo ${1}
                fi
            fi
        fi
    done
    #scsi/sata devices, and virtio blockdevices (/dev/vd*)
    for dev in $(ls ${block} 2>/dev/null | egrep '^[sv]d'); do
        # virtio device doesn't have type file!
        blktype="$(cat ${block}/${dev}/device/type 2>/dev/null)"
        if ! [[ "${blktype}" = "5" ]]; then
            if ! [[ "$(cat ${block}/${dev}/size)" = "0" ]]; then
                if ! [[ "$(cat /proc/mdstat 2>/dev/null | grep "${dev}\[")" || "$(dmraid -rc | grep /dev/${dev})" ]]; then
                    echo "/dev/${dev}"
                    [[ "${1}" ]] && echo ${1}
                fi
            fi
        fi
    done
}

# set GUID (gpt) usage
set_guid(){
    ## Lenovo BIOS-GPT issues - Arch Forum - https://bbs.archlinux.org/viewtopic.php?id=131149 , https://bbs.archlinux.org/viewtopic.php?id=133330 , https://bbs.archlinux.org/viewtopic.php?id=138958
    ## Lenovo BIOS-GPT issues - in Fedora - https://bugzilla.redhat.com/show_bug.cgi?id=735733, https://bugzilla.redhat.com/show_bug.cgi?id=749325 , http://git.fedorahosted.org/git/?p=anaconda.git;a=commit;h=ae74cebff312327ce2d9b5ac3be5dbe22e791f09
    GUIDPARAMETER=""
    DIALOG --defaultno --yesno "${_gptinfo}" 0 0 && GUIDPARAMETER="yes"
}

# Disable all software raid devices
_stopmd(){
    if [[ "$(cat /proc/mdstat 2>/dev/null | grep ^md)" ]]; then
        DISABLEMD=""
        DIALOG --defaultno --yesno "${_stop_md}" 0 0 && DISABLEMD="1"
        if [[ "${DISABLEMD}" = "1" ]]; then
            DIALOG --infobox "${_disable_raid}" 0 0
            for i in $(cat /proc/mdstat 2>/dev/null | grep ^md | sed -e 's# :.*##g'); do
                mdadm --manage --stop /dev/${i} > ${LOG}
            done
            DIALOG --infobox "${_clear_superblock}" 0 0
            for i in $(${_BLKID} | grep "TYPE=\"linux_raid_member\"" | sed -e 's#:.*##g'); do
                mdadm --zero-superblock ${i} > ${LOG}
            done
        fi
    fi
    DISABLEMDSB=""
    if [[ "$(${_BLKID} | grep "TYPE=\"linux_raid_member\"")" ]]; then
        DIALOG --defaultno --yesno "${_setup_superblock}" 0 0 && DISABLEMDSB="1"
        if [[ "${DISABLEMDSB}" = "1" ]]; then
            DIALOG --infobox "${_clean_superblock}" 0 0
            for i in $(${_BLKID} | grep "TYPE=\"linux_raid_member\"" | sed -e 's#:.*##g'); do
                mdadm --zero-superblock ${i} > ${LOG}
            done
        fi
    fi
}

# Disable all lvm devices
_stoplvm(){
    DISABLELVM=""
    DETECTED_LVM=""
    LV_VOLUMES="$(lvs -o vg_name,lv_name --noheading --separator - 2>/dev/null)"
    LV_GROUPS="$(vgs -o vg_name --noheading 2>/dev/null)"
    LV_PHYSICAL="$(pvs -o pv_name --noheading 2>/dev/null)"
    ! [[ "${LV_VOLUMES}" = "" ]] && DETECTED_LVM=1
    ! [[ "${LV_GROUPS}" = "" ]] && DETECTED_LVM=1
    ! [[ "${LV_PHYSICAL}" = "" ]] && DETECTED_LVM=1
    if [[ "${DETECTED_LVM}" = "1" ]]; then
        DIALOG --defaultno --yesno "${_stoplvm}" 0 0 && DISABLELVM="1"
    fi
    if [[ "${DISABLELVM}" = "1" ]]; then
        DIALOG --infobox "${_remove_lvm}" 0 0
        for i in ${LV_VOLUMES}; do
            lvremove -f /dev/mapper/${i} 2>/dev/null> ${LOG}
        done
        DIALOG --infobox "${_remove_lvg}" 0 0
        for i in ${LV_GROUPS}; do
            vgremove -f ${i} 2>/dev/null > ${LOG}
        done
        DIALOG --infobox "${_remove_pvm}" 0 0
        for i in ${LV_PHYSICAL}; do
            pvremove -f ${i} 2>/dev/null > ${LOG}
        done
    fi
}

_stopluks(){
    DISABLELUKS=""
    DETECTED_LUKS=""
    LUKSDEVICE=""

    # detect already running luks devices
    LUKS_DEVICES="$(ls /dev/mapper/ | grep -v control)"
    for i in ${LUKS_DEVICES}; do
        cryptsetup status ${i} 2>/dev/null && LUKSDEVICE="${LUKSDEVICE} ${i}"
    done
    ! [[ "${LUKSDEVICE}" = "" ]] && DETECTED_LUKS=1
    if [[ "${DETECTED_LUKS}" = "1" ]]; then
        DIALOG --defaultno --yesno "${_stopluks}" 0 0 && DISABLELUKS="1"
    fi
    if [[ "${DISABLELUKS}" = "1" ]]; then
        DIALOG --infobox "${_removeluks}" 0 0
        for i in ${LUKSDEVICE}; do
            LUKS_REAL_DEVICE="$(echo $(cryptsetup status ${i} | grep device: | sed -e 's#device:##g'))"
            cryptsetup remove ${i} > ${LOG}
            # delete header from device
            dd if=/dev/zero of=${LUKS_REAL_DEVICE} bs=512 count=2048 >/dev/null 2>&1
        done
    fi

    DISABLELUKS=""
    DETECTED_LUKS=""

    # detect not running luks devices
    [[ "$(${_BLKID} | grep "TYPE=\"crypto_LUKS\"")" ]] && DETECTED_LUKS=1
    if [[ "${DETECTED_LUKS}" = "1" ]]; then
        DIALOG --defaultno --yesno "${_stoprluks}" 0 0 && DISABLELUKS="1"
    fi
    if [[ "${DISABLELUKS}" = "1" ]]; then
        DIALOG --infobox "${_removerluks}" 0 0
        for i in $(${_BLKID} | grep "TYPE=\"crypto_LUKS\"" | sed -e 's#:.*##g'); do
            # delete header from device
            dd if=/dev/zero of=${i} bs=512 count=2048 >/dev/null 2>&1
        done
    fi
    [[ -e /tmp/.crypttab ]] && rm /tmp/.crypttab
}

_umountall(){
    DIALOG --infobox "$_umountingall" 0 0
    swapoff -a >/dev/null 2>&1
    umount $(mount | grep -v "${DESTDIR} " | grep "${DESTDIR}" | sed 's|\ .*||g') >/dev/null 2>&1
    umount $(mount | grep "${DESTDIR} " | sed 's|\ .*||g') >/dev/null 2>&1
}

mountpoints(){
    NAME_SCHEME_PARAMETER_RUN=""
    while [[ "${PARTFINISH}" != "DONE" ]]; do
        activate_special_devices
        : >/tmp/.device-names
        : >/tmp/.fstab
        : >/tmp/.parts
        #
        # Select mountpoints
        #
        DIALOG --msgbox "Available partitions:\n\n$(_getavailpartitions)\n" 0 0
        PARTS=$(findpartitions _)
        DO_SWAP=""
        while [[ "${DO_SWAP}" != "DONE" ]]; do
            FSTYPE="swap"
            DIALOG --menu "Select the partition to use as swap" 21 50 13 NONE - ${PARTS} 2>${ANSWER} || return 1
            PART=$(cat ${ANSWER})
            if [[ "${PART}" != "NONE" ]]; then
                DOMKFS="no"
                if [[ "${ASK_MOUNTPOINTS}" = "1" ]]; then
                    create_filesystem
                else
                    FILESYSTEM_FINISH="yes"
                fi
            else
                FILESYSTEM_FINISH="yes"
            fi
            [[ "${FILESYSTEM_FINISH}" = "yes" ]] && DO_SWAP=DONE
        done
        check_mkfs_values
        if [[ "${PART}" != "NONE" ]]; then
            PARTS="$(echo ${PARTS} | sed -e "s#${PART}\ _##g")"
            echo "${PART}:swap:swap:${DOMKFS}:${LABEL_NAME}:${FS_OPTIONS}:${BTRFS_DEVICES}:${BTRFS_LEVEL}:${BTRFS_SUBVOLUME}:${DOSUBVOLUME}:${BTRFS_COMPRESS}:${BTRFS_SSD}" >>/tmp/.parts
        fi
        DO_ROOT=""
        while [[ "${DO_ROOT}" != "DONE" ]]; do
            DIALOG --menu "Select the partition to mount as /" 21 50 13 ${PARTS} 2>${ANSWER} || return 1
            PART=$(cat ${ANSWER})
            PART_ROOT=${PART}
            # Select root filesystem type
            FSTYPE="$(${_BLKID} -p -i -o value -s TYPE ${PART})"
            DOMKFS="no"
            # clear values first!
            clear_btrfs_values
            check_btrfs_filesystem_creation
            if [[ "${ASK_MOUNTPOINTS}" = "1" && "${SKIP_FILESYSTEM}" = "no" ]]; then
                select_filesystem && create_filesystem && btrfs_subvolume
            else
                btrfs_subvolume
            fi
            [[ "${FILESYSTEM_FINISH}" = "yes" ]] && DO_ROOT=DONE
        done
        find_btrfs_raid_devices
        btrfs_parts
        check_mkfs_values
        echo "${PART}:${FSTYPE}:/:${DOMKFS}:${LABEL_NAME}:${FS_OPTIONS}:${BTRFS_DEVICES}:${BTRFS_LEVEL}:${BTRFS_SUBVOLUME}:${DOSUBVOLUME}:${BTRFS_COMPRESS}:${BTRFS_SSD}" >>/tmp/.parts
        ! [[ "${FSTYPE}" = "btrfs" ]] && PARTS="$(echo ${PARTS} | sed -e "s#${PART}\ _##g")"
        #
        # Additional partitions
        #
        while [[ "${PART}" != "DONE" ]]; do
            DO_ADDITIONAL=""
            while [[ "${DO_ADDITIONAL}" != "DONE" ]]; do
                DIALOG --menu "Select any additional partitions to mount under your new root (select DONE when finished)" 21 52 13 ${PARTS} DONE _ 2>${ANSWER} || return 1
                PART=$(cat ${ANSWER})
                if [[ "${PART}" != "DONE" ]]; then
                    FSTYPE="$(${_BLKID} -p -i  -o value -s TYPE ${PART})"
                    DOMKFS="no"
                    # clear values first!
                    clear_btrfs_values
                    check_btrfs_filesystem_creation
                    # Select a filesystem type
                    if [[ "${ASK_MOUNTPOINTS}" = "1" && "${SKIP_FILESYSTEM}" = "no" ]]; then
                        enter_mountpoint && select_filesystem && create_filesystem && btrfs_subvolume
                    else
                        enter_mountpoint
                        btrfs_subvolume
                    fi
                    check_btrfs_boot_subvolume
                else
                    FILESYSTEM_FINISH="yes"
                fi
                [[ "${FILESYSTEM_FINISH}" = "yes" ]] && DO_ADDITIONAL="DONE"
            done
            if [[ "${PART}" != "DONE" ]]; then
                find_btrfs_raid_devices
                btrfs_parts
                check_mkfs_values
                echo "${PART}:${FSTYPE}:${MP}:${DOMKFS}:${LABEL_NAME}:${FS_OPTIONS}:${BTRFS_DEVICES}:${BTRFS_LEVEL}:${BTRFS_SUBVOLUME}:${DOSUBVOLUME}:${BTRFS_COMPRESS}:${BTRFS_SSD}" >>/tmp/.parts
                ! [[ "${FSTYPE}" = "btrfs" ]] && PARTS="$(echo ${PARTS} | sed -e "s#${PART}\ _##g")"
            fi
        done
        DIALOG --yesno "Would you like to create and mount the filesytems like this?\n\nSyntax\n------\nDEVICE:TYPE:MOUNTPOINT:FORMAT:LABEL:FSOPTIONS:BTRFS_DETAILS\n\n$(for i in $(cat /tmp/.parts | sed -e 's, ,#,g'); do echo "${i}\n";done)" 0 0 && PARTFINISH="DONE"
    done
    # disable swap and all mounted partitions
    _umountall
    if [[ "${NAME_SCHEME_PARAMETER_RUN}" = "" ]]; then
        set_device_name_scheme || return 1
    fi
    printk off
    for line in $(cat /tmp/.parts); do
        PART=$(echo ${line} | cut -d: -f 1)
        FSTYPE=$(echo ${line} | cut -d: -f 2)
        MP=$(echo ${line} | cut -d: -f 3)
        DOMKFS=$(echo ${line} | cut -d: -f 4)
        LABEL_NAME=$(echo ${line} | cut -d: -f 5)
        FS_OPTIONS=$(echo ${line} | cut -d: -f 6)
        BTRFS_DEVICES=$(echo ${line} | cut -d: -f 7)
        BTRFS_LEVEL=$(echo ${line} | cut -d: -f 8)
        BTRFS_SUBVOLUME=$(echo ${line} | cut -d: -f 9)
        DOSUBVOLUME=$(echo ${line} | cut -d: -f 10)
        BTRFS_COMPRESS=$(echo ${line} | cut -d: -f 11)
        BTRFS_SSD=$(echo ${line} | cut -d: -f 12)
        if [[ "${DOMKFS}" = "yes" ]]; then
            if [[ "${FSTYPE}" = "swap" ]]; then
                DIALOG --infobox "Creating and activating swapspace on ${PART}" 0 0
            else
                DIALOG --infobox "Creating ${FSTYPE} on ${PART},\nmounting to ${DESTDIR}${MP}" 0 0
            fi
            _mkfs yes ${PART} ${FSTYPE} ${DESTDIR} ${MP} ${LABEL_NAME} ${FS_OPTIONS} ${BTRFS_DEVICES} ${BTRFS_LEVEL} ${BTRFS_SUBVOLUME} ${DOSUBVOLUME} ${BTRFS_COMPRESS} ${BTRFS_SSD} || return 1
        else
            if [[ "${FSTYPE}" = "swap" ]]; then
                DIALOG --infobox "Activating swapspace on ${PART}" 0 0
            else
                DIALOG --infobox "Mounting ${FSTYPE} on ${PART} to ${DESTDIR}${MP}" 0 0
            fi
            _mkfs no ${PART} ${FSTYPE} ${DESTDIR} ${MP} ${LABEL_NAME} ${FS_OPTIONS} ${BTRFS_DEVICES} ${BTRFS_LEVEL} ${BTRFS_SUBVOLUME} ${DOSUBVOLUME} ${BTRFS_COMPRESS} ${BTRFS_SSD} || return 1
        fi
        sleep 1
    done
    printk on
    DIALOG --msgbox "Partitions were successfully mounted." 0 0
    NEXTITEM="5"
    S_MKFS=1
}

# menu for raid, lvm and encrypt
create_special(){
    NEXTITEM=""
    SPECIALDONE=0
    while [[ "${SPECIALDONE}" = "0" ]]; do
        if [[ -n "${NEXTITEM}" ]]; then
            DEFAULT="--default-item ${NEXTITEM}"
        else
            DEFAULT=""
        fi
        CANCEL=""
        dialog ${DEFAULT} --backtitle "${TITLE}" --menu "Create Software Raid, LVM2 and Luks encryption" 14 60 5 \
            "1" "Create Software Raid" \
            "2" "Create LVM2" \
            "3" "Create Luks encryption" \
            "4" "Return to Previous Menu" 2>${ANSWER} || CANCEL="1"
        NEXTITEM="$(cat ${ANSWER})"
        case $(cat ${ANSWER}) in
            "1")
                _createmd ;;
            "2")
                _createlvm ;;
            "3")
                _createluks ;;
            *)
                SPECIALDONE=1 ;;
        esac
    done
    if [[ "${CANCEL}" = "1" ]]; then
        NEXTITEM="3"
    else
        NEXTITEM="4"
    fi
}

partition(){
    # disable swap and all mounted partitions, umount / last!
    _umountall
    # check on encrypted devices, else weird things can happen!
    _stopluks
    # check on raid devices, else weird things can happen during partitioning!
    _stopmd
    # check on lvm devices, else weird things can happen during partitioning!
    _stoplvm
    # update dmraid
    _dmraid_update
    # switch for mbr usage
    set_guid
    # Select disk to partition
    DISCS=$(finddisks _)
    DISCS="${DISCS} OTHER _ DONE +"
    DIALOG --msgbox "Available Disks:\n\n$(_getavaildisks)\n" 0 0
    DISC=""
    while true; do
        # Prompt the user with a list of known disks
        DIALOG --menu "Select the disk you want to partition\n(select DONE when finished)" 14 55 7 ${DISCS} 2>${ANSWER} || return 1
        DISC=$(cat ${ANSWER})
        if [[ "${DISC}" == "OTHER" ]]; then
            DIALOG --inputbox "Enter the full path to the device you wish to partition" 8 65 "/dev/sda" 2>${ANSWER} || DISC=""
            DISC=$(cat ${ANSWER})
        fi
        # Leave our loop if the user is done partitioning
        [[ "${DISC}" == "DONE" ]] && break
        MSDOS_DETECTED=""
        if ! [[ "${DISC}" == "" ]]; then
            if [[ "${GUIDPARAMETER}" == "yes" ]]; then
                CHECK_BIOS_BOOT_GRUB=""
                CHECK_UEFISYS_PART=""
                RUN_CGDISK="1"
                check_gpt
            else
                [[ "$(${_BLKID} -p -i -o value -s PTTYPE ${DISC})" == "dos" ]] && MSDOS_DETECTED="1"

                if [[ "${MSDOS_DETECTED}" == "" ]]; then
                    DIALOG --defaultno --yesno "Setup detected no MS-DOS partition table on ${DISC}.\nDo you want to create a MS-DOS partition table now on ${DISC}?\n\n${DISC} will be COMPLETELY ERASED!  Are you absolutely sure?" 0 0 || return 1
                    # clean partitiontable to avoid issues!
                    dd if=/dev/zero of=${DEVICE} bs=512 count=2048 >/dev/null 2>&1
                    wipefs -a ${DEVICE} /dev/null 2>&1
                    parted -a optimal -s ${DISC} mktable msdos >${LOG}
                fi
                # Partition disc
                DIALOG --msgbox "Now you'll be put into the parted shell where you can partition your hard drive. You should make a swap partition and as many data partitions as you will need.\n\nShort command list:\n- 'help' to get help text\n- 'print' to show  partition table\n- 'mkpart' for new partition\n- 'rm' for deleting a partition\n- 'quit' to leave parted\n\nNOTE: parted may tell you to reboot after creating partitions.  If you need to reboot, just re-enter this install program, skip this step and go on." 18 70
                clear
                ## Use parted for correct alignment, cfdisk does not align correct!
                parted ${DISC} print
                parted ${DISC}
            fi
        fi
    done
    # update dmraid
    _dmraid_update
    NEXTITEM="4"
    S_PART=1
}

# set device name scheme
set_device_name_scheme(){
    NAME_SCHEME_PARAMETER=""
    NAME_SCHEME_LEVELS=""
    MENU_DESC_TEXT=""

    # check if gpt/guid formatted disks are there
    find_gpt

    ## util-linux root=PARTUUID=/root=PARTLABEL= support - https://git.kernel.org/?p=utils/util-linux/util-linux.git;a=commitdiff;h=fc387ee14c6b8672761ae5e67ff639b5cae8f27c;hp=21d1fa53f16560dacba33fffb14ffc05d275c926
    ## mkinitcpio's init root=PARTUUID= support - https://projects.archlinux.org/mkinitcpio.git/tree/init_functions#n185

    if [[ "${GUID_DETECTED}" == "1" ]]; then
        NAME_SCHEME_LEVELS="${NAME_SCHEME_LEVELS} PARTUUID PARTUUID=<partuuid> PARTLABEL PARTLABEL=<partlabel>"
        MENU_DESC_TEXT="${_menu_descg}"
    fi

    NAME_SCHEME_LEVELS="${NAME_SCHEME_LEVELS} FSUUID UUID=<uuid> FSLABEL LABEL=<label> KERNEL /dev/<kernelname>"
    DIALOG --menu "${_device_name_scheme_1}${MENU_DESC_TEXT}${_device_name_scheme_2}" 15 70 9 ${NAME_SCHEME_LEVELS} 2>${ANSWER} || return 1
    NAME_SCHEME_PARAMETER=$(cat ${ANSWER})
    NAME_SCHEME_PARAMETER_RUN="1"
}

autoprepare(){
    # check on encrypted devices, else weird things can happen!
    _stopluks
    # check on raid devices, else weird things can happen during partitioning!
    _stopmd
    # check on lvm devices, else weird things can happen during partitioning!
    _stoplvm
    NAME_SCHEME_PARAMETER_RUN=""
    # switch for mbr usage
    set_guid
    DISCS=$(default_blockdevices)
    if [[ "$(echo ${DISCS} | wc -w)" -gt 1 ]]; then
        DIALOG --msgbox "Available Disks:\n\n$(_getavaildisks)\n" 0 0
        DIALOG --menu "Select the hard drive to use" 14 55 7 $(default_blockdevices _) 2>${ANSWER} || return 1
        DISC=$(cat ${ANSWER})
    else
        DISC=${DISCS}
    fi
    DEFAULTFS=""
    BOOT_PART_SET=""
    SWAP_PART_SET=""
    ROOT_PART_SET=""
    CHOSEN_FS=""
    # get just the disk size in 1000*1000 MB
    if [[ "$(cat ${block}/$(basename ${DISC} 2>/dev/null)/size 2>/dev/null)" ]]; then
        DISC_SIZE="$(($(expr $(cat ${block}/$(basename ${DISC})/queue/logical_block_size) '*' $(cat ${block}/$(basename ${DISC})/size))/1000000))"
    else
        DIALOG --msgbox "ERROR: Setup cannot detect size of your device, please use normal installation routine for partitioning and mounting devices." 0 0
        return 1
    fi
    while [[ "${DEFAULTFS}" = "" ]]; do
        FSOPTS=""
        [[ "$(which mkfs.ext2 2>/dev/null)" ]] && FSOPTS="${FSOPTS} ext2 Ext2"
        [[ "$(which mkfs.ext3 2>/dev/null)" ]] && FSOPTS="${FSOPTS} ext3 Ext3"
        [[ "$(which mkfs.ext4 2>/dev/null)" ]] && FSOPTS="${FSOPTS} ext4 Ext4"
        [[ "$(which mkfs.btrfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} btrfs Btrfs-(Experimental)"
        [[ "$(which mkfs.nilfs2 2>/dev/null)" ]] && FSOPTS="${FSOPTS} nilfs2 Nilfs2-(Experimental)"
        [[ "$(which mkreiserfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} reiserfs Reiser3"
        [[ "$(which mkfs.xfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} xfs XFS"
        [[ "$(which mkfs.jfs 2>/dev/null)" ]] && FSOPTS="${FSOPTS} jfs JFS"
        # create 1 MB bios_grub partition for grub-bios GPT support
        if [[ "${GUIDPARAMETER}" = "yes" ]]; then
            GUID_PART_SIZE="2"
            GPT_BIOS_GRUB_PART_SIZE="${GUID_PART_SIZE}"
            UEFISYS_PART_SIZE="512"
        else
            GUID_PART_SIZE="0"
            UEFISYS_PART_SIZE="0"
        fi
        DISC_SIZE=$((${DISC_SIZE}-${GUID_PART_SIZE}-${UEFISYS_PART_SIZE}))
        while [[ "${BOOT_PART_SET}" = "" ]]; do
            DIALOG --inputbox "Enter the size (MB) of your /boot partition,\nMinimum value is 150.\n\nDisk space left: ${DISC_SIZE} MB" 10 65 "512" 2>${ANSWER} || return 1
            BOOT_PART_SIZE="$(cat ${ANSWER})"
            if [[ "${BOOT_PART_SIZE}" = "" ]]; then
                DIALOG --msgbox "ERROR: You have entered a invalid size, please enter again." 0 0
            else
                if [[ "${BOOT_PART_SIZE}" -ge "${DISC_SIZE}" || "${BOOT_PART_SIZE}" -lt "150" || "${SBOOT_PART_SIZE}" = "${DISC_SIZE}" ]]; then
                    DIALOG --msgbox "ERROR: You have entered an invalid size, please enter again." 0 0
                else
                    BOOT_PART_SET=1
                fi
            fi
        done
        DISC_SIZE=$((${DISC_SIZE}-${BOOT_PART_SIZE}))
        SWAP_SIZE="256"
        [[ "${DISC_SIZE}" -lt "256" ]] && SWAP_SIZE="${DISC_SIZE}"
        while [[ "${SWAP_PART_SET}" = "" ]]; do
            DIALOG --inputbox "Enter the size (MB) of your swap partition,\nMinimum value is > 0.\n\nDisk space left: ${DISC_SIZE} MB" 10 65 "${SWAP_SIZE}" 2>${ANSWER} || return 1
            SWAP_PART_SIZE=$(cat ${ANSWER})
            if [[ "${SWAP_PART_SIZE}" = "" || "${SWAP_PART_SIZE}" = "0" ]]; then
                DIALOG --msgbox "ERROR: You have entered an invalid size, please enter again." 0 0
            else
                if [[ "${SWAP_PART_SIZE}" -ge "${DISC_SIZE}" ]]; then
                    DIALOG --msgbox "ERROR: You have entered a too large size, please enter again." 0 0
                else
                    SWAP_PART_SET=1
                fi
            fi
        done
        DISC_SIZE=$((${DISC_SIZE}-${SWAP_PART_SIZE}))
        ROOT_SIZE="6400"
        [[ "${DISC_SIZE}" -lt "6400" ]] && ROOT_SIZE="${DISC_SIZE}"
        while [[ "${ROOT_PART_SET}" = "" ]]; do
        DIALOG --inputbox "Enter the size (MB) of your / partition,\nthe /home partition will use the remaining space.\n\nDisk space left:  ${DISC_SIZE} MB" 10 65 "${ROOT_SIZE}" 2>${ANSWER} || return 1
        ROOT_PART_SIZE=$(cat ${ANSWER})
            if [[ "${ROOT_PART_SIZE}" = "" || "${ROOT_PART_SIZE}" = "0" ]]; then
                DIALOG --msgbox "ERROR: You have entered an invalid size, please enter again." 0 0
            else
                if [[ "${ROOT_PART_SIZE}" -ge "${DISC_SIZE}" ]]; then
                    DIALOG --msgbox "ERROR: You have entered a too large size, please enter again." 0 0
                else
                    DIALOG --yesno "$((${DISC_SIZE}-${ROOT_PART_SIZE})) MB will be used for your /home partition. Is this OK?" 0 0 && ROOT_PART_SET=1
                fi
            fi
        done
        while [[ "${CHOSEN_FS}" = "" ]]; do
            DIALOG --menu "Select a filesystem for / and /home:" 16 45 8 ${FSOPTS} 2>${ANSWER} || return 1
            FSTYPE=$(cat ${ANSWER})
            DIALOG --yesno "${FSTYPE} will be used for / and /home. Is this OK?" 0 0 && CHOSEN_FS=1
        done
        DEFAULTFS=1
    done
    DIALOG --defaultno --yesno "${DISC} will be COMPLETELY ERASED!  Are you absolutely sure?" 0 0 \
    || return 1
    DEVICE=${DISC}

    # validate DEVICE
    if [[ ! -b "${DEVICE}" ]]; then
      DIALOG --msgbox "Device '${DEVICE}' is not valid" 0 0
      return 1
    fi

    # validate DEST
    if [[ ! -d "${DESTDIR}" ]]; then
        DIALOG --msgbox "Destination directory '${DESTDIR}' is not valid" 0 0
        return 1
    fi

    [[ -e /tmp/.fstab ]] && rm -f /tmp/.fstab
    # disable swap and all mounted partitions, umount / last!
    _umountall
    # we assume a /dev/hdX format (or /dev/sdX)
    if [[ "${GUIDPARAMETER}" == "yes" ]]; then
        PART_ROOT="${DEVICE}5"
        # GPT (GUID) is supported only by 'parted' or 'sgdisk'
        printk off
        DIALOG --infobox "Partitioning ${DEVICE}" 0 0
        # clean partition table to avoid issues!
        sgdisk --zap ${DEVICE} &>/dev/null
        # clear all magic strings/signatures - mdadm, lvm, partition tables etc.
        dd if=/dev/zero of=${DEVICE} bs=512 count=2048 &>/dev/null
        wipefs -a ${DEVICE} &>/dev/null
        # create fresh GPT
        sgdisk --clear ${DEVICE} &>/dev/null
        # create actual partitions
        sgdisk --set-alignment="2048" --new=1:1M:+${GPT_BIOS_GRUB_PART_SIZE}M --typecode=1:EF02 --change-name=1:BIOS_GRUB ${DEVICE} > ${LOG}
        sgdisk --set-alignment="2048" --new=2:+1M:+${UEFISYS_PART_SIZE}M --typecode=2:EF00 --change-name=2:UEFI_SYSTEM ${DEVICE} > ${LOG}
        sgdisk --set-alignment="2048" --new=3:+1M:+${BOOT_PART_SIZE}M --typecode=3:8300 --attributes=3:set:2 --change-name=3:MANJARO_BOOT ${DEVICE} > ${LOG}
        sgdisk --set-alignment="2048" --new=4:+1M:+${SWAP_PART_SIZE}M --typecode=4:8200 --change-name=4:MANJARO_SWAP ${DEVICE} > ${LOG}
        sgdisk --set-alignment="2048" --new=5:+1M:+${ROOT_PART_SIZE}M --typecode=5:8300 --change-name=5:MANJARO_ROOT ${DEVICE} > ${LOG}
        sgdisk --set-alignment="2048" --new=6:+1M:0 --typecode=6:8300 --change-name=6:MANJARO_HOME ${DEVICE} > ${LOG}
        sgdisk --print ${DEVICE} > ${LOG}
    else
        PART_ROOT="${DEVICE}3"
        # start at sector 1 for 4k drive compatibility and correct alignment
        printk off
        DIALOG --infobox "Partitioning ${DEVICE}" 0 0
        # clean partitiontable to avoid issues!
        dd if=/dev/zero of=${DEVICE} bs=512 count=2048 >/dev/null 2>&1
        wipefs -a ${DEVICE} &>/dev/null
        # create DOS MBR with parted
        parted -a optimal -s ${DEVICE} unit MiB mktable msdos >/dev/null 2>&1
        parted -a optimal -s ${DEVICE} unit MiB mkpart primary 1 $((${GUID_PART_SIZE}+${BOOT_PART_SIZE})) >${LOG}
        parted -a optimal -s ${DEVICE} unit MiB set 1 boot on >${LOG}
        parted -a optimal -s ${DEVICE} unit MiB mkpart primary $((${GUID_PART_SIZE}+${BOOT_PART_SIZE}+1)) $((${GUID_PART_SIZE}+${BOOT_PART_SIZE}+${SWAP_PART_SIZE}+1)) >${LOG}
        parted -a optimal -s ${DEVICE} unit MiB mkpart primary $((${GUID_PART_SIZE}+${BOOT_PART_SIZE}+${SWAP_PART_SIZE}+2)) $((${GUID_PART_SIZE}+${BOOT_PART_SIZE}+${SWAP_PART_SIZE}+${ROOT_PART_SIZE}+2)) >${LOG}
        parted -a optimal -s ${DEVICE} unit MiB mkpart primary $((${GUID_PART_SIZE}+${BOOT_PART_SIZE}+${SWAP_PART_SIZE}+${ROOT_PART_SIZE}+3)) 100% >${LOG}
    fi
    if [[ $? -gt 0 ]]; then
        DIALOG --msgbox "Error partitioning ${DEVICE} (see ${LOG} for details)" 0 0
        printk on
        return 1
    fi
    printk on
    ## wait until /dev initialized correct devices
    udevadm settle

    if [[ "${NAME_SCHEME_PARAMETER_RUN}" == "" ]]; then
        set_device_name_scheme || return 1
    fi
    ## FSSPECS - default filesystem specs (the + is bootable flag)
    ## <partnum>:<mountpoint>:<partsize>:<fstype>[:<fsoptions>][:+]:labelname
    ## The partitions in FSSPECS list should be listed in the "mountpoint" order.
    ## Make sure the "root" partition is defined first in the FSSPECS list
    FSSPECS="3:/:${ROOT_PART_SIZE}:${FSTYPE}:::ROOT_MANJARO 1:/boot:${BOOT_PART_SIZE}:ext2::+:BOOT_MANJARO 4:/home:*:${FSTYPE}:::HOME_MANJARO 2:swap:${SWAP_PART_SIZE}:swap:::SWAP_MANJARO"

    if [[ "${GUIDPARAMETER}" == "yes" ]]; then
        FSSPECS="5:/:${ROOT_PART_SIZE}:${FSTYPE}:::ROOT_MANJARO 3:/boot:${BOOT_PART_SIZE}:ext2::+:BOOT_MANJARO 2:/boot/efi:512:vfat:-F32::ESP 6:/home:*:${FSTYPE}:::HOME_MANJARO 4:swap:${SWAP_PART_SIZE}:swap:::SWAP_MANJARO"
    fi

    ## make and mount filesystems
    for fsspec in ${FSSPECS}; do
        part="$(echo ${fsspec} | tr -d ' ' | cut -f1 -d:)"
        mountpoint="$(echo ${fsspec} | tr -d ' ' | cut -f2 -d:)"
        fstype="$(echo ${fsspec} | tr -d ' ' | cut -f4 -d:)"
        fsoptions="$(echo ${fsspec} | tr -d ' ' | cut -f5 -d:)"
        [[ "${fsoptions}" == "" ]] && fsoptions="NONE"
        labelname="$(echo ${fsspec} | tr -d ' ' | cut -f7 -d:)"
        btrfsdevices="${DEVICE}${part}"
        btrfsssd="NONE"
        btrfscompress="NONE"
        btrfssubvolume="NONE"
        btrfslevel="NONE"
        dosubvolume="no"
        # if echo "${mountpoint}" | tr -d ' ' | grep '^/$' 2>&1 >/dev/null; then
        # if [[ "$(echo ${mountpoint} | tr -d ' ' | grep '^/$' | wc -l)" -eq 0 ]]; then
        DIALOG --infobox "Creating ${fstype} on ${DEVICE}${part}\nwith FSLABEL ${labelname} .\nMountpoint is ${mountpoint} ." 0 0
        _mkfs yes "${DEVICE}${part}" "${fstype}" "${DESTDIR}" "${mountpoint}" "${labelname}" "${fsoptions}" "${btrfsdevices}" "${btrfssubvolume}" "${btrfslevel}" "${dosubvolume}" "${btrfssd}" "${btrfscompress}" || return 1
        # fi
    done

    DIALOG --msgbox "Auto-prepare was successful" 0 0
    S_MKFSAUTO=1
}

set_passwd(){
	# trap tmp-file for passwd
	trap "rm -f ${ANSWER}" 0 1 2 5 15
	# get password
	DIALOG --title "$_passwdtitle" \
		--clear \
		--insecure \
		--passwordbox "$_passwddl $PASSWDUSER" 10 30 2> ${ANSWER}
	PASSWD="$(cat ${ANSWER})"
	DIALOG --title "$_passwdtitle" \
		--clear \
		--insecure \
		--passwordbox "$_passwddl2 $PASSWDUSER" 10 30 2> ${ANSWER}
	PASSWD2="$(cat ${ANSWER})"
	if [ "$PASSWD" == "$PASSWD2" ]; then
		PASSWD=$PASSWD
		_passwddl=$_passwddl1
    else
		_passwddl=$_passwddl3
		set_passwd
    fi
}

setup_user(){
   # addgroups="video,audio,power,disk,storage,optical,network,lp,scanner"
    DIALOG --inputbox "${_enterusername}" 10 65 "${username2}" 2>${ANSWER} || return 1
    REPLY="$(cat ${ANSWER})"
    while [ -z "$(echo $REPLY |grep -E '^[a-z_][a-z0-9_-]*[$]?$')" ];do
       DIALOG --inputbox "${_givecorrectname}" 10 65 "${username2}" 2>${ANSWER} || return 1
       REPLY="$(cat ${ANSWER})"
    done

    chroot ${DESTDIR} useradd -m -p "" -g users -G ${addgroups} $REPLY

    PASSWDUSER="$REPLY"

    if [ -d "${DESTDIR}/var/lib/AccountsService/users" ] ; then
       echo "[User]" > ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       if [ -e "/usr/bin/startxfce4" ] ; then
          echo "XSession=xfce" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       fi
       if [ -e "/usr/bin/cinnamon-session" ] ; then
          echo "XSession=cinnamon" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       fi
       if [ -e "/usr/bin/mate-session" ] ; then
          echo "XSession=mate" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       fi
       if [ -e "/usr/bin/enlightenment_start" ] ; then
          echo "XSession=enlightenment" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       fi
       if [ -e "/usr/bin/openbox-session" ] ; then
          echo "XSession=openbox" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       fi
       if [ -e "/usr/bin/startlxde" ] ; then
          echo "XSession=LXDE" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       fi
       if [ -e "/usr/bin/lxqt-session" ] ; then
          echo "XSession=LXQt" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
       fi
       echo "Icon=" >> ${DESTDIR}/var/lib/AccountsService/users/$PASSWDUSER
    fi

    if DIALOG --yesno "${_addsudouserdl1}${REPLY}${_addsudouserdl2}" 6 40;then
       echo "${PASSWDUSER}     ALL=(ALL) ALL" >> ${DESTDIR}/etc/sudoers
    fi
    sed -i -e 's|# %wheel ALL=(ALL) ALL|%wheel ALL=(ALL) ALL|g' ${DESTDIR}/etc/sudoers
    chmod 0440 ${DESTDIR}/etc/sudoers
    set_passwd
    echo "$PASSWDUSER:$PASSWD" | chroot ${DESTDIR} chpasswd
    NEXTITEM="Setup-User"
    DONE_CONFIG=1
}

set_language(){
    if [[ -e /opt/livecd/lg ]]; then
        /opt/livecd/lg --setup
    else
        DIALOG --msgbox "Error:\nlg script not found, aborting language setting" 0 0
    fi
}

set_keyboard(){
    if [[ -e /opt/livecd/km ]]; then
        /opt/livecd/km --setup
    else
        DIALOG --msgbox "Error:\nkm script not found, aborting keyboard and console setting" 0 0
    fi
}

config_system(){
    DONE=0
    NEXTITEM=""
    while [[ "${DONE}" = "0" ]]; do
        if [[ -n "${NEXTITEM}" ]]; then
            DEFAULT="--default-item ${NEXTITEM}"
        else
            DEFAULT=""
        fi
        if [[ -e /run/systemd ]]; then
			DIALOG $DEFAULT --menu "Configuration" 17 78 10 \
				"/etc/fstab"                "${_fstabtext}" \
				"/etc/mkinitcpio.conf"      "${_mkinitcpioconftext}" \
				"/etc/resolv.conf"          "${_resolvconftext}" \
				"/etc/hostname"             "${_hostnametext}" \
				"/etc/hosts"                "${_hoststext}" \
				"/etc/hosts.deny"           "${_hostsdenytext}" \
				"/etc/hosts.allow"          "${_hostsallowtext}" \
				"/etc/locale.gen"           "${_localegentext}" \
				"/etc/locale.conf"           "${_localeconftext}" \
				"/etc/environment"           "${_environmenttext}" \
				"/etc/pacman.d/mirrorlist"  "${_mirrorlisttext}" \
				"/etc/X11/xorg.conf.d/10-evdev.conf"  "${_xorgevdevconftext}" \
				"/etc/keyboard.conf"        "${_vconsoletext}" \
				"${_return_label}"        "${_return_label}" 2>${ANSWER} || NEXTITEM="${_return_label}"
			NEXTITEM="$(cat ${ANSWER})"
        else
			DIALOG $DEFAULT --menu "Configuration" 17 78 10 \
				"/etc/fstab"                "${_fstabtext}" \
				"/etc/mkinitcpio.conf"      "${_mkinitcpioconftext}" \
				"/etc/resolv.conf"          "${_resolvconftext}" \
				"/etc/rc.conf"              "${_rcconfigtext}" \
				"/etc/conf.d/hostname"      "${_hostnametext}" \
				"/etc/conf.d/keymaps"       "${_localeconftext}" \
				"/etc/conf.d/modules"       "${_modulesconftext}" \
				"/etc/conf.d/hwclock"       "${_hwclockconftext}" \
				"/etc/conf.d/xdm"           "${_xdmconftext}" \
				"/etc/hosts"                "${_hoststext}" \
				"/etc/hosts.deny"           "${_hostsdenytext}" \
				"/etc/hosts.allow"          "${_hostsallowtext}" \
				"/etc/locale.gen"           "${_localegentext}" \
				"/etc/environment"          "${_environmenttext}" \
				"/etc/pacman.d/mirrorlist"  "${_mirrorlisttext}" \
				"/etc/X11/xorg.conf.d/10-evdev.conf"  "${_xorgevdevconftext}" \
				"${_return_label}"        "${_return_label}" 2>${ANSWER} || NEXTITEM="${_return_label}"
			NEXTITEM="$(cat ${ANSWER})"
        fi

        if [ "${NEXTITEM}" = "${_return_label}" -o -z "${NEXTITEM}" ]; then       # exit
           DONE=1
        else
           $EDITOR ${DESTDIR}${NEXTITEM}
        fi
    done
}

install_bootloader(){

    destdir_mounts || return 1
    if [[ "${NAME_SCHEME_PARAMETER_RUN}" == "" ]]; then
        set_device_name_scheme || return 1
    fi
    CANCEL=""

    _DIRECT="0"

    [[ "$(grep UEFI_ARCH_x86_64 /proc/cmdline)" ]] && _UEFI_x86_64="1"

    [[ "${_UEFI_x86_64}" == "1" ]] && DIALOG --yesno "Setup has detected that you are using x86_64 (64-bit) UEFI ...\nDo you like to install a x86_64 UEFI bootloader?" 0 0 && install_bootloader_uefi_x86_64 && _DIRECT="1"

    if [[ "${_DIRECT}" == "1" ]]; then
        DIALOG --yesno "Do you want to install another bootloader?" 0 0 && install_bootloader_menu && _DIRECT="0"
    else
        install_bootloader_menu
    fi
}

# installsystem_cp()
# installs to the target folder
installsystem_cp(){
    #DIALOG --msgbox "${_installationwillstart}" 0 0
    #clear
    mkdir -p ${DESTDIR}
    #rsync -av --progress /source/root-image ${DESTDIR}
    CP_SOURCE=/source/root-image
    mkdir -p ${CP_SOURCE}
    CP_TARGET=${DESTDIR}
    SQF_FILE=root-image.sqfs
    run_mount_sqf
    run_cp
    run_umount_sqf
    echo $? > /tmp/.install-retcode
    if [ $(cat /tmp/.install-retcode) -ne 0 ]; then echo -e "\n${_installationfail}" >>/tmp/rsyncerror.log
    else echo -e "\n => Root-Image: ${_installationsuccess}" >>/tmp/rsyncerror.log
    fi

    #rsync -av --progress /source/de-image ${DESTDIR}
    CP_SOURCE=/source/${DESKTOP_IMG}
    mkdir -p ${CP_SOURCE}
    CP_TARGET=${DESTDIR}
    SQF_FILE=${DESKTOP_IMG}.sqfs
    run_mount_sqf
    run_cp
    run_umount_sqf
    echo $? > /tmp/.install-retcode
    if [ $(cat /tmp/.install-retcode) -ne 0 ]; then echo -e "\n${_installationfail}" >>/tmp/rsyncerror.log
    else echo -e "\n => ${DESKTOP}-Image: ${_installationsuccess}" >>/tmp/rsyncerror.log
    fi

    # finished, display scrollable output
    local _result=''
    if [ $(cat /tmp/.install-retcode) -ne 0 ]; then
      _result="${_installationfail}"
      BREAK="break"
    else
      _result="${_installationsuccess}"
    fi
    rm /tmp/.install-retcode

    DIALOG --title "$_result" --exit-label "${_continue_label}" \
        --textbox "/tmp/rsyncerror.log" 18 60 || return 1

    # ensure the disk is synced
    sync

    if [ "${BREAK}" = "break" ]; then
       break
    fi

    S_INSTALL=1
    NEXTITEM=4

    # automagic time!
    # any automatic configuration should go here
    DIALOG --infobox "${_configuringsystem}" 6 40
    sleep 3

    hd_config
    auto_fstab
    _system_is_installed=1
}

installsystem(){
    SQFPARAMETER=""
#    DIALOG --defaultno --yesno "${_installchoice}" 0 0 && SQFPARAMETER="yes"
#    if [[ "${SQFPARAMETER}" == "yes" ]]; then
#       installsystem_unsquash
#    else
       installsystem_cp
#    fi
}

configure_system(){
    ## PREPROCESSING ##
    # only done on first invocation of configure_system
    if [ $S_PRECONFIG -eq 0 ]; then
        #edit /etc/locale.conf & /etc/environment
        echo "LANG=${LOCALE}.UTF-8" > ${DESTDIR}/etc/locale.conf
        echo "LC_COLLATE=C" >> ${DESTDIR}/etc/locale.conf
        echo "LANG=${LOCALE}.UTF-8" >> ${DESTDIR}/etc/environment

        # add BROWSER var
        if [ -e "${DESTDIR}/usr/bin/firefox" ] ; then
           echo "BROWSER=/usr/bin/firefox" >> ${DESTDIR}/etc/environment
        fi

        #edit /etc/mkinitcpio.conf to have external bootup from pcmcia and resume support
        HOOKS=`cat /etc/mkinitcpio.conf | grep HOOKS= | grep -v '#' | cut -d'"' -f2 | sed 's/filesystems/pcmcia resume filesystems/g'`
        if [ -e ${DESTDIR}/etc/plymouth/plymouthd.conf ] ; then
           sed -i -e "s/^HOOKS=.*/HOOKS=\"${HOOKS} plymouth\"/g" ${DESTDIR}/etc/mkinitcpio.conf
        fi

		# Determind which language we are using
		configure_language
    fi

    S_PRECONFIG=1

    DONE=0
    DONE_CONFIG=""
    NEXTITEM=""
    while [[ "${DONE}" = "0" ]]; do
        if [[ -n "${NEXTITEM}" ]]; then
            DEFAULT="--default-item ${NEXTITEM}"
        else
            DEFAULT=""
        fi

        DIALOG $DEFAULT --menu "Configuration" 17 78 10 \
            "Root-Password"             "${_definerootpass}" \
            "Setup-User"                "${_defineuser}" \
            "Setup-Locale"              "${_definelocale}" \
            "Setup-Keymap"              "${_definekeymap}" \
            "Config-System"             "${_doeditconfig}" \
            "${_return_label}"          "${_mainmenulabel}" 2>${ANSWER} || NEXTITEM="${_return_label}"
        NEXTITEM="$(cat ${ANSWER})"

        case $(cat ${ANSWER}) in
            "Root-Password")
                PASSWDUSER="root"
                set_passwd
                echo "$PASSWDUSER:$PASSWD" | chroot ${DESTDIR} chpasswd
                DONE_CONFIG="1"
                NEXTITEM="Setup-User" ;;
            "Setup-User")
                setup_user && NEXTITEM="Setup-Locale" ;;
            "Setup-Locale")
                set_language && NEXTITEM="Setup-Keymap" ;;
            "Setup-Keymap")
                set_keyboard && NEXTITEM="Config-System" ;;
            "Config-System")
                config_system && NEXTITEM="${_return_label}" ;;
            "${_return_label}")
                DONE="1" ;;
             *)
                DONE="1" ;;
        esac
    done
    if [[ "${DONE_CONFIG}" = "1" ]]; then
       _post_process
    else
       NEXTITEM="4"
    fi
}

prepare_harddrive(){
    S_MKFSAUTO=0
    S_MKFS=0
    DONE=0
    NEXTITEM=""
    CANCEL="1"
    while [[ "${DONE}" = "0" ]]; do
        if [[ -n "${NEXTITEM}" ]]; then
            DEFAULT="--default-item ${NEXTITEM}"
        else
            DEFAULT=""
        fi
        CANCEL=""
        dialog ${DEFAULT} --backtitle "${TITLE}" --menu "Prepare Hard Drive" 12 60 5 \
            "1" "Auto-Prepare (erases the ENTIRE hard drive)" \
            "2" "Partition Hard Drives" \
            "3" "Create Software Raid, Lvm2 and Luks encryption" \
            "4" "Set Filesystem Mountpoints" \
            "5" "Return to Main Menu" 2>${ANSWER} || CANCEL="1"
        NEXTITEM="$(cat ${ANSWER})"
        [[ "${S_MKFSAUTO}" = "1" ]] && DONE=1
        case $(cat ${ANSWER}) in
            "1")
                autoprepare
                [[ "${S_MKFSAUTO}" = "1" ]] && DONE=1
                CANCEL="0"
                _hd_is_prepared=1
                NEXTITEM="5";;
            "2")
                partition ;;
            "3")
                create_special ;;
            "4")
                PARTFINISH=""
                ASK_MOUNTPOINTS="1"
                mountpoints
                CANCEL="0"
                _hd_is_prepared=1
                NEXTITEM="5";;
            *)
                DONE=1 ;;
        esac
    done
    if [[ "${CANCEL}" = "1" ]]; then
        NEXTITEM="2"
    else
        NEXTITEM="3"
    fi
}

set_clock(){
    # utc or local?
    DIALOG --menu "${_machinetimezone}" 10 72 2 \
        "UTC" " " \
        "localtime" " " \
        2>${ANSWER} || return 1
    HARDWARECLOCK=$(cat ${ANSWER})

    # timezone?
    REGIONS=""
    for i in $(grep '^[A-Z]' /usr/share/zoneinfo/zone.tab | cut -f 3 | sed -e 's#/.*##g'| sort -u); do
      REGIONS="$REGIONS $i -"
    done
    region=""
    zone=""
    while [ -z "$zone" ];do
      region=""
      while [ -z "$region" ];do
        :>${ANSWER}
        DIALOG --menu "${_selectregion}" 0 0 0 $REGIONS 2>${ANSWER}
        region=$(cat ${ANSWER})
      done
      ZONES=""
      for i in $(grep '^[A-Z]' /usr/share/zoneinfo/zone.tab | grep $region/ | cut -f 3 | sed -e "s#$region/##g"| sort -u); do
        ZONES="$ZONES $i -"
      done
      :>${ANSWER}
      DIALOG --menu "${_selecttimezone}" 0 0 0 $ZONES 2>${ANSWER}
      zone=$(cat ${ANSWER})
    done
    TIMEZONE="$region/$zone"

    # set system clock from hwclock - stolen from rc.sysinit
    local HWCLOCK_PARAMS=""


    if [[ -e /run/openrc ]];then
	local _conf_clock='clock="'${HARDWARECLOCK}'"'
	sed -i -e "s|^.*clcok=.*|${_conf_clock}|" /etc/conf.d/hwclock
    fi
    if [ "$HARDWARECLOCK" = "UTC" ]; then
	HWCLOCK_PARAMS="$HWCLOCK_PARAMS --utc"
    else
	HWCLOCK_PARAMS="$HWCLOCK_PARAMS --localtime"
	if [[ -e /run/systemd ]];then
	    echo "0.0 0.0 0.0" > /etc/adjtime &> /dev/null
	    echo "0" >> /etc/adjtime &> /dev/null
	    echo "LOCAL" >> /etc/adjtime &> /dev/null
	fi
    fi
    if [ "$TIMEZONE" != "" -a -e "/usr/share/zoneinfo/$TIMEZONE" ]; then
        /bin/rm -f /etc/localtime
        #/bin/cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
        ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    fi
    /usr/bin/hwclock --hctosys $HWCLOCK_PARAMS --noadjfile

    if [[ -e /run/openrc ]];then
	echo "${TIMEZONE}" > /etc/timezone
    fi

    # display and ask to set date/time
    DIALOG --calendar "${_choosedatetime}" 0 0 0 0 0 2> ${ANSWER} || return 1
    local _date="$(cat ${ANSWER})"
    DIALOG --timebox "${_choosehourtime}" 0 0 2> ${ANSWER} || return 1
    local _time="$(cat ${ANSWER})"
    echo "date: $_date time: $_time" >$LOG

    # save the time
    # DD/MM/YYYY hh:mm:ss -> YYYY-MM-DD hh:mm:ss
    local _datetime="$(echo "$_date" "$_time" | sed 's#\(..\)/\(..\)/\(....\) \(..\):\(..\):\(..\)#\3-\2-\1 \4:\5:\6#g')"
    echo "setting date to: $_datetime" >$LOG
    date -s "$_datetime" 2>&1 >$LOG
    /usr/bin/hwclock --systohc $HWCLOCK_PARAMS --noadjfile

    S_CLOCK=1
    NEXTITEM="2"
}

mainmenu(){
    if [ -n "${NEXTITEM}" ]; then
        DEFAULT="--default-item ${NEXTITEM}"
    else
        DEFAULT=""
    fi
    DIALOG $DEFAULT --title " ${_mainmenulabel} " \
        --menu "${_mainmenuhelp}" 16 55 8 \
        "1" "${_datetimetext}" \
        "2" "${_preparediskstext}" \
        "3" "${_installsystemtext}" \
        "4" "${_configuresystemtext}" \
        "5" "${_instbootloadertext}" \
        "6" "${_quittext}" 2>${ANSWER}
    NEXTITEM="$(cat ${ANSWER})"
    case $(cat ${ANSWER}) in
        "1")
            set_clock ;;
        "2")
            prepare_harddrive
        ;;
        "3")
            if [ "$_hd_is_prepared" == "1" ];then
             installsystem
            else
             DIALOG --msgbox "$_forgotpreparehd" 10 40
            fi
        ;;
        "4")
            if [ "$_system_is_installed" == "1" ];then
             configure_system
            else
             DIALOG --msgbox "$_forgotinstalling" 10 40
            fi
        ;;
        "5")
            if [ "$_system_is_configured" == "1" ];then
             install_bootloader
            else
             DIALOG --msgbox "$_forgotsystemconf" 10 40
            fi
        ;;
        "6")
            DIALOG --infobox "${_installationfinished}" 6 40
            mkdir -p ${DESTDIR}/var/log/${manjaroiso}
            cp /tmp/*.log ${DESTDIR}/var/log/${manjaroiso} &>/dev/null
            cp /var/log/pacman.log ${DESTDIR}/var/log/${manjaroiso}/pacman-live.log &>/dev/null
            _umountall &>/dev/null ; sleep 1 ; exit 0
        ;;
        *)
            if DIALOG --yesno "${_cancelinstall}" 6 40;then
            _umountall &>/dev/null ; exit 0
            fi
        ;;
    esac
}

