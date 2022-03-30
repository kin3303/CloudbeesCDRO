
#!/bin/bash

export PATH=$PATH:/usr/local/mysql/bin

workingDir=`pwd`

DEFAULTS_FILE=${workingDir}/mysqlbkup.cnf
BACKUP_DIR=/home/ubuntu/backup
MAX_BACKUPS=3
BKUP_BIN=gzip
BKUP_EXT=gz

if [ ! -d "$BACKUP_DIR" ]; then
  mkdir -p "$BACKUP_DIR"
  chmod 600 "$BACKUP_DIR"
fi

if [ ! -e $DEFAULTS_FILE ]; then
  echo "DEFAULTS_FILE ($DEFAULTS_FILE) does not exist"
  exit 1
fi

for program in date $BKUP_BIN head hostname ls mysql mysqldump rm tr wc
do
  which $program 1>/dev/null 2>/dev/null
  if [ $? -gt 0 ]; then
    echo "External dependency $program not found or not in $PATH"
    exit 1
  fi
done

chmod 600 ${DEFAULTS_FILE}

date=$(date +%F)
dbs="ecdb ecdb_upgrade"

exist_dbs=$(echo 'show databases' | mysql --defaults-file=$DEFAULTS_FILE )
 
dbs="ecdb"
if [[ "${exist_dbs}" == *ecdb_upgrade* ]]; then
  dbs="ecdb ecdb_upgrade"
fi

echo "Preparing backup databases : ${dbs}"
echo ""

echo "== Running $0 on $(hostname) - $date ==";
echo ""

# loop over the list of databases
for db in $dbs
do
  backupDir="$BACKUP_DIR/$db"
  backupFile="$date-$db.sql.$BKUP_EXT"
  
  echo "Backing up $db into $backupDir"
  
  if [ ! -d "$backupDir" ]; then
    echo "Creating directory $backupDir"
    mkdir -p "$backupDir"
  else
    numBackups=$(ls -1lt "$backupDir"/*."$BKUP_EXT" 2>/dev/null | wc -l)
    if [ -z "$numBackups" ]
    then
      umBackups=0;
    fi
  
    if [ "$numBackups" -ge "$MAX_BACKUPS" ]; then
      ((numFilesToNuke = "$numBackups - $MAX_BACKUPS + 1"))
      filesToNuke=$(ls -1rt "$backupDir"/*."$BKUP_EXT" | head -n "$numFilesToNuke" | tr '\n' ' ')
      echo "Nuking files $filesToNuke"
      rm $filesToNuke
    fi
  fi
  
  echo "Running: mysqldump --defaults-file=$DEFAULTS_FILE $db | $BKUP_BIN > data/db-data/backup/$db/$backupFile"
  mysqldump --defaults-file=$DEFAULTS_FILE "$db" | $BKUP_BIN > "$backupDir/$backupFile"
  echo ""
done

echo "Finished running - $date";
echo ""
