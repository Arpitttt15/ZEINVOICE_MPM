@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_DISCOUNT
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_DISCOUNT
{
  key Id,
  Kschl,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
