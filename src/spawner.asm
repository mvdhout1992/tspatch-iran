%macro SpawnINI_Get_Int 3
    push %3 
    push %2
    push %1
    mov ecx, var.INIClass_SPAWN
    call INIClass__GetInt
%endmacro 

%macro SpawnINI_Get_Bool 3
    push %3 
    push %2
    push %1
    mov ecx, var.INIClass_SPAWN
    call INIClass__GetBool
%endmacro
   
%macro SpawnINI_Get_String 5
    push %5
    push %4
    push %3
    push %2
    push %1
    mov ecx, var.INIClass_SPAWN
    call INIClass__GetString
%endmacro

%macro SpawnINI_Get_Fixed 4
    push %4
    push %3 
    push %2
    push %1
    mov ecx, var.INIClass_SPAWN
    call INIClass__GetFixed

%endmacro

@JMP 0x004E1DE0 _Select_Game_Init_Spawner
@JMP 0x00609470 _Send_Statistics_Packet_Return_If_Skirmish
@JMP 0x005E08E3 _Read_Scenario_INI_Assign_Houses_And_Spawner_House_Settings
@JMP 0x004BDDB1 _HouseClass__Make_Ally_STFU_when_Allying_In_Loading_Screen_Spawner
@JMP 0x004E078C _Init_Game_Check_Spawn_Arg_No_Intro

; Inside HouseClass::Mplayer_Defeated skip some checks which makes game continue
; even if there are only allied AI players left, in skirmish
@JMP 0x004BF7B6 0x004BF7BF
@JMP 0x004BF7F0 0x004BF7F9

@JMP 0x005ED477 _sub_5ED470_Dont_Read_Scenario_Descriptions_When_Spawner_Active

@JMP 0x004C06EF _HouseClass__AI_Attack_Stuff_Alliance_Check

@JMP 0x005DE3D7 _Assign_Houses_AI_Countries

@JMP 0x004C3630 _HouseClass__Computer_Paranoid_Disable_With_Spawner

@JMP 0x005DDAF1 _Read_Scenario_INI_Dont_Create_Units_Earlier
@JMP 0x005DDEDD _Read_Scenario_INI_Dont_Create_Units_Earlier_Dont_Create_Twice
@JMP 0x0065860D _UnitClass__Read_INI_Jump_Out_When_Units_Section_Missing
@JMP 0x005DBCC3 _Read_Scenario_Custom_Load_Screen_Spawner
@JMP 0x005DD523 _Read_Scenario_INI_Fix_Spawner_DifficultyMode_Setting

_Read_Scenario_INI_Fix_Spawner_DifficultyMode_Setting:
    cmp dword [var.IsSpawnArgPresent], 0
    jz  .Ret
    
    cmp dword [SessionType], 0
    jnz .Ret

    pushad

    SpawnINI_Get_Int str_Settings, str_DifficultyModeComputer, 1
    push eax
    
    SpawnINI_Get_Int str_Settings, str_DifficultyModeHuman, 1
    
    pop edx
    mov ebx, [ScenarioStuff]
    
    mov dword [ebx+0x60C], edx ; DifficultyModeComputer
    mov dword [ebx+0x608], eax ; DifficultyModeHuman
    mov dword [SelectedDifficulty], eax
    
    popad

.Ret:
    mov eax, dword [SelectedDifficulty]
    mov dword [0x7a2f0c], eax
    mov eax, [ScenarioStuff]
    jmp 0x005DD528

_Read_Scenario_Custom_Load_Screen_Spawner:

    cmp BYTE [var.CustomLoadScreen], 0
    jz .Ret
    
    mov esi, var.CustomLoadScreen

.Ret:
    push 40590000h
    jmp 0x005DBCC8

_UnitClass__Read_INI_Jump_Out_When_Units_Section_Missing:
    cmp eax, ebx
    jle .Jump_Out
    
    jmp 0x00658613
    
.Jump_Out:
    jmp 0x00658A10

_Read_Scenario_INI_Dont_Create_Units_Earlier:
    call 0x0058C980
    
    cmp dword [SessionType], 0
    jz  .Ret
    
    push    0
    push    0x0070CAA8 ; offset aOfficial ; "Official"
    push    0x007020A8 ; offset aBasic   ; "Basic"
    mov     ecx, ebp
    call    INIClass__GetBool
    mov     cl, al
    call    0x005DD290 ; Create_Units(int)

.Ret:
    jmp 0x005DDAF6


_Read_Scenario_INI_Dont_Create_Units_Earlier_Dont_Create_Twice:
    jmp 0x005DDEF8

