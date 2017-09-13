#include once "Irc.bi"
#include once "GetIrcData.bi"

Sub IrcClient.ProcessMessage(ByVal Receiver As WString Ptr, ByVal UserName As WString Ptr, ByVal MessageText As WString Ptr)
	If lstrcmp(Receiver, @m_Nick) = 0 Then
		' Сообщение от пользователя
		If CInt(PrivateMessageEvent) Then
			PrivateMessageEvent(AdvancedClientData, UserName, MessageText)
		End If
	Else
		' Сообщение с канала
		If CInt(ChannelMessageEvent) Then
			ChannelMessageEvent(AdvancedClientData, Receiver, UserName, MessageText)
		End If
	End If
End Sub

Sub IrcClient.ProcessNotice(ByVal Receiver As WString Ptr, ByVal UserName As WString Ptr, ByVal MessageText As WString Ptr)
	If lstrcmp(Receiver, @m_Nick) = 0 Then
		' Уведомление от пользователя
		If CInt(NoticeEvent) Then
			NoticeEvent(AdvancedClientData, UserName, MessageText)
		End If
	Else
		' Уведомление с канала
		If CInt(ServerMessageEvent) Then
			ServerMessageEvent(AdvancedClientData, Receiver, MessageText)
		End If
	End If
End Sub

Function IrcClient.ParseData(ByVal strData As WString Ptr)As Boolean
	' Копия данных для сохранения оригинала
	Dim wStart As WString Ptr = strData
	
	' Первое слово
	Dim wServerWord As WString Ptr = wStart
	
	' Отделить первое слово в строке
	wStart = GetNextWord(wStart)
	
	Select Case GetServerWord(wServerWord)
		
		Case ServerWord.PingWord
			'PING :barjavel.freenode.net
			If CInt(PingEvent) Then
				' Понг не отправлять, это сделает сам клиент
				PingEvent(AdvancedClientData, GetIrcServerName(wStart))
			Else
				' Отправляем понг самостоятельно
				Return SendPong(GetIrcServerName(wStart))
			End If
			
		Case ServerWord.PongWord
			'PONG :barjavel.freenode.net
			If CInt(PongEvent) Then
				PongEvent(AdvancedClientData, GetIrcServerName(wStart))
			End If
			
		Case ServerWord.ErrorWord
			'ERROR :Closing Link: 89.22.170.64 (Client Quit)
			If CInt(ServerErrorEvent) Then
				ServerErrorEvent(AdvancedClientData, GetIrcMessageText(wStart))
			End If
			
			Return False
			
		Case Else
			
			' Имя пользователя, необходимо почти во всех событиях
			Dim strUserName As WString * (MaxBytesCount + 1) = Any
			GetIrcUserName(@strUserName, wServerWord)
			
			' Серверная команда (второе слово)
			Dim IrcCommand As WString Ptr = wStart
			wStart = GetNextWord(wStart)
			
			' Определяем команду
			Select Case GetServerCommand(IrcCommand)
				
				Case ServerCommand.PrivateMessage
					':Angel!wings@irc.org PRIVMSG Wiz :Are you receiving this message ?
					
					' Получатель сообщения
					Dim ircReceiver As WString Ptr = wStart
					wStart = GetNextWord(wStart)
					
					Dim strMessageText As WString Ptr = GetIrcMessageText(wStart)
					
					Dim MessageTextLength As Integer = lstrlen(strMessageText)
					
					' CTCP сообщение
					If MessageTextLength > 2 AndAlso strMessageText[0] = 1 AndAlso strMessageText[MessageTextLength - 1] = 1 Then
						':Angel!wings@irc.org PRIVMSG Qubick :PING 1402355972
						':Angel!wings@irc.org PRIVMSG Qubick :VERSION
						':Angel!wings@irc.org PRIVMSG Qubick :TIME
						':Angel!wings@irc.org PRIVMSG Qubick :USERINFO
						
						
						strMessageText[MessageTextLength - 1] = 0
						
						' Исходим из предположения, что ник «кому» совпадает с нашим
						
						Select Case GetCtcpCommand(@strMessageText[1])
							
							Case CtcpMessageType.Ping
								wStart = GetNextWord(@strMessageText[1])
								
								If CInt(CtcpPingRequestEvent) = 0 Then
									SendCtcpPingResponse(@strUserName, wStart)
								Else
									CtcpPingRequestEvent(AdvancedClientData, @strUserName, ircReceiver, wStart)
								End If
								
							Case CtcpMessageType.UserInfo
								If CInt(CtcpUserInfoRequestEvent) = 0 Then
									If ClientUserInfo <> 0 Then㰊㰼㰼㰼⸠業敮										SendCtcpUserInfoResponse(@strUserName, ClientUserInfo)簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀऀऀऀഀ਀ऀऀऀऀऀऀऀऀ䌀愀猀攀 䌀琀挀瀀䴀攀猀猀愀最攀吀礀瀀攀⸀唀猀攀爀䤀渀昀漀ഀ਀ऀऀऀऀऀऀऀऀऀ䤀昀 䌀䤀渀琀⠀䌀琀挀瀀唀猀攀爀䤀渀昀漀刀攀焀甀攀猀琀䔀瘀攀渀琀⤀ 㴀 　 吀栀攀渀ഀ਀ऀऀऀऀऀऀऀऀऀऀ䤀昀 䌀氀椀攀渀琀唀猀攀爀䤀渀昀漀 㰀㸀 　 吀栀攀渀ഀ਀ऀऀऀऀऀऀऀऀऀऀऀ匀攀渀搀䌀琀挀瀀唀猀攀爀䤀渀昀漀刀攀猀瀀漀渀猀攀⠀䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 䌀氀椀攀渀琀唀猀攀爀䤀渀昀漀⤀ഀ਀ऀऀऀऀऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀ऀऀऀऀऀऀऀऀऀ䔀氀猀攀ഀ਀ऀऀऀऀऀऀऀऀऀऀ䌀琀挀瀀唀猀攀爀䤀渀昀漀刀攀焀甀攀猀琀䔀瘀攀渀琀⠀䄀搀瘀愀渀挀攀搀䌀氀椀攀渀琀䐀愀琀愀Ⰰ 䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 椀爀挀刀攀挀攀椀瘀攀爀⤀ഀ਀㴽㴽㴽ഽऀऀऀऀऀऀऀऀ䌀愀猀攀 䌀琀挀瀀䴀攀猀猀愀最攀吀礀瀀攀⸀唀猀攀爀䤀渀昀漀ഀ਀ऀऀऀऀऀऀऀऀऀ䤀昀 䌀䤀渀琀⠀䌀琀挀瀀唀猀攀爀䤀渀昀漀刀攀焀甀攀猀琀䔀瘀攀渀琀⤀ 㴀 　 吀栀攀渀ഀ਀ऀऀऀऀऀऀऀऀऀऀ䤀昀 䌀氀椀攀渀琀唀猀攀爀䤀渀昀漀 㰀㸀 　 吀栀攀渀ഀ਀ऀऀऀऀऀऀऀऀऀऀऀ匀攀渀搀䌀琀挀瀀唀猀攀爀䤀渀昀漀刀攀猀瀀漀渀猀攀⠀䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 䌀氀椀攀渀琀唀猀攀爀䤀渀昀漀⤀ഀ਀ऀऀऀऀऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀ऀऀऀऀऀऀऀऀऀ䔀氀猀攀ഀ਀ऀऀऀऀऀऀऀऀऀऀ䌀琀挀瀀唀猀攀爀䤀渀昀漀刀攀焀甀攀猀琀䔀瘀攀渀琀⠀䄀搀瘀愀渀挀攀搀䌀氀椀攀渀琀䐀愀琀愀Ⰰ 䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 椀爀挀刀攀挀攀椀瘀攀爀⤀ഀ਀㸾㸾㸾‾爮㤴									End If
								Else㰊㰼㰼㰼⸠業敮									CtcpUserInfoRequestEvent(AdvancedClientData, @strUserName, ircReceiver)
								End If簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀऀऀऀഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴								
							Case CtcpMessageType.Time
								If CInt(CtcpTimeRequestEvent) = 0 Then
									' Tue, 15 Nov 1994 12:45:26 GMT
									Const DateFormatString = "ddd, dd MMM yyyy "
									Const TimeFormatString = "HH:mm:ss GMT"
									Dim TimeValue As WString * 64 = Any
									Dim dtNow As SYSTEMTIME = Any
									㰊㰼㰼㰼⸠業敮									GetSystemTime(@dtNow)
									簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀऀऀऀഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴									Dim dtBufferLength As Integer = GetDateFormat(LOCALE_INVARIANT, 0, @dtNow, @DateFormatString, @TimeValue, 31) - 1
									GetTimeFormat(LOCALE_INVARIANT, 0, @dtNow, @TimeFormatString, @TimeValue[dtBufferLength], 31 - dtBufferLength)
									㰊㰼㰼㰼⸠業敮									Return SendCtcpTimeResponse(@strUserName, @TimeValue)簍籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀऀऀ匀攀渀搀䌀琀挀瀀嘀攀爀猀椀漀渀刀攀猀瀀漀渀猀攀⠀䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 䌀氀椀攀渀琀嘀攀爀猀椀漀渀⤀ഀ㴽㴽㴽ഽऀऀऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 匀攀渀搀䌀琀挀瀀嘀攀爀猀椀漀渀刀攀猀瀀漀渀猀攀⠀䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 䌀氀椀攀渀琀嘀攀爀猀椀漀渀⤀ഀ㸾㸾㸾‾爮㤴
								Else
									CtcpTimeRequestEvent(AdvancedClientData, @strUserName, ircReceiver)
								End If
								
							Case CtcpMessageType.Version㰊㰼㰼㰼⸠業敮								If CInt(CtcpVersionRequestEvent) = 0 Then
									If ClientVersion <> 0 Then簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀऀऀऀഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴										Return SendCtcpVersionResponse(@strUserName, ClientVersion)
									End If
								Else㰊㰼㰼㰼⸠業敮									CtcpVersionRequestEvent(AdvancedClientData, @strUserName, ircReceiver)
								End If簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀऀऀऀഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴								
							Case CtcpMessageType.Action
								If CInt(CtcpActionEvent) Then
									wStart = GetNextWord(@strMessageText[1])
									CtcpActionEvent(AdvancedClientData, @strUserName, ircReceiver, wStart)
								End If
								
							Case Else
								ProcessMessage(ircReceiver, @strUserName, strMessageText)
								
						End Select㰊㰼㰼㰼⸠業敮簍籼籼籼⸠㑲ഷऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㴽㴽㴽ഽऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㸾㸾㸾‾爮㤴					Else
						' Обычное сообщение
						ProcessMessage(ircReceiver, @strUserName, strMessageText)
						㰊㰼㰼㰼⸠業敮簍籼籼籼⸠㑲ഷऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㴽㴽㴽ഽऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㸾㸾㸾‾爮㤴					End If
					
				Case ServerCommand.Notice
					':Angel!wings@irc.org NOTICE Wiz :Are you receiving this message ?
					':Angel!wings@irc.org NOTICE Qubick :PING 1402355972
					
					' Получатель сообщения
					Dim ircReceiver As WString Ptr = wStart
					wStart = GetNextWord(wStart)
					
					Dim strNoticeText As WString Ptr = GetIrcMessageText(wStart)
					
					Dim NoticeTextLength As Integer = lstrlen(strNoticeText)
					
					If NoticeTextLength > 2 AndAlso strNoticeText[0] = 1 AndAlso strNoticeText[NoticeTextLength - 1] = 1 Then
						strNoticeText[NoticeTextLength - 1] = 0
						
						' Дополнительный параметр
						wStart = GetNextWord(@strNoticeText[1])
						
						Select Case GetCtcpCommand(@strNoticeText[1])
							
							Case CtcpMessageType.Ping
								If CInt(CtcpPingResponseEvent) Then
									CtcpPingResponseEvent(AdvancedClientData, @strUserName, ircReceiver, wStart)
								End If
								㰊㰼㰼㰼⸠業敮							Case CtcpMessageType.UserInfo
								If CInt(CtcpUserInfoResponseEvent) Then簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀऀऀऀഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴									CtcpUserInfoResponseEvent(AdvancedClientData, @strUserName, ircReceiver, wStart)
								End If
								
							Case CtcpMessageType.Time㰊㰼㰼㰼⸠業敮								If CInt(CtcpTimeResponseEvent) Then簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴									CtcpTimeResponseEvent(AdvancedClientData, @strUserName, ircReceiver, wStart)
								End If
								
							Case CtcpMessageType.Version
								If CInt(CtcpVersionResponseEvent) Then㰊㰼㰼㰼⸠業敮									CtcpVersionResponseEvent(AdvancedClientData, @strUserName, ircReceiver, wStart)簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴								End If
								
							Case Else
								ProcessNotice(ircReceiver, @strUserName, strNoticeText)
								㰊㰼㰼㰼⸠業敮						End Select簊籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀㴽㴽㴽ഽ㸾㸾㸾‾爮㤴㰍㰼㰼㰼⸠業敮簍籼籼籼⸠㑲ഷऀऀऀऀऀऀऀऀऀഀ਀ऀऀऀऀऀऀऀ䔀渀搀 匀攀氀攀挀琀ഀ਀ऀऀऀऀऀऀऀഀ਀ऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀ऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀ऀऀऀऀऀഀ਀ऀऀऀऀऀ䤀昀 氀猀琀爀挀洀瀀⠀椀爀挀刀攀挀攀椀瘀攀爀Ⰰ 䀀洀开一椀挀欀⤀ 㴀 　 吀栀攀渀ഀ਀ऀऀऀऀऀऀ✀ ⌀㈄㔄㐄㸄㰄㬄㔄㴄㠄㔄 㸀䈄 㼀㸄㬄䰄㜄㸄㈄〄䈄㔄㬄伄ഄ਀ऀऀऀऀऀऀ䤀昀 䌀䤀渀琀⠀一漀琀椀挀攀䔀瘀攀渀琀⤀ 吀栀攀渀ഀ਀ऀऀऀऀऀऀऀ一漀琀椀挀攀䔀瘀攀渀琀⠀䄀搀瘀愀渀挀攀搀䌀氀椀攀渀琀䐀愀琀愀Ⰰ 䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 猀琀爀䴀攀猀猀愀最攀吀攀砀琀⤀ഀ਀ऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㴽㴽㴽ഽऀऀऀऀऀऀऀऀऀഀ਀ऀऀऀऀऀऀऀ䔀渀搀 匀攀氀攀挀琀ഀ਀ऀऀऀऀऀऀऀഀ਀ऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀ऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀ऀऀऀऀऀഀ਀ऀऀऀऀऀ䤀昀 氀猀琀爀挀洀瀀⠀椀爀挀刀攀挀攀椀瘀攀爀Ⰰ 䀀洀开一椀挀欀⤀ 㴀 　 吀栀攀渀ഀ਀ऀऀऀऀऀऀ✀ ⌀㈄㔄㐄㸄㰄㬄㔄㴄㠄㔄 㸀䈄 㼀㸄㬄䰄㜄㸄㈄〄䈄㔄㬄伄ഄ਀ऀऀऀऀऀऀ䤀昀 䌀䤀渀琀⠀一漀琀椀挀攀䔀瘀攀渀琀⤀ 吀栀攀渀ഀ਀ऀऀऀऀऀऀऀ一漀琀椀挀攀䔀瘀攀渀琀⠀䄀搀瘀愀渀挀攀搀䌀氀椀攀渀琀䐀愀琀愀Ⰰ 䀀猀琀爀唀猀攀爀一愀洀攀Ⰰ 猀琀爀䴀攀猀猀愀最攀吀攀砀琀⤀ഀ਀ऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㸾㸾㸾‾爮㤴					Else
						' Обычное уведомление
						ProcessNotice(ircReceiver, @strUserName, strNoticeText)
						㰊㰼㰼㰼⸠業敮簍籼籼籼⸠㑲ഷऀऀऀऀऀऀऀ刀攀琀甀爀渀 吀爀甀攀ഀ਀ऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㴽㴽㴽ഽऀऀऀऀऀऀ䔀渀搀 䤀昀ഀ਀㸾㸾㸾‾爮㤴					End If
					
				Case ServerCommand.Join
					' Кто-то присоединился к каналу
					':Qubick!~Qubick@irc.org JOIN ##freebasic
					If CInt(UserJoinedEvent) Then
						UserJoinedEvent(AdvancedClientData, wStart, @strUserName)
					End If
					
				Case ServerCommand.Quit
					' Кто-то вышел
					If CInt(QuitEvent) Then
						QuitEvent(AdvancedClientData, @strUserName, GetIrcMessageText(wStart))
					End If
					
				Case ServerCommand.Invite
					' приглашение пользователя на канал
					' от кого INVITE кому канал
					':Angel!wings@irc.org INVITE Wiz #Dust
					If CInt(InviteEvent) Then
						Dim ircReceiver As WString Ptr = wStart
						' Канал на который зовут
						wStart = GetNextWord(wStart)
						InviteEvent(AdvancedClientData, @strUserName, wStart)
					End If
					
				Case ServerCommand.Kick
					' Удар по пользователю
					':WiZ!jto@tolsun.oulu.fi KICK #Finnish John
					'KICK message on channel #Finnish
					'from WiZ to remove John from channel
					If CInt(KickEvent) Then
						' Имя канала, с которого ударили
						Dim Channel As WString Ptr = wStart
						wStart = GetNextWord(wStart)
						' В wStart имя пользователя которого ударили
						KickEvent(AdvancedClientData, @strUserName, Channel, wStart)
					End If
					
				Case ServerCommand.Mode
					' Установка режима
					':ChanServ!ChanServ@services. MODE ##freebasic +v ssteiner
					' нужны данные: кто включил статус
					' кому включили статус
					' на каком канале включили статус
					' и текст строки
					If CInt(ModeEvent) Then
						' Кто изменил режим
						'ircData2 - канал
						Dim Channel As WString Ptr = wStart
						wStart = GetNextWord(wStart)
						
						'ircData3 - режим
						Dim Mode As WString Ptr = wStart
						wStart = GetNextWord(wStart)
						
						'ircData4 - кому установили режим
						
						ModeEvent(AdvancedClientData, @strUserName, Channel, wStart, Mode)
					End If
					
				Case ServerCommand.Nick
					' Кто-то сменил ник
					' В ircData2 содержится новый ник
					If CInt(NickChangedEvent) Then
						NickChangedEvent(AdvancedClientData, @strUserName, wStart)
					End If
					
				Case ServerCommand.Part
					' Пользователь покинул канал
					If CInt(UserLeavedEvent) Then
						UserLeavedEvent(AdvancedClientData, wStart, @strUserName, GetIrcMessageText(wStart))
					End If
					
				Case ServerCommand.Topic
					' Смена темы
					If CInt(TopicEvent) Then
						TopicEvent(AdvancedClientData, wStart, @strUserName, GetIrcMessageText(wStart))
					End If
					
				Case ServerCommand.SQuit
					' Выход оператора
					If CInt(QuitEvent) Then
						QuitEvent(AdvancedClientData, @strUserName, GetIrcMessageText(wStart))
					End If
					
				Case Else
					' Серверное сообщение
					If CInt(ServerMessageEvent) Then
						' IrcCommand — код сообщения
						' ник получателя
						Dim ircReceiver As WString Ptr = wStart
						wStart = GetNextWord(wStart)
						
						ServerMessageEvent(AdvancedClientData, IrcCommand, wStart)
					End If
					
			End Select
			
	End Select
	
	Return True
	
End Function
