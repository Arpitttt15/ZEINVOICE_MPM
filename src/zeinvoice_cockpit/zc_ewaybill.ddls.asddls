@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consuption View for E-WAYBILL'
@Metadata.allowExtensions: true

define view entity ZC_EWAYBILL
  as projection on ZI_ewaybill
{
  key Bukrs,
  key Docno,
  key DocType,
  key Gjahr,
  key Ebillno,
      EgenDat,
      EgenTime,
      Vdfmdate,
      Vdfmtime,
      Vdtodate,
      Vdtotime,
      Status,
      EcanDat,
      EcanTime,
      Ernam,
      Erdat,
      Aenam,
      Aedat,
      /* Associations */
      _BILLINGINV : redirected to parent ZC_BILLINGINV
}
