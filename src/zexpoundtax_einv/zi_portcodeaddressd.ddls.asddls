@EndUserText.label: 'Port Code Address Details'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PortCodeAddressD
  as select from ZTSD_PORT_DTLS
  association to parent ZI_PortCodeAddressD_S as _PortCodeAddress on $projection.SingletonID = _PortCodeAddress.SingletonID
{
  key SAP_PORT_CODE as SapPortCode,
  key PORT_CODE as PortCode,
  PORT_DESC as PortDesc,
  PORT_GSTIN as PortGstin,
  NAME1 as Name1,
  STRAS as Stras,
  ADDRESS1 as Address1,
  ADRESS2 as Adress2,
  ORT01 as Ort01,
  PSTLZ as Pstlz,
  REGIO as Regio,
  @Semantics.user.localInstanceLastChangedBy: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_BY as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  @Consumption.hidden: true
  LOCAL_LAST_CHANGED_AT as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  LAST_CHANGED_AT as LastChangedAt,
  @Consumption.hidden: true
  1 as SingletonID,
  _PortCodeAddress
  
}
