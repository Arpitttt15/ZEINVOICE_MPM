CLASS lhc_zi_billing_inv DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_billing_inv RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_billing_inv RESULT result.

    METHODS createirn FOR MODIFY
      IMPORTING keys FOR ACTION zi_billing_inv~createirn RESULT result.

    METHODS cirn FOR MODIFY
      IMPORTING keys FOR ACTION zi_billing_inv~cirn RESULT result.
    METHODS json FOR MODIFY
      IMPORTING keys FOR ACTION zi_billing_inv~json.

ENDCLASS.

CLASS lhc_zi_billing_inv IMPLEMENTATION.

  METHOD get_instance_features.

    " Read the active flag of the existing members
    READ ENTITIES OF zi_billing_inv IN LOCAL MODE
        ENTITY zi_billing_inv
          FIELDS ( irn irnstatus ) WITH CORRESPONDING #( keys )
        RESULT DATA(members)
        FAILED failed.

    result = VALUE #(
     FOR member IN members ( %key  = member-%key


      %features-%action-createirn  = if_abap_behv=>fc-o-enabled

      %features-%action-cirn  = COND #( WHEN ( member-irn IS INITIAL )
                             THEN if_abap_behv=>fc-o-disabled
                             ELSE if_abap_behv=>fc-o-enabled )


     ) ).

  ENDMETHOD.


  METHOD get_instance_authorizations.

  ENDMETHOD.

  METHOD createirn.

    DATA: lt_data TYPE TABLE FOR UPDATE zi_billing_inv.

    TYPES: BEGIN OF ty_msg,
             typ(1)   TYPE c,
             vbeln    TYPE zchar,
             msg(100) TYPE c,
           END OF ty_msg.
    DATA : lt_msg TYPE STANDARD TABLE OF ty_msg,
           ls_msg TYPE ty_msg.

    READ ENTITIES OF zi_billing_inv IN LOCAL MODE
          ENTITY zi_billing_inv
            ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(members).

    DATA(lt_keys) = keys.
    DATA : obj_data  TYPE REF TO zcl_expoundtax_einvvoice,
           ls_res    TYPE string,
           lv_status TYPE c.

    LOOP AT members ASSIGNING FIELD-SYMBOL(<fs>).
      CREATE OBJECT obj_data.
      obj_data->generate_irn(
        EXPORTING im_vbeln        = <fs>-billingdocument
        IMPORTING ex_response     = ls_res
                  ex_status       = lv_status
                  es_error_log    = zbp_i_billing_inv=>wa_error_log
                  es_ei_invrefnum = zbp_i_billing_inv=>wa_j_1ig_invrefnum ).

      IF lv_status   = 'E'.
        ls_msg-typ   = 'E'.
        ls_msg-vbeln = <fs>-billingdocument.
        ls_msg-msg = 'Error while generating IRN'.
        APPEND ls_msg TO lt_msg.
        CLEAR ls_msg.

      ELSE.

        lt_data = VALUE #( (  "%cid = 'C1'
                              billingdocument = <fs>-billingdocument
                              irn = 'X'
                              %control = VALUE #( billingdocument = if_abap_behv=>mk-on
                                                  irn = if_abap_behv=>mk-on ) ) ).

        MODIFY ENTITIES OF zi_billing_inv IN LOCAL MODE
        ENTITY zi_billing_inv UPDATE FROM lt_data
        MAPPED DATA(it_mapped)
        FAILED DATA(it_failed)
        REPORTED DATA(it_reported).

        ls_msg-typ   = 'S'.
        ls_msg-vbeln = <fs>-billingdocument.
        ls_msg-msg = 'IRN Generated Succesfully'.
        APPEND ls_msg TO lt_msg.
        CLEAR ls_msg.

      ENDIF.

    ENDLOOP.

    LOOP AT lt_msg INTO ls_msg.
      IF ls_msg-typ = 'S'.
        APPEND VALUE #(   %cid = ls_msg-vbeln
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                             text = 'IRN Generated Succesfully' )
                                %element = VALUE #(  irn  = if_abap_behv=>mk-on  ) )
                                TO reported-zi_billing_inv.
      ELSEIF ls_msg-typ = 'E'.
        APPEND VALUE #(   %cid = ls_msg-vbeln
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                             text = 'Error while generating IRN' )
                                %element = VALUE #(  irn  = if_abap_behv=>mk-off  ) )
                                TO reported-zi_billing_inv.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD cirn.

    DATA: lt_data TYPE TABLE FOR UPDATE zi_billing_inv.

    TYPES: BEGIN OF ty_msg,
             typ(1)   TYPE c,
             vbeln    TYPE zchar,
             msg(100) TYPE c,
           END OF ty_msg.
    DATA : lt_msg TYPE STANDARD TABLE OF ty_msg,
           ls_msg TYPE ty_msg.

    READ ENTITIES OF zi_billing_inv IN LOCAL MODE
    ENTITY zi_billing_inv
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(members).

    DATA(lt_keys) = keys.
    DATA : obj_data  TYPE REF TO zcl_expoundtax_einvvoice,
           ls_res    TYPE string,
           lv_status TYPE c.

    LOOP AT members ASSIGNING FIELD-SYMBOL(<fs>).
      CREATE OBJECT obj_data.
      obj_data->cancel_irn(
        EXPORTING im_vbeln        = <fs>-billingdocument
        IMPORTING ex_response     = ls_res
                  ex_status       = lv_status
                  es_error_log    = zbp_i_billing_inv=>wa_error_log
                  es_ei_invrefnum = zbp_i_billing_inv=>wa_j_1ig_invrefnum ).

      IF lv_status   = 'E'.
        ls_msg-typ   = 'E'.
        ls_msg-vbeln = <fs>-billingdocument.
        ls_msg-msg = 'Error while Cancelling IRN'.
        APPEND ls_msg TO lt_msg.
        CLEAR ls_msg.

      ELSE.

        lt_data = VALUE #( (  "%cid = 'C1'
                              billingdocument = <fs>-billingdocument
                              irn = 'X'
                              %control = VALUE #(
