.386 
.model flat, stdcall
option casemap:none

INCLUDE asciiArt.inc

.data 
; bmp path
bmpPathTemplate BYTE "frames\pic-%05d.bmp",0
bmpPath BYTE 256 DUP(0)

; output file name
outfile BYTE 256 DUP(?)

read_ BYTE "rb",0
write_ BYTE "rb+",0

windowTitle BYTE "Ascii Art",0

filehandle DWORD 0
basePoint DWORD 0
cursorhandle DWORD ?

; used for cmds
ffmpegCmd BYTE 512 DUP(?)
cmdPrefix BYTE "utils\ffmpeg -i ",22h, 0
video DWORD 0
cmdSuffix BYTE "-q:v 2 -f image2 frames\pic-%05d.bmp -v 0", 0
concatFormat1 BYTE "%s%s", 22h, 0
concatFormat2 BYTE "%s -r %d %s",0
appleSuffix BYTE ".apple", 0
clearScreenCmd BYTE "cls", 0
minimizeFontSizeCmd BYTE "utils\tiny", 0
setColorCmd BYTE 20 DUP(?)
colorCmdTemplate BYTE "color %02x", 0
fuck BYTE "%s", 0
frameRate DWORD 0 ; frame rate
processFinished DWORD 0 ; whether or not the ffmpeg process has finished
frameCount DWORD 1 ; used as the number in "pic-%05d.bmp"

; some status variables
status DWORD ?
isStopped DWORD ?


.code

; ===================================================================
; his procedure uses ffmpeg.exe to extract frames from the video (multi-thread)
ffmpeg PROC
    ; concat the ffmpeg cmd
	INVOKE crt_sprintf,addr ffmpegCmd,addr concatFormat1,addr cmdPrefix, video
	INVOKE crt_sprintf,addr ffmpegCmd,addr concatFormat2,addr ffmpegCmd, frameRate, addr cmdSuffix
	INVOKE crt_system, addr ffmpegCmd

	; once finished, set this variable to 1
	mov eax, 1
	mov processFinished, eax
	ret
ffmpeg ENDP
; ===================================================================


; ===================================================================
; this procedure generates a .apple file and plays it simultaneously
generate PROC, fps: DWORD, videoPath: PTR BYTE, doPlay: DWORD
    mov eax, 0
	mov isStopped, eax

    ; set console title
    INVOKE SetConsoleTitleA, addr windowTitle

	.IF doPlay == 1
	    ; show the console window above the GUI
        INVOKE GetConsoleWindow
        INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW 
	.ENDIF

	; adjusts fps
	.IF fps == 0
	    mov eax, 10
	    mov frameRate, eax
	.ELSEIF fps == 1
	    mov eax, 20
	    mov frameRate, eax
	.ELSEIF fps == 2
	    mov eax, 30
	    mov frameRate, eax
	.ENDIF

	; minimize font size
    INVOKE crt_system, addr minimizeFontSizeCmd

	; start video processing
    mov eax, videoPath
	mov video, eax
	mov eax, OFFSET ffmpeg
	INVOKE CreateThread, NULL, NULL, eax, 0, 0, 0

	; generate .apple file name
	invoke crt_strrchr,videoPath,'\'
	add eax,1
	invoke crt_strcpy, addr outfile, eax
	invoke crt_strrchr,addr outfile, '.'
	mov BYTE PTR [eax], 0
	invoke crt_strcat, addr outfile,addr appleSuffix
	
	; read bmp file one by one
	mov eax, 1
	mov frameCount, eax
    INVOKE Sleep, 3000 ; give ffmpeg some time to process


	.WHILE frameCount < 9999
		INVOKE crt_sprintf, addr bmpPath, addr bmpPathTemplate, frameCount
		INVOKE crt_fopen, addr bmpPath, addr read_
		mov filehandle, eax
		cmp eax, 0
		jne file_ok
		jmp file_err
file_ok:
        ; read bmp size and initialize
	    .IF frameCount == 1
			INVOKE processBmp, filehandle, addr outfile, fps
		.ENDIF
		
		; convert bmp to ascii art and play it if chosen to do so
	    INVOKE bmpToAsciiArt, filehandle, addr outfile, doPlay

		mov eax, filehandle
		INVOKE crt_fclose, eax

		; remove bmp!
		INVOKE crt_remove, addr bmpPath

		.IF isStopped == 1
		    INVOKE crt_system, addr clearScreenCmd
		    INVOKE GetConsoleWindow
            INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW 
		    mov eax, 2
		    ret
		.ENDIF

		add frameCount, 1
		.CONTINUE

file_err:
        ; if video processing finished, file open error means there are no more unread files
	    .IF processFinished == 1
			.BREAK
		.ENDIF

		; else, could be video processing not fast enough
		.CONTINUE
	.ENDW
	INVOKE crt_system, addr clearScreenCmd
	INVOKE GetConsoleWindow
    INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW 

	.IF frameCount > 1
	    ; if success, return 1
	    mov eax, 1
	.ELSE
	    mov eax, 0
	.ENDIF
	ret
generate ENDP
; ===================================================================


; ===================================================================
; this procedure opens a .apple file and plays the ascii art
playAsciiArt PROC, applePath: PTR BYTE, speed: DWORD, bgColor: DWORD, charColor: DWORD
    mov eax, 0
	mov isStopped, eax

    ; adjust color
    mov eax, bgColor
    shl eax, 4
	add eax, charColor
    INVOKE crt_sprintf, addr setColorCmd, addr colorCmdTemplate, eax
    INVOKE crt_system, addr setColorCmd

	; set console title
    INVOKE SetConsoleTitleA, addr windowTitle
	
	; make console window show above the GUI
    INVOKE GetConsoleWindow
    INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_SHOWWINDOW 
	
	; minimize console window font size
    INVOKE crt_system, addr minimizeFontSizeCmd

	; initialize and start playing
    INVOKE initPlay, applePath
	INVOKE play, speed
	mov status, eax

	; clear the screen
	INVOKE crt_system, addr clearScreenCmd

	INVOKE GetConsoleWindow
    INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW 
	mov eax, status
	ret
playAsciiArt ENDP
; ===================================================================


; ===================================================================
; this procedure stops the generating or playing process
stopProcess PROC
    mov eax, 1
    mov isStopped, eax
	ret
stopProcess ENDP
; ===================================================================

; ===================================================================
; this procedure checks whether the current procedure is stopped
getIsStopped PROC
    mov eax, isStopped
	ret
getIsStopped ENDP
; ===================================================================


; ===================================================================
; this procedure clears .\frames folder
clearFolder PROC
    mov eax, 1
	mov frameCount, eax
    .WHILE frameCount < 9999
        INVOKE crt_sprintf, addr bmpPath, addr bmpPathTemplate, frameCount
	    INVOKE crt_remove, addr bmpPath
        add frameCount, 1
	.ENDW
	ret
clearFolder ENDP
; ===================================================================

END