_HouseClass__Computer_Paranoid_Disable_With_Spawner:
    cmp dword [var.IsSpawnArgPresent], 1
    jz  .Ret

.Normal_Code:
    mov ecx, [HouseClassArray_Count]
    jmp 0x004C3636
    
.Ret:
    jmp 0x004C3700 ; jump to RETN instruction

_Assign_Houses_AI_Countries:
    mov ebp, [HouseClassArray_Count]
    cmp dword [var.HouseCountriesArray+ebp*4], -1
    jz  .Ret
  
    mov ecx, [var.HouseCountriesArray+ebp*4]  
    mov ecx,[edx+ecx*4]
  
.Ret:
    push ecx
    mov ecx, eax
    call 0x004BA0B0 ; HouseClass::HouseClass(HousesType)
    jmp 0x005DE3DF

_HouseClass__AI_Attack_Stuff_Alliance_Check:
    cmp esi, edi
    jz 0x004C0777
    
    push esi
    mov ecx, edi
    call 0x004BDA20 ; HouseClass::Is_Ally
    cmp al, 1
    jz 0x004C0777
    
.Ret:
    jmp 0x004C06F7

_sub_5ED470_Dont_Read_Scenario_Descriptions_When_Spawner_Active:
    cmp dword [var.IsSpawnArgPresent], 1
    jz  .Ret
    
    call SessionClass__Read_Scenario_Descriptions

.Ret:
    call [timeGetTime]
    jmp 0x005ED482

    
Init_Game_Spawner:
    lea eax, [var.UsedSpawnsArray]
    push 32             ; Size
    push 0xFF              ; Val
    push eax             ; Dst
    call memset
    add esp, 0Ch
   
    retn
   
_Init_Game_Check_Spawn_Arg_No_Intro:
    pushad
    
    call Init_Game_Spawner

    call [GetCommandLineA]
    push str_SpawnArg
    push eax
    call stristr_
    add esp, 8
    xor ebx, ebx
    cmp eax, 0  
    setne bl
    mov [var.IsSpawnArgPresent], ebx
    popad
    
    cmp dword [var.IsSpawnArgPresent], 0
    jz .Normal_Code
    
.No_Intro:
    jmp 0x004E0848


.Normal_Code:
    and ecx, 4
    cmp cl, 4
    jmp 0x004E0792


_HouseClass__Make_Ally_STFU_when_Allying_In_Loading_Screen_Spawner:
    cmp byte [var.IsDoingAlliancesSpawner], 1
    jz 0x004BDE68
    test al, al          ; hooked by patch
    jz 0x4BDE68
    jmp 0x004BDDB9

_SessionClass__Free_Scenario_Descriptions_RETN_Patch:
    retn   

_Send_Statistics_Packet_Return_If_Skirmish:
    cmp dword [SessionType], 5
    jz .ret

    sub esp, 374h
    jmp 0x00609476
    
.ret:
    jmp 0x0060A80A ; jump to retn statement

; args <House number>, <ColorType>
%macro Set_House_Color 3
    mov eax, %2
    cmp eax, -1
    jz .Dont_Set_Color_%3
    mov edi, [HouseClassArray] ; HouseClassArray
    mov edi, [edi+%1*4]
    
;    mov dword [edi+0x10DFC], eax
    mov esi, [edi+0x24]
    mov dword [esi+0x6C], eax
    mov dword [edi+10DFCh], eax
    
    push eax
    call Get_MP_Color
    
    mov dword [edi+0x10DFC], eax
    
    mov ecx, edi
    call 0x004CBAA0

.Dont_Set_Color_%3:
%endmacro

; args <House number>, <HouseType>
%macro Set_House_Country 3
    mov eax, %2
    cmp eax, -1
    jz .Dont_Set_Country_%3
    mov edi, [HouseClassArray]
    mov edi, [edi+%1*4]
    
    mov ecx, [HouseTypesArray]
    mov eax, [ecx+eax*4]
    
    mov dword [edi+24h], eax

.Dont_Set_Country_%3:
%endmacro


; args <House number>, <identifier>
%macro Set_Spectator 2
    
    cmp dword [var.IsSpectatorArray+4*%1], 0
    jz .No_Spectator_%2

    mov edi, [HouseClassArray]
    mov edi, [edi+%1*4]
    
    xor eax, eax
    cmp dword [var.IsSpectatorArray+4*%1], 1
    sete al
    
    mov byte [edi+0x0CB], 1

.No_Spectator_%2:
%endmacro

