@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View ZI_BILLINGINV'
@Metadata.ignorePropagatedAnnotations: true
//@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI.headerInfo: { typeName: 'E-Invoice Generation : ExpoundTax' ,
                  typeNamePlural: 'E-Invoice Generation : ExpoundTax' }

define root view entity ZC_BILLING_INV
  provider contract transactional_query
  as projection on ZI_BILLING_INV
{

      @UI.facet: [{   id : 'BillingDocument',
                  purpose: #STANDARD,
                  type: #IDENTIFICATION_REFERENCE,
                  label: 'E-Invoice Generation : ExpoundTax',
                  position: 10
              },
              {
                   purpose: #HEADER,
                   type: #DATAPOINT_REFERENCE,
                   label: 'BillingDocument',
                   position: 20,
                   targetQualifier: 'BillingDocument'
               } ,

              {
                   purpose: #HEADER,
                   type: #DATAPOINT_REFERENCE,
                   label: 'Status',
                   position: 9,
                   targetQualifier: 'IrnStatus'
               } ,


      {
                   purpose: #HEADER,
                   type: #DATAPOINT_REFERENCE,
                   label: 'CompanyCode',
                   position: 10,
                   targetQualifier: 'CompanyCode'
               },
      {
                   purpose: #HEADER,
                   type: #DATAPOINT_REFERENCE,
                   label: 'DistributionChannel',
                   position: 40,
                   targetQualifier: 'DistributionChannel'
               },
      {
                   purpose: #HEADER,
                   type: #DATAPOINT_REFERENCE,
                   label: 'SoldToParty',
                   position: 50,
                   targetQualifier: 'SoldToParty'
               },
      {
                   purpose: #HEADER,
                   type: #DATAPOINT_REFERENCE,
                   label: 'BillingDocumentDate',
                   position: 30,
                   targetQualifier: 'BillingDocumentDate'
               },
                     {
                   purpose: #HEADER,
                   type: #DATAPOINT_REFERENCE,
                   label: 'BillingDocumentType',
                   position: 60,
                   targetQualifier: 'BillingDocumentType'
               }]

      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument', element: 'BillingDocument' } }]
      @UI: { lineItem: [ { position: 10 },
      { type: #FOR_ACTION, dataAction: 'CreateIRN', label: 'Create IRN', invocationGrouping: #CHANGE_SET } ] ,
     selectionField: [{ position: 180 }]}
      @UI.dataPoint: { qualifier: 'BillingDocument', title: 'Billing Document' }
  key BillingDocument,

      Criticality,


      @UI.dataPoint: { qualifier: 'IrnStatus', title: 'Status' }
      @EndUserText.label: 'IRN Status'
      @UI: { lineItem:[{ position: 9, criticality: 'Criticality', importance: #HIGH }],
      //      identification: [{ position: 100 }],
      selectionField: [{ position: 9 }] }
      @Search.defaultSearchElement: true
      IrnStatus1,

      @UI.hidden: true
      @EndUserText.label: 'Sold To Party'
      @UI: { lineItem: [ { position: 20 },
      { type: #FOR_ACTION, dataAction: 'JSON', label: 'JSON', invocationGrouping: #CHANGE_SET } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument', element: 'SoldToParty' } }]
      @UI.dataPoint: { qualifier: 'SoldToParty', title: 'Sold To Party' }
      SoldToParty,

      @EndUserText.label: 'Sold To Party Name'
      @UI: { lineItem: [ { position: 21, importance: #HIGH }] }
      @UI.dataPoint: { qualifier: 'SoldToParty', title: 'Sold To Party'}
      CustomerName,

      @EndUserText.label: 'Billing Date'
      @UI: { lineItem: [ { position: 30 },
      { type: #FOR_ACTION, dataAction: 'CIRN', label: 'Cancel IRN', invocationGrouping: #CHANGE_SET } ] }           
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',element: 'BillingDocumentDate' } }]
      @UI.dataPoint: { qualifier: 'BillingDocumentDate', title: 'Billing Document Date' }
      BillingDocumentDate,

      @EndUserText.label: 'Billing Type'
      @UI.selectionField: [{ position: 40 }]
      @UI: { lineItem: [{position: 40 }] }
      @Search.defaultSearchElement: true
      @UI.dataPoint: { qualifier: 'BillingDocumentType', title: 'Billing Document Type' }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',element: 'BillingDocumentType' } }]
      BillingDocumentType,

      @EndUserText.label: 'Company Code'
      @UI.selectionField: [{ position: 50 }]
      @UI: { lineItem: [{position: 50 }] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',element: 'CompanyCode' } }]
      @UI.dataPoint: { qualifier: 'CompanyCode', title: 'Company Code' }
      CompanyCode,

      @EndUserText.label: 'Distribution Channel'
      @UI: { lineItem: [{position: 60 }] }
      @Search.defaultSearchElement: true
      @UI.selectionField: [{ position: 60 }]
      @UI.dataPoint: { qualifier: 'DistributionChannel', title: 'Distribution Channel' }
      DistributionChannel,

      @EndUserText.label: 'ODN'
      @UI: {
      //      identification: [{ position: 70 }],
             selectionField: [{ position: 70 }] }
      Odn,

      @EndUserText.label: 'ODN Date'
      @UI: {
      //      identification: [{ position: 80 }],
             selectionField: [{ position: 80 }] }
      OdnDate,

      @EndUserText.label: 'IRN'
      @UI: { lineItem:[{ position: 90 }],
      //      identification: [{ position: 90 }],
      selectionField: [{ position: 90 }] }
      @Search.defaultSearchElement: true
      Irn,

      //      @EndUserText.label: 'IRN Status'
      //      @UI: { lineItem:[{ position: 100 }],
      //      //      identification: [{ position: 100 }],
      //      selectionField: [{ position: 100 }] }
      //      @Search.defaultSearchElement: true
      //      IrnStatus,

      @EndUserText.label: 'Acknowlegment No'
      @UI: {
      //      identification: [{ position: 110 }],
             selectionField: [{ position: 110 }] }
      AckNo,

      @EndUserText.label: 'Acknowlegment Date'
      @UI: {
      //      identification: [{ position: 120 }],
             selectionField: [{ position: 120 }] }
      AckDate,

      @EndUserText.label: 'Cancel Date'
      @UI: {
      //      identification: [{ position: 130 }],
             selectionField: [{ position: 130 }] }
      CancelDate,

      @EndUserText.label: 'Created By'
      @UI: {
      //      identification: [{ position: 140 }],
             selectionField: [{ position: 140 }] }
      Ernam,

      @EndUserText.label: 'Creation Date'
      @UI: {
      //      identification: [{ position: 150 }],
             selectionField: [{ position: 150 }] }
      Erdat,

      @EndUserText.label: 'Creation Time'
      @UI: {
      //      identification: [{ position: 160 }],
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
