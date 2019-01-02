#include "ParseData.bi"
#include "GetIrcData.bi"
#include "StringConstants.bi"

Function IsCtcpMessage( _
		ByVal strMessageText As WString Ptr, _
		ByVal MessageTextLength As Integer _
	)As Boolean
	If MessageTextLength > 2 Then
		If strMessageText[0] = 1 Then
			If strMessageText[MessageTextLength - 1] = 1 Then
				Return True
			End If
		End If
	End If
	Return False
End Function

Function ParseData( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal ReceivedData As WString Ptr _
	) As Boolean
	
	Dim Prefix As IrcPrefix = Any
	Dim wStartIrcCommand As WString Ptr = GetIrcPrefix(@Prefix, ReceivedData)
	
	Dim wStartIrcParam1 As WString Ptr = GetNextWord(wStartIrcCommand)
	
	Select Case GetIrcCommand(wStartIrcCommand)
		
		Case IrcCommand.PingWord
			'PING :barjavel.freenode.net
			Dim ServerName As WString Ptr = GetIrcServerName(wStartIrcParam1)
			If ServerName <> 0 Then
				If CUInt(pIrcClient->lpfnPingEvent) Then
					pIrcClient->lpfnPingEvent(pIrcClient->AdvancedClientData, @Prefix, ServerName)
				Else
					Return SendPong(pIrcClient, ServerName)
				End If
			End If
			
		Case IrcCommand.PrivateMessage
			':Angel!wings@irc.org PRIVMSG Wiz :Are you receiving this message ?
			':Angel!wings@irc.org PRIVMSG Qubick :PING 1402355972
			':Angel!wings@irc.org PRIVMSG Qubick :VERSION
			':Angel!wings@irc.org PRIVMSG Qubick :TIME
			':Angel!wings@irc.org PRIVMSG Qubick :USERINFO
			
			Dim ircReceiver As WString Ptr = wStartIrcParam1
			Dim wStartIrcParam2 As WString Ptr = GetNextWord(wStartIrcParam1)
	
			Dim strMessageText As WString Ptr = GetIrcMessageText(wStartIrcParam2)
			
			If strMessageText <> 0 Then
				Dim MessageTextLength As Integer = lstrlen(strMessageText)
				
				If IsCtcpMessage(strMessageText, MessageTextLength) Then
					strMessageText[MessageTextLength - 1] = 0
					Dim wStartCtcpParam As WString Ptr = GetNextWord(@strMessageText[1])
					
					Select Case GetCtcpCommand(@strMessageText[1])
						
						Case CtcpMessageKind.Ping
							
							If CUInt(pIrcClient->lpfnCtcpPingRequestEvent) = 0 Then
								SendCtcpPingResponse(pIrcClient, Prefix.Nick, wStartCtcpParam)
							Else
								pIrcClient->lpfnCtcpPingRequestEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.UserInfo
							If CUInt(pIrcClient->lpfnCtcpUserInfoRequestEvent) = 0 Then
								If pIrcClient->ClientUserInfo <> 0 Then
									SendCtcpUserInfoResponse(pIrcClient, Prefix.Nick, pIrcClient->ClientUserInfo)
								End If
							Else
								pIrcClient->lpfnCtcpUserInfoRequestEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver)
							End If
							
						Case CtcpMessageKind.Time
							If CUInt(pIrcClient->lpfnCtcpTimeRequestEvent) = 0 Then
								' Tue, 15 Nov 1994 12:45:26 GMT
								Const DateFormatString = "ddd, dd MMM yyyy "
								Const TimeFormatString = "HH:mm:ss GMT"
								Dim TimeValue As WString * 64 = Any
								Dim dtNow As SYSTEMTIME = Any
								
								GetSystemTime(@dtNow)
								
								Dim dtBufferLength As Integer = GetDateFormat(LOCALE_INVARIANT, 0, @dtNow, @DateFormatString, @TimeValue, 31) - 1
								GetTimeFormat(LOCALE_INVARIANT, 0, @dtNow, @TimeFormatString, @TimeValue[dtBufferLength], 31 - dtBufferLength)
								
								Return SendCtcpTimeResponse(pIrcClient, Prefix.Nick, @TimeValue)
							Else
								pIrcClient->lpfnCtcpTimeRequestEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver)
							End If
							
						Case CtcpMessageKind.Version
							If CUInt(pIrcClient->lpfnCtcpVersionRequestEvent) = 0 Then
								If pIrcClient->ClientVersion <> 0 Then
									Return SendCtcpVersionResponse(pIrcClient, Prefix.Nick, pIrcClient->ClientVersion)
								End If
							Else
								pIrcClient->lpfnCtcpVersionRequestEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver)
							End If
							
						Case CtcpMessageKind.Action
							If CUInt(pIrcClient->lpfnCtcpActionEvent) Then
								pIrcClient->lpfnCtcpActionEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, wStartCtcpParam)
							End If
							
					End Select
				Else
					If lstrcmp(ircReceiver, @pIrcClient->ClientNick) = 0 Then
						If CUInt(pIrcClient->lpfnPrivateMessageEvent) Then
							pIrcClient->lpfnPrivateMessageEvent(pIrcClient->AdvancedClientData, @Prefix, strMessageText)
						End If
					Else
						If CUInt(pIrcClient->lpfnChannelMessageEvent) Then
							pIrcClient->lpfnChannelMessageEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, strMessageText)
						End If
					End If
				End If
			End If
			
		Case IrcCommand.Join
			':Qubick!~Qubick@irc.org JOIN ##freebasic
			If CUInt(pIrcClient->lpfnUserJoinedEvent) Then
				pIrcClient->lpfnUserJoinedEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1)
			End If
			
		Case IrcCommand.Quit, IrcCommand.SQuit
			' :syrk!kalt@millennium.stealth.net QUIT :Gone to have lunch
			If CUInt(pIrcClient->lpfnQuitEvent) Then
				Dim QuitText As WString Ptr = GetIrcMessageText(wStartIrcParam1)
				If QuitText = 0 Then
					pIrcClient->lpfnQuitEvent(pIrcClient->AdvancedClientData, @Prefix, @EmptyString)
				Else
					pIrcClient->lpfnQuitEvent(pIrcClient->AdvancedClientData, @Prefix, QuitText)
				End If
			End If
			
		Case IrcCommand.Notice
			':Angel!wings@irc.org NOTICE Wiz :Are you receiving this message ?
			':Angel!wings@irc.org NOTICE Qubick :PING 1402355972
			
			Dim ircReceiver As WString Ptr = wStartIrcParam1
			Dim wStartIrcParam2 As WString Ptr = GetNextWord(wStartIrcParam1)
			
			Dim strNoticeText As WString Ptr = GetIrcMessageText(wStartIrcParam2)
			
			If strNoticeText <> 0 Then
				Dim NoticeTextLength As Integer = lstrlen(strNoticeText)
				
				If IsCtcpMessage(strNoticeText, NoticeTextLength) Then
					strNoticeText[NoticeTextLength - 1] = 0
					Dim wStartCtcpParam As WString Ptr = GetNextWord(@strNoticeText[1])
					
					Select Case GetCtcpCommand(@strNoticeText[1])
						
						Case CtcpMessageKind.Ping
							If CUInt(pIrcClient->lpfnCtcpPingResponseEvent) Then
								pIrcClient->lpfnCtcpPingResponseEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.UserInfo
							If CUInt(pIrcClient->lpfnCtcpUserInfoResponseEvent) Then
								pIrcClient->lpfnCtcpUserInfoResponseEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.Time
							If CUInt(pIrcClient->lpfnCtcpTimeResponseEvent) Then
								pIrcClient->lpfnCtcpTimeResponseEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, wStartCtcpParam)
							End If
							
						Case CtcpMessageKind.Version
							If CUInt(pIrcClient->lpfnCtcpVersionResponseEvent) Then
								pIrcClient->lpfnCtcpVersionResponseEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, wStartCtcpParam)
							End If
							
					End Select
					
				Else
					If lstrcmp(ircReceiver, @pIrcClient->ClientNick) = 0 Then
						If CUInt(pIrcClient->lpfnNoticeEvent) Then
							pIrcClient->lpfnNoticeEvent(pIrcClient->AdvancedClientData, @Prefix, strNoticeText)
						End If
					Else
						If CUInt(pIrcClient->lpfnChannelNoticeEvent) Then
							pIrcClient->lpfnChannelNoticeEvent(pIrcClient->AdvancedClientData, @Prefix, ircReceiver, strNoticeText)
						End If
					End If
				End If
			End If
			
		Case IrcCommand.Part
			':WiZ!jto@tolsun.oulu.fi PART #playzone :I lost
			If CUInt(pIrcClient->lpfnUserLeavedEvent) Then
				Dim wStartIrcParam2 As WString Ptr = GetNextWord(wStartIrcParam1)
				Dim PartText As WString Ptr = GetIrcMessageText(wStartIrcParam2)
				If PartText = 0 Then
					pIrcClient->lpfnUserLeavedEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1, @EmptyString)
				Else
					pIrcClient->lpfnUserLeavedEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1, PartText)
				End If
			End If
			
		Case IrcCommand.Nick
			':WiZ!jto@tolsun.oulu.fi NICK Kilroy
			If CUInt(pIrcClient->lpfnNickChangedEvent) Then
				pIrcClient->lpfnNickChangedEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1)
			End If
			
		Case IrcCommand.Invite
			':Angel!wings@irc.org INVITE Wiz #Dust
			If CUInt(pIrcClient->lpfnInviteEvent) Then
				Dim wStartIrcParam2 As WString Ptr = GetNextWord(wStartIrcParam1)
				pIrcClient->lpfnInviteEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1, wStartIrcParam2)
			End If
			
		Case IrcCommand.Kick
			':WiZ!jto@tolsun.oulu.fi KICK #Finnish John
			If CUInt(pIrcClient->lpfnKickEvent) Then
				Dim wStartIrcParam2 As WString Ptr = GetNextWord(wStartIrcParam1)
				pIrcClient->lpfnKickEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1, wStartIrcParam2)
			End If
			
		Case IrcCommand.Topic
			':WiZ!jto@tolsun.oulu.fi TOPIC #test :New topic
			If CUInt(pIrcClient->lpfnTopicEvent) Then
				Dim wStartIrcParam2 As WString Ptr = GetNextWord(wStartIrcParam1)
				Dim TopicText As WString Ptr = GetIrcMessageText(wStartIrcParam2)
				If TopicText = 0 Then
					pIrcClient->lpfnTopicEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1, @EmptyString)
				Else
					pIrcClient->lpfnTopicEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1, TopicText)
				End If
			End If
			
		Case IrcCommand.Mode
			':ChanServ!ChanServ@services. MODE #freebasic +v ssteiner
			':FreeBasicCompile MODE FreeBasicCompile :+i
			If CUInt(pIrcClient->lpfnModeEvent) Then
				Dim wStartIrcParam2 As WString Ptr = GetNextWord(wStartIrcParam1)
				Dim wStartIrcParam3 As WString Ptr = GetNextWord(wStartIrcParam2)
				pIrcClient->lpfnModeEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcParam1, wStartIrcParam2, wStartIrcParam3)
			End If
			
		Case IrcCommand.PongWord
			'PONG :barjavel.freenode.net
			Dim ServerName As WString Ptr = GetIrcServerName(wStartIrcParam1)
			If ServerName <> 0 Then
				If CUInt(pIrcClient->lpfnPongEvent) Then
					pIrcClient->lpfnPongEvent(pIrcClient->AdvancedClientData, @Prefix, ServerName)
				End If
			End If
			
		Case IrcCommand.ErrorWord
			'ERROR :Closing Link: 89.22.170.64 (Client Quit)
			Dim MessageText As WString Ptr = GetIrcMessageText(wStartIrcParam1)
			If MessageText <> 0 Then
				If CUInt(pIrcClient->lpfnServerErrorEvent) Then
					pIrcClient->lpfnServerErrorEvent(pIrcClient->AdvancedClientData, @Prefix, MessageText)
				End If
			End If
			
			Return False
			
		Case IrcCommand.Server
			':orwell.freenode.net 376 FreeBasicCompile :End of /MOTD command.
			If CUInt(pIrcClient->lpfnServerMessageEvent) Then
				pIrcClient->lpfnServerMessageEvent(pIrcClient->AdvancedClientData, @Prefix, wStartIrcCommand, wStartIrcParam1)
			End If
			
	End Select
	
	Return True
	
End Function
