;;;; 窗口头文件


; --------------------
; 结构体定义
; --------------------
;; 点结构体
;POINT STRUCT
  ;X   DWORD ?
  ;Y   DWORD ?
;POINT ENDS
;
;; 矩形结构体
;RECT STRUCT
  ;left      DWORD ?
  ;top       DWORD ?
  ;right     DWORD ?
  ;bottom    DWORD ?
;RECT ENDS
;
;; 窗口类结构体
;WNDCLASS STRUC
  ;style           DWORD ?		; 窗口样式选项
  ;lpfnWndProc     DWORD ?		; WinProc 函数指针
  ;cbClsExtra      DWORD ?		; 共享内存
  ;cbWndExtra      DWORD ?		; 附加字节数
  ;hInstance       DWORD ?		; 当前程序句柄
  ;hIcon           DWORD ?		; 图标句柄
  ;hCursor         DWORD ?		; 光标句柄
  ;hbrBackground   DWORD ?		; 背景刷句柄
  ;lpszMenuName    DWORD ?		; 菜单名句柄
  ;lpszClassName   DWORD ?		; WinClass 名句柄
;WNDCLASS ENDS
;
;; 消息类结构体
;MSG STRUCT
  ;msgWnd        DWORD ?
  ;msgMessage    DWORD ?
  ;msgWparam     DWORD ?
  ;msgLparam     DWORD ?
  ;msgTime       DWORD ?
  ;msgPt         POINT <>
;MSGCLASS ENDS

; --------------------
; 宏定义
; --------------------
; 常量定义
NULL EQU 0
endl EQU <0dh,0ah>
MAINWIN_WIDTH = 800
MAINWIN_HEIGHT = 600

BUFFER_LENGTH = 1024
INFORMATION_LENGTH = 8192
INFORMATION_BORDER = 150

; 控件ID定义
IDB_GROUPBOX_MAKE		= 1001		; 生成区分组框
IDB_GROUPBOX_PLAY		= 1002		; 播放区分组框

IDB_BUTTON_SELECT_1		= 1101		; 选择按钮一
IDB_BUTTON_SELECT_2		= 1102		; 选择按钮二
IDB_BUTTON_MAKE			= 1103		; 生成按钮
IDB_BUTTON_PLAY			= 1104		; 制作按钮
IDB_BUTTON_STOP_1       = 1105		; 停止按钮一
IDB_BUTTON_STOP_2		= 1106		; 停止按钮二


IDB_RADIOBUTTON_1		= 1201		; 单选框一
IDB_RADIOBUTTON_2		= 1202		; 单选框二
IDB_RADIOBUTTON_3		= 1203		; 单选框三
IDB_RADIOBUTTON_4		= 1204		; 单选框四
IDB_RADIOBUTTON_5		= 1205		; 单选框五



IDE_EDIT_INFO			= 2000		; 信息输出框
IDE_EDIT_FILENAME_1		= 2001		; 文件名编辑框一
IDE_EDIT_FILENAME_2		= 2002		; 文件名编辑框二

IDS_STATIC_1			= 3001		; 静态框一
IDS_STATIC_2			= 3002		; 静态框二
IDS_STATIC_3			= 3003		; 静态框三

IDC_COMBOBOX_BACKCOLOR	= 4001		; 背景颜色组合框
IDC_COMBOBOX_CHARCOLOR	= 4002		; 字符颜色组合框
IDC_COMBOBOX_PLAYSPEED  = 4003		; 播放倍速

; --------------------
; 过程声明
; --------------------
ButtonTest PROTO hWnd:HWND


syncWorkDir PROTO												; 同步工作路径过程
getOpenFile PROTO szFilter:PTR BYTE								; 打开文件对话框过程
checkRadioButton PROTO hRadioButton:DWORD						; 检测单选框状态过程
setEdit PROTO hEdit:DWORD, szText:PTR BYTE						; 设置编辑框文本过程
getEdit PROTO hEdit:DWORD, nLength:DWORD, szText:PTR BYTE		; 获取编辑框文本过程
addEdit PROTO hEdit:DWORD, szText:PTR BYTE						; 添加编辑框文本过程
setCombobox PROTO hCombobox:DWORD, nIndex:DWORD					; 设置组合框选项过程
getCombobox PROTO hCombobox:DWORD, nIndex:PTR DWORD				; 获取组合框选项过程
addCombobox PROTO hCombobox:DWORD, szText:PTR BYTE				; 添加组合框选项过程

getRadioButtonFPSChoice PROTO									; 获取动画帧率单选框选项过程
getRadioButtonnMakeModeChoice PROTO								; 获取生成模式单选框选项过程


