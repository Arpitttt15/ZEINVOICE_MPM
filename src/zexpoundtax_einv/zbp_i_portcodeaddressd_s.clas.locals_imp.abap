CLASS LHC_RAP_TDAT_CTS DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS:
      GET
        RETURNING
          VALUE(RESULT) TYPE REF TO IF_MBC_CP_RAP_TDAT_CTS.

ENDCLASS.

CLASS LHC_RAP_TDAT_CTS IMPLEMENTATION.
  METHOD GET.
    result = mbc_cp_api=>rap_tdat_cts( tdat_name = 'ZPORTCODEADDRESSD'
                                       table_entity_relations = VALUE #(
                                         ( entity = 'PortCodeAddressDeta' table = 'ZTSD_PORT_DTLS' )
                                       ) ) ##NO_TEXT.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PORTCODEADDRESSD_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR PortCodeAddress
        RESULT result,
      SELECTCUSTOMIZINGTRANSPTREQ FOR MODIFY
        IMPORTING
          KEYS FOR ACTION PortCodeAddress~SelectCustomizingTransptReq
        RESULT result,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR PortCodeAddress
        RESULT result,
      EDIT FOR MODIFY
        IMPORTING
          KEYS FOR ACTION PortCodeAddress~edit.
ENDCLASS.

CLASS LHC_ZI_PORTCODEADDRESSD_S IMPLEMENTATION.
  METHOD GET_INSTANCE_FEATURES.
    DATA: edit_flag            TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled
         ,transport_feature    TYPE abp_behv_field_ctrl VALUE if_abap_behv=>fc-f-mandatory
         ,selecttransport_flag TYPE abp_behv_op_ctrl    VALUE if_abap_behv=>fc-o-enabled.

    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    IF lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ) = abap_false.
      transport_feature = if_abap_behv=>fc-f-unrestricted.
    ENDIF.
    result = VALUE #( FOR key in keys (
               %TKY = key-%TKY
               %ACTION-edit = edit_flag
               %ASSOC-_PortCodeAddressDeta = edit_flag
               %FIELD-TransportRequestID = transport_feature
               %ACTION-SelectCustomizingTransptReq = COND #( WHEN key-%IS_DRAFT = if_abap_behv=>mk-off
                                                             THEN if_abap_behv=>fc-o-disabled
                                                             ELSE selecttransport_flag ) ) ).
  ENDMETHOD.
  METHOD SELECTCUSTOMIZINGTRANSPTREQ.
    MODIFY ENTITIES OF ZI_PortCodeAddressD_S IN LOCAL MODE
      ENTITY PortCodeAddress
        UPDATE FIELDS ( TransportRequestID )
        WITH VALUE #( FOR key IN keys
                        ( %TKY               = key-%TKY
                          TransportRequestID = key-%PARAM-transportrequestid
                         ) ).

    READ ENTITIES OF ZI_PortCodeAddressD_S IN LOCAL MODE
      ENTITY PortCodeAddress
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %TKY   = entity-%TKY
                          %PARAM = entity ) ).
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
*    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_PORTCODEADDRESSD' ID 'ACTVT' FIELD '02'.
*    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
*                                  ELSE if_abap_behv=>auth-unauthorized ).
*    result-%UPDATE      = is_authorized.
*    result-%ACTION-Edit = is_authorized.
*    result-%ACTION-SelectCustomizingTransptReq = is_authorized.
  ENDMETHOD.
  METHOD EDIT.
    CHECK lhc_rap_tdat_cts=>get( )->is_transport_mandatory( ).
    DATA(transport_request) = lhc_rap_tdat_cts=>get( )->get_transport_request( ).
    IF transport_request IS NOT INITIAL.
      MODIFY ENTITY IN LOCAL MODE ZI_PortCodeAddressD_S
        EXECUTE SelectCustomizingTransptReq FROM VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                                            SingletonID = 1
                                                            %PARAM-transportrequestid = transport_request ) ).
      reported-PortCodeAddress = VALUE #( ( %IS_DRAFT = if_abap_behv=>mk-on
                                     SingletonID = 1
                                     %MSG = mbc_cp_api=>message( )->get_transport_selected( transport_request ) ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LSC_ZI_PORTCODEADDRESSD_S DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_SAVER.
  PROTECTED SECTION.
    METHODS:
      SAVE_MODIFIED REDEFINITION.
ENDCLASS.

CLASS LSC_ZI_PORTCODEADDRESSD_S IMPLEMENTATION.
  METHOD SAVE_MODIFIED.
    DATA(transport_from_singleton) = VALUE #( update-PortCodeAddress[ 1 ]-TransportRequestID OPTIONAL ).
    IF transport_from_singleton IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = transport_from_singleton
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
CLASS LHC_ZI_PORTCODEADDRESSD DEFINITION FINAL INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_FEATURES FOR GLOBAL FEATURES
        IMPORTING
          REQUEST REQUESTED_FEATURES FOR PortCodeAddressDeta
        RESULT result,
      COPYPORTCODEADDRESSDETA FOR MODIFY
        IMPORTING
          KEYS FOR ACTION PortCodeAddressDeta~CopyPortCodeAddressDeta,
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR PortCodeAddressDeta
        RESULT result,
      GET_INSTANCE_FEATURES FOR INSTANCE FEATURES
        IMPORTING
          KEYS REQUEST requested_features FOR PortCodeAddressDeta
        RESULT result,
      VALIDATETRANSPORTREQUEST FOR VALIDATE ON SAVE
        IMPORTING
          KEYS_PORTCODEADDRESS FOR PortCodeAddress~ValidateTransportRequest
          KEYS_PORTCODEADDRESSDETA FOR PortCodeAddressDeta~ValidateTransportRequest.
