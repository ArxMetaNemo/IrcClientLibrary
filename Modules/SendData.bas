#include "SendData.bi"
#include "CharacterConstants.bi"

Function SendData( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strData As LPCWSTR _
	)As Boolean
	
	Dim SafeBuffer As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpyn(@SafeBuffer, strData, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2)
	
	Dim SendBuffer As ZString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM * 3 + 1) = Any
	Dim SendBufferLength As Long = WideCharToMultiByte( _
		pIrcClient->CodePage, _
		0, _
		@SafeBuffer, _
		-1, _
		@SendBuffer, _
		IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1, _
		0, _
		0 _
	)
	
	If SendBufferLength <> 0 Then
		' Без учёта нулевого символа
		SendBufferLength -= 1
		
		Const CrLfALength As Integer = 2
		Dim CrLfA(0 To CrLfALength - 1) As Byte = {Characters.CarriageReturn, Characters.LineFeed}
		
		Const SendBufLength As Integer = 2
		Dim SendBuf(0 To SendBufLength - 1) As WSABUF = Any
		SendBuf(0).len = Cast(ULONG, SendBufferLength)
		SendBuf(0).buf = @SendBuffer
		
		SendBuf(1).len = Cast(ULONG, CrLfALength)
		SendBuf(1).buf = @CrLfA(0)
		
		Dim NumberOfBytesSent As DWORD = Any
		Const dwSendFlags As DWORD = 0
		Dim res As Long = WSASend( _
			pIrcClient->ClientSocket, _
			@SendBuf(0), _
			Cast(DWORD, SendBufLength), _
			@NumberOfBytesSent, _
			dwSendFlags, _
			NULL, _
			NULL _
		)
		
		If res <> 0 Then
			If WSAGetLastError() <> WSA_IO_PENDING Then
				Return False
			End If
		End If
		
		If CUInt(pIrcClient->lpfnSendedRawMessageEvent) Then
			pIrcClient->lpfnSendedRawMessageEvent(pIrcClient->AdvancedClientData, @SafeBuffer)
		End If
		
	End If
	
	Return True
	
End Function