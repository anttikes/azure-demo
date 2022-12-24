#!/bin/bash

echo

if !(command -v psql &> /dev/null)
then
  echo "Required PostgreSQL client tool (psql) was not found; the script can not operate"
  exit -1
fi

if !(command -v pg_isready &> /dev/null)
then
  echo "Required PostgreSQL client tool (pg_isready) was not found; the script can not operate"
  exit -1
fi

host="localhost"
user=""
password=""
dbname="merus-power-db"

VALID_ARGS=$(getopt -o abg:d: --long host:,user:,password:,dbname:,help -- "$@")
if [[ $? -ne 0 ]]; then
    exit 1;
fi

eval set -- "$VALID_ARGS"
while [ : ]; do
  case "$1" in
    -h | --host)
        host="$2"
        shift 2
        ;;
    -u | --user)
        user="$2"
        shift 2
        ;;
    -p | --password)
        password="$2"        
        shift 2
        ;;
    -d | --dbname)
        dbname="$2"
        shift 2
        ;;
    ? | -h | --help)
      echo "Usage: $(basename $0) [-h hostname] [-u user] [-p password] [-d database]"
      exit 1
      ;;
    --) shift; 
        break 
        ;;    
  esac
done

if [ -z "$host" ]
then
      echo "Hostname has not been provided; use '-h' or '--host' to provide it"
      exit -1
fi

if [ -z "$user" ]
then
      echo "Username has not been provided; use '-u' or '--user' to provide it"
      exit -1
fi

if [ -z "$password" ]
then
      echo "Password has not been provided; use '-p' or '--password' to provide it"
      exit -1
fi

if [ -z "$dbname" ]
then
      echo "Database has not been provided; use '-d' or '--dbname' to provide it"
      exit -1
fi

echo "Testing database connection"
if !(PGPASSWORD="$password" pg_isready --host="$host" --username="$user" --dbname="$dbname")
then
  echo "Connection attempt failed; check provided parameters"
  exit -1
fi

echo
echo "Initializing database, and seeding it with some random data"
PGPASSWORD="$password" psql --host="$host" --username="$user" --dbname="$dbname" --file="initialData.sql"
