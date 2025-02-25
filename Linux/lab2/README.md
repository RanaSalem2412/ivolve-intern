Lab 2: Shell Scripting Basics
* Objective: Create a shell script that automates taking backup from MySQL
database everyday at 5:00 PM.
---

Install MySQL Server:
```
sudo yum install -y mysql-server
```
Run the MySQL service:
```
sudo systemctl start mysqld
sudo systemctl enable mysqld
```
Verify that MySQL is running:
```
sudo systemctl status mysqld
```
Log in to MySQL:
```
mysql -u root -p
```
After logging in, you can check the databases using:
```
SHOW DATABASES;
```
Create a new file in /usr/local/bin containing the script:
```
sudo vim /usr/local/bin/mysql_backup.sh
```
Add the following code into the file:
```
#!/bin/bash


BACKUP_DIR="/backup/mysql"


DATE=$(date +%F-%H-%M-%S)


DB_USER="root"
DB_PASSWORD="studentrana2412"  # Replace with your MySQL password


LOG_FILE="/var/log/mysql_backup.log"


mkdir -p "$BACKUP_DIR"


echo "[$(date)] Starting MySQL backup..." >> "$LOG_FILE"


mysqldump -u"$DB_USER" -p"$DB_PASSWORD" --all-databases | gzip > "$BACKUP_DIR/db_backup_$DATE.sql.gz"


if [ $? -eq 0 ]; then
    echo "[$(date)]  Backup successful: $BACKUP_DIR/db_backup_$DATE.sql.gz" >> "$LOG_FILE"
else
    echo "[$(date)]  Backup failed!" >> "$LOG_FILE"
fi


find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +7 -exec rm {} \;


echo "[$(date)]  Backup process completed." >> "$LOG_FILE"
```

Give execution permission to the script:
```
sudo chmod +x /usr/local/bin/mysql_backup.sh
```
Create the log file and set permissions:
```
sudo touch /var/log/mysql_backup.log
sudo chmod 666 /var/log/mysql_backup.log
```

To schedule the script to run every Sunday at 5 AM, edit the crontab:
```
sudo crontab -e
```
Add this line:
```
0 5 * * 0 /usr/local/bin/mysql_backup.sh
```
Make sure to add the cron job:
```
sudo crontab -l
```
Run the script manually to test:
```
sudo /usr/local/bin/mysql_backup.sh
```
 
Verify that the backup file was created:
```
ls -lh /backup/mysql/
```

Check the log file for any errors:
```
cat /var/log/mysql_backup.log
```


































