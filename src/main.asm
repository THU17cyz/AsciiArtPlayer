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

szFilterAll		   BYTE "媒体文件（所有文件）", 0, "*.*", 0, 0
szFilterMp4	   BYTE "MP4文件.mp4", 0, "*.mp4", 0, 0
szFilterApple	   BYTE "字符动画文件.apple", 0, "*.apple", 0, 0

szWinText		   BYTE "字符动画", 0
szGroupboxMakeText BYTE "字符动画生成", 0
szGroupboxPlayText BYTE "字符动画播放", 0
szButtonSelectText BYTE "选择", 0
szButtonMakeText   BYTE "生成", 0
szButtonPlayText   BYTE "播放", 0
szButtonStopText   BYTE "停止", 0
szRadioButtonText1 BYTE "FPS: 10", 0
szRadioButtonText2 BYTE "FPS: 20", 0
szRadioButtonText3 BYTE "FPS: 30", 0
szRadioButtonText4 BYTE "仅进行生成", 0
szRadioButtonText5 BYTE "生成并播放", 0

szStaticText1	   BYTE "背景颜色", 0
szStaticText2	   BYTE "字符颜色", 0
szStaticText3	   BYTE "播放倍速", 0
szComboboxText0	   BYTE "黑色", 0
szComboboxText1	   BYTE "蓝色", 0
szComboboxText2	   BYTE "绿色", 0
szComboboxText3	   BYTE "浅绿色", 0
szComboboxText4	   BYTE "红色", 0
szComboboxText5	   BYTE "紫色", 0
szComboboxText6	   BYTE "黄色", 0
szComboboxText7	   BYTE "白色", 0
szComboboxText8	   BYTE "灰色", 0
szComboboxText9	   BYTE "淡蓝色", 0
szComboboxTextA	   BYTE "淡绿色", 0
szComboboxTextB	   BYTE "淡浅绿色", 0
szComboboxTextC	   BYTE "淡红色", 0
szComboboxTextD	   BYTE "淡紫色", 0
szComboboxTextE	   BYTE "淡黄色", 0
szComboboxTextF	   BYTE "亮白色", 0
szComboboxText10   BYTE "1.0 倍速", 0
szComboboxText11   BYTE "0.25 倍速", 0
szComboboxText12   BYTE "0.5 倍速", 0
szComboboxText13   BYTE "2.0 倍速", 0
szComboboxText14   BYTE "4.0 倍速", 0


szInfoInit					BYTE "【信息】程序初始化完毕", 0
szInfoSelectBegin			BYTE "【信息】正在选择文件...", 0
szInfoSelectEnd				BYTE "【成功】文件选择成功！", 0
szInfoMakeBegin				BYTE "【信息】正在生成字符动画...", 0
szInfoMakeError				BYTE "【信息】生成字符动画出错！", 0
szInfoMakeEnd				BYTE "【成功】生成字符动画成功！", 0
szInfoPlayBegin				BYTE "【信息】正在播放字符动画...", 0
szInfoPlayError				BYTE "【信息】播放字符动画出错！", 0
szInfoPlayEnd				BYTE "【成功】播放字符动画完毕！", 0
szInfoStopped				BYTE "【信息】当前操作终止！", 0
szInfoIsWorking				BYTE "【信息】播放/生成时不能进行其他操作！", 0
szInfoNoDirectorySelected   BYTE "【信息】没有选中任何文件！", 0


szTest			   BYTE "测试", 0


;==================== DATA =======================
.data
; --- 窗口类结构体定义 ---
MainWin WNDCLASS <>			; 主窗口类

; --- 消息类结构体定义 ---
msg   MSG <>				; 消息变量

; --- 文件打开结构体定义 ---
openFile OPENFILENAME <>	; 文件打开变量

; --- 其他结构体定义 ---
initCtrls INITCOMMONCONTROLSEX <>
rect RECT <>


; --- 句柄定义 ---块句柄
hInstance			DWORD ?		; 当前模块句柄
hMainWnd			DWORD ?		; 主窗口句柄
hStdOut				DWORD ?		; 标准输出控制台局部

hGroupboxMake		DWORD ?		; 生成区分组框句柄
hGroupboxPlay		DWORD ?		; 播放区分组框句柄

