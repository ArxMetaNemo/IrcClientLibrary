#ifndef unicode
#define unicode
#endif

#include once "windows.bi"
#include once "win\olectl.bi"
#include once "win\psapi.bi"
#include once "win\shlwapi.bi"
#include once "IIrcClient.bi"
#include once "ClassFactory.bi"
#include once "IrcClient.bi"

#ifdef withoutrtl
Declare Function DllMain Alias "DllMain"(ByVal hinstDLL As HINSTANCE, ByVal fdwReason As DWORD, ByVal lpvReserved As LPVOID)As Integer
#endif

' Declare Function DllGetClassObject Alias "DllGetClassObject"(ByVal rclsid As REFCLSID, ByVal riid As REFIID, ByVal ppv As Any Ptr Ptr)As HRESULT

' Declare Function DllCanUnloadNow Alias "DllCanUnloadNow"()As HRESULT

' Declare Function DllRegisterServer Alias "DllRegisterServer"()As HRESULT

' Declare Function DllUnregisterServer Alias "DllUnregisterServer"() As HRESULT

Declare Function SetSettingsValue(ByVal RegSection As WString Ptr, ByVal Key As WString Ptr, ByVal Value As WString Ptr)As Boolean
