#Persistent  ; Keep the script running until the user exits it.
#SingleInstance force  ;he word FORCE skips the dialog box and replaces the old instance automatically


NomeProgramma := "myPulsewayExec"
Versione := "2.0"
Installato := 0
DirProgrammaAvvio := "C:\myScriptRUN\"
RegRun :="Software\Microsoft\Windows\CurrentVersion\Run"
PathReg := ""



Menu, Tray, NoStandard
Menu, Tray, Tip, %NomeProgramma%

;Tray Menu
Menu, mOpzioni, Add, Avvio Automatico, AvvioAutomaticoToogle
Menu, mOpzioni, Add, Info, InfoTool
Menu, Tray, Add, Opzioni, :mOpzioni
Menu, Tray, Add  ; Add a separator line.


Menu, Tray, Add,Esci,ChiudiApp

;funzione check avvio
checkAvvioAutomatico()

;avvio subito
AvviaPlex()


if A_Args.Length() > 0
{
    ;MsgBox % "This script requires at least 3 parameters but it only received " A_Args.Length() "."
    ;MsgBox % "val " A_Args[1] "."
   
   
    ;start Plex gui
    if A_Args[1] == 1
    {
        ;MsgBox % "val " A_Args[1] 
        AvviaPlex()
    }
    
    
    ;start TeamViewer
    if A_Args[1] == 2
    {
        AvviaTeamV()
    }
    
    ;start radmin
    if A_Args[1] == 3
    {
        ;AvviaTeamV()
    }
    
   
}

;esco da tray icon
ChiudiApp()
return



AvviaPlex(){
    FileT := "Plex Media Server.exe"
    PathLocal := "S:\PlexDir\"
    mycmd := PathLocal . "\" . FileT
	Run , %mycmd%,, hide  
}
return

AvviaCalc(){
    FileT := "calc.exe"
    PathLocal := "C:\Windows\system32\"
    mycmd := PathLocal . "\" . FileT
	Run , %mycmd%,, hide    
}
return


ManualeAvviaCalc:
{
    AvviaCalc()
}
return


AvviaTeamV(){
	FileT := "TeamViewer.exe"
	RegRead, PathLocal, HKEY_LOCAL_MACHINE, SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeamViewer, InstallLocation
	mycmd := PathLocal . "\" . FileT
	Run , %mycmd%,, hide
}
return

ManualeAvviaTeamV:
{
    AvviaTeamV()
}
return










;impostazioni app

;imposta la spunta se attivo e cambia booleano per rimuoverlo
checkAvvioAutomatico()
{
    global Installato
    global NomeProgramma
    global PathReg
    global RegRun
    
    RegRead, valtest, HKEY_CURRENT_USER, %RegRun%, %NomeProgramma%
    ;se esiste il path allora e' installato e metto spunta sul menu e bool true
   if (valtest <> "") ;se non e blank
    {
        Installato :=1
        Menu, mOpzioni, Check, Avvio Automatico
        PathReg := valtest
    }
}
return


TrayMess(var1,var2)
{
	TrayTip, %var1%,%var2%, 800
	
}
return

AvvioAutomaticoToogle:
{
    global Installato
    global DirProgrammaAvvio
    global NomeProgramma
    global RegRun
    
    ;se non e' installato allora copio il file nella dir
    ;aggiungo il registro per avvio automatico
    if (Installato = 0){
        Menu, mOpzioni, Check, Avvio Automatico
        Installato:=1
        
        ;se non esiste dir la creo
        IfNotExist, %DirProgrammaAvvio%
        {
            
            FileCreateDir, %DirProgrammaAvvio%
        }
        ;copio file corrente
        FileCopy, %A_ScriptDir%\%A_ScriptName%, %DirProgrammaAvvio%, 1
        ;aggiungo reg
        RegWrite, REG_SZ, HKEY_CURRENT_USER, %RegRun%, %NomeProgramma%, "%DirProgrammaAvvio%%A_ScriptName%"
        TrayMess(NomeProgramma,"Aggiunto all'avvio automatico")

    }
    else if (Installato = 1){
        ;se gia installato allora rimuovo avvio automatico
         Installato := 0   
         Menu, mOpzioni, UnCheck, Avvio Automatico
         RegDelete, HKEY_CURRENT_USER, %RegRun% , %NomeProgramma%
         
    }
    
    
    
    
}
return

InfoTool:
{
    global Installato
    global DirProgrammaAvvio
    global NomeProgramma
    global Versione
    global PathReg
    global RegRun
    
    ;re-check in caso
    checkAvvioAutomatico()
    if (Installato = 0)
    {
        MsgBox, 64, %NomeProgramma%, %NomeProgramma% v%Versione%`n`nLocalPath: %A_ScriptDir% `n`nRunPath: -`n`nRunReg: -`n`nRunRegValue: - 
    }
    else
    {
    MsgBox, 64, %NomeProgramma%, %NomeProgramma% v%Versione%`n`nLocalPath: %A_ScriptDir% `n`nRunPath: %DirProgrammaAvvio%`n`nRunReg: HKEY_CURRENT_USER\`n%RegRun% `n`nRunRegValue: %PathReg% 
    }
}
return








ChiudiApp(){
ExitApp
return
}