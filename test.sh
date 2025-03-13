#!/bin/bash

# Define X (AS number)
X=$2

# Initialize variables
declare -A DEFAULTS
declare -A LOCATIONS
CURRENT_LOCATION=""

# Function to evaluate arithmetic expressions in a string
eval_arithmetic() {
  local input="$1"
  local y="$2"
  # Replace Y with its value
  input="${input//Y/$y}"
  # Evaluate arithmetic expressions like [100+Y] or [150+Y]
  while [[ "$input" =~ \[([0-9]+)\+([0-9]+)\] ]]; do
    expr="${BASH_REMATCH[1]} + ${BASH_REMATCH[2]}"
    result=$((expr))
    input="${input//\[${BASH_REMATCH[1]}+${BASH_REMATCH[2]}\]/$result}"
  done
  echo "$input"
}

# Read the file line by line
while IFS= read -r line; do
  # Skip comments and empty lines
  if [[ "$line" =~ ^# || -z "$line" ]]; then
    continue
  fi

  # Check if the line is the defaults section
  if [[ "$line" =~ ^defaults: ]]; then
    # Read the defaults section
    while IFS= read -r default_line; do
      # Exit the loop if we reach the end of the defaults section
      if [[ -z "$default_line" || "$default_line" =~ ^[A-Za-z]+-[0-9]+: ]]; then
        break
      fi
      key=$(echo $default_line | cut -d':' -f1 | sed 's/ //g')
      value=$(echo $default_line | cut -d':' -f2 | sed 's/ //g')
      value="${value//X/$X}"
      DEFAULTS["$key"]="$value"
    done
  fi

  # Check if the line is a header (e.g., "LOND-1:")
  if [[ "$line" =~ ^([A-Za-z]+)-([0-9]+): ]]; then
    # If we're already processing a location, save it
    if [[ -n "$CURRENT_LOCATION" ]]; then
      LOCATIONS["$CURRENT_LOCATION"]="$LOCATION_DATA"
    fi
    NAME="${BASH_REMATCH[1]}"
    Y="${BASH_REMATCH[2]}" # Extract Y from the location name
    CURRENT_LOCATION="$NAME-$Y"
    LOCATION_DATA="" # Reset location data for the new location

    # Add the default host and lo interfaces for this location
    for key in "${!DEFAULTS[@]}"; do
      value="${DEFAULTS[$key]}"
      # Evaluate arithmetic expressions in the value
      value=$(eval_arithmetic "$value" "$Y")
      LOCATION_DATA+="$key:$value"$'\n'
    done
  else
    # Process child place and IP address lines
    if [[ "$line" =~ ^[[:space:]]+([A-Za-z]+):[[:space:]]+([0-9X+Y\.\/]+) ]]; then
      CHILD_PLACE="${BASH_REMATCH[1]}"
      IP="${BASH_REMATCH[2]}"
      # Replace X in the IP address (Y is not used here)
      IP="${IP//X/$X}"
      # Append child place and IP to the location data
      LOCATION_DATA+="$CHILD_PLACE:$IP"$'\n'
    fi
  fi
done <"$1"

# Save the last location
if [[ -n "$CURRENT_LOCATION" ]]; then
  LOCATIONS["$CURRENT_LOCATION"]="$LOCATION_DATA"
fi

# Print defaults for debugging
echo "Defaults:"
for key in "${!DEFAULTS[@]}"; do
  echo "  $key: ${DEFAULTS[$key]}"
done
echo "----------"

# Loop through each location and run commands
for location in "${!LOCATIONS[@]}"; do
  echo "Processing location: $location"
  echo "Location data:"
  echo "${LOCATIONS[$location]}"
done

# -n flag remove all interface ips instead of setting them
if [[ "$3" == "-n" ]]; then
  echo "Removing all interface IPs"
  for location in "${!LOCATIONS[@]}"; do
    # Extract information for the location
    while IFS= read -r data; do
      if [[ -z "$data" ]]; then
        continue
      fi
      INTERFACE="${data%%:*}"
      IP="${data#*:}"
      loc=$(echo $location | cut -d'-' -f1)
      echo "Removing IP from $INTERFACE on $location"

      # Skip the host and lo interfaces
      if [[ "$INTERFACE" == "host" || "$INTERFACE" == "lo" ]]; then
        ./goto.sh $loc router <<EOF
        configure terminal
        interface $INTERFACE
        no ip address $IP
        exit
EOF
        continue
      fi

      # Run commands using the location data
      # Example command: echo "Setting up $INTERFACE with IP $IP"
      # Replace the echo command with your actual commands
      ./goto.sh $loc router <<EOF
      configure terminal
      interface port_$INTERFACE
      no ip address $IP
      exit
EOF
    done <<<"${LOCATIONS[$location]}"
  done
  exit
fi

echo "Before continuing please check all ip's and all infomation about each router/host"
echo "as this process is anoying and time comsuming to undo"
read -p "Press any key to continue.. " -n1 -s

# Loop through each location and run commands
for location in "${!LOCATIONS[@]}"; do
  # Extract information for the location
  while IFS= read -r data; do
    if [[ -z "$data" ]]; then
      continue
    fi
    INTERFACE="${data%%:*}"
    IP="${data#*:}"
    loc=$(echo $location | cut -d'-' -f1)
    echo "Setting up $INTERFACE with IP $IP on $location"

    # Skip the host and lo interfaces
    if [[ "$INTERFACE" == "host" || "$INTERFACE" == "lo" ]]; then
      ./goto.sh $loc router <<EOF
    configure terminal
    interface $INTERFACE
    ip address $IP
    exit
EOF
      continue
    fi

    # Run commands using the location data
    # Example command: echo "Setting up $INTERFACE with IP $IP"
    # Replace the echo command with your actual commands
    ./goto.sh $loc router <<EOF
    configure terminal
    interface port_$INTERFACE
    ip address $IP
    exit
EOF
  done <<<"${LOCATIONS[$location]}"
done
