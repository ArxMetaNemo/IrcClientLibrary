#include once "Irc.bi"
#include once "StringConstants.bi"

' Разбираем сообщение и вызываем соответствующие события
Function IrcClient.ParseData(ByVal strData As WString Ptr)As ResultType
	' Копия данных для сохранения оригинала
	Dim strCopyData As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strCopyData, strData)
	Dim wStart As WString Ptr = @strCopyData
	
	' Первое слово
	Dim wServerWord As WString Ptr = wStart
	
	' Отделить первое слово в строке
	wStart = GetNextWord(wStart)
	
	Select Case GetServerWord(wServerWord)
		Case ServerWord.PingWord
			'PING :barjavel.freenode.net
			If CInt(PingEvent) Then
				' Понг не отправлять, это сделает сам клиент
				Return PingEvent(ExtendedData, GetIrcServerName(strData))
			Else
				' Отправляем понг самостоятельно
				Return SendPong(GetIrcServerName(strData))
			End If
			
		Case ServerWord.PongWord
			'PONG :barjavel.freenode.net
			If CInt(PongEvent) Then
				Return PongEvent(ExtendedData, GetIrcServerName(strData))
			End If
			
		Case ServerWord.ErrorWord
			'ERROR :Closing Link: 89.22.170.64 (Client Quit)
			If CInt(ServerErrorEvent) Then
				Dim strMessageText As WString * (MaxBytesCount + 1) = Any
				Dim w As WString Ptr = StrChr(strData, ColonChar)
				If w <> 0 Then
					lstrcpy(@strMessageText, w + 1)
				Else
					strMessageText[0] = 0
				End If
				ServerErrorEvent(ExtendedData, @strMessageText)
			End If
			Return ResultType.ServerError
			
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
			
					Dim strMessageText As WString Ptr = GetIrcMessageText(strData)
					
					':Angel!wings@irc.org PRIVMSG Qubick :PING 1402355972
					' PRIVMSG Qubick :VERSION
					' PRIVMSG Qubick :TIME
					' PRIVMSG Qubick :USERINFO
					
					' CTCP сообщение
					
					Dim MessageTextLength As Integer = lstrlen(strMessageText)
					If MessageTextLength > 2 Then
						' Проверить последний символ в строке на 
						If strMessageText[0] = 1 AndAlso strMessageText[MessageTextLength - 1] = 1 Then
							If CInt(CtcpMessageEvent) Then
								strMessageText[MessageTextLength - 1] = 0
								' Исходим из предположения, что ник «кому» совпадает с нашим
								
								' Дополнительный параметр
								wStart = GetNextWord(wStart)
								
								Select Case GetCtcpCommand(@strMessageText[1])
									Case CtcpMessageType.Ping
										Return CtcpMessageEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.Ping, wStart)
									Case CtcpMessageType.UserInfo
										Return CtcpMessageEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.UserInfo, wStart)
									Case CtcpMessageType.Time
										Return CtcpMessageEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.Time, wStart)
									Case CtcpMessageType.Version
										Return CtcpMessageEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.Version, wStart)
								End Select
								
							End If
						End If
					End If
					
					' Обычное сообщение
					
					If lstrcmp(ircReceiver, @m_Nick) = 0 Then
						' Сообщение от пользователя
						If CInt(PrivateMessageEvent) Then
							Return PrivateMessageEvent(ExtendedData, @strUserName, strMessageText)
						End If
					Else
						' Сообщение с канала
						If CInt(ChannelMessageEvent) Then
							Return ChannelMessageEvent(ExtendedData, ircReceiver, @strUserName, strMessageText)
						End If
					End If
					
				Case ServerCommand.Notice
					':Angel!wings@irc.org NOTICE Wiz :Are you receiving this message ?
					Dim strMessageText As WString Ptr = GetIrcMessageText(strData)
					
					':Angel!wings@irc.org NOTICE Qubick :PING 1402355972
					
					' Получатель сообщения
					Dim ircReceiver As WString Ptr = wStart
					wStart = GetNextWord(wStart)
					
					Dim NoticeTextLength As Integer = lstrlen(strMessageText)
					If NoticeTextLength > 2 Then
						If strMessageText[0] = 1 AndAlso strMessageText[NoticeTextLength - 1] = 1 Then
							If CInt(CtcpNoticeEvent) Then
								strMessageText[NoticeTextLength - 1] = 0
								
								' Дополнительный параметр
								wStart = GetNextWord(wStart)
								
								Select Case GetCtcpCommand(@strMessageText[1])
									Case CtcpMessageType.Ping
										Return CtcpNoticeEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.Ping, wStart)
									Case CtcpMessageType.UserInfo
										Return CtcpNoticeEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.UserInfo, wStart)
									Case CtcpMessageType.Time
										Return CtcpNoticeEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.Time, wStart)
									Case CtcpMessageType.Version
										Return CtcpNoticeEvent(ExtendedData, @strUserName, ircReceiver, CtcpMessageType.Version, wStart)
								End Select
								
							End If
						End If
					End If
					
					If lstrcmp(ircReceiver, @m_Nick) = 0 Then
						' Уведомление от пользователя
						If CInt(NoticeEvent) Then
							Return NoticeEvent(ExtendedData, @strUserName, strMessageText)
						End If
					Else
						' Уведомление с канала
						If CInt(ServerMessageEvent) Then
							Return ServerMessageEvent(ExtendedData, ircReceiver, strMessageText)
						End If
					End If
					
				Case ServerCommand.Join
					' Кто-то присоединился к каналу
					':Qubick!~Qubick@irc.org JOIN ##freebasic
					If CInt(UserJoinedEvent) Then
						Return UserJoinedEvent(ExtendedData, wStart, @strUserName)
					End If
					
				Case ServerCommand.Quit
					' Кто-то вышел
					If CInt(QuitEvent) Then
						Return QuitEvent(ExtendedData, @strUserName, GetIrcMessageText(strData))
					End If
					
				Case ServerCommand.Invite
					' приглашение пользователя на канал
					' от кого INVITE кому канал
					':Angel!wings@irc.org INVITE Wiz #Dust
					If CInt(InviteEvent) Then
						Dim ircReceiver As WString Ptr = wStart
						' Канал на который зовут
						wStart = GetNextWord(wStart)
						Return InviteEvent(ExtendedData, @strUserName, wStart)
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
						Return KickEvent(ExtendedData, @strUserName, Channel, wStart)
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
						
						Return ModeEvent(ExtendedData, @strUserName, Channel, wStart, Mode)
					End If
					
				Case ServerCommand.Nick
					' Кто-то сменил ник
					' В ircData2 содержится новый ник
					If CInt(NickChangedEvent) Then
						Return NickChangedEvent(ExtendedData, @strUserName, wStart)
					End If
					
				Case ServerCommand.Part
					' Пользователь покинул канал
					If CInt(UserLeavedEvent) Then
						Return UserLeavedEvent(ExtendedData, wStart, @strUserName, GetIrcMessageText(strData))
					End If
					
				Case ServerCommand.Topic
					' Смена темы
					If CInt(TopicEvent) Then
						Return TopicEvent(ExtendedData, wStart, @strUserName, GetIrcMessageText(strData))
					End If
					
				Case ServerCommand.SQuit
					' Выход оператора
					If CInt(QuitEvent) Then
						Return QuitEvent(ExtendedData, @strUserName, GetIrcMessageText(strData))
					End If
					
				Case Else
					' Серверное сообщение
					If CInt(ServerMessageEvent) Then
						' IrcCommand — код сообщения
						' ник получателя
						Dim ircReceiver As WString Ptr = wStart
						wStart = GetNextWord(wStart)
						
						Return ServerMessageEvent(ExtendedData, IrcCommand, wStart)
					End If
					
			End Select
			
	End Select
	
	Return ResultType.None
	
End Function
