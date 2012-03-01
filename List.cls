VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "List"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Private Const LOWER_BOUND = 1
Private Const RESIZE_FACTOR = 1.75

Private mCount As Integer

Private mItems() As Variant

Public Property Get Count() As Integer
    Count = mCount
End Property

Public Property Get HasItems() As Boolean
    HasItems = (mCount > 0)
End Property

Public Property Let Item(i As Integer, val As Variant)
    CheckIndex i
    If IsObject(val) Then
        Set mItems(i) = val
    Else
        mItems(i) = val
    End If
End Property

Public Property Get Item(i As Integer) As Variant
    CheckIndex i
    If IsObject(mItems(i)) Then
        Set Item = mItems(i)
    Else
        Item = mItems(i)
    End If
End Property

Public Property Get Items() As Variant
    If mCount = 0 Then
        Items = Empty
    Else
        Dim arr() As Variant
        ReDim arr(LOWER_BOUND To LOWER_BOUND + mCount - 1)
        
        Dim i As Integer
        For i = LOWER_BOUND To LOWER_BOUND + mCount - 1
            If IsObject(mItems(i)) Then
                Set arr(i) = mItems(i)
            Else
                arr(i) = mItems(i)
            End If
        Next
        
        ' TODO: Doesn't this copy the array (so it's copied twice)?
        Items = arr
    End If
End Property

Private Sub CheckIndex(i As Integer)
    If i < LOWER_BOUND Then
        Err.Raise 32000, _
            Description:="List item index is less than lower bound"
    End If
    
    If i > mCount Then
        Err.Raise 32000, _
            Description:="List item index is greater than upper bound"
    End If
End Sub

Public Sub Clear()
    ReDim mItems(LOWER_BOUND - 1 To LOWER_BOUND)
    mCount = 0
End Sub

Public Sub Add(val As Variant)
    Resize mCount + 1
    If IsObject(val) Then
        Set mItems(LOWER_BOUND + mCount - 1) = val
    Else
        mItems(LOWER_BOUND + mCount - 1) = val
    End If
End Sub

Public Sub AddOnce(val As Variant)
    If Not Contains(val) Then Add val
End Sub

Public Sub AddRange(val As Variant)
    If Not IsEmpty(val) Then
        Dim v As Variant
        For Each v In val
            Add v
        Next
    End If
End Sub

Public Sub AddRangeOnce(val As Variant)
    If Not IsEmpty(val) Then
        Dim v As Variant
        For Each v In val
            AddOnce v
        Next
    End If
End Sub

Public Function Contains(val As Variant) As Boolean
    Contains = False
    Dim i As Integer
    For i = LOWER_BOUND To LOWER_BOUND + mCount - 1
        If mItems(i) = val Then
            Contains = True
            Exit For
        End If
    Next
End Function

Private Sub Resize(newCount As Integer)
    If newCount > UBound(mItems) - LOWER_BOUND + 1 Then
        ReDim Preserve mItems(LOWER_BOUND - 1 _
            To Int(UBound(mItems) * RESIZE_FACTOR + 0.5))
    End If
    mCount = newCount
End Sub

Private Sub Class_Initialize()
    Clear
End Sub