; args <House number>, <DifficultyType>
%macro Set_House_Handicap 3
    mov eax, %2
    cmp eax, -1
    jz .Dont_Set_Handicap_%3
    mov edi, [HouseClassArray]
    mov edi, [edi+%1*4]
    
    push eax
    mov ecx, edi
    call HouseClass__Assign_Handicap ; DiffType HouseClass::Assign_Handicap(DiffType)

.Dont_Set_Handicap_%3:
%endmacro

; args <House number>, <House number to ally>
%macro House_Make_Ally 3
    mov eax, %2
    cmp eax, -1
    jz .Dont_Make_Ally_%3
    mov esi, [HouseClassArray] ; HouseClassArray
    mov edi, [esi+4*%1]
    
    push eax
    mov ecx, edi
    call HouseClass__Make_Ally
    
;    mov eax, [esi+4*eax]
    
    
;    mov esi, [edi+0x578]
;    mov ecx, [eax+0x20]
    
;    mov eax, 1
;    shl eax, cl
;    or  esi, eax
;    mov [edi+0x578], esi


.Dont_Make_Ally_%3:
%endmacro

; args <string of section to load from>, <House number which will ally>
%macro  House_Make_Allies_Spawner 3
    SpawnINI_Get_Int %1, str_HouseAllyOne, -1
    cmp al, -1
    jz .Dont_Ally_Multi1_%3
    House_Make_Ally %2, eax, a%3
    
.Dont_Ally_Multi1_%3:

    SpawnINI_Get_Int %1, str_HouseAllyTwo, -1
    cmp al, -1
    jz .Dont_Ally_Multi2_%3
    House_Make_Ally %2, eax, b%3
    
.Dont_Ally_Multi2_%3:

    SpawnINI_Get_Int %1, str_HouseAllyThree, -1
    cmp al, -1
    jz .Dont_Ally_Multi3_%3
    House_Make_Ally %2, eax, c%3
    
.Dont_Ally_Multi3_%3:

    SpawnINI_Get_Int %1, str_HouseAllyFour, -1
    cmp al, -1
    jz .Dont_Ally_Multi4_%3
    House_Make_Ally %2, eax, d%3
    
.Dont_Ally_Multi4_%3:

    SpawnINI_Get_Int %1, str_HouseAllyFive, -1
    cmp al, -1
    jz .Dont_Ally_Multi5_%3
    House_Make_Ally %2, eax, e%3
    
.Dont_Ally_Multi5_%3:

    SpawnINI_Get_Int %1, str_HouseAllySix, -1
    cmp al, -1
    jz .Dont_Ally_Multi6_%3
    House_Make_Ally %2, eax, f%3
    
.Dont_Ally_Multi6_%3:

    SpawnINI_Get_Int %1, str_HouseAllySeven, -1
    cmp al, -1
    jz .Dont_Ally_Multi7_%3
    House_Make_Ally %2, eax, g%3
    
.Dont_Ally_Multi7_%3:
%endmacro

Load_House_Countries_Spawner:
    SpawnINI_Get_Int str_HouseCountries, str_Multi1, -1
    mov dword [var.HouseCountriesArray+0], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi2, -1
    mov dword [var.HouseCountriesArray+4], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi3, -1
    mov dword [var.HouseCountriesArray+8], eax
      
    SpawnINI_Get_Int str_HouseCountries, str_Multi4, -1
    mov dword [var.HouseCountriesArray+12], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi5, -1
    mov dword [var.HouseCountriesArray+16], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi6, -1
    mov dword [var.HouseCountriesArray+20], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi7, -1
    mov dword [var.HouseCountriesArray+24], eax
    
    SpawnINI_Get_Int str_HouseCountries, str_Multi8, -1
    mov dword [var.HouseCountriesArray+28], eax

    retn

Load_House_Colors_Spawner:
    SpawnINI_Get_Int str_HouseColors, str_Multi1, -1
    mov dword [var.HouseColorsArray+0], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi2, -1
    mov dword [var.HouseColorsArray+4], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi3, -1
    mov dword [var.HouseColorsArray+8], eax
      
    SpawnINI_Get_Int str_HouseColors, str_Multi4, -1
    mov dword [var.HouseColorsArray+12], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi5, -1
    mov dword [var.HouseColorsArray+16], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi6, -1
    mov dword [var.HouseColorsArray+20], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi7, -1
    mov dword [var.HouseColorsArray+24], eax
    
    SpawnINI_Get_Int str_HouseColors, str_Multi8, -1
    mov dword [var.HouseColorsArray+28], eax

    retn

