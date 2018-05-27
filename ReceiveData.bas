#include "ReceiveData.bi"

Function FindCrLfA( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal pFindIndex As Integer Ptr _
	)As Boolean
	' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
	For i As Integer = 0 To pIrcClient->ClientRawBufferLength - 2
		If pIrcClient->ClientRawBuffer[i] = 13 AndAlso pIrcClient->ClientRawBuffer[i + 1] = 10 Then
			*pFindIndex = i
			Return True
		End If
	Next
	*pFindIndex = 0
	Return False
End Function

Function ReceiveData( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strReceiveData As WString Ptr _
	)As Boolean
	
	Dim CrLfIndex As Integer = 0
	Dim FindCrLfResult As Boolean = FindCrLfA(pIrcClient, @CrLfIndex)
	
	Do While FindCrLfResult = False
		If pIrcClient->ClientRawBufferLength >= IrcClient.MaxBytesCount Then
			CrLfIndex = IrcClient.MaxBytesCount - 2
			pIrcClient->ClientRawBufferLength = IrcClient.MaxBytesCount
			Exit Do
		Else
			Dim intReceivedBytesCount As Integer = recv(pIrcClient->ClientSocket, @pIrcClient->ClientRawBuffer[pIrcClient->ClientRawBufferLength], IrcClient.MaxBytesCount - pIrcClient->ClientRawBufferLength, 0)
			
			Select Case intReceivedBytesCount
				Case SOCKET_ERROR
					strReceiveData[0] = 0
					Return False
				Case 0
					strReceiveData[0] = 0
					Return False
				Case Else
					pIrcClient->ClientRawBufferLength += intReceivedBytesCount
					pIrcClient->ClientRawBuffer[pIrcClient->ClientRawBufferLength] = 0
			End Select
		End If
		FindCrLfResult = FindCrLfA(pIrcClient, @CrLfIndex)
	Loop
	
	pIrcClient->ClientRawBuffer[CrLfIndex] = 0
	
	MultiByteToWideChar(pIrcClient->CodePage, 0, @pIrcClient->ClientRawBuffer, -1, strReceiveData, IrcClient.MaxBytesCount + 1)
	
	Dim NewBufferStartingIndex As Integer = CrLfIndex + 2
	If NewBufferStartingIndex = pIrcClient->ClientRawBufferLength Then
		pIrcClient->ClientRawBuffer[0] = 0
		pIrcClient->ClientRawBufferLength = 0
	Else
		memmove(@pIrcClient->ClientRawBuffer, @pIrcClient->ClientRawBuffer[NewBufferStartingIndex], IrcClient.MaxBytesCount - NewBufferStartingIndex + 1)
		pIrcClient->ClientRawBufferLength -= NewBufferStartingIndex
	End If
	
	If CInt(pIrcClient->ReceivedRawMessageEvent) Then
		pIrcClient->ReceivedRawMessageEvent(pIrcClient->AdvancedClientData, strReceiveData)
	End If
	
	Return True
End Function
