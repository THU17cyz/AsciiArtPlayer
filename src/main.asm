.386
.model flat,stdcall
option casemap:none
INCLUDE windows.inc
INCLUDE kernel32.inc
INCLUDELIB kernel32.lib
INCLUDE user32.inc
INCLUDELIB user32.lib
INCLUDE msvcrt.inc
INCLUDELIB msvcrt.lib
INCLUDE comdlg32.inc
INCLUDELIB comdlg32.lib
INCLUDE comctl32.inc
INCLUDELIB comctl32.lib

INCLUDE window.inc
INCLUDE asciiArt.inc

.const
;==================== CONST =======================
szNull			   BYTE 0
szNewLine		   BYTE endl, 0			   
szWinClass		   BYTE "ASMWIN", 0
szButtonClass	   BYTE "BUTTON", 0
szEditClass		   BYTE "EDIT", 0
szStaticClass      BYTE "STATIC", 0
szComboboxClass	   BYTE "COMBOBOX", 0

szFilterAll		   BYTE "ý���ļ��������ļ���", 0, "*.*", 0, 0
szFilterMp4	   BYTE "MP4�ļ�.mp4", 0, "*.mp4", 0, 0
szFilterApple	   BYTE "�ַ������ļ�.apple", 0, "*.apple", 0, 0

szWinText		   BYTE "�ַ�����", 0
szGroupboxMakeText BYTE "�ַ���������", 0
szGroupboxPlayText BYTE "�ַ���������", 0
szButtonSelectText BYTE "ѡ��", 0
szButtonMakeText   BYTE "����", 0
szButtonPlayText   BYTE "����", 0
szButtonStopText   BYTE "ֹͣ", 0
szRadioButtonText1 BYTE "FPS: 10", 0
szRadioButtonText2 BYTE "FPS: 20", 0
szRadioButtonText3 BYTE "FPS: 30", 0
szRadioButtonText4 BYTE "����������", 0
szRadioButtonText5 BYTE "���ɲ�����", 0

szStaticText1	   BYTE "������ɫ", 0
szStaticText2	   BYTE "�ַ���ɫ", 0
szStaticText3	   BYTE "���ű���", 0
szComboboxText0	   BYTE "��ɫ", 0
szComboboxText1	   BYTE "��ɫ", 0
szComboboxText2	   BYTE "��ɫ", 0
szComboboxText3	   BYTE "ǳ��ɫ", 0
szComboboxText4	   BYTE "��ɫ", 0
szComboboxText5	   BYTE "��ɫ", 0
szComboboxText6	   BYTE "��ɫ", 0
szComboboxText7	   BYTE "��ɫ", 0
szComboboxText8	   BYTE "��ɫ", 0
szComboboxText9	   BYTE "����ɫ", 0
szComboboxTextA	   BYTE "����ɫ", 0
szComboboxTextB	   BYTE "��ǳ��ɫ", 0
szComboboxTextC	   BYTE "����ɫ", 0
szComboboxTextD	   BYTE "����ɫ", 0
szComboboxTextE	   BYTE "����ɫ", 0
szComboboxTextF	   BYTE "����ɫ", 0
szComboboxText10   BYTE "1.0 ����", 0
szComboboxText11   BYTE "0.25 ����", 0
szComboboxText12   BYTE "0.5 ����", 0
szComboboxText13   BYTE "2.0 ����", 0
szComboboxText14   BYTE "4.0 ����", 0


szInfoInit					BYTE "����Ϣ�������ʼ�����", 0
szInfoSelectBegin			BYTE "����Ϣ������ѡ���ļ�...", 0
szInfoSelectEnd				BYTE "���ɹ����ļ�ѡ��ɹ���", 0
szInfoMakeBegin				BYTE "����Ϣ�����������ַ�����...", 0
szInfoMakeError				BYTE "����Ϣ�������ַ���������", 0
szInfoMakeEnd				BYTE "���ɹ��������ַ������ɹ���", 0
szInfoPlayBegin				BYTE "����Ϣ�����ڲ����ַ�����...", 0
szInfoPlayError				BYTE "����Ϣ�������ַ���������", 0
szInfoPlayEnd				BYTE "���ɹ��������ַ�������ϣ�", 0
szInfoStopped				BYTE "����Ϣ����ǰ������ֹ��", 0
szInfoIsWorking				BYTE "����Ϣ������/����ʱ���ܽ�������������", 0
szInfoNoDirectorySelected   BYTE "����Ϣ��û��ѡ���κ��ļ���", 0


