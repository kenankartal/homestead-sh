#!/usr/bin/env bash
################################################################
# Edit .bashrc and add following line:                         #
# alias homestead="sh ${MY_SCRIPTS}/homestead.sh"              #
#                                                              #
# Usage:                                                       #
# homestead                                                    #
#     start         homestead starts                           #
#     ssh           homestead log in                           #
#     provision     homestead starts with the provision        #
#                   parameter                                  #
#     pid           show pid, cpu, memory info                 #
#     stop          homestead stop                             #
#                                                              #
################################################################


HOMESTEAD="/home/kenan/Homestead"

COMMAND="$1"


startHomestead() {
cat << "EOF"
                             _   _       _                     
        __      _____  _ __ | |_| | __ _| |__                  
        \ \ /\ / / _ \| '_ \| __| |/ _` | '_ \                 
         \ V  V / (_) | | | | |_| | (_| | |_) |                
          \_/\_/ \___/|_| |_|\__|_|\__,_|_.__/                 
 __      _____| |__    ___  ___ | |_   _| |_(_) ___  _ __  ___ 
 \ \ /\ / / _ \ '_ \  / __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
  \ V  V /  __/ |_) | \__ \ (_) | | |_| | |_| | (_) | | | \__ \
   \_/\_/ \___|_.__/  |___/\___/|_|\__,_|\__|_|\___/|_| |_|___/
                                                               

EOF
	echo "Starting Homestead..."
	cd ${HOMESTEAD}
	/usr/bin/vagrant up
	echo "Started Homestead..."
}

sshHomestead() {
	/usr/bin/vagrant ssh
}

provisionHomestead() {
	/usr/bin/vagrant up --provision
}

stopHomestead() {
	echo "Stopping Homestead..."
	PIDS=$(ps aux | grep "[V]BoxHeadless" | awk '{print $2}')
	/usr/bin/vagrant halt
	echo "Stop Homestead with process id ${PIDS}"
}

showHomesteadPid() {
#	printf "%5s %12s %12s %12s\n" "PID" "CPU" "MEMORY" "TIME";
#	printf "%5s %12s %12s %12s\n" "-----" "------" "--------" "------";
	metrics= ps aux | grep "[V]BoxHeadless" | awk 'BEGIN { printf "%5s %5s %7s %5s\n", "PID", "CPU", "MEMORY", "TIME" } { printf "%d %.02f%% %.02f%% %s\n", $2, $3, $4, $9 }'
}


if [[ -z "{$COMMAND}" ]] ; then
	echo "Usage: homestead start|stop|provision|pid"
	exit 1
elif [[ "${COMMAND}" != "start" ]] &&
     [[ "${COMMAND}" != "stop" ]] &&
     [[ "${COMMAND}" != "ssh" ]] &&
     [[ "${COMMAND}" != "provision" ]] &&
     [[ "${COMMAND}" != "pid" ]]; then
	echo "Invalid command: ${COMMAND}"
	echo "Available commands: start, stop, ssh, provision, pid, kill"
	exit 1
else
	echo "Running command ${COMMAND}"
fi

cd ${HOMESTEAD}
if [[ "$COMMAND" = "start" ]]; then
    PIDS=$(ps aux | grep "[V]BoxHeadless" | awk '{print $2}')
    if [[ "$PIDS" = "" ]]; then
	    startHomestead
    else
	echo "Start Homestead with process id ${PIDS}"
    fi
elif [[ "$COMMAND" = "stop" ]]; then
	stopHomestead
elif [[ "$COMMAND" = "ssh" ]]; then
        sshHomestead
elif [[ "$COMMAND" = "provision" ]]; then
    	provisionHomestead
elif [[ "$COMMAND" = "pid" ]]; then
	showHomesteadPid
fi
