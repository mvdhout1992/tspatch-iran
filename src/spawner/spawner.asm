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
    .FileClass_SPAWN  RESB 128
    .INIClass_SPAWN   RESB 256
    .CurrentOpponent RESD 1
    .OtherSection   RESB 128
    .IP_temp    RESB 32
    .HouseColorsArray RESD 8
    .HouseCountriesArray RESD 8
    
[section .text]

struc NetAddress
    .port:      RESD 1
    .ip:        RESD 1
    .zero:      RESW 1
endstruc

   %macro SpawnINI_Get_Int 3
      push %3 
      push %2
      push %1
      mov   ecx, hp_data.INIClass_SPAWN
      call 0x004DD140      ;Get_Int() 
   %endmacro 

     %macro SpawnINI_Get_Bool 3
      push %3 
      push %2
      push %1
      mov   ecx, hp_data.INIClass_SPAWN
      call 0x004DE140		;Get_Bool()
   %endmacro
   
   %macro SpawnINI_Get_String 5
            push	%5
            push	%4
            push	%3
            push	%2
            push	%1
            mov		ecx, hp_data.INIClass_SPAWN
            call	0x004DDF60		;Get_String()
%endmacro


@JMP   0x004E1DE0   _Select_Game_Init_Spawner
@JMP   0x00609470   _Send_Statistics_Packet_Return_If_Spawner_Active ; Games tries to send statistics when match ends which causes crash
@JMP   0x005E08E3   _Read_Scenario_INI_Assign_Houses_And_Spawner_House_Settings

; NEED TO ADD SendFix & ReceiveFix

_SessionClass__Free_Scenario_Descriptions_RETN_Patch:
    retn

_Send_Statistics_Packet_Return_If_Spawner_Active:
    cmp     DWORD [hp_data.SpawnerActive], 1
    jz      .Ret

    sub     esp, 374h
    jmp     0x00609476
    
.Ret:
    retn

str_gcanyonmap   db "blitz_test.map", 0 
str_debugplayer  db "debugplayer",0
str_debugplayer2  db "debugplayer2",0
str_wsock32_dll  db "wsock32.dll",0
str_inet_addr    db "inet_addr",0
str_localhost    db "127.0.0.1",0
str_spawn_ini   db "SPAWN.INI",0
str_Settings    db "Settings",0
str_UnitCount   db"UnitCount",0
str_Scenario    db"Scenario",0
str_Empty       db"",0
str_GameSpeed   db "GameSpeed",0
str_Seed        db"Seed",0
str_TechLevel   db"TechLevel",0
str_AIPlayers   db"AIPlayers",0
str_AIDifficulty db"AIDifficulty",0
str_HarvesterTruce db"HarvesterTruce",0
str_BridgeDestroy db"BridgeDestroy",0
str_FogOfWar    db"FogOfWar",0
str_Crates      db"Crates",0
str_ShortGame   db"ShortGame",0
str_Bases       db"Bases",0
str_MCVRedeploy db"MCVRedeploy",0
str_Credits     db"Credits",0
str_Name        db"Name",0
str_Side        db"Side",0
str_Color       db"Color",0
str_OtherSectionFmt db"Other%d",0
str_Port        db"Port",0
str_IP          db"IP",0
str_SpawnArg    db"-SPAWN",0
str_MultiEngineer db"MultiEngineer",0
str_Firestorm   db"Firestorm",0
str_HouseColors db"HouseColors",0
str_HouseCountries db"HouseCountries",0

str_Multi1      db"Multi1",0
str_Multi2      db"Multi2",0
str_Multi3      db"Multi3",0
str_Multi4      db"Multi4",0
str_Multi5      db"Multi5",0
str_Multi6      db"Multi6",0
str_Multi7      db"Multi7",0
str_Multi8      db"Multi8",0

str_Multi1_Alliances db"Multi1_Alliances",0
str_Multi2_Alliances db"Multi2_Alliances",0
str_Multi3_Alliances db"Multi3_Alliances",0
str_Multi4_Alliances db"Multi4_Alliances",0
str_Multi5_Alliances db"Multi5_Alliances",0
str_Multi6_Alliances db"Multi6_Alliances",0
str_Multi7_Alliances db"Multi7_Alliances",0
str_Multi8_Alliances db"Multi8_Alliances",0

