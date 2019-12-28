.386
.model flat, stdcall
option casemap:none

INCLUDE asciiArt.inc

.data
read_byte BYTE "rb+", 0
write_byte BYTE "wb", 0
append_byte BYTE "ab", 0
output BYTE "%d", 0dh, 0ah, 0
fp DWORD 0
outfp DWORD 0

; ascii map, key to char converting
asciiMap BYTE "$@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-T+G<>i!lI;:PASD  ", 0
asciiMapLen BYTE LENGTHOF asciiMap

; start point of bmp BGR info
sptr DWORD 0

; scale and origin/changed size of bmp
originRows DWORD 0
originCols DWORD 0
scaleX DWORD 0
scaleY DWORD 0
rows DWORD 0
cols DWORD 0

; addresses, lengths and buffers used when reading and printing
rowLen DWORD 0
pixels BYTE 3000 DUP(?)
grey BYTE 200000 DUP(?)
greyhead DWORD 0
greyLen DWORD 0
oneline BYTE 500 DUP(0)
buffer BYTE 1024 DUP(?)

; bmp contains zeros to align 
placeholder DWORD 0

; loop variables
i DWORD 0
count DWORD 0

; skip lists, used for down sampling a large bmp
xSkipList BYTE 1000 DUP(0)
ySkipList BYTE 1000 DUP(0)

; cmd to modify console size
consoleCmd BYTE 50 DUP(0)
modifyConsoleSize BYTE "mode con cols=%d lines=%d", 0

; information about fps
frames DWORD 0
sleepTime DWORD 0

; cursor related
basePoint DWORD 0
cursorHandle DWORD 0
cursorInfo CONSOLE_CURSOR_INFO <>


; ================================================================
; used to calculate the grey value from RGB values
; the grey value is in eax
; should not use registers edi and eax to pass the arguments
mCalGrey MACRO R:REQ, G:REQ, B:REQ
    push edi
	mov edi, 0
	mov eax, 19595
	mul R
	add edi, eax
	mov eax, 38469
	mul G
	add edi, eax
	mov eax, 7472
	mul B
	add edi, eax
	shr edi, 16
    mov eax, edi
	pop edi
ENDM
; =================================================================


; ==================================================================
; used to convert grey value to ascii char
; converted char is in al, and make sure grey value is in al before calling mConvertChar
mConvertChar MACRO 
	mov bl, asciiMapLen
	dec bl
	mul bl
	movzx eax, ax
    shr eax, 8
	add eax, OFFSET asciiMap
	mov al, BYTE PTR [eax]
ENDM
; ==================================================================


.code
; ==================================================================
; used to calculate a "skip table" from the origin size and scale
calSkipList PROC USES ebx ecx edx edi, old: DWORD, skiplist: PTR BYTE, scale: DWORD
    mov eax, old
	mul scale
	mov edx, 0
	mov ebx, 100
	div ebx
	mov edi, eax ; store the max idx in edi
	mov ecx, 0
	.WHILE ecx < edi
    mov eax, 100
	mul ecx

    ; may not be necessary (10floor(nx/10) + n-1)
	add eax, scale
	dec eax

	div scale
	mov ebx, eax
	inc ecx
	mov eax, 100
	mul ecx

	; may not be necessary (10floor(nx/10) + n-1)
	add eax, scale
	dec eax

	div scale
	
	sub eax, ebx
	dec eax

	mov ebx, skiplist
	add ebx, ecx
	dec ebx
	mov BYTE PTR [ebx], al

	.ENDW
	mov eax, edi
	inc eax
	ret
calSkipList ENDP
; ===================================================================


; ====================================================================
; opens a bmp file, extract the RGB info, and write it into the output file
bmpToAsciiArt PROC USES eax ebx ecx edx edi esi, bmpName: DWORD, outName: PTR BYTE, doPlay: DWORD
	mov eax, bmpName
	mov fp, eax

	INVOKE crt_fseek, fp, 0Ah, 0 ; go to bfOffBits
	INVOKE crt_fread, addr sptr, 4, 1, fp ; get offset

    ; start from the last line
	mov eax, OFFSET grey
	add eax, greyLen
	sub eax, cols
    mov greyhead, eax

	INVOKE crt_fseek, fp, sptr, 0

; =====================================================================
; generating grey sequence
	mov ecx, 0
	mov i, ecx

    .WHILE ecx < rows
        ; read a line of pixels
	    INVOKE crt_fread, addr pixels, 1, rowLen, fp
	    mov esi, 0
        mov edi, OFFSET pixels
	    .WHILE esi < cols
            ; get BGR of a pixel, calculate grey value and convert to char
			movzx ebx, BYTE PTR [edi]
			inc edi
			movzx ecx, BYTE PTR [edi]
			inc edi
			movzx edx, BYTE PTR [edi]
			inc edi
			mCalGrey edx, ecx, ebx
			mConvertChar

            ; store grey value
			mov ecx, greyhead
			add ecx, esi
			mov BYTE PTR [ecx], al
    
	        ; go to next column according to skip list
			mov ecx, esi
			add ecx, offset xSkipList
			mov eax, 0
			mov al, BYTE PTR [ecx]
			mov dl, 3
			mul dl
			add edi, eax
			inc esi
    	.ENDW
    
    	; go backwards a line
    	mov eax, greyhead
		sub eax, cols
		mov greyhead, eax

        ; go to next row according to skip list
    	mov ecx, i
		add ecx, offset ySkipList
		movzx eax, BYTE PTR [ecx]
		mov ebx, rowLen
		mul ebx
		INVOKE crt_fseek, fp, eax, 1
    
		; i++
		inc i
		mov ecx, i
	.ENDW

	
