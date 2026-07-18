@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Einvoice credit note'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'E-Invoice Generation : ExpoundTax' ,
                  typeNamePlural: 'E-Invoice Generation : ExpoundTax' }
define root view entity ZC_BILLING_INV_FI
  provider contract transactional_query
  as projection on ZI_BILLING_INV_FI
{
        @UI.facet: [
         {
           id: 'BillingDocumentFacet',
           purpose: #STANDARD,
           type: #IDENTIFICATION_REFERENCE,
           label: 'E-Invoice Generation : ExpoundTax',
           position: 10
         },
         {
           id: 'BillingDocHeader',
           purpose: #HEADER,
           type: #DATAPOINT_REFERENCE,
           targetQualifier: 'BillingDocument',
           label: 'Billing Document',
           position: 20
         },
         {
           id: 'StatusHeader',
           purpose: #HEADER,
           type: #DATAPOINT_REFERENCE,
           targetQualifier: 'IrnStatus',
           label: 'Status',
           position: 30
         },
         {
           id: 'CompanyCodeHeader',
           purpose: #HEADER,
           type: #DATAPOINT_REFERENCE,
           targetQualifier: 'CompanyCode',
           label: 'Company Code',
           position: 40
         },
         {
           id: 'SoldToPartyHeader',
           purpose: #HEADER,
           type: #DATAPOINT_REFERENCE,
           targetQualifier: 'SoldToParty',
           label: 'Sold To Party',
           position: 50
         },
         {
           id: 'BillingDateHeader',
           purpose: #HEADER,
           type: #DATAPOINT_REFERENCE,
           targetQualifier: 'BillingDocumentDate',
           label: 'Billing Document Date',
           position: 50
         },
         {
           id: 'BillingTypeHeader',
           purpose: #HEADER,
           type: #DATAPOINT_REFERENCE,
           targetQualifier: 'BillingDocumentType',
           label: 'Billing Document Type',
           position: 70
         }
        ]

        @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument', element: 'BillingDocument' } }]
        @UI: { lineItem: [ { position: 10 },
        { type: #FOR_ACTION, dataAction: 'CreateIRN', label: 'Create IRN', invocationGrouping: #CHANGE_SET } ] }
        @UI.dataPoint: { qualifier: 'BillingDocument', title: 'Billing Document' }
  key   BillingDocument,

        @UI.hidden: true
        @EndUserText.label: 'year'
        @UI: { lineItem: [ { position: 15, importance: #HIGH }] }
        @UI.dataPoint: { qualifier: 'FiscalYear', title: 'year'}
  key   FiscalYear,

        @EndUserText.label: 'Company Code'
        @UI.selectionField: [{ position: 50 }]
        @UI: { lineItem: [{position: 50 }] }
        @Search.defaultSearchElement: true
        @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',element: 'CompanyCode' } }]
        @UI.dataPoint: { qualifier: 'CompanyCode', title: 'Company Code' }
  key   CompanyCode,

        @EndUserText.label: 'Billing Date'
        @UI: { lineItem: [ { position: 20 },
        { type: #FOR_ACTION, dataAction: 'CIRN', label: 'Cancel IRN', invocationGrouping: #CHANGE_SET } ] }
        @Search.defaultSearchElement: true
        @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',element: 'BillingDocumentDate' } }]
        @UI.dataPoint: { qualifier: 'BillingDocumentDate', title: 'Billing Document Date' }
        BillingDocumentDate,

        Criticality,


        @UI.dataPoint: { qualifier: 'IrnStatus', title: 'Status' }
        @EndUserText.label: 'IRN Status'
        @UI: { lineItem:[{ position: 9, criticality: 'Criticality', importance: #HIGH }],
        selectionField: [{ position: 9 }] }
        @Search.defaultSearchElement: true
        IrnStatus1,

        @UI.hidden: true
        @EndUserText.label: 'Sold To Party'
        @UI: { lineItem: [ { position: 30 },
        { type: #FOR_ACTION, dataAction: 'JSON', label: 'JSON', invocationGrouping: #CHANGE_SET } ] }
        @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument', element: 'SoldToParty' } }]
        @UI.dataPoint: { qualifier: 'SoldToParty', title: 'Sold To Party' }
        SoldToParty,

        @EndUserText.label: 'Sold To Party Name'
        @UI: { lineItem: [ { position: 31, importance: #HIGH }] }
        @UI.dataPoint: { qualifier: 'SoldToParty', title: 'Sold To Party'}
        CustomerName,


        @EndUserText.label: 'Billing Type'
        @UI.selectionField: [{ position: 40 }]
        @UI: { lineItem: [{position: 40 }] }
        @Search.defaultSearchElement: true
        @UI.dataPoint: { qualifier: 'BillingDocumentType', title: 'Billing Document Type' }
        @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',element: 'BillingDocumentType' } }]
        BillingDocumentType,

        @EndUserText.label: 'ODN'
        @UI: {

               selectionField: [{ position: 70 }] }
        Odn,

        @EndUserText.label: 'ODN Date'
        @UI: {
               selectionField: [{ position: 80 }] }
        OdnDate,

        @EndUserText.label: 'IRN'
        @UI: { lineItem:[{ position: 90 }],
        selectionField: [{ position: 90 }] }
        @Search.defaultSearchElement: true
        Irn,

        @EndUserText.label: 'IRN Status'
        @UI: { lineItem:[{ position: 100 }],
        selectionField: [{ position: 100 }] }
        @Search.defaultSearchElement: true
        IrnStatus,

        @EndUserText.label: 'Acknowlegment No'
        @UI: {
               selectionField: [{ position: 110 }] }
        AckNo,

        @EndUserText.label: 'Acknowlegment Date'
        @UI: {
               selectionField: [{ position: 120 }] }
        AckDate,

        @EndUserText.label: 'Cancel Date'
        @UI: {
               selectionField: [{ position: 130 }] }
        CancelDate,

        @EndUserText.label: 'Created By'
        @UI: {
               selectionField: [{ position: 140 }] }
        Ernam,

        @EndUserText.label: 'Creation Date'
        @UI: {
               selectionField: [{ position: 150 }] }
        Erdat,

        @EndUserText.label: 'Creation Time'
        @UI: {
               selectionField: [{ position: 160 }] }
        Erzet,

        @EndUserText.label: 'Log Status'
        @UI: { lineItem: [{position: 170 }],
        //      identification:  [{position: 170 }],
        selectionField:  [{position: 170 }]}
        @Search.defaultSearchElement: true
        LogStatus,

        @EndUserText.label: 'Response'
        @UI: {
        identification: [{ position: 190 }] }
        @UI.multiLineText: true
        MSG,

        @EndUserText.label: 'JSON'
        @UI.multiLineText: true
        @UI: { identification: [{ position: 180 }] }
        EinvJson

}
