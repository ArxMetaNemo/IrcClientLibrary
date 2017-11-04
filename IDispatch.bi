#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\objbase.bi"

Const CLSIDS_DISPATCH = "{00020400-0000-0000-C000-000000000046}"

Dim Shared IID_IDISPATCH As IID = Type(&h00020400, &h0000, &h0000, {&hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46})

Dim Shared CLSID_DISPATCH As IID = Type(&h00020400, &h0000, &h0000, {&hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46})

Type IDispatch As IDispatch_

Type LPIDISPATCH As IDispatch Ptr

Type IDispatchVirtualTable
	Dim VirtualTable As IUnknownVtbl
	Dim GetTypeInfoCount As Function(ByVal This As IDispatch Ptr, ByVal pctinfo As UINT Ptr)As HRESULT
	Dim GetTypeInfo As Function(ByVal This As IDispatch Ptr, ByVal iTInfo As UINT, ByVal lcid As LCID, ByVal ppTInfo As ITypeInfo Ptr Ptr)As HRESULT
	Dim GetIDsOfNames As Function(ByVal This As IDispatch Ptr, ByVal riid As Const IID Const Ptr, ByVal rgszNames As LPOLESTR Ptr, ByVal cNames As UINT, ByVal lcid As LCID, ByVal rgDispId As DISPID Ptr)As HRESULT
	Dim Invoke As Function(ByVal This As IDispatch Ptr, ByVal dispIdMember As DISPID, ByVal riid As Const IID Const Ptr, ByVal lcid As LCID, ByVal wFlags As WORD, ByVal pDispParams As DISPPARAMS Ptr, ByVal pVarResult As VARIANT Ptr, ByVal pExcepInfo As EXCEPINFO Ptr, ByVal puArgErr As UINT Ptr)As HRESULT
End Type

Type IDispatch_
	Dim VirtualTable As IIrcClientVirtualTable Ptr
End Type
