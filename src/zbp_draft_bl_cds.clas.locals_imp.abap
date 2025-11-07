CLASS lhc_zpregen_exi DEFINITION INHERITING FROM cl_abap_behavior_handler .
  PRIVATE SECTION.

    METHODS get_INSTANCE_authorizations FOR INSTANCE AUTHORIZATION

     IMPORTING keys REQUEST requested_authorizations FOR ydraft_bl_cds RESULT result.
*      IMPORTING  REQUEST requested_authorizations FOR ydraft_bl_cds RESULT result.

ENDCLASS.

CLASS lhc_zpregen_exi IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
