# XBIN DETECT
if [ ! -d /system/xbin ]; then
    mv $INSTALLER/system/xbin $INSTALLER/system/bin
    bin=bin
else
    bin=xbin
fi

chmod 755 $INSTALLER/common/keycheck

keytest() {
    ui_print " [#] Vol key Test-"
    ui_print " [+] Press Vol Up:"
    (/system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events) || return 1
    return 0
}

chooseport() {
    while (true); do
        /system/bin/getevent -lc 1 2>&1 | /system/bin/grep VOLUME | /system/bin/grep " DOWN" > $INSTALLER/events
        if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUME >/dev/null`); then
            break
        fi
    done
    if (`cat $INSTALLER/events 2>/dev/null | /system/bin/grep VOLUMEUP >/dev/null`); then
        return 0
    else
        return 1
    fi
}

chooseportold() {
    $KEYCHECK
    $KEYCHECK
    SEL=$?
    if [ "$1" == "UP" ]; then
        UP=$SEL
    elif [ "$1" == "DOWN" ]; then
        DOWN=$SEL
    elif [ $SEL -eq $UP ]; then
        return 0
    elif [ $SEL -eq $DOWN ]; then
        return 1
    else
        ui_print " [!] Vol key not detected!"
        abort " [!] Send this install log to the module creator!"
    fi
}

ui_print ""
if keytest; then
    FUNCTION=chooseport
else
    FUNCTION=chooseportold
    ui_print " [!] Legacy device detected! Using old keycheck method"
    ui_print ""
    ui_print " [#] Vol Key Programming"
    ui_print " [+] Press Vol Up Again:"
    $FUNCTION "UP"
    ui_print " [+] Press Vol Down:"
    $FUNCTION "DOWN"
fi
# FONT SURVIVAL
if [ -f /data/media/0/MidnightMain/MidnightFonts/currently_applied_font.txt ]; then
    FONTTEXT="$( cat /data/media/0/MidnightMain/MidnightFonts/currently_applied_font.txt | tr -d ' ' )"
    FONT="$( echo $FONTTEXT | cut -d ']' -f 2 )"
    ui_print " [+] Currently Applied Font: $FONT"
    ui_print " [+] Would you like to restore this font?"
    ui_print " [!] IF YOU DONT HAVE A BACKUP, YOU NEED AN INTERNET CONNECTION!"
    ui_print " [+] Vol+ = Yes, Vol- = No"
    if $FUNCTION; then
        if [ -f /data/media/0/MidnightMain/MidnightFonts/Backup/$FONT.tar.gz ]; then
            ui_print " [+] Font Backup Found!"
            ui_print " [+] Restoring Backup..."
            dir=pwd
            mkdir $INSTALLER/system/fonts
            cd /data/media/0/MidnightMain/MidnightFonts/Backup
            tar -xzf "$FONT.tar.gz" -C $INSTALLER/system/fonts
            cd $dir
            ui_print " [+] Backup Restored!"
        elif [ -d /data/media/0/MidnightMain/MidnightCustom/Fonts/$FONT ]; then
            ui_print " [+] Font Backup Found!"
            ui_print " [+] Restoring Backup..."
            mkdir $INSTALLER/system/fonts
            cp -f /data/media/0/MidnightMain/MidnightCustom/Fonts/$FONT/* $INSTALLER/system/fonts
            ui_print " [+] Backup Restored!"
        else
            ui_print " [+] No Font Backup Found."
            ui_print " [+] Setting Up Font Restoration Environment..."
            ui_print " [+] Checking For Internet Connection..."
            if $BOOTMODE; then
                ping -q -c 1 -W 1 google.com > /dev/null 2>&1 && ui_print " [+] Internet Connection Established!" || { echo " [!] No Internet Connection detected"; false; }
                if [ $? -eq 0 ]; then
                    wget -q -O /data/media/0/DONT-DELETE-2 "https://ncloud.zaclys.com/index.php/s/HQpbpeNKYp5crlz/download"
                    ui_print " [+] Links List downloaded..."
                    FONTNUM="$( cat /data/media/0/MidnightMain/MidnightFonts/currently_applied_font.txt | cut -d ']' -f 1 | cut -d '[' -f 2 )"
                    LINK="$( cat /data/media/0/DONT-DELETE-2 | xargs | cut -d ' ' -f $FONTNUM )"
                    ui_print " [+] Downloading Font..."
                    wget -q -O /data/media/0/$FONT.zip $LINK
                    ui_print " [+] $FONT Downloaded!"
                    mkdir /data/media/0/tmpmidfontdir > /dev/null 2>&1
                    unzip -o /data/media/0/$FONT.zip -d /data/media/0/tmpmidfontdir > /dev/null 2>&1
                    mv -f /data/media/0/tmpmidfontdir/system/fonts $INSTALLER/system > /dev/null 2>&1
                    rm -f /data/media/0/$FONT.zip > /dev/null 2>&1
                    rm -rf /data/media/0/tmpmidfontdir > /dev/null 2>&1
                    rm -f /data/media/0/DONT-DELETE-2
                    chmod 644 $INSTALLER/system/fonts/*
                    if [ -d $INSTALLER/system/fonts ]; then
                        ui_print " [+] Font Restored!"
                    else
                        ui_print " [!] Font Not Restored!"
                    fi
                fi
            else
                ui_print " [!] TWRP Installation Detected!"
                ui_print " [+] Skipping Font Restoration."
            fi
        fi
    else
        ui_print " [+] Resuming Process..."
    fi
fi
# MEDIA SURVIVAL
#if [ -f /data/media/0/MidnightMain/MidnightMedia/currently_applied_media.txt ]; then
#    MEDIATEXT="$( cat /data/media/0/MidnightMain/MidnightMedia/currently_applied_media.txt | tr -d ' ' )"
#    MEDIA="$( echo $MEDIATEXT | cut -d ']' -f 2 )"
#    ui_print " [+] Currently Applied Media: $MEDIA"
#    ui_print " [+] Would you like to restore this file?"
#    ui_print " [!] A BACKUP IS NECESSARY FOR THIS!"
#    ui_print " [+] Vol+ = Yes, Vol- = No"
#    if $FUNCTION; then
#        if [ -f /data/media/0/MidnightMain/MidnightMedia/Backup/$MEDIA.tar.gz ]; then
#            ui_print " [+] Media Backup Found!"
#            ui_print " [+] Restoring Backup..."
#            dir=pwd
#            mkdir $INSTALLER/system/media
#            cd /data/media/0/MidnightMain/MidnightMedia/Backup
#            tar -xzf "$MEDIA.tar.gz" -C $INSTALLER/system/media
#            cd $dir
#            ui_print " [+] Backup Restored!"
#        elif [ -d /data/media/0/MidnightMain/MidnightCustom/Media/Bootanimations/$MEDIA ]; then
#            ui_print " [+] Media Backup Found!"
#            ui_print " [+] Restoring Backup..."
#            mkdir $INSTALLER/system/media
#            cp /data/media/0/MidnightMain/MidnightCustom/Media/Bootanimations/$MEDIA/* $INSTALLER/system/media
#            ui_print " [+] Backup Restored!"
#        elif [ -d /data/media/0/MidnightMain/MidnightCustom/Media/Audio/$MEDIA ]; then
#            ui_print " [+] Media Backup Found!"
#            ui_print " [+] Restoring Backup..."
#            mkdir $INSTALLER/system/media
#            cp /data/media/0/MidnightMain/MidnightCustom/Media/Audio/$MEDIA/* $INSTALLER/system/media
#            ui_print " [+] Backup Restored!"
#        else
#            ui_print " [+] No Media Backup Found."
#            ui_print " [+] Media files can only be restored"
#            ui_print " [+] if a backup exists."
#            ui_print " [+] Skipping Media Restoration..."
#        fi
#    else
#        ui_print " [+] Resuming Process..."
#    fi
#fi
