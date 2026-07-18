CLASS zcl_expoundtax_einvvoice_fi DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA : json TYPE string.
    DATA : it_trans            TYPE STANDARD TABLE OF zdst_eway_fi,
           wa_tran             TYPE zdst_eway_fi,
           wa_transaction      TYPE zdst_eway_fi,
           wa_trandtls         TYPE zei_trandtls_st1,
           wa_docdtls          TYPE zei_docdtls_st,
           wa_sellerdtls       TYPE zei_sellerdtls_st1,
           wa_buyerdtls        TYPE zei_buyerdtls_st1,
           wa_dispdtls         TYPE zei_dispdtls_st,
           wa_shipdtls         TYPE zei_shipdtls_st1,
           itemlist            TYPE zei_item_fi_tt,
           wa_itemlist         TYPE zei_itemlist_st1,
           wa_valdtls          TYPE zei_valdtls_st1,
           wa_refdtls          TYPE zei_refdtls_st,
           addldocdtls         TYPE zei_addldocdtls_tt,
           wa_addldocdtls      TYPE zei_addldocdtls_st,
           wa_expdtls          TYPE zei_expdtls_st,
           wa_ewbdtls          TYPE zei_ewbdtls_st,
           gv_gstin_seller(18) TYPE c.
    DATA : gv_disp TYPE c,
           gv_ship TYPE c.
    DATA : lv_buyer       TYPE i_customer-customer,
           lv_soldtoparty TYPE i_customer-customer,
           wa_vbrk        TYPE zc_je_customerlineitem,
*           i_billingdocument,
           lv_acc_ass_grp TYPE i_productsalesdelivery-accountdetnproductgroup.
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
          lv_signedinvoice         TYPE string,
          lv_signedqrcode          TYPE string,
          lv_status                TYPE string.

    DATA:  wa_zsdt_invrefnum        TYPE zei_invrefnum.

    TYPES: BEGIN OF ty_response_auth,
             custom_fields(100)   TYPE c,
             deleted(100)         TYPE c,
             document_status(100) TYPE c,
             error_response(100)  TYPE c,
             govt_response(100)   TYPE c,
             ackno(100)           TYPE c,
             ackdt(100)           TYPE c,
             irn(100)             TYPE c,
             signedinvoice        TYPE xstring,
             signedqrcode         TYPE xstring,
           END OF ty_response_auth.

    DATA : gs_resp_auth   TYPE ty_response_auth,
           wa_ztsd_ei_log TYPE ztsd_ei_log.

    DATA: lv_no(16) TYPE c.
    DATA : v1(20)    TYPE c,
           v2(20)    TYPE c,
           lv_date   TYPE d,
           lv_time   TYPE t,
           lv_cancel TYPE c.
    DATA : gv_exp TYPE c.

    DATA: lv_vbeln(10) TYPE c.
    DATA : lv_year(4) TYPE n.

    DATA : lv_num(5)    TYPE n,
           lv_unit_pr   TYPE i_billingdocumentitembasic-netamount,
           lv_disc      TYPE i_billingdocumentbasic-billingdocument,
           lv_freight   TYPE i_billingdocumentbasic-totalnetamount,
           lv_ins       TYPE i_billingdocumentbasic-totalnetamount,
           lv_asse_val  TYPE i_billingdocumentbasic-totalnetamount,
           lv_asse_val1 TYPE i_billingdocumentbasic-totalnetamount,
           lv_igst      TYPE i_billingdocumentbasic-totalnetamount,
           lv_round     TYPE i_billingdocumentbasic-totalnetamount,
           lv_cgst      TYPE i_billingdocumentbasic-totalnetamount,
           lv_sgst      TYPE i_billingdocumentbasic-totalnetamount,
           lv_igst_rt   TYPE i_billingdocumentitemprcgelmnt-conditionamount,
           lv_cgst_rt   TYPE i_billingdocumentitemprcgelmnt-conditionamount,
           lv_sgst_rt   TYPE i_billingdocumentitemprcgelmnt-conditionamount,
           lv_other_ch  TYPE i_billingdocumentitemprcgelmnt-conditionamount.
    DATA: lv_meins TYPE string.

    DATA : lv_tot_val      TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_disc     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_freight  TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_ins      TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_roff     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_asse_val TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_igst     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_cgst     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_sgst     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_other    TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_rndof    TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_rndof_i  TYPE i_billingdocumentbasic-totalnetamount.

    DATA : lv_state_cd(2) TYPE c.
    DATA : ls_error_log TYPE ztsd_ei_log.

    DATA : gv_gstin       TYPE string,
           gv_contenttype TYPE string VALUE 'application/json',
           gv_username    TYPE string,
           gv_token       TYPE string.

    METHODS: get_data_fi,
      create_json_fi,
      call_api_fi.

    METHODS: generate_irn_fi
      IMPORTING im_vbeln        TYPE zchar
                im_year         TYPE gjahr
      EXPORTING ex_response     TYPE string
                ex_status       TYPE c
                es_error_log    TYPE ztsd_ei_log
                es_ei_invrefnum TYPE zei_invrefnum.

    METHODS: cancel_irn_fi
      IMPORTING im_vbeln        TYPE zchar
                im_year         TYPE gjahr
      EXPORTING ex_response     TYPE string
                ex_status       TYPE c
                es_error_log    TYPE ztsd_ei_log
                es_ei_invrefnum TYPE zei_invrefnum..

    METHODS: download_json_fi
      IMPORTING im_vbeln        TYPE zchar
                im_year         TYPE gjahr
      EXPORTING ex_response     TYPE string
                ex_status       TYPE c
                es_error_log    TYPE ztsd_ei_log
                es_ei_invrefnum TYPE zei_invrefnum
                es_ei_json      TYPE ztsd_einv_json.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EXPOUNDTAX_EINVVOICE_FI IMPLEMENTATION.


  METHOD call_api_fi.

    " Create HTTP client
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario      = 'ZCOMM_TO_EXPOUNDTAX'
                                     service_id     = 'ZEXPTAX_IRN_GENERATE_REST'
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

*        SELECT SINGLE FROM i_billingdocument
*        FIELDS companycode, billingdocumentdate, billingdocumenttype
*        WHERE billingdocument = @lv_vbeln
*        INTO @DATA(ls_billdoc).

        SELECT SINGLE *
        FROM i_journalentry
        WHERE accountingdocument = @lv_vbeln
        INTO @DATA(ls_billdoc).

        CLEAR: wa_ztsd_ei_log.
        wa_ztsd_ei_log-bukrs    = ls_billdoc-companycode.
        wa_ztsd_ei_log-docno    = lv_vbeln.
        wa_ztsd_ei_log-doc_year = lv_year.
*        ls_billdoc-AccountingDocumentCreationDate+0(4).
        wa_ztsd_ei_log-doc_type = ls_billdoc-accountingdocumenttype.
        wa_ztsd_ei_log-method   = 'GENERATE_IRN'.
        wa_ztsd_ei_log-erdat    = sy-datlo. "sy-datum.
        wa_ztsd_ei_log-uzeit    = sy-timlo. "sy-uzeit.
        wa_ztsd_ei_log-message  = lv_xml_result_str.

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

        SPLIT lv_xml_result_str AT '"SignedInvoice":"'     INTO str lv_signedinvoice.
        SPLIT lv_signedinvoice  AT '"'                     INTO lv_signedinvoice str .

        SPLIT lv_xml_result_str AT '"SignedQRCode":"'      INTO str lv_signedqrcode.
        SPLIT lv_signedqrcode AT '"'                       INTO lv_signedqrcode str .

        SPLIT lv_xml_result_str AT '"Status":"'            INTO str lv_status.
        SPLIT lv_status AT ','                             INTO lv_status str.


        IF lv_irn IS NOT INITIAL.
          lv_success = 'Y'.
        ENDIF.

        IF lv_success EQ 'Y' .
          DATA : lv_count TYPE i.
          CLEAR wa_zsdt_invrefnum.

          SELECT COUNT( docno )  FROM zei_invrefnum
           WHERE docno      = @lv_vbeln
           INTO @DATA(lv_count_1).

          lv_count = lv_count_1 + 1.

          wa_zsdt_invrefnum-bukrs      = ls_billdoc-companycode.
          wa_zsdt_invrefnum-docno      = lv_vbeln.
          wa_zsdt_invrefnum-odn        = lv_vbeln.
          wa_zsdt_invrefnum-doc_year   = lv_year.
