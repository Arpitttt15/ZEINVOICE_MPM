CLASS lhc_zi_billinginv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_billinginv RESULT result.

    METHODS createirn FOR MODIFY
      IMPORTING keys FOR ACTION zi_billinginv~createirn RESULT result.

ENDCLASS.

CLASS lhc_zi_billinginv IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CreateIRN.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_billinginv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_billinginv IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
