CLASS lhc_yexim_calculatcds DEFINITION INHERITING FROM  cl_abap_behavior_handler .
  PRIVATE SECTION.

*    equested_authorizations FOR yexim_calculatcds RESULT result.
  METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR yexim_calculatcds RESULT result.


ENDCLASS.

CLASS lhc_yexim_calculatcds IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.
