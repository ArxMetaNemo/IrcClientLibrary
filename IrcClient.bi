#include once "IIrcClient.bi"

Type IrcClient
	Dim VirtualTable As IIrcClientVirtualTable Ptr
	
	Dim ReferenceCounter As DWORD
	
End Type

Declare Sub MakeIIrcClientVirtualTable()

Declare Function ConstructorIrcClient()As IrcClient Ptr

Declare Sub DestructorIrcClient(ByVal pIrcClient As IrcClient Ptr)

Declare Function IrcClientQueryInterface(ByVal This As IrcClient Ptr, ByVal riid As REFIID, ByVal ppv As Any Ptr Ptr)As HRESULT

Declare Function IrcClientAddRef(ByVal This As IrcClient Ptr)As ULONG

Declare Function IrcClientRelease(ByVal This As IrcClient Ptr)As ULONG

Declare Function IrcClientGetTypeInfoCount(ByVal This As IDispatch Ptr, ByVal pctinfo As UINT Ptr)As HRESULT

Declare Function IrcClientGetTypeInfo(ByVal This As IDispatch Ptr, ByVal iTInfo As UINT, ByVal lcid As LCID, ByVal ppTInfo As ITypeInfo Ptr Ptr)As HRESULT

Declare Function IrcClientGetIDsOfNames(ByVal This As IDispatch Ptr, ByVal riid As Const IID Const ptr, ByVal rgszNames As LPOLESTR Ptr, ByVal cNames As UINT, ByVal lcid As LCID, ByVal rgDispId As DISPID Ptr)As HRESULT

Declare Function IrcClientInvoke(ByVal This As IDispatch Ptr, ByVal dispIdMember As DISPID, ByVal riid As Const IID Const Ptr, ByVal lcid As LCID, ByVal wFlags As WORD, ByVal pDispParams As DISPPARAMS Ptr, ByVal pVarResult As VARIANT Ptr, ByVal pExcepInfo As EXCEPINFO Ptr, ByVal puArgErr As UINT Ptr)As HRESULT

Declare Function IrcClientShowMessageBox(ByVal This As IrcClient Ptr, ByVal pResult As Long Ptr)As HRESULT
