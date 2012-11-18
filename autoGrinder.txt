                                                                     
                                                                     
                                                                     
                                             
@ECHO OFF
REM Author Ravi Joshi

REM Full path to Grinder installation directory under double quotes (if it contains spaces)
SET GRINDERPROPERTIESPATH=../etc/grinder.properties

SET LOADTESTINGPATH=C:\LoadTesting
SET GRINDERPATH=C:\grinder-3.2
SET DEPENDENCIES=C:\Loadtesting\lib\encryptor.jar
SET JAVA_HOME="C:\Program Files\Java\jdk1.6.0_20"


REM Initialize an array containing runs
REM SET RUNLIST=(1 5 10 25 50 75 100 125 150 175 200 250 300 350 400 450 500)
SET RUNLIST=(1 5 10 25 50)

SET HOSTNAME=%COMPUTERNAME%

ECHO Grinder dir is %GRINDERPATH%
ECHO Load Testing dir is %LOADTESTINGPATH%
ECHO Java dir is %JAVA_HOME%

SET CLASSPATH=%GRINDERPATH%\lib\grinder.jar;%CLASSPATH%

PATH=%JAVA_HOME%\bin;%PATH%

ECHO Make sure %LOADTESTINGPATH%\logs directory is empty.
ECHO Program is going to delete all the files inside this directory.
PAUSE
DEL /Q %LOADTESTINGPATH%\logs\*

REM Loop through the array and in each loop count call jar
FOR %%i IN %RUNLIST% DO (
    ECHO Started test for %%i thread
    
    JAVA -classpath %CLASSPATH% -Dgrinder.threads=%%i net.grinder.Grinder %GRINDERPROPERTIESPATH%   
    
    REM Put 2 sec sleep
    PING 1.1.1.1 -n 1 -w 2000 > NUL
        
    MKDIR ..\logs\%%i
    
    REM After finishing move the logss
    MOVE /Y %LOADTESTINGPATH%\logs\out_%HOSTNAME%-0.log %LOADTESTINGPATH%\logs\%%i\
    MOVE /Y %LOADTESTINGPATH%\logs\data_%HOSTNAME%-0.log %LOADTESTINGPATH%\logs\%%i\
    
    IF EXIST %LOADTESTINGPATH%\logs\error_%HOSTNAME%-0.log (
        MOVE /Y %LOADTESTINGPATH%\logs\error_%HOSTNAME%-0.log %LOADTESTINGPATH%\logs\%%i\
    )
    
    ECHO Finished test for %%i thread
	ECHO .
)

ECHO Finished. Press any key to exit.

PAUSE > NUL