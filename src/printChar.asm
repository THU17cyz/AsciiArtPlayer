.386 
.model flat, stdcall
option casemap:none

INCLUDE asciiArt.inc


.data 
fileName BYTE 512 DUP(?) ; file name
readByte BYTE "rb",0
fp DWORD 0 ; file pointer

frames DWORD 0 ; number of frames
cols DWORD 0 ; number of columns(width)
rows DWORD 0 ; number of rows(height)
sleepTime DWORD 0 ; depends on fps
frameCount DWORD 0 ; loop variable
rowCount DWORD 0 ; loop variable

buffer BYTE 1024 DUP(?) ; buffer when reading a row

pointBase DWORD 0 ; cursor base point
cursorHandle DWORD 0 ; cursor handle
cursorInfo CONSOLE_CURSOR_INFO <> ; cursor info

; cmd to modify the size of the console
modifyConsoleSizeCmd BYTE 50 DUP(0)
modifyConsoleSizeTemplate BYTE "mode con cols=%d lines=%d", 0

sysTime SYSTEMTIME <>
curTime DWORD 0


.code
; ==========================================================================
; play the file
; no arguments, rows/cols/frames read from the file
; returns 1 if success, else 0
play PROC USES ecx, speed: DWORD
	INVOKE crt_fopen, addr fileName, addr readByte
	mov fp, eax
	cmp eax, 0
	jne file_ok
	jmp file_err

file_ok:
    ; reads the number of frames, columns and rows
	INVOKE crt_fread, addr frames, 4, 1, fp
	INVOKE crt_fread, addr cols, 4, 1, fp
	INVOKE crt_fread, addr rows, 4, 1, fp
	INVOKE crt_fread, addr sleepTime, 4, 1, fp

    ; adjust play speed
	.IF speed == 1
	    shl sleepTime, 2
	.ELSEIF speed == 2
	    shl sleepTime, 1
	.ELSEIF speed == 3
	    shr sleepTime, 1
	.ELSEIF speed == 4
	    shr sleepTime, 2
	.ENDIF
	
	; sets console window size
	mov eax, cols
	mov ebx, rows
	inc ebx
	INVOKE crt_sprintf, addr modifyConsoleSizeCmd, addr modifyConsoleSizeTemplate, eax, ebx
	INVOKE crt_system, addr modifyConsoleSizeCmd

	mov eax, 1
	mov frameCount, eax
	mov eax, 0
	mov rowCount, eax

	mov ecx, frames
	.WHILE frameCount < ecx
         
		 ; get current time
		INVOKE GetLocalTime, ADDR sysTime
		movzx eax, sysTime.wMilliseconds
		mov curTime, eax

		mov ecx, rows
		.WHILE rowCount < ecx
			INVOKE SetConsoleCursorInfo, cursorHandle,addr cursorInfo
			INVOKE crt_fread, addr buffer, 1, cols, fp

			; error detection
			.IF eax != cols
			    INVOKE crt_fclose, fp
				mov eax, 0
				ret
			.ENDIF
			mov eax, offset buffer
			add eax, cols
			mov BYTE PTR [eax], 0 ; add 0 to the end of buffer
			INVOKE crt_puts, addr buffer
			add rowCount, 1
			mov ecx, rows
		.ENDW
		mov ecx, 0
		mov rowCount, ecx

		; get current time again, and rectify the time to sleep
		INVOKE GetLocalTime, ADDR sysTime
		movzx eax, sysTime.wMilliseconds
		.IF eax < curTime
		    add eax, 1000
		.ENDIF
		sub eax, curTime
		mov ebx, sleepTime
		.IF ebx < eax ; if the printing is too slow that printing time is even larger than sleep time!
		    mov ebx, 0
		.ELSE
		    sub ebx, eax
		.ENDIF
		INVOKE Sleep, ebx

		INVOKE SetConsoleCursorPosition, cursorHandle, pointBase ; set cursor position to base point

		INVOKE getIsStopped
		.IF eax == 1
		    mov eax, 2
		    ret
		.ENDIF

		add frameCount, 1
		mov ecx, frames
	.ENDW
	INVOKE crt_fclose, fp
	mov eax, 1
	ret
file_err:
    mov eax, 0
	ret
play ENDP
; ========================================================================


; ========================================================================
; initializes fileName
; cursor visibility, size, and start position
initPlay PROC USES eax, fileAddr: PTR BYTE
    ; cursor handle is GetStdHandle(DWORD(-11))
	mov eax, 0
	sub eax, 11d
	INVOKE GetStdHandle, eax
	mov cursorHandle, eax
	
	INVOKE crt_strcpy, addr fileName, fileAddr
	
    mov eax, 0
	mov pointBase, eax

	mov cursorInfo.dwSize,1
	mov cursorInfo.bVisible,0 ; set cursor invisible
	invoke SetConsoleCursorInfo, cursorHandle, addr cursorInfo
	ret
initPlay ENDP
; ========================================================================

END 