CLASS zcl_expoundtax_ewaybill DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA : gv_exp TYPE c.

    DATA : lv_str TYPE string.

    DATA : it_data      TYPE TABLE OF zsdst_eway_bill,
           wa_data      TYPE zsdst_eway_bill,
           it_ewb       TYPE TABLE OF zew_ewaybill,
           wa_ewb       TYPE zew_ewaybill,
           it_error_log TYPE TABLE OF ztsd_ew_log,
           wa_error_log TYPE ztsd_ew_log.

    DATA : json TYPE string.

    DATA : lv_buyer       TYPE i_customer-customer,
           lv_soldtoparty TYPE i_customer-customer,
           wa_vbrk        TYPE i_billingdocument.

    DATA : gv_gstin       TYPE string,
           gv_contenttype TYPE string VALUE 'application/json',
           gv_username    TYPE string,
           gv_token       TYPE string.

    DATA:
      it_zei_api_url  TYPE STANDARD TABLE OF zei_api_url,
      wa_zei_api_url  TYPE zei_api_url,
      lv_access_token TYPE string,
      lv_url_post     TYPE string,
      lv_access       TYPE string,
      lv_compid       TYPE string.

    DATA : lv_billto_shipto TYPE c,
           lv_billfr_dispfr TYPE c.
    DATA : lv_owner_id TYPE string.

    DATA : lv_token       TYPE string,
           lv_monthyear   TYPE string,
           lv_gstin       TYPE string,
           iv_gstin_tr    TYPE string,
           iv_name_tr     TYPE string,
           iv_distance    TYPE string,
           lv_mvapikey    TYPE string,
           lv_mvsecretkey TYPE string,
           lv_username    TYPE string,
           lv_password    TYPE string.

    DATA: lv_url_get               TYPE string,
          lv_auth_body             TYPE string,
          lv_content_length_value  TYPE i,
          lv_http_return_code      TYPE i,
          lv_http_error_descr      TYPE string,
          lv_http_error_descr_long TYPE xstring,
          lv_xml_result_str        TYPE string,
          lv_response              TYPE string,
          lv_stat                  TYPE c,
          lv_doc_status            TYPE string,
          lv_error_response        TYPE string,
          lv_govt_response         TYPE string,
          lv_success               TYPE c,
          lv_ackno                 TYPE string,
          lv_ackdt(19)             TYPE c,
          lv_irn                   TYPE string,
          lv_ewaybill_irn          TYPE string,
          lv_ewbdt                 TYPE string,
          lv_status                TYPE string,
          lv_cancldt               TYPE string,
          lv_valid_till            TYPE string,
          lv_signedinvoice         TYPE string,
          lv_signedqrcode          TYPE string.

    DATA: wa_zsdt_invrefnum TYPE zei_invrefnum,
          lt_irn            TYPE STANDARD TABLE OF zei_invrefnum,
          ls_irn            TYPE zei_invrefnum,
          wa_zsdt_ewaybill  TYPE zew_ewaybill,
          wa_ztsd_ew_log    TYPE ztsd_ew_log.

    DATA : lv_no(16) TYPE c.

    DATA : v1(20)    TYPE c,
           v2(20)    TYPE c,
           lv_date   TYPE d,
           lv_time   TYPE t,
           lv_cancel TYPE c.

    DATA: lv_vbeln(10) TYPE c.

    METHODS:
      create_eway_with_irn IMPORTING im_vbeln TYPE zchar,
      create_eway_without_irn.

    METHODS: generate_eway
      IMPORTING im_vbeln       TYPE zchar
      EXPORTING ex_response    TYPE string
                ex_status      TYPE c
                es_error_log   TYPE ztsd_ew_log
                es_ew_ewaybill TYPE zew_ewaybill.

    METHODS: cancel_eway
      IMPORTING im_vbeln       TYPE zchar
      EXPORTING ex_response    TYPE string
                ex_status      TYPE c
                es_error_log   TYPE ztsd_ew_log
                es_ew_ewaybill TYPE zew_ewaybill..

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EXPOUNDTAX_EWAYBILL IMPLEMENTATION.


  METHOD cancel_eway.

    DATA : cancelrsncode TYPE string  VALUE '1',
           cancelrmrk    TYPE string  VALUE 'DATA_ENTRY_MISTAKE',
           ewbno(12)     TYPE c,
           lv_ewbnumber  TYPE string.

    lv_vbeln = im_vbeln.

    CLEAR : lv_date.

    READ ENTITY i_billingdocumenttp
       ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
       RESULT FINAL(billingheader)
       FAILED FINAL(failed_data1).

    READ ENTITY i_billingdocumenttp
    BY \_item
    ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
    RESULT FINAL(billingdata)
    FAILED FINAL(failed_data).

    DATA : lv_werks TYPE i_plant-plant.
    READ TABLE billingdata INTO DATA(wa_data_n) INDEX 1.
    IF sy-subrc = 0.
      lv_werks = wa_data_n-plant.

      READ TABLE billingheader INTO DATA(wa_head) WITH KEY billingdocument =  wa_data_n-billingdocument.
      IF sy-subrc = 0.

        SELECT SINGLE businessplace
        FROM i_in_plantbusinessplacedetail
        WHERE companycode = @wa_head-companycode AND
              plant       = @lv_werks
        INTO @DATA(lv_businessplace).

        SELECT SINGLE in_gstidentificationnumber
        FROM i_in_businessplacetaxdetail
        WHERE businessplace = @lv_businessplace AND
              companycode   = @wa_head-companycode
        INTO @DATA(lv_sellergstin).

        lv_gstin = lv_sellergstin.

        CLEAR : gv_gstin, gv_username, gv_token.
        SELECT SINGLE * FROM zei_api_url WHERE method = 'CAN_EWB' AND param1 = @lv_gstin INTO @DATA(ls_api_url). "#EC CI_ALL_FIELDS_NEEDED
        IF sy-subrc = 0.
          gv_gstin    = ls_api_url-param1.
          gv_username = ls_api_url-param2.
          gv_token    = |Token { ls_api_url-param3 }|.

        ENDIF.

      ENDIF..
    ENDIF.

    SELECT * FROM zew_ewaybill
      WHERE docno = @lv_vbeln
      AND   status IN ('A', 'P')
      INTO TABLE @DATA(it_zsdt_ewaybill).
    IF it_zsdt_ewaybill[] IS NOT INITIAL.
      SORT it_zsdt_ewaybill BY egen_dat DESCENDING egen_time DESCENDING.
      READ TABLE it_zsdt_ewaybill INTO DATA(wa_zsdt_ewaybill) INDEX 1.

      CONCATENATE '{"ewbNo":"' wa_zsdt_ewaybill-ebillno '",'
                   '"cancelRsnCode":"' cancelrsncode '",'
                   '"cancelRmrk":"' cancelrmrk '"}'
                   INTO json.