def_port dd 1234

; sizes not actually verified
FileClass_SPAWN  TIMES 128 db 0
INIClass_SPAWN   TIMES 64 db 0

; args <House number>, <ColorType>
%macro Set_House_Color 3
    mov     eax, %2
    cmp     eax, -1
    jz      .Dont_Set_Color_%3
    mov     edi, [0x007E155C] ; HouseClassArray
    mov     edi, [edi+%1*4]
    
;    mov     DWORD [edi+0x10DFC], eax
;    mov     DWORD [edi+0x6C], eax
    
    push    eax
    call    0x005EEF70 ; Get_MP_Color?
    
    mov     DWORD [edi+0x10DFC], eax

.Dont_Set_Color_%3:
%endmacro

; args <House number>, <HouseType>
%macro Set_House_Country 3
    mov     eax, %2
    cmp     eax, -1
    jz      .Dont_Set_Country_%3
    mov     edi, [0x007E155C] ; HouseClassArray
    mov     edi, [edi+%1*4]
    
    mov     ecx, [0x007E21D4] ; HouseTypesArray?
    mov     eax, [ecx+eax*4]
    
    mov     DWORD [edi+24h], eax

.Dont_Set_Country_%3:
%endmacro

; args <House number>, <House number to ally>
%macro House_Make_Ally 3
    mov     eax, %2
    cmp     eax, -1
    jz      .Dont_Make_Ally_%3
    mov     esi, [0x007E155C] ; HouseClassArray
    mov     edi, [esi+4*%1]
    
    push    eax
    mov     ecx, edi
   call    0x004BDB30 ; void HouseClass::Make_Ally(HousesType)

.Dont_Make_Ally_%3:
%endmacro

; args <string of section to load from>, <House number which will ally>
%macro  House_Make_Allies_Spawner 3
    SpawnINI_Get_Bool %1, str_Multi1, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi1_%3
    House_Make_Ally %2, 0, a%3
    
.Dont_Ally_Multi1_%3:

    SpawnINI_Get_Bool %1, str_Multi2, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi2_%3
    House_Make_Ally %2, 1, b%3
    
.Dont_Ally_Multi2_%3:

    SpawnINI_Get_Bool %1, str_Multi3, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi3_%3
    House_Make_Ally %2, 2, c%3
    
.Dont_Ally_Multi3_%3:

    SpawnINI_Get_Bool %1, str_Multi4, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi4_%3
    House_Make_Ally %2, 3, d%3
    
.Dont_Ally_Multi4_%3:

    SpawnINI_Get_Bool %1, str_Multi5, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi5_%3
    House_Make_Ally %2, 4, e%3
    
.Dont_Ally_Multi5_%3:

    SpawnINI_Get_Bool %1, str_Multi6, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi6_%3
    House_Make_Ally %2, 5, f%3
    
.Dont_Ally_Multi6_%3:

    SpawnINI_Get_Bool %1, str_Multi7, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi7_%3
    House_Make_Ally %2, 6, g%3
    
.Dont_Ally_Multi7_%3:

    SpawnINI_Get_Bool %1, str_Multi8, 0
    cmp     al, 0
    jz      .Dont_Ally_Multi8_%3
    House_Make_Ally %2, 7, h%3
    
.Dont_Ally_Multi8_%3:

%endmacro

Load_House_Countries_Spawner:
    SpawnINI_Get_Int str_HouseCountries, str_Multi1, -1
    mov     DWORD [hp_data.HouseCountriesArray+0], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi2, -1
    mov     DWORD [hp_data.HouseCountriesArray+4], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi3, -1
    mov     DWORD [hp_data.HouseCountriesArray+8], eax
      
    SpawnINI_Get_Int str_HouseCountries, str_Multi4, -1
    mov     DWORD [hp_data.HouseCountriesArray+12], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi5, -1
    mov     DWORD [hp_data.HouseCountriesArray+16], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi6, -1
    mov     DWORD [hp_data.HouseCountriesArray+20], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi7, -1
    mov     DWORD [hp_data.HouseCountriesArray+24], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi8, -1
    mov     DWORD [hp_data.HouseCountriesArray+28], eax
    
   retn