hButtonSelect1		DWORD ?		; 选择按钮一句柄
hButtonSelect2		DWORD ?		; 选择按钮二句柄
hButtonMake			DWORD ?		; 生成按钮句柄
hButtonPlay			DWORD ?		; 制作按钮句柄
hButtonStop1		DWORD ?		; 停止按钮一句柄
hButtonStop2		DWORD ?		; 停止按钮二句柄


hRadioButton1		DWORD ?		; 单选框一句柄
hRadioButton2		DWORD ?		; 单选框二句柄
hRadioButton3		DWORD ?		; 单选框三句柄
hRadioButton4		DWORD ?		; 单选框四句柄
hRadioButton5		DWORD ?		; 单选框五句柄


hEditInfo			DWORD ?		; 信息输出框句柄
hEditFilename1		DWORD ?		; 文件名编辑框一句柄
hEditFilename2		DWORD ?		; 文件名编辑框二句柄

hStatic1		    DWORD ?		; 静态框一句柄
hStatic2			DWORD ?		; 静态框二句柄
hStatic3			DWORD ?		; 静态框三句柄

hComboboxBackcolor	DWORD ?		; 背景颜色组合框
hComboboxCharcolor	DWORD ?		; 字符颜色组合框
hComboboxPlayspeed	DWORD ?		; 播放倍率组合框

; --- 整型变量定义 ---
nFPSChoice       DWORD ?	; 动画帧率选项
nMakeModeChoice	 DWORD ?	; 播放模式选项
nBackcolorChoice DWORD ?	; 背景颜色选项
nCharcolorChoice DWORD ?	; 字符颜色选项
nSpeedChoice DWORD ?		; 播放速度选项

; --- 字符串变量定义 ---
szBuffer		BYTE BUFFER_LENGTH DUP(0)			; 缓存字符串
szBuffer2		BYTE BUFFER_LENGTH DUP(0)			; 缓存字符串2, 为了避免两个文件选择框互相干扰
szInformation	BYTE INFORMATION_LENGTH DUP(0)		; 信息字符串
szWorkDir		BYTE BUFFER_LENGTH DUP(0)			; 工作路径

; 是否正在操作
isWorking DWORD 0

clearScreenCmd BYTE "cls", 0


;=================== CODE =========================
.code

; ---控制台关闭事件 ---
onConsoleClose PROC, ctrlType: DWORD
    .IF ctrlType == 2 || ctrlType == 1 || ctrlType == 0
	    INVOKE clearFolder ; 先将frames文件夹的临时图片清空
	.ENDIF
	ret
onConsoleClose ENDP


; ---开始生成 ---
startMake PROC
    mov eax, 1
	mov isWorking, eax
    INVOKE syncWorkDir
	INVOKE clearFolder ; 先将frames文件夹的临时图片清空
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


