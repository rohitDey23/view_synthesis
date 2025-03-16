#! /bin/bash

# Start the first process
set -e
source /home/user_dev/.bashrc


echo "Starting the first process... with arguments: $@"

exec $@
