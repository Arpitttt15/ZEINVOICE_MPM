@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consuption View for BILLINGEWB'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_BILLING_EWB
  provider contract transactional_query
  as projection on ZI_BILLING_EWB

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
      EinvJson,
      EbillNo,
      Status,
      VdFmDate,
      VdToDate,
      VdFmTime,
      VdToTime,
      MSG,
      LogStatus,
      IrnStatus1,
      Criticality,
      
      /* Associations */
      _transdtls : redirected to composition child ZC_EWB_TRANS_DTLS
}
 where Irn is not initial 
