#include once "IrcClient.bi"
#include once "ClassFactory.bi"

Common Shared GlobalClassFactoryCount As Long
Common Shared GlobalClassFactoryVirtualTable As IClassFactoryVtbl

Sub MakeIClassFactoryVtbl()
	GlobalClassFactoryVirtualTable.QueryInterface = @ClassFactoryQueryInterface
	GlobalClassFactoryVirtualTable.AddRef = @ClassFactoryAddRef
	GlobalClassFactoryVirtualTable.Release = @ClassFactoryRelease
	GlobalClassFactoryVirtualTable.CreateInstance = @ClassFactoryCreateInstance
	GlobalClassFactoryVirtualTable.LockServer = @ClassFactoryLockServer
End Sub

Function ConstructorClassFactory()As ClassFactory Ptr
	Dim pClassFactory As ClassFactory Ptr = CPtr(ClassFactory Ptr, Allocate(SizeOf(ClassFactory)))
	If pClassFactory = 0 Then
		Return 0
	End If
	
	pClassFactory->VirtualTable = @GlobalClassFactoryVirtualTable
	
	pClassFactory->ReferenceCounter = 0
	
	Return pClassFactory
End Function

Sub DestructorClassFactory(ByVal pClassFactory As ClassFactory Ptr)
	DeAllocate(pClassFactory)
End Sub

Function ClassFactoryQueryInterface(ByVal This As ClassFactory Ptr, ByVal riid As REFIID, ByVal ppv As Any Ptr Ptr)As HRESULT
	*ppv = 0
	
	If IsEqualIID(@IID_IUnknown, riid) Then
		*ppv = CPtr(IUnknown Ptr, This)
	End If
	
	If IsEqualIID(@IID_IClassFactory, riid) Then
		*ppv = CPtr(IClassFactory Ptr, This)
	End If
	
	If *ppv <> 0 Then
		This->VirtualTable->AddRef(CPtr(IClassFactory Ptr, This))
		Return S_OK
	End If
	
	Return E_NOINTERFACE
	
End Function

Function ClassFactoryAddRef(ByVal This As ClassFactory Ptr)As ULONG
	Return InterlockedIncrement(@This->ReferenceCounter)
End Function

Function ClassFactoryRelease(ByVal This As ClassFactory Ptr)As ULONG
	
	If InterlockedDecrement(@This->ReferenceCounter) = 0 Then
		DestructorClassFactory(This)
		Return 0
	End If
	
	Return This->ReferenceCounter
End Function

Function ClassFactoryCreateInstance(ByVal This As ClassFactory Ptr, ByVal pUnknownOuter As IUnknown Ptr, ByVal riid As REFIID, ByVal ppv As Any Ptr Ptr)As HRESULT
	*ppv = 0
	
	' Агрегирование не поддерживается
	If pUnknownOuter <> NULL Then
		Return CLASS_E_NOAGGREGATION
	End If
	
	Dim pIrcClient As IrcClient Ptr = ConstructorIrcClient()
	If pIrcClient = 0 Then
		Return E_OUTOFMEMORY
	End If
	
	Dim hr As HRESULT = pIrcClient->VirtualTable->VirtualTable.QueryInterface(CPtr(IDispatch Ptr, pIrcClient), riid, ppv)
	
	If FAILED(hr) Then
		DestructorIrcClient(pIrcClient)
	End If
	
	Return hr
	
End Function
	
Function ClassFactoryLockServer(ByVal This As ClassFactory Ptr, ByVal fLock As BOOL)As HRESULT
	If fLock Then
		InterlockedIncrement(@GlobalClassFactoryCount) 
	Else
		InterlockedDecrement(@GlobalClassFactoryCount)
	End If
	
	Return S_OK
End Function
