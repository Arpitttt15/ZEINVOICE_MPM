@EndUserText.label: 'Copy Port Code Address Details'
define abstract entity ZD_CopyPortCodeAddressD
{
  @EndUserText.label: 'New SAP Port Code'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: SapPortCode' )
  SapPortCode : ZDE_PORT_OF_LOAD;
  @EndUserText.label: 'New Port Code'
  @UI.defaultValue: #( 'ELEMENT_OF_REFERENCED_ENTITY: PortCode' )
  PortCode : ZDE_PORT_CD;
  
}
