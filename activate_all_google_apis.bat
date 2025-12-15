@echo off
echo ========================================
echo Activation des APIs Google - HansEco
echo ========================================
echo.
echo Ouvrez ces liens dans votre navigateur et cliquez sur ACTIVER pour chacun:
echo.
echo [1] People API (REQUIS):
echo https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=989504216135
echo.
echo [2] Google Identity Toolkit API (REQUIS):
echo https://console.developers.google.com/apis/api/identitytoolkit.googleapis.com/overview?project=989504216135
echo.
echo [3] Google Sign-In API (RECOMMANDE):
echo https://console.developers.google.com/apis/library/plus.googleapis.com?project=989504216135
echo.
echo ========================================
echo.
echo Apres activation, ATTENDEZ 5-10 MINUTES avant de retester.
echo.
pause

REM Ouvrir les liens dans le navigateur
start https://console.developers.google.com/apis/api/people.googleapis.com/overview?project=989504216135
timeout /t 2 /nobreak >nul
start https://console.developers.google.com/apis/api/identitytoolkit.googleapis.com/overview?project=989504216135
