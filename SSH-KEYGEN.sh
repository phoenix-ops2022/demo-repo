#!/bin/bash
#=================================Parameter Section=======================================================================
trap "exit 1" TERM
export TOP_PID=$$

if [ "$#" -eq 3 ]; then
    user=$1
    remotevm=$2
    generate=$3
else
    echo -ne "\nParameter missing \n"
    exit;
fi

#===================================End Parameter Section===================================================================

printresult()
{
  echo  "+-----------------------------------------------------------------------------+"
  echo "| Date/Time : $(date)" | awk '{print $0 substr("                                                                    ",1,78-length($0)) "|"}'
  echo  " ${functionName} - ${returnMessage} "
  echo  "+-----------------------------------------------------------------------------+"
}

#===================================SSH Key Generation===================================================================

sshkey()
{
    functionName="sshkey"
    su - $user -c "ssh-keygen -q -t rsa -b 2048 -N '' -f /home/$user/.ssh/id_rsa -C "symadm@$remotevm"<<<y" > /home/$user/.ssh/result.txt
    if [ $? == 0 ]; then
        echo -ne "\n SSH Key is generated successfully \n"
        returnMessage="Success"
        printresult functionName returnMessage
    else
        returnMessage="Failed"
        printresult functionName returnMessage
        kill -s TERM $TOP_PID
    fi
}

catssh()
{
    prikey=$(cat /home/$user/.ssh/id_rsa)
    echo "##gbStart##private_key##splitKeyValue##$prikey##gbEnd##"
}

if [[ $generate == yes ]]; then
    sshkey
else
    catssh
fi