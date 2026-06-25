@echo off
setlocal enabledelayedexpansion

echo get aixlog

if not exist "aixlog\" (
    git clone https://github.com/badaix/aixlog.git
    if errorlevel 1 goto :err

    pushd "aixlog"
        if not exist "build\" mkdir build
        pushd "build"
            cmake ..
            if errorlevel 1 goto :errpop2

            cmake --build . --config Release
            if errorlevel 1 goto :errpop2
						
        popd
		
		if not exist "\usr\local\include" mkdir "\usr\local\include"

		robocopy ".\include" "\usr\local\include" /E
		if %errorlevel% GEQ 8 goto :errpop3
    popd
) else (
    echo exists already
    pushd "aixlog"
        git pull
        if errorlevel 1 goto :errpop1

        if not exist "build\" mkdir build
        pushd "build"
            REM Re-configure
            cmake ..
            if errorlevel 1 goto :errpop2

            cmake --build . --config Release
            if errorlevel 1 goto :errpop2
        popd
		
		if not exist "\usr\local\include" mkdir "\usr\local\include"

		robocopy ".\include" "\usr\local\include" /E
		if %errorlevel% GEQ 8 goto :errpop3
    popd
)

echo Done.
exit /b 0

:errpop3
echo "ERROR 3"
popd
:errpop2
echo "ERROR 2"
popd
:errpop1
popd
:err
echo Error occurred.

exit /b 1