Load_House_Colors_Spawner:
    SpawnINI_Get_Int str_HouseColors, str_Multi1, -1
    mov     DWORD [hp_data.HouseColorsArray+0], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi2, -1
    mov     DWORD [hp_data.HouseColorsArray+4], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi3, -1
    mov     DWORD [hp_data.HouseColorsArray+8], eax
      
    SpawnINI_Get_Int str_HouseColors, str_Multi4, -1
    mov     DWORD [hp_data.HouseColorsArray+12], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi5, -1
    mov     DWORD [hp_data.HouseColorsArray+16], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi6, -1
    mov     DWORD [hp_data.HouseColorsArray+20], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi7, -1
    mov     DWORD [hp_data.HouseColorsArray+24], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi8, -1
    mov     DWORD [hp_data.HouseColorsArray+28], eax
    
   retn

_Read_Scenario_INI_Assign_Houses_And_Spawner_House_Settings:
    pushad
    call    0x005DE210 ; Assign_Houses(void)
    
    Set_House_Color 0, DWORD [hp_data.HouseColorsArray+0], a
    Set_House_Color 1, DWORD [hp_data.HouseColorsArray+4], b
    Set_House_Color 2, DWORD [hp_data.HouseColorsArray+8], c
    Set_House_Color 3, DWORD [hp_data.HouseColorsArray+12], d
    Set_House_Color 4, DWORD [hp_data.HouseColorsArray+16], e
    Set_House_Color 6, DWORD [hp_data.HouseColorsArray+20], f
    Set_House_Color 7, DWORD [hp_data.HouseColorsArray+24], g
    Set_House_Color 8, DWORD [hp_data.HouseColorsArray+28], h
    
    Set_House_Country 0, DWORD [hp_data.HouseCountriesArray+0], a
    Set_House_Country 1, DWORD [hp_data.HouseCountriesArray+4], b
    Set_House_Country 2, DWORD [hp_data.HouseCountriesArray+8], c
    Set_House_Country 3, DWORD [hp_data.HouseCountriesArray+12], d
    Set_House_Country 4, DWORD [hp_data.HouseCountriesArray+16], e
    Set_House_Country 6, DWORD [hp_data.HouseCountriesArray+20], f
    Set_House_Country 7, DWORD [hp_data.HouseCountriesArray+24], g
    Set_House_Country 8, DWORD [hp_data.HouseCountriesArray+28], h
    
    House_Make_Allies_Spawner str_Multi1_Alliances, 0, a
    House_Make_Allies_Spawner str_Multi2_Alliances, 1, b
    House_Make_Allies_Spawner str_Multi3_Alliances, 2, c
    House_Make_Allies_Spawner str_Multi4_Alliances, 3, d
    House_Make_Allies_Spawner str_Multi5_Alliances, 4, e
    House_Make_Allies_Spawner str_Multi6_Alliances, 5, f
    House_Make_Allies_Spawner str_Multi7_Alliances, 6, g
    House_Make_Allies_Spawner str_Multi8_Alliances, 7, h
   
.Ret:   
    popad
    jmp     0x005E08E8


    
Load_SPAWN_INI:
    ; initialize FileClass
    push str_spawn_ini
    MOV ECX, hp_data.FileClass_SPAWN
    CALL 0x004497B0 ; FileClass__FileClass

        ; check ini exists
    MOV ECX, hp_data.FileClass_SPAWN
    XOR EDX, EDX
    push   EDX
    CALL 0x004499C0 ; FileClass__Is_Available
    TEST al, al
    JE .No_Spawn_INI

    ; initialize INIClass
    MOV ECX, hp_data.INIClass_SPAWN
    CALL 0x004E8A30 ; INIClass__INIClass

    ; load FileClass to INIClass
    push 0
    push 0
    mov     eax, hp_data.FileClass_SPAWN
    push    eax
    MOV ECX, hp_data.INIClass_SPAWN
    CALL 0x00449F30 ; INIClass__Load
    
    mov     eax, 1
    retn
    
