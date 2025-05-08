#!/bin/bash

INPUT_FILE="$1"
LOG_FILE="iam_setup.log"
DEFAULT_PASSWORD="ChangeMe123"

# Accept user file
if [ -z "$USER_FILE" ]; then
  echo "Usage: $0 <user_csv_file>"
  exit 1
fi

if [ ! -f "$USER_FILE" ]; then
  echo "Error: File '$USER_FILE' not found!"
  exit 1
fi

log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}


# Read each line in the users.txt
while IFS=',' read -r username fullname group; do
    # Skip empty or malformed lines
    if [[ -z "$username" || -z "$fullname" || -z "$group" ]]; then
        log_action "Skipping invalid line: $username, $fullname, $group"
        continue
    fi

    # Create group if not exists
    if ! getent group "$group" > /dev/null; then
        groupadd "$group"
        log_action "Group '$group' created."
    else
        log_action "Group '$group' already exists."
    fi

    # Check if user exists
    if id "$username" &>/dev/null; then
        log_action "User '$username' already exists. Skipping user creation."
        continue
    fi

    # Create user
    useradd -m -c "$fullname" -g "$group" "$username"
    echo "$username:$DEFAULT_PASSWORD" | chpasswd
    chage -d 0 "$username"
    chmod 700 "/home/$username"

    log_action "User '$username' created with home directory, added to group '$group'."
    log_action "Password set and forced to change on first login."
    log_action "Permissions set on /home/$username"
done < "$INPUT_FILE"

# Reand and Sanitize the csv file
while IFS=',' read -r username fullname group email; do
  username=$(echo "$username" | xargs)
  fullname=$(echo "$fullname" | xargs)
  group=$(echo "$group" | xargs)
  email=$(echo "$email" | xargs)

# Password Complexity Check

generate_password() {
  openssl rand -base64 12
}

is_complex_password() {
  local pass="$1"
  if [[ "$pass" =~ [A-Z] && "$pass" =~ [a-z] && "$pass" =~ [0-9] && "$pass" =~ [\@\#\!\%\^\&\*] ]]; then
    return 0
  else
    return 1
  fi
}

# Generate until a complex password is found
while true; do
  TEMP_PASSWORD=$(generate_password)
  if is_complex_password "$TEMP_PASSWORD"; then
    break
  fi
done


# Creates user group and logging
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

  if ! getent group "$group" > /dev/null; then
    groupadd "$group" && echo "$TIMESTAMP - Group '$group' created." >> "$LOG_FILE"
  else
    echo "$TIMESTAMP - Group '$group' already exists." >> "$LOG_FILE"
  fi

  useradd -m -c "$fullname" -g "$group" "$username"
  echo "$username:$TEMP_PASSWORD" | chpasswd
  chage -d 0 "$username"
  chmod 700 "/home/$username"

  echo "$TIMESTAMP - User '$username' created with password $TEMP_PASSWORD and added to group '$group'." >> "$LOG_FILE"


# Send email notification
  mail -s "Welcome to the team!" "$email" <<EOF
Hello $fullname,

Your Linux account has been created.

Username: $username
Temporary Password: $TEMP_PASSWORD

Please change your password upon first login.

Regards,
IT Team
EOF

  echo "$TIMESTAMP - Email sent to $email" >> "$LOG_FILE"
done < "$USER_FILE"  
 
