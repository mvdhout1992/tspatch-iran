@JMP 0x00408EAA _Anticheat_Test1
@JMP 0x006157E0 _Anticheat_Test2
@JMP 0x00596D9F _Anticheat_Test3

; Minimap/radar hacks
@JMP 0x005BBF68 _Anticheat_Test4
@JMP 0x005BC040 _Anticheat_Test5
@JMP 0x005BBFE8 _Anticheat_Test6
@JMP 0x005B899E _Anticheat_Test7
@JMP 0x005B8C70 _Anticheat_Test8
@JMP 0x005B8E9E _Anticheat_Test9
@JMP 0x005B914D _Anticheat_Test10
@JMP 0x005B916B _Anticheat_Test11
@JMP 0x005BB153 _Anticheat_Test12
@JMP 0x005BBEE8 _Anticheat_Test13
@JMP 0x005BBF89 _Anticheat_Test14
@JMP 0x005BC040 _Anticheat_Test15
@JMP 0x005BC050 _Anticheat_Test16
@JMP 0x005BC0B3 _Anticheat_Test17
@JMP 0x005BC150 _Anticheat_Test18
@JMP 0x005BC170 _Anticheat_Test19
@JMP 0x005BC1E7 _Anticheat_Test20
@JMP 0x005B91A6 _Anticheat_Test21
@JMP 0x005C22EC _Anticheat_Test22
@JMP 0x005C265A _Anticheat_Test23

;;@JMP 0x005F4645 _Anticheat_Test30
;@JMP 0x005F468C _Anticheat_Test31

;@JMP 0x005F4E7B _Anticheat_Test32
;@JMP 0x005F4E8F _Anticheat_Test33
;@JMP 0x005F50F1 _Anticheat_Test34
;@JMP 0x005F5168 _Anticheat_Test35
;@JMP 0x005F51F8 _Anticheat_Test36
;@JMP 0x005F56E0 _Anticheat_Test37
;@JMP 0x005F5720 _Anticheat_Test38
;@JMP 0x005F58D0 _Anticheat_Test39
;@JMP 0x005F464E _Anticheat_Test40
;@JMP 0x005F59DD _Anticheat_Test41
;@JMP 0x005F5DD1 _Anticheat_Test42
;@JMP 0x005F5E9D _Anticheat_Test43
;@JMP 0x005F2C90 _Anticheat_Test44
;@JMP 0x005F57FF _Anticheat_Test46

@JMP 0x0046EA84 _Anticheat_Test45

@JMP 0x00454E6C _Anticheat_Test50

@JMP 0x0045513C _Anticheat_Test51

@JMP 0x005F2E7A _Anticheat_Test60
@JMP 0x005F2E83 _Anticheat_Test61
@JMP 0x005F3E5A _Anticheat_Test62

@JMP 0x005F3CB9 _Anticheat_Test63
;@JMP 0x005F59B9 _Anticheat_Test64

;@JMP 0x0047649D _Anticheat_Test70
@JMP 0x00478974 _Anticheat_Test80

@JMP 0x0060B74C _Anticheat_Test90

@JMP 0x0060C175  _AntiCheat_Test95

@JMP 0x0060B77F  _AntiCheat_Test100

_AntiCheat_Test100:
    mov byte [esi+2Ch], 0
    jmp 0x0060B789

_AntiCheat_Test95:
    cmp byte [esi+29h], 0
    jz .Ret
    
    call 0x004C53C0
    
.Ret:
    jmp 0x0060C17A

_Anticheat_Test90:
    jmp 0x0060B753
    
_Anticheat_Test80:    
    push eax
    push ecx
    
    mov ecx, [0x0074C8F0]
    call 0x006A6930
    mov ecx, [0x0074C258]
    cmp eax, ecx
    
    pop ecx
    pop eax
    
    jge .Ret
    
    mov al, [ebx+11A8h]
    jmp 0x0047897A
    
.Ret:
    xor dl, dl
    jmp 0x00478A3C

_Anticheat_Test70:
    mov esi, ecx
    mov byte [esi+0x11A8], 0
    cmp bp, word [0x007A2048]
    jmp 0x004764A6

Test_Stuff:
;    mov ecx, [eax+esi+0x4C]
;    cmp ecx, [edx+esi+0x4C]
;    jnz .Crash
    
    add esi, 0x50
    mov edi, 950
;    mov edi, 900
    add edi, esi
    sub edi, 0x50
    
.Loop:
    mov ecx, [edx+esi]
    mov [eax+esi], ecx
    mov ecx, [edx+esi+4]
    mov [eax+esi+4], ecx
    
    cmp esi, edi
    jge .Ret
    add esi, 0x0c
    jmp .Loop
   
