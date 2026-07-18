CLASS zapicall_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZAPICALL_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


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
          lv_status                TYPE string,
          json                     TYPE string.

    TRY.

        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                       comm_scenario      = 'ZCOMM_TO_CANCEL_EWAY'
                                           service_id     = 'ZEXPTAX_EWAY_CANCEL1_REST'
                                     ).

        TRY.
            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
          CATCH cx_web_http_client_error INTO DATA(lx_error).
            DATA(lv_text) = lx_error->get_text( ).

        ENDTRY.
        DATA(lo_request) = lo_http_client->get_http_request( ).


        lo_request->set_header_field( i_name = 'Content-Type'
                                      i_value = 'application/json' ).

        lo_request->set_header_field( i_name = 'Authorization'
                                      i_value = 'Token a8a9d9db8d7a09b6bb969c6964694a36ef0d61f6' ).

        lo_request->set_header_field( i_name = 'username'
                                      i_value = 'et_shree_durga_dev' ).

        lo_request->set_header_field( i_name = 'gstin'
                                      i_value = '24AABCD8894P1ZV' ).

        lv_content_length_value = strlen( json ).
        lo_request->set_text( i_text = json
                              i_length = lv_content_length_value ).

        TRY.
            DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>put ).
          CATCH cx_web_http_client_error INTO DATA(lx_err).
            DATA(lv_texts) = lx_error->get_text( ).
        ENDTRY.
        lv_xml_result_str = lo_response->get_text( ).
        lv_response = lv_xml_result_str.

      CATCH cx_http_dest_provider_error INTO DATA(lx_errors).
            DATA(lv_txt) = lx_error->get_text( ).   "##NO_HANDLER


    ENDTRY.


  ENDMETHOD.
ENDCLASS.