szTest			   BYTE "����", 0


;==================== DATA =======================
.data
; --- ������ṹ�嶨�� ---
MainWin WNDCLASS <>			; ��������

; --- ��Ϣ��ṹ�嶨�� ---
msg   MSG <>				; ��Ϣ����

; --- �ļ��򿪽ṹ�嶨�� ---
openFile OPENFILENAME <>	; �ļ��򿪱���

; --- �����ṹ�嶨�� ---
initCtrls INITCOMMONCONTROLSEX <>
rect RECT <>


; --- ������� ---����
hInstance			DWORD ?		; ��ǰģ����
hMainWnd			DWORD ?		; �����ھ��
hStdOut				DWORD ?		; ��׼�������̨�ֲ�

hGroupboxMake		DWORD ?		; �������������
hGroupboxPlay		DWORD ?		; �������������

hButtonSelect1		DWORD ?		; ѡ��ťһ���
hButtonSelect2		DWORD ?		; ѡ��ť�����
hButtonMake			DWORD ?		; ���ɰ�ť���
hButtonPlay			DWORD ?		; ������ť���
hButtonStop1		DWORD ?		; ֹͣ��ťһ���
hButtonStop2		DWORD ?		; ֹͣ��ť�����


hRadioButton1		DWORD ?		; ��ѡ��һ���
hRadioButton2		DWORD ?		; ��ѡ������
hRadioButton3		DWORD ?		; ��ѡ�������
hRadioButton4		DWORD ?		; ��ѡ���ľ��
hRadioButton5		DWORD ?		; ��ѡ������


hEditInfo			DWORD ?		; ��Ϣ�������
hEditFilename1		DWORD ?		; �ļ����༭��һ���
hEditFilename2		DWORD ?		; �ļ����༭������

hStatic1		    DWORD ?		; ��̬��һ���
hStatic2			DWORD ?		; ��̬������
hStatic3			DWORD ?		; ��̬�������

hComboboxBackcolor	DWORD ?		; ������ɫ��Ͽ�
hComboboxCharcolor	DWORD ?		; �ַ���ɫ��Ͽ�
hComboboxPlayspeed	DWORD ?		; ���ű�����Ͽ�

; --- ���ͱ������� ---
nFPSChoice       DWORD ?	; ����֡��ѡ��
nMakeModeChoice	 DWORD ?	; ����ģʽѡ��
nBackcolorChoice DWORD ?	; ������ɫѡ��
nCharcolorChoice DWORD ?	; �ַ���ɫѡ��
nSpeedChoice DWORD ?		; �����ٶ�ѡ��

; --- �ַ����������� ---
szBuffer		BYTE BUFFER_LENGTH DUP(0)			; �����ַ���
szBuffer2		BYTE BUFFER_LENGTH DUP(0)			; �����ַ���2, Ϊ�˱��������ļ�ѡ��������
szInformation	BYTE INFORMATION_LENGTH DUP(0)		; ��Ϣ�ַ���
szWorkDir		BYTE BUFFER_LENGTH DUP(0)			; ����·��

; �Ƿ����ڲ���
isWorking DWORD 0

clearScreenCmd BYTE "cls", 0


;=================== CODE =========================
.code

; ---����̨�ر��¼� ---
onConsoleClose PROC, ctrlType: DWORD
    .IF ctrlType == 2 || ctrlType == 1 || ctrlType == 0
	    INVOKE clearFolder ; �Ƚ�frames�ļ��е���ʱͼƬ���
	.ENDIF
	ret
onConsoleClose ENDP


