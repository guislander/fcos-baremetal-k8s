#!/bin/bash
#
# defaults
PWR="on"

# loop for arguments
for arg in "$@"
do
  case $arg in
    -h|--help)
      echo "PXE boot nodes"
      echo " "
      echo "options:"
      echo "-h, --help		show brief help"
      echo "-p, --power-mode	specify on(defalut) or reset"
      echo "-n, --node		specify node ip reuse flag for each node"
      exit 0
      ;;
    -p|--power-mode)
      PWR=$2
      shift
      ;;
    -n|--node)
      HOST=$2
      read -s -p "Enter passord for $HOST: " PWD
      ipmitool -H $HOST -U ADMIN -P $PWD chassis bootdev pxe
      ipmitool -H $HOST -U ADMIN -P $PWD power $PWR
      shift 
      ;;
    *)
      shift
      ;;
  esac
done

