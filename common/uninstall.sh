case $(basename $ZIP) in
    *delete*|*Delete*|*DELETE*)
        DELETE=true
        ;;
esac

chmod 755 $INSTALLER/common/keycheck

keytest() {
    ui_print " [#] Volume Key Test"
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
        ui_print " [!] Volume key not detected!"
        abort " [!] Use name change method in TWRP!"
    fi
}

if [ -z $DELETE ]; then
    if keytest; then
        FUNCTION=chooseport
    else
        FUNCTION=chooseportold
        ui_print " [!] Legacy device detected! Using old keycheck method"
        ui_print " "
        ui_print " [#] Volume Key Programming"
        ui_print " [+] Press Vol Up Again:"
        $FUNCTION "UP"
        ui_print " [+] Press Vol Down:"
        $FUNCTION "DOWN"
    fi
    ui_print " "
    ui_print " [#] Module Cleanup"
    ui_print " [+] Remove ALL files related to MidnightCore?"
    ui_print " [+] This will also remove any backups of fonts or media files."
    ui_print " [+] Vol+ = Remove all files, Vol- = Don't remove files"
    if $FUNCTION; then
        DELETE=true
    else
        DELETE=false
    fi
fi
if $DELETE; then
    ui_print " [+] Purging MidnightCore Files..."
    rm -rf /data/media/0/MidnightMain > /dev/null 2>&1
    ui_print " [+] All MidnightCore Files Purged!"
else
    ui_print " [+] No Files Deleted"
fi
