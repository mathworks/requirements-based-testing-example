#define STDCALL	__stdcall
typedef int BOOL;
typedef unsigned int UINT;
typedef const char *LPCSTR;
typedef void *HANDLE;
typedef HANDLE HWND;
//typedef int HWND;
typedef struct _RECT {
	int left;
	int top;
	int right;
	int bottom;
} RECT,*LPRECT;

HWND STDCALL FindWindowA(LPCSTR,LPCSTR);
BOOL STDCALL ShowWindow(HWND,int);
BOOL STDCALL SetForegroundWindow(HWND hWnd);
BOOL STDCALL GetWindowRect(HWND,LPRECT);
// optional
BOOL STDCALL GetClientRect(HWND,LPRECT);
BOOL STDCALL SetWindowPos(HWND,HWND,int,int,int,int,UINT);
