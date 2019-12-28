# 汇编大作业

田丰源 2017013630

黄翔 2017013570

从业臻 2017013599



#### 选题由来

我们曾经看到过一个字符画视频，它将一个经典的黑白风格的动画（名叫Bad Apple，见下图）打印在控制台上，效果非常不错。借汇编大作业的机会，我们就想到用汇编实现一个字符画生成与播放器。非常巧的是，10月27日（本来的ddl）还刚好是Bad Apple十周年。

 ![img](https://gss0.bdstatic.com/94o3dSag_xI4khGkpoWK1HF6hhy/baike/w%3D268%3Bg%3D0/sign=eb315de88544ebf86d716339e1c2b017/8694a4c27d1ed21b8ea54a0eaf6eddc450da3fe8.jpg) 

虽然视频解码的难度过大，无法写出来，只能借助外部工具；但是图片的解码、缩放和转换完全可以用汇编语言书写。经过技术方案的调研后，我们确定了这个选题，兼顾了工作量、挑战性和趣味性。



#### 开发环境

- ​    **操作系统：**Windows 10
- ​    **SDK：**masm32
- ​    **IDE：**Visual Studio 2019 / 2017
- ​    **GUI：**Win32
- ​    **链接库（部分）：**windows/kernel32/user32/comdlg32/comctl32/msvcrt

#####         

#### **实现原理**  

1. **视频抽帧与图片解码**

   视频的抽帧我们使用了开源工具`ffmpeg`。程序运行时，通过`crt_system`函数命令行调用该工具来对目标视频进行抽帧。

   由于`.jpg`文件的编码格式过于复杂，我们使用`ffmpeg`生成位图来解析。这样得到的位图是24位真彩色，其编码格式见下图：（以下图片均摘自 https://blog.csdn.net/Radishmanfan/article/details/100829708 ）

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190914171521395.png#pic_center) 

   其中24位真彩色的位图没有调色板段，比较方便，只需要获取位图数据起始点、图片长和宽信息。

   文件头和位图信息头的内容如下：

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/20190914172828457.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1JhZGlzaG1hbmZhbg==,size_16,color_FFFFFF,t_70#pic_center) 

    ![在这里插入图片描述](https://img-blog.csdnimg.cn/2019091417291220.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L1JhZGlzaG1hbmZhbg==,size_16,color_FFFFFF,t_70#pic_center) 

   位图数据是按照先行后列，从左下到右上，BGR的顺序摆放的。此外，由于32位的Windows操作系统处理4个字节(32位)的速度比较快，所以位图的每一行颜色占用的字节数规定为4的整数倍，不足需补0，故解析时需要根据图像的宽计算补0的个数。 

   对照着位图数据的格式，就可以提取所有像素点的信息了。

   

2. **生成字符画：**

   控制台调用视频解析工具`ffmpeg.exe`从视频中按照一定帧率截取图片（bmp格式），对得到的图片先进行等比例缩放（自动适配为适合观看的大小），再对缩放后的每一个像素点，按照公式 `Gray = (R*19595 + G*38469 + B*7472) >> 16 ` 求出其灰度（这样求是为了避免除法，加快速度）。

   将灰度值映射到字符的过程使用的字符序列`asciiChar`为（最后两个字符均为空格，不算\0）：

   ```C
   "@B%8&WM#*oahkbdpqwmZO0QLCJUYXzcvunxrjft/\|()1{}[]?-T+G<>i!||;:PASD "
   ```

   按照`asciiChar[Gray * lengthof(asciiChar) / 256]`求得灰度值对应的字符。这些字符按先行后列，从左上到右下的顺序（方便打印到控制台）存入`.apple`文件。此外，`.apple`文件文件的开头是长、宽、帧数信息。

   

3. **播放字符画**：

   从`.apple`文件一行行读字符，使用`crt_puts`函数打印在控制台上，打印满一张帧就将光标位置定回初始点，继续打印，以覆盖前一帧，避免屏幕闪烁。相邻帧间的时间间隔由设定的时间减去打印所花的时间，以达到帧率稳定、正确的效果。光标定回初始点的语句如下，其中`pointBase`值为0。

   ```assembly
   INVOKE SetConsoleCursorPosition, cursorHandle, pointBase
   ```

   

4. **GUI部分：**

    程序GUI的实现利用了**win32编程接口**，综合运用了主窗口类、静态框控件、分组框控件、单选框控件、组合框控件、按钮控件，使用了`kernel32.lib`、`user32.lib`、`msvcrt.lib`、`comdlg32.lib`、`comctl32.lib`等链接库。

- GUI 程序主要部分逻辑如下：
    -  定义主窗口类结构体
    ```asm
    MainWin WNDCLASS <>			; 主窗口类
    ```
    - 设定主窗口类结构体属性
    ```asm
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
    ```
    - 注册主窗口类
    ```asm
    INVOKE RegisterClass, ADDR MainWin
    ```
    - 创建主窗口类
    ```ams
    INVOKE CreateWindowEx, NULL, ADDR szWinClass, ADDR szWinText,
		WS_VISIBLE + WS_CAPTION + WS_SYSMENU + WS_MINIMIZEBOX,
		CW_USEDEFAULT, CW_USEDEFAULT, MAINWIN_WIDTH, MAINWIN_HEIGHT, NULL, NULL, hInstance, NULL
    ```
    - 显示主窗口类
    ```asm
    INVOKE ShowWindow, hMainWnd, SW_SHOW
    INVOKE UpdateWindow, hMainWnd
    ```
    - 进行消息循环
    ```ams
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
    ```
- GUI 消息处理函数所响应的消息如下：
    ```asm
    ; --- 创建窗口消息 ---
    .IF eax == WM_CREATE
        ; 内容省略
    ; --- 销毁窗口消息 ---
    .ELSEIF eax == WM_DESTROY
        ; 内容省略
	; --- 菜单/控件/快捷键消息 ---
	.ELSEIF eax == WM_COMMAND
        ; 内容省略
    ; --- 其他消息 ---
    .ELSE
        ; 内容省略
    .ENDIF
    ```
- GUI 定义的所有控件如下：

    ```asm
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
    IDC_COMBOBOX_PLAYSPEED  = 4003		; 播放倍速组合框
    ```



#### 难点与创新点

总结下来，有三大**难点**：

1. 大量控制台操作，如隐藏与显现、字体大小调整、背景色与字体颜色控制、关闭事件响应等等，部分功能网络上相关资料不多，我们花了不少时间调研与尝试；
2. 如何做到播放流畅不卡顿；
3. 由于需要调用外部工具进行视频抽帧，几乎无法线程间通信。如何同时生成和播放，以及处理生成操作停止后残余的位图文件，我们都设法解决了；

这些难点的解决方法见报告末的*遇到的困难及解决方法*。

配备字符画生成、生成并播放功能，自定义了字符画文件格式并可以读文件流畅播放，并将**这一套完善的功能集成到一个简单的GUI里**，并提供了大量用户自选的属性，是我们项目的最大**创新点**。



#### 目录结构

- report.pdf：此文档

- exe
  - asciiArt.exe：程序入口
  - test.rar：测试用.apple文件压缩包
  - test0.mp4：测试用视频
  - readme.pdf：使用及测试说明
  - utils
    - ffmpeg.exe：用于从视频中截取图片
    - tiny.exe：用于调整控制台字体
- frames：保存程序运行中产生的位图文件，正常关闭程序会清空该文件夹
  
- src
  - asciiArt.inc
  - window.inc
  - asciiArt.asm: 解析bmp格式的图片，并转为字符序列，存入.apple文件，并同时播放
  - utils.asm: 封装了生成、播放功能的接口，以及清空文件夹、设置暂停的接口
  - main.asm：GUI界面，也是程序入口点
  - printChar.asm：读取.apple文件并在控制台播放字符画
- demo.mp4：一个50秒左右的demo

​         

#### **效果展示**  

主界面如下：

<img src="C:\Users\13731\AppData\Roaming\Typora\typora-user-images\image-20191102182730797.png" alt="image-20191102182730797" style="zoom:67%;" />

在字符画生成栏中选择要转换的**视频文件**、**截取图片的帧率**以及**是否同时播放**（建议不选，因为同时播放，视频解析速率低于播放速率，卡顿较为严重），之后点击生成，会生成`.apple`文件，完成后消息框会有提示。

在字符动画播放栏中设置**背景颜色**，**字体颜色**和**播放速度倍率**，选择`.apple`文件后点击播放按钮即可在控制台中观看字符动画。

**点击停止按钮**可以停止上述操作，建议不要直接关闭控制台窗口；如果正在生成或播放时点击生成或播放按钮，会提示该操作无效。

此外，各类常见错误都会有信息栏的提示。

字符动画的效果见同级目录下的demo.mp4，是黑底白字，快进4倍的Bad Apple。由于电脑录屏软件录制的效果有一定卡顿，故使用手机拍摄。

此外，我们还制作了完整的操作示例，见清华云盘链接：https://cloud.tsinghua.edu.cn/d/ffedda32882e4d0dbdfb/ 。



#### **小组分工**  

整体来说，分工较为均衡，此文档也是三人共同撰写。

| 人员   | 任务                                                         |
| ------ | ------------------------------------------------------------ |
| 田丰源 | ffmpeg解析工具的使用/文件路径相关功能/控制台相关功能（包括播放字符画） |
| 黄翔   | 创意设计/图形界面/接口封装                                   |
| 从业臻 | 位图格式解析与缩放/.apple文件读写/代码封装整合               |



#### 遇到的困难与解决方法

1. `INCLUDE windows.inc `时遇到报错，解决方法是在文件首加入

   ```asm
   option casemap:none
   ```

   参考 https://forum.tuts4you.com/topic/13237-window-in-asm/ 。



2. 希望不让`ffmpeg`的提示信息打印在控制台上，最先想到了输出重定向，将如下C语句翻译为汇编：

   ```C
   freopen("log.out", "w", stdout);
   ```

   参考 https://stackoverflow.com/questions/12700106/writing-to-stderr-in-x86-assembly ，找到了`stdout`的宏定义使用的函数，然而发现对于控制台命令运行的ffmpeg程序不管用。

   后来脑筋一转，在`ffmpeg`的指令中找到了关闭输出信息的方式`-v 0`，解决了这个问题。



3. 为了能显示分辨率更高的字符画，希望调小控制台字体大小，然而很久都没有找到对应的API。终于在 https://social.msdn.microsoft.com/Forums/vstudio/en-US/192c888a-2994-48aa-bb17-ec95f03535b0/how-to-use-graphic-class-in-visual-c-console-application 以及 http://masm32.com/board/index.php?topic=1108.0 找到了方法，然而涉及的函数不在masm的库中，只好故技重施，编写了C++程序生成可执行文件`tiny.exe`，用运行该文件的方式更改控制台字体。该C++程序核心代码如下：

   ```C
   HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE); // Obtain the Console handle
   PCONSOLE_FONT_INFOEX lpConsoleCurrentFontEx = new CONSOLE_FONT_INFOEX();
   
   // set the size of the CONSOLE_FONT_INFOEX
   lpConsoleCurrentFontEx->cbSize = sizeof(CONSOLE_FONT_INFOEX);
   
   // get the current value
   GetCurrentConsoleFontEx(hConsole, 0, lpConsoleCurrentFontEx);
   
   // set size to be 4x6, the default size is 8x16
   lpConsoleCurrentFontEx->dwFontSize.X = 4;
   lpConsoleCurrentFontEx->dwFontSize.Y = 6;
   
   // submit the settings
   SetCurrentConsoleFontEx(hConsole, 0, lpConsoleCurrentFontEx);
   ```

   

4. 一开始，打印字符画采用的方式是打印完一帧后清除控制台（相当于C中的`system("cls");`），然后继续打印下一帧的方法，可这样会造成播放时出现画面闪烁的现象。为了使画面更流畅，我们将方法改为将光标移动到控制台开始位置再打印下一帧，并将光标设置为隐形，解决了播放时光标在左侧上下移动的问题。该解决方案参考了网页https://blog.csdn.net/edc370/article/details/79944251和https://blog.csdn.net/bnb45/article/details/8034641/ 。

   

5. 由于打印字符需要时间，sleep固定时间的方法下播放速度明显慢了不少。为了解决这个问题，我们调用获取时间的系统函数，每一帧打印前后获取时间，相减，再用帧率计算出的固定的睡眠时间减去该差值作为真正的睡眠时间。获取当前毫秒数的代码如下：

   ```assembly
   INVOKE GetLocalTime, ADDR sysTime
   movzx eax, sysTime.wMilliseconds
   ```




6. ffmpeg会生成大量的临时图片用于生成字符画文件。我们一开始采用用完一张删一张的办法，然而若中途停止的话，ffmpeg会继续运行，直到处理完整个视频。由于ffmpeg的使用是相当于同时运行一个可执行程序，正常的线程终止方法用不上，`TerminateThread`又有一定风险，通常不建议使用。因此，我们在GUI和控制台的关闭事件中都加入了清空临时位图文件的过程，且开始一次生成之前都会清空临时文件夹，保证新一次的生成不受上一次的影响。

   

7. 在GUI的设计中，通过阅读win32文档可以得知相关函数与接口的使用方法。但由于在汇编中无像C语言一样封装较为完整的库，在查找资料寻找对应的汇编链接库的过程中遇到了一些挑战。对于这一问题，我们采用对所有masm32汇编库进行文本搜索的方式检索含有所需函数的链接库。这样基本做到了C语言函数到汇编语言函数的无缝衔接，大大简化了GUI设计中的资料查找过程。

