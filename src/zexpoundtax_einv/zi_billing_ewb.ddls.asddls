@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Invoice View for E-Way Bill'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZI_BILLING_EWB
  as select from    I_BillingDocument as _header
    left outer join ZI_INVREFNUM   on _header.BillingDocument = ZI_INVREFNUM.Docno
    left outer join ztsd_ew_log    on _header.BillingDocument = ztsd_ew_log.docno
    left outer join ztsd_einv_json on _header.BillingDocument = ztsd_einv_json.docno
    left outer join zew_ewaybill   on _header.BillingDocument = zew_ewaybill.docno
  composition [0..*] of ZI_EWB_TRANS_DET as _transdtls
{

  key  _header.BillingDocument     as BillingDocument,
       _header.SoldToParty         as SoldToParty,
       _header.BillingDocumentDate as BillingDocumentDate,
       _header.BillingDocumentType as BillingDocumentType,
       _header.CompanyCode         as CompanyCode,
       _header.DistributionChannel as DistributionChannel,
       ZI_INVREFNUM.Irn            as Irn,
       ZI_INVREFNUM.IrnStatus      as IrnStatus,
       ztsd_ew_log.message         as MSG,
       ztsd_ew_log.status          as LogStatus,
       ztsd_einv_json.einv_json    as EinvJson,
       zew_ewaybill.ebillno        as EbillNo,
       zew_ewaybill.status         as Status,
       zew_ewaybill.vdfmdate       as VdFmDate,
       zew_ewaybill.vdtodate       as VdToDate,
       zew_ewaybill.vdfmtime       as VdFmTime,
       zew_ewaybill.vdtotime       as VdToTime,
       
       case zew_ewaybill.status
       when 'A'    then 'Active'
       when 'C'    then 'Cancelled'
       else 'Pending'
       end                         as IrnStatus1,

       case zew_ewaybill.status
       when 'A'    then 3
       when 'C'    then 1
       else 2
       end                         as Criticality,
       
       _transdtls

}
where
  ZI_INVREFNUM.IrnStatus = 'ACT'