; ---开始播放 ---
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
	; 初始化通用控件
	mov initCtrls.dwSize, SIZEOF initCtrls
	mov initCtrls.dwICC, ICC_WIN95_CLASSES
	INVOKE InitCommonControlsEx, ADDR initCtrls
	; 获取工作路径
	INVOKE crt__getcwd, ADDR szWorkDir, BUFFER_LENGTH
	; 设置控制台属性
	INVOKE GetConsoleWindow			; 获取控制台句柄
	mov hStdOut, eax
	INVOKE SetConsoleTitle, ADDR szWinText
	INVOKE GetWindowRect, hStdOut, ADDR rect
	INVOKE GetWindowLong, hStdOut, GWL_STYLE
	mov ebx, WS_SIZEBOX
	neg ebx
	and eax, ebx
	INVOKE SetWindowLong, hStdOut, GWL_STYLE, eax
	INVOKE SetConsoleCtrlHandler, OFFSET onConsoleClose, 1
	; 设置窗口类属性
	mov MainWin.style, CS_HREDRAW or CS_VREDRAW		; 设置 窗口样式
	mov MainWin.lpfnWndProc, OFFSET WinProc			; 设置 WinProc 函数指针
	mov MainWin.cbClsExtra, NULL					; 设置 共享内存
    mov MainWin.cbWndExtra, NULL					; 设置 附加字节数
	INVOKE GetModuleHandle, NULL					; 获取当前模块句柄
    mov hInstance, eax
	mov MainWin.hInstance, eax						; 设置 当前程序句柄
    INVOKE LoadIcon, NULL, IDI_APPLICATION
    mov MainWin.hIcon, eax							; 设置 图标句柄
    INVOKE LoadCursor, NULL, IDC_ARROW
    mov MainWin.hCursor, eax						; 设置 光标句柄
	mov MainWin.hbrBackground, COLOR_APPWORKSPACE	; 设置 背景刷句柄
	mov MainWin.lpszMenuName,NULL					; 设置 菜单名句柄
	mov MainWin.lpszClassName, OFFSET szWinClass	; 设置 WinClass 名句柄
	; 注册窗口类
    INVOKE RegisterClass, ADDR MainWin
    .IF eax == 0
		call ErrorHandler
		jmp Exit_Program
    .ENDIF
	; 创建窗口类
    INVOKE CreateWindowEx, NULL, ADDR szWinClass, ADDR szWinText,
		WS_VISIBLE + WS_CAPTION + WS_SYSMENU + WS_MINIMIZEBOX,
		CW_USEDEFAULT, CW_USEDEFAULT, MAINWIN_WIDTH, MAINWIN_HEIGHT, NULL, NULL, hInstance, NULL
    mov hMainWnd, eax
    .IF eax == 0
		call ErrorHandler
		jmp  Exit_Program
    .ENDIF
	; 显示窗口类
    INVOKE ShowWindow, hMainWnd, SW_SHOW
    INVOKE UpdateWindow, hMainWnd
	; 消息循环
Message_Loop:
    ; 从队列中取出下一条消息
    INVOKE GetMessage, ADDR msg, NULL, NULL, NULL
    .IF eax == 0
		jmp Exit_Program
	.ENDIF
    ; 将消息传递给程序的 WinProc
	invoke TranslateMessage, ADDR msg
    INVOKE DispatchMessage, ADDR msg
    jmp Message_Loop
; 程序退出
Exit_Program:
      INVOKE ExitProcess,0
WinMain ENDP

;-----------------------------------------------------
WinProc PROC,
    hWnd:HWND, localMsg:UINT, wParam:WPARAM, lParam:LPARAM