Load_Spawn_Locations_Spawner:
    SpawnINI_Get_Int str_SpawnLocations, str_Multi1, -1
    mov dword [var.SpawnLocationsArray+0], eax
    
    SpawnINI_Get_Int str_SpawnLocations, str_Multi2, -1
    mov dword [var.SpawnLocationsArray+4], eax
    
    SpawnINI_Get_Int str_SpawnLocations, str_Multi3, -1
    mov dword [var.SpawnLocationsArray+8], eax
      
    SpawnINI_Get_Int str_SpawnLocations, str_Multi4, -1
    mov dword [var.SpawnLocationsArray+12], eax
    
    SpawnINI_Get_Int str_SpawnLocations, str_Multi5, -1
    mov dword [var.SpawnLocationsArray+16], eax
    
    SpawnINI_Get_Int str_SpawnLocations, str_Multi6, -1
    mov dword [var.SpawnLocationsArray+20], eax
    
    SpawnINI_Get_Int str_SpawnLocations, str_Multi7, -1
    mov dword [var.SpawnLocationsArray+24], eax
    
    SpawnINI_Get_Int str_SpawnLocations, str_Multi8, -1
    mov dword [var.SpawnLocationsArray+28], eax

    retn   

Load_House_Handicaps_Spawner:
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi1, -1
    mov dword [var.HouseHandicapsArray+0], eax
   
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi2, -1
    mov dword [var.HouseHandicapsArray+4], eax
   
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi3, -1
    mov dword [var.HouseHandicapsArray+8], eax
    
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi4, -1
    mov dword [var.HouseHandicapsArray+12], eax
    
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi5, -1
    mov dword [var.HouseHandicapsArray+16], eax
    
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi6, -1
    mov dword [var.HouseHandicapsArray+20], eax
    
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi7, -1
    mov dword [var.HouseHandicapsArray+24], eax
    
    SpawnINI_Get_Int str_HouseHandicaps, str_Multi8, -1
    mov dword [var.HouseHandicapsArray+28], eax

    retn
   
_Read_Scenario_INI_Assign_Houses_And_Spawner_House_Settings:
    pushad
    call Assign_Houses
    
    cmp dword [var.SpawnerActive], 0
    jz  .Ret
    
;    Set_House_Country 0, dword [var.HouseCountriesArray+0], a
;    Set_House_Country 1, dword [var.HouseCountriesArray+4], b
;    Set_House_Country 2, dword [var.HouseCountriesArray+8], c
;    Set_House_Country 3, dword [var.HouseCountriesArray+12], d
;    Set_House_Country 4, dword [var.HouseCountriesArray+16], e
;    Set_House_Country 5, dword [var.HouseCountriesArray+20], f
;    Set_House_Country 6, dword [var.HouseCountriesArray+24], g
;    Set_House_Country 7, dword [var.HouseCountriesArray+28], h
    
    Set_House_Color 0, dword [var.HouseColorsArray+0], a
    Set_House_Color 1, dword [var.HouseColorsArray+4], b
    Set_House_Color 2, dword [var.HouseColorsArray+8], c
    Set_House_Color 3, dword [var.HouseColorsArray+12], d
    Set_House_Color 4, dword [var.HouseColorsArray+16], e
    Set_House_Color 5, dword [var.HouseColorsArray+20], f
    Set_House_Color 6, dword [var.HouseColorsArray+24], g
    Set_House_Color 7, dword [var.HouseColorsArray+28], h
        
    mov byte [var.IsDoingAlliancesSpawner], 1
    
    House_Make_Allies_Spawner str_Multi1_Alliances, 0, a
    House_Make_Allies_Spawner str_Multi2_Alliances, 1, b
    House_Make_Allies_Spawner str_Multi3_Alliances, 2, c
    House_Make_Allies_Spawner str_Multi4_Alliances, 3, d
    House_Make_Allies_Spawner str_Multi5_Alliances, 4, e
    House_Make_Allies_Spawner str_Multi6_Alliances, 5, f
    House_Make_Allies_Spawner str_Multi7_Alliances, 6, g
    House_Make_Allies_Spawner str_Multi8_Alliances, 7, h
    
    mov byte [var.IsDoingAlliancesSpawner], 0
    
    Set_House_Handicap 0, dword [var.HouseHandicapsArray+0], a
    Set_House_Handicap 1, dword [var.HouseHandicapsArray+4], b
    Set_House_Handicap 2, dword [var.HouseHandicapsArray+8], c
    Set_House_Handicap 3, dword [var.HouseHandicapsArray+12], d
    Set_House_Handicap 4, dword [var.HouseHandicapsArray+16], e
    Set_House_Handicap 5, dword [var.HouseHandicapsArray+20], f
    Set_House_Handicap 6, dword [var.HouseHandicapsArray+24], g
    Set_House_Handicap 7, dword [var.HouseHandicapsArray+28], h
    
    Set_Spectator 0, a
    Set_Spectator 1, b
    Set_Spectator 2, c
    Set_Spectator 3, d
    Set_Spectator 4, e
    Set_Spectator 5, f
    Set_Spectator 6, g
    Set_Spectator 7, h
    
