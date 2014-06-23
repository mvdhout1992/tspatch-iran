; power=0 hard-coded to damage 1 at 0x004D3F84

@JMP 0x0045ED08 _Tiberium_Chain_Reaction_Dont_Crash_With_Power_Zero

_Tiberium_Chain_Reaction_Dont_Crash_With_Power_Zero:
    mov edi, [ebx+84h]
    cmp edi, 0
    jz .Set_EDI_To_1
    
    jmp 0x0045ED0E
    
.Set_EDI_To_1:
    mov edi, 1
    jmp 0x0045ED0E