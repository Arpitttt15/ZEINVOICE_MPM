@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Einvoice credit note interface'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_BILLING_INV_FI
  as select from    ZC_JE_CustomerLineItem as _header
    left outer join ZI_INVREFNUM   on _header.AccountingDocument = ZI_INVREFNUM.Docno
                                   and _header.FiscalYear =  ZI_INVREFNUM.DocYear         
    left outer join I_Customer     on _header.Customer = I_Customer.Customer
    left outer join ztsd_ei_log    on _header.AccountingDocument = ztsd_ei_log.docno
                                   and _header.FiscalYear = ztsd_ei_log.doc_year 
    left outer join ztsd_einv_json on _header.AccountingDocument = ztsd_einv_json.docno
                                  and _header.FiscalYear =  ztsd_einv_json.doc_year         
{

  key  _header.AccountingDocument     as BillingDocument,
  key  _header.FiscalYear,
  key  _header.CompanyCode            as CompanyCode,
       _header.DocumentDate           as BillingDocumentDate ,
       _header.Customer               as SoldToParty,
       I_Customer.CustomerName        as CustomerName,     
       _header.AccountingDocumentType as BillingDocumentType,
       //       _header.DistributionChannel as DistributionChannel,
       ZI_INVREFNUM.Irn               as Irn,
       ZI_INVREFNUM.IrnStatus         as IrnStatus,
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
       ztsd_ei_log.status             as LogStatus,
       ztsd_ei_log.message            as MSG,
       ztsd_einv_json.einv_json       as EinvJson,

       case ZI_INVREFNUM.IrnStatus
       when 'ACT'    then 'Active'
       when 'CAN'    then 'Cancelled'
       else 'Pending'
       end                            as IrnStatus1,

       case ZI_INVREFNUM.IrnStatus
       when 'ACT'    then 3
       when 'CAN'    then 1
       else 2
       end                            as Criticality
}

where
     _header.AccountingDocumentType = 'DR'
  or _header.AccountingDocumentType = 'DG'
