;@JMP 0x005D6B92 _Load_Game_Post_Load_Game_Hook
;@JMP 0x005D4FF5 _Save_Game_Pre_Save_Game_Hook

_Save_Game_Pre_Save_Game_Hook:
    mov eax, [var.Anticheat1]
    mov [0x00749800], eax
     
    push (StripClass_Size * 2)
    push var.AntiCheatArray
    push LEFT_STRIP
    call memcpy
    add esp, 0x0c    
     
    call 0x004082D0
    jmp 0x005D4FFA

_Load_Game_Post_Load_Game_Hook:
    mov eax, [0x00749800]
    mov [var.Anticheat1], eax

    push (StripClass_Size * 2)
    push LEFT_STRIP
    push var.AntiCheatArray
    call memcpy
    add esp, 0x0c
    
    call 0x004082D0
    jmp 0x005D6B97