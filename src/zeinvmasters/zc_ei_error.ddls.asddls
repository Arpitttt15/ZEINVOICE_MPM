@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_EI_ERROR
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EI_ERROR
{
  key Id,
  Bukrs,
  Docno,
  DocYear,
  Message,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