.No_Spawn_INI:
    mov     eax, 0
    retn

Initialize_Spawn:

    cmp     DWORD [hp_data.SpawnerActive], 1
    jz      .Ret_Exit
    
    mov     DWORD [hp_data.SpawnerActive], 1
 
;; Commented out at the moment so I don't need to supply the -SPAWN arg the whole time 
;    call    [0x006CA24C] ; GetCommandLineA()
;    push str_SpawnArg
;    push eax
;    CALL 0x006B6730 ; stristr_
;    add esp, 8
;    TEST EAX,EAX
;    JE .Exit_Error
    
    call    Load_SPAWN_INI
     cmp    eax, 0
    jz      .Exit_Error
    
    call    Import_int_addr
    
    call    Load_House_Colors_Spawner
    call    Load_House_Countries_Spawner
    
    
    mov   BYTE [0x007E4580], 1 ; GameActive, needs to be set here or the game gets into an infinite loop trying to create spawning units

          ;set session 
      mov      DWORD [0x007E2458], 5 ; sessiontype
       
    SpawnINI_Get_Int str_Settings, str_UnitCount, 1
      mov      dword [0x007E2480], eax ; unit count
      
        SpawnINI_Get_Int str_Settings, str_TechLevel, 10
      mov      dword [0x006FB628], eax ; tech level
      
    SpawnINI_Get_Int str_Settings, str_AIPlayers, 0
      mov       dword [0x007E2484], eax ; AI players
   
    SpawnINI_Get_Int str_Settings, str_AIDifficulty, 1   
      mov   dword [0x007E2488], eax
      
      SpawnINI_Get_Bool str_Settings, str_HarvesterTruce, 0
      mov BYTE [0x007E248D], al
      
     SpawnINI_Get_Bool str_Settings, str_BridgeDestroy, 1 
      mov BYTE [0x007E2474], al
      
      SpawnINI_Get_Bool str_Settings, str_FogOfWar, 0
      mov BYTE [0x007E248F], al     
 
      SpawnINI_Get_Bool str_Settings, str_Crates, 0
      mov BYTE [0x007E2475], al
     
      SpawnINI_Get_Bool str_Settings, str_ShortGame, 0
      mov BYTE [0x007E2476], al     
  
      SpawnINI_Get_Bool str_Settings, str_Bases, 1
      mov BYTE [0x007E246C], al      
 
      SpawnINI_Get_Bool str_Settings, str_MCVRedeploy, 1
      mov BYTE [0x007E2490], al   
      
      SpawnINI_Get_Int str_Settings, str_Credits, 10000
      mov DWORD [0x007E2470], eax   

    SpawnINI_Get_Int str_Settings, str_Port, 1234
      mov DWORD [0x0070FCF0], eax   
      
     SpawnINI_Get_Int str_Settings, str_GameSpeed, 0
     mov    dword [0x007E4720], eax
     
    SpawnINI_Get_Bool str_Settings, str_MultiEngineer, 0
     mov    BYTE [0x007E247C], al
     
     
    SpawnINI_Get_Bool str_Settings, str_Firestorm, 0
    
    cmp     al, 0
    jz      .No_Firestorm
    
    mov     DWORD [0x006F2638], 3
    mov     DWORD [0x006F263C], 3
    
.No_Firestorm:
    
        mov     ecx, 0x07E2458; offset SessionClass_Session
        call    0x005EE7D0
        
         ; scenario
     LEA EAX, [0x007E28B8]
    SpawnINI_Get_String str_Settings, str_Scenario, str_Empty, EAX, 32
       
       SpawnINI_Get_Int str_Settings, str_Seed, 0
      mov   DWORD [0x007E4934], eax
      call  0x004E38A0 ; Init_Random()    
      
     
      

      

     
      
         
;    push  str_gcanyonmap
;      push   0x007E28B0 ; map buffer used by something
;      call   0x006BE630 ; strcpy
;      add     esp, 8
      

      
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
    mov DWORD [0x007E2514], 60 ; RequestedFPS
    mov DWORD [0x007E2464], 2   ; ProtocolVersion

    call    0x00574F90 ; Init_Network
    

      ;start scenario 
      push   -1 
      xor      edx, edx 
      mov      ecx, 0x007E28B8
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
     
