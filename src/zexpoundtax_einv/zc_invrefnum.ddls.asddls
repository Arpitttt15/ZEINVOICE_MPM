@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View INVREFNUM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_INVREFNUM
provider contract transactional_query
  as projection on ZI_INVREFNUM
{
  key Bukrs,
  key Docno,
  key DocYear,
  key DocType,
  key Odn,
  key Irn,
  key Version,
      Bupla,
      OdnDate,
      AckNo,
      AckDate,
      IrnStatus,
      CancelDate,
      Ernam,
      Erdat,
      Erzet,
      SignedInv,
      SignedQrcode
}