.Ret:
    retn
    
.Crash:
    int3

_Anticheat_Test64:
    pushad

    mov eax, LEFT_STRIP
    mov edx, var.AntiCheatArray
    call Test_Stuff
    
    mov eax, RIGHT_STRIP
  ;  mov edx, var.AntiCheatArray+980
  ;  call Test_Stuff

    popad
    
    push ebx
    push ebp
    mov ebp, [ecx+30h]
    push esi
    jmp 0x005F59BF

_Anticheat_Test63:
;    cmp dword [var.AntiCheatArray+0x38], -1
;    jnz .Ret

    pushad

    mov eax, LEFT_STRIP
    mov edx, var.AntiCheatArray
    mov esi, 0
    call Test_Stuff
    
    mov eax, LEFT_STRIP
    mov edx, var.AntiCheatArray
    mov esi, 980
    call Test_Stuff

    popad
.Ret:
    call 0x005F4910
    jmp 0x005F3CBE
    
_Anticheat_Test62:
    push (StripClass_Size * 2)
    push LEFT_STRIP
    push var.AntiCheatArray
    call memcpy
    add esp, 0x0c
    pop esi
    pop ebx
    retn

_Anticheat_Test61:
    push (StripClass_Size * 2)
    push LEFT_STRIP
    push var.AntiCheatArray
    call memcpy
    add esp, 0x0c

    xor     al, al
    pop     esi
    retn    8

_Anticheat_Test60:
    call dword [edx+34h]
    
    push (StripClass_Size * 2)
    push LEFT_STRIP
    push var.AntiCheatArray
    call memcpy
    add esp, 0x0c
    
    mov al, 1
    pop esi
    retn 8

_Anticheat_Test46:
    call memcpy
    add esp, 4
    
    lea edi, [esi+50h]
    push edi
    
    call memcpy
    add esp, 0Ch
    
    jmp 0x005F5807

 
%macro DOOBEEDO 3      ;<dirtype>, <unk01>, <step>
        push    ecx
        lea     eax, [esp+0]
        push    %2
        push    eax
        push    %1
        mov     ecx, 0x00748348
        mov     dword [esp+0Ch], %3
        call    0x00476A60
 
        pop     ecx
%endmacro

@JMP 0x004EA280 _Anticheat_Test_60

_Anticheat_Test_60:
    mov eax, [0x007494F8]
    test eax, eax
    jnz .lct_Out
       
    mov eax, [0x007494FC]
    test eax, eax
    jnz .lct_Out
 
    DOOBEEDO 0, 1, 34
       
.lct_Out:
    retn
    
@JMP 0x004EA2E0 _Anticheat_Test_61

_Anticheat_Test_61:
    mov eax, [0x007494F8]
    test eax, eax
    jnz .lct_Out
       
    mov eax, [0x007494FC]
    test eax, eax
    jnz .lct_Out
       
    DOOBEEDO 4, 1, 34
       
.lct_Out:
    retn

@JMP 0x004EA340 _Anticheat_Test_62

_Anticheat_Test_62:
    mov eax, [0x007494F8]
    test eax, eax
    jnz .lct_Out
       
    mov eax, [0x007494FC]
    test eax, eax
    jnz .lct_Out
       
    DOOBEEDO 2, 1, 34
       
.lct_Out:
    retn
    
@JMP 0x004EA3A0 _Anticheat_Test_63

_Anticheat_Test_63:
    mov eax, [0x007494F8]
    test eax, eax
    jnz .lct_Out
       
    mov eax, [0x007494FC]
    test eax, eax
    jnz .lct_Out
       
    DOOBEEDO 6, 1, 34
       
.lct_Out:
    retn


_Anticheat_Test51:
    lea eax, [_1Bin]
       
Ok1:
    mov dword [0x00760C88], eax
    mov byte [0x00760CCE], 1
 
    jmp 0x00455154

_Anticheat_Test50:
    lea eax, [_2Bin]
    mov dword [0x00760CB4], eax
       
    lea eax, [_1Bin]
    mov dword [0x00760CB0], eax
 
    mov byte [0x00760CCD], 1
 
    jmp 0x00454E91
        

_Anticheat_Test45:
    lea eax, [eax+ebx*4]
    inc ecx
    mov [eax], ecx
    mov ecx, [esi+4]
    jmp 0x0046EA8D