ENDCLASS.

CLASS LHC_ZI_PORTCODEADDRESSD IMPLEMENTATION.
  METHOD GET_GLOBAL_FEATURES.
    DATA edit_flag TYPE abp_behv_op_ctrl VALUE if_abap_behv=>fc-o-enabled.
    IF lhc_rap_tdat_cts=>get( )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%UPDATE = edit_flag.
    result-%DELETE = edit_flag.
  ENDMETHOD.
  METHOD COPYPORTCODEADDRESSDETA.
    DATA new_PortCodeAddressDeta TYPE TABLE FOR CREATE ZI_PortCodeAddressD_S\_PortCodeAddressDeta.

    IF lines( keys ) > 1.
      INSERT mbc_cp_api=>message( )->get_select_only_one_entry( ) INTO TABLE reported-%other.
      failed-PortCodeAddressDeta = VALUE #( FOR fkey IN keys ( %TKY = fkey-%TKY ) ).
      RETURN.
    ENDIF.

    READ ENTITIES OF ZI_PortCodeAddressD_S IN LOCAL MODE
      ENTITY PortCodeAddressDeta
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(ref_PortCodeAddressDeta)
        FAILED DATA(read_failed).

    IF ref_PortCodeAddressDeta IS NOT INITIAL.
      ASSIGN ref_PortCodeAddressDeta[ 1 ] TO FIELD-SYMBOL(<ref_PortCodeAddressDeta>).
      DATA(key) = keys[ KEY draft %TKY = <ref_PortCodeAddressDeta>-%TKY ].
      DATA(key_cid) = key-%CID.
      APPEND VALUE #(
        %TKY-SingletonID = 1
        %IS_DRAFT = <ref_PortCodeAddressDeta>-%IS_DRAFT
        %TARGET = VALUE #( (
          %CID = key_cid
          %IS_DRAFT = <ref_PortCodeAddressDeta>-%IS_DRAFT
          %DATA = CORRESPONDING #( <ref_PortCodeAddressDeta> EXCEPT
          SingletonID
          LocalLastChangedBy
          LocalLastChangedAt
          LastChangedAt
        ) ) )
      ) TO new_PortCodeAddressDeta ASSIGNING FIELD-SYMBOL(<new_PortCodeAddressDeta>).
      <new_PortCodeAddressDeta>-%TARGET[ 1 ]-SapPortCode = to_upper( key-%PARAM-SapPortCode ).
      <new_PortCodeAddressDeta>-%TARGET[ 1 ]-PortCode = key-%PARAM-PortCode.

      MODIFY ENTITIES OF ZI_PortCodeAddressD_S IN LOCAL MODE
        ENTITY PortCodeAddress CREATE BY \_PortCodeAddressDeta
        FIELDS (
                 SapPortCode
                 PortCode
                 PortDesc
                 PortGstin
                 Name1
                 Stras
                 Address1
                 Adress2
                 Ort01
                 Pstlz
                 Regio
               ) WITH new_PortCodeAddressDeta
        MAPPED DATA(mapped_create)
        FAILED failed
        REPORTED reported.

      mapped-PortCodeAddressDeta = mapped_create-PortCodeAddressDeta.
    ENDIF.

    INSERT LINES OF read_failed-PortCodeAddressDeta INTO TABLE failed-PortCodeAddressDeta.

    IF failed-PortCodeAddressDeta IS INITIAL.
      reported-PortCodeAddressDeta = VALUE #( FOR created IN mapped-PortCodeAddressDeta (
                                                 %CID = created-%CID
                                                 %ACTION-CopyPortCodeAddressDeta = if_abap_behv=>mk-on
                                                 %MSG = mbc_cp_api=>message( )->get_item_copied( )
                                                 %PATH-PortCodeAddress-%IS_DRAFT = created-%IS_DRAFT
                                                 %PATH-PortCodeAddress-SingletonID = 1 ) ).
    ENDIF.
  ENDMETHOD.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_PORTCODEADDRESSD' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = COND #( WHEN sy-subrc = 0 THEN if_abap_behv=>auth-allowed
                                  ELSE if_abap_behv=>auth-unauthorized ).
    result-%ACTION-CopyPortCodeAddressDeta = is_authorized.
  ENDMETHOD.
  METHOD GET_INSTANCE_FEATURES.
    result = VALUE #( FOR row IN keys ( %TKY = row-%TKY
                                        %ACTION-CopyPortCodeAddressDeta = COND #( WHEN row-%IS_DRAFT = if_abap_behv=>mk-off THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled )
    ) ).
  ENDMETHOD.
  METHOD VALIDATETRANSPORTREQUEST.
    CHECK keys_PortCodeAddressDeta IS NOT INITIAL.
    DATA change TYPE REQUEST FOR CHANGE ZI_PortCodeAddressD_S.
    READ ENTITY IN LOCAL MODE ZI_PortCodeAddressD_S
    FIELDS ( TransportRequestID ) WITH CORRESPONDING #( keys_PortCodeAddress )
    RESULT FINAL(transport_from_singleton).
    lhc_rap_tdat_cts=>get( )->validate_all_changes(
                                transport_request     = VALUE #( transport_from_singleton[ 1 ]-TransportRequestID OPTIONAL )
                                table_validation_keys = VALUE #(
                                                          ( table = 'ZTSD_PORT_DTLS' keys = REF #( keys_PortCodeAddressDeta ) )
                                                               )
                                reported              = REF #( reported )
                                failed                = REF #( failed )
                                change                = REF #( change ) ).
  ENDMETHOD.
ENDCLASS.
