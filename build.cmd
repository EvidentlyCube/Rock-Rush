REM Set this variable to the absolute or relative path to your SDK's bin directory. The SDK has to support at least Flash 10.1
SET MXMLC_PATH="c:/Programs/Air SDK/flex_sdk_4.6.0_a_3.6/bin/"

REM In order to build only a single version of the game copy the MXML_PATH variable declaration and the whole call of the version
REM you want to build into a separate *.cmd file and run it

REM First are all the release versions then the debug versions

REM Regular Release
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,true ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"regular\" ^
	-define+=CF::debug,false ^
	-output=bin/RockRush_Regular.swf ^
	src\game\global\Preloader.as
	
REM Classic I Release
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,true ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"classic-i\" ^
	-define+=CF::debug,false ^
	-output=bin/RockRush_Classic1.swf ^
	src\game\global\Preloader.as
	
REM Classic II Release
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,true ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"classic-ii\" ^
	-define+=CF::debug,false ^
	-output=bin/RockRush_Classic2.swf ^
	src\game\global\Preloader.as
	
REM Classic III Release
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,true ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"classic-iii\" ^
	-define+=CF::debug,false ^
	-output=bin/RockRush_Classic3.swf ^
	src\game\global\Preloader.as
	
REM Undervaults Release
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,true ^
	-define+=CF::modeName,\"undervaults\" ^
	-define+=CF::debug,false ^
	-output=bin/RockRush_Undervaults.swf ^
	src\game\global\Preloader.as
	
	
	
REM Debug versions

REM Regular Debug
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,true ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"regular\" ^
	-define+=CF::debug,true ^
	-output=bin/RockRush_Regular_DEBUG.swf ^
	-debug=true ^
	src\game\global\Preloader.as
	
REM Classic I Debug
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,true ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"classic-i\" ^
	-define+=CF::debug,true ^
	-output=bin/RockRush_Classic1_DEBUG.swf ^
	-debug=true ^
	src\game\global\Preloader.as
	
REM Classic II Debug
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,true ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"classic-ii\" ^
	-define+=CF::debug,true ^
	-output=bin/RockRush_Classic2_DEBUG.swf ^
	-debug=true ^
	src\game\global\Preloader.as
	
REM Classic III Debug
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,true ^
	-define+=CF::modeUndervaults,false ^
	-define+=CF::modeName,\"classic-iii\" ^
	-define+=CF::debug,true ^
	-output=bin/RockRush_Classic3_DEBUG.swf ^
	-debug=true ^
	src\game\global\Preloader.as
	
REM Undervaults Debug
%MXMLC_PATH%\mxmlc ^
	-default-size=528,448 ^
	-optimize ^
	-default-background-color=0 ^
	-frame=ContentFrame,game.global.CoreStarter ^
	-source-path=".\src" ^
	-source-path+=".\src.framework" ^
	-source-path+=".\src.utils" ^
	-define=CF::modeRegular,false ^
	-define+=CF::modeClassic1,false ^
	-define+=CF::modeClassic2,false ^
	-define+=CF::modeClassic3,false ^
	-define+=CF::modeUndervaults,true ^
	-define+=CF::modeName,\"undervaults\" ^
	-define+=CF::debug,true ^
	-output=bin/RockRush_Undervaults_DEBUG.swf ^
	-debug=true ^
	src\game\global\Preloader.as
	