; ---��ʼ���� ---
startMake PROC
    mov eax, 1
	mov isWorking, eax
    INVOKE syncWorkDir
	INVOKE clearFolder ; �Ƚ�frames�ļ��е���ʱͼƬ���
    INVOKE generate, nFPSChoice, ADDR szBuffer2, nMakeModeChoice
    .IF eax == 0
        INVOKE addEdit, hEditInfo, ADDR szInfoMakeError
	.ELSEIF eax == 1
        INVOKE addEdit, hEditInfo, ADDR szInfoMakeEnd
	.ELSE
	    INVOKE addEdit, hEditInfo, ADDR szInfoStopped
	.ENDIF
	mov eax, 0
	mov isWorking, eax
	ret
startMake ENDP


; ---��ʼ���� ---
startPlay PROC
    mov eax, 1
	mov isWorking, eax
    INVOKE syncWorkDir
    INVOKE playAsciiArt, ADDR szBuffer2, nSpeedChoice, nBackcolorChoice, nCharcolorChoice
	.IF eax == 0
        INVOKE addEdit, hEditInfo, ADDR szInfoPlayError
	.ELSEIF eax == 1
        INVOKE addEdit, hEditInfo, ADDR szInfoPlayEnd
	.ELSE
	    INVOKE addEdit, hEditInfo, ADDR szInfoStopped
	.ENDIF
	mov eax, 0
	mov isWorking, eax
	ret
startPlay ENDP


WinMain PROC
	; ��ʼ��ͨ�ÿؼ�
	mov initCtrls.dwSize, SIZEOF initCtrls
	mov initCtrls.dwICC, ICC_WIN95_CLASSES
	INVOKE InitCommonControlsEx, ADDR initCtrls
	; ��ȡ����·��
	INVOKE crt__getcwd, ADDR szWorkDir, BUFFER_LENGTH
	; ���ÿ���̨����
	INVOKE GetConsoleWindow			; ��ȡ����̨���
	mov hStdOut, eax
	INVOKE SetConsoleTitle, ADDR szWinText
	INVOKE GetWindowRect, hStdOut, ADDR rect
	INVOKE GetWindowLong, hStdOut, GWL_STYLE
	mov ebx, WS_SIZEBOX
	neg ebx
	and eax, ebx
	INVOKE SetWindowLong, hStdOut, GWL_STYLE, eax
	INVOKE SetConsoleCtrlHandler, OFFSET onConsoleClose, 1
	; ���ô���������
	mov MainWin.style, CS_HREDRAW or CS_VREDRAW		; ���� ������ʽ
	mov MainWin.lpfnWndProc, OFFSET WinProc			; ���� WinProc ����ָ��
	mov MainWin.cbClsExtra, NULL					; ���� �����ڴ�
    mov MainWin.cbWndExtra, NULL					; ���� �����ֽ���
	INVOKE GetModuleHandle, NULL					; ��ȡ��ǰģ����
    mov hInstance, eax
	mov MainWin.hInstance, eax						; ���� ��ǰ������
    INVOKE LoadIcon, NULL, IDI_APPLICATION
    mov MainWin.hIcon, eax							; ���� ͼ����
    INVOKE LoadCursor, NULL, IDC_ARROW
    mov MainWin.hCursor, eax						; ���� �����
	mov MainWin.hbrBackground, COLOR_APPWORKSPACE	; ���� ����ˢ���
	mov MainWin.lpszMenuName,NULL					; ���� �˵������
	mov MainWin.lpszClassName, OFFSET szWinClass	; ���� WinClass �����
	; ע�ᴰ����
    INVOKE RegisterClass, ADDR MainWin
    .IF eax == 0
		call ErrorHandler
		jmp Exit_Program
    .ENDIF
	; ����������
    INVOKE CreateWindowEx, NULL, ADDR szWinClass, ADDR szWinText,
		WS_VISIBLE + WS_CAPTION + WS_SYSMENU + WS_MINIMIZEBOX,
		CW_USEDEFAULT, CW_USEDEFAULT, MAINWIN_WIDTH, MAINWIN_HEIGHT, NULL, NULL, hInstance, NULL
    mov hMainWnd, eax
    .IF eax == 0
		call ErrorHandler
		jmp  Exit_Program
    .ENDIF
	; ��ʾ������
    INVOKE ShowWindow, hMainWnd, SW_SHOW
    INVOKE UpdateWindow, hMainWnd
	; ��Ϣѭ��
