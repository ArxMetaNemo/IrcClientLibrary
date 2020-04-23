#include "ReceiveData.bi"
#include "CharacterConstants.bi"
#include "ParseData.bi"
#include "Network.bi"

Declare Function FindCrLfA( _
	ByVal pIrcClient As IrcClient Ptr, _
	ByVal pFindIndex As Integer Ptr _
)As Boolean

Declare Sub ReceiveCompletionROUTINE( _
	ByVal dwError As DWORD, _
	ByVal cbTransferred As DWORD, _
	ByVal lpOverlapped As LPWSAOVERLAPPED, _
	ByVal dwFlags As DWORD _
)

Function FindCrLfA( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal pFindIndex As Integer Ptr _
	)As Boolean
	
	' Минус 2 потому что один байт под Lf и один, чтобы не выйти за границу
	For i As Integer = 0 To pIrcClient->ReceiveBuffer.Length - 2
		
		If pIrcClient->ReceiveBuffer.Buffer[i] = 13 AndAlso pIrcClient->ReceiveBuffer.Buffer[i + 1] = 10 Then
			*pFindIndex = i
			Return True
		End If
		
	Next
	
	*pFindIndex = 0
	Return False
	
End Function

Function StartRecvOverlapped( _
		ByVal pIrcClient As IrcClient Ptr _
	)As Boolean
	
	Const WsaBufBuffersCount As DWORD = 1
	Dim RecvBuf As WSABUF = Any
	RecvBuf.len = Cast(ULONG, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - pIrcClient->ReceiveBuffer.Length)
	RecvBuf.buf = @pIrcClient->ReceiveBuffer.Buffer[pIrcClient->ReceiveBuffer.Length]
	
	ZeroMemory(@pIrcClient->RecvOverlapped, SizeOf(WSAOVERLAPPED))
	pIrcClient->RecvOverlapped.hEvent = pIrcClient
	
	Dim Flags As DWORD = 0
	
	Dim res As Long = WSARecv( _
		pIrcClient->ClientSocket, _
		@RecvBuf, _
		WsaBufBuffersCount, _
		NULL, _
		@Flags, _
		@pIrcClient->RecvOverlapped, _
		@ReceiveCompletionROUTINE _
	)
	If res <> 0 Then
		
		If WSAGetLastError() <> WSA_IO_PENDING Then
			IrcClientCloseConnection(pIrcClient)
			Return False
		End If
		
	End If
	
	Return True
	
End Function

Sub ReceiveCompletionROUTINE( _
		ByVal dwError As DWORD, _
		ByVal cbTransferred As DWORD, _
		ByVal lpOverlapped As LPWSAOVERLAPPED, _
		ByVal dwFlags As DWORD _
	)
	
	Dim pIrcClient As IrcClient Ptr = lpOverlapped->hEvent
	
	If dwError <> 0 Then
		IrcClientCloseConnection(pIrcClient)
		Exit Sub
	End If
	
	pIrcClient->ReceiveBuffer.Length += CInt(cbTransferred)
	pIrcClient->ReceiveBuffer.Buffer[pIrcClient->ReceiveBuffer.Length] = 0
	
	Dim CrLfIndex As Integer = Any
	Dim FindCrLfResult As Boolean = FindCrLfA(pIrcClient, @CrLfIndex)
	
	If FindCrLfResult = False Then
		
		If pIrcClient->ReceiveBuffer.Length >= IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM Then
			FindCrLfResult = True
			CrLfIndex = IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2
			pIrcClient->ReceiveBuffer.Length = IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM
		End If
		
	End If
	
	Do While FindCrLfResult
		pIrcClient->ReceiveBuffer.Buffer[CrLfIndex] = Characters.NullChar
		
		Scope
			Dim ServerResponse As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
			Dim ServerResponseLength As Long = MultiByteToWideChar( _
				pIrcClient->CodePage, _
				0, _
				@pIrcClient->ReceiveBuffer.Buffer, _
				CrLfIndex, _
				@ServerResponse, _
				IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1 _
			)
			ServerResponse[CInt(ServerResponseLength)] = Characters.NullChar
			
			If CUInt(pIrcClient->lpfnReceivedRawMessageEvent) Then
				pIrcClient->lpfnReceivedRawMessageEvent(pIrcClient->AdvancedClientData, @ServerResponse)
			End If
			
			If ParseData(pIrcClient, @ServerResponse) = False Then
				IrcClientCloseConnection(pIrcClient)
				Exit Sub
			End If
		End Scope
		
		Scope
			Dim NewStartingIndex As Integer = CrLfIndex + 2
			
			If NewStartingIndex = pIrcClient->ReceiveBuffer.Length Then
				pIrcClient->ReceiveBuffer.Buffer[0] = Characters.NullChar
				pIrcClient->ReceiveBuffer.Length = 0
			Else
				memmove( _
					@pIrcClient->ReceiveBuffer.Buffer, _
					@pIrcClient->ReceiveBuffer.Buffer[NewStartingIndex], _
					IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - NewStartingIndex + 1 _
				)
				pIrcClient->ReceiveBuffer.Length -= NewStartingIndex
			End If
		End Scope
		
		FindCrLfResult = FindCrLfA(pIrcClient, @CrLfIndex)
	Loop
	
	StartRecvOverlapped(pIrcClient)
	
End Sub