.Ret:  
    popad
    jmp 0x005E08E8

Load_SPAWN_INI:
%push
    push ebp
    mov ebp,esp
    sub esp,128

%define TempFileClass ebp-128

    ; initialize FileClass
    push str_spawn_ini
    lea ecx, [TempFileClass]
    call FileClass__FileClass

    ; check ini exists
    lea ecx, [TempFileClass]
    xor edx, edx
    push edx
    call FileClass__Is_Available
    test al, al
    je .error

    ; initialize INIClass
    mov ecx, var.INIClass_SPAWN
    call INIClass__INIClass

    ; load FileClass to INIClass
    push 0
    push 0
    lea eax, [TempFileClass]
    push eax
    Mov ecx, var.INIClass_SPAWN
    call INIClass__Load
    
    mov eax, 1
    jmp .exit

.error:
    mov eax, 0
.exit:
    mov esp,ebp
    pop ebp
    retn
%pop

Initialize_Spawn:
%push
    push ebp
    mov ebp,esp
    sub esp,128

%define TempBuf     ebp-128

    
    cmp dword [var.IsSpawnArgPresent], 0
    je .Exit_Error
    
    cmp dword [var.SpawnerActive], 1
    jz .Ret_Exit
    
    mov dword [var.SpawnerActive], 1
    mov dword [var.PortHack], 1 ; default enabled
    
    call Load_SPAWN_INI
    cmp eax, 0
    jz .Exit_Error
   
    ; get pointer to inet_addr
    push str_wsock32_dll
    call [LoadLibraryA]

    push str_inet_addr
    push eax
    call [GetProcAddress]

    mov [var.inet_addr], eax
    
    call Load_House_Colors_Spawner
    call Load_House_Countries_Spawner
    call Load_House_Handicaps_Spawner
    call Load_Spawn_Locations_Spawner
    call Load_Spectators_Spawner
    
    mov byte [GameActive], 1 ; needs to be set here or the game gets into an infinite loop trying to create spawning units

    ; set session 
    mov dword [SessionType], 5
       
    SpawnINI_Get_Int str_Settings, str_UnitCount, 1
    mov dword [UnitCount], eax
      
    SpawnINI_Get_Int str_Settings, str_TechLevel, 10
    mov dword [TechLevel], eax
      
    SpawnINI_Get_Int str_Settings, str_AIPlayers, 0
    mov dword [AIPlayers], eax
   
    SpawnINI_Get_Int str_Settings, str_AIDifficulty, 1   
    mov dword [AIDifficulty], eax
      
    SpawnINI_Get_Bool str_Settings, str_HarvesterTruce, 0
    mov byte [HarvesterTruce], al
      
    SpawnINI_Get_Bool str_Settings, str_BridgeDestroy, 1 
    mov byte [BridgeDestroy], al
      
    SpawnINI_Get_Bool str_Settings, str_FogOfWar, 0
    mov byte [FogOfWar], al
    
    SpawnINI_Get_Bool str_Settings, str_BuildOffAlly, 0
    mov byte [var.BuildOffAlly], al
 
    SpawnINI_Get_Bool str_Settings, str_Crates, 0
    mov byte [Crates], al
     
    SpawnINI_Get_Bool str_Settings, str_ShortGame, 0
    mov byte [ShortGame], al     
  
    SpawnINI_Get_Bool str_Settings, str_Bases, 1
    mov byte [Bases], al      
    
    SpawnINI_Get_Bool str_Settings, str_AlliesAllowed, 1
    mov byte [AlliesAllowed], al
 
    SpawnINI_Get_Bool str_Settings, str_MCVRedeploy, 1
    mov byte [MCVRedeploy], al   
      
    SpawnINI_Get_Int str_Settings, str_Credits, 10000
    mov dword [Credits], eax   
      
    SpawnINI_Get_Int str_Settings, str_GameSpeed, 0
    mov dword [GameSpeed], eax
     
    SpawnINI_Get_Bool str_Settings, str_MultiEngineer, 0
    mov byte [MultiEngineer], al
         
    lea eax, [var.CustomLoadScreen]
    SpawnINI_Get_String str_Settings, str_CustomLoadScreen, str_Empty, eax, 256
    
    ; tunnel ip
    lea eax, [TempBuf]
    SpawnINI_Get_String str_Tunnel, str_Ip, str_Empty, eax, 32

    lea eax, [TempBuf]
    push eax
    call [var.inet_addr]
    mov [var.TunnelIp], eax

    ; tunnel port
    SpawnINI_Get_Int str_Tunnel, str_Port, 0
    and eax, 0xffff
    push eax
    call htonl
    mov [var.TunnelPort], eax

    ; tunnel id 
    SpawnINI_Get_Int str_Settings, str_Port, 0
    and eax, 0xffff
    push eax
    call htonl
    mov [var.TunnelId], eax

    cmp dword [var.TunnelPort],0
    jne .nosetport
    SpawnINI_Get_Int str_Settings, str_Port, 1234
    mov word [ListenPort], ax
