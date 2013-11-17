@HOOK   0x00509D2F  _Message_Input_Display_Messages_Typed_By_Yourself

str_message_fmt: db "%s: %s"
msg_buf: TIMES 512 db 0

_Message_Input_Display_Messages_Typed_By_Yourself:

    mov     ecx, edx
    and     ecx, 3
    rep movsb
    
; Create <player name>: <message> string
    mov     esi, 0x007E36AE ; text to sent
    push    esi
    mov     esi, [0x007E2284] ; PlayerPtr
    lea     esi, [esi+10DE4h] ; our name
    push    esi
    push    str_message_fmt ; %s: %s
;   push    msg_buf ; dest
    push    0x007E36F4 ; HACK to bypass msg_buf write access violation
    call    0x006B52EE ; _sprintf
    add     esp, 10h

; Calculate message duration
    mov     eax, [0x0074C488] ; eax, RulesClass?
    fld     qword [eax+0C68h]
    fmul    qword [0x006CB1B8]
    call    0x006B2330 ; Get_Message_Delay_Or_Duration?
    
; Push arguments

    push    eax ; Message delay/duration 
    push    4046h ; Very likely TextPrintType 
    mov     ecx, 0x007E2C34 ; offset MessageListClass_MessageList
    mov     edx, [0x007E2284] ; PlayerPtr
    mov     edx, [edx+10DFCh]
    push    edx ; Color to use?
;   push    msg_buf ; text to display
    push    0x007E36F4 ; HACK to bypass msg_buf write access violation
    push    0 
    push    0 
    call    0x00572FE0 ;  MessageListClass__Add_Message
    
.Ret:
    jmp     0x00509D36