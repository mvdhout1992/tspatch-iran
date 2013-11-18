[absolute 0xA69000]

hp_data:
    .var1 RESD 1
    .var2 RESD 1
    .var3 RESD 1
    .global_buffer RESB 1024
    .foobar RESW 1
    .byte RESB 1
    .TempPtr RESD 1
    .SpawnerActive RESD 1
    .inet_addr  RESD 1
    
[section .text]

struc NetAddress
    .port:      RESD 1
    .ip:        RESD 1
    .zero:      RESW 1
endstruc


@JMP   0x004E1DE0  _Select_Game_Init_Spawner
@JMP   0x00609470  _Send_Statistics_Packet_RETN_Patch
@JMP   0x005EEE60  _SessionClass__Free_Scenario_Descriptions_RETN_Patch

_SessionClass__Free_Scenario_Descriptions_RETN_Patch:
    retn

_Send_Statistics_Packet_RETN_Patch:
    retn

str_gcanyonmap   db "blitz_test.map", 0 
str_debugplayer  db "debugplayer",0
str_debugplayer2  db "debugplayer2",0
str_wsock32_dll  db "wsock32.dll",0
str_inet_addr    db "inet_addr",0
str_localhost    db "127.0.0.1",0

def_port dd 1234

; NEED TO ADD SendFix & ReceiveFix


Initialize_Spawn:

    cmp     DWORD [hp_data.SpawnerActive], 1
    jz      .Ret_Exit
    
    mov     DWORD [hp_data.SpawnerActive], 1
    
    call    Import_int_addr
    
    mov   BYTE [0x007E4580], 1 ; GameActive, needs to be set here or the game gets into an infinite loop trying to create spawning units

          ;set session 
      mov      DWORD [0x007E2458], 4 ; sessiontype
       
      mov      dword [0x007E2480], 2 ; unit count
      mov      dword [0x007026C0], 10 ; tech level
      
      mov       dword [0x007E2484], 0 ; AI players
      
      mov       dword [0x007E2514], 60 ; RequestedFPS
      
       
      mov      dword [0x007E2464], 2   ;PacketProtocol
      
      mov   DWORD [0x007E245C], 0 ; WOL?
      
        mov     ecx, 0x07E2458; offset SessionClass_Session
        call    0x005EE7D0
      
      mov   DWORD [0x007E4934], 324324 ; Seed, TODO NEEDS TO BE READ FROM INI
      call  0x004E38A0 ; Init_Random()
      
    push  str_gcanyonmap
      push   0x007E28B0 ; map buffer used by something
      call   0x006BE630 ; strcpy
      add     esp, 8 
      
    call    Add_Human_Player
    call    Add_Human_Opponents
    
    ; do networking crap
    
    push    35088h
    call    0x006B51D7 ; operator new(uint)
    add     esp, 4
    
    mov     ecx, eax
    call    0x006A1E70 ; UDPInterfaceClass::UDPInterfaceClass(void)
    
    mov     [0x0074C8D8], eax ; _ptr_WinsockInterface
    
    MOV ECX, [0x0074C8D8] ; _ptr_WinsockInterface
    CALL    0x006A1180   ;   int WinsockInterfaceClass::Init(void)
    
    push    0
    MOV ECX, [0x0074C8D8] ; _ptr_WinsockInterface
    call    0x006A2130      ;   UDPInterfaceClass::Open_Socket(unsigned int)
    
    MOV ECX, [0x0074C8D8] ; _ptr_WinsockInterface
    call    0x006A1030  ; int WinsockInterfaceClass::Start_Listening(void)
    
    MOV ECX, [0x0074C8D8] ; _ptr_WinsockInterface
    call    0x006A10A0 ; void WinsockInterfaceClass::Discard_In_Buffers(void)
    
    MOV ECX, [0x0074C8D8] ; _ptr_WinsockInterface
    call    0x006A1110  ; void WinsockInterfaceClass::Discard_Out_Buffers(void)
    
    mov     ecx, 0x007E45A0 ; offset IPXManagerClass Ipx
    push    1
    push    258h
    push    0FFFFFFFFh
    push    1Eh
    call    0x004F05B0 ; IPXManagerClass::Set_Timing(ulong,ulong,ulong)
    
    mov DWORD [0x007E250C], 15 ; MaxAhead
    MOV DWORD [0x007E2510], 3 ; FrameSendRate
    mov DWORD [0x007E3FA8], 0 ; LatencyFudge

    call    0x00574F90 ; Init_Network
    

      ;start scenario 
      push   -1 
      xor      edx, edx 
      mov      ecx, str_gcanyonmap 
      call   0x005DB170 
       
      call   0x00462C60 
       
      mov      ecx, [0x0074C8F0] 
      mov     edx, [ecx] 
      call    dword [edx+0Ch] 
       
      mov      ecx, [0x0074C5DC] 
      push    edi 
      mov     eax, [ecx] 
      call    dword [eax+18h] 
       
      push   0 
      mov      cl, 1 
      mov      edx, [0x0074C5DC] 
      call   0x004B96C0 
       
      mov      ecx, [0x0074C8F0] 
      mov     edx, [ecx] 
      call    dword [edx+10h] 
       
      mov      eax, [0x0074C5DC] 
      mov      [0x0074C5E4], eax 
       
      push   0 
      push   13h 
      mov      ecx, 0x00748348 
      call   0x00562390 
       
      mov      ecx, 0x00748348 
      call   0x005621F0 
       
      push   1 
      mov      ecx, 0x00748348 
      call   0x005F3E60 
       
      push   0 
      mov      ecx, 0x00748348 
      call   0x004B9440 
       
      call   0x00462C60 
             
      mov      ecx, [0x0074C8F0] 
      mov     edx, [ecx] 
      call    dword [edx+0Ch]
   
