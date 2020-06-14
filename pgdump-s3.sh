#!/bin/sh

: "${PG_PASS:?PG_PASS not set}"
: "${PG_HOST:?PG_HOST not set}"
: "${PG_USER:?PG_USER not set}"

: "${AWS_ACCESS_KEY_ID:?AWS_ACCESS_KEY_ID not set}"
: "${AWS_SECRET_ACCESS_KEY:?AWS_SECRET_ACCESS_KEY not set}"
: "${S3_BUCKET:?S3_BUCKET not set}"

cd /tmp
DATE_BKP=$(date +%Y%m%d-%H%M)
mkdir pg-backup
PGPASSWORD="$PG_PASS" pg_dumpall -h $PG_HOST -p 5432 -U $PG_USER > pg-backup/postgres-db.tar
file_name="pg-backup-"$DATE_BKP".tar.gz"

tar -zcvf $file_name pg-backup

filesize=$(stat -c %s $file_name)
mfs=10
if [[ "$filesize" -gt "$mfs" ]]; then
    aws s3 cp $file_name $S3_BUCKET
    echo "Backup finished successfully!"
fi