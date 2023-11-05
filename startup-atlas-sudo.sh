# Get automount running
if ! pgrep -x "automount" > /dev/null
then
    automount
fi
