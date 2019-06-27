#ifndef BATCHEDFILES_IRCCLIENT_IIRCCLIENT_BI
#define BATCHEDFILES_IRCCLIENT_IIRCCLIENT_BI

#ifndef unicode
#define unicode
#endif
#include "windows.bi"
#include "win\ole2.bi"
#include "Modules\IrcPrefix.bi"
#include "Modules\IrcEvents.bi"

Const IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM As Integer = 512

' {068B4FA6-0B55-4E12-B0C8-E2EEF9EFEFF3}
Dim Shared IID_IIRCCLIENT As IID = Type(&h68b4fa6, &hb55, &h4e12, _
	{&hb0, &hc8, &he2, &hee, &hf9, &hef, &hef, &hf3} _
)

Type LPIIRCCLIENT As IIrcClient Ptr

Type IIrcClient As IIrcClient_

Type IIrcClientVirtualTable
	Dim InheritedTable As IUnknownVtbl
	
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
		ByVal ppClientVersion As WString Ptr Ptr _
	)As HRESULT
	
	Dim SetClientVersion As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pClientVersion As WString Ptr _
	)As HRESULT
	
	Dim GetClientUserInfo As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ppClientUserInfo As WString Ptr Ptr _
	)As HRESULT
	
	Dim SetClientUserInfo As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pClientUserInfo As WString Ptr _
	)As HRESULT
	
	Dim GetCodePage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCodePage As Integer Ptr _
	)As HRESULT
	
	Dim SetCodePage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CodePage As Integer _
	)As HRESULT
	
	Dim GetSendedRawMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pSendedRawMessageEventHandler As SendedRawMessageEvent Ptr _
	)As HRESULT
	
	Dim SetSendedRawMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal SendedRawMessageEventHandler As SendedRawMessageEvent _
	)As HRESULT
	
	Dim GetReceivedRawMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pReceivedRawMessageEventHandler As ReceivedRawMessageEvent Ptr _
	)As HRESULT
	
	Dim SetReceivedRawMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ReceivedRawMessageEventHandler As ReceivedRawMessageEvent _
	)As HRESULT
	
	Dim GetServerErrorEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pServerErrorEventHandler As ServerErrorEvent Ptr _
	)As HRESULT
	
	Dim SetServerErrorEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ServerErrorEventHandler As ServerErrorEvent _
	)As HRESULT
	
	Dim GetServerMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pServerMessageEventHandler As ServerMessageEvent Ptr _
	)As HRESULT
	
	Dim SetServerMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ServerMessageEventHandler As ServerMessageEvent _
	)As HRESULT
	
	Dim GetNoticeEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pNoticeEventHandler As NoticeEvent Ptr _
	)As HRESULT
	
	Dim SetNoticeEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal NoticeEventHandler As NoticeEvent _
	)As HRESULT
	
	Dim GetChannelNoticeEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pChannelNoticeEventHandler As ChannelNoticeEvent Ptr _
	)As HRESULT
	
	Dim SetChannelNoticeEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ChannelNoticeEventHandler As ChannelNoticeEvent _
	)As HRESULT
	
	Dim GetChannelMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pChannelMessageEventHandler As ChannelMessageEvent Ptr _
	)As HRESULT
	
	Dim SetChannelMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ChannelMessageEventHandler As ChannelMessageEvent _
	)As HRESULT
	
	Dim GetPrivateMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pPrivateMessageEventHandler As PrivateMessageEvent Ptr _
	)As HRESULT
	
	Dim SetPrivateMessageEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal PrivateMessageEventHandler As PrivateMessageEvent _
	)As HRESULT
	
	Dim GetUserJoinedEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pUserJoinedEventHandler As UserJoinedEvent Ptr _
	)As HRESULT
	
	Dim SetUserJoinedEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserJoinedEventHandler As UserJoinedEvent _
	)As HRESULT
	
	Dim GetUserLeavedEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pUserLeavedEventHandler As UserLeavedEvent Ptr _
	)As HRESULT
	
	Dim SetUserLeavedEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserLeavedEventHandler As UserLeavedEvent _
	)As HRESULT
	
	Dim GetNickChangedEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pNickChangedEventHandler As NickChangedEvent Ptr _
	)As HRESULT
	
	Dim SetNickChangedEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal NickChangedEventHandler As NickChangedEvent _
	)As HRESULT
	
	Dim GetTopicEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pTopicEventHandler As TopicEvent Ptr _
	)As HRESULT
	
	Dim SetTopicEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal TopicEventHandler As TopicEvent _
	)As HRESULT
	
	Dim GetQuitEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pQuitEventHandler As QuitEvent Ptr _
	)As HRESULT
	
	Dim SetQuitEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal QuitEventHandler As QuitEvent _
	)As HRESULT
	
	Dim GetKickEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pKickEventHandler As KickEvent Ptr _
	)As HRESULT
	
	Dim SetKickEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal KickEventHandler As KickEvent _
	)As HRESULT
	
	Dim GetInviteEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pInviteEventHandler As InviteEvent Ptr _
	)As HRESULT
	
	Dim SetInviteEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal InviteEventHandler As InviteEvent _
	)As HRESULT
	
	Dim GetPingEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pPingEventHandler As PingEvent Ptr _
	)As HRESULT
	
	Dim SetPingEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal PingEventHandler As PingEvent _
	)As HRESULT
	
	Dim GetPongEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pPongEventHandler As PongEvent Ptr _
	)As HRESULT
	
	Dim SetPongEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal PongEventHandler As PongEvent _
	)As HRESULT
	
	Dim GetModeEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pModeEventHandler As ModeEvent Ptr _
	)As HRESULT
	
	Dim SetModeEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal ModeEventHandler As ModeEvent _
	)As HRESULT
	
	Dim GetCtcpPingRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpPingRequestEventHandler As CtcpPingRequestEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpPingRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpPingRequestEventHandler As CtcpPingRequestEvent _
	)As HRESULT
	
	Dim GetCtcpTimeRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpTimeRequestEventHandler As CtcpTimeRequestEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpTimeRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpCtcpTimeRequestEventHandler As CtcpTimeRequestEvent _
	)As HRESULT
	
	Dim GetCtcpUserInfoRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpUserInfoRequestEventHandler As CtcpUserInfoRequestEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpUserInfoRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpUserInfoRequestEventHandler As CtcpUserInfoRequestEvent _
	)As HRESULT
	
	Dim GetCtcpVersionRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpVersionRequestEventHandler As CtcpVersionRequestEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpVersionRequestEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpVersionRequestEventHandler As CtcpVersionRequestEvent _
	)As HRESULT
	
	Dim GetCtcpActionEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpActionEventHandler As CtcpActionEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpActionEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpActionEventHandler As CtcpActionEvent _
	)As HRESULT
	
	Dim GetCtcpPingResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpPingResponseEventHandler As CtcpPingResponseEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpPingResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpPingResponseEventHandler As CtcpPingResponseEvent _
	)As HRESULT
	
	Dim GetCtcpTimeResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpTimeResponseEventHandler As CtcpTimeResponseEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpTimeResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpTimeResponseEventHandler As CtcpTimeResponseEvent _
	)As HRESULT
	
	Dim GetCtcpUserInfoResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpUserInfoResponseEventHandler As CtcpUserInfoResponseEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpUserInfoResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpUserInfoResponseEventHandler As CtcpUserInfoResponseEvent _
	)As HRESULT
	
	Dim GetCtcpVersionResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal pCtcpVersionResponseEventHandler As CtcpVersionResponseEvent Ptr _
	)As HRESULT
	
	Dim SetCtcpVersionResponseEventHandler As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal CtcpVersionResponseEventHandler As CtcpVersionResponseEvent _
	)As HRESULT
	
	Dim OpenIrcClient As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal LocalAddress As WString Ptr, _
		ByVal LocalPort As WString Ptr, _
		ByVal Password As WString Ptr, _
		ByVal Nick As WString Ptr, _
		ByVal User As WString Ptr, _
		ByVal Description As WString Ptr, _
		ByVal Visible As Boolean _
	)As HRESULT
	
	Dim CloseIrcClient As Function( _
		ByVal pIIrcClient As IIrcClient Ptr _
	)As HRESULT
	
	Dim SendIrcMessage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendNotice As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal NoticeText As WString Ptr _
	)As HRESULT
	
	Dim ChangeTopic As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal TopicText As WString Ptr _
	)As HRESULT
	
	Dim QuitFromServer As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim ChangeNick As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Nick As WString Ptr _
	)As HRESULT
	
	Dim JoinChannel As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr _
	)As HRESULT
	
	Dim PartChannel As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendWho As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendWhoIs As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendAdmin As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendInfo As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendAway As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendIsON As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal NickList As WString Ptr _
	)As HRESULT
	
	Dim SendKick As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Channel As WString Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendInvite As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal Channel As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpPingRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpTimeRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpUserInfoRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpVersionRequest As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpAction As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal MessageText As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpPingResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpTimeResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal TimeValue As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpUserInfoResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal UserInfo As WString Ptr _
	)As HRESULT
	
	Dim SendCtcpVersionResponse As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal Version As WString Ptr _
	)As HRESULT
	
	Dim SendDccSend As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal UserName As WString Ptr, _
		ByVal FileName As WString Ptr, _
		ByVal IPAddress As WString Ptr, _
		ByVal Port As WString Ptr, _
		ByVal FileLength As ULongInt _
	)As HRESULT
	
	Dim SendPing As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendPong As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal Server As WString Ptr _
	)As HRESULT
	
	Dim SendRawMessage As Function( _
		ByVal pIIrcClient As IIrcClient Ptr, _
		ByVal RawText As WString Ptr _
	)As HRESULT
	
End Type

Type IIrcClient_
	Dim pVirtualTable As IIrcClientVirtualTable Ptr
End Type

#define IBaseStream_QueryInterface(pIIrcClient, riid, ppv) (pIIrcClient)->pVirtualTable->InheritedTable.QueryInterface(CPtr(IUnknown Ptr, pIIrcClient), riid, ppv)
#define IBaseStream_AddRef(pIIrcClient) (pIIrcClient)->pVirtualTable->InheritedTable.AddRef(CPtr(IUnknown Ptr, pIIrcClient))
#define IBaseStream_Release(pIIrcClient) (pIIrcClient)->pVirtualTable->InheritedTable.Release(CPtr(IUnknown Ptr, pIIrcClient))

#endif
