#include "SendMessages.bi"
#include "IntegerToWString.bi"
#include "SendData.bi"
#include "StringConstants.bi"

Function IrcClientSendPrivateMessage( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strChannel As LPCWSTR, _
		ByVal strMessageText As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, strChannel, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, strMessageText, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - strTempLength)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendNotice( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strChannel As LPCWSTR, _
		ByVal strNoticeText As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, strChannel, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, strNoticeText, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - strTempLength)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientChangeTopic( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strChannel As LPCWSTR, _
		ByVal strTopic As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @TopicStringWithSpace)
	lstrcpyn(@strTemp + TopicStringWithSpaceLength, strChannel, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	
	If strTopic <> 0 Then
		lstrcat(@strTemp, @SpaceWithCommaString)
		Dim strTempLength As Integer = lstrlen(@strTemp)
		lstrcpyn(@strTemp + strTempLength, strTopic, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - strTempLength)
	End If
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientQuitFromServer( _
		ByVal pIrcClient As IrcClient Ptr _
	)As Boolean
	
	Return SendData(pIrcClient, @QuitString)
	
End Function

Function IrcClientQuitFromServer( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strMessageText As LPCWSTR _
	)As Boolean
	
	If lstrlen(strMessageText) = 0 Then
		Return SendData(pIrcClient, @QuitString)
	Else
		Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
		lstrcpy(@strTemp, @QuitStringWithSpace)
		lstrcpyn(@strTemp + QuitStringWithSpaceLength, strMessageText, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - QuitStringWithSpaceLength)
		Return SendData(pIrcClient, @strTemp)
	End If
	
End Function

Function IrcClientChangeNick( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal Nick As LPCWSTR _
	)As Boolean
	
	Dim strSend As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strSend, @NickStringWithSpace)
	lstrcpyn(@pIrcClient->ClientNick, Nick, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	lstrcat(@strSend, @pIrcClient->ClientNick)
	
	Return SendData(pIrcClient, @strSend)
	
End Function

Function IrcClientJoinChannel( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strChannel As LPCWSTR _
	)As Boolean
	
	Dim strSend As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strSend, @JoinStringWithSpace)
	lstrcpyn(@strSend + JoinStringWithSpaceLength, strChannel, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	
	Return SendData(pIrcClient, @strSend)
	
End Function

Function IrcClientPartChannel( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strChannel As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PartStringWithSpace)
	lstrcpyn(@strTemp + PartStringWithSpaceLength, strChannel, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientPartChannel( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strChannel As LPCWSTR, _
		ByVal strMessageText As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PartStringWithSpace)
	lstrcpyn(@strTemp + PartStringWithSpaceLength, strChannel, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	
	If lstrlen(strMessageText) <> 0 Then
		lstrcat(@strTemp, @SpaceWithCommaString)
		Dim strTempLength As Integer = lstrlen(@strTemp)
		lstrcpyn(@strTemp + strTempLength, strMessageText, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - strTempLength)
	End If
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendWho( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR _
	) As Boolean
	
	Dim strSend As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strSend, @WhoStringWithSpace)
	lstrcpyn(@strSend + WhoStringWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	
	Return SendData(pIrcClient, @strSend)
	
End Function

Function IrcClientSendWhoIs( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR _
	) As Boolean
	
	Dim strSend As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strSend, @WhoIsStringWithSpace)
	lstrcpyn(@strSend + WhoIsStringWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	
	Return SendData(pIrcClient, @strSend)
	
End Function

' Declare Function IrcClientSendAdmin Overload( _
	' ByVal pIrcClient As IrcClient Ptr _
' ) As Boolean

' Declare Function IrcClientSendAdmin Overload( _
	' ByVal pIrcClient As IrcClient Ptr, _
	' ByVal Server As LPCWSTR _
' ) As Boolean

' Declare Function IrcClientSendInfo Overload( _
	' ByVal pIrcClient As IrcClient Ptr _
' ) As Boolean

' Declare Function IrcClientSendInfo Overload( _
	' ByVal pIrcClient As IrcClient Ptr, _
	' ByVal Server As LPCWSTR _
' ) As Boolean

' Declare Function IrcClientSendAway Overload( _
	' ByVal pIrcClient As IrcClient Ptr _
' ) As Boolean

' Declare Function IrcClientSendAway Overload( _
	' ByVal pIrcClient As IrcClient Ptr, _
	' ByVal MessageText As LPCWSTR _
' ) As Boolean

' Declare Function IrcClientSendIsON( _
	' ByVal pIrcClient As IrcClient Ptr, _
	' ByVal NickList As LPCWSTR _
' ) As Boolean

' Declare Function IrcClientSendKick Overload( _
	' ByVal pIrcClient As IrcClient Ptr, _
	' ByVal Channel As LPCWSTR, _
	' ByVal UserName As LPCWSTR _
' ) As Boolean

' Declare Function IrcClientSendKick Overload( _
	' ByVal pIrcClient As IrcClient Ptr, _
	' ByVal Channel As LPCWSTR, _
	' ByVal UserName As LPCWSTR, _
	' ByVal MessageText As LPCWSTR _
' ) As Boolean

' Declare Function IrcClientSendInvite( _
	' ByVal pIrcClient As IrcClient Ptr, _
	' ByVal UserName As LPCWSTR, _
	' ByVal Channel As LPCWSTR _
' ) As Boolean

Function IrcClientSendCtcpPingRequest( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal TimeValue As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @PingStringWithSpace)
	Dim intLen As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + intLen, TimeValue, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - intLen - 3)
	
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpTimeRequest( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @TimeString)
	
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpUserInfoRequest( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @UserInfoString)
	
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpVersionRequest( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @VersionString)
	
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpAction( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal MessageText As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @ActionStringWithSpace)
	Dim intLen As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + intLen, MessageText, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - intLen - 3)
	
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpPingResponse( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal TimeValue As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @PingStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, TimeValue, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpTimeResponse( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal TimeValue As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @TimeStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, TimeValue, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpUserInfoResponse( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal UserInfo As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @UserInfoStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, UserInfo, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendCtcpVersionResponse( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal Version As LPCWSTR _
	)As Boolean
	
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @NoticeStringWithSpace)
	' TODO возможно переполнение буфера
	lstrcpyn(@strTemp + NoticeStringWithSpaceLength, UserName, IRCPROTOCOL_CHANNELNAMELENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @VersionStringWithSpace)
	
	Dim strTempLength As Integer = lstrlen(@strTemp)
	lstrcpyn(@strTemp + strTempLength, Version, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - 1 - strTempLength)
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendDccSend Overload( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal FileName As LPCWSTR, _
		ByVal IPAddress As LPCWSTR, _
		ByVal Port As Integer _
	) As Boolean
	
	Return IrcClientSendDccSend(pIrcClient, UserName, FileName, IPAddress, Port, 0)
	
End Function

Function IrcClientSendDccSend Overload( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal UserName As LPCWSTR, _
		ByVal FileName As LPCWSTR, _
		ByVal IPAddress As LPCWSTR, _
		ByVal Port As Integer, _
		ByVal FileLength As ULongInt _
	) As Boolean
	
	' TODO возможно переполнение буфера
	Dim strTemp As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strTemp, @PrivateMessageWithSpace)
	lstrcpyn(@strTemp + PrivateMessageWithSpaceLength, UserName, IRCPROTOCOL_NICKLENGTHMAXIMUM)
	lstrcat(@strTemp, @SpaceWithCommaString)
	lstrcat(@strTemp, @SohString)
	
	lstrcat(@strTemp, @DccSendWithSpace)
	lstrcat(@strTemp, FileName)
	lstrcat(@strTemp, @WhiteSpaceString)
	lstrcat(@strTemp, IPAddress)
	lstrcat(@strTemp, @WhiteSpaceString)
	
	Dim wszPort As WString * 100 = Any
	ltow(CLng(Port), @wszPort, 10)
	
	lstrcat(@strTemp, wszPort)
	
	If FileLength > 0 Then
		lstrcat(@strTemp, @WhiteSpaceString)
		
		Dim strFileLength As WString * 64 = Any
		i64tow(FileLength, @strFileLength, 10)
	
		lstrcat(@strTemp, @strFileLength)
	End If
	
	lstrcat(@strTemp, @SohString)
	
	Return SendData(pIrcClient, @strTemp)
	
End Function

Function IrcClientSendPing( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strServer As LPCWSTR _
	)As Boolean
	
	Dim strPing As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strPing, @PingString)
	lstrcat(@strPing, @SpaceWithCommaString)
	lstrcpyn(@strPing + PingStringLength + SpaceWithCommaStringLength, strServer, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - lstrlen(strServer) - PingStringLength - SpaceWithCommaStringLength)
	
	Return SendData(pIrcClient, @strPing)
	
End Function

Function IrcClientSendPong( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strServer As LPCWSTR _
	)As Boolean
	
	Dim strPong As WString * (IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM + 1) = Any
	lstrcpy(@strPong, @PongStringWithSpace)
	lstrcpyn(@strPong + PongStringWithSpaceLength, strServer, IRCPROTOCOL_BYTESPERMESSAGEMAXIMUM - 2 - lstrlen(strServer) - PongStringWithSpaceLength)
	
	Return SendData(pIrcClient, @strPong)
	
End Function

Function IrcClientSendRawMessage( _
		ByVal pIrcClient As IrcClient Ptr, _
		ByVal strRawText As LPCWSTR _
	)As Boolean
	
	Return SendData(pIrcClient, strRawText)
	
End Function
