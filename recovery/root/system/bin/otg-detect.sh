#!/system/bin/sh
# Keeps /dev/block/usbotg (USB disk) and /dev/block/usbotg1 (its 1st partition)
# pointing at the pen drive plugged in by OTG, whatever sdX letter it gets.
while true; do
    disk=""
    for b in /sys/block/sd*; do
        [ -e "$b" ] || continue
        case "$(readlink -f "$b")" in
            *ufs*) continue ;;
            */usb*) disk=${b##*/}; break ;;
        esac
    done
    if [ -n "$disk" ]; then
        part=$disk
        [ -e /dev/block/${disk}1 ] && part=${disk}1
        [ "$(readlink /dev/block/usbotg)" = "/dev/block/$disk" ] || ln -sf /dev/block/$disk /dev/block/usbotg
        [ "$(readlink /dev/block/usbotg1)" = "/dev/block/$part" ] || ln -sf /dev/block/$part /dev/block/usbotg1
    else
        rm -f /dev/block/usbotg /dev/block/usbotg1
    fi
    sleep 2
done