Message_Loop:
    ; �Ӷ�����ȡ����һ����Ϣ
    INVOKE GetMessage, ADDR msg, NULL, NULL, NULL
    .IF eax == 0
		jmp Exit_Program
	.ENDIF
    ; ����Ϣ���ݸ������ WinProc
	invoke TranslateMessage, ADDR msg
    INVOKE DispatchMessage, ADDR msg
    jmp Message_Loop
; �����˳�
Exit_Program:
      INVOKE ExitProcess,0
WinMain ENDP

;-----------------------------------------------------
WinProc PROC,
    hWnd:HWND, localMsg:UINT, wParam:WPARAM, lParam:LPARAM
; Ӧ�ó������Ϣ������̣�����Ӧ�ó����ض�����Ϣ��
; ����������Ϣ�򴫵ݸ�Ĭ�ϵ� windows ��Ϣ�������
;-----------------------------------------------------
    mov eax, localMsg
	; --- ����������Ϣ ---
    .IF eax == WM_CREATE
		; ���������ؼ�
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szGroupboxMakeText, WS_CHILD + WS_VISIBLE + BS_GROUPBOX,
			50, 180, 700, 150, hWnd, IDB_GROUPBOX_MAKE, hInstance, NULL
		mov hGroupboxMake, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szGroupboxPlayText, WS_CHILD + WS_VISIBLE + BS_GROUPBOX,
			50, 350, 700, 150, hWnd, IDB_GROUPBOX_PLAY, hInstance, NULL
		mov hGroupboxPlay, eax
		; ������ť�ؼ�
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szButtonSelectText, WS_CHILD + WS_VISIBLE + BS_PUSHBUTTON,
			500, 280, 60, 30, hWnd, IDB_BUTTON_SELECT_1, hInstance, NULL
		mov hButtonSelect1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szButtonMakeText, WS_CHILD + WS_VISIBLE + BS_PUSHBUTTON,
			570, 280, 60, 30, hWnd, IDB_BUTTON_MAKE, hInstance, NULL
		mov hButtonMake, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szButtonStopText, WS_CHILD + WS_VISIBLE + BS_PUSHBUTTON,
			640, 280, 60, 30, hWnd, IDB_BUTTON_STOP_1, hInstance, NULL
		mov hButtonStop1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szButtonSelectText, WS_CHILD + WS_VISIBLE + BS_PUSHBUTTON,
			500, 450, 60, 30, hWnd, IDB_BUTTON_SELECT_2, hInstance, NULL
		mov hButtonSelect1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szButtonPlayText, WS_CHILD + WS_VISIBLE + BS_PUSHBUTTON,
			570, 450, 60, 30, hWnd, IDB_BUTTON_PLAY, hInstance, NULL
		mov hButtonPlay, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szButtonStopText, WS_CHILD + WS_VISIBLE + BS_PUSHBUTTON,
			640, 450, 60, 30, hWnd, IDB_BUTTON_STOP_2, hInstance, NULL
		mov hButtonStop2, eax
		; ������ѡ��ؼ�
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szRadioButtonText1, WS_CHILD + WS_VISIBLE + WS_BORDER + BS_AUTORADIOBUTTON + WS_GROUP,
			120, 230, 80, 20, hWnd, IDB_RADIOBUTTON_1, hInstance, NULL
		mov hRadioButton1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szRadioButtonText2, WS_CHILD + WS_VISIBLE + WS_BORDER + BS_AUTORADIOBUTTON,
			210, 230, 80, 20, hWnd, IDB_RADIOBUTTON_2, hInstance, NULL
		mov hRadioButton2, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szRadioButtonText3, WS_CHILD + WS_VISIBLE + WS_BORDER + BS_AUTORADIOBUTTON,
			300, 230, 80, 20, hWnd, IDB_RADIOBUTTON_3, hInstance, NULL
		mov hRadioButton3, eax
		INVOKE SendMessage, eax, BM_SETCHECK, BST_CHECKED, NULL
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szRadioButtonText4, WS_CHILD + WS_VISIBLE + WS_BORDER + BS_AUTORADIOBUTTON + WS_GROUP,
			470, 230, 100, 20, hWnd, IDB_RADIOBUTTON_4, hInstance, NULL
		mov hRadioButton4, eax
		INVOKE SendMessage, eax, BM_SETCHECK, BST_CHECKED, NULL
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szRadioButtonText5, WS_CHILD + WS_VISIBLE + WS_BORDER + BS_AUTORADIOBUTTON,
			580, 230, 100, 20, hWnd, IDB_RADIOBUTTON_5, hInstance, NULL
		mov hRadioButton5, eax
		; �����ı���ؼ�
		INVOKE CreateWindowEx, NULL, OFFSET szEditClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_MULTILINE + ES_READONLY + WS_VSCROLL, 
			50, 30, 700, 130, hWnd, IDE_EDIT_INFO, hInstance, NULL
		mov hEditInfo, eax
		INVOKE CreateWindowEx, NULL, OFFSET szEditClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_AUTOHSCROLL, 
			100, 280, 380, 30, hWnd, IDE_EDIT_FILENAME_1, hInstance, NULL
		mov hEditFilename1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szEditClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_AUTOHSCROLL, 
			100, 450, 380, 30, hWnd, IDE_EDIT_FILENAME_2, hInstance, NULL
		mov hEditFilename2, eax
		; ������̬��ؼ�
		INVOKE CreateWindowEx, NULL, OFFSET szStaticClass, OFFSET szStaticText1, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_CENTER, 
			115, 400, 70, 24, hWnd, IDS_STATIC_1, hInstance, NULL
		mov hStatic1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szStaticClass, OFFSET szStaticText2, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_CENTER, 
			315, 400, 70, 24, hWnd, IDS_STATIC_2, hInstance, NULL
		mov hStatic2, eax
		INVOKE CreateWindowEx, NULL, OFFSET szStaticClass, OFFSET szStaticText3, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_CENTER, 
			515, 400, 70, 24, hWnd, IDS_STATIC_3, hInstance, NULL
		mov hStatic3, eax
		; ������Ͽ�ؼ�
		INVOKE CreateWindowEx, NULL, OFFSET szComboboxClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + WS_VSCROLL + CBS_DROPDOWNLIST, 
			185, 400, 100, 300, hWnd, IDC_COMBOBOX_BACKCOLOR, hInstance, NULL
		mov hComboboxBackcolor, eax
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText0
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText1
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText2
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText3
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText4
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText5
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText6
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText7
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText8
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxText9
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxTextA
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxTextB
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxTextC
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxTextD
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxTextE
		INVOKE addCombobox, hComboboxBackcolor, ADDR szComboboxTextF
		INVOKE setCombobox, hComboboxBackcolor, 0
		INVOKE CreateWindowEx, NULL, OFFSET szComboboxClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + WS_VSCROLL + CBS_DROPDOWNLIST, 
			385, 400, 100, 300, hWnd, IDC_COMBOBOX_CHARCOLOR, hInstance, NULL
		mov hComboboxCharcolor, eax
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText0
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText1
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText2
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText3
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText4
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText5
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText6
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText7
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText8
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxText9
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxTextA
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxTextB
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxTextC
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxTextD
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxTextE
		INVOKE addCombobox, hComboboxCharcolor, ADDR szComboboxTextF
		INVOKE setCombobox, hComboboxCharcolor, 7
		INVOKE CreateWindowEx, NULL, OFFSET szComboboxClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + WS_VSCROLL + CBS_DROPDOWNLIST, 
			585, 400, 100, 300, hWnd, IDC_COMBOBOX_PLAYSPEED, hInstance, NULL
		mov hComboboxPlayspeed, eax
		INVOKE addCombobox, hComboboxPlayspeed, ADDR szComboboxText10
		INVOKE addCombobox, hComboboxPlayspeed, ADDR szComboboxText11
		INVOKE addCombobox, hComboboxPlayspeed, ADDR szComboboxText12
		INVOKE addCombobox, hComboboxPlayspeed, ADDR szComboboxText13
		INVOKE addCombobox, hComboboxPlayspeed, ADDR szComboboxText14
		INVOKE setCombobox, hComboboxPlayspeed, 0
		; ���ؿ���̨
		INVOKE GetConsoleWindow
        INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW
		; ���ͳ�ʼ��Ϣ
		INVOKE addEdit, hEditInfo, ADDR szInfoInit
        jmp WinProcExit
	; --- ���ٴ�����Ϣ ---
    .ELSEIF eax == WM_DESTROY
        INVOKE PostQuitMessage, 0
		INVOKE crt_system, ADDR clearScreenCmd
		INVOKE GetConsoleWindow
        INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW 
		INVOKE clearFolder ; �Ƚ�frames�ļ��е���ʱͼƬ���
		INVOKE crt_exit
        jmp WinProcExit
	; --- �˵�/�ؼ�/��ݼ���Ϣ ---
	.ELSEIF eax == WM_COMMAND
		mov eax,wParam
		.IF ax == IDB_BUTTON_SELECT_1
			; ���� ѡ��ťһ
			INVOKE addEdit, hEditInfo, ADDR szInfoSelectBegin
			INVOKE getOpenFile, ADDR szFilterMp4						; �����ļ�ѡ�� - szBuffer
			INVOKE setEdit, hEditFilename1, ADDR szBuffer
			mov al, BYTE PTR szBuffer
			.IF al == 0 ; û��ѡ���κ��ļ�
			    INVOKE addEdit, hEditInfo, ADDR szInfoNoDirectorySelected
			.ELSE
			    INVOKE crt_strcpy,  ADDR szBuffer, ADDR szNull
			    INVOKE addEdit, hEditInfo, ADDR szInfoSelectEnd
			.ENDIF
		.ELSEIF ax == IDB_BUTTON_SELECT_2
			; ���� ѡ��ť��
			INVOKE addEdit, hEditInfo, ADDR szInfoSelectBegin
			INVOKE getOpenFile, ADDR szFilterApple							; �����ļ�ѡ�� - szBuffer
			INVOKE setEdit, hEditFilename2, ADDR szBuffer
			mov al, BYTE PTR szBuffer
			.IF al == 0 ; û��ѡ���κ��ļ�
			    INVOKE addEdit, hEditInfo, ADDR szInfoNoDirectorySelected
			.ELSE
			    INVOKE crt_strcpy,  ADDR szBuffer, ADDR szNull
			    INVOKE addEdit, hEditInfo, ADDR szInfoSelectEnd
			.ENDIF
		.ELSEIF ax == IDB_BUTTON_MAKE
			; ���� ���ɰ�ť
			INVOKE getRadioButtonFPSChoice									; ��ȡ����֡��ѡ�� - nFPSChoice
			INVOKE getRadioButtonnMakeModeChoice							; ��ȡ����ģʽѡ�� - nMakeModeChoice
			INVOKE getEdit, hEditFilename1, BUFFER_LENGTH, ADDR szBuffer2	; ��ȡ�ļ��� - szBuffer
			mov al, BYTE PTR szBuffer2
			.IF al == 0 ; û��ѡ���κ��ļ�
			    INVOKE addEdit, hEditInfo, ADDR szInfoNoDirectorySelected
			.ELSEIF isWorking == 0
			    INVOKE addEdit, hEditInfo, ADDR szInfoMakeBegin
                mov eax, startMake
			    INVOKE CreateThread, NULL, NULL, eax, 0, 0, 0
			.ELSE
			    INVOKE addEdit, hEditInfo, ADDR szInfoIsWorking
			.ENDIF
		.ELSEIF ax == IDB_BUTTON_PLAY
			; ���� ���Ű�ť
			INVOKE getCombobox, hComboboxBackcolor, ADDR nBackcolorChoice	; ��ȡ������ɫѡ�� - nBackcolorChoice
			INVOKE getCombobox, hComboboxCharcolor, ADDR nCharcolorChoice	; ��ȡ�ַ���ɫѡ�� - nCharcolorChoice
			INVOKE getCombobox, hComboboxPlayspeed, ADDR nSpeedChoice		; ��ȡ�����ٶ�ѡ�� - nSpeedChoice
			INVOKE getEdit, hEditFilename2, BUFFER_LENGTH, ADDR szBuffer2	; ��ȡ�ļ��� - szBuffer
			mov al, BYTE PTR szBuffer2
			.IF al == 0 ; û��ѡ���κ��ļ�
			    INVOKE addEdit, hEditInfo, ADDR szInfoNoDirectorySelected
			.ELSEIF isWorking == 0
			    INVOKE addEdit, hEditInfo, ADDR szInfoPlayBegin
			    mov eax, startPlay
			    INVOKE CreateThread, NULL, NULL, eax, 0, 0, 0
			.ELSE
			    INVOKE addEdit, hEditInfo, ADDR szInfoIsWorking
			.ENDIF
		.ELSEIF (ax == IDB_BUTTON_STOP_1 || ax == IDB_BUTTON_STOP_2)
			.IF isWorking == 0
			    ;INVOKE addEdit, hEditInfo, ADDR szInfoPlayBegin
			.ELSE
			    INVOKE stopProcess
			.ENDIF