_Anticheat_Test44:
    cmp [edx+4], ebp
    jnz 0x005F2C99
    
    cmp edx, RIGHT_STRIP
    jg .Right_Strip
    
    cmp [var.AntiCheatArray+edx-LEFT_STRIP], edi
    jz 0x005F2CA9
    jmp 0x005F2C99
    
.Right_Strip:
    cmp [var.AntiCheatArray+StripClass_Size+edx-RIGHT_STRIP], edi
    jz 0x005F2CA9
    jmp 0x005F2C99

_Anticheat_Test43:
    cmp eax, RIGHT_STRIP
    jz .Right_Strip
    
    mov edx, [var.AntiCheatArray+ebp+50h]

.Ret:
    push edx
    jmp 0x005F5EA2
    
.Right_Strip:
    mov edx, [var.AntiCheatArray+StripClass_Size+ebp+50h]
    jmp .Ret

_Anticheat_Test42:
    cmp eax, RIGHT_STRIP
    jz .Right_Strip
    
    mov edx, [var.AntiCheatArray+ebp+50h]
    
.Ret:
    push edx
    jmp 0x005F5DD6
   
.Right_Strip:
    mov edx, [var.AntiCheatArray+StripClass_Size+ebp+50h]
    jmp .Ret

_Anticheat_Test41:
    cmp eax, RIGHT_STRIP
    jz .Right_Strip

    mov edi, [var.AntiCheatArray+ebp+50h]
    
.Ret:
    mov eax, [eax+ebp+58h]
    jmp 0x005F59E5
    
.Right_Strip:
    mov edi, [var.AntiCheatArray+StripClass_Size+ebp+50h]
    jmp .Ret

_Anticheat_Test40:
    cmp [eax+4], edi
    jnz 0x005F4657
    
    cmp eax, RIGHT_STRIP
    jg .Right_Strip
    
    
    cmp [var.AntiCheatArray+eax-LEFT_STRIP], ebx
    jz  0x005F46A1
    jmp 0x005F4657
    
.Right_Strip:
    cmp [var.AntiCheatArray+StripClass_Size+eax-RIGHT_STRIP], ebx
    jz  0x005F46A1
    jmp 0x005F4657


_Anticheat_Test39:
    mov [esp+0x2C], edx
    
    cmp esi, RIGHT_STRIP
    jz .Right_Strip
    
    lea edx, [var.AntiCheatArray+50h]
    
.Ret:
    jmp 0x005F58D7
    
.Right_Strip:
    lea edx, [var.AntiCheatArray+StripClass_Size+50h]
    jmp .Ret

_Anticheat_Test38:
    cmp esi, RIGHT_STRIP
    jz .Right_Strip

    lea edi, [var.AntiCheatArray+50h]

.Ret:
    mov [esp+0x1C], ecx
    jmp 0x005F5727
    
.Right_Strip:
    lea edi, [var.AntiCheatArray+StripClass_Size+50h]
    jmp .Ret

_Anticheat_Test37:
    push eax
    
    cmp esi, RIGHT_STRIP
    jz  .Right_Strip

    lea eax, [var.AntiCheatArray+eax*4+50h]
    

.Ret:
    mov ebp, [eax]
    mov [ebx], ebp
    
    pop eax
    lea eax, [esi+eax*4+50h]
    
    mov ebp, [eax+4]
    mov [ebx+4], ebp
    mov eax, [eax+8]
    mov [ebx+8], eax
    jmp 0x005F56F4
    
.Right_Strip:
    lea eax, [var.AntiCheatArray+StripClass_Size+eax*4+50h]
    jmp .Ret

_Anticheat_Test36:
    cmp edx, RIGHT_STRIP
    jz .Right_Strip

    mov ebp, [var.AntiCheatArray+eax*4+50h]
    
.Ret:
    mov ecx, [0x007E3FFC]
    jmp 0x005F5202
    
.Right_Strip:
    mov ebp, [var.AntiCheatArray+StripClass_Size+eax*4+50h]
    jmp .Ret

_Anticheat_Test35:
    cmp ecx, RIGHT_STRIP
    jg .Right_Strip

    mov edx, [ecx+var.AntiCheatArray+50h-LEFT_STRIP]

.Ret:
    mov ecx, [eax]
    jmp 0x005F516D
    
.Right_Strip:
    mov edx, [ecx+var.AntiCheatArray+StripClass_Size+50h-RIGHT_STRIP]
    jmp .Ret

_Anticheat_Test34:
    cmp eax, RIGHT_STRIP
    jg .Right_Strip

    mov edx, [eax+var.AntiCheatArray+50h-LEFT_STRIP]

.Ret:
    call 0x004631B0
    jmp 0x005F50F9
    
