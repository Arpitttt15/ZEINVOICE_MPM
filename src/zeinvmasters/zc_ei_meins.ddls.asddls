@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_MEINS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_MEINS
{
  key Id,
  @Semantics.unitOfMeasure: true
  SapUom,
  @Semantics.unitOfMeasure: true
  GstUom,
  Msehl,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
