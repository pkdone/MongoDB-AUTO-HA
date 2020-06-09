#/bin/sh
echo
# By using [m] in the grep filter we avoid showing this console's process - using awk to add newline after each match
ps -eo pid,cmd | grep "[m]ongod --replSet" | awk '{print $0,"\n"}'