ContinueWinProc:
		.ENDIF
		jmp WinProcExit
	; --- ������Ϣ ---
    .ELSE
		INVOKE DefWindowProc, hWnd, localMsg, wParam, lParam
        jmp WinProcExit
    .ENDIF
WinProcExit:
    ret
WinProc ENDP


;---------------------------------------------------
ErrorHandler PROC
; ��ʾ���ʵ�ϵͳ������Ϣ
;---------------------------------------------------
.data
pErrorMsg  DWORD ?         ; ������Ϣָ��
messageID  DWORD ?
ErrorTitle  BYTE "Error", 0
.code
    INVOKE GetLastError    ; ��EAX������ϢID
    mov messageID, eax
    ; ��ȡ��Ӧ����Ϣ�ַ���
    INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + \
      FORMAT_MESSAGE_FROM_SYSTEM, NULL, messageID, NULL,
      ADDR pErrorMsg, NULL, NULL
    ; ��ʾ������Ϣ
    INVOKE MessageBox, NULL, pErrorMsg, ADDR ErrorTitle, MB_ICONERROR+MB_OK
    ; �ͷŴ�����Ϣ�ַ���
    INVOKE LocalFree, pErrorMsg
    ret
ErrorHandler ENDP


;---------------------------------------------------
ButtonTest PROC hWnd:HWND
; ��ť����
;---------------------------------------------------
	INVOKE MessageBox, hWnd, ADDR szTest, ADDR szWinText, MB_OK
	INVOKE addEdit, hEditInfo, ADDR szTest
	INVOKE SendMessage, hWnd, CB_ADDSTRING, NULL, ADDR szTest
	INVOKE getRadioButtonFPSChoice
	ret
