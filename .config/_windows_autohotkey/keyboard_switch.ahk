; https://github.com/xmdn/2_of_3_lang_switch_hotkey

englishLayout := "00000409"  ; English (United States)
chineseLayout := "00000804"   ; Chinese (Simplified, PRC)

; Windows 10 → Advanced keyboard settings → Input language hot keys → Advanced key settings
; Set Alt+Shift+0 to switch to English
; Set Alt+Shift+1 to switch to Chinese

SetKeyboardLayoutShortcut(shortcut) {
    SendInput, {Alt down}{Shift down}%shortcut%{Shift up}{Alt up}
}

CapsLock::
    currentLayout := GetKeyboardLayout()

    if (currentLayout = englishLayout) {
        SetKeyboardLayoutShortcut("1")
    } else if (currentLayout = chineseLayout) {
        SetKeyboardLayoutShortcut("0")
    } else {
        SetKeyboardLayoutShortcut("0")
    }
return

GetKeyboardLayout() {
    hwnd := WinExist("A")
    threadId := DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "UInt", 0)
    langId := DllCall("GetKeyboardLayout", "UInt", threadId, "Ptr")
    return Format("{:08x}", langId & 0xFFFF)
}