; 应用程序的消息处理过程，处理应用程序特定的消息。
; 其他所有消息则传递给默认的 windows 消息处理过程
;-----------------------------------------------------
    mov eax, localMsg
	; --- 创建窗口消息 ---
    .IF eax == WM_CREATE
		; 创建分组框控件
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szGroupboxMakeText, WS_CHILD + WS_VISIBLE + BS_GROUPBOX,
			50, 180, 700, 150, hWnd, IDB_GROUPBOX_MAKE, hInstance, NULL
		mov hGroupboxMake, eax
		INVOKE CreateWindowEx, NULL, OFFSET szButtonClass, OFFSET szGroupboxPlayText, WS_CHILD + WS_VISIBLE + BS_GROUPBOX,
			50, 350, 700, 150, hWnd, IDB_GROUPBOX_PLAY, hInstance, NULL
		mov hGroupboxPlay, eax
		; 创建按钮控件
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
		; 创建单选框控件
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
		; 创建文本框控件
		INVOKE CreateWindowEx, NULL, OFFSET szEditClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_MULTILINE + ES_READONLY + WS_VSCROLL, 
			50, 30, 700, 130, hWnd, IDE_EDIT_INFO, hInstance, NULL
		mov hEditInfo, eax
		INVOKE CreateWindowEx, NULL, OFFSET szEditClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_AUTOHSCROLL, 
			100, 280, 380, 30, hWnd, IDE_EDIT_FILENAME_1, hInstance, NULL
		mov hEditFilename1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szEditClass, NULL, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_AUTOHSCROLL, 
			100, 450, 380, 30, hWnd, IDE_EDIT_FILENAME_2, hInstance, NULL
		mov hEditFilename2, eax
		; 创建静态框控件
		INVOKE CreateWindowEx, NULL, OFFSET szStaticClass, OFFSET szStaticText1, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_CENTER, 
			115, 400, 70, 24, hWnd, IDS_STATIC_1, hInstance, NULL
		mov hStatic1, eax
		INVOKE CreateWindowEx, NULL, OFFSET szStaticClass, OFFSET szStaticText2, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_CENTER, 
			315, 400, 70, 24, hWnd, IDS_STATIC_2, hInstance, NULL
		mov hStatic2, eax
		INVOKE CreateWindowEx, NULL, OFFSET szStaticClass, OFFSET szStaticText3, WS_CHILD + WS_VISIBLE + WS_BORDER + ES_CENTER, 
			515, 400, 70, 24, hWnd, IDS_STATIC_3, hInstance, NULL
		mov hStatic3, eax
		; 创建组合框控件
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
		; 隐藏控制台
		INVOKE GetConsoleWindow
        INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW
		; 发送初始信息
		INVOKE addEdit, hEditInfo, ADDR szInfoInit
        jmp WinProcExit
	; --- 销毁窗口消息 ---
    .ELSEIF eax == WM_DESTROY
        INVOKE PostQuitMessage, 0
		INVOKE crt_system, ADDR clearScreenCmd
		INVOKE GetConsoleWindow
        INVOKE SetWindowPos,eax, HWND_TOP, 0, 0, 0, 0, SWP_HIDEWINDOW 
		INVOKE clearFolder ; 先将frames文件夹的临时图片清空
		INVOKE crt_exit
        jmp WinProcExit
	; --- 菜单/控件/快捷键消息 ---
	.ELSEIF eax == WM_COMMAND
		mov eax,wParam
		.IF ax == IDB_BUTTON_SELECT_1
			; 按下 选择按钮一
			INVOKE addEdit, hEditInfo, ADDR szInfoSelectBegin
			INVOKE getOpenFile, ADDR szFilterMp4						; 进行文件选择 - szBuffer
			INVOKE setEdit, hEditFilename1, ADDR szBuffer
			mov al, BYTE PTR szBuffer
			.IF al == 0 ; 没有选中任何文件
			    INVOKE addEdit, hEditInfo, ADDR szInfoNoDirectorySelected
			.ELSE
			    INVOKE crt_strcpy,  ADDR szBuffer, ADDR szNull
			    INVOKE addEdit, hEditInfo, ADDR szInfoSelectEnd
			.ENDIF
		.ELSEIF ax == IDB_BUTTON_SELECT_2
			; 按下 选择按钮二
			INVOKE addEdit, hEditInfo, ADDR szInfoSelectBegin
			INVOKE getOpenFile, ADDR szFilterApple							; 进行文件选择 - szBuffer
			INVOKE setEdit, hEditFilename2, ADDR szBuffer
			mov al, BYTE PTR szBuffer
			.IF al == 0 ; 没有选中任何文件
			    INVOKE addEdit, hEditInfo, ADDR szInfoNoDirectorySelected
			.ELSE
			    INVOKE crt_strcpy,  ADDR szBuffer, ADDR szNull
			    INVOKE addEdit, hEditInfo, ADDR szInfoSelectEnd
			.ENDIF
		.ELSEIF ax == IDB_BUTTON_MAKE
			; 按下 生成按钮
			INVOKE getRadioButtonFPSChoice									; 获取动画帧率选项 - nFPSChoice
			INVOKE getRadioButtonnMakeModeChoice							; 获取生成模式选项 - nMakeModeChoice
			INVOKE getEdit, hEditFilename1, BUFFER_LENGTH, ADDR szBuffer2	; 获取文件名 - szBuffer
			mov al, BYTE PTR szBuffer2
			.IF al == 0 ; 没有选中任何文件
			    INVOKE addEdit, hEditInfo, ADDR szInfoNoDirectorySelected
			.ELSEIF isWorking == 0
			    INVOKE addEdit, hEditInfo, ADDR szInfoMakeBegin
                mov eax, startMake
			    INVOKE CreateThread, NULL, NULL, eax, 0, 0, 0
			.ELSE
			    INVOKE addEdit, hEditInfo, ADDR szInfoIsWorking
			.ENDIF
		.ELSEIF ax == IDB_BUTTON_PLAY
			; 按下 播放按钮
			INVOKE getCombobox, hComboboxBackcolor, ADDR nBackcolorChoice	; 获取背景颜色选项 - nBackcolorChoice
			INVOKE getCombobox, hComboboxCharcolor, ADDR nCharcolorChoice	; 获取字符颜色选项 - nCharcolorChoice
			INVOKE getCombobox, hComboboxPlayspeed, ADDR nSpeedChoice		; 获取播放速度选项 - nSpeedChoice
			INVOKE getEdit, hEditFilename2, BUFFER_LENGTH, ADDR szBuffer2	; 获取文件名 - szBuffer
			mov al, BYTE PTR szBuffer2
			.IF al == 0 ; 没有选中任何文件
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
	; --- 其他消息 ---
    .ELSE
		INVOKE DefWindowProc, hWnd, localMsg, wParam, lParam
        jmp WinProcExit
    .ENDIF
