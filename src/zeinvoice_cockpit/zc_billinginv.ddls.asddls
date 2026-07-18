@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consuption View for BILLINGINV'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_BILLINGINV
  provider contract transactional_query
  as projection on ZI_BILLINGINV
{

      @Search.defaultSearchElement: true
  key BillingDocument,
      SoldToParty,
      BillingDocumentDate,
      BillingDocumentType,
      CompanyCode,
      DistributionChannel,
      Irn,
      IrnStatus,
      MSG,
      /* Associations */
      _ewaybill : redirected to composition child ZC_EWAYBILL
}
