;;;; ����ͷ�ļ�


; --------------------
; �ṹ�嶨��
; --------------------
;; ��ṹ��
;POINT STRUCT
  ;X   DWORD ?
  ;Y   DWORD ?
;POINT ENDS
;
;; ���νṹ��
;RECT STRUCT
  ;left      DWORD ?
  ;top       DWORD ?
  ;right     DWORD ?
  ;bottom    DWORD ?
;RECT ENDS
;
;; ������ṹ��
;WNDCLASS STRUC
  ;style           DWORD ?		; ������ʽѡ��
  ;lpfnWndProc     DWORD ?		; WinProc ����ָ��
  ;cbClsExtra      DWORD ?		; �����ڴ�
  ;cbWndExtra      DWORD ?		; �����ֽ���
  ;hInstance       DWORD ?		; ��ǰ������
  ;hIcon           DWORD ?		; ͼ����
  ;hCursor         DWORD ?		; �����
  ;hbrBackground   DWORD ?		; ����ˢ���
  ;lpszMenuName    DWORD ?		; �˵������
  ;lpszClassName   DWORD ?		; WinClass �����
;WNDCLASS ENDS
;
;; ��Ϣ��ṹ��
;MSG STRUCT
  ;msgWnd        DWORD ?
  ;msgMessage    DWORD ?
  ;msgWparam     DWORD ?
  ;msgLparam     DWORD ?
  ;msgTime       DWORD ?
  ;msgPt         POINT <>
;MSGCLASS ENDS

; --------------------
; �궨��
; --------------------
; ��������
NULL EQU 0
endl EQU <0dh,0ah>
MAINWIN_WIDTH = 800
MAINWIN_HEIGHT = 600

BUFFER_LENGTH = 1024
INFORMATION_LENGTH = 8192
INFORMATION_BORDER = 150

; �ؼ�ID����
IDB_GROUPBOX_MAKE		= 1001		; �����������
IDB_GROUPBOX_PLAY		= 1002		; �����������

IDB_BUTTON_SELECT_1		= 1101		; ѡ��ťһ
IDB_BUTTON_SELECT_2		= 1102		; ѡ��ť��
IDB_BUTTON_MAKE			= 1103		; ���ɰ�ť
IDB_BUTTON_PLAY			= 1104		; ������ť
IDB_BUTTON_STOP_1       = 1105		; ֹͣ��ťһ
IDB_BUTTON_STOP_2		= 1106		; ֹͣ��ť��


IDB_RADIOBUTTON_1		= 1201		; ��ѡ��һ
IDB_RADIOBUTTON_2		= 1202		; ��ѡ���
IDB_RADIOBUTTON_3		= 1203		; ��ѡ����
IDB_RADIOBUTTON_4		= 1204		; ��ѡ����
IDB_RADIOBUTTON_5		= 1205		; ��ѡ����



IDE_EDIT_INFO			= 2000		; ��Ϣ�����
IDE_EDIT_FILENAME_1		= 2001		; �ļ����༭��һ
IDE_EDIT_FILENAME_2		= 2002		; �ļ����༭���

IDS_STATIC_1			= 3001		; ��̬��һ
IDS_STATIC_2			= 3002		; ��̬���
IDS_STATIC_3			= 3003		; ��̬����

IDC_COMBOBOX_BACKCOLOR	= 4001		; ������ɫ��Ͽ�
IDC_COMBOBOX_CHARCOLOR	= 4002		; �ַ���ɫ��Ͽ�
IDC_COMBOBOX_PLAYSPEED  = 4003		; ���ű���

; --------------------
; ��������
; --------------------
ButtonTest PROTO hWnd:HWND


syncWorkDir PROTO												; ͬ������·������
getOpenFile PROTO szFilter:PTR BYTE								; ���ļ��Ի������
checkRadioButton PROTO hRadioButton:DWORD						; ��ⵥѡ��״̬����
setEdit PROTO hEdit:DWORD, szText:PTR BYTE						; ���ñ༭���ı�����
getEdit PROTO hEdit:DWORD, nLength:DWORD, szText:PTR BYTE		; ��ȡ�༭���ı�����
addEdit PROTO hEdit:DWORD, szText:PTR BYTE						; ���ӱ༭���ı�����
setCombobox PROTO hCombobox:DWORD, nIndex:DWORD					; ������Ͽ�ѡ�����
getCombobox PROTO hCombobox:DWORD, nIndex:PTR DWORD				; ��ȡ��Ͽ�ѡ�����
addCombobox PROTO hCombobox:DWORD, szText:PTR BYTE				; ������Ͽ�ѡ�����

getRadioButtonFPSChoice PROTO									; ��ȡ����֡�ʵ�ѡ��ѡ�����
getRadioButtonnMakeModeChoice PROTO								; ��ȡ����ģʽ��ѡ��ѡ�����

