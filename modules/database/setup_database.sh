# Variables
rm -rf soundplace-db

git clone https://github.com/tsirlucas/soundplace-db.git &&

# Do something that might fail but we care. Loop is completed. If there was an error, the variable error is created and set to true
psql -h $HOST_IP -U $HOST_USER -f soundplace-db/setup.sql || error=true

rm -rf soundplace-db

#Fail the build if there was an error
if [ $error ]
then
    exit -1
fi

