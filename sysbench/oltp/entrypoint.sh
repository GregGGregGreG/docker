#!/bin/bash

if [ -z "$MYSQL_HOST" ]; then
	echo >&2 'Error: MYSQL_HOST needs to be specified.'
	exit 1
fi

MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASS="${MYSQL_PASS:-root}"
MYSQL_DB="${MYSQL_DB:-test}"

OLTP_TEST=/usr/share/doc/sysbench/tests/db/oltp.lua
OLTP_TABLE_SIZE="${OLTP_TABLE_SIZE:-250000}"
OLTP_TABLES_COUNT="${OLTP_TABLES_COUNT:-1}"

REPORT_INTERVAL="${REPORT_INTERVAL:-1}"
MAX_REQUESTS="${MAX_REQUESTS:-0}"
TX_RATE="${TX_RATE:-10}"


echo ======= Using the following variables =======

echo OLTP_TEST $OLTP_TEST
echo OLTP_TABLE_SIZE $OLTP_TABLE_SIZE
echo OLTP_TABLES_COUNT $OLTP_TABLES_COUNT
echo MYSQL_HOST $MYSQL_HOST
echo MYSQL_USER $MYSQL_USER
echo MYSQL_PASS $MYSQL_PASS
echo MYSQL_DB $MYSQL_DB
echo REPORT_INTERVAL $REPORT_INTERVAL
echo MAX_REQUESTS $MAX_REQUESTS
echo TX_RATE $TX_RATE

echo 
echo ======= Executing sysbench [OPTIONS] prepare =======

sysbench --test=$OLTP_TEST \
--mysql-host=$MYSQL_HOST \
--mysql-user=$MYSQL_USER \
--mysql-password=$MYSQL_PASS \
--mysql-db=$MYSQL_DB \
--oltp-table-size=$OLTP_TABLE_SIZE \
--oltp-tables-count=$OLTP_TABLES_COUNT \
prepare

echo
echo ======= Executing sysbench [OPTIONS] run =======

sysbench --test=$OLTP_TEST \
--mysql-host=$MYSQL_HOST \
--mysql-user=$MYSQL_USER \
--mysql-password=$MYSQL_PASS \
--mysql-db=$MYSQL_DB \
--oltp-table-size=$OLTP_TABLE_SIZE  \
--oltp-tables-count=$OLTP_TABLES_COUNT \
--report-interval=$REPORT_INTERVAL \
--max-requests=$MAX_REQUESTS \
--tx-rate=$TX_RATE \
run | grep tps
