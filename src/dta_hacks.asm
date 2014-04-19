@JMP 0x005D7E96 _Read_SaveFile_Binary_Hack_Save_Games_Sub_Directory
@JMP 0x00505503 _Get_SaveFile_Info_Save_Game_Folder_Format_String_Change
@JMP 0x00505859 _sub_505840_Save_Game_Folder_Format_String_Change
@JMP 0x005D693C _Load_Game_Save_Game_Folder_Format_String_Change1
@JMP 0x0050528E _sub505270_Save_Game_Folder_Format_String_Change
@JMP 0x00504FFB _LoadOptionsClass__Process_Save_Game_Folder_Format_String_Change

_LoadOptionsClass__Process_Save_Game_Folder_Format_String_Change:
    push    str_SaveGameFolderFormat2
    jmp     0x00505000

_sub505270_Save_Game_Folder_Format_String_Change:
    push    str_SaveGameFolderFormat2
    jmp     0x00505293

_Load_Game_Save_Game_Folder_Format_String_Change1:
    lea     eax, [esp+0x24]

    pushad
     
    push    esi
    push    str_SaveGameLoadFolder
    push    var.SaveGameLoadPath   
    call    [0x006CA464] ; WsSprintf
    add     esp, 0x0c
    
    popad
    
    mov     esi, var.SaveGameLoadPath  
    push    40h
    jmp     0x005D6942

_sub_505840_Save_Game_Folder_Format_String_Change:
    push    str_SaveGameFolderFormat
    jmp     0x0050585E

_Get_SaveFile_Info_Save_Game_Folder_Format_String_Change:
    push    str_SaveGameFolderFormat
    jmp     0x00505508

_Read_SaveFile_Binary_Hack_Save_Games_Sub_Directory:
    push    esi

    pushad
   
    push    ecx
    push    str_SaveGameLoadFolder
    push    var.SaveGameLoadPath   
    call    [0x006CA464] ; WsSprintf
    add     esp, 0x0c
    
    popad
    
    mov     ecx, var.SaveGameLoadPath
     
    lea     eax, [esp+8]
    jmp     0x005D7E9B