*          ls_billdoc-AccountingDocumentCreationDate+0(4). "e_fy.
          wa_zsdt_invrefnum-doc_type   = ls_billdoc-accountingdocumenttype.
          wa_zsdt_invrefnum-odn_date   = ls_billdoc-accountingdocumentcreationdate.
          wa_zsdt_invrefnum-irn        = lv_irn(64).
          wa_zsdt_invrefnum-version    = lv_count.
          wa_zsdt_invrefnum-ack_no     = lv_ackno.
          wa_zsdt_invrefnum-ack_date   = lv_ackdt.
          wa_zsdt_invrefnum-irn_status = 'ACT'.
          wa_zsdt_invrefnum-ernam      = sy-uname.
          wa_zsdt_invrefnum-erdat      = sy-datlo. "sy-datum.
          wa_zsdt_invrefnum-erzet      = sy-timlo. "sy-uzeit.
          wa_zsdt_invrefnum-signed_inv = lv_signedinvoice.
          wa_zsdt_invrefnum-signed_qrcode = lv_signedqrcode.

          wa_ztsd_ei_log-status  = 'IRN Generated Successfully'.
          lv_response            = 'IRN Generated Successfully'.
          CLEAR : wa_ztsd_ei_log-message.
          lv_stat = 'S'.
        ELSE.
          lv_stat = 'E'.
          wa_ztsd_ei_log-status  = 'Error While Generating IRN. Please Check Response inside record'.
        ENDIF.

      CATCH cx_root INTO DATA(lx_exception).
        DATA(lvtxt) = lx_exception->get_text( ).
        lv_response = lvtxt.
    ENDTRY.

  ENDMETHOD.


  METHOD cancel_irn_fi.

    lv_vbeln = im_vbeln.
    lv_year = im_year.

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
    READ TABLE billingdata INTO DATA(wa_data) INDEX 1.
    IF sy-subrc = 0.
      lv_werks = wa_data-plant.

      READ TABLE billingheader INTO DATA(wa_head) WITH KEY billingdocument =  wa_data-billingdocument.
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

      ENDIF..
    ENDIF.

    lv_gstin = lv_sellergstin.

    CLEAR : gv_gstin, gv_username, gv_token.
    SELECT SINGLE * FROM zei_api_url WHERE method = 'CAN_EINV' AND param1 = @lv_gstin INTO @DATA(ls_api_url).
    IF sy-subrc = 0.
      gv_gstin    = ls_api_url-param1.
      gv_username = ls_api_url-param2.
      gv_token    = |Token { ls_api_url-param3 }|.

      lv_vbeln = im_vbeln.

      SELECT SINGLE * FROM zc_je_customerlineitem
          WHERE accountingdocument = @lv_vbeln
          INTO @wa_vbrk.
      IF sy-subrc = 0.

        SELECT * FROM zei_invrefnum
        WHERE docno = @lv_vbeln
        INTO TABLE @DATA(lt_irn).
        IF lt_irn[] IS NOT INITIAL.
          SORT lt_irn BY docno ASCENDING version DESCENDING.
        ENDIF.

        READ TABLE lt_irn INTO DATA(ls_irn) WITH KEY docno = lv_vbeln BINARY SEARCH.
        IF sy-subrc = 0 AND ls_irn-irn IS NOT INITIAL. "AND LS_IRN-IRNSTATUS NE 'CAN'.

          CONCATENATE  '{"irn": "' ls_irn-irn '","CnlRsn": "2","CnlRem": "Wrong"}'
          INTO json.

          " Create HTTP client
          TRY.
              DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                       comm_scenario      = 'ZCOMM_TO_CANCEL_IRN'
                                           service_id     = 'ZEXPTAX_CANCELIRN_REST'
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

              DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post  ).

              lv_xml_result_str = lo_response->get_text( ).
              lv_response = lv_xml_result_str.

              "Capture Log
*              SELECT SINGLE FROM i_billingdocument
*              FIELDS companycode, billingdocumentdate, billingdocumenttype
*              WHERE billingdocument = @lv_vbeln
*              INTO @DATA(ls_billdoc).
              SELECT SINGLE *
        FROM i_journalentry
        WHERE accountingdocument = @lv_vbeln
        INTO @DATA(ls_billdoc).


              CLEAR: wa_ztsd_ei_log.
              wa_ztsd_ei_log-bukrs    = ls_billdoc-companycode.
              wa_ztsd_ei_log-docno    = lv_vbeln.
              wa_ztsd_ei_log-doc_year = lv_year.
*              ls_billdoc-AccountingDocumentCreationDate+0(4).
              wa_ztsd_ei_log-doc_type = ls_billdoc-accountingdocumenttype.
              wa_ztsd_ei_log-method   = 'CANCEL_IRN'.
              wa_ztsd_ei_log-erdat    = sy-datlo. "sy-datum.
              wa_ztsd_ei_log-uzeit    = sy-timlo. "sy-uzeit.
              wa_ztsd_ei_log-message  = lv_xml_result_str.

              "CAPTURE RESPONSE
              DATA : str TYPE string.
              CLEAR lv_success.

              SPLIT lv_xml_result_str AT '"CancelDate":"'             INTO str lv_ackdt.

              IF  lv_ackdt IS NOT INITIAL.
                lv_success = 'Y'.
              ENDIF.

              IF lv_success = 'Y'.

                DATA : lv_count TYPE i.
                CLEAR wa_zsdt_invrefnum.

                SELECT COUNT( docno )  FROM zei_invrefnum
                 WHERE docno      = @lv_vbeln
                 INTO @DATA(lv_count_1).

                lv_count = lv_count_1 + 1.


                wa_zsdt_invrefnum-irn_status = 'CAN'.
                wa_zsdt_invrefnum-ernam        = sy-uname.
                wa_zsdt_invrefnum-cancel_date  = sy-datlo. "sy-datum.

                ls_irn-irn_status = 'CAN'.
                ls_irn-cancel_date = lv_ackdt."gs_resp_canc_inr-response-canceldate.
                lv_stat = 'S'.
                wa_ztsd_ei_log-status  = 'IRN Cancelled Successfully'.
                lv_response            = 'IRN Cancelled Successfully'.
                CLEAR : wa_ztsd_ei_log-message.
                wa_zsdt_invrefnum      = ls_irn.
              ELSE.
                lv_stat = 'E'.
                wa_ztsd_ei_log-status  = 'Error While Cancelling IRN. Please Check Response inside record'.
              ENDIF.

            CATCH cx_root INTO DATA(lx_exception).
              DATA(lvtxt) = lx_exception->get_text( ).
              lv_response = lvtxt.
          ENDTRY.

        ENDIF.

      ENDIF.

    ELSE.
      lv_stat = 'E'.
      wa_ztsd_ei_log-status  = 'Please Maintain Cancellataion Details in ZEI_API_URL'.
    ENDIF.

    ex_response     = lv_response.
    ex_status       = lv_stat.
    es_error_log    = wa_ztsd_ei_log.
    es_ei_invrefnum = wa_zsdt_invrefnum.

  ENDMETHOD.


  METHOD create_json_fi.

    IF it_trans IS NOT INITIAL.
      DATA : lt_mapping  TYPE /ui2/cl_json=>name_mappings.
      lt_mapping = VALUE #(
                        ( abap = 'VERSION'     json = 'Version' )
*                        ( abap = 'IRN'         json = 'Irn' )
                        ( abap = 'TRANDTLS'    json = 'TranDtls' )
                        ( abap = 'DOCDTLS'     json = 'DocDtls' )
                        ( abap = 'SELLERDTLS'  json = 'SellerDtls' )
                        ( abap = 'BUYERDTLS'   json = 'BuyerDtls' )
*                        ( abap = 'DISPDTLS'    json = 'DispDtls' )
                        ( abap = 'SHIPDTLS'    json = 'ShipDtls' )
                        ( abap = 'ITEMLIST'    json = 'ItemList' )
                        ( abap = 'VALDTLS'     json = 'ValDtls' )
                        ( abap = 'PAYDTLS'     json = 'PayDtls' )
                        ( abap = 'REFDTLS'     json = 'RefDtls' )
                        ( abap = 'ADDLDOCDTLS' json = 'AddlDocDtls' )
                        ( abap = 'EXPDTLS'     json = 'ExpDtls' )
                        ( abap = 'EWBDTLS'     json = 'EwbDtls' )
                        ( abap = 'TAXSCH'      json = 'TaxSch' )
                        ( abap = 'SUPTYP'      json = 'SupTyp' )
                        ( abap = 'REGREV'      json = 'RegRev' )
                        ( abap = 'ECMGSTIN'    json = 'EcmGstin' )
                        ( abap = 'IGSTONINTRA' json = 'IgstOnIntra' )
                        ( abap = 'TYP'         json = 'Typ' )
                        ( abap = 'NO'          json = 'No' )
                        ( abap = 'DT'          json = 'Dt' )
                        ( abap = 'GSTIN'       json = 'Gstin' )
                        ( abap = 'LGLNM'       json = 'LglNm' )
                        ( abap = 'TRDNM'       json = 'TrdNm' )
                        ( abap = 'ADDR1'       json = 'Addr1' )
                        ( abap = 'ADDR2'       json = 'Addr2' )
                        ( abap = 'LOC'         json = 'Loc' )
                        ( abap = 'PIN'         json = 'Pin' )
                        ( abap = 'STCD'        json = 'Stcd' )
                        ( abap = 'PH'          json = 'Ph' )
                        ( abap = 'EM'          json = 'Em' )
                        ( abap = 'POS'         json = 'Pos' )
                        ( abap = 'NM'          json = 'Nm' )
                        ( abap = 'SLNO'        json = 'SlNo' )
                        ( abap = 'PRDDESC'     json = 'PrdDesc' )
                        ( abap = 'ISSERVC'     json = 'IsServc' )
                        ( abap = 'HSNCD'       json = 'HsnCd' )
                        ( abap = 'BARCDE'      json = 'Barcde' )
                        ( abap = 'QTY'         json = 'Qty' )
                        ( abap = 'FREEQTY'     json = 'FreeQty' )
                        ( abap = 'UNIT'        json = 'Unit' )
                        ( abap = 'UNITPRICE'   json = 'UnitPrice' )
                        ( abap = 'TOTAMT'      json = 'TotAmt' )
