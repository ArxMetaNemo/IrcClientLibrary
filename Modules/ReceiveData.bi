#ifndef BATCHEDFILES_IRCCLIENT_RECEIVEDATA_BI
#define BATCHEDFILES_IRCCLIENT_RECEIVEDATA_BI

#include "IrcClient.bi"

Declare Function StartRecvOverlapped( _
	ByVal pIrcClient As IrcClient Ptr _
)As Boolean

#endif
