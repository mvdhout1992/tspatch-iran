@JMP 0x005DB49C _Start_Scenario_Force_Briefing_Screen

_Start_Scenario_Force_Briefing_Screen:
    cmp dword [SessionType], 0
    jnz     .Ret

    push    ecx
    
    call    0x0059CC40 ; loads bunch of resources
    
    
    ; load some stuff to get text color right on button
    mov     ecx, 0
    push    ecx
    call    [0x006CA368]
    push    eax
    call    0x005912E0
    
    mov     ecx, [ScenarioStuff]
    call    0x005C0230

    
    pop     ecx
    
.Ret:
    pop     edi
    pop     esi
    pop     ebp
    mov     byte [0x007E48FC], 1
    jmp     0x005DB4A6