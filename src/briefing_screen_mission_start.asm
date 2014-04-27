@JMP 0x005DB49C _Start_Scenario_Force_Briefing_Screen

_Start_Scenario_Force_Briefing_Screen:
    cmp dword [SessionType], 0
    jnz     .Ret

    push    ecx
    
    call    0x0059CC40 ; loads bunch of resources
    
    mov dword [0x00808B7C], 0x23D05E
    
    mov     dword [0x809218], 1
    mov     dword [0x809250], 28h
    mov     dword [0x808B6C], 7Fh
    mov     dword [0x808B68], 109010h
    mov     dword [0x809248], 0x909090

    mov     dword [0x809244], 0DCB64Eh
    mov     dword [0x809230], 615022h
    mov     dword [0x8093A4], 221B0Bh
    mov     dword [0x808E30], 443716h

    mov     ecx, [ScenarioStuff]
    call    0x005C0230
    
    pop     ecx
    
.Ret:
    pop     edi
    pop     esi
    pop     ebp
    mov     byte [0x007E48FC], 1
    jmp     0x005DB4A6