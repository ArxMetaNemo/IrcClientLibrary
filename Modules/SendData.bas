#include "SendData.bi"
#include "CharacterConstants.bi"

Type SendOverlappedData
	Dim SendOverlapped As WSAOVERLAPPED
	Dim pIrcClient As IrcClient Ptr
	Dim SendBufferLength As Long
	Dim SendBuffer As ZString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM * 3 + 1) = Any
End Type

Type CrLfA
	Dim Cr As Byte
	Dim Lf As Byte
End Type

Type SendBuffers
	Dim Bytes As WSABUF
	Dim CrLf As WSABUF
End Type

Declare Sub SendCompletionROUTINE( _
	ByVal dwError As DWORD, _
	ByVal cbTransferred As DWORD, _
	ByVal lpOverlapped As LPWSAOVERLAPPED, _
	ByVal dwFlags As DWORD _
)

Function StartSendOverlapped( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByRef strData As ValueBSTR _
	)As HRESULT
	
	Dim hr As HRESULT = E_OUTOFMEMORY
	Dim pSendOverlappedData As SendOverlappedData Ptr = HeapAlloc( _
		pIrcClient->hHeap, _
		0, _
		SizeOf(SendOverlappedData) _
	)
	
	If pSendOverlappedData <> NULL Then
		
		pSendOverlappedData->SendBufferLength = WideCharToMultiByte( _
			pIrcClient->CodePage, _
			0, _
			Cast(WString Ptr, strData), _
			Len(strData), _
			@pSendOverlappedData->SendBuffer, _
			IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM, _
			NULL, _
			NULL _
		)
		
		If pSendOverlappedData->SendBufferLength <> 0 Then
			
			Const CrLfALength As Integer = 2
			Const SendBufLength As Integer = 2
			
			ZeroMemory(@pSendOverlappedData->SendOverlapped, SizeOf(WSAOVERLAPPED))
			
			pSendOverlappedData->pIrcClient = pIrcClient
			
			Dim CrLf As CrLfA = Any
			CrLf.Cr = Characters.CarriageReturn
			CrLf.Lf = Characters.LineFeed
			
			Dim SendBuf As SendBuffers = Any
			SendBuf.Bytes.len = Cast(ULONG, min(pSendOverlappedData->SendBufferLength, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - CrLfALength))
			SendBuf.Bytes.buf = @pSendOverlappedData->SendBuffer
			
			SendBuf.CrLf.len = Cast(ULONG, CrLfALength)
			SendBuf.CrLf.buf = CPtr(CHAR Ptr, @CrLf)
			
			Const dwSendFlags As DWORD = 0
			Dim res As Long = WSASend( _
				pIrcClient->ClientSocket, _
				CPtr(WSABUF Ptr, @SendBuf), _
				Cast(DWORD, SendBufLength), _
				NULL, _
				dwSendFlags, _
				@pSendOverlappedData->SendOverlapped, _
				@SendCompletionROUTINE _
			)
			Dim ErrorCode As Long = WSAGetLastError()
			hr = HRESULT_FROM_WIN32(ErrorCode)
			
			If res = 0 Then
				Return S_OK
			End If
			
			If ErrorCode = WSA_IO_PENDING Then
				Return S_OK
			End If
			
		End If
		
		hr = HRESULT_FROM_WIN32(GetLastError())
		HeapFree(pIrcClient->hHeap, 0, pSendOverlappedData)
		
	End If
	
	Return hr
	
End Function

Sub SendCompletionROUTINE( _
		ByVal dwError As DWORD, _
		ByVal cbTransferred As DWORD, _
		ByVal lpOverlapped As LPWSAOVERLAPPED, _
		ByVal dwFlags As DWORD _
	)
	
	Dim pSendOverlappedData As SendOverlappedData Ptr = CPtr(SendOverlappedData Ptr, lpOverlapped)
	Dim pIrcClient As IrcClient Ptr = pSendOverlappedData->pIrcClient
	
	If dwError <> 0 Then
		pIrcClient->ErrorCode = HRESULT_FROM_WIN32(dwError)
		SetEvent(pIrcClient->hEvent)
		Exit Sub
	End If
	
	If CUInt(pIrcClient->Events.lpfnSendedRawMessageEvent) Then
		pIrcClient->Events.lpfnSendedRawMessageEvent(pIrcClient->lpParameter, @pSendOverlappedData->SendBuffer, pSendOverlappedData->SendBufferLength)
	End If
	
	HeapFree(pIrcClient->hHeap, 0, pSendOverlappedData)
	
End Sub