**      " Create HTTP client
      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                   comm_scenario  = 'ZCOMM_TO_CANCEL_EWAY'
                                       service_id     = 'ZEXPTAX_EWAY_CANCEL1_REST'
                                 ).

          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).

          lo_request->set_header_field( i_name  = 'Content-Type'
                                        i_value = gv_contenttype ).

          lo_request->set_header_field( i_name  = 'Authorization'
                                        i_value = gv_token ).

          lo_request->set_header_field( i_name  = 'username'
                                        i_value = gv_username ).

          lo_request->set_header_field( i_name  = 'gstin'
                                        i_value = gv_gstin ).

          lv_content_length_value = strlen( json ).
          lo_request->set_text( i_text = json
                                i_length = lv_content_length_value ).

          DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
*        DATA(lv_xml) = lo_response->get_text( ).
          lv_xml_result_str = lo_response->get_text( ).
          lv_response = lv_xml_result_str.

          "capture response
          SELECT SINGLE FROM i_billingdocument
          FIELDS companycode, billingdocumentdate, billingdocumenttype
          WHERE billingdocument = @lv_vbeln
          INTO @DATA(ls_billdoc).

          CLEAR: wa_ztsd_ew_log.
          wa_ztsd_ew_log-bukrs    = ls_billdoc-companycode.
          wa_ztsd_ew_log-docno    = lv_vbeln.
          wa_ztsd_ew_log-doc_year = ls_billdoc-billingdocumentdate+0(4).
          wa_ztsd_ew_log-doc_type = ls_billdoc-billingdocumenttype.
          wa_ztsd_ew_log-method   = 'CANCEL_EWAY'.
          wa_ztsd_ew_log-erdat    = sy-datlo.
          wa_ztsd_ew_log-uzeit    = sy-timlo.
          wa_ztsd_ew_log-message  = lv_xml_result_str.

          DATA : str TYPE string.
          SPLIT lv_xml_result_str AT '"ewbStatus":"'           INTO str lv_status.
          SPLIT lv_xml_result_str AT '"ewayBillNo":'           INTO str lv_ewbnumber.
          SPLIT lv_ewbnumber      AT '"'                       INTO lv_ewbnumber str.
          SPLIT lv_xml_result_str AT 'cancelDate":"'           INTO str lv_cancldt.
          SPLIT lv_cancldt        AT '"'                       INTO lv_cancldt str. .

          IF  lv_cancldt IS NOT INITIAL.
            lv_status = 'Y'.
          ENDIF.

          IF lv_status = 'Y'.
            wa_zsdt_ewaybill-bukrs    = ls_billdoc-companycode.
            wa_zsdt_ewaybill-docno    = lv_vbeln.
            wa_zsdt_ewaybill-gjahr    = ls_billdoc-billingdocumentdate+0(4).
            wa_zsdt_ewaybill-ecan_dat    = sy-datum.
            wa_zsdt_ewaybill-ecan_time = sy-uzeit.
            wa_ztsd_ew_log-status  = 'E-Waybill Cancelled Successfully'.
            lv_response            = 'E-Waybill Cancelled Successfully'.
            lv_stat                = 'S'.
            wa_zsdt_ewaybill-status   = 'C'.
          ELSE.
            lv_stat = 'E'.
            wa_ztsd_ew_log-status  = 'Error While Generating IRN. Please Check Response inside record'.
          ENDIF.

        CATCH cx_root INTO DATA(lx_exception).