*                    ( abap = 'DISCOUNT' json = 'Discount' )
                        ( abap = 'PRETAXVAL'   json = 'PreTaxVal' )
                        ( abap = 'ASSAMT'      json = 'AssAmt' )
                        ( abap = 'GSTRT'       json = 'GstRt' )
                        ( abap = 'IGSTAMT'     json = 'IgstAmt' )
                        ( abap = 'CGSTAMT'     json = 'CgstAmt' )
                        ( abap = 'SGSTAMT'     json = 'SgstAmt' )
                        ( abap = 'CESRT'       json = 'CesRt' )
                        ( abap = 'CESAMT'      json = 'CesAmt' )
                        ( abap = 'CESNONADVLAMT' json = 'CesNonAdvlAmt' )
                        ( abap = 'STATECESRT'  json = 'StateCesRt' )
                        ( abap = 'STATECESAMT' json = 'StateCesAmt' )
                        ( abap = 'STATECESNONADVLAMT' json = 'StateCesNonAdvlAmt' )
*                    ( abap = 'OTHCHRG' json = 'OthChrg' )
                        ( abap = 'TOTITEMVAL' json = 'TotItemVal' )
                        ( abap = 'ORDLINEREF' json = 'OrdLineRef' )
                        ( abap = 'ORGCNTRY'   json = 'OrgCntry' )
                        ( abap = 'PRDSLNO'    json = 'PrdSlNo' )
                        ( abap = 'BCHDTLS'    json = 'BchDtls' )
                        ( abap = 'ATTRIBDTLS' json = 'AttribDtls' )
                        ( abap = 'EXPDT'      json = 'ExpDt' )
                        ( abap = 'WRDT'       json = 'WrDt' )
                        ( abap = 'VAL'        json = 'Val' )
                        ( abap = 'ASSVAL'     json = 'AssVal' )
                        ( abap = 'CGSTVAL'    json = 'CgstVal' )
                        ( abap = 'SGSTVAL'    json = 'SgstVal' )
                        ( abap = 'IGSTVAL'    json = 'IgstVal' )
                        ( abap = 'CESVAL'     json = 'CesVal' )
                        ( abap = 'STCESVAL'   json = 'StCesVal' )
                        ( abap = 'DISCOUNT'   json = 'Discount' )
                        ( abap = 'OTHCHRG'    json = 'OthChrg' )
                        ( abap = 'RNDOFFAMT'  json = 'RndOffAmt' )
                        ( abap = 'TOTINVVAL'  json = 'TotInvVal' )
                        ( abap = 'TOTINVVALFC' json = 'TotInvValFc' )
                        ( abap = 'ACCDET'      json = 'AccDet' )
                        ( abap = 'MODE'        json = 'Mode' )
                        ( abap = 'FININSBR'    json = 'FinInsBr' )
                        ( abap = 'PAYTERM'     json = 'PayTerm' )
                        ( abap = 'PAYINSTR'    json = 'PayInstr' )
                        ( abap = 'CRTRN'       json = 'CrTrn' )
                        ( abap = 'DIRDR'       json = 'DirDr' )
                        ( abap = 'CRDAY'       json = 'CrDay' )
                        ( abap = 'PAIDAMT'     json = 'PaidAmt' )
                        ( abap = 'PAYMTDUE'    json = 'PaymtDue' )
                        ( abap = 'INVRM'       json = 'InvRm' )
                        ( abap = 'DOCPERDDTLS' json = 'DocPerdDtls' )
                        ( abap = 'PRECDOCDTLS' json = 'PrecDocDtls' )
                        ( abap = 'CONTRDTLS'   json = 'ContrDtls' )
                        ( abap = 'INVSTDT'     json = 'InvStDt' )
                        ( abap = 'INVENDDT'    json = 'InvEndDt' )
                        ( abap = 'INVNO'       json = 'InvNo' )
                        ( abap = 'INVDT'       json = 'InvDt' )
                        ( abap = 'OTHREFNO'    json = 'OthRefNo' )
                        ( abap = 'RECADVREF'   json = 'RecAdvRef' )
                        ( abap = 'RECADVDT'    json = 'RecAdvDt' )
                        ( abap = 'TENDREFR'    json = 'TendRefr' )
                        ( abap = 'CONTRREFR'   json = 'ContrRefr' )
                        ( abap = 'EXTREFR'     json = 'ExtRefr' )
                        ( abap = 'PROJREFR'    json = 'ProjRefr' )
                        ( abap = 'POREFR'      json = 'PORefr' )
                        ( abap = 'POREFDT'     json = 'PORefDt' )
                        ( abap = 'URL'         json = 'Url' )
                        ( abap = 'DOCS'        json = 'Docs' )
                        ( abap = 'INFO'        json = 'Info' )
                        ( abap = 'SHIPBNO'     json = 'ShipBNo' )
                        ( abap = 'SHIPBDT'     json = 'ShipBDt' )
                        ( abap = 'PORT'        json = 'Port' )
                        ( abap = 'REFCLM'      json = 'RefClm' )
                        ( abap = 'FORCUR'      json = 'ForCur' )
                        ( abap = 'CNTCODE'     json = 'CntCode' )
                        ( abap = 'EXPDUTY'     json = 'ExpDuty' )
                        ( abap = 'TRANSID'     json = 'TransId' )
                        ( abap = 'TRANSNAME'   json = 'TransName' )
                        ( abap = 'TRANSMODE'   json = 'TransMode' )
                        ( abap = 'DISTANCE'    json = 'Distance' )
                        ( abap = 'TRANSDOCNO'  json = 'TransDocNo' )
                        ( abap = 'TRANSDOCDT'  json = 'TransDocDt' )
                        ( abap = 'VEHNO'       json = 'VehNo' )
                        ( abap = 'VEHTYPE'     json = 'VehType' )
                        ).


      READ TABLE it_trans INTO wa_tran INDEX 1.
      DATA(lv_json) = /ui2/cl_json=>serialize( data      = wa_tran
                                           compress      = abap_false
                                           pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                           name_mappings = lt_mapping ).

*      IF gv_disp = 'X'.
*        REPLACE ALL OCCURRENCES OF '"DispDtls":{"Nm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""},'
*        IN lv_json WITH ' '.
*      ENDIF.

*      REPLACE ALL OCCURRENCES OF '"BchDtls":{"Nm":"","ExpDt":"","WrDt":""},' IN lv_json WITH ' '.

*      IF gv_ship = 'X'.
*        REPLACE ALL OCCURRENCES OF '"ShipDtls":{"Gstin":"","LglNm":"","TrdNm":"","Addr1":"","Loc":"","Pin":0,"Stcd":""},'
*        IN lv_json WITH ''.
*      ENDIF.

      REPLACE ALL OCCURRENCES OF '""' IN lv_json WITH 'null'.
      REPLACE ALL OCCURRENCES OF '"Distance":null' IN lv_json WITH '"Distance":0'.
      REPLACE ALL OCCURRENCES OF '"Distance":"1"' IN lv_json WITH '"Distance":null'.
      REPLACE ALL OCCURRENCES OF '"Ph":0' IN lv_json WITH '"Ph":null'.

      IF wa_tran-trandtls-suptyp  = 'EXPWOP' OR wa_tran-trandtls-suptyp  = 'SEZWOP'.
        REPLACE ALL OCCURRENCES OF '"irt":null' IN lv_json WITH '"irt":"0.00"'.
      ENDIF.

      json = lv_json.
    ENDIF.

  ENDMETHOD.


  METHOD download_json_fi.

    DATA : lv_fname     TYPE string,
           wa_einv_json TYPE ztsd_einv_json.

    TYPES: BEGIN OF ty_jsontab,
             line(255),
           END OF ty_jsontab.

    DATA: lt_jsontab TYPE TABLE OF ty_jsontab,
          ls_jsontab TYPE ty_jsontab.
    DATA: lv_filename TYPE string,
          lv_path     TYPE string VALUE 'C:/desktop/',
          lv_fullpath TYPE string.

    lv_vbeln = im_vbeln.
    lv_year = im_year.

    SELECT SINGLE * FROM zc_je_customerlineitem
    WHERE accountingdocument = @lv_vbeln
     AND  fiscalyear = @lv_year
    INTO @wa_vbrk.

    IF sy-subrc = 0.

      SELECT * FROM zei_invrefnum
      WHERE docno = @lv_vbeln
      INTO TABLE @DATA(lt_irn).
      IF lt_irn[] IS NOT INITIAL.
        SORT lt_irn BY docno ASCENDING version DESCENDING.
      ENDIF.

      READ TABLE lt_irn INTO DATA(ls_irn) WITH KEY docno = lv_vbeln BINARY SEARCH.
      IF sy-subrc NE 0 OR ( sy-subrc = 0 AND ls_irn-irn IS NOT INITIAL
                        AND ls_irn-irn_status EQ 'CAN' ).

        CALL METHOD get_data_fi.
        CALL METHOD create_json_fi.

        IF  json IS NOT INITIAL.

          CONCATENATE 'C:/desktop/' lv_vbeln '.json' INTO lv_fname .
          SPLIT json AT '#' INTO TABLE lt_jsontab.

*          SELECT SINGLE FROM i_billingdocument
*          FIELDS companycode, billingdocumentdate, billingdocumenttype
*          WHERE billingdocument = @lv_vbeln
*          INTO @DATA(ls_billdoc).
          SELECT SINGLE *
        FROM i_journalentry
        WHERE accountingdocument = @lv_vbeln
        INTO @DATA(ls_billdoc).


          CLEAR: wa_einv_json.
          wa_einv_json-bukrs      = ls_billdoc-companycode.
          wa_einv_json-docno      = lv_vbeln.
          wa_einv_json-doc_year   = lv_year.
*          ls_billdoc-AccountingDocumentCreationDate+0(4).
          wa_einv_json-doc_type   = ls_billdoc-accountingdocumenttype.
          wa_einv_json-erdat      = sy-datlo. "sy-datum.
          wa_einv_json-uzeit      = sy-timlo. "sy-uzeit.
          wa_einv_json-einv_json  = json.

        ENDIF.

        es_ei_json = wa_einv_json.


      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD generate_irn_fi.
*   IM_VBELN

    lv_vbeln = im_vbeln.
    lv_year  = im_year.

    SELECT SINGLE * FROM zc_je_customerlineitem
    WHERE accountingdocument = @lv_vbeln
    AND   fiscalyear = @lv_year
    INTO @wa_vbrk.

    IF sy-subrc = 0.

      SELECT * FROM zei_invrefnum
      WHERE docno = @lv_vbeln
      INTO TABLE @DATA(lt_irn).
      IF lt_irn[] IS NOT INITIAL.
        SORT lt_irn BY docno ASCENDING version DESCENDING.
      ENDIF.

      READ TABLE lt_irn INTO DATA(ls_irn) WITH KEY docno = lv_vbeln BINARY SEARCH.
      IF sy-subrc NE 0 OR ( sy-subrc = 0 AND ls_irn-irn IS NOT INITIAL
                        AND ls_irn-irn_status EQ 'CAN' ).

        CALL METHOD get_data_fi.
        CALL METHOD create_json_fi.
        CALL METHOD call_api_fi.


      ENDIF.
    ENDIF.

    ex_response     = lv_response.
    ex_status       = lv_stat.
    es_error_log    = wa_ztsd_ei_log.
    es_ei_invrefnum = wa_zsdt_invrefnum.

  ENDMETHOD.


  METHOD get_data_fi.

    CLEAR lv_cancel.

*    READ ENTITY i_billingdocumenttp
*    ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
*    RESULT FINAL(billingheader)
*    FAILED FINAL(failed_data1).

    SELECT SINGLE *
        FROM i_journalentry
        WHERE accountingdocument = @lv_vbeln
        AND   fiscalyear = @lv_year
        INTO @DATA(ls_journalentry).

    SELECT *
        FROM i_journalentryitem
        WHERE accountingdocument = @lv_vbeln
        AND   fiscalyear = @lv_year
          AND sourceledger = '0L'
          AND ledger = '0L'
        INTO TABLE @DATA(billingdata).

    SELECT SINGLE *
        FROM i_operationalacctgdocitem
        WHERE accountingdocument = @ls_journalentry-accountingdocument
          AND financialaccounttype = 'D'
          AND   fiscalyear = @lv_year
        INTO @DATA(w_item).

    SELECT *
        FROM i_operationalacctgdocitem
        WHERE accountingdocument = @ls_journalentry-accountingdocument
        AND   fiscalyear = @lv_year
        AND financialaccounttype = 'S'
        INTO TABLE @DATA(billingdata1).

    SELECT SINGLE *
    FROM i_operationalacctgdocitem
    WHERE accountingdocument = @ls_journalentry-accountingdocument
    AND   fiscalyear = @lv_year
    AND financialaccounttype = 'S'
    INTO @DATA(lv_prof).


    SELECT SINGLE plant , companycode, businessplace
      FROM i_in_plantbusinessplacedetail
      WHERE businessplace = @w_item-businessplace
      INTO @DATA(lv_businessplace1).

*    READ ENTITY I_JournalEntryTP
*    ALL FIELDS WITH VALUE #( ( AccountingDocument = lv_vbeln ) )
*    RESULT FINAL(ls_journalentry)
*    FAILED FINAL(failed_data2).

*    READ ENTITY I_JournalEntryItemTP
*     ALL FIELDS WITH VALUE #( ( JournalEntry = lv_journalentry ) )
*     RESULT FINAL(lt_journalentryitem)
*     FAILED FINAL(failed_items).

*    READ ENTITY i_billingdocumenttp
*    BY \_item
*    ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
*    RESULT FINAL(billingdata)
*    FAILED FINAL(failed_data).


*    SELECT billingdocument, billingdocumentitem, conditiontype,
*           conditionrateamount, conditionamount, conditionratevalue
*    FROM i_billingdocitemprcgelmntbasic
*    FOR ALL ENTRIES IN @billingdata
*    WHERE billingdocument   = @billingdata-AccountingDocument
*    AND billingdocumentitem = @billingdata-AccountingDocumentItem
*    INTO TABLE @DATA(pricingdata).

    SELECT product, plant, consumptiontaxctrlcode
    FROM i_productplantbasic
    FOR ALL ENTRIES IN @billingdata
    WHERE product  = @billingdata-product
    AND plant      = @billingdata-plant
    INTO TABLE @DATA(productplantbasic).

    SELECT *                 "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_baserate
    INTO TABLE @DATA(it_baserate).

    SELECT *                  "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_bukrs
    INTO TABLE @DATA(it_bukrs).

    SELECT *                   "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_discount
    INTO TABLE @DATA(it_discount).

    SELECT *                  "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_gstrate
    INTO TABLE @DATA(it_gstrate).

    SELECT *                  "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_meins
    INTO TABLE @DATA(it_meins).

    SELECT *                  "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_othrchrg
    INTO TABLE @DATA(it_othrchrg).

    SELECT *                   "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_roundoff
    INTO TABLE @DATA(it_roundoff).

    SELECT *                  "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_state
    INTO TABLE @DATA(it_state).

    SELECT *                 "#EC CI_ALL_FIELDS_NEEDED
    FROM zei_api_url
    INTO TABLE @DATA(it_api_url).

    IF billingdata IS NOT INITIAL.
      SELECT partnerfunction, customer, addressid
      FROM i_salesorderpartner "I_SALESORDERITEMPARTNER
      FOR ALL ENTRIES IN @billingdata
      WHERE salesorder = @billingdata-salesdocument
      INTO TABLE @DATA(it_vbpa).

      IF it_vbpa[] IS INITIAL.

*       SELECT partnerfunction ,
*       customer ,
*       addressid
*      FROM I_BillingDocumentPartner "I_SALESORDERITEMPARTNER
*      FOR ALL ENTRIES IN @billingdata
*      WHERE billingdocument = @billingdata-BillingDocument
*      INTO TABLE @data(it_vbpa1).
*
*      it_vbpa[] = it_vbpa1[].

      ENDIF.

*      SELECT partnerfunction, customer, addressid
*      FROM i_creditmemoreqpartner
*      FOR ALL ENTRIES IN @billingdata
*      WHERE creditmemorequest = @billingdata-referencesddocument
*      INTO TABLE @DATA(it_vbpa_cr).
    ENDIF.
    CLEAR : it_trans[], itemlist[], addldocdtls[].
    CLEAR : wa_transaction, wa_trandtls, wa_docdtls, wa_sellerdtls,
            wa_buyerdtls, wa_dispdtls,wa_shipdtls, wa_itemlist, wa_valdtls,
            wa_refdtls, wa_addldocdtls, wa_expdtls, wa_ewbdtls.

    DATA : lv_werks TYPE i_plant-plant.
    READ TABLE billingdata INTO DATA(wa_data) INDEX 1.
    IF sy-subrc = 0.
      SELECT SINGLE *
        FROM i_customer
        WHERE customer = @wa_data-customer
        INTO @DATA(w_cust).

*      w_cust-Customer.
      SELECT SINGLE
        customer, addressid, customername, taxnumber3, country,
        streetname, cityname, postalcode, region, telephonenumber1
        FROM i_customer
        WHERE customer = @w_cust-customer
        INTO @DATA(wa_kna1).

      SELECT SINGLE * FROM i_organizationaddress      "#EC CI_ALL_FIELDS_NEEDED
      WITH PRIVILEGED ACCESS
      WHERE addressid = @wa_kna1-addressid
      INTO @DATA(gs_buyaddress10).

      lv_werks = lv_businessplace1-businessplace.

*      wa_data-plant.


*      READ TABLE ls_journalentry INTO DATA(wa_head) WITH KEY AccountingDocument =  wa_data-billingdocument.
*      IF sy-subrc = 0.
*      ENDIF..

*      SELECT SINGLE
*        plant,
*        plantname,
*        addressid
*        FROM i_plant
*        WHERE plant = @lv_werks
*        INTO @DATA(wa_t001w).
*
*      SELECT SINGLE businessplace
*      FROM i_in_plantbusinessplacedetail
*      WHERE companycode = @ls_journalentry-CompanyCode AND
*            plant       = @lv_werks
*      INTO @DATA(lv_businessplace).

      SELECT SINGLE in_gstidentificationnumber
      FROM i_in_businessplacetaxdetail
      WHERE businessplace = @lv_werks AND
            companycode   = @ls_journalentry-companycode
      INTO @DATA(lv_sellergstin).

      lv_gstin = lv_sellergstin.
      CLEAR : gv_gstin, gv_username, gv_token.
*      SELECT SINGLE * FROM zei_api_url WHERE method = 'GEN_EINV' AND param1 = @lv_gstin INTO @DATA(ls_api_url).
      DATA(ls_api_url) = VALUE #( it_api_url[ method = 'GEN_EINV' param1 = lv_gstin ] OPTIONAL ).
      IF sy-subrc = 0.
        gv_gstin    = ls_api_url-param1.
        gv_username = ls_api_url-param2.
        gv_token    = |Token { ls_api_url-param3 }|.


*--------------------------------------------------------------------*
        "Version
*--------------------------------------------------------------------*
        wa_transaction-version = '1.1'.
*--------------------------------------------------------------------*
        "TranDtls
*--------------------------------------------------------------------*
        wa_trandtls-taxsch       = 'GST'.
        wa_trandtls-regrev       = 'N'.
*        wa_trandtls-igstonintra  = 'N'.
*--------------------------------------------------------------------*
        "DOCDTLS
*--------------------------------------------------------------------*
        CASE wa_vbrk-accountingdocumenttype.
          WHEN 'F2'.
            wa_docdtls-typ           = 'INV'.
            wa_trandtls-suptyp       = 'B2B'.
          WHEN 'DG'.
            wa_docdtls-typ           = 'CRN'.
            wa_trandtls-suptyp       = 'B2B'.
          WHEN 'L2'.
            wa_docdtls-typ           = 'DBN'.
            wa_trandtls-suptyp       = 'B2B'.
          WHEN OTHERS.
            wa_docdtls-typ           = 'INV'.
            wa_trandtls-suptyp       = 'B2B'.
        ENDCASE.
*        wa_docdtls-typ           = 'CRN'.
        wa_docdtls-no            = lv_vbeln. "wa_vbrk-xblnr.
        SHIFT wa_docdtls-no LEFT DELETING LEADING '0'.

        CONCATENATE ls_journalentry-postingdate+6(2) ls_journalentry-postingdate+4(2)
                    ls_journalentry-postingdate+0(4) INTO wa_docdtls-dt SEPARATED BY '/'.
*--------------------------------------------------------------------*
        "SELLERDTLS
*--------------------------------------------------------------------*

        SELECT SINGLE *
        FROM i_profitcenter
        WHERE profitcenter = @lv_prof-profitcenter
        INTO @DATA(lv_profitcenter).

        lv_state_cd = VALUE #( it_state[ regio = lv_profitcenter-region ]-statecode OPTIONAL ).
        wa_sellerdtls-gstin = lv_sellergstin.
        wa_sellerdtls-lglnm = lv_profitcenter-profitctrresponsiblepersonname.
        wa_sellerdtls-trdnm = lv_profitcenter-profitctrresponsiblepersonname.
        wa_sellerdtls-addr1 = | { lv_profitcenter-streetaddressname }|.
*        wa_sellerdtls-addr2 = |{ gs_orgaddress-streetsuffixname1 } { gs_orgaddress-streetsuffixname2 } { gs_orgaddress-cityname } |.
        wa_sellerdtls-loc = lv_profitcenter-cityname.
        wa_sellerdtls-pin = lv_profitcenter-postalcode.
        CONDENSE lv_state_cd.
        wa_sellerdtls-stcd = lv_state_cd.

*--------------------------------------------------------------------*
        "DISPATCHDTLS
*--------------------------------------------------------------------*
*        wa_dispdtls-nm = gs_buyaddress1-addresseefullname.
*        wa_dispdtls-addr1 = |{ gs_buyaddress1-street }{ gs_buyaddress1-streetprefixname1 }{ gs_buyaddress1-streetprefixname2 }|.
*        wa_dispdtls-addr2 = |{ gs_buyaddress1-streetsuffixname1 } { gs_buyaddress1-streetsuffixname2 } { gs_buyaddress1-cityname }|.
*        wa_dispdtls-loc = gs_buyaddress1-cityname.
*        wa_dispdtls-pin = gs_buyaddress1-postalcode.
*        wa_dispdtls-stcd = lv_state_cd.

        CLEAR: lv_state_cd.
*--------------------------------------------------------------------*
        "BUYERDTLS
*--------------------------------------------------------------------*
        "BUYERDTLS
        READ TABLE it_vbpa INTO DATA(wa_vbpa) WITH  KEY partnerfunction = 'AG'.  ""Sold to party
        IF sy-subrc = 0.
          lv_soldtoparty = wa_vbpa-customer.
        ENDIF.

*        READ TABLE it_vbpa_cr INTO DATA(wa_vbpa_cr) WITH  KEY partnerfunction = 'AG'.  ""Sold to party
*        IF sy-subrc = 0.
*          lv_soldtoparty = wa_vbpa_cr-customer.
*        ENDIF.

        READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'RE'.  ""Buyer
        IF sy-subrc = 0.
          lv_buyer = wa_vbpa-customer.
        ELSE.
          lv_buyer = lv_soldtoparty.
        ENDIF.

*        READ TABLE it_vbpa_cr INTO wa_vbpa_cr WITH  KEY partnerfunction = 'RE'.  ""Buyer
*        IF sy-subrc = 0.
*          lv_buyer = wa_vbpa_cr-customer.
*        ELSE.
*          lv_buyer = lv_soldtoparty.
*        ENDIF.

        SELECT SINGLE
        customer, addressid, customername, taxnumber3, country,
        streetname, cityname, postalcode, region, telephonenumber1
        FROM i_customer
        WHERE customer = @w_item-customer
        INTO @DATA(wa_kna2).

        SELECT SINGLE * FROM i_organizationaddress
        WITH PRIVILEGED ACCESS
        WHERE addressid = @wa_kna2-addressid
        INTO @DATA(gs_buyaddress1).

        CLEAR gv_exp.
        IF wa_kna1-country NE 'IN'.
          gv_exp = 'X'.
          wa_expdtls-cntcode = gs_buyaddress1-country.
        ENDIF.

        wa_buyerdtls-gstin = wa_kna2-taxnumber3.
        wa_buyerdtls-loc   = gs_buyaddress1-cityname.
        wa_buyerdtls-pin   = gs_buyaddress1-postalcode.
        wa_buyerdtls-lglnm = gs_buyaddress1-addresseefullname.
        wa_buyerdtls-trdnm = gs_buyaddress1-addresseefullname.

        CLEAR: lv_state_cd.
        lv_state_cd = VALUE #( it_state[ regio = gs_buyaddress1-region ]-statecode OPTIONAL ).
        wa_buyerdtls-stcd = lv_state_cd.
        wa_buyerdtls-pos  = lv_state_cd.

        wa_buyerdtls-addr1 = | { gs_buyaddress1-streetname } { gs_buyaddress1-streetprefixname1 } { gs_buyaddress1-streetprefixname2 }|.
