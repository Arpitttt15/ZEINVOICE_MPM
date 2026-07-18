CLASS zcl_expoundtax_einv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EXPOUNDTAX_EINV IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lv_entiry) = io_request->get_entity_id( ).
    IF io_request->is_data_requested( ).

      DATA: lt_response   TYPE TABLE OF zce_expoundtax_einv,
            ls_response   TYPE zce_expoundtax_einv,
            lt_response_1 TYPE TABLE OF zce_expoundtax_eway,
            ls_response_1 TYPE zce_expoundtax_eway,
            r_vbeln       TYPE RANGE OF i_billingdocumentbasic-billingdocument,
            s_vbeln       LIKE LINE OF r_vbeln.

      DATA : obj_data     TYPE REF TO zcl_expoundtax_einvvoice,
             obj_data_1   TYPE REF TO zcl_expoundtax_ewaybill,
             ls_res       TYPE string,
             lv_status(1) TYPE c.

      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
         DATA(lv_text) = lx_no_sel_option->get_text( ).  ##NO_HANDLER
      ENDTRY.

      DATA(lr_vbeln)  =  VALUE #( lt_filter_cond[ name   = 'BILLINGDOCUMENT' ]-range OPTIONAL ).

      CLEAR r_vbeln[].
      IF lr_vbeln[] IS NOT INITIAL.
        LOOP AT lr_vbeln INTO DATA(ls_vbeln).
          s_vbeln-sign = ls_vbeln-sign.
          s_vbeln-option = ls_vbeln-option.
          s_vbeln-low = |{ ls_vbeln-low ALPHA = IN }|.
          s_vbeln-high = |{ ls_vbeln-high ALPHA = IN }|.
          APPEND s_vbeln TO r_vbeln.
          CLEAR s_vbeln.
        ENDLOOP.
      ENDIF.

      CASE lv_entiry.

        WHEN 'ZCE_CLEARTAX_EINV'.

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT billingdocument, billingdocumenttype, sddocumentcategory,
                   billingdocumentcategory, distributionchannel, billingdocumentdate,
                   soldtoparty
                    FROM i_billingdocument
                WHERE billingdocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @DATA(lt_bill) UP TO @lv_top ROWS.

            LOOP AT lt_bill INTO DATA(ls_bill).

              CREATE OBJECT obj_data.
              obj_data->generate_irn(
                    EXPORTING im_vbeln     = ls_bill-billingdocument
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-billingdocument
              AND   method = 'GENERATE_IRN'
              INTO TABLE @DATA(lt_log).
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.


          ENDIF.


          IF lt_bill[] IS NOT INITIAL.
            SELECT * FROM zei_invrefnum FOR ALL ENTRIES IN @lt_bill
            WHERE docno = @lt_bill-billingdocument
            INTO TABLE @DATA(lt_irn).
            IF lt_irn[] IS NOT INITIAL.
              SORT lt_irn BY docno ASCENDING version DESCENDING.
            ENDIF.

            LOOP AT lt_bill INTO ls_bill.
              ls_response-billingdocument      = ls_bill-billingdocument.
              ls_response-billingdocumentdate  = ls_bill-billingdocumentdate.
              ls_response-billingdocumenttype  = ls_bill-billingdocumenttype.
              ls_response-vtweg    = ls_bill-distributionchannel.
              ls_response-kunag    = ls_bill-soldtoparty.

              READ TABLE lt_irn INTO DATA(ls_irn) WITH KEY docno = ls_bill-billingdocument." BINARY SEARCH.
              IF sy-subrc = 0.
                ls_response-version   = ls_irn-version.
                ls_response-irn       = ls_irn-irn.
                ls_response-irnstatus = ls_irn-irn_status.
              ENDIF.

              READ TABLE lt_log INTO DATA(ls_log) WITH KEY docno = ls_bill-billingdocument." BINARY SEARCH.
              IF sy-subrc = 0.
                ls_response-message   = ls_log-message.
              ENDIF.


              APPEND ls_response TO lt_response.
              CLEAR ls_response.
            ENDLOOP.
          ENDIF.

          io_response->set_total_number_of_records( lines( lt_response ) ).
          io_response->set_data( lt_response ).


        WHEN 'ZCE_EXPOUNDTAX_EINV_CANC'.

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT billingdocument, billingdocumenttype, sddocumentcategory,
                   billingdocumentcategory, distributionchannel, billingdocumentdate,
                   soldtoparty
                    FROM i_billingdocument
                WHERE billingdocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         AND   BillingDocumentIsCancelled = 'X'
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @lt_bill UP TO @lv_top ROWS.

            LOOP AT lt_bill INTO ls_bill.

              CREATE OBJECT obj_data.
              obj_data->cancel_irn(
                    EXPORTING im_vbeln     = ls_bill-billingdocument
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-billingdocument
              AND   method = 'CANCEL_IRN'
              INTO TABLE @lt_log.
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM zei_invrefnum FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-billingdocument
              INTO TABLE @lt_irn.
              IF lt_irn[] IS NOT INITIAL.
                SORT lt_irn BY docno ASCENDING version DESCENDING.
              ENDIF.

              LOOP AT lt_bill INTO ls_bill.
                ls_response-billingdocument      = ls_bill-billingdocument.
                ls_response-billingdocumentdate  = ls_bill-billingdocumentdate.
                ls_response-billingdocumenttype  = ls_bill-billingdocumenttype.
                ls_response-vtweg    = ls_bill-distributionchannel.
                ls_response-kunag    = ls_bill-soldtoparty.

                READ TABLE lt_irn INTO ls_irn WITH KEY docno = ls_bill-billingdocument ."BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response-version   = ls_irn-version.
                  ls_response-irn       = ls_irn-irn.
                  ls_response-irnstatus = ls_irn-irn_status.
                ENDIF.

                READ TABLE lt_log INTO ls_log WITH KEY docno = ls_bill-billingdocument ."BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response-message   = ls_log-message.
                ENDIF.


                APPEND ls_response TO lt_response.
                CLEAR ls_response.
              ENDLOOP.
            ENDIF.

            io_response->set_total_number_of_records( lines( lt_response ) ).
            io_response->set_data( lt_response ).


          ENDIF.

        WHEN 'ZCE_EXPOUNDTAX_EWAY'.

          DATA(lr_gstin)  =  VALUE #( lt_filter_cond[ name   = 'TRANS_GSTIN' ]-range OPTIONAL ).
          DATA(lr_name)  =  VALUE #( lt_filter_cond[ name   = 'TRANS_NAME' ]-range OPTIONAL ).
          DATA(lr_distance)  =  VALUE #( lt_filter_cond[ name   = 'DISTANCE' ]-range OPTIONAL ).

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT billingdocument, billingdocumenttype, sddocumentcategory,
                   billingdocumentcategory, distributionchannel, billingdocumentdate,
                   soldtoparty
                    FROM i_billingdocument
                WHERE billingdocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @lt_bill UP TO @lv_top ROWS.

            DATA : lv_gstin(18) TYPE c,
                   lv_name      TYPE c length 200,
                   lv_dist      TYPE c length 10.

            IF lr_gstin[] IS NOT INITIAL.
              READ TABLE lr_gstin INTO DATA(ls_gstin) INDEX 1.
              lv_gstin = ls_gstin-low.
            ENDIF.

            IF lr_name[] IS NOT INITIAL.
              READ TABLE lr_name INTO DATA(ls_name) INDEX 1.
              lv_name = ls_name-low.
            ENDIF.

            IF lr_distance[] IS NOT INITIAL.
              READ TABLE lr_distance INTO DATA(ls_distance) INDEX 1.
              lv_dist = ls_distance-low.
            ENDIF.

            LOOP AT lt_bill INTO ls_bill.

              CREATE OBJECT obj_data_1.
              obj_data_1->generate_eway(
                    EXPORTING im_vbeln     = ls_bill-billingdocument
*                              im_gstin     = lv_gstin
*                              im_name      = lv_name
*                              im_dist      = lv_dist
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.


            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-billingdocument
              AND   method = 'GENERATE_EWAY'
              INTO TABLE @lt_log.
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM zew_ewaybill FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-billingdocument
              INTO TABLE @DATA(lt_eway).
              IF lt_irn[] IS NOT INITIAL.
*                SORT lt_eway BY docno ASCENDING createdon DESCENDING createdat DESCENDING.
              ENDIF.

              LOOP AT lt_bill INTO ls_bill.
                ls_response_1-billingdocument      = ls_bill-billingdocument.
                ls_response_1-billingdocumentdate  = ls_bill-billingdocumentdate.
                ls_response_1-billingdocumenttype  = ls_bill-billingdocumenttype.
                ls_response_1-vtweg    = ls_bill-distributionchannel.
                ls_response_1-kunag    = ls_bill-soldtoparty.

                READ TABLE lt_eway INTO DATA(ls_eway) WITH KEY docno = ls_bill-billingdocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-ebillno   = ls_eway-ebillno.
                  ls_response_1-status    = ls_eway-status.
                  ls_response_1-egen_dat  = ls_eway-egen_dat.
                  ls_response_1-vdfmdate  = ls_eway-vdfmdate.
                  ls_response_1-vdfmtime  = ls_eway-vdfmtime.
                  ls_response_1-vdtodate  = ls_eway-vdtodate.
                  ls_response_1-vdtotime  = ls_eway-vdtotime.
                ENDIF.

                READ TABLE lt_log INTO ls_log WITH KEY docno = ls_bill-billingdocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-message   = ls_log-message.
                ENDIF.


                APPEND ls_response_1 TO lt_response_1.
                CLEAR ls_response_1.
              ENDLOOP.
            ENDIF.

            io_response->set_total_number_of_records( lines( lt_response_1 ) ).
            io_response->set_data( lt_response_1 ).

          ENDIF.

        WHEN 'ZCE_CLEARTAX_EWAY_CANC'.

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT billingdocument, billingdocumenttype, sddocumentcategory,
                   billingdocumentcategory, distributionchannel, billingdocumentdate,
                   soldtoparty
                    FROM i_billingdocument
                WHERE billingdocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         AND   BillingDocumentIsCancelled = 'X'
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @lt_bill UP TO @lv_top ROWS.

            LOOP AT lt_bill INTO ls_bill.

              CREATE OBJECT obj_data_1.
              obj_data_1->cancel_eway(
                    EXPORTING im_vbeln     = ls_bill-billingdocument
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.


            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-billingdocument
              AND   method = 'CANCEL_EWAY'
              INTO TABLE @lt_log.
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM zew_ewaybill FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-billingdocument
              INTO TABLE @lt_eway.
              IF lt_irn[] IS NOT INITIAL.
*                SORT lt_eway BY docno ASCENDING createdon DESCENDING createdat DESCENDING.
              ENDIF.

              LOOP AT lt_bill INTO ls_bill.
                ls_response_1-billingdocument      = ls_bill-billingdocument.
                ls_response_1-billingdocumentdate  = ls_bill-billingdocumentdate.
                ls_response_1-billingdocumenttype  = ls_bill-billingdocumenttype.
                ls_response_1-vtweg    = ls_bill-distributionchannel.
                ls_response_1-kunag    = ls_bill-soldtoparty.

                READ TABLE lt_eway INTO ls_eway WITH KEY docno = ls_bill-billingdocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-ebillno   = ls_eway-ebillno.
                  ls_response_1-status    = ls_eway-status.
                  ls_response_1-egen_dat  = ls_eway-egen_dat.
                  ls_response_1-vdfmdate  = ls_eway-vdfmdate.
                  ls_response_1-vdfmtime  = ls_eway-vdfmtime.
                  ls_response_1-vdtodate  = ls_eway-vdtodate.
                  ls_response_1-vdtotime  = ls_eway-vdtotime.
                ENDIF.

                READ TABLE lt_log INTO ls_log WITH KEY docno = ls_bill-billingdocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-message   = ls_log-message.
                ENDIF.


                APPEND ls_response_1 TO lt_response_1.
                CLEAR ls_response_1.
              ENDLOOP.
            ENDIF.

            io_response->set_total_number_of_records( lines( lt_response_1 ) ).
            io_response->set_data( lt_response_1 ).



          ENDIF.

      ENDCASE.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
