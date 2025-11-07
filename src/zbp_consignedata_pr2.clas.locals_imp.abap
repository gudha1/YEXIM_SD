CLASS lhc_YCONSIGNEDATA_PR1 DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR yconsignedata_pr1 RESULT result.

ENDCLASS.

CLASS lhc_YCONSIGNEDATA_PR1 IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
