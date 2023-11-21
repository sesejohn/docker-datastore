## IMPORTANT! Setup of MariaDB Master-Slave Replication (after booting both server)
### This configures the slave server with information about the master server, so it knows where to begin replicating data. Also, this specifies the master's binary log file and log position from which the slave should start replicating.
---
##### Note:

To execute these SQL commands, you can connect to your MariaDB instances using a database client or the command line. Using Docker, you can connect to access the MySQL shell:
- For master container, `docker exec -it mariadb-master mysql -u root -p`
- For slave container, `docker exec -it mariadb-slave mysql -u root -p`
---

1. **In `master` container: Lock the Master Database**
- Before you begin, you need to ensure that no changes are made to the master database during this process. This is typically done by locking the database for writes. On the master, execute:
    ```sql
    FLUSH TABLES WITH READ LOCK;
    ```
2. **In `master` container: Get Master Status**
- Run the following command to get the current binary log file and position:
    ```sql
    SHOW MASTER STATUS;
    ```
    This will display information including the File (the binary log file name) and Position. Note down these values.

3. **In `master` container: Unlock the Master Database**
- After you have noted down the file and position, unlock the tables on the master:
    ```sql
    UNLOCK TABLES;
    ```

4. **In `slave` container: Set Up the Slave**
- You will use the `CHANGE MASTER TO` command with the information you just gathered. Replace `master_log_file` and `master_log_pos` with the values you got from the master. Also, replace `master_user` and `master_password` with the credentials of the replication user:
    ```sql
    CHANGE MASTER TO
    MASTER_HOST='mariadb-master',
    MASTER_USER='replication_user',
    MASTER_PASSWORD='replication_password',
    MASTER_LOG_FILE='master_log_file',
    MASTER_LOG_POS=master_log_pos;
    ```
    Note: Only the `master_log_pos` value does not have single quotes, since it holds integer value.

5. **In `slave` container: Start the Slave**
- Finally, start the slave process:
    ```sql
    START SLAVE;
    ```
6. **Check if replication is working**
- Ensure that `Slave_IO_Running` and `Slave_SQL_Running` are both `Yes`. Also, check for any errors.
    ```sql
    SHOW SLAVE STATUS\G;
    ```
    Note: The usage of `\G` tells the MySQL client to display the results in a vertical format.
### Additional Notes
* Make sure that slave has the same data as the master
* Command for creating new user (granting SELECT, INSERT, UPDATE, DELETE commands). Just replace `database_user`, `database`, `database_password`.
    ```sql
    CREATE USER 'database_user'@'%' IDENTIFIED BY 'database_password';
    GRANT SELECT, INSERT, UPDATE, DELETE ON database.* to 'database_user'@'%' IDENTIFIED BY 'database_password';
    FLUSH PRIVILEGES;
    ```