Attribute VB_Name = "CreateBorder"
Option Explicit

Sub Auto_Open()

    Dim rRng As Range
    
    Dim lastrow As Integer
    Dim lastcol As Integer
    lastrow = ActiveSheet.UsedRange.Rows.Count
    lastcol = Cells(6, Columns.Count).End(xlToLeft).Column

    Set rRng = Sheet1.Range(Cells(7, 25), Cells(lastrow, lastcol))
    
    rRng.BorderAround xlContinuous
    rRng.Borders(xlInsideHorizontal).Color = RGB(196, 189, 151)
    rRng.Borders(xlInsideVertical).Color = RGB(196, 189, 151)
    
    Dim monthRng As Range, monthCell As Range
    Set monthRng = Sheet1.Range(Cells(6, 25), Cells(6, lastcol))
    
    For Each monthCell In monthRng
        If monthCell.Value = "1" Then
          Call Border_Month(monthCell, Cells(lastrow, monthCell.Column))
        End If
    Next monthCell

    Dim wkNameRng As Range, wkNameCell As Range
    Set wkNameRng = Sheet1.Range(Cells(7, 4), Cells(lastrow, 4))
    
    Dim tempRng As Range
    Dim oldWkName As String
    Dim startCell As Integer
    startCell = 7
    For Each wkNameCell In wkNameRng
    
        Set tempRng = Sheet1.Range(Cells(wkNameCell.Row, 4), Cells(wkNameCell.Row, 7))
        tempRng.BorderAround xlContinuous
        tempRng.Borders(xlInsideHorizontal).Color = RGB(0, 0, 0)
        tempRng.Borders(xlInsideVertical).Color = RGB(0, 0, 0)
        
        If wkNameCell.Value <> oldWkName Then

          Call Border_Change(Cells(wkNameCell.Row, 25), Cells(wkNameCell.Row, lastcol))
          oldWkName = wkNameCell.Value
          
          Range(Cells(startCell, 4), Cells(wkNameCell.Row - 1, 7)).Merge
          startCell = wkNameCell.Row
        Else
          tempRng.Value = ""

        End If
    Next wkNameCell

Dim vbCom As Object
Set vbCom = Application.VBE.ActiveVBProject.VBComponents
vbCom.Remove VBComponent:= _
vbCom.Item("Module1")
End Sub

Sub Border_Month(cellStart As Range, cellEnd As Range)

    Dim rRng As Range, cell As Range

    Set rRng = Sheet1.Range(cellStart, cellEnd)
    
    For Each cell In rRng
        cell.Borders(xlEdgeLeft).Color = RGB(0, 0, 0)
    Next cell
    
End Sub

Sub Border_Change(cellStart As Range, cellEnd As Range)

    Dim rRng As Range, cell As Range

    Set rRng = Sheet1.Range(cellStart, cellEnd)
    
    For Each cell In rRng
        cell.Borders(xlEdgeTop).Color = RGB(0, 0, 0)
    Next cell
    
End Sub
