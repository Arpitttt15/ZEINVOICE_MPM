@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_GSTRATE
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_GSTRATE
{
  key Id,
  Kschl,
  GstTyp,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