;; Hide mouse, shouldn't be needed and makes mouse invisible in the match if it's there.
;      mov      ecx, [0x0074C8F0] 
;      mov     edx, [ecx] 
;      call    dword [edx+0Ch]
   
.Ret:   
    mov       eax, 1
    retn
    
.Ret_Exit:
    mov       eax, 0
    retn
    
.Exit_Error:
    MOV EAX,-1
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
       
       
           LEA EAX, [esi]
    SpawnINI_Get_String str_Settings, str_Name, str_Empty, EAX, 0x14

;    lea      ecx,  
;      push   str_debugplayer 
;      push   ecx 
;      call   0x006BE630 ; strcpy     
;      add     esp, 8 
       
       ; Player side
        SpawnINI_Get_Int str_Settings, str_Side, 0
        mov      dword [esi+0x35], eax ; side
        

        ; Invert AL to set byte related to what sidebar and speech graphics to load
        cmp     al, 1
        jz      .Set_AL_To_Zero
        
        mov     al, 1
        jmp     .Past_AL_Invert
        
.Set_AL_To_Zero:
            mov     al, 0
        
.Past_AL_Invert:        
        mov BYTE [0x7E2500], al ; For side specific mix files loading and stuff, without sidebar and speech hack


        SpawnINI_Get_Int str_Settings, str_Color, 0
        mov      dword [esi+0x39], eax  ; color


      mov      dword [esi+0x41], -1 
       
      mov      [hp_data.TempPtr], esi 
      lea      eax, [hp_data.TempPtr] 
      push   eax 
      mov      ecx, 0x007E3E90 
      call   0x0044D690 
      retn
      
Add_Human_Opponents:
    ; copy opponents
    XOR ECX,ECX
    mov     DWORD [hp_data.CurrentOpponent], ECX
    
.next_opp:
    MOV     ECX, [hp_data.CurrentOpponent]
    ADD ECX,1
    mov     DWORD [hp_data.CurrentOpponent], ECX
    
    push    ecx
    push    str_OtherSectionFmt  ;Other%d
    push    hp_data.OtherSection
    call    0x006B52EE ; _sprintf
    add     esp, 0x0C
    
    

        push   0x4D 
      call   0x006B51D7 
       
      add     esp, 4 
      
       
      mov      esi, eax 

      lea     ecx, [esi+14h] 
      call   0x004EF040 
      
    
      
                 LEA EAX, [esi]
    SpawnINI_Get_String hp_data.OtherSection, str_Name, str_Empty, EAX, 0x14
    
    LEA EAX, [esi]
    mov eax, [eax]
        TEST EAX,EAX
    ; if no name present for this section, this is the last
    JE .Exit
    
       
        SpawnINI_Get_Int hp_data.OtherSection, str_Side, -1
        mov      dword [esi+0x35], eax ; side 
        
            CMP EAX,-1
    JE .next_opp

        SpawnINI_Get_Int hp_data.OtherSection, str_Color, -1
        mov      dword [esi+0x39], eax  ; color
        
            CMP EAX,-1
    JE .next_opp
     
    mov     eax, 1
    MOV [esi + 0x14 + NetAddress.zero], WORD 0
    
          mov      DWORD [0x007E2458], 4 ; sessiontype Lan
    
    
    LEA EAX, [hp_data.IP_temp]
    SpawnINI_Get_String hp_data.OtherSection, str_IP, str_Empty, EAX, 32
    
    push    hp_data.IP_temp
    mov eax, [hp_data.inet_addr]
    call    eax
    
    MOV [esi + 0x14 + NetAddress.ip], EAX
    
    SpawnINI_Get_Int hp_data.OtherSection, str_Port, 0
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
      
      jmp   .next_opp
.Exit:
      retn
    
    
Import_int_addr:
    PUSH str_wsock32_dll
    CALL [0x006CA16C] ; LoadLibraryA

    PUSH str_inet_addr
    PUSH EAX
    CALL [0x006CA174] ; GetProcAddress

    MOV [hp_data.inet_addr], EAX
    retn

