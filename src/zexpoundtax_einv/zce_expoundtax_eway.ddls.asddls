@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_EXPOUNDTAX_EINV'
    }
}

@UI.headerInfo: { typeName: 'E-WayBill Generation : ExpoundTax' ,
                  typeNamePlural: 'E-WayBill Generation : ExpoundTax' }


@EndUserText.label: 'E-WayBill Generation : ClearTax'
define root custom entity ZCE_EXPOUNDTAX_EWAY
{
  @UI.facet: [{ id : 'VBELN',
            purpose: #STANDARD,
            type: #IDENTIFICATION_REFERENCE,
            label: 'E-WayBill Generation : ClearTax',
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
  
 @UI.selectionField    : [{position: 20 }]  
  Trans_GSTIN : abap.char(18);
  
 @UI.selectionField    : [{position: 25 }]  
  Trans_Name : abap.char(40);  

 @UI.selectionField    : [{position: 30 }]  
  Distance : abap.numc(10);      
  
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
  
 @UI.lineItem :  [{label: 'EWayBill No', position: 70 ,importance: #HIGH }] 
 @UI.identification: [{ label: 'EWayBill No', position: 70 }]  
  ebillno : abap.char(12);  

 @UI.lineItem :  [{label: 'Status', position: 80 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Status', position: 80 }] 
  status    : abap.char(3);
  

 @UI.lineItem :  [{label: 'Gen. Date', position: 90 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Gen. Date', position: 90 }] 
  egen_dat    : datum;  
  
 @UI.lineItem :  [{label: 'Gen. Time', position: 100 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Gen. Time', position: 100 }] 
  egen_time    : uzeit;    

 @UI.lineItem :  [{label: 'Valid From Date', position: 110 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Valid From Date', position: 110 }] 
  vdfmdate    : datum;    
  
 @UI.lineItem :  [{label: 'Valid From Time', position: 120 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Valid From Time', position: 120 }] 
  vdfmtime    : uzeit;      
  

 @UI.lineItem :  [{label: 'Valid To Date', position: 130 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Valid To Date', position: 130 }] 
  vdtodate    : datum;    
  
 @UI.lineItem :  [{label: 'Valid To Time', position: 140 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Valid To Time', position: 140 }] 
  vdtotime    : uzeit;          
  
 @UI.lineItem :  [{label: 'Log Message', position: 150 ,hidden: true }]
 @UI.identification: [{ label: 'Log Message', position: 150 ,importance: #HIGH}] 
  message    : abap.string(0);
  
}
