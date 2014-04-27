@JMP 0x005DB49C _Start_Scenario_Force_Briefing_Screen

_Start_Scenario_Force_Briefing_Screen:
    push    ecx

    mov     ecx, [ScenarioStuff]
    call    0x005C0230
    
    pop     ecx
    
.Ret:
    pop     edi
    pop     esi
    pop     ebp
    mov     byte [0x007E48FC], 1
    jmp     0x005DB4A6