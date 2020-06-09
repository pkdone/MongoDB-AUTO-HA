#!/bin/bash  
mongo --port 27000 --eval '
    rs.initiate(
        {_id: "TestRS", members: [
            {_id: 0, host: "localhost:27000"},
            {_id: 1, host: "localhost:27001"},
            {_id: 2, host: "localhost:27002"}
        ], 
        settings: {electionTimeoutMillis: 2000}
    });
'