.Ret:   
    mov       eax, 1
    retn
    
.Ret_Exit:
    mov       eax, 0
    retn

_Select_Game_Init_Spawner:
    CALL    Initialize_Spawn
    CMP     EAX,-1
    ; if spawn not initialized, go to main menu
    JE .Normal_Code
    
;    mov     eax, 1
    retn
   
.Normal_Code:   
    mov     ecx, [0x0074C8F0] ; WWMouseClass *_Mouse
    sub     esp, 1ACh
    mov     eax, [ecx]
    push    ebx
    push    ebp
    push    esi
    push    edi
    jmp     0x004E1DF2
    
Add_Human_Player:      
      push   0x4D 
      call   0x006B51D7 
       
      add     esp, 4 
       
      mov      esi, eax 

      lea     ecx, [esi+14h] 
      call   0x004EF040 
       
      lea      ecx, [esi] 
      push   str_debugplayer 
      push   ecx 
      call   0x006BE630 ; strcpy
       
      add     esp, 8 
       
       ; Player side
       mov  eax, 1
        mov      dword [esi+0x35], eax ; side 
        mov BYTE [0x7E2500], al ; For side specific mix files loading and stuff

        mov      dword [esi+0x39], 3  ; color


      mov      dword [esi+0x41], -1 
       
      mov      [hp_data.TempPtr], esi 
      lea      eax, [hp_data.TempPtr] 
      push   eax 
      mov      ecx, 0x007E3E90 
      call   0x0044D690 
      retn
      
Add_Human_Opponents:
          push   0x4D 
      call   0x006B51D7 
       
      add     esp, 4 
       
      mov      esi, eax 

      lea     ecx, [esi+14h] 
      call   0x004EF040 
       
      lea      ecx, [esi] 
      push   str_debugplayer2 
      push   ecx 
      call   0x006BE630 ; strcpy
       
      add     esp, 8 
       
       ; Player side
       mov  eax, 1
        mov      dword [esi+0x35], eax ; side 
        mov BYTE [0x7E2500], al ; For side specific mix files loading and stuff
     
    mov     eax, 1
    MOV [esi + 0x14 + NetAddress.zero], WORD 0
    
    push    str_localhost
    mov eax, [hp_data.inet_addr]
    call    eax
    
    MOV [esi + 0x14 + NetAddress.ip], EAX
    
    mov eax, [def_port]
    AND EAX, 0xFFFF

    PUSH EAX
    CALL 0x006B4D24 ; htonl
    
    MOV [esi + 0x14 + NetAddress.port], EAX

        mov      dword [esi+0x39], 2  ; color


      mov      dword [esi+0x41], -1 
       
      mov      [hp_data.TempPtr], esi 
      lea      eax, [hp_data.TempPtr] 
      push   eax 
      mov      ecx, 0x007E3E90 
      call   0x0044D690 
      retn
    
Import_int_addr:
    PUSH str_wsock32_dll
    CALL [0x006CA16C] ; LoadLibraryA

    PUSH str_inet_addr
    PUSH EAX
    CALL [0x006CA174] ; GetProcAddress

    MOV [hp_data.inet_addr], EAX
    retn


