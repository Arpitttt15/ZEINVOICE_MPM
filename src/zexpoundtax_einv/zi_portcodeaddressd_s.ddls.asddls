@EndUserText.label: 'Port Code Address Details'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.semanticKey: [ 'SingletonID' ]
@UI: {
  headerInfo: {
    typeName: 'PortCodeAddress'
  }
}
define root view entity ZI_PortCodeAddressD_S
  as select from I_Language
    left outer join ZTSD_PORT_DTLS on 0 = 0
  association [0..*] to I_ABAPTransportRequestText as _ABAPTransportRequestText on $projection.TransportRequestID = _ABAPTransportRequestText.TransportRequestID
  composition [0..*] of ZI_PortCodeAddressD as _PortCodeAddressDeta
{
  @UI.facet: [ {
    id: 'ZI_PortCodeAddressD', 
    purpose: #STANDARD, 
    type: #LINEITEM_REFERENCE, 
    label: 'Port Code Address Details', 
    position: 1 , 
    targetElement: '_PortCodeAddressDeta'
  } ]
  @UI.lineItem: [ {
    position: 1 
  } ]
  key 1 as SingletonID,
  _PortCodeAddressDeta,
  @UI.hidden: true
  max( ZTSD_PORT_DTLS.LAST_CHANGED_AT ) as LastChangedAtMax,
  @ObjectModel.text.association: '_ABAPTransportRequestText'
  @UI.identification: [ {
    position: 2 , 
    type: #WITH_INTENT_BASED_NAVIGATION, 
    semanticObjectAction: 'manage'
  } ]
  @Consumption.semanticObject: 'CustomizingTransport'
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  _ABAPTransportRequestText
  
}
where I_Language.Language = $session.system_language
