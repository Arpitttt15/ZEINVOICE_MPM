@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZEIAPI_URL000'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_EIAPI_URL000
  as select from zei_api_url
{
  key id as ID,
  key bukrs as Bukrs,
  key type as Type,
  method as Method,
  url as Url,
  param1 as Param1,
  param2 as Param2,
  param3 as Param3,
  param4 as Param4,
  param5 as Param5,
  param6 as Param6,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt
}
