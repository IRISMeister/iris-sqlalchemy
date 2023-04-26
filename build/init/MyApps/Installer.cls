Class MyApps.Installer
{

ClassMethod setup(ByRef tVars) As %Status
{
  New $NAMESPACE
  Set oldns=$NAMESPACE
  Set tSC='$$$OK
  Try {

#If 1
    Set $NAMESPACE="%SYS"

    #; install ZPM
    Do ##class(Security.SSLConfigs).Create("z")
    Set r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="z",r.Https=1
    Set tSC=r.Get("/packages/zpm/latest/installer")
    $$$ThrowOnError(tSC)
    Set tSC=$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
    $$$ThrowOnError(tSC)
#EndIf

    #; Load sample datasets.
    Set $NAMESPACE="USER"
    zpm "install samples-bi"
    #;zpm "install bdb-nytaxi"

  } Catch(e) {
	  Set tSC=e.AsStatus()
    zw tSC
  }
  Set $NAMESPACE=oldns
  Return tSC
}
}