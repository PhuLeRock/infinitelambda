#!/usr/bin/python
import os
import psycopg2
import subprocess

conn_str = {
        'user': subprocess.check_output('aws ssm get-parameters --names /rds/db/rds-identifier/superuser/username --query "Parameters[*].Value"', shell=True).strip(),
        'host': subprocess.check_output('aws ssm get-parameters --names /rds/db/rds-identifier/endpoint --query "Parameters[*].Value" | cut -d : -f 1', shell=True).strip(),
        'port': 5432,
        'database': 'postgres',
        'password': subprocess.check_output('aws ssm get-parameters --names /rds/db/rds-identifier/superuser/password --query "Parameters[*].Value"', shell=True).strip()
    }
conn = psycopg2.connect(**conn_str)

cursor = conn.cursor()
cursor.execute('SELECT VERSION()')
row = cursor.fetchone()
print(row)
cursor.close()