.Right_Strip:
    mov edx, [eax+var.AntiCheatArray+StripClass_Size+50h-RIGHT_STRIP]
    jmp .Ret

_Anticheat_Test33:
    cmp ecx, RIGHT_STRIP
    jz .Right_Strip
    
    mov edx, [var.AntiCheatArray+eax*4+50h]

.Ret:
    mov ecx, esi
    jmp 0x005F4E95
    
.Right_Strip:
    mov edx, [var.AntiCheatArray+StripClass_Size+eax*4+50h]
    jmp .Ret

_Anticheat_Test32:
    cmp ecx, RIGHT_STRIP
    jz .Right_Strip
    mov ecx, [var.AntiCheatArray+eax*4+50h]
    
.Ret:
    mov edx, [0x007E3FFC]
    jmp 0x005F4E85
    
.Right_Strip:
    mov ecx, [var.AntiCheatArray+StripClass_Size+eax*4+50h]
    jmp .Ret

_Anticheat_Test31:

    cmp esi, RIGHT_STRIP
    jz .Right_Strip

    mov [var.AntiCheatArray + ecx * 4 + 50h], ebx

.Ret:
    mov eax, [esi+4Ch]
    jmp 0x005F4693

.Right_Strip:
    mov [var.AntiCheatArray + StripClass_Size + ecx * 4 + 50h], ebx
    jmp .Ret

_Anticheat_Test30:
    xor     ecx, ecx
    test    edx, edx
    jle     0x005F465F

    cmp esi, RIGHT_STRIP
    jz .Right_Strip
    
    lea eax, [var.AntiCheatArray + 50]
    jmp 0x005F464E

.Right_Strip:
    lea eax, [var.AntiCheatArray + StripClass_Size + 50]
    jmp 0x005F464E
    
_Anticheat_Test23:
    mov ecx, [var.Anticheat1]
    jmp 0x005C2660

_Anticheat_Test22:
    mov eax, [var.Anticheat1]
    jmp 0x005C22F1

_Anticheat_Test21:
    mov eax, [var.Anticheat1]
    jmp 0x005B91AB

_Anticheat_Test20:
    mov     ecx, [var.Anticheat1]
    jmp 0x005BC1ED

_Anticheat_Test19:
    cmp dword [var.Anticheat1], 3
    jmp 0x005BC177

_Anticheat_Test18:
    cmp dword [var.Anticheat1], 2
    jmp 0x005BC157

_Anticheat_Test17:
    mov eax, [var.Anticheat1]
    jmp 0x005BC0B9

_Anticheat_Test16:
    mov edx, [var.Anticheat1]
    jmp 0x005BC056

_Anticheat_Test15:
    mov [var.Anticheat1], edi
    jmp 0x005BC046

_Anticheat_Test14:
    mov [var.Anticheat1], edi
    jmp 0x005BBF8F

_Anticheat_Test13:
    mov eax, [var.Anticheat1]
    jmp 0x005BBEEE

_Anticheat_Test12:
    cmp dword [var.Anticheat1], 3
    jmp 0x005BB15A

_Anticheat_Test11:
    mov edx, [var.Anticheat1]
    jmp 0x005B9171

_Anticheat_Test10:
    cmp dword [var.Anticheat1], 3
    jmp 0x005B9154

_Anticheat_Test9:
    mov eax, [var.Anticheat1]
    jmp 0x005B8EA4

_Anticheat_Test8:
    mov [var.Anticheat1], eax
    jmp 0x005B8C76

_Anticheat_Test7:
    mov [var.Anticheat1], ebx
    jmp 0x005B89A4

_Anticheat_Test6:
    mov [var.Anticheat1], edi
    jmp 0x005BBFEE

_Anticheat_Test5:
    mov [var.Anticheat1], edi
    jmp 0x005BC046

_Anticheat_Test4:
    mov [var.Anticheat1], edi
    jmp 0x005BBF6E

; Prevent 'cm-tsatr.exe' Command & Conquer: Tiberian Sun/Firestorm + 2 Trainer from working
_Anticheat_Test1:
    mov ecx, 0x00748348
    jmp 0x00408EAF
    
; Prevent 'MultiTrainer.exe' fog reveal hack from working, not tested
_Anticheat_Test2:
    jz  0x00615807
    mov edx, [esi]
    lea eax, [esp+164]
    jmp 0x006157EB

; Prevent 'MultiTrainer.exe' fog reveal hack from working, not tested
_Anticheat_Test3:
    mov esi, [0x006CA408]
    jmp 0x00596DA5

