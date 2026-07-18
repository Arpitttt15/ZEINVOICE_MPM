@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_EXPOUNDTAX_EINV'
    }
}

@UI.headerInfo: { typeName: 'Einvoice Generation : ExpoundTax' ,
                  typeNamePlural: 'Einvoice Generation : ExpoundTax' }


@EndUserText.label: 'Einvoice Generation : ClearTax'
define root custom entity ZCE_EXPOUNDTAX_EINV
{
  @UI.facet: [{ id : 'VBELN',
            purpose: #STANDARD,
            type: #IDENTIFICATION_REFERENCE,
            label: 'Einvoice Generation : ClearTax',
            position: 10 }]

 @UI.selectionField  : [{position: 10 }]
 @UI.lineItem :  [{label: 'Invoice Number', position: 10 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Invoice Number', position: 10 }]
 @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                               element: 'BillingDocument' } }]
  key BillingDocument :   abap.char(10);

// @UI.selectionField    : [{position: 20 }]
 @UI.lineItem :  [{label: 'Invoice Date', position: 20 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Invoice Date', position: 20 }] 
// @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
//                                                element: 'BillingDocumentDate' } }] 
  BillingDocumentDate : datum;
  
 //@UI.selectionField    : [{position: 30 }]
 @UI.lineItem :  [{label: 'Sold To Party', position: 30 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Sold To Party', position: 30 }] 
  kunag     : abap.char(10);    

 @UI.lineItem :  [{label: 'Version', position: 40 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Version', position: 40 }]   
  version  : abap.char(3);  

 //@UI.selectionField    : [{position: 50 }]
 @UI.lineItem :  [{label: 'Document type', position: 50 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Document type', position: 50 }] 
 @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                element: 'BillingDocumentType' } }] 
  BillingDocumentType : abap.char(4);
  
 //@UI.selectionField    : [{position: 60 }]
 @UI.lineItem :  [{label: 'Distribution Channel', position: 60 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Distribution Channel', position: 60 }]   
  vtweg : abap.char(2);
  
 @UI.lineItem :  [{label: 'IRN No', position: 70 ,importance: #HIGH }] 
 @UI.identification: [{ label: 'IRN No', position: 70 }]  
  IRN : abap.char(64);  

 @UI.lineItem :  [{label: 'IRN Status', position: 80 ,importance: #HIGH }]
 @UI.identification: [{ label: 'IRN Status', position: 80 }] 
  irnstatus    : abap.char(3);
  
 @UI.lineItem :  [{label: 'Log Message', position: 90 ,hidden: true }]
 @UI.identification: [{ label: 'Log Message', position: 90 ,importance: #HIGH}] 
  message    : abap.string(0);
  
}
