# Data-Processing-Techiniques-in-Hive
data processing in hive after ingestion



-----------------Hive Base updated table --------------------------------------------------

First step
{
1)one time activity -----------
a)hive  external table without partition
b)Get the maximum date from hive base table & write into a file
}

Second step shell script
{
1)last_modified_dte=`cat last_modified_dte` last_modified_dte.file first it will read last modified value from file........... oozie
2)incremental job --------------- through oozie

sqoop import --connect 'jdbc:oracle:thin:@10.0.92.200:1521/ORALIMS' \
 --username 'KHAYATDB' -P --table 'INC_TEST_2' --target-dir '/user/raw_dmdata/inc_test' -m 1 \
 --merge-key 'ID' --check-column 'RECVD_DATE' --incremental lastmodified --last-value '14-Apr-17 11:00:47' \
 --verbose
}


{ 
1)--------then below will trigger through oozie if above success

2)hive query to get last value from hive_externl_base >> last_modified_dte.file
}


------------------------Audit/historical table to be a partitioned in hive ------------------------------------
{
1)firs time full load 
2)second job will sqoop the incremental data and append the existing hive table using below sqoop job with partition

sqoop import --connect 'jdbc:oracle:thin:@10.0.92.200:1521/ORALIMS' \
 --username 'KHAYATDB' -P  --target-dir '/user/raw_dmdata/inc_test=2017-04-14 10:00:47.0' -m 4  \
-e "select id,name,address,recvd_date from inc_test_2 where recvd_date > '2017-04-14 10:00:47.0' and \$CONDITIONS" \
 --verbose

exit

Afert sucessfull 
beeline "url" -e 'msck repair table table_name'
 
}