*                                                 billingdocument = if_abap_behv=>mk-on
                                                  irn = if_abap_behv=>mk-on
                                                  ) ) ).

        MODIFY ENTITIES OF zi_billing_inv IN LOCAL MODE
          ENTITY zi_billing_inv UPDATE FROM lt_data
          MAPPED DATA(it_mapped)
          FAILED DATA(it_failed)
          REPORTED DATA(it_reported).

        ls_msg-typ   = 'S'.
        ls_msg-vbeln = <fs>-billingdocument.
        ls_msg-msg = 'IRN Cancelled Succesfully'.
        APPEND ls_msg TO lt_msg.
        CLEAR ls_msg.

      ENDIF.

    ENDLOOP.

    LOOP AT lt_msg INTO ls_msg.
      IF ls_msg-typ = 'S'.
        APPEND VALUE #(   %cid = ls_msg-vbeln
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                             text = 'IRN Cancelled Succesfully' )
                                %element = VALUE #(  irn  = if_abap_behv=>mk-on  ) )
                                TO reported-zi_billing_inv.
      ELSEIF ls_msg-typ = 'E'.
        APPEND VALUE #(   %cid = ls_msg-vbeln
                          %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                             text = 'Error while cancelling IRN' )
                                %element = VALUE #(  irn  = if_abap_behv=>mk-off  ) )
                                TO reported-zi_billing_inv.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD json.

    DATA: lt_data TYPE TABLE FOR UPDATE zi_billing_inv.

    TYPES: BEGIN OF ty_msg,
             typ(1)   TYPE c,
             vbeln    TYPE zchar,
             msg(100) TYPE c,
           END OF ty_msg.
    DATA : lt_msg TYPE STANDARD TABLE OF ty_msg,
           ls_msg TYPE ty_msg.

    READ ENTITIES OF zi_billing_inv IN LOCAL MODE
    ENTITY zi_billing_inv
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(members).

    DATA(lt_keys) = keys.
    DATA : obj_data  TYPE REF TO zcl_expoundtax_einvvoice,
           ls_res    TYPE string,
           lv_status TYPE c.

    CLEAR : zbp_i_billing_inv=>wa_einv_json,
            zbp_i_billing_inv=>wa_error_log,
            zbp_i_billing_inv=>wa_j_1ig_invrefnum.

    LOOP AT members ASSIGNING FIELD-SYMBOL(<fs>).
      CREATE OBJECT obj_data.
      obj_data->download_json(
        EXPORTING im_vbeln        = <fs>-billingdocument
        IMPORTING ex_response     = ls_res
                  ex_status       = lv_status
                  es_error_log    = zbp_i_billing_inv=>wa_error_log
                  es_ei_invrefnum = zbp_i_billing_inv=>wa_j_1ig_invrefnum
                  es_ei_json      = zbp_i_billing_inv=>wa_einv_json ).

      ls_msg-typ   = 'S'.
      ls_msg-vbeln = <fs>-billingdocument.
      ls_msg-msg = 'JSON Updated Successfully'.
      APPEND ls_msg TO lt_msg.
      CLEAR ls_msg.

      <fs>-einvjson = zbp_i_billing_inv=>wa_einv_json-einv_json.

    ENDLOOP.

    LOOP AT lt_msg INTO ls_msg.
      IF ls_msg-typ = 'S'.
        APPEND VALUE #(   %cid = ls_msg-vbeln
                          %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-success
                          text     = 'JSON Updated Successfully' )
                          %element = VALUE #(  irn  = if_abap_behv=>mk-on  ) ) TO reported-zi_billing_inv.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_billing_inv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_billing_inv IMPLEMENTATION.

  METHOD save_modified.

    IF zbp_i_billing_inv=>wa_error_log IS NOT INITIAL.
      MODIFY ztsd_ei_log FROM @zbp_i_billing_inv=>wa_error_log.
    ENDIF.

    IF zbp_i_billing_inv=>wa_j_1ig_invrefnum IS NOT INITIAL.
      MODIFY zei_invrefnum FROM @zbp_i_billing_inv=>wa_j_1ig_invrefnum.
    ENDIF.

    IF zbp_i_billing_inv=>wa_einv_json IS NOT INITIAL.
      MODIFY ztsd_einv_json FROM @zbp_i_billing_inv=>wa_einv_json.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