.nosetport:
     
    SpawnINI_Get_Bool str_Settings, str_Firestorm, 0
    
    cmp al, 0
    jz .No_Firestorm
    
    ; Firestorm related variables
    mov dword [0x006F2638], 3 ; FIXME: name this
    mov dword [0x006F263C], 3 ; FIXME: name this
    
.No_Firestorm:
    
    mov ecx, SessionClass_this
    call SessionClass__Read_Scenario_Descriptions
        
    ; scenario
    lea eax, [ScenarioName]
    SpawnINI_Get_String str_Settings, str_Scenario, str_Empty, eax, 32

;    push str_gcanyonmap
;    push 0x007E28B0 ; map buffer used by something
;    call 0x006BE630 ; strcpy
;    add esp, 8

    call Add_Human_Player
    call Add_Human_Opponents
    
    SpawnINI_Get_Bool str_Settings, str_IsSinglePlayer, 0
    cmp al, 0
    jz .Not_Single_Player
    
    mov dword [SessionType], 0 ; single player
       
.Not_Single_Player:
        
    ; Needs to be done after SessionClass is set, or the seed value will be overwritten
    ; inside the Init_Random() call if sessiontype == SKIRMISH
    SpawnINI_Get_Int str_Settings, str_Seed, 0
    mov dword [Seed], eax
    call Init_Random
    
    ; Initialize networking
    
    push 35088h
    call new
    add esp, 4
    
    mov ecx, eax
    call UDPInterfaceClass__UDPInterfaceClass
    
    mov [WinsockInterface_this], eax
    
    mov ecx, [WinsockInterface_this]
    call WinsockInterfaceClass__Init
    
    push 0
    mov ecx, [WinsockInterface_this]
    call UDPInterfaceClass__Open_Socket
    
    mov ecx, [WinsockInterface_this]
    call WinsockInterfaceClass__Start_Listening
    
    mov ecx, [WinsockInterface_this]
    call WinsockInterfaceClass__Discard_In_Buffers
    
    mov ecx, [WinsockInterface_this]
    call WinsockInterfaceClass__Discard_Out_Buffers
    
    mov ecx, IPXManagerClass_this
    push 1
    push 258h
    push 0FFFFFFFFh
    push 3Ch
    call IPXManagerClass__Set_Timing

    ; WOL settings
 ;   mov dword [MaxAhead], 40
 ;   mov dword [FrameSendRate], 10
   
    mov dword [MaxAhead], 20
    mov dword [FrameSendRate], 4
    
    mov dword [MaxMaxAhead], 0
    mov dword [LatencyFudge], 0
    mov dword [RequestedFPS], 60
    mov dword [ProtocolVersion], 2

    call Init_Network
    
    mov dword eax, [NameNodes_CurrentSize]
    mov dword [HumanPlayers], eax
    
    SpawnINI_Get_Bool str_Settings, str_LoadSaveGame, 0
    cmp al, 0
    jz  .Dont_Load_Savegame
    
    lea eax, [var.SaveGameNameBuf]
    SpawnINI_Get_String str_Settings, str_SaveGameName, str_Empty, eax, 60
 
    mov byte [0x7E48FC], 0
    mov byte [0x7E4040], 0
    lea ecx, [var.SaveGameNameBuf]
    call Load_Game
    
    jmp .Dont_Load_Scenario
   
