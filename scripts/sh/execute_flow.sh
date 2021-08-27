#!/bin/bash

bash -x /scripts/sh/get_enade.sh
python3 /scripts/python/enade_pandas.py
# sqoop import --connect jdbc:mysql://172.21.0.1:3306/enade --driver com.mysql.cj.jdbc.Driver --username root --password 1234 --table enade_tratado --m 1 --bindir /tmp/sqoop-root/compile
