;@HOOK 0x00589D31 _Read_SUN_INI_Detail_Level_Setting

_Read_SUN_INI_Detail_Level_Setting:
    push eax
    
    INIClass_Get_Bool INIClass_SUN_INI, str_Options, str_ForceLowestDetailLevel, 1
    cmp al, 1
    pop eax
    jz .Force
    
    cmp eax, 2
    mov [esi+14h], eax
    jl .Out
    mov eax, 2
.Out:
    jmp 0x00589D3E
    
.Force:
    mov dword [esi+14h], 0
    mov eax, 0
    jmp 0x00589D3E

; Fixes for WaveClass errors related to laser and Ion Cannon ripple effect
@JMP 0x006715F0 _sub_6715F0_RETN_Patch
@JMP 0x004EEB26 _sub_4EEAC0_WCE_Fix_Patch

_sub_4EEAC0_WCE_Fix_Patch:
    jmp 0x004EEB43 ; jump to epilogue

_sub_6715F0_RETN_Patch:
    jmp 0x0067191F ; jump to RETN instruction
