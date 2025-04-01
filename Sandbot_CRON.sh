#!/bin/bash


# ChatGPT Prompt:
# can you please write me a bash script that will:
# 1. ping TARGET_IP
# 2.  if TARGET_IP is pingable, and if the file ~/Sandbot_Commanded is not there, send a simple HTTP request to TARGET_IP, then echo "Sandbot was Commanded at [TARGET_IP]", then create ~/Sandbot_Commanded
# 3. If Target_IP is pingable, and the file ~/Sandbot_Commanded is there, do nothing
# 4. else if TARGET_IP is not pingable, execute "rm ~/Sandbot_Commanded


# Define the target IP address
TARGET_IP="192.168.50.229"  # Replace with the IP address you want to ping
COMMAND_FILE="$HOME/Sandbot_Commanded"
HTTP_COMMAND="http://${TARGET_IP}/playFile/sd/HomeEveryTimeAllPatterns.seq"

# Ping the target IP address
ping -c 4 "$TARGET_IP" > /dev/null 2>&1

# Check if the ping was successful
if [ $? -eq 0 ]; then
  echo "$TARGET_IP is pingable."

  # If the "Sandbot_Commanded" file doesn't exist, send an HTTP request and echo the message
  if [ ! -f "$COMMAND_FILE" ]; then
    # Send a simple HTTP request to TARGET_IP (using curl)
    curl -s "$HTTP_COMMAND" > /dev/null

    # Echo the message that Sandbot was commanded
    echo "Sandbot was Commanded at $TARGET_IP"

    # Create the "Sandbot_Commanded" file
    touch "$COMMAND_FILE"
    echo "Created $COMMAND_FILE."

  else
    # If the file exists, do nothing
    echo "Sandbot has already been commanded at $TARGET_IP. No action taken."
  fi

else
  # If the target IP is not pingable, remove the "Sandbot_Commanded" file if it exists
  if [ -f "$COMMAND_FILE" ]; then
    rm "$COMMAND_FILE"
    echo "Target IP is not reachable. Removed $COMMAND_FILE."
  else
    echo "Target IP is not reachable and $COMMAND_FILE does not exist."
  fi
fi
