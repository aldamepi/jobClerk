Attribute VB_Name = "queries_validacion_subobjetivos"
Option Explicit

'
' Definicion de las variables y constantes del modulo
'
' Definir constantes para los nombres de consultas y tablas
Const preCon = "Subobjetivos de: "
Const preTab = "Tab_Sub_"

' El control de la ventana de dialogo
Dim control As Byte

' La variable del bucle for que representa cada uno de los objetivos
Dim obj As Range

' Contador de Queries
Dim counter As Integer

' El resto de los nombres: Consulta, Tabla y cadenas para M
Dim nCon, nTab As String
Dim objFilM, conM As String

' Variables para el crono
Dim dStart, dTime As Double


Sub actualizar_subobjetivos()
'
' Esta es la macro llamada desde la cinta de opciones
'
' Crear_Insetar_Consultas_Subobjetivos Macro
'
' Automatiza la creacion de consultas y su insercion en una tabla que permite crear despues
' las listas de validation desplegables de la tabla tareas.
'
'
'

dStart = Timer

' Seleccionar la ubicacion de las nuevas tablas con sus queries
Sheet7.Range("B3").Select


' Crear un bucle que borra previamente las queries y las tablas
For counter = ActiveWorkbook.Queries.Count To 1 Step -1
    If Left(ActiveWorkbook.Queries.Item(counter).Name, Len(preCon)) = preCon Then
        ' Definir el nombre de la query a borrar
        nCon = ActiveWorkbook.Queries.Item(counter).Name
        ' Borrar la query
        Call borrarConsulta
        ' Definir el nombre de la tabla correspondiente a la query borrada
        nTab = preTab & Right(nCon, Len(nCon) - Len(preCon))
        ' Borrar la tabla
        Call borrarTabla
    End If
Next counter



' Iniciar bucle que crea las tablas de subojetivos y sus nombres para objetivo
For Each obj In Worksheets("Objetivos").ListObjects("Tabla_Objetivos").ListColumns(2).DataBodyRange
    ' Asignar valores a las variables
    nCon = preCon & obj.Value
    objFilM = Chr(34) & obj.Value & Chr(34)
    conM = Chr(34) & nCon & Chr(34)
    nTab = preTab & obj.Value
    
