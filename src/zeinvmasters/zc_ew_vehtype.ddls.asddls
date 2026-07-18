@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EW_VEHTYPE
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EW_VEHTYPE
{
  key Id,
  Vehtype,
  Transmode,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
