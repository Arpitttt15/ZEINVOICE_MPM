@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Endusertext: {
  Label: '###GENERATED Core Data Service Entity'
}
@Objectmodel: {
  Sapobjectnodetype.Name: 'ZEIAPI_URL000'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_EIAPI_URL000
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_EIAPI_URL000
  association [1..1] to ZR_EIAPI_URL000 as _BaseEntity on $projection.ID = _BaseEntity.ID and $projection.BUKRS = _BaseEntity.BUKRS and $projection.TYPE = _BaseEntity.TYPE
{
  key ID,
  key Bukrs,
  key Type,
  Method,
  Url,
  Param1,
  Param2,
  Param3,
  Param4,
  Param5,
  Param6,
  @Semantics: {
    User.Createdby: true
  }
  CreatedBy,
  @Semantics: {
    Systemdatetime.Createdat: true
  }
  CreatedAt,
  @Semantics: {
    User.Localinstancelastchangedby: true
  }
  LastChangedBy,
  @Semantics: {
    Systemdatetime.Localinstancelastchangedat: true
  }
  LastChangedAt,
  _BaseEntity
}
