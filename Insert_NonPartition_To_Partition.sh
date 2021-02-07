####  ------- Step 1 ----------################# 

How to merge timestamp partition into date format

1)	Create a Normal internal or managed table 
Ex.
CREATE  TABLE INC_NON_PARTITION (
id STRING,
name STRING,
address STRING,
recvd_date string)
         ROW FORMAT DELIMITED
         FIELDS TERMINATED BY ','
         STORED AS TEXTFILE;

insert into INC_NON_PARTITION values('12','Safy','Dubai','01-JUL-20 05.55.55');
insert into INC_NON_PARTITION values('13','Sajid','canada','01-JUL-20 11.00.55');		 
insert into INC_NON_PARTITION values('14','Naveen','BANG','02-JUL-20 11.00.47');
insert into INC_NON_PARTITION values('15','SANDY','Dubai','02-JUL-20 01.00.47');
insert into INC_NON_PARTITION values('16','SAY','MUM','03-JUL-20 12.00.47');
insert into INC_NON_PARTITION values('17','SAZ','Dubai','03-JUL-20 01.00.47');

####  ------- Step 2 ----------################# 
2)	Create a partitioned table as base table which contains the day data after overwrite
It might be external or internal but I would recommend to have external table.

CREATE  TABLE INC_MERGED_PARTITION (
id STRING,
name STRING,
address STRING)
         partitioned by (recvd_date string)
         ROW FORMAT DELIMITED
         FIELDS TERMINATED BY ','
         STORED AS TEXTFILE;
         
 ####  ------- Step 3 ----------################# 

3)	Perform the merging data from non-partition to partitioned table using some basic logic
INSERT into TABLE INC_MERGED_PARTITION 
PARTITION(recvd_date) SELECT t.id,t.name,t.address, 
SUBSTR(t.recvd_date, 1, 9) AS recvd_date FROM INC_NON_PARTITION AS t;

####  ------- Step 4 ----------################# 
4)	Check the table contains partitions as day instead of timestamp.
Show partitions INC_MERGED_PARTITION;
 

####  ------- Step 5 ----------################# 

5)	Select any partition and cross check with NON partition table records.
You can see below with 2 rows of partition ’02-JUL-20’ which we can cross check in non-partitioned table.