*        out->write( lx_exception->get_text( ) ).
          DATA(lvtxt) = lx_exception->get_text( ).
          lv_response = lvtxt.
      ENDTRY.
    ENDIF.

    es_ew_ewaybill = wa_zsdt_ewaybill.
    ex_response    = lv_response.
    ex_status      = lv_stat.
    es_error_log   = wa_ztsd_ew_log.

  ENDMETHOD.


  METHOD create_eway_without_irn.

  ENDMETHOD.


  METHOD create_eway_with_irn.

    DATA : lv_date(10) TYPE c.

    lv_vbeln = im_vbeln.

    CLEAR : lv_date.
    SELECT SINGLE *
    FROM zr_ewb_trans_dtls
    WHERE billingdocument = @im_vbeln
    INTO @DATA(wa_trans_dtls).

    READ ENTITY i_billingdocumenttp
       ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
       RESULT FINAL(billingheader)
       FAILED FINAL(failed_data1).

    READ ENTITY i_billingdocumenttp
    BY \_item
    ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
    RESULT FINAL(billingdata)
    FAILED FINAL(failed_data).

    DATA : lv_werks TYPE i_plant-plant.
    READ TABLE billingdata INTO DATA(wa_data_n) INDEX 1.
    IF sy-subrc = 0.
      lv_werks = wa_data_n-plant.

      READ TABLE billingheader INTO DATA(wa_head) WITH KEY billingdocument =  wa_data_n-billingdocument.
      IF sy-subrc = 0.

        SELECT SINGLE businessplace
        FROM i_in_plantbusinessplacedetail
        WHERE companycode = @wa_head-companycode AND
              plant       = @lv_werks
        INTO @DATA(lv_businessplace).

        SELECT SINGLE in_gstidentificationnumber
        FROM i_in_businessplacetaxdetail
        WHERE businessplace = @lv_businessplace AND
              companycode   = @wa_head-companycode
        INTO @DATA(lv_sellergstin).

        lv_gstin = lv_sellergstin.

        CLEAR : gv_gstin, gv_username, gv_token.
        SELECT SINGLE * FROM zei_api_url WHERE method = 'GEN_EWB' AND param1 = @lv_gstin INTO @DATA(ls_api_url). "#EC CI_ALL_FIELDS_NEEDED
        IF sy-subrc = 0.
          gv_gstin    = ls_api_url-param1.
          gv_username = ls_api_url-param2.
          gv_token    = |Token { ls_api_url-param3 }|.

        ENDIF.

      ENDIF..
    ENDIF.

    IF sy-subrc = 0.
      wa_data-transid    = wa_trans_dtls-transid.
      wa_data-transname  = wa_trans_dtls-transnm.
      wa_data-vehno      = wa_trans_dtls-vehno.

      IF  wa_trans_dtls-vehtype IS NOT INITIAL.

        wa_data-vehtype    = wa_trans_dtls-vehtype+0(1).

        IF wa_data-vehtype+0(1) = 'R'.
          wa_data-transmode = '1'.
        ELSE.
          wa_data-transmode = '2'.
        ENDIF.

      ENDIF.

      IF wa_data-vehtype <> 'R'.
        CLEAR : wa_data-vehno.
      ENDIF.

      wa_data-transdocno = wa_trans_dtls-lrno.
      wa_data-irn        = ls_irn-irn.

      TRANSLATE wa_data-vehno TO UPPER CASE.

      IF  wa_trans_dtls-lrdate IS NOT INITIAL.
        lv_date = wa_trans_dtls-lrdate+6(2) && '/' &&
                  wa_trans_dtls-lrdate+4(2) && '/' &&
                  wa_trans_dtls-lrdate+0(4).
        wa_data-transdocdt = lv_date.
      ELSE.
        CLEAR :  wa_data-transdocdt.
      ENDIF.

      DATA: lv_address_id TYPE i_plant-addressid,
            ls_orgaddress TYPE z_i_address_2.

      DATA: lv_from_pin TYPE string,
            lv_to_pin   TYPE string.

      SELECT SINGLE addressid
      FROM i_plant
      WHERE plant = @lv_werks
      INTO @lv_address_id.

      IF sy-subrc = 0.
        SELECT SINGLE *
        FROM z_i_address_2
        WHERE addressid = @lv_address_id
        INTO @ls_orgaddress.
      ENDIF.

      " FROM PIN → Plant / Dispatch (same as seller)
      lv_from_pin = ls_orgaddress-postalcode.   " <-- fetch like in E-Invoice

      DATA: lv_ship     TYPE i_customer-customer.

      SELECT SINGLE customer
      FROM i_billingdocumentpartner
      WHERE billingdocument = @wa_data_n-billingdocument
      AND partnerfunction = 'RE'
      INTO @lv_ship.

      IF sy-subrc = 0.
        SELECT SINGLE *
        FROM i_customer
        WHERE customer = @lv_ship
        INTO @DATA(ls_cust).

        IF ls_cust-postalcode IS NOT INITIAL.
          lv_to_pin = ls_cust-postalcode. " override buyer
        ENDIF.
      ENDIF.

      IF lv_from_pin IS NOT INITIAL AND lv_to_pin IS NOT INITIAL.

        IF lv_from_pin = lv_to_pin.
          wa_data-distance = 10.
          CONDENSE wa_data-distance NO-GAPS.
        ELSE.
          wa_data-distance = 0.
          CONDENSE wa_data-distance NO-GAPS.
        ENDIF.

      ELSE.
        wa_data-distance = 0. " safe fallback
        CONDENSE wa_data-distance NO-GAPS.
      ENDIF.

      APPEND wa_data TO it_data.

      DATA : lt_mapping  TYPE /ui2/cl_json=>name_mappings.

      lt_mapping = VALUE #(
    ( abap = 'IRN'        json = 'Irn' )
    ( abap = 'DISTANCE'   json = 'Distance' )
    ( abap = 'TRANSMODE'  json = 'TransMode' )
    ( abap = 'TRANSID'    json = 'TransId' )
    ( abap = 'TRANSNAME'  json = 'TransName' )
    ( abap = 'TRANSDOCDT' json = 'TransDocDt' )
    ( abap = 'TRANSDOCNO' json = 'TransDocNo' )
    ( abap = 'VEHNO'      json = 'VehNo' )
    ( abap = 'VEHTYPE'    json = 'VehType' )

    ).

      DATA(lv_json) = /ui2/cl_json=>serialize( data          = it_data
                                               compress      = abap_false
                                               pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                               name_mappings = lt_mapping ).

      REPLACE ALL OCCURRENCES OF '['               IN lv_json WITH space.
      REPLACE ALL OCCURRENCES OF ']'               IN lv_json WITH space.
      REPLACE ALL OCCURRENCES OF '""'              IN lv_json WITH 'null'.
      REPLACE ALL OCCURRENCES OF ':0*'             IN lv_json WITH ':null*'.
      REPLACE ALL OCCURRENCES OF '":0,'            IN lv_json WITH '":null,'.
      REPLACE ALL OCCURRENCES OF '":"0.00",'       IN lv_json WITH '":null,'.
      REPLACE ALL OCCURRENCES OF '"Distance":null' IN lv_json WITH 'Distance:0'.
      REPLACE ALL OCCURRENCES OF '"Distance":"0"'  IN lv_json WITH '"Distance":0'.
      REPLACE ALL OCCURRENCES OF '"Distance":"1"'  IN lv_json WITH 'Distance:null'.

      json = lv_json.

      " Create HTTP client
      TRY.
          DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                   comm_scenario      = 'ZCOMM_TO_CREATE_EWAY'
                                       service_id     = 'ZEXPTAX_CREATE_EWAY_REST'
                                 ).

          DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
          DATA(lo_request) = lo_http_client->get_http_request( ).


          lo_request->set_header_field( i_name  = 'Content-Type'
                                        i_value = gv_contenttype ).

          lo_request->set_header_field( i_name  = 'Authorization'
                                        i_value = gv_token ).

          lo_request->set_header_field( i_name  = 'username'
                                        i_value = gv_username ).

          lo_request->set_header_field( i_name  = 'gstin'
                                        i_value = gv_gstin ).

          lv_content_length_value = strlen( json ).

          lo_request->set_text( i_text = json
                                i_length = lv_content_length_value ).

          DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
          lv_xml_result_str = lo_response->get_text( ).
          lv_response = lv_xml_result_str.

          "capture response
          SELECT SINGLE FROM i_billingdocument
          FIELDS companycode, billingdocumentdate, billingdocumenttype
          WHERE billingdocument = @lv_vbeln
          INTO @DATA(ls_billdoc).
          IF sy-subrc = 0.
            CLEAR: wa_ztsd_ew_log.
            wa_ztsd_ew_log-bukrs    = ls_billdoc-companycode.
            wa_ztsd_ew_log-docno    = lv_vbeln.
            wa_ztsd_ew_log-doc_year = ls_billdoc-billingdocumentdate+0(4).
            wa_ztsd_ew_log-doc_type = ls_billdoc-billingdocumenttype.
            wa_ztsd_ew_log-method   = 'GENERATE_EWAY'.
            wa_ztsd_ew_log-erdat    = sy-datlo. "sy-datum.
            wa_ztsd_ew_log-uzeit    = sy-timlo. "sy-uzeit.
            wa_ztsd_ew_log-message  = lv_xml_result_str.
          ENDIF.

          "CAPTURE RESPONSE
          DATA : str TYPE string.
          SPLIT lv_xml_result_str AT '"document_status":"'   INTO str lv_doc_status.
          SPLIT lv_xml_result_str AT '"error_response":'     INTO str lv_error_response.
          SPLIT lv_xml_result_str AT '"govt_response":'      INTO str lv_govt_response.
          SPLIT lv_xml_result_str AT '"Success":"'           INTO str lv_success.

          SPLIT lv_xml_result_str AT '"AckNo":'              INTO str lv_ackno.
          SPLIT lv_ackno AT ','                              INTO lv_ackno str .

          SPLIT lv_xml_result_str AT '"AckDt":"'             INTO str lv_ackdt.

          SPLIT lv_xml_result_str AT '"Irn":"'               INTO str lv_irn.
          SPLIT lv_irn AT '"'                                INTO lv_irn str.

          SPLIT lv_xml_result_str AT '"EwbNo":'              INTO str lv_ewaybill_irn.
          SPLIT lv_ewaybill_irn  AT ','                      INTO lv_ewaybill_irn str .

          SPLIT lv_xml_result_str AT 'EwbDt":"'              INTO str lv_ewbdt.
          SPLIT lv_ewbdt AT '"'                              INTO lv_ewbdt str .

          SPLIT lv_xml_result_str AT '"status":"'            INTO str lv_status.

          SPLIT lv_xml_result_str AT '"EwbValidTill":"'      INTO str lv_valid_till.
          SPLIT lv_valid_till AT '"'                         INTO lv_valid_till str .

          IF lv_ewaybill_irn IS NOT INITIAL.
            lv_success = 'Y'.
          ENDIF.

          IF  lv_ewaybill_irn IS NOT INITIAL.
            CLEAR wa_zsdt_ewaybill.
            wa_zsdt_ewaybill-bukrs     = ls_billdoc-companycode.
            wa_zsdt_ewaybill-doc_type  = ls_billdoc-billingdocumenttype.
            wa_zsdt_ewaybill-docno     = lv_vbeln.

            wa_zsdt_ewaybill-gjahr = ls_billdoc-billingdocumentdate+0(4).
            wa_zsdt_ewaybill-ebillno = lv_ewaybill_irn."gs_resp_post_topaz-response-ewbno.

            REPLACE ALL OCCURRENCES OF '-' IN lv_ewbdt WITH space.
            CONDENSE lv_ewbdt.
            wa_zsdt_ewaybill-egen_dat = lv_ewbdt(8).

            REPLACE ALL OCCURRENCES OF ':' IN lv_ewbdt WITH space.
            CONDENSE lv_ewbdt.
            wa_zsdt_ewaybill-egen_time = lv_ewbdt+9(6).

            wa_zsdt_ewaybill-vdfmdate = wa_zsdt_ewaybill-egen_dat.
            wa_zsdt_ewaybill-vdfmtime = wa_zsdt_ewaybill-egen_time.

            IF wa_zsdt_ewaybill-egen_dat IS INITIAL.
              wa_zsdt_ewaybill-egen_dat = sy-datlo. "sy-datum.
            ENDIF.
            IF wa_zsdt_ewaybill-egen_time IS INITIAL.
              wa_zsdt_ewaybill-egen_time = sy-timlo. "sy-UZeIT.
            ENDIF.

            REPLACE ALL OCCURRENCES OF '-' IN lv_valid_till WITH space.
            CONDENSE lv_valid_till.

            REPLACE ALL OCCURRENCES OF ':' IN lv_valid_till WITH space.
            CONDENSE lv_valid_till.

            IF lv_valid_till IS NOT INITIAL.
              wa_zsdt_ewaybill-vdtodate  = lv_valid_till(8).
              wa_zsdt_ewaybill-vdtotime  = lv_valid_till+9(6).
            ENDIF.

            wa_zsdt_ewaybill-status = 'A'.
            wa_zsdt_ewaybill-ernam  = sy-uname.

            CLEAR: wa_data.
            lv_stat = 'S'.
            wa_ztsd_ew_log-status  = 'E-Waybill Generated Successfully'.
            lv_response            = 'E-Waybill Generated Successfully'.
          ELSE.
            lv_stat = 'E'.
            wa_ztsd_ew_log-status  = 'Error While Generating E-Waybill. Please Check Response inside record'.
          ENDIF.

        CATCH cx_root INTO DATA(lx_exception).
          DATA(lvtxt) = lx_exception->get_text( ).
          lv_response = lvtxt.
      ENDTRY.
    ENDIF..

  ENDMETHOD.


  METHOD generate_eway.

    lv_vbeln    = im_vbeln.

    SELECT SINGLE * FROM i_billingdocument
    WHERE billingdocument = @lv_vbeln
    INTO @wa_vbrk.

    IF sy-subrc = 0.

      SELECT * FROM zei_invrefnum
      WHERE docno = @lv_vbeln
      INTO TABLE @lt_irn.
      IF lt_irn[] IS NOT INITIAL.
        SORT lt_irn BY docno ASCENDING version DESCENDING.
      ENDIF.

      SELECT * FROM zew_ewaybill
      WHERE  docno = @lv_vbeln
      INTO TABLE @DATA(lt_eway).
      IF lt_eway[] IS NOT INITIAL.
        SORT lt_eway BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
      ENDIF.

      READ TABLE lt_eway INTO DATA(ls_eway) WITH KEY docno = lv_vbeln.
      IF sy-subrc NE 0 OR ( sy-subrc = 0 AND ls_eway-status = 'C' ).

        READ TABLE lt_irn INTO ls_irn WITH KEY docno = lv_vbeln BINARY SEARCH.
        IF ( sy-subrc = 0 AND ls_irn-irn IS NOT INITIAL AND ls_irn-irn_status EQ 'ACT' ).

          CALL METHOD create_eway_with_irn( im_vbeln ).

        ELSEIF ( sy-subrc NE 0 ).

          CALL METHOD create_eway_without_irn.

        ENDIF.
      ENDIF.
    ENDIF.

    ex_response    = lv_response.
    ex_status      = lv_stat.
    es_ew_ewaybill = wa_zsdt_ewaybill.
    es_error_log   = wa_ztsd_ew_log.

  ENDMETHOD.
ENDCLASS.
