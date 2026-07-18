@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_STATE
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_STATE
{
  key Id,
  Regio,
  Statecode,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