.Dont_Load_Savegame:

    ; need to supply different args to Start_Scenario() for single player
    cmp dword [SessionType], 0
    jnz .Start_Scenario_NOT_Singleplayer

    ; start scenario for singleplayer
    push 0
    mov edx, 1
    mov ecx, ScenarioName
    call Start_Scenario
    
    jmp .Past_Start_Scenario
    
.Start_Scenario_NOT_Singleplayer:
    
    ; start scenario for multiplayer
    push -1 
    xor edx, edx 
    mov ecx, ScenarioName
    call Start_Scenario

.Past_Start_Scenario:    
    
    ; modify some RulesClass (RULES.INI stuff) settings
    mov esi, [0x0074C488] ; RulesClass pointer

    ; Load MultipleFactory from SPAWN.INI if not missing
    ; Else use the value already loaded from a RULES.INI file
    SpawnINI_Get_Fixed str_Settings, str_MultipleFactory, dword [esi+2B0h], dword [esi+2B4h]
    fstp qword [esi+2B0h]
    
    ; THIS ONE DOESN'T SEEM TO WORK
;    mov byte [esi+0F48h], 0 ; Disable Paranoid RulesClass setting
    
.Dont_Load_Scenario:

    ; HACK: If SessonType was set to WOL then set it to LAN now
    ; We had to set SessionType to WOL to make sure players connect
    ; while Start_Scenario was being executed
    
    cmp dword [SessionType], 4
    jnz .Dont_Set_SessionType_To_Lan
    
    mov dword [SessionType], 3 
      
.Dont_Set_SessionType_To_Lan:

    mov ecx, SessionClass_this
    call SessionClass__Create_Connections
      
    mov ecx, IPXManagerClass_this
    push 1
    push 258h
    push 0FFFFFFFFh
    push 3Ch
    call IPXManagerClass__Set_Timing
       
    call 0x00462C60 ; FIXME: name this and everything below
       
    mov ecx, [WWMouseClas_Mouse] 
    mov edx, [ecx] 
    call dword [edx+0Ch] 
       
    mov ecx, [0x0074C5DC] 
    push 0 
    mov eax, [ecx] 
    call dword [eax+18h] 
       
    push 0 
    mov cl, 1 
    mov edx, [0x0074C5DC] 
    call 0x004B96C0 
       
    mov ecx, [WWMouseClas_Mouse] 
    mov edx, [ecx] 
    call dword [edx+10h] 
       
    mov eax, [0x0074C5DC] 
    mov [0x0074C5E4], eax 
       
    push 0 
    push 13h 
    mov ecx, MouseClass_Map 
    call 0x00562390 
       
    mov ecx, MouseClass_Map 
    call 0x005621F0 
       
    push 1 
    mov ecx, MouseClass_Map 
    call 0x005F3E60 
       
    push 0 
    mov ecx, MouseClass_Map 
    call 0x004B9440 
       
    call 0x00462C60 
     
;; Hide mouse, shouldn't be needed and makes mouse invisible in the match if it's there.
;    mov ecx, [0x0074C8F0] 
;    mov edx, [ecx] 
;    call dword [edx+0Ch]
   
.Ret:   
    mov eax, 1
    jmp .exit
.Ret_Exit:
    mov eax, 0
    jmp .exit
.Exit_Error:
    mov eax, -1
    jmp .exit

.exit:
    mov esp,ebp
    pop ebp
    retn
%pop

_Select_Game_Init_Spawner:
    push ebx
    call Initialize_Spawn
    cmp eax,-1
    pop ebx
    ; if spawn not initialized, go to main menu
    je .Normal_Code
    
    retn
   
.Normal_Code:   
    mov ecx, [WWMouseClas_Mouse]
    sub esp, 1ACh
    mov eax, [ecx]
    push ebx
    push ebp
    push esi
    push edi
    jmp 0x004E1DF2
    
Add_Human_Player:      
%push
    push ebp
    mov ebp,esp
    sub esp,4

%define TempPtr ebp-4

    push 0x4D 
    call new
       
    add esp, 4 
       
    mov esi, eax 

    lea ecx, [esi+14h] 
    call IPXAddressClass__IPXAddressClass 

    lea eax, [esi]
    SpawnINI_Get_String str_Settings, str_Name, str_Empty, eax, 0x14