ButtonTest ENDP


;---------------------------------------------------
syncWorkDir PROC
; ͬ������·��  szWorkDir: ������·��
;---------------------------------------------------
	INVOKE crt__chdir, ADDR szWorkDir
	ret
syncWorkDir ENDP


;---------------------------------------------------
getOpenFile PROC szFilter:PTR BYTE
; ���ļ��Ի���  szBuffer: �洢�ļ���
;---------------------------------------------------
	mov openFile.lStructSize, SIZEOF OPENFILENAME
	push hMainWnd
	pop openFile.hwndOwner
	push szFilter
	pop openFile.lpstrFilter
	mov openFile.lpstrFile, OFFSET szBuffer
	mov openFile.nMaxFile, BUFFER_LENGTH
	mov openFile.Flags, OFN_PATHMUSTEXIST or OFN_FILEMUSTEXIST
	INVOKE GetOpenFileName, ADDR openFile
	ret
getOpenFile ENDP


;---------------------------------------------------
checkRadioButton PROC hRadioButton:DWORD
; ��ⵥѡ��״̬  hButton: ��ѡ���� eax: �Ƿ�ѡ�� 
;---------------------------------------------------
	INVOKE SendMessage, hRadioButton, BM_GETCHECK, 0, 0
	.IF eax == BST_CHECKED
		mov eax, TRUE
	.ELSE
		mov eax, FALSE
	.ENDIF
	ret
