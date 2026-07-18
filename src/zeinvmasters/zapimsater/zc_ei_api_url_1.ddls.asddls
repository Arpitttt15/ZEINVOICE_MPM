@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_API_URL_1
  provider contract transactional_query
  as projection on ZR_EI_API_URL_1
{
  key Id,
  key Bukrs,
  key Type,
  Method,
  Url,
  Param1,
  Param2,
  Param3,
  Param4,
  Param5,
  Param6,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