'' Mostrar ventana emergente para controlar la creacion de queries y tablas paso a paso
'    control = MsgBox("Realizando consulta : " & nCon & Chr(13) & _
'        vbNewLine & "¿Desea Continuar?", _
'        vbQuestion + vbYesNo + vbDefaultButton1, "Consultas Subobjetivos")
''    MsgBox "Valor del filtro: " & filtro
'    If control = vbNo Then Exit Sub  'Si se activa este comando produce error en la proxima ejecución.
    

    ActiveWorkbook.Queries.Add Name:=nCon, Formula:= _
        "let" & Chr(13) & "" & Chr(10) & "" _
            & "Source = Excel.CurrentWorkbook(){[Name=""Subobjetivos""]}[Content]," & Chr(13) & "" & Chr(10) & "" _
            & "#""Filtered Rows"" = Table.SelectRows(Source, each ([OBJETIVOS] = " & objFilM & "))," & Chr(13) & "" & Chr(10) & "" _
            & "#""Removed Other Columns"" = Table.SelectColumns(#""Filtered Rows"",{""SUBOBJETIVOS""})," & Chr(13) & "" & Chr(10) & "" _
            & "#""Renamed Columns"" = Table.RenameColumns(#""Removed Other Columns"",{{""SUBOBJETIVOS"", " & objFilM & "}})" & Chr(13) & "" & Chr(10) _
        & "in" & Chr(13) & "" & Chr(10) & "" _
            & "#""Renamed Columns"""
        


    With ActiveSheet.ListObjects.Add(SourceType:=0, Source:= _
        "OLEDB;Provider=Microsoft.Mashup.OleDb.1;Data Source=$Workbook$;Location=" & conM & ";Extended Properties=""""" _
        , Destination:=ActiveCell).QueryTable
        .CommandType = xlCmdSql
        .CommandText = Array("SELECT * FROM [" & nCon & "]")
        .RowNumbers = False
        .FillAdjacentFormulas = False
        .PreserveFormatting = True
        .RefreshOnFileOpen = False
        .BackgroundQuery = True
        .RefreshStyle = xlInsertDeleteCells
        .SavePassword = False
        .SaveData = True
        .AdjustColumnWidth = True
        .RefreshPeriod = 0
        .PreserveColumnInfo = True
        .ListObject.DisplayName = nTab
        .ListObject.ShowAutoFilter = False
        .Refresh BackgroundQuery:=False
    End With
    
    
    Call borrarNombre
    Call crearNombre
    
    ActiveCell.Offset(0, 1).Range("A1").Select

Next

dTime = Timer - dStart

MsgBox "El proceso ha tardado: " & Format(dTime, "0.0") & "segundos.", 1, "Consultas Subobjetivos"

End Sub


Sub borrarConsulta()
'
' borrarConsulta Macro
'
' Llamada desde la macro principal Crear_Insetar_Consultas_Subobjetivos
' Simplemente va borrando las consultas anteriores con el mismo nombre que se generan
' en el bucle for.
'
'

On Error Resume Next
ActiveWorkbook.Queries(nCon).Delete

On Error GoTo 0

'
End Sub


Sub borrarTabla()
'
' EliminarTabla Macro
'
' Llamada desde la macro principal. Similar a borrar consulta pero con las tablas
'


On Error Resume Next
Sheet7.ListObjects(nTab).Range.Clear
On Error GoTo 0

End Sub

Sub borrarNombre()
'
' borrarNombre Macro
'
' Esta macro borra los nombres definidoas previamente que referencian a las tablas borradas.
'


On Error Resume Next
ActiveWorkbook.Names(obj.Value).Delete
On Error GoTo 0

End Sub


Sub crearNombre()
'
' Crear_Nombre Macro
'
' Esta macro crea el nombre para la tabla creada
' con el fin de poder usarlo en las listas de validacion en la tabla tareas.
'



ActiveSheet.ListObjects(nTab).Range.Select
Selection.CreateNames Top:=True, Left:=False, Bottom:=False, Right:=False

End Sub


Sub Crear_Consultas_Subobjetivos()
'
' Crear_Consultas_Subobjetivos Macro
' Automatiza la creaci„n de consultas para las listas desplegables
'

'CODIGO M ORIGINAL
'let
'    Source = Excel.CurrentWorkbook(){[Name="Subobjetivos"]}[Content],
'    #"Changed Type" = Table.TransformColumnTypes(Source,{{"PRIORIDAD", type any}, {"OBJETIVOS", type text}, {"SUBOBJETIVOS", type any}, {"T SUBOBJETIVO SEMANA", type number}, {"OBSERVACIONES", type text}}),
'    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each ([OBJETIVOS] = "Deporte")),
'    #"Removed Other Columns" = Table.SelectColumns(#"Filtered Rows",{"SUBOBJETIVOS"}),
'    #"Renamed Columns" = Table.RenameColumns(#"Removed Other Columns",{{"SUBOBJETIVOS", "SUBOBJETIVOS Deporte"}})
'in
'    #"Renamed Columns"



For Each obj In Worksheets("Objetivos").ListObjects("Tabla_Objetivos").ListColumns(2).DataBodyRange
  
    nCon = preCon & obj.Value
    objFilM = Chr(34) & obj.Value & Chr(34)
    
    MsgBox "Realizando consulta: " & nCon
'    MsgBox "Valor del filtro: " & filtro

    ActiveWorkbook.Queries.Add Name:=nCon, Formula:= _
        "let" & Chr(13) & "" & Chr(10) & "" _
            & "Source = Excel.CurrentWorkbook(){[Name=""Subobjetivos""]}[Content]," & Chr(13) & "" & Chr(10) & "" _
            & "#""Filtered Rows"" = Table.SelectRows(Source, each ([OBJETIVOS] = " & objFilM & "))," & Chr(13) & "" & Chr(10) & "" _
            & "#""Removed Other Columns"" = Table.SelectColumns(#""Filtered Rows"",{""SUBOBJETIVOS""})," & Chr(13) & "" & Chr(10) & "" _
            & "#""Renamed Columns"" = Table.RenameColumns(#""Removed Other Columns"",{{""SUBOBJETIVOS"", " & objFilM & "}})" & Chr(13) & "" & Chr(10) _
        & "in" & Chr(13) & "" & Chr(10) & "" _
            & "#""Renamed Columns"""
        
        
    

Next
    
End Sub