*        wa_buyerdtls-addr2 = |{ gs_buyaddress1-streetsuffixname1 } { gs_buyaddress1-streetsuffixname2 } { gs_buyaddress1-cityname }|.

        wa_shipdtls-gstin = wa_kna2-taxnumber3.
        wa_shipdtls-pin   = gs_buyaddress1-postalcode.
        wa_shipdtls-lglnm = gs_buyaddress1-addresseefullname.
        wa_shipdtls-trdnm = gs_buyaddress1-addresseefullname.
        wa_shipdtls-stcd = lv_state_cd.
        wa_shipdtls-loc =  gs_buyaddress1-cityname.
        wa_shipdtls-addr1 = | { gs_buyaddress1-streetname } { gs_buyaddress1-streetprefixname1 } { gs_buyaddress1-streetprefixname2 }|.
*--------------------------------------------------------------------*
        "SHIPDTLS
*--------------------------------------------------------------------*
        CLEAR : gv_disp, gv_ship.

        READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
        IF sy-subrc = 0 AND wa_vbpa-customer NE lv_buyer.

          SELECT SINGLE
          customer, addressid, customername, taxnumber3, country,
          streetname, cityname, postalcode, region, telephonenumber1
          FROM i_customer
          WHERE customer = @wa_vbpa-customer
          INTO @DATA(wa_kna1_sh)..

          SELECT SINGLE * FROM i_organizationaddress         "#EC CI_ALL_FIELDS_NEEDED
          WITH PRIVILEGED ACCESS
          WHERE addressid = @wa_kna1_sh-addressid
          INTO @DATA(gs_shpaddress).

          wa_shipdtls-gstin = wa_kna2-taxnumber3.
          wa_shipdtls-pin   = gs_buyaddress1-postalcode.
          wa_shipdtls-lglnm = gs_buyaddress1-addresseefullname.
          wa_shipdtls-trdnm = gs_buyaddress1-addresseefullname.
*          CLEAR: lv_state_cd.
*          lv_state_cd = VALUE #( it_state[ regio = wa_kna1_sh-region ]-statecode OPTIONAL ).

          wa_shipdtls-stcd = lv_state_cd.
          wa_shipdtls-loc =  gs_buyaddress1-cityname.
*          lv_state_cd.
          wa_shipdtls-addr1 = | { gs_buyaddress1-streetname } { gs_buyaddress1-streetprefixname1 } { gs_buyaddress1-streetprefixname2 }|.
*          wa_shipdtls-addr2 = |{ gs_shpaddress-streetsuffixname1 } { gs_shpaddress-streetsuffixname2 } { gs_shpaddress-cityname }|.
        ELSE.
          gv_ship = 'X'.
        ENDIF.

*        READ TABLE it_vbpa_cr INTO wa_vbpa_cr WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
*        IF sy-subrc = 0 AND wa_vbpa_cr-customer NE lv_buyer.
*
*          CLEAR gv_ship.
*          SELECT SINGLE
*          customer, addressid, customername, taxnumber3, country,
*          streetname, cityname, postalcode, region, telephonenumber1
*          FROM i_customer
*          WHERE customer = @wa_vbpa_cr-customer
*          INTO @wa_kna1_sh.
*
*          SELECT SINGLE * FROM i_organizationaddress
*          WITH PRIVILEGED ACCESS
*          WHERE addressid = @wa_kna1_sh-addressid
*          INTO @DATA(gs_shpaddresscr).
*
*          wa_shipdtls-gstin = wa_kna1_sh-taxnumber3.
*          wa_shipdtls-loc   = gs_shpaddresscr-cityname.
*          wa_shipdtls-pin   = gs_shpaddresscr-postalcode.
*          wa_shipdtls-lglnm = gs_shpaddresscr-addresseefullname.
*          wa_shipdtls-trdnm = gs_shpaddresscr-addresseefullname.
*
*          CLEAR: lv_state_cd.
*          lv_state_cd = VALUE #( it_state[ regio = gs_shpaddresscr-region ]-statecode OPTIONAL ).
*
*          wa_shipdtls-stcd = lv_state_cd.
*
*          wa_shipdtls-addr1 = |{ gs_shpaddresscr-streetname } { gs_shpaddresscr-streetprefixname1 } { gs_shpaddresscr-streetprefixname2 }|.
*          wa_shipdtls-addr2 = |{ gs_shpaddresscr-streetsuffixname1 } { gs_shpaddresscr-streetsuffixname2 } { gs_shpaddresscr-cityname }|.
*        ELSE.
*          gv_ship = 'X'.
*        ENDIF.

*        IF   wa_vbrk-distributionchannel = '20'
*          OR gv_exp = 'X'.
*          SELECT SINGLE conditiontype FROM i_billingdocumentprcgelmnt
*            WHERE billingdocument = @wa_data-billingdocument
*            AND   conditiontype IN ('JOCG','JOSG','JOIG','ZOIG','JOUG')
*            INTO @DATA(lv_kschl).
*          IF sy-subrc = 0.
*            wa_trandtls-suptyp   = 'EXPWP'.
*          ELSE.
*            wa_trandtls-suptyp   = 'EXPWOP'.
*          ENDIF.
*        ENDIF.

        IF gv_ship = ''.
          IF wa_trandtls-suptyp = 'EXPWP' OR wa_trandtls-suptyp = 'EXPWOP' OR gv_exp = 'X'.
            wa_shipdtls-stcd    = '96'.
            wa_shipdtls-pin     = '999999'.
          ENDIF.
        ENDIF.

        IF wa_trandtls-suptyp = 'EXPWP' OR wa_trandtls-suptyp  = 'EXPWOP' OR gv_exp = 'X'.
          wa_buyerdtls-gstin  = 'URP'.
          wa_buyerdtls-pos    = '96'.
          wa_buyerdtls-stcd   = '96'.
          wa_buyerdtls-pin    = '999999'.
        ENDIF.

*--------------------------------------------------------------------*
        "ITEMLIST
*--------------------------------------------------------------------*
        CLEAR : lv_tot_val, lv_tot_disc, lv_tot_freight, lv_tot_ins, lv_tot_roff, lv_tot_asse_val,
                lv_tot_igst, lv_tot_cgst, lv_tot_sgst, lv_tot_other, lv_tot_rndof, lv_tot_rndof_i.


        SORT billingdata1 BY taxitemgroup ASCENDING.
        DATA(billingdata2) = billingdata1.
        DATA(billingdata3) = billingdata1.
        DELETE billingdata3 WHERE in_hsnorsaccode = ''.
        SORT billingdata3 BY in_hsnorsaccode DESCENDING.
        DELETE ADJACENT DUPLICATES FROM billingdata2 COMPARING taxitemgroup.
        CLEAR lv_round.
        LOOP AT billingdata2 INTO DATA(wa_vbrp1).

          lv_num = lv_num + 1.
          wa_itemlist-slno        = lv_num.
          READ TABLE billingdata3 INTO DATA(w_bill2) INDEX 1.
          wa_itemlist-hsncd =  w_bill2-in_hsnorsaccode.
          IF wa_vbrk-accountingdocumenttype = 'DR'.
            wa_docdtls-typ           = 'DBN'.
          ENDIF.
          IF wa_itemlist-hsncd = '997212' AND wa_vbrk-accountingdocumenttype = 'DR'.
            wa_docdtls-typ           = 'INV'.
          ENDIF.

          wa_itemlist-qty = wa_vbrp1-quantity.
*          ENDIF.
          wa_itemlist-unit = wa_vbrp1-baseunit.

          IF  wa_itemlist-qty IS INITIAL.
            wa_itemlist-qty = '1.00'.
          ENDIF.
          IF  wa_itemlist-unit = 'EA'.
            wa_itemlist-unit = 'NOS'.
          ENDIF.
          IF  wa_itemlist-unit = ''.
            wa_itemlist-unit = 'NOS'.
          ENDIF.

          IF wa_vbrp1-glaccount = '0000450034'.
            lv_round =  wa_vbrp1-amountintransactioncurrency.
          ENDIF.
          LOOP AT billingdata1 INTO DATA(wa_vbrp) WHERE taxitemgroup = wa_vbrp1-taxitemgroup.

