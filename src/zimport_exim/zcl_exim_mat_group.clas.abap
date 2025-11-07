CLASS zcl_exim_mat_group DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    """"""""""""Data Define for material code creation
    TYPES: BEGIN OF ty_header,
             matgrpcode   TYPE zexim_mat_group-matgrpcode,
             description1 TYPE zexim_mat_group-description1,
             type         TYPE zexim_mat_group-type,
           END   OF ty_header.

    TYPES: BEGIN OF ty_item,
             matcode     TYPE zexim_mat_group-matcode,
             description TYPE zexim_mat_group-description,
             uom         TYPE zexim_mat_group-uom,
           END   OF ty_item.
    TYPES: ty_table1_tab TYPE STANDARD TABLE OF ty_item WITH EMPTY KEY.
    TYPES: BEGIN OF ty_final,
             headerdata      TYPE ty_header,
             tabledataarray1 TYPE ty_table1_tab,
           END OF ty_final.
    DATA: ls_final TYPE ty_final.
    """"""""""""End Of define Material Creation.

    """""""""""'Data Define For SIon Creation
    TYPES: BEGIN OF ty_header1,
             siontype          TYPE zexim_sion-siontype,
             exportmatgroup    TYPE zexim_sion-exp_mat_grp,
             exportmatgroupad1 TYPE zexim_sion-exp_mat_grpadd1,
             exportmatgroupad2 TYPE zexim_sion-exp_mat_grpadd2,
             exportmatgroupad3 TYPE zexim_sion-exp_mat_grpadd3,
             creationdate      TYPE STRING,
             sionnumber        TYPE zexim_sion-sionno,
             description       TYPE zexim_sion-description,
             description1      TYPE zexim_sion-desc1,
             description2      TYPE zexim_sion-desc2,
             description3      TYPE zexim_sion-desc3,
             dgftsionno        TYPE zexim_sion-dgft_sionno,
             quantity          TYPE zexim_sion-qty,
             quantity1         TYPE zexim_sion-qty1,
             quantity2         TYPE zexim_sion-qty2,
             quantity3         TYPE zexim_sion-qty3,
             baseunit          TYPE zexim_sion-base_uom,
             totalquantity     TYPE zexim_sion-totqty,
           END   OF ty_header1.
    TYPES: BEGIN OF ty_item1,
             importmatgrp TYPE zexim_sion-imp_mat_grp,
             description  TYPE zexim_sion-matgrp_desc,
             quantity     TYPE zexim_sion-matgrp_qty,
             uom          TYPE zexim_sion-matgrp_uom,
           END   OF ty_item1.
    TYPES: ty_table2_tab TYPE STANDARD TABLE OF ty_item1 WITH EMPTY KEY.

    TYPES: BEGIN OF ty_final1,
             headerdata      TYPE ty_header1,
             tabledataarray1 TYPE ty_table2_tab,
           END OF ty_final1.
    DATA: ls_final1 TYPE ty_final1.



    """"""""""""ENd OF Define sion creation

    INTERFACES if_http_service_extension .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EXIM_MAT_GROUP IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA: it_data  TYPE TABLE OF zexim_mat_group,
          wa_data  TYPE zexim_mat_group,
          wa_data1 TYPE zexim_sion,
          it_data1 TYPE TABLE OF zexim_sion,
          responce TYPE string.


    DATA(body)         = request->get_text(  ).
    DATA(req)          = request->get_form_fields(  ).
    DATA(type)         = VALUE #( req[ name = 'type' ]-value OPTIONAL ) .
    DATA(radiobutton)  = VALUE #( req[ name = 'radiobutton' ]-value  OPTIONAL ) .
    DATA(action)       = VALUE #( req[ name = 'action' ]-value  OPTIONAL ) .

    """""""""""""""'For Material Group creation and delete

    IF radiobutton = 'Material Group Master'.

      xco_cp_json=>data->from_string( body )->write_to( REF #(  ls_final ) ).
      LOOP AT ls_final-tabledataarray1 INTO DATA(wa_table).
        wa_data-matgrpcode = ls_final-headerdata-matgrpcode.
        wa_data-type      = ls_final-headerdata-type.
        wa_data-description1 = ls_final-headerdata-description1.
        wa_data-matcode = wa_table-matcode.
        wa_data-description = wa_table-description.
        wa_data-uom = wa_table-uom.
        APPEND wa_data TO it_data.
      ENDLOOP.
    ENDIF.

    IF radiobutton = 'Material Group Master' AND action = 'Create Material Group'.
      IF it_data IS NOT INITIAL.
        MODIFY zexim_mat_group FROM TABLE @it_data.
        responce = 'Data Saved Successfully'.
        response->set_text( responce ).
      ENDIF.
    ELSEIF radiobutton = 'Material Group Master' AND action = 'Change Material Group'.
      IF it_data IS NOT INITIAL.
        MODIFY zexim_mat_group FROM TABLE @it_data.
        responce = 'Data Updated Successfully'.
        response->set_text( responce ).
      ENDIF.
    ELSEIF radiobutton = 'Material Group Master' AND action = 'Delete Material Group'.
      DELETE zexim_mat_group FROM TABLE @it_data.
      responce = 'Data Deleted Successfully'.
      response->set_text( responce ).
    ENDIF.

    """"""""""""For Sion Master Create

    IF radiobutton = 'SION Master' AND action = 'Create SION' OR action = 'Change SION'.

      xco_cp_json=>data->from_string( body )->write_to( REF #(  ls_final1 ) ).

      """"""""Get Sion Number
      IF ls_final1-headerdata-sionnumber IS  INITIAL.
        DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
        TRY.
            CALL METHOD cl_numberrange_runtime=>number_get
              EXPORTING
                nr_range_nr = '01'
                object      = 'ZSION_NO'
                quantity    = 0000000001
              IMPORTING
                number      = nr_number.

          CATCH cx_nr_object_not_found.
          CATCH cx_number_ranges.
        ENDTRY.
        SHIFT nr_number LEFT DELETING LEADING '0'.
        DATA numberrane TYPE c LENGTH 10 .
        numberrane = nr_number .
        CONDENSE numberrane NO-GAPS.
      ENDIF.

      LOOP AT ls_final1-tabledataarray1 INTO DATA(wa_table1).
        wa_data1-siontype = ls_final1-headerdata-siontype.
        wa_data1-exp_mat_grp = ls_final1-headerdata-exportmatgroup.
        wa_data1-exp_mat_grpadd1 = ls_final1-headerdata-exportmatgroupad1.
        wa_data1-exp_mat_grpadd2 = ls_final1-headerdata-exportmatgroupad2.
        wa_data1-exp_mat_grpadd3 = ls_final1-headerdata-exportmatgroupad3.
             IF ls_final1-headerdata-creationdate IS NOT INITIAL .

        wa_data1-creation_date    = ls_final1-headerdata-creationdate+0(4) && ls_final1-headerdata-creationdate+5(2) && ls_final1-headerdata-creationdate+8(2).
        ENDIF.
        IF ls_final1-headerdata-sionnumber IS NOT INITIAL.
          wa_data1-sionno   = ls_final1-headerdata-sionnumber.
        ELSE.
          wa_data1-sionno           = numberrane.
        ENDIF.
        wa_data1-description      = ls_final1-headerdata-description.
        wa_data1-desc1            = ls_final1-headerdata-description1.
        wa_data1-desc2            = ls_final1-headerdata-description2.
        wa_data1-desc3            = ls_final1-headerdata-description3.
        wa_data1-dgft_sionno      = ls_final1-headerdata-dgftsionno.
        wa_data1-qty              = ls_final1-headerdata-quantity.
        wa_data1-qty1             = ls_final1-headerdata-quantity1.
        wa_data1-qty2             = ls_final1-headerdata-quantity2.
        wa_data1-qty3             = ls_final1-headerdata-quantity3.
        wa_data1-base_uom         = ls_final1-headerdata-baseunit.
        wa_data1-totqty           = ls_final1-headerdata-totalquantity.
        wa_data1-imp_mat_grp      = wa_table1-importmatgrp.
        wa_data1-matgrp_desc      = wa_table1-description.
        wa_data1-matgrp_qty       = wa_table1-quantity.
        wa_data1-matgrp_uom       = wa_table1-uom.
        APPEND wa_data1 TO it_data1.
        CLEAR wa_data1.
      ENDLOOP.
      IF it_data1 IS NOT INITIAL AND numberrane IS NOT INITIAL.
        MODIFY zexim_sion FROM TABLE @it_data1.
        CONCATENATE 'SION' numberrane 'Created Successfully' INTO responce SEPARATED BY space.
        response->set_text( responce ).
      ELSEIF it_data1 IS NOT INITIAL AND ls_final1-headerdata-sionnumber IS NOT INITIAL.
        MODIFY zexim_sion FROM TABLE @it_data1.
        CONCATENATE 'SION' ls_final1-headerdata-sionnumber 'Updated Successfully' INTO responce SEPARATED BY space.
        response->set_text( responce ).
      ENDIF.

    ELSEIF  radiobutton = 'SION Master' AND action = 'Delete SION Master'.
      CLEAR wa_table1.
      xco_cp_json=>data->from_string( body )->write_to( REF #(  ls_final1 ) ).

      LOOP AT ls_final1-tabledataarray1 INTO wa_table1.
        wa_data1-siontype         = ls_final1-headerdata-siontype.
        wa_data1-exp_mat_grp      = ls_final1-headerdata-exportmatgroup.
        wa_data1-exp_mat_grpadd1  = ls_final1-headerdata-exportmatgroupad1.
        wa_data1-exp_mat_grpadd2  = ls_final1-headerdata-exportmatgroupad2.
        wa_data1-exp_mat_grpadd3  = ls_final1-headerdata-exportmatgroupad3.
         IF ls_final1-headerdata-creationdate IS NOT INITIAL .

        wa_data1-creation_date    = ls_final1-headerdata-creationdate+0(4) && ls_final1-headerdata-creationdate+5(2) && ls_final1-headerdata-creationdate+8(2).
        ENDIF.
        wa_data1-sionno           = ls_final1-headerdata-sionnumber.
        wa_data1-description      = ls_final1-headerdata-description.
        wa_data1-desc1            = ls_final1-headerdata-description1.
        wa_data1-desc2            = ls_final1-headerdata-description2.
        wa_data1-desc3            = ls_final1-headerdata-description3.
        wa_data1-dgft_sionno      = ls_final1-headerdata-dgftsionno.
        wa_data1-qty              = ls_final1-headerdata-quantity.
        wa_data1-qty1             = ls_final1-headerdata-quantity1.
        wa_data1-qty2             = ls_final1-headerdata-quantity2.
        wa_data1-qty3             = ls_final1-headerdata-quantity3.
        wa_data1-base_uom         = ls_final1-headerdata-baseunit.
        wa_data1-totqty           = ls_final1-headerdata-totalquantity.
        wa_data1-imp_mat_grp      = wa_table1-importmatgrp.
        wa_data1-matgrp_desc      = wa_table1-description.
        wa_data1-matgrp_qty       = wa_table1-quantity.
        wa_data1-matgrp_uom       = wa_table1-uom.
        wa_data1-delete_ind       = 'X'.
        APPEND wa_data1 TO it_data1.
        CLEAR wa_data1.
      ENDLOOP.

      IF it_data1 IS NOT INITIAL.
        MODIFY zexim_sion FROM TABLE @it_data1.
        responce =  'Data Deleted Successfully'.
        response->set_text( responce ).
      ENDIF.


    ENDIF.




  ENDMETHOD.
ENDCLASS.
