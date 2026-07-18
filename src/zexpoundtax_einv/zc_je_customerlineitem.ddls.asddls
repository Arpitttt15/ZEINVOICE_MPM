@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FI Document data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_JE_CustomerLineItem 
 as select from I_JournalEntry       as je
    inner join I_JournalEntryItem    as jeitem
      on  je.CompanyCode        = jeitem.CompanyCode
      and je.FiscalYear         = jeitem.FiscalYear
      and je.AccountingDocument = jeitem.AccountingDocument

{
    key je.CompanyCode,
    key je.FiscalYear,
    key je.AccountingDocument,

    je.AccountingDocumentType,
    je.PostingDate,
    je.DocumentDate,
    jeitem.TransactionCurrency as TransactionCurrency,

    /* Aggregated amount */
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum( jeitem.AmountInCompanyCodeCurrency ) as TotalAmount,

    /* Optionally you can expose one customer, 
       or use string_agg if multiple */
    min( jeitem.Customer ) as Customer
}
where jeitem.Customer <> ''
group by 
    je.CompanyCode,
    je.FiscalYear,
    je.AccountingDocument,
    je.AccountingDocumentType,
    je.PostingDate,
    je.DocumentDate,
    jeitem.TransactionCurrency
//as select from I_JournalEntry       as je
//    inner join I_JournalEntryItem    as jeitem
//      on  je.CompanyCode        = jeitem.CompanyCode
//      and je.FiscalYear         = jeitem.FiscalYear
//      and je.AccountingDocument = jeitem.AccountingDocument
//
//{
//    key je.CompanyCode,
//    key je.FiscalYear,
//    key je.AccountingDocument,
//    key jeitem.AccountingDocumentItem,
//
//    je.AccountingDocumentType,
//    je.PostingDate,
//    je.DocumentDate,
//
//    jeitem.Customer,
//    jeitem.Supplier,
//    jeitem.GLAccount,
////    jeitem.AmountInCompanyCodeCurrency,
//    jeitem.CompanyCodeCurrency,
//    jeitem.DebitCreditCode
////    jeitem.JournalEntryItemText
//}
//where jeitem.Customer <> ''
