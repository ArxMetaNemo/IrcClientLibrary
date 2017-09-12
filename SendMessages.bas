#include once "Irc.bi"
#include once "StringConstants.bi"

' Максимальная длина ника в чате
Const MaxNickLength As Integer = 50
' Максимальная длина канала в чате
Const MaxChannelNameLength As Integer = 50
' Максимальная длина параметра в CTCP запросах
Const MaxCtcpMessageParamLength As Integer = 50

Public Function IrcClient.ChangeNick(ByVal Nick As WString Ptr)As Boolean
	Dim strSend As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strSend, @NickStringWithSpace)
	lstrcpyn(@m_Nick, Nick, MaxNickLength)
	lstrcat(@strSend, @m_Nick)
	Return SendData(@strSend)
End Function

Public Function IrcClient.JoinChannel(ByVal strChannel As WString Ptr)As Boolean
	Dim strSend As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strSend, @JoinStringWithSpace)
	lstrcpyn(@strSend + JoinStringWithSpaceLength, strChannel, MaxChannelNameLength)
	Return SendData(@strSend)
End Function

Public Function IrcClient.PartChannel(ByVal strChannel As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PartStringWithSpace)
	lstrcpyn(@strTemp + PartStringWithSpaceLength, strChannel, MaxChannelNameLength)
	Return SendData(@strTemp)
End Function

Public Function IrcClient.PartChannel(ByVal strChannel As WString Ptr, ByVal strMessageText As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PartStringWithSpace)
	lstrcpyn(@strTemp + PartStringWithSpaceLength, strChannel, MaxChannelNameLength)
	If lstrlen(strMessageText) <> 0 Then
		lstrcat(@strTemp, @SpaceWithCommaString)
		Dim strTempLength As Integer = lstrlen(@strTemp)
		lstrcpyn(@strTemp + strTempLength, strMessageText, MaxBytesCount - 2 - strTempLength)
	End If
	Return SendData(@strTemp)
End Function

Public Function IrcClient.QuitFromServer()As Boolean
	Return SendData(@QuitString)
End Function

Public Function IrcClient.QuitFromServer(ByVal strMessageText As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	If lstrlen(strMessageText) = 0 Then
		lstrcpy(@strTemp, @QuitString)
	Else
		lstrcpy(@strTemp, @QuitStringWithSpace)
		lstrcpyn(@strTemp + QuitStringWithSpaceLength, strMessageText, MaxBytesCount - 2 - QuitStringWithSpaceLength)
	End If
	Return SendData(@strTemp)
End Function

Public Function IrcClient.SendPong(ByVal strServer As WString Ptr)As Boolean
	Dim strPong As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strPong, @PongStringWithSpace)
	lstrcpyn(@strPong + PongStringWithSpaceLength, strServer, MaxBytesCount - 2 - lstrlen(strServer) - PongStringWithSpaceLength)
	Return SendData(@strPong)
End Function

Public Function IrcClient.SendPing(ByVal strServer As WString Ptr)As Boolean
	Dim strPing As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strPing, @PingString)
	lstrcat(@strPing, @SpaceWithCommaString)
	lstrcpyn(@strPing + PingStringLength + SpaceWithCommaStringLength, strServer, MaxBytesCount - 2 - lstrlen(strServer) - PingStringLength - SpaceWithCommaStringLength)
	Return SendData(@strPing)
End Function

Public Function IrcClient.SendRawMessage(ByVal strRawText As WString Ptr)As Boolean
	Return SendData(strRawText)
End Function

Public Function IrcClient.SendIrcMessage(ByVal strChannel As WString Ptr, ByVal strMessageText As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, strChannel, MaxChannelNameLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, strMessageText, MaxBytesCount - 2 - strTempLength)
	Return SendData(@strTemp)
End Function

Public Function IrcClient.ChangeTopic(ByVal strChannel As WString Ptr, ByVal strTopic As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @TopicStringWithSpace)
	lstrcpyn(@strTemp + TopicStringWithSpaceLength, strChannel, MaxChannelNameLength)
	If strTopic <> 0 Then
		lstrcat(@strTemp, @SpaceWithCommaString)
		Dim strTempLength As Integer = lstrlen(@strTemp)
		lstrcpyn(@strTemp + strTempLength, strTopic, MaxBytesCount - 2 - strTempLength)
	End If
	Return SendData(@strTemp)
End Function

' Отправка уведомления
Public Function IrcClient.SendNotice(ByVal strChannel As WString Ptr, ByVal strNoticeText As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, strChannel, MaxChannelNameLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, strNoticeText, MaxBytesCount - 2 - strTempLength)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpPingRequest(ByVal UserName As WString Ptr, ByVal TimeValue As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, MaxNickLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @PingStringWithSpace)
	Dim intLen As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + intLen, TimeValue, MaxBytesCount - intLen - 3)
	
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpTimeRequest(ByVal UserName As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, MaxNickLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @TimeString)
	
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpUserInfoRequest(ByVal UserName As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, MaxNickLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @UserInfoString)
	
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpVersionRequest(ByVal UserName As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, MaxNickLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @VersionString)
	
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpAction(ByVal UserName As WString Ptr, ByVal MessageText As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, MaxNickLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @ActionStringWithSpace)
	Dim intLen As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + intLen, MessageText, MaxBytesCount - intLen - 3)
	
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpPingResponse(ByVal UserName As WString Ptr, ByVal TimeValue As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, MaxChannelNameLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @PingStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, TimeValue, MaxBytesCount - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpTimeResponse(ByVal UserName As WString Ptr, ByVal TimeValue As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, MaxChannelNameLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @TimeStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, TimeValue, MaxBytesCount - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpUserInfoResponse(ByVal UserName As WString Ptr, ByVal UserInfo As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, MaxChannelNameLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @UserInfoStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, UserInfo, MaxBytesCount - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function

Function IrcClient.SendCtcpVersionResponse(ByVal UserName As WString Ptr, ByVal Version As WString Ptr)As Boolean
	Dim strTemp As WString * (MaxBytesCount + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, MaxChannelNameLength)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @VersionStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, Version, MaxBytesCount - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	Return SendData(@strTemp)
End Function