*
*          IF wa_vbrp-billingquantity IS INITIAL.
*            CONTINUE.
*          ENDIF.
*
*          CLEAR : lv_unit_pr, lv_disc, lv_freight, lv_asse_val, lv_asse_val1, lv_igst, lv_cgst, lv_sgst,
*                  lv_igst_rt, lv_cgst_rt, lv_sgst_rt, lv_other_ch, lv_ins, lv_tot_rndof_i.
*
**          SELECT SINGLE accountdetnproductgroup FROM i_productsalesdelivery
**          WHERE product = @wa_vbrp-product
**          AND   productsalesorg = @wa_vbrk-salesorganization
**          AND   productdistributionchnl = @wa_vbrk-distributionchannel
**          INTO @lv_acc_ass_grp.
*



*          if  wa_vbrp-AccountingDocumentItemType = 'T'.

           wa_itemlist-totamt = abs( wa_vbrp-taxbaseamountintranscrcy ).
           wa_itemlist-assamt = abs( wa_vbrp-taxbaseamountintranscrcy ).


            IF wa_vbrp-taxcode = 'F4'  OR wa_vbrp-taxcode = 'F3'.
              wa_itemlist-gstrt =  '18.00'.
            ELSEIF wa_vbrp-taxcode = 'O4' OR wa_vbrp-taxcode = 'O3'.
              wa_itemlist-gstrt =  '12.00'.
            ELSEIF wa_vbrp-taxcode = 'O1' OR wa_vbrp-taxcode = 'O2'.
              wa_itemlist-gstrt =  '5.00'.
            ELSEIF wa_vbrp-taxcode = 'O6' OR wa_vbrp-taxcode = 'O5'.
              wa_itemlist-gstrt =  '28.00'.
            ENDIF.

            IF wa_vbrp-transactiontypedetermination = 'JOC'.
              wa_itemlist-cgstamt = wa_itemlist-cgstamt + abs( wa_vbrp-amountintransactioncurrency ).
            ELSEIF wa_vbrp-transactiontypedetermination = 'JOS' OR wa_vbrp-transactiontypedetermination = 'JOU'.
              wa_itemlist-sgstamt = wa_itemlist-sgstamt + abs( wa_vbrp-amountintransactioncurrency ).
            ELSEIF wa_vbrp-transactiontypedetermination = 'JOI'.
              wa_itemlist-igstamt = wa_itemlist-igstamt + abs( wa_vbrp-amountintransactioncurrency ).
            ENDIF.

*          CONCATENATE wa_vbrp-product wa_vbrp-billingdocumentitemtext
*          INTO wa_itemlist-prddesc SEPARATED BY '-'.
            IF ls_journalentry-accountingdocumenttype = 'DR'.
              IF wa_itemlist-totamt < 0.
                wa_itemlist-totamt = wa_itemlist-totamt * -1.
              ENDIF.
              IF  wa_itemlist-assamt < 0.
                wa_itemlist-assamt = wa_itemlist-assamt * -1.
              ENDIF.
              IF wa_itemlist-cgstamt < 0.
                wa_itemlist-cgstamt = wa_itemlist-cgstamt * -1.
              ENDIF.

              IF wa_itemlist-sgstamt < 0.
                wa_itemlist-sgstamt = wa_itemlist-sgstamt * -1.
              ENDIF.

              IF wa_itemlist-igstamt < 0.
                wa_itemlist-igstamt = wa_itemlist-igstamt * -1.
              ENDIF.

              IF wa_itemlist-totitemval < 0.
                wa_itemlist-totitemval = wa_itemlist-totitemval * -1.
              ENDIF.

            ENDIF.

*          IF lv_acc_ass_grp = 'Z5' OR lv_acc_ass_grp = 'Z7' or wa_vbrp-SalesOrderDistributionChannel = 'JW'.
*            wa_itemlist-isservc     = 'Y'.
*          ELSE.
            IF wa_itemlist-hsncd NE '997212'.
              wa_itemlist-isservc     = 'N'.
            ELSE.
              wa_itemlist-isservc     = 'Y'.
            ENDIF.

*          ENDIF.
*
*          wa_itemlist-qty         = wa_vbrp-billingquantity.
*          wa_itemlist-barcde      = wa_vbrp-product.
*
*          READ TABLE productplantbasic INTO DATA(plantdata) WITH KEY product = wa_vbrp-product
*                                                                    plant = wa_vbrp-plant.
*          IF sy-subrc = 0.
*          wa_itemlist-hsncd =  wa_vbrp-IN_HSNOrSACCode.
*          ENDIF.
*          CLEAR lv_meins.
*
*          if wa_vbrp-SalesOrderDistributionChannel = 'JW'.
*          SELECT SINGLE ConsumptionTaxCtrlCodeText1
*              FROM I_AE_CnsmpnTaxCtrlCodeTxt
*              WHERE Language = 'E'
*                AND ConsumptionTaxCtrlCode = @wa_itemlist-hsncd
*                AND CountryCode = 'IN'
*                INTO @DATA(w_desc1).
*           wa_itemlist-prddesc = w_desc1.
**          wa_itemlist-prddesc = 'Manufacturing Services On Physical Inputs'.
*          ENDIF.
*
*          wa_itemlist-unit = VALUE #( it_meins[ sap_uom = wa_vbrp-billingquantityunit ]-gst_uom OPTIONAL ).
*
**          if wa_vbrp-SalesOrderDistributionChannel = 'JW'.
**          wa_itemlist-unit = 'KGS'.
**          endif.
*
**          LOOP AT pricingdata INTO DATA(prcd_elements)
**                         WHERE billingdocument = wa_vbrp-billingdocument AND
**                         billingdocumentitem = wa_vbrp-billingdocumentitem.
**
**            "BaseRate
**            READ TABLE it_baserate INTO DATA(wa_baserate) WITH KEY kschl = prcd_elements-conditiontype.
**            IF sy-subrc = 0.
**              lv_unit_pr = prcd_elements-conditionratevalue.
**              lv_asse_val = lv_asse_val + prcd_elements-conditionamount.
**            ENDIF.
**
**            "IGST
**            READ TABLE it_gstrate INTO DATA(wa_igst) WITH KEY kschl   = prcd_elements-conditiontype
**                                                              gst_typ = 'IGST'.
**            IF sy-subrc = 0.
**              lv_igst_rt = prcd_elements-conditionratevalue." / 10.
**              lv_igst = lv_igst + prcd_elements-conditionamount.
**            ENDIF.
**
**            "CGST
**            READ TABLE it_gstrate INTO DATA(wa_cgst) WITH KEY kschl   = prcd_elements-conditiontype
**                                                              gst_typ = 'CGST'.
**            IF sy-subrc = 0.
**              lv_cgst_rt = prcd_elements-conditionratevalue." / 10.
**              lv_cgst = lv_cgst + prcd_elements-conditionamount.
**            ENDIF.
**
**            "SGST
**            READ TABLE it_gstrate INTO DATA(wa_sgst) WITH KEY kschl   = prcd_elements-conditiontype
**                                                              gst_typ = 'SGST'.
**            IF sy-subrc = 0.
**              lv_sgst_rt = prcd_elements-conditionratevalue." / 10.
**              lv_sgst = lv_sgst + prcd_elements-conditionamount.
**            ENDIF.
**
**            "Discount
**            READ TABLE it_discount INTO DATA(wa_discount) WITH KEY kschl = prcd_elements-conditiontype.
**            IF sy-subrc = 0.
**              lv_disc = lv_disc + prcd_elements-conditionamount.
**            ENDIF.
**
**            "Other charges
**            READ TABLE it_othrchrg INTO DATA(wa_othrchrg) WITH KEY kschl = prcd_elements-conditiontype.
**            IF sy-subrc = 0.
**              lv_other_ch = lv_other_ch + prcd_elements-conditionamount.
**            ENDIF.
**
**            "Round Off
**            READ TABLE it_roundoff INTO DATA(wa_roundoff) WITH KEY kschl = prcd_elements-conditiontype.
**            IF sy-subrc = 0.
**              lv_tot_rndof_i = lv_tot_rndof_i + prcd_elements-conditionamount.
**            ENDIF.
**
**            if prcd_elements-conditiontype = 'ZROF'.
**             lv_tot_rndof_i = lv_tot_rndof_i + prcd_elements-conditionamount.
**            ENDIF.
**
**          ENDLOOP.
*
**          lv_asse_val  = lv_asse_val * wa_head-accountingexchangerate.
**          wa_itemlist-unitprice = ( lv_unit_pr  * wa_head-accountingexchangerate ).
**          wa_itemlist-totamt    = lv_asse_val. "( lv_unit_pr  * wa_vbrk-AccountingExchangeRate ) * wa_vbrp-fkimg.
**          wa_itemlist-discount  = ( lv_disc * wa_head-accountingexchangerate ).
*
*          IF lv_disc LE 0.
*            lv_disc = lv_disc * ( -1 ).
*          ENDIF.
*
*          IF wa_itemlist-discount LE 0.
*            wa_itemlist-discount = wa_itemlist-discount * ( -1 ).
*          ENDIF.
*
**          wa_itemlist-assamt    = lv_asse_val - ( lv_disc * wa_head-accountingexchangerate ).
*
*          IF lv_igst_rt IS NOT INITIAL.
*            wa_itemlist-gstrt     = lv_igst_rt.
*          ELSEIF lv_cgst_rt IS NOT INITIAL.
*            wa_itemlist-gstrt     = lv_cgst_rt.
*          ELSEIF lv_sgst_rt IS NOT INITIAL.
*            wa_itemlist-gstrt     = lv_sgst_rt.
*          ENDIF.
*
*          IF lv_cgst_rt IS NOT INITIAL AND lv_sgst_rt IS NOT INITIAL.
*            wa_itemlist-gstrt = lv_cgst_rt + lv_sgst_rt.
*          ENDIF.
*
*          wa_itemlist-igstamt = lv_igst."( lv_asse_val * lv_igst_rt ) / 100.
*          wa_itemlist-cgstamt = lv_cgst."( lv_asse_val * lv_cgst_rt ) / 100.
*          wa_itemlist-sgstamt = lv_sgst."( lv_asse_val * lv_sgst_rt ) / 100.
*
*          IF gv_exp = 'X'.
**            wa_itemlist-igstamt = wa_itemlist-igstamt * wa_head-accountingexchangerate. "( lv_asse_val * lv_igst_rt ) / 100.
*          ENDIF.
*
*          lv_other_ch = lv_other_ch + lv_freight + lv_ins.
**          lv_other_ch = lv_other_ch * wa_head-accountingexchangerate.
*
*          wa_itemlist-totitemval = wa_itemlist-assamt + wa_itemlist-igstamt + wa_itemlist-cgstamt + wa_itemlist-sgstamt +
*                                   wa_itemlist-cesamt + wa_itemlist-statecesamt + wa_itemlist-statecesnonadvlamt.
*
*          wa_itemlist-bchdtls-nm = wa_vbrp-batch.
*          lv_tot_val      = lv_tot_val      + wa_itemlist-totitemval + lv_other_ch.
*          lv_tot_disc     = lv_tot_disc     + wa_itemlist-discount.
*          lv_tot_asse_val = lv_tot_asse_val + wa_itemlist-assamt.
*          lv_tot_igst     = lv_tot_igst     + wa_itemlist-igstamt.
*          lv_tot_cgst     = lv_tot_cgst     + wa_itemlist-cgstamt.
*          lv_tot_sgst     = lv_tot_sgst     + wa_itemlist-sgstamt.
*          lv_tot_other    = lv_tot_other    + lv_other_ch.
*          lv_tot_rndof    = lv_tot_rndof    + lv_tot_rndof_i.
*

