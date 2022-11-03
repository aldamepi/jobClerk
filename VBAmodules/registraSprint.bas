Attribute VB_Name = "registraSprint"
Sub registraSprint()
Attribute registraSprint.VB_ProcData.VB_Invoke_Func = " \n14"
'
' RegistraSprint Macro
'
' Copia el sprint de subobjetivos definidos en la tabla subobjetivos al final de la tabla Registro de Sprints
'
'

Dim control As Byte
    
    hojaSprints.ListObjects("Tab_RegSprints").HeaderRowRange.Select
    
    Selection.End(xlDown).Select
    ActiveCell.Offset(1, 1).Range("A1").Select
    
    Range("Subobjetivos[[N SPRINT]:[T SUBOBJETIVO SEMANA]]").Copy
    
    ActiveCell.PasteSpecial Paste:=xlPasteAllUsingSourceTheme
    
    Application.CutCopyMode = False
    
    
End Sub