;    lea ecx,  
;    push str_debugplayer 
;    push ecx 
;    call 0x006BE630 ; strcpy     
;    add esp, 8 
       
    ; Player side
    SpawnINI_Get_Int str_Settings, str_Side, 0
    mov dword [esi+0x35], eax ; side
    push eax
    
    ; Sidebar hack for mods which add new sides and new sidebars for them
    ; this will not fuck invert al which is needed for normal TS sidebar loading
    ; as GDI needs 1 and Nod 0 for sidebar (which is the opposite of their side index)
    SpawnINI_Get_Bool str_Settings, str_SidebarHack, 0
    cmp al, 1
    pop eax
    jz  .Sidebar_Hack

    ; Invert AL to set byte related to what sidebar and speech graphics to load
    cmp al, 1
    jz .Set_AL_To_Zero
        
    mov al, 1
    jmp .Past_AL_Invert
        
.Set_AL_To_Zero:
    mov al, 0
        
.Past_AL_Invert:
.Sidebar_Hack:     
    mov byte [0x7E2500], al ; For side specific mix files loading and stuff, without sidebar and speech hack
    mov ebx, [ScenarioStuff]
    mov byte [ebx+1D91h], al

    SpawnINI_Get_Int str_Settings, str_Color, 0
    mov dword [esi+0x39], eax  ; color
    mov dword [PlayerColor], eax

    mov dword [esi+0x41], -1 
       
    mov [TempPtr], esi 
    lea eax, [TempPtr] 
    push eax 
    mov ecx, NameNodeVector
    call NameNodeVector_Add

    mov esp,ebp
    pop ebp
    retn
%pop
      
Add_Human_Opponents:
%push
    push ebp
    mov ebp,esp
    sub esp,128+128+4+4

%define TempBuf         ebp-128
%define OtherSection    ebp-128-128
%define TempPtr         ebp-128-128-4
%define CurrentOpponent ebp-128-128-4-4

    ; copy opponents
    xor ecx,ecx
    mov dword [CurrentOpponent], ecx
    
.next_opp:
    mov ecx, [CurrentOpponent]
    add ecx,1
    mov dword [CurrentOpponent], ecx

    push ecx
    push str_OtherSectionFmt ; Other%d
    lea eax, [OtherSection]
    push eax
    call _sprintf
    add esp, 0x0C
    
    push 0x4D 
    call new
    add esp, 4 
      
    mov esi, eax 
    lea ecx, [esi+14h] 
    call IPXAddressClass__IPXAddressClass
      
    lea eax, [esi]
    lea ecx, [OtherSection]
    SpawnINI_Get_String ecx, str_Name, str_Empty, eax, 0x14
    
    lea eax, [esi]
    mov eax, [eax]
    test eax, eax
    ; if no name present for this section, this is the last
    je .Exit
    
    lea ecx, [OtherSection]
    SpawnINI_Get_Int ecx, str_Side, -1
    mov dword [esi+0x35], eax ; side 
        
    cmp eax,-1
    je .next_opp

    lea ecx, [OtherSection]
    SpawnINI_Get_Int ecx, str_Color, -1
    mov dword [esi+0x39], eax ; color
        
    cmp eax,-1
    je .next_opp
     
    mov eax, 1
    mov dword [SessionType], 4 ; HACK: SessonType set to WOL, will be set to LAN later

    ; set addresses to indexes for send/receive hack
    mov [esi + 0x14 + SpawnAddress.pad1], word 0
    mov ecx, dword [CurrentOpponent]
    mov [esi + 0x14 + SpawnAddress.id], ecx
    mov [esi + 0x14 + SpawnAddress.pad2], word 0

    lea eax, [TempBuf]
    lea ecx, [OtherSection]
    SpawnINI_Get_String ecx, str_Ip, str_Empty, eax, 32
    
    lea eax, [TempBuf]
    push eax
    call [var.inet_addr]
    
    mov ecx, dword [CurrentOpponent]
    dec ecx
    mov [ecx * ListAddress_size + var.AddressList + ListAddress.ip], eax
    
    lea ecx, [OtherSection]
    SpawnINI_Get_Int ecx, str_Port, 0
    and eax, 0xffff

    push eax
    call htonl
    shr eax,16

    ; disable PortHack if different port than own
    cmp ax, [ListenPort]
    je .samePort
    mov dword [var.PortHack], 0    
.samePort:

    mov ecx, dword [CurrentOpponent]
    dec ecx
    mov [ecx * ListAddress_size + var.AddressList + ListAddress.port], ax

    mov dword [esi+0x41], -1 
    
    mov byte [esi+0x1E], 1
       
    mov [TempPtr], esi 
    lea eax, [TempPtr] 
    push eax 
    mov ecx, NameNodeVector ; FIXME: name this
    call NameNodeVector_Add ; FIXME: name this
      
    jmp .next_opp
.Exit:
    mov esp,ebp
    pop ebp
    retn
%pop