checkRadioButton ENDP


;---------------------------------------------------
setEdit PROC hEdit:DWORD, szText:PTR BYTE
; ���ñ༭���ı�  hEdit: �༭����  szText: �ı�ָ��
;---------------------------------------------------
	INVOKE SendMessage, hEdit, WM_SETTEXT, NULL, szText
	ret
setEdit ENDP


;---------------------------------------------------
getEdit PROC hEdit:DWORD, nLength:DWORD, szText:PTR BYTE
; ��ȡ�༭���ı�  hEdit: �༭����  nLength: �ı���С szText: �ı�ָ��
;---------------------------------------------------
	INVOKE SendMessage, hEdit, WM_GETTEXT, nLength, szText
	ret
getEdit ENDP


;---------------------------------------------------
addEdit PROC hEdit:DWORD, szText:PTR BYTE
; ��ӱ༭���ı�����Ϣ�����  hEdit: �༭����  szText: �ı�ָ��
;---------------------------------------------------
	INVOKE crt_strlen, ADDR szInformation
	.IF eax > INFORMATION_BORDER
		INVOKE crt_strcpy, ADDR szInformation, ADDR szNull
	.ELSEIF eax > 0
		INVOKE crt_strcat, ADDR szInformation, ADDR szNewLine
	.ENDIF
	INVOKE crt_strcat, ADDR szInformation, szText
	INVOKE SendMessage, hEdit, WM_SETTEXT, NULL, ADDR szInformation
	ret
