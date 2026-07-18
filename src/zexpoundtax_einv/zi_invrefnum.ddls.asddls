@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view INVREFNUM'

define root view entity ZI_INVREFNUM
  as select from zei_invrefnum
{
  key bukrs         as Bukrs,
  key docno         as Docno,
  key doc_year      as DocYear,
  key doc_type      as DocType,
  key odn           as Odn,
  key irn           as Irn,
  key version       as Version,
      bupla         as Bupla,
      odn_date      as OdnDate,
      ack_no        as AckNo,
      ack_date      as AckDate,
      irn_status    as IrnStatus,
      cancel_date   as CancelDate,
      ernam         as Ernam,
      erdat         as Erdat,
      erzet         as Erzet,
      signed_inv    as SignedInv,
      signed_qrcode as SignedQrcode
}