;======================================================================
    
    ; play on screen simultaneously
	; mov ecx, 0
	; .WHILE ecx < greyLen
    ; 	INVOKE crt_strncpy, addr oneline, greyhead, cols
	; 	INVOKE crt_puts, addr oneline
	; 	mov eax, cols
	; 	add greyhead, eax
	; 	mov ecx, greyhead
	; 	sub ecx, OFFSET grey
	; .ENDW

	; write into output file
    INVOKE crt_fopen, outName, addr append_byte ; open output file
	mov outfp, eax
	INVOKE crt_fwrite, addr grey, 1, greyLen, outfp
	
	
	INVOKE crt_fclose, outfp
	INVOKE crt_fopen, outName, addr read_byte ; open output file
	.IF doPlay == 1
		mov outfp, eax
		mov ebx, greyLen
		neg ebx
		INVOKE crt_fseek, outfp, ebx, 2
		mov ecx,rows
		mov eax, 0
		mov i, eax
			.WHILE i<ecx
				INVOKE crt_fread,addr buffer,1,cols, outfp
				mov eax,offset buffer
				add eax, cols
			    mov BYTE PTR [eax], 0 ; add 0 to the end of buffer
				INVOKE SetConsoleCursorInfo, cursorHandle,addr cursorInfo
				;INVOKE crt_printf,addr buffer
				INVOKE crt_puts,addr buffer
				;INVOKE crt_printf,addr str_n
				add i,1
				mov ecx,rows
			.ENDW
		invoke Sleep, sleepTime
		INVOKE SetConsoleCursorPosition, cursorHandle, basePoint
	.ENDIF
	

	INVOKE crt_fseek, outfp, 0, 0
	INVOKE crt_fread, addr count, 4, 1, outfp
	add count, 1
	INVOKE crt_fseek, outfp, 0, 0
	INVOKE crt_fwrite, addr count, 4, 1, outfp
	INVOKE crt_fclose, outfp
    ret
bmpToAsciiArt ENDP
; ==================================================================

; ==================================================================
; open first picture and do some initializing
processBmp PROC, bmpName: DWORD, outName: PTR BYTE , fps: DWORD
    mov eax, bmpName
	mov fp, eax
	INVOKE crt_fseek, fp, 012h, 0 ; go to bfOffBits

	INVOKE crt_fread, addr originCols, 4, 1, fp ; get offset
	INVOKE crt_fread, addr originRows, 4, 1, fp ; get offset

	mov eax, originRows
	mov ebx, 6
	mul ebx
	.IF originCols < eax
	    .IF originRows < 200
	        mov eax, 50
			mov scaleY, eax
			mov eax, 100
			mov scaleX, eax
		.ELSE
		    mov eax, 10000
            mov ebx, originRows
			div ebx
			mov scaleY, eax
			shl eax, 1
			mov scaleX, eax
		.ENDIF
	.ELSE
	    .IF originCols < 300
	        mov eax, 50
			mov scaleY, eax
			mov eax, 100
			mov scaleX, eax
		.ELSE
		    mov eax, 30000
            mov ebx, originCols
			div ebx
			mov scaleX, eax
			shr eax, 1
			mov scaleY, eax
		.ENDIF
	.ENDIF

	INVOKE calSkipList, originCols, addr xSkipList, scaleX
	mov cols, eax
	;INVOKE crt_printf, addr output, cols

	
	INVOKE calSkipList, originRows, addr ySkipList, scaleY
	mov rows, eax
    ;INVOKE crt_printf, addr output, rows
	

    ; set console window size
    mov ebx, rows
	inc ebx
    INVOKE crt_sprintf, addr consoleCmd, addr modifyConsoleSize, cols, ebx
	INVOKE crt_system, addr consoleCmd

	.IF fps == 0
	    mov eax, 100
	    mov sleepTime, eax
	.ELSEIF fps == 1
	    mov eax, 50
	    mov sleepTime, eax
	.ELSEIF fps == 2
	    mov eax, 33
	    mov sleepTime, eax
	.ENDIF
	

    INVOKE crt_fopen, outName, addr write_byte ; open output file
	mov outfp, eax
	INVOKE crt_fwrite, addr frames, 4, 1, outfp
	INVOKE crt_fwrite, addr cols, 4, 1, outfp
	INVOKE crt_fwrite, addr rows, 4, 1, outfp
	INVOKE crt_fwrite, addr sleepTime, 4, 1, outfp
	INVOKE crt_fclose, outfp

    mov eax, 0
	sub eax, 11d
	INVOKE GetStdHandle, eax
	mov cursorHandle, eax
	
    mov eax, 0
	mov basePoint, eax

	mov cursorInfo.dwSize,1
	mov cursorInfo.bVisible,0
	invoke SetConsoleCursorInfo, cursorHandle, addr cursorInfo

	;==============================================
; calculate the place holder length
; placeholder = 4 - (3 * cols) % 4 if (3 * cols) % 4 != 0 else 0
	mov ax, WORD PTR originCols
	mov dx, 0
	mov bx, 3
	mul bx
	mov bx, 4
	div bx
	cmp dx, 0
	
	je noplaceholder
    movzx ebx, dx
    mov eax, 4
	sub eax, ebx
	mov placeholder, eax
;====================================================================


noplaceholder:
    mov eax, rows
	mov ebx, cols
	mul ebx
	mov greyLen, eax

	mov eax, 3
	mul originCols
	; add the trailing zeros
    .IF placeholder != 0
	    add eax, placeholder
	.ENDIF
	mov rowLen, eax

    ret
processBmp ENDP
; ==================================================================

END