WinProcExit:
    ret
WinProc ENDP


;---------------------------------------------------
ErrorHandler PROC
; 显示合适的系统错误消息
;---------------------------------------------------
.data
pErrorMsg  DWORD ?         ; 错误消息指针
messageID  DWORD ?
ErrorTitle  BYTE "Error", 0
.code
    INVOKE GetLastError    ; 用EAX返回消息ID
    mov messageID, eax
    ; 获取相应的消息字符串
    INVOKE FormatMessage, FORMAT_MESSAGE_ALLOCATE_BUFFER + \
      FORMAT_MESSAGE_FROM_SYSTEM, NULL, messageID, NULL,
      ADDR pErrorMsg, NULL, NULL
    ; 显示错误消息
    INVOKE MessageBox, NULL, pErrorMsg, ADDR ErrorTitle, MB_ICONERROR+MB_OK
    ; 释放错误消息字符串
    INVOKE LocalFree, pErrorMsg
    ret
ErrorHandler ENDP


;---------------------------------------------------
ButtonTest PROC hWnd:HWND
; 按钮测试
;---------------------------------------------------
	INVOKE MessageBox, hWnd, ADDR szTest, ADDR szWinText, MB_OK
	INVOKE addEdit, hEditInfo, ADDR szTest
	INVOKE SendMessage, hWnd, CB_ADDSTRING, NULL, ADDR szTest
	INVOKE getRadioButtonFPSChoice
	ret
ButtonTest ENDP


;---------------------------------------------------
syncWorkDir PROC
; 同步工作路径  szWorkDir: 程序工作路径
;---------------------------------------------------
	INVOKE crt__chdir, ADDR szWorkDir
	ret
syncWorkDir ENDP


;---------------------------------------------------
getOpenFile PROC szFilter:PTR BYTE
; 打开文件对话框  szBuffer: 存储文件名
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
; 检测单选框状态  hButton: 单选框句柄 eax: 是否选中 
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
; 设置编辑框文本  hEdit: 编辑框句柄  szText: 文本指针
;---------------------------------------------------
	INVOKE SendMessage, hEdit, WM_SETTEXT, NULL, szText
	ret
setEdit ENDP


;---------------------------------------------------
getEdit PROC hEdit:DWORD, nLength:DWORD, szText:PTR BYTE
; 获取编辑框文本  hEdit: 编辑框句柄  nLength: 文本大小 szText: 文本指针
;---------------------------------------------------
	INVOKE SendMessage, hEdit, WM_GETTEXT, nLength, szText
	ret
getEdit ENDP


;---------------------------------------------------
addEdit PROC hEdit:DWORD, szText:PTR BYTE
; 添加编辑框文本（信息输出框）  hEdit: 编辑框句柄  szText: 文本指针
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
; 设置组合框选项  hCombobox: 组合框句柄  nIndex: 选项索引
;---------------------------------------------------
	INVOKE SendMessage, hCombobox, CB_SETCURSEL, nIndex, NULL
	ret
setCombobox ENDP


;---------------------------------------------------
getCombobox PROC hCombobox:DWORD, nIndex:PTR DWORD
; 获取组合框选项  hCombobox: 组合框句柄  eax: 选项索引
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
; 添加组合框选项  hCombobox: 组合框句柄  szText: 文本指针
;---------------------------------------------------
	INVOKE SendMessage, hCombobox, CB_ADDSTRING, NULL, szText
	ret
addCombobox ENDP


;---------------------------------------------------
getRadioButtonFPSChoice PROC
; 获取动画帧率单选框选项  nFPSChoice: 全局
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
; 获取帧率单选框选项  nMakeModeChoice: 全局
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