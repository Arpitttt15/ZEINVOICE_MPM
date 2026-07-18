@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_OTHRCHRG
  provider contract transactional_query
  as projection on ZR_EI_OTHRCHRG
{
  key Id,
 // @Consumption.valueHelpDefinition: [{entity : { name: 'ZC_EI_BASERATE', element : 'kschl'}}]
  Kschl,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
