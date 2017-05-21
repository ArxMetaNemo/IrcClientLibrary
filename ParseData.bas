#include once "Irc.bi"

' Символ пробела
Const WhiteSpaceChar As Integer = &h0020
' Двоеточие
Const ColonChar As Integer = &h003A


' Разбираем сообщение и вызываем соответствующие события
Function IrcClient.ParseData(ByVal strData As WString Ptr)As ResultType
	' Копия данных для сохранения оригинала
	Dim strCopyData As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strCopyData, strData)
	Dim wStart As WString Ptr = @strCopyData
	
	' Первое слово
	Dim wServerWord As WString Ptr = wStart
	
	' Найти первый пробел и удалить
	Dim wSpace As WString Ptr = StrChr(wStart, WhiteSpaceChar)
	If wSpace <> 0 Then
		wSpace[0] = 0
		wStart = wSpace + 1
	End If
	
	Select Case GetServerWord(wServerWord)
		Case ServerWord.PingWord
			'PING :barjavel.freenode.net
			If CInt(PingEvent) Then
				' Понг не отправлять, это сделает сам клиент
				Dim strServer As WString * (MaxBytesCount + 1) = Any
				GetIrcServerName(@strServer, strData)
				Return PingEvent(ExtendedData, @strServer)
			Else
				' Отправляем понг самостоятельно
				Dim strPong As WString * (MaxBytesCount + 1) = Any
				lstrcpy(@strPong, @PongStringWithSpace)
				Dim w As WString Ptr = StrChr(strData, ColonChar)
				If w <> 0 Then
					lstrcpy(@strPong + 5, w + 1)
				End If
				Return SendData(@strPong)
			End If
			
		Case ServerWord.PongWord
			'PONG :barjavel.freenode.net
			If CInt(PongEvent) Then
				Dim strServer As WString * (MaxBytesCount + 1) = Any
				GetIrcServerName(@strServer, strData)
				Return PongEvent(ExtendedData, @strServer)
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
			wSpace = StrChr(wStart, WhiteSpaceChar)
			If wSpace <> 0 Then
				wSpace[0] = 0
				wStart = wSpace + 1
			End If
			
			' Третье слово
			Dim ircData2 As WString Ptr = wStart
			wSpace = StrChr(wStart, WhiteSpaceChar)
			If wSpace <> 0 Then
				wSpace[0] = 0
				wStart = wSpace + 1
			End If
			
			' Определяем команду
			Select Case GetServerCommand(IrcCommand)
				Case ServerCommand.PrivateMessage
					':Angel!wings@irc.org PRIVMSG Wiz :Are you receiving this message ?
					
					' В ircData2 содержится имя получателя
					Dim strMessageText As WString * (MaxBytesCount + 1) = Any
					GetIrcMessageText(@strMessageText, strData)
					
					':Angel!wings@irc.org PRIVMSG Qubick :PING 1402355972
					' PRIVMSG Qubick :VERSION
					' PRIVMSG Qubick :TIME
					' PRIVMSG Qubick :USERINFO
					
					' Команда
					Dim MessageTextLength As Integer = lstrlen(@strMessageText)
					If MessageTextLength > 2 Then
						' Проверить последний символ в строке на 
						If strMessageText[0] = 1 AndAlso strMessageText[MessageTextLength - 1] = 1 Then
							If CInt(CtcpMessageEvent) Then
								strMessageText[MessageTextLength - 1] = 0
								' Исходим из предположения, что ник «кому» совпадает с нашим
								
								' Найти пробел и удалить
								wSpace = StrChr(@strMessageText, WhiteSpaceChar)
								If wSpace <> 0 Then
									wSpace[0] = 0
									wSpace += 1
								End If
								
								If lstrcmp(@strMessageText[1], @PingString) = 0 Then
									Return CtcpMessageEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.Ping, wSpace)
								End If
								If lstrcmp(@strMessageText[1], @UserInfoString) = 0 Then
									Return CtcpMessageEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.UserInfo, 0)
								End If
								If lstrcmp(@strMessageText[1], @TimeString) = 0 Then
									Return CtcpMessageEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.Time, 0)
								End If
								If lstrcmp(@strMessageText[1], @VersionString) = 0 Then
									Return CtcpMessageEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.Version, 0)
								End If
							End If
						End If
					End If
					
					' Обычное сообщение
					If lstrcmp(ircData2, @m_Nick) = 0 Then
						' Сообщение от пользователя
						If CInt(PrivateMessageEvent) Then
							Return PrivateMessageEvent(ExtendedData, @strUserName, @strMessageText)
						End If
					Else
						' ircData2 - канал
						If CInt(ChannelMessageEvent) Then
							Return ChannelMessageEvent(ExtendedData, ircData2, @strUserName, @strMessageText)
						End If
					End If
					
				Case ServerCommand.Notice
					':Angel!wings@irc.org NOTICE Wiz :Are you receiving this message ?
					Dim strMessageText As WString * (MaxBytesCount + 1) = Any
					GetIrcMessageText(@strMessageText, strData)
					
					':Angel!wings@irc.org NOTICE Qubick :PING 1402355972
					
					Dim NoticeTextLength As Integer = lstrlen(@strMessageText)
					If NoticeTextLength > 2 Then
						If strMessageText[0] = 1 AndAlso strMessageText[NoticeTextLength - 1] = 1 Then
							If CInt(CtcpNoticeEvent) Then
								strMessageText[NoticeTextLength - 1] = 0
								' Найти пробел и удалить
								wSpace = StrChr(@strMessageText, WhiteSpaceChar)
								If wSpace <> 0 Then
									wSpace[0] = 0
									wSpace += 1
								End If
								
								If lstrcmp(@strMessageText[1], @PingString) = 0 Then
									Return CtcpNoticeEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.Ping, wSpace)
								End If
								If lstrcmp(@strMessageText[1], @UserInfoString) = 0 Then
									Return CtcpNoticeEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.UserInfo, wSpace)
								End If
								If lstrcmp(@strMessageText[1], @TimeString) = 0 Then
									Return CtcpNoticeEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.Time, wSpace)
								End If
								If lstrcmp(@strMessageText[1], @VersionString) = 0 Then
									Return CtcpNoticeEvent(ExtendedData, @strUserName, ircData2, CtcpMessageType.Version, wSpace)
								End If
							End If
						End If
					End If
					
					If lstrcmp(ircData2, @m_Nick) = 0 Then
						' Уведомление от пользователя
						If CInt(NoticeEvent) Then
							Return NoticeEvent(ExtendedData, @strUserName, strMessageText)
						End If
					Else
						' ircData2 - канал
						If CInt(ServerMessageEvent) Then
							Return ServerMessageEvent(ExtendedData, ircData2, strMessageText)
						End If
					End If
					
				Case ServerCommand.Join
					' Кто-то присоединился к каналу
					':Qubick!~Qubick@irc.org JOIN ##freebasic
					If CInt(UserJoinedEvent) Then
						Return UserJoinedEvent(ExtendedData, ircData2, @strUserName)
					End If
					
				Case ServerCommand.Quit
					' Кто-то вышел
					If CInt(QuitEvent) Then
						Dim strMessageText As WString * (MaxBytesCount + 1) = Any
						GetIrcMessageText(@strMessageText, strData)
						Return QuitEvent(ExtendedData, @strUserName, @strMessageText)
					End If
					
				Case ServerCommand.Invite
					' приглашение пользователя на канал
					' от кого INVITE кому канал
					':Angel!wings@irc.org INVITE Wiz #Dust
					If CInt(InviteEvent) Then
						' В ircData3 содержится имя канала
						Return InviteEvent(ExtendedData, @strUserName, wStart)
					End If
					
				Case ServerCommand.Kick
					' Удар по пользователю
					':WiZ!jto@tolsun.oulu.fi KICK #Finnish John
					'KICK message on channel #Finnish
					'from WiZ to remove John from channel
					If CInt(KickEvent) Then
						'В ircData2 содержится имя канала, с которого ударили
						'В ircData3 содержится имя пользователя которого ударили
						Return KickEvent(ExtendedData, @strUserName, ircData2, wStart)
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
						'ircData3 - режим
						'ircData4 - кому установили режим
						
						' Четвёртое слово
						Dim ircData3 As WString Ptr = wStart
						wSpace = StrChr(wStart, WhiteSpaceChar)
						If wSpace <> 0 Then
							wSpace[0] = 0
							wStart = wSpace + 1
						End If
						
						Return ModeEvent(ExtendedData, @strUserName, ircData2, wStart, ircData3)
					End If
					
				Case ServerCommand.Nick
					' Кто-то сменил ник
					' В ircData2 содержится новый ник
					If CInt(NickChangedEvent) Then
						Return NickChangedEvent(ExtendedData, @strUserName, ircData2)
					End If
					
				Case ServerCommand.Part
					' Пользователь покинул канал
					If CInt(UserLeavedEvent) Then
						Dim strMessageText As WString * (MaxBytesCount + 1) = Any
						GetIrcMessageText(@strMessageText, strData)
						Return  UserLeavedEvent(ExtendedData, ircData2, @strUserName, @strMessageText)
					End If
					
				Case ServerCommand.Topic
					' Смена темы
					If CInt(TopicEvent) Then
						Dim strMessageText As WString * (MaxBytesCount + 1) = Any
						GetIrcMessageText(@strMessageText, strData)
						Return TopicEvent(ExtendedData, ircData2, @strUserName, @strMessageText)
					End If
					
				Case ServerCommand.SQuit
					' Выход оператора
					If CInt(QuitEvent) Then
						Dim strMessageText As WString * (MaxBytesCount + 1) = Any
						GetIrcMessageText(@strMessageText, strData)
						Return QuitEvent(ExtendedData, @strUserName, @strMessageText)
					End If
					
				Case Else
					' Серверное сообщение
					If CInt(ServerMessageEvent) Then
						' IrcCommand — код сообщения
						' ircData2 — ник получателя
						' а дальше идут данные
						Dim strMessage As WString * (MaxBytesCount + 1) = Any
						Return ServerMessageEvent(ExtendedData, IrcCommand, @strMessage)
					End If
					
			End Select
			
	End Select
	
	Return ResultType.None
	
End Function
