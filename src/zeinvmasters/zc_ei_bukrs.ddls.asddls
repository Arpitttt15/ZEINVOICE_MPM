@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_BUKRS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_BUKRS
{
  key Id,
  Bukrs,
  Fkart,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
