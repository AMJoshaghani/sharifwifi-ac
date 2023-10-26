#!/bin/bash
# By: AMJoshaghani @ amjoshaghani.ir
# Under: GPLv.3
# For legal use.

SCRIPT_DIR=$( cd -- $( dirname -- "${BASH_SOURCE[0]}" ) &> /dev/null && pwd )
CONF_DIR="$HOME/.config"
DEST_DIR=$CONF_DIR"/sharif-wifi"
SERV_C=$CONF_DIR"/systemd/user"
UNIT_N="sharif-wifi.service"

function main(){
	echo "=============================";
	echo "Enter your username:"
	read USERNAME
	PASS=""
	pass_var="Your password: "
	while IFS= read -p "$pass_var" -r -s -n 1 letter
	do
    		if [[ $letter == $'\0' ]]
    			then
        			break
    		fi
    	PASS="${PASS}$letter"
    	pass_var="*"
	done
	echo ""
	sleep 1
	sed -i "5c\USERNAME=\'$USERNAME\'; PASS=\'$PASS\'" src/Sharif-WiFi.sh
	echo "Creating required folders...";
	sleep 2
	make_dir && move_src;
	echo "Setting cron-job for every 6 hours";
	sleep 1
	set_cron;
	echo "Done.";
	sleep 1
	echo "=============================";
	sleep 1
	echo "> Adding to startup...";
	echo ">> Creating and enabling service file";
	sleep 1
	cat > $SERV_C"/"$UNIT_N << EOF
[Unit]
Description=Authorizing to Sharif-WiFi
After=network.target
[Service]
Type=simple
RestartSec=5
ExecStart=/bin/bash ${DEST_DIR}/Sharif-WiFi.sh
RemainAfterExit=yes
Restart=on-failure
[Install]
WantedBy=default.target
EOF
	chmod 644 $SERV_C"/"$UNIT_N
	echo ">>> unit created!"
	sleep 2
	systemctl enable -f $UNIT_N --user
	systemctl start -f $UNIT_N --user
	echo ">>> service enabled!"
	sleep 3
	echo -e "Everything's good; Bye.";
}

function make_dir(){
	mkdir -p $CONF_DIR
	mkdir -p $DEST_DIR
	mkdir -p $SERV_C
}
function move_src(){
	mv $SCRIPT_DIR/src/* $DEST_DIR
	rm $SCRIPT_DIR/src -r
	mv $SCRIPT_DIR/img $DEST_DIR
}
function set_cron(){
	crontab -l > sw
	echo "0 */6 * * * /bin/bash ${DEST_DIR}/Sharif-WiFi.sh" >> sw
	crontab sw
	rm sw
}


main "$@"