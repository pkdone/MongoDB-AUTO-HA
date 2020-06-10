#!/bin/bash  

if [[ $# -eq 0 ]] ; then
    echo 'ERROR: Run this script passing port argument, e.g. ./monitor.sh 27000'
    exit 1
fi

# ARG FOR PORT MONGOD IS LISTENING ON
PORT="${1}"

# BASH COLOUR SEQUENCES
RED='1;31m'
BLUE='1;34m'
GREEN='1;32m'
PURPLE='1;35m'
RESET='0m'
ESCAPE='\033['
RESET_CMD=$(echo -en "${ESCAPE}${RESET}")
RED_CMD=$(echo -en "${ESCAPE}${RED}")

# LOOP FOREVER MONITORING
while(true); do
    mongo --port $PORT --eval "db.stats()" > /dev/null 2>&1  # Test connection with simple ccommand
    RESULT=$?  # Returns 0 if mongo connected

    if [ $RESULT -ne 0 ]; then
        echo "${RED_CMD}Down${RESET_CMD}"
    else
        mongo --port $PORT --quiet --eval "
            rs.slaveOk();
            print('Connected to MongoDB ' + db.version());
            db = db.getSiblingDB('mside');

            try {
                while (true) {
                    line = '${ESCAPE}';
                    ready = true;

                    if (db.isMaster().ismaster) {
                        line += '${BLUE}Primary';
                    } else if (db.isMaster().secondary) {
                        line += '${GREEN}Secondary';
                    } else {
                        line += '${PURPLE}Not Initialised';
                        ready = false;
                    }

                    line += '${RESET_CMD}'
                    
                    if (ready) {
                        line += ' - Docs: ' + db.bookings.countDocuments({})
                    }

                    print(line);
                    sleep(1000);
                }
            } catch(err) {
                print('CONNECTION PROBLEM')
            }
        "
        
        printf "\nPress CTRL-C again quickly if you want to completely terminate\n"
    fi    
    
    sleep 1    
done

