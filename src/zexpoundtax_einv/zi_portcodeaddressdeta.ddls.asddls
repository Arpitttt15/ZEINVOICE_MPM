@EndUserText.label: 'Port Code Address Details'
@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
define view entity ZI_PortCodeAddressDeta
  as select from ZTSD_PORT_DTLS
  association to parent ZI_PortCodeAddressDeta_S as _PortCodeAddressDAll on $projection.SingletonID = _PortCodeAddressDAll.SingletonID
{
  key PORT_CODE as PortCode,
  PORT_DESC as PortDesc,
  NAME1 as Name1,
  STRAS as Stras,
  ADDRESS1 as Address1,
  ADRESS2 as Adress2,
  ORT01 as Ort01,
  PSTLZ as Pstlz,
  REGIO as Regio,
  @Consumption.hidden: true
  1 as SingletonID,
  _PortCodeAddressDAll
  
}
