#ifndef BATCHEDFILES_IRCCLIENT_IIRCCLIENT_BI
#define BATCHEDFILES_IRCCLIENT_IIRCCLIENT_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"
#include "IrcEvents.bi"

Const IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM As Integer = 512
Const IRCPROTOCOL_NICKLENGTHMAXIMUM As Integer = 50
Const IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM As Integer = 50

' {068B4FA6-0B55-4E12-B0C8-E2EEF9EFEFF3}
' Dim Shared IID_IIRCCLIENT As IID = Type(&h68b4fa6, &hb55, &h4e12, _
	' {&hb0, &hc8, &he2, &hee, &hf9, &hef, &hef, &hf3} _
' )

Type IIrcClient As IIrcClient_

Type LPIRCCLIENT As IIrcClient Ptr

Extern IID_IIrcClient Alias "IID_IIrcClient" As Const IID

Type IIrcClientVirtualTable
	Dim InheritedTable As IDispatchVtbl
	
	Dim GetAdvancedClientData As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ppAdvancedClientData As Any Ptr Ptr _
	)As HRESULT
	
	Dim SetAdvancedClientData As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pAdvancedClientData As Any Ptr _
	)As HRESULT
	
	Dim GetClientVersion As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ppClientVersion As BSTR Ptr _
	)As HRESULT
	
	Dim SetClientVersion As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pClientVersion As BSTR _
	)As HRESULT
	
	Dim GetClientUserInfo As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ppClientUserInfo As BSTR Ptr _
	)As HRESULT
	
	Dim SetClientUserInfo As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pClientUserInfo As BSTR _
	)As HRESULT
	
	Dim GetCodePage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCodePage As Integer Ptr _
	)As HRESULT
	
	Dim SetCodePage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CodePage As Integer _
	)As HRESULT
	
	Dim Startup As Function( _
		ByVal pIIrcClient As IIrcClient Ptr _
	)As HRESULT
	
	Dim Cleanup As Function( _
		ByVal pIIrcClient As IIrcClient Ptr _
	)As HRESULT
	
	Dim OpenIrcClient As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As BSTR, _
		ByVal Port As BSTR, _
		ByVal LocalAddress As BSTR, _
		ByVal LocalPort As BSTR, _
		ByVal Password As BSTR, _
		ByVal Nick As BSTR, _
		ByVal User As BSTR, _
		ByVal Description As BSTR, _
		ByVal Visible As Boolean _
	)As HRESULT
	
	Dim StartReceiveDataLoop As Function( _
		ByVal pIIrcClient As IIrcClient Ptr _
	)As HRESULT
	
	Dim MsgStartReceiveDataLoop As Function( _
		ByVal pIIrcClient As IIrcClient Ptr _
	)As HRESULT
	
	Dim CloseIrcClient As Function( _
		ByVal pIIrcClient As IIrcClient Ptr _
	)As HRESULT
	
	Dim SendIrcMessage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As BSTR, _
		ByVal MessageText As BSTR _
	)As HRESULT
	
	Dim SendNotice As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As BSTR, _
		ByVal NoticeText As BSTR _
	)As HRESULT
	
	Dim ChangeTopic As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As BSTR, _
		ByVal TopicText As BSTR _
	)As HRESULT
	
	Dim QuitFromServer As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal MessageText As BSTR _
	)As HRESULT
	
	Dim ChangeNick As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Nick As BSTR _
	)As HRESULT
	
	Dim JoinChannel As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As BSTR _
	)As HRESULT
	
	Dim PartChannel As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As BSTR, _
		ByVal MessageText As BSTR _
	)As HRESULT
	
	Dim SendWho As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	Dim SendWhoIs As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	Dim SendAdmin As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As BSTR _
	)As HRESULT
	
	Dim SendInfo As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As BSTR _
	)As HRESULT
	
	Dim SendAway As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal MessageText As BSTR _
	)As HRESULT
	
	Dim SendIsON As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal NickList As BSTR _
	)As HRESULT
	
	Dim SendKick As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As BSTR, _
		ByVal UserName As BSTR, _
		ByVal MessageText As BSTR _
	)As HRESULT
	
	Dim SendInvite As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal Channel As BSTR _
	)As HRESULT
	
	Dim SendCtcpPingRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal TimeValue As BSTR _
	)As HRESULT
	
	Dim SendCtcpTimeRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	Dim SendCtcpUserInfoRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	Dim SendCtcpVersionRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR _
	)As HRESULT
	
	Dim SendCtcpAction As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal MessageText As BSTR _
	)As HRESULT
	
	Dim SendCtcpPingResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal TimeValue As BSTR _
	)As HRESULT
	
	Dim SendCtcpTimeResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal TimeValue As BSTR _
	)As HRESULT
	
	Dim SendCtcpUserInfoResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal UserInfo As BSTR _
	)As HRESULT
	
	Dim SendCtcpVersionResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal Version As BSTR _
	)As HRESULT
	
	Dim SendDccSend As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As BSTR, _
		ByVal FileName As BSTR, _
		ByVal IPAddress As BSTR, _
		ByVal Port As BSTR, _
		ByVal FileLength As ULongInt _
	)As HRESULT
	
	Dim SendPing As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As BSTR _
	)As HRESULT
	
	Dim SendPong As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As BSTR _
	)As HRESULT
	
	Dim SendRawMessage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal RawText As BSTR _
	)As HRESULT
	
End Type

Type IIrcClient_
	Dim pVirtualTable As IIrcClientVirtualTable Ptr
End Type

#endif
