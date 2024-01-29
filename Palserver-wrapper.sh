#!/bin/bash
/home/steam/.steam/steam/steamapps/common/PalServer/PalServer.sh &
Pal_PID="$!"
sleep 10
kill $Pal_PID
