INCLUDE msvcrt.inc
INCLUDELIB msvcrt.lib
INCLUDE kernel32.inc
INCLUDELIB kernel32.lib
INCLUDE windows.inc
INCLUDE user32.inc
INCLUDELIB user32.lib

bmpToAsciiArt PROTO,
bmpName: DWORD, 
outName: PTR BYTE,
doPlay: DWORD

processBmp PROTO,
bmpName: DWORD, 
outName: PTR BYTE,
fps: DWORD

playAsciiArt PROTO,
fileName: PTR BYTE,
speed: DWORD,
bgColor: DWORD,
charColor: DWORD

generate PROTO,
fps: DWORD,
videoPath: PTR BYTE,
doPlay: DWORD

play PROTO,
speed: DWORD

initPlay PROTO,
fileAddr: PTR BYTE,

clearFolder PROTO

stopProcess PROTO

getIsStopped PROTO

