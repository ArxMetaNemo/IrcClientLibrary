#include "GetIrcData.bi"
#include "CharacterConstants.bi"
#include "StringConstants.bi"
#ifndef unicode
#define unicode
#endif
#include "win\shlwapi.bi"

Function GetIrcCommand( _
		ByVal w As WString Ptr, _
		ByVal Length As Integer _
	)As IrcCommand
	
	If lstrcmp(w, @PingString) = 0 Then
		Return IrcCommand.Ping
	End If
	
	If lstrcmp(w, @PrivateMessage) = 0 Then
		Return IrcCommand.PrivateMessage
	End If
	
	If lstrcmp(w, @JoinString) = 0 Then
		Return IrcCommand.Join
	End If
	
	If lstrcmp(w, @QuitString) = 0 Then
		Return IrcCommand.Quit
	End If
	
	If lstrcmp(w, @PartString) = 0 Then
		Return IrcCommand.Part
	End If
	
	If lstrcmp(w, @NoticeString) = 0 Then
		Return IrcCommand.Notice
	End If
	
	If lstrcmp(w, @NickString) = 0 Then
		Return IrcCommand.Nick
	End If
	
	If lstrcmp(w, @ErrorString) = 0 Then
		Return IrcCommand.Error
	End If
	
	If lstrcmp(w, @KickString) = 0 Then
		Return IrcCommand.Kick
	End If
	
	If lstrcmp(w, @ModeString) = 0 Then
		Return IrcCommand.Mode
	End If
	
	If lstrcmp(w, @TopicString) = 0 Then
		Return IrcCommand.Topic
	End If
	
	If lstrcmp(w, @InviteString) = 0 Then
		Return IrcCommand.Invite
	End If
	
	If lstrcmp(w, @PongString) = 0 Then
		Return IrcCommand.Pong
	End If
	
	If lstrcmp(w, @SQuitString) = 0 Then
		Return IrcCommand.SQuit
	End If
	
	If Length = 3 Then
		Dim NumericFlag As Boolean = True
		For i As Integer = 0 To 2
			If w[i] < Characters.DigitZero OrElse w[i] > Characters.DigitNine Then
				NumericFlag = False
				Exit For
			End If
		Next
		If NumericFlag Then
			Return IrcCommand.Numeric
		End If
	End If
	
	Return IrcCommand.Server
	
End Function

Function GetIrcServerName( _
		ByVal strData As WString Ptr _
	)As WString Ptr
	
	Dim w As WString Ptr = StrChr(strData, Characters.Colon)
	If w = NULL Then
		Return NULL
	End If
	
	Return w + 1
	
End Function

Function GetNextWord( _
		ByVal wStart As WString Ptr _
	)As WString Ptr
	
	Dim ws As WString Ptr = StrChr(wStart, Characters.WhiteSpace)
	If ws = NULL Then
		Return NULL
	End If
	
	ws[0] = Characters.NullChar
	
	Return ws + 1
	
End Function

Function GetIrcMessageText( _
		ByVal strData As WString Ptr _
	)As WString Ptr
	
	':Qubick!~miranda@192.168.1.1 PRIVMSG ##freebasic :Hello World
	Dim w As WString Ptr = StrChr(strData, Characters.Colon)
	If w = NULL Then
		Return NULL
	End If
	
	Return w + 1
	
End Function

Function GetCtcpCommand( _
		ByVal w As WString Ptr _
	)As CtcpMessageKind
	
	If lstrcmp(w, @PingString) = 0 Then
		Return CtcpMessageKind.Ping
	End If
	
	If lstrcmp(w, @UserInfoString) = 0 Then
		Return CtcpMessageKind.UserInfo
	End If
	
	If lstrcmp(w, @TimeString) = 0 Then
		Return CtcpMessageKind.Time
	End If
	
	If lstrcmp(w, @VersionString) = 0 Then
		Return CtcpMessageKind.Version
	End If
	
	If lstrcmp(w, @ActionString) = 0 Then
		Return CtcpMessageKind.Action
	End If
	
	Return CtcpMessageKind.None
	
End Function
