#ifndef BATCHEDFILES_IRCCLIENT_IRCPREFIX_BI
#define BATCHEDFILES_IRCCLIENT_IRCPREFIX_BI

#include "LpWString.bi"

Type _IrcPrefix
	Dim Nick As LPWSTRING
	Dim User As LPWSTRING
	Dim Host As LPWSTRING
End Type

Type IrcPrefix As _IrcPrefix

Type LPIRCPREFIX As _IrcPrefix Ptr

#endif
