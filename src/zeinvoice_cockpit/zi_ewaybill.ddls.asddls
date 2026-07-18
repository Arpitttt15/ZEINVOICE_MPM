@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for E-WAYBILL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ewaybill
  as select from zew_ewaybill as _ewaybill
  association to parent ZI_BILLINGINV as _BILLINGINV on $projection.Docno = _BILLINGINV.BillingDocument
{
  key bukrs     as Bukrs,
  key docno     as Docno,
  key doc_type  as DocType,
  key gjahr     as Gjahr,
  key ebillno   as Ebillno,
      egen_dat  as EgenDat,
      egen_time as EgenTime,
      vdfmdate  as Vdfmdate,
      vdfmtime  as Vdfmtime,
      vdtodate  as Vdtodate,
      vdtotime  as Vdtotime,
      status    as Status,
      ecan_dat  as EcanDat,
      ecan_time as EcanTime,
      ernam     as Ernam,
      erdat     as Erdat,
      aenam     as Aenam,
      aedat     as Aedat,

      _BILLINGINV

}
