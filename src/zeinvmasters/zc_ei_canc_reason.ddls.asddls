@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_CANC_REASON
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_CANC_REASON
{
  key Id,
  CancReas,
  CancDesc,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
