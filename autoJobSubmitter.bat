                                                                     
                                                                     
                                                                     
                                             
@ECHO OFF

REM Need to configure SERVER and PASSWORD of the PBS server
SET SERVER="192.168.33.220"
SET PASSWORD="perf@123"


SET PATHTOPUTTY="C:/Program Files/PuTTY/"

SET /P TOTALJOBS="Enter No of Jobs : "

SET CLASSPATH=C:\grinder-3.2\lib\grinder.jar;%CLASSPATH%
SET JAVA_HOME="C:\Program Files\Java\jdk1.6.0_20"

ECHO Java dir is %JAVA_HOME%>%CURRDIR%\JobSubmit.log
PATH=%JAVA_HOME%\bin;%PATH%

SET CURRDIR=%CD%
SET INDEX=1

ECHO Started at %date% %time%>>%CURRDIR%\JobSubmit.log

:START
REM Put 2 sec sleep
PING 1.1.1.1 -n 1 -w 2000 > NUL

%PATHTOPUTTY%plink.exe root@%SERVER% -pw %PASSWORD% -m %PATHTOPUTTY%cmd>%CURRDIR%\JobCount.txt

SET /P CURRJOBS=<%CURRDIR%\JobCount.txt
IF EXIST %CURRDIR%\JobCount.txt (
    DEL %CURRDIR%\JobCount.txt
)

SET TIMESTAMP=%date% %time%

IF [%CURRJOBS%] EQU [] (
    ECHO Could not connect to %SERVER% at %TIMESTAMP%>>%CURRDIR%\JobSubmit.log
    GOTO START
)ELSE (
    IF [%CURRJOBS%] LSS [%TOTALJOBS%] (

    IF [%INDEX%] GEQ [6] (
        SET /A INDEX=1
    )

    ECHO Started Grinder at %TIMESTAMP% with %CURRJOBS% jobs on PBS using agent%INDEX%.txt users>>%CURRDIR%\JobSubmit.log

    REM Run Grinder for 100 thread and 1 run
    JAVA -classpath %CLASSPATH% -Dgrinder.agentFile=%INDEX% -Dgrinder.threads=100 -Dgrinder.runs=1 net.grinder.Grinder ..\etc\grinder.properties

    SET /A INDEX+=1
    ECHO Finished Grinder at %TIMESTAMP% with %CURRJOBS% jobs on PBS>>%CURRDIR%\JobSubmit.log
    GOTO START
    )ELSE (
       ECHO Finished Grinder at %TIMESTAMP% with %CURRJOBS% jobs on PBS>>%CURRDIR%\JobSubmit.log
    )
)
