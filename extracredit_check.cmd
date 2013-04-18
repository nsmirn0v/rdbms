del *.log
del b*
del dbfile.bin
del first second

rem
rem Create tab1
rem
db.exe "drop table tab1"
db.exe "create table tab1(name char(20), quizzes int, midterm int, final int)"
db.exe "insert into tab1 values('Douglas Belford', 50, 100, 150)"
db.exe "insert into tab1 values('Joe Leng', 36, 59, 98)"
db.exe "insert into tab1 values('Jason Caceres', 45, 95, 120)"
db.exe "insert into tab1 values('Eric Toledo', 40, 90, 120)"
db.exe "insert into tab1 values('Douglas Bottenhorn', 10, 38, 65)"

rem
rem Create tab2
rem
db.exe "drop table tab2"
db.exe "create table tab2(college char(20), zipcode char(5), rank int)"
db.exe "insert into tab2 values('Stanford University', '94043', 5)"
db.exe "insert into tab2 values('Amherst College', '12345', 4)"
db.exe "insert into tab2 values('US Military Academy', '95051', 3)"
db.exe "insert into tab2 values('Williams College', '10010', 1)"
db.exe "insert into tab2 values('Princeton Univercity', '10245', 2)"

rem
rem Validate transaction log file db.log to ensure all create and insert 
rem statements are logged properly.
rem
pause

rem
rem Create backup 'first'
rem
db.exe "backup to first"

rem
rem Validate backup image (e.g. size) and log file for the BACKUP entry
rem
pause

rem
rem Insert 5 new rows into tab1
rem
db.exe "insert into tab1 values('Theresa Lee', 50, 100, 150)"
db.exe "insert into tab1 values('Brian Balzer', 36, 59, 98)"
db.exe "insert into tab1 values('Mike Behrens', 45, 95, 120)"
db.exe "insert into tab1 values('Cord Kinney', 40, 90, 120)"
db.exe "insert into tab1 values('Hosun Caceres', 10, 38, 65)"

rem
rem Insert 5 new rows into tab2
rem
db.exe "insert into tab2 values('Harvard University', '94043', 6)"
db.exe "insert into tab2 values('Technology Institute', '12345', 9)"
db.exe "insert into tab2 values('US Air Force', '95051', 10)"
db.exe "insert into tab2 values('Chicago University', '10010', 8)"
db.exe "insert into tab2 values('Haverford College', '10245', 7)"

rem
rem Update the “final” values of the1st row in tab1
rem
db.exe "update tab1 set final = 149 where name = 'Douglas Belford'"

rem
rem Delete the 1st and 2nd rows from tab2
rem
db.exe "delete from tab2 where college = 'Stanford University'"
db.exe "delete from tab2 where college = 'Amherst College'"

rem
rem Validate transaction log to ensure the I/U/D are logged properly
rem
pause

rem
rem Create backup 'second'
rem
db.exe "backup to second"

rem
rem Validate backup image (e.g. size) and log file for the BACKUP entry
rem
pause

rem
rem Drop tab2
rem
db.exe "drop table tab2"

pause 

rem
rem Restor from second
rem
db.exe "restore from second"

pause
rem
rem Test db_flag
rem
db.exe "select * form tab1"
db.exe "create table t1(num int)"

rem 
rem Check FR_START entry in the log
rem
pause

rem
rem Rollforward
rem
db.exe "rollforward"

rem
rem Ensure that tab2 is drop again and FR_START entry is gone from the log
rem
pause

rem
rem Restor from second without rollforward
rem
db.exe "restore from second without RF"

rem
rem Make sure the that the log is backed up (db.log1) and pruned.  
rem Make sure the tab2 contents are still valid
rem
pause

rem 
rem Restore from first
rem
db.exe "restore from first"

rem
rem Test db_flag
rem
db.exe "select * form tab1"
db.exe "create table t1(num int)"

rem
rem Check for valid contents by doing select statement.  
rem Make sure the db_flag is set to ROLLFORWARD_PENDING 
rem by failing a valid DDL or DML statement such as “create table” or “insert”.
rem Check FR_START entry in the log
rem
pause

rem
rem Rollforward to <TIMESTAMP>
rem In this case the timestamp is between the deletion of the 1st the 2nd row from tab2.
rem
db.exe "rollforward to 20120510115039"

rem
rem Make sure the that the log is backed up (db.log2) and pruned.
rem Make sure tab1 and tab2 contents are still valid.
rem
pause

rem
rem Copy the db.log to db.log3.  Copy db.log1 to db.log.
rem
copy db.log db.log3
copy db.log1 db.log

rem
rem Check db.log, db.log3
rem
pause

rem
rem Restore from second and rollforward
rem
db.exe "restore from second"
db.exe "rollforward"

rem
rem You should be back to the state of the end of item #6 above
rem
pause

rem
rem Backup to existing backup file
rem
db.exe "backup to first"

pause

rem
rem Restore to nonexisting image file
rem
db.exe "restore from blah"

pause

rem
rem Rollforward to inavalid timestamp
rem
db.exe "rollforward to blah"
db.exe "rollforward to 123455"
