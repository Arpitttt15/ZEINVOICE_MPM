@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Invoice for EINV'
define root view entity ZI_BILLINGINV
  as select from    I_BillingDocument as _header
    left outer join zei_invrefnum on _header.BillingDocument = zei_invrefnum.docno
    left outer join ztsd_ei_log   on _header.BillingDocument = ztsd_ei_log.docno

  composition [0..*] of ZI_ewaybill as _ewaybill

{

  key  _header.BillingDocument     as BillingDocument,
       _header.SoldToParty         as SoldToParty,
       _header.BillingDocumentDate as BillingDocumentDate,
       _header.BillingDocumentType as BillingDocumentType,
       _header.CompanyCode         as CompanyCode,
       _header.DistributionChannel as DistributionChannel,
       zei_invrefnum.irn           as Irn,
       zei_invrefnum.irn_status    as IrnStatus,
       ztsd_ei_log.message         as MSG,

       _ewaybill
}
