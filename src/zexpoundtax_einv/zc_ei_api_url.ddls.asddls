@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View API URL'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_EI_API_URL
  provider contract transactional_query
  as projection on ZI_EI_API_URL
{

@EndUserText.label: 'Id'
key Id,

      @EndUserText.label: 'Company Code'
      @UI.facet: [{   id : 'D1',
                        purpose: #STANDARD,
                        type: #IDENTIFICATION_REFERENCE,
                        label: 'URL Data',
                        position: 10
            } ]
      @UI: { lineItem: [{position: 10 }], identification: [{position: 10 }] }
  key Bukrs,

      @EndUserText.label: 'API Type'
      @UI: { lineItem: [{position: 20 }], identification: [{position: 20 }] }
  key Type,

      @EndUserText.label: 'Method'
      @UI: { lineItem: [{position: 30 }], identification: [{position: 30 }] }
  key Method,

      @EndUserText.label: 'GSTIN'
      @UI: { lineItem: [{position: 40 }], identification: [{position: 40 }] }
  key Parameter3,

      @EndUserText.label: 'URL'
      @UI: { lineItem: [{position: 50 }], identification: [{position: 50 }] }
      Url,

      @EndUserText.label: 'Key1'
      @UI: { lineItem: [{position: 60 }], identification: [{position: 60 }] }
      Parameter1,

      @EndUserText.label: 'Key2'
      @UI: { lineItem: [{position: 70 }], identification: [{position: 70 }] }
      Parameter2,

      @EndUserText.label: 'User Name'
      @UI: { lineItem: [{position: 80 }], identification: [{position: 80 }] }
      Parameter4,

      @EndUserText.label: 'Password'
      @UI: { lineItem: [{position: 90 }], identification: [{position: 90 }] }
      Parameter5
}
