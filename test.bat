nesasm3 mem-match.asm | find "#"
if %ERRORLEVEL%==0 goto END
fceuxdsp mem-match.nes
:END