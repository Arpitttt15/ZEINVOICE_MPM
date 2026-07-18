@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Invoice for EINV'
define root view entity ZI_BILLING_INV
  as select from    I_BillingDocument as _header
    left outer join ZI_INVREFNUM   on _header.BillingDocument = ZI_INVREFNUM.Docno
    left outer join I_Customer     on _header.SoldToParty = I_Customer.Customer
    left outer join ztsd_ei_log    on _header.BillingDocument = ztsd_ei_log.docno
    left outer join ztsd_einv_json on _header.BillingDocument = ztsd_einv_json.docno
{

  key  _header.BillingDocument     as BillingDocument,
       _header.SoldToParty         as SoldToParty,
       I_Customer.CustomerName     as CustomerName,
       _header.BillingDocumentDate as BillingDocumentDate,
       _header.BillingDocumentType as BillingDocumentType,
       _header.CompanyCode         as CompanyCode,
       _header.DistributionChannel as DistributionChannel,
       ZI_INVREFNUM.Irn            as Irn,
       ZI_INVREFNUM.IrnStatus      as IrnStatus,
       ZI_INVREFNUM.Odn,
       ZI_INVREFNUM.OdnDate,
       ZI_INVREFNUM.AckNo,
       ZI_INVREFNUM.AckDate,
       ZI_INVREFNUM.CancelDate,
       ZI_INVREFNUM.Ernam,
       ZI_INVREFNUM.Erdat,
       ZI_INVREFNUM.Erzet,
       ZI_INVREFNUM.SignedInv,
       ZI_INVREFNUM.SignedQrcode,
       ztsd_ei_log.status          as LogStatus,
       ztsd_ei_log.message         as MSG,
       ztsd_einv_json.einv_json    as EinvJson,

       case ZI_INVREFNUM.IrnStatus
       when 'ACT'    then 'Active'
       when 'CAN'    then 'Cancelled'
       else 'Pending'
       end                         as IrnStatus1,

       case ZI_INVREFNUM.IrnStatus
       when 'ACT'    then 3
       when 'CAN'    then 1
       else 2
       end                         as Criticality
}
where _header.DistributionChannel <> '40'
