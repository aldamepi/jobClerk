Attribute VB_Name = "InsertarFila"
Sub InsertarFila()
Attribute InsertarFila.VB_Description = "Insertar fila con el formato de abajo y copiar valores"
Attribute InsertarFila.VB_ProcData.VB_Invoke_Func = "I\n14"
'
' InsertarFila Macro
' Util cuando olvidamos crear el subobjetivo neutro "00 - ".
' Inserta filas en la tabla subobjetivos copiando el formato de la fila inferior.
' Añade el valor "00 - " a la columna de subobjetivos de la fila añadida.
' Insertar fila con el formato de abajo y copiar valores.
'
' IMPORTANTE: Requiere marcar la celda activa manualmente en la columna PRIORIDAD, justo debajo de
' donde se añadirá la filla nueva.
'

'
    Selection.ListObject.ListRows.Add (ActiveCell.Row - 4) 'CopyOrigin:=xlFormatFromRightOrBelow)
    ActiveCell.Offset(1, 0).Range("A1").Select
    ActiveCell.Range("A1:D1").Select
    Selection.Copy
    ActiveCell.Offset(-1, 0).Range("A1").Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    ActiveCell.Offset(0, 3).Range("A1").Select
    ActiveCell.FormulaR1C1 = "00 - "
'    ActiveCell.Offset(1, 0).Range("A1").Select
End Sub
