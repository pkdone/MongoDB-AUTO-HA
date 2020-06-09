#!/usr/bin/env python3
import pymongo, sys, random, uuid, time
from datetime import datetime

SEEDLIST_URL = 'mongodb://localhost:27000,localhost:27001,localhost:27002/?replicaSet=TestRS&retryWrites={retry}&retryReads={retry}'
retry = True if ((len(sys.argv) > 1) and (sys.argv[1].strip().lower() == 'retry')) else False
connection = pymongo.MongoClient(SEEDLIST_URL.format(retry=str(retry).lower()), retryWrites=retry , retryReads=retry)
connect_problem = False
print(f'\nInserting records continuously with retryable reads & writes set to {str(retry).upper()}....\n')

while True:
    try:
        connection['mside']['bookings'].insert_one({
            'user_id': 'Jane_Doe',
            'location':'US',
            'booking_number': uuid.uuid1(),
            'booking_cost': random.randint(1,100),
            'checkin_date': datetime(2022, 5, 18),
            'checkout_date': datetime(2022, 5, 21)
        })

        if connect_problem:
            print(' Reconnected....\n')
            connect_problem = False

        time.sleep(0.01)
    except KeyboardInterrupt:
        print()
        sys.exit(0)
    except Exception as e:
        print(f'\n   ********\n     Connection problem: {e}\n   ********    \n')
        connect_problem = True
