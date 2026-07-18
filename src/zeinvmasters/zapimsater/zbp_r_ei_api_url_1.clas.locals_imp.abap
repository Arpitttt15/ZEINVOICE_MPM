CLASS lhc_ZrEiApiUrl1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR ZrEiApiUrl1 RESULT result.

ENDCLASS.

CLASS lhc_ZrEiApiUrl1 IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.