*
          ENDLOOP.
          wa_itemlist-totitemval = abs( wa_itemlist-totamt + wa_itemlist-cgstamt + wa_itemlist-sgstamt + wa_itemlist-igstamt ).

          lv_tot_asse_val = lv_tot_asse_val + wa_itemlist-assamt.
          lv_tot_cgst     = lv_tot_cgst + wa_itemlist-cgstamt.
          lv_tot_sgst     = lv_tot_sgst + wa_itemlist-sgstamt.
          lv_tot_igst     = lv_tot_igst + wa_itemlist-igstamt.

          APPEND wa_itemlist TO itemlist.
          CLEAR wa_itemlist.

        ENDLOOP.

        DELETE itemlist WHERE cgstamt = '' AND sgstamt = '' AND igstamt = ''.
*--------------------------------------------------------------------*
        "VALDTLS
*--------------------------------------------------------------------*

       wa_valdtls-assval   = abs( lv_tot_asse_val ).
        wa_valdtls-cgstval  = abs( lv_tot_cgst ).
        wa_valdtls-sgstval  = abs( lv_tot_sgst ).
        wa_valdtls-igstval  = abs( lv_tot_igst ).
        wa_valdtls-rndoffamt = lv_round.

        wa_valdtls-totinvval = abs( wa_valdtls-assval + wa_valdtls-cgstval + wa_valdtls-sgstval + wa_valdtls-igstval - lv_round ).


        IF ls_journalentry-accountingdocumenttype = 'DR'.
          IF wa_valdtls-assval < 0.
            wa_valdtls-assval = wa_valdtls-assval * -1.
          ENDIF.
*          wa_valdtls-assamt = wa_itemlist-assamt * -1.
          IF wa_valdtls-cgstval < 0.
            wa_valdtls-cgstval = wa_valdtls-cgstval * -1.
          ENDIF.

          IF wa_valdtls-sgstval < 0.
            wa_valdtls-sgstval = wa_valdtls-sgstval * -1.
          ENDIF.

          IF wa_valdtls-igstval < 0.
            wa_valdtls-igstval = wa_valdtls-igstval * -1.
          ENDIF.

          IF wa_valdtls-totinvval < 0.
            wa_valdtls-totinvval = wa_valdtls-totinvval * -1.
          ENDIF.

        ENDIF.

*        lv_tot_val .
*        + lv_tot_rndof.
*        wa_valdtls-rndoffamt = lv_tot_rndof.
*--------------------------------------------------------------------*
        "REFDTLS
*--------------------------------------------------------------------*
*        wa_refdtls-invrm = 'Ref'.
*        wa_refdtls-docperddtls-invstdt = ls_journalentry-AccountingDocument+6(2) && |/|
*                                  && ls_journalentry-AccountingDocument+4(2) && |/| &&  ls_journalentry-AccountingDocument+0(4).
*        wa_refdtls-docperddtls-invenddt = wa_refdtls-docperddtls-invstdt.


*        SELECT SINGLE *
*        FROM i_paymenttermstext
*        WHERE paymentterms = @wa_head-customerpaymentterms AND language = 'E'
*        INTO @DATA(wa_zterm).

*--------------------------------------------------------------------*
        "Export Shipping Details
*--------------------------------------------------------------------*
*        IF   wa_vbrk-distributionchannel = '20'
*          OR gv_exp = 'X'.
*          DATA(ls_salesdocument) = VALUE #( billingdata[ 1 ] OPTIONAL ).
*
*          IF ls_salesdocument IS NOT INITIAL.
*
*            SELECT SINGLE yy1_portofloading1_sdh
*            FROM i_salesdocument
*            WHERE salesdocument = @ls_salesdocument-salesdocument
*            INTO @DATA(lv_portcode).
*
**         IF wa_kna1-country NE 'IN'.    """ Added HC
*
**            CHECK lv_portcode IS NOT INITIAL.   "" Commented HC
*
*            SELECT SINGLE *
*            FROM ztsd_port_dtls
*            WHERE sap_port_code = @lv_portcode
*            INTO @DATA(ls_port_dtls).
*
*            IF ls_port_dtls IS NOT INITIAL.
*
*              wa_shipdtls-gstin = ls_port_dtls-port_gstin.
*              wa_shipdtls-pin   = ls_port_dtls-pstlz.
*              wa_shipdtls-lglnm = ls_port_dtls-name1.
*              wa_shipdtls-trdnm = ls_port_dtls-name1.
*              wa_shipdtls-stcd  = ls_port_dtls-regio.
*              wa_shipdtls-loc   = ls_port_dtls-ort01.
**wa_shipdtls-stcd  = ls_port_dtls-regio.
*              wa_shipdtls-addr1 = ls_port_dtls-address1.
*              wa_shipdtls-addr2 = ls_port_dtls-adress2.
*
*            ENDIF.
*
*          ENDIF.
*
*        ENDIF.

*--------------------------------------------------------------------*
        "PAYDTLS
*--------------------------------------------------------------------*
*      wa_paydtls-nm       = wa_zterm-paymenttermsdescription.
*      wa_paydtls-payterm  = wa_head-customerpaymentterms.
*      wa_paydtls-crday    =  wa_zterm-paymentterms.

*--------------------------------------------------------------------*
        "TRANSACTIONDTLS
*--------------------------------------------------------------------*
        wa_transaction-trandtls   = wa_trandtls.
        wa_transaction-docdtls    = wa_docdtls.
        wa_transaction-sellerdtls = wa_sellerdtls.
        wa_transaction-buyerdtls  = wa_buyerdtls.
*        wa_transaction-dispdtls   = wa_dispdtls.
        wa_transaction-shipdtls   = wa_shipdtls.
        wa_transaction-itemlist[] = itemlist[].
*      wa_transaction-paydtls    = wa_paydtls.
*        wa_transaction-refdtls    = wa_refdtls.
        wa_transaction-valdtls    = wa_valdtls.
*        wa_transaction-expdtls    = wa_expdtls.

        wa_tran = wa_transaction.
        APPEND wa_tran TO it_trans.

      ENDIF.
    ELSE.
      lv_stat = 'E'.
      wa_ztsd_ei_log-status  = 'Error While Generating IRN. Please Check Response inside record'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