addEdit ENDP


;---------------------------------------------------
setCombobox PROC hCombobox:DWORD, nIndex:DWORD
; ������Ͽ�ѡ��  hCombobox: ��Ͽ���  nIndex: ѡ������
;---------------------------------------------------
	INVOKE SendMessage, hCombobox, CB_SETCURSEL, nIndex, NULL
	ret
setCombobox ENDP


;---------------------------------------------------
getCombobox PROC hCombobox:DWORD, nIndex:PTR DWORD
; ��ȡ��Ͽ�ѡ��  hCombobox: ��Ͽ���  eax: ѡ������
	INVOKE SendMessage, hCombobox, CB_GETCURSEL, NULL, NULL
	.IF eax == CB_ERR
		mov eax, 0
	.ENDIF
	mov ebx, nIndex
	mov [ebx], eax
	ret
getCombobox ENDP


;---------------------------------------------------
addCombobox PROC hCombobox:DWORD, szText:PTR BYTE
; �����Ͽ�ѡ��  hCombobox: ��Ͽ���  szText: �ı�ָ��
;---------------------------------------------------
	INVOKE SendMessage, hCombobox, CB_ADDSTRING, NULL, szText
	ret
addCombobox ENDP


;---------------------------------------------------
getRadioButtonFPSChoice PROC
; ��ȡ����֡�ʵ�ѡ��ѡ��  nFPSChoice: ȫ��
;---------------------------------------------------
	INVOKE checkRadioButton, hRadioButton1
	.IF eax == TRUE
		mov nFPSChoice, 0
		ret
	.ENDIF
	INVOKE checkRadioButton, hRadioButton2
	.IF eax == TRUE
		mov nFPSChoice, 1
		ret
	.ENDIF
	INVOKE checkRadioButton, hRadioButton3
	.IF eax == TRUE
		mov nFPSChoice, 2
		ret
	.ENDIF
	mov nFPSChoice, 0
	ret
getRadioButtonFPSChoice ENDP


;---------------------------------------------------
getRadioButtonnMakeModeChoice PROC
; ��ȡ֡�ʵ�ѡ��ѡ��  nMakeModeChoice: ȫ��
;---------------------------------------------------
	INVOKE checkRadioButton, hRadioButton4
	.IF eax == TRUE
		mov nMakeModeChoice, 0
		ret
	.ENDIF
	INVOKE checkRadioButton, hRadioButton5
	.IF eax == TRUE
		mov nMakeModeChoice, 1
		ret
	.ENDIF
	mov nMakeModeChoice, 0
	ret
getRadioButtonnMakeModeChoice ENDP

END WinMain