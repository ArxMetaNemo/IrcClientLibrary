#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "IUnknown.bi"

Dim Shared IID_IClassFactory As IID = Type(&h00000001, &h0000, &h0000, {&hC0, &h00, &h00, &h00, &h00, &h00, &h00, &h46})

Type IClassFactory As IClassFactory_

Type IClassFactoryVirtualTable
	Dim VirtualTable As IUnknownVirtualTable
	Dim CreateInstance As Function(ByVal This As IClassFactory Ptr,	ByVal riid As REFIID, ByVal ppv As Any Ptr Ptr)As HRESULT
	Dim LockServer As Function(ByVal This As IClassFactory Ptr, ByVal fLock As BOOL)As HRESULT
End Type

Type IClassFactory_
	Dim VirtualTable As IClassFactoryVirtualTable Ptr
End Type
