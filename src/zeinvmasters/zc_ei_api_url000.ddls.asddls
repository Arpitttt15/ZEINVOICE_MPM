@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_EI_API_URL000
  provider contract transactional_query
  as projection on ZR_EI_API_URL000
{
  key Id,
      Method,
      Url,
      Param1,
      Param2,
      Param3,
      Param4,
      Param5,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt

}
