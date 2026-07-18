@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_BASERATE
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_BASERATE
{
  key Id,
  Kschl,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
