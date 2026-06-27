#ifndef UNICODE
#define UNICODE
#endif

#include <stdio.h>
#include <windows.h>

LRESULT CALLBACK WindowProc(HWND hand, UINT uMsg, WPARAM uParam, LPARAM lParam);

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, PSTR pCmdLine, int nCmdShow) {
    const wchar_t CLASS_NAME[] = L"TheWindowClass";

    WNDCLASS wc = { 0 };

    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = CLASS_NAME;

    RegisterClass(&wc);

    HWND hand = CreateWindowEx(
        0,
        CLASS_NAME,
        L"Window",
        WS_OVERLAPPEDWINDOW,

        10, 10,
        400,
        200,

        NULL,
        NULL,
        hInstance,
        NULL
    );


    if (hand == NULL) {
        return 0;
    }

    ShowWindow(hand, nCmdShow);

    MSG msg = { 0 };
    while (GetMessage(&msg, NULL, 0, 0)) {
        TranslateMessage(&msg);
        DispatchMessage(&msg);
    }

    return 0;
}

LRESULT CALLBACK WindowProc(HWND hand, UINT uMsg, WPARAM uParam, LPARAM lParam) {
    switch(uMsg) {
        case WM_DESTROY:
            PostQuitMessage(0);
            return 0;
        case WM_PAINT:
            {
                PAINTSTRUCT ps;
                HDC hdc = BeginPaint(hand, &ps);

                FillRect(hdc, &ps.rcPaint, (HBRUSH) (COLOR_WINDOW+1));
                

                EndPaint(hand, &ps);
            }
            return 0;
        }

    //RedrawWindow(hand, NULL, NULL, RDW_INVALIDATE);
    return DefWindowProc(hand, uMsg, uParam, lParam);
}