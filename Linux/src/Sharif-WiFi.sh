#!/bin/bash
set -o errexit -o nounset -o pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
USERNAME='amir.joshaghani12'; PASS='AmirMj1383'
SADDR="net2.sharif.edu"
C=0; CM=1

function main {
	msg "Checking Connection..."
	CR=$(check_conn && echo 0) || $(echo 1)
	test $CR -eq 0 || check_net
    msg "Connection established"

    W_NAME=$(iwgetid -r)
    msg "SSID: "$W_NAME

    if [ $(echo $W_NAME | grep "Sharif-WiFi") ]; then
        # A more secure way is to check UUID instead of SSID:
        # [ $CONNECTION_UUID = $UUID ]; then

        SERVER_RESPONSE=$(curl -X POST -d \
            "username=$USERNAME&password=$PASS"\
            "https://$SADDR/login")

        R=$(echo $SERVER_RESPONSE | sed -n \
            "/<meta http-equiv=\"refresh\" content=\"2; url=http:\/\/$SADDR\/status\">/p")

        if [ "$R" ]; then
            msg "Auth; done."
            notify-send "Authorized to Sharif-Wifi!" -i "$SCRIPT_DIR/img/vcs-normal.svg"
        else
            err "No-Auth; ${SERVER_RESPONSE}"
            notify-send "Couldn't authorize to Sharif-Wifi ;(" -i "$SCRIPT_DIR/img/vcs-conflicting.svg"
        fi
    fi
}
function check_net { ping -c 2 "google.com" > /dev/null 2>&1; if [ $? = 0 ]; then msg "net is ok"; notify-send "Networking is present without Sharif-WiFi"; exit 0; else msg "no net."; exit 1; fi }
function check_conn { ping -c 1 $SADDR > /dev/null 2>&1; while [ $? -ne 0 ]; do sleep 1; let "C+=1"; [[ ${C} -gt ${CM} ]] && echo 1 && break; ping -c 1 $SADDR > /dev/null 2>&1; done }
function msg { out "$*" >&2 ;}
function err { local x=$? ; msg "$*" ; return $(( $x == 0 ? 1 : $x )) ;}
function out { TIME=$(date '+%I:%M:%S'); printf "$TIME - %s\n" "$*" ;}

function maybe { "$@" || return $(( $? == 1 ? 0 : $? )) ;}

main "$@"
