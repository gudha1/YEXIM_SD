CLASS ycl_spellinwords DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
* data: LO_HTTP_CLIENT     TYPE REF TO IF_WEB_HTTP_CLIENT ,
    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : distan TYPE string .
    CLASS-DATA : final_message_irn TYPE string .
    CLASS-DATA : final_message_ewaybill TYPE string .
    TYPES: ty_dec TYPE p LENGTH 13 DECIMALS 3.
    CLASS-METHODS :
      spellamt
        IMPORTING iv_num          TYPE string OPTIONAL
                  currency        LIKE sy-waers OPTIONAL
                  language        LIKE sy-langu OPTIONAL
*                  filler          TYPE any DEFAULT space ##ADT_PARAMETER_UNTYPED
        RETURNING VALUE(rv_words) TYPE string  ,

      amtwords
        IMPORTING amount1        TYPE string
        RETURNING VALUE(status1) TYPE string  .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS YCL_SPELLINWORDS IMPLEMENTATION.


  METHOD amtwords .
    SPLIT amount1 AT '.' INTO DATA(a1) DATA(a2) .
    DATA(length)  = strlen( a1 )  .


    IF length GE 3 .
*data(l1) = length - 3 .
*data(a0) = a1+l1(3) .
*data(word1) = |{ a0+0(1) } HUNDRED| .
*data(word2) = |{ a0+1(1) } HUNDRED| .



    ENDIF .


  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.

    TRY.
*       DATA(return_data) = get_table_fields( invoice =  '0090000002' ewaybill  = 'X' irn = 'X'
*        DISTANCE = '796'   ) .
DATA(return_data) = spellamt( iv_num = '123'  ) .
 if return_data is not INITIAL .

 endif .


    ENDTRY.
  ENDMETHOD.


  METHOD spellamt .

    TYPES: BEGIN OF str_d,
             num   TYPE i,
             word1 TYPE string,
             word2 TYPE string,
           END OF str_d.

    DATA: ls_h TYPE str_d,
          ls_k TYPE str_d,
          ls_m TYPE str_d,
          ls_b TYPE str_d,
          ls_t TYPE str_d,
          ls_o TYPE str_d.

    DATA lv_int TYPE i.
    DATA lv_inp1 TYPE string.
    DATA lv_inp2 TYPE string.

    IF iv_num IS INITIAL.
      RETURN.
    ENDIF.

    ls_h-num = 100.
    ls_h-word1 = 'Hundred'.
    ls_h-word2 = 'Hundred and'.

    ls_k-num = ls_h-num * 10.
    ls_k-word1 = 'Thousand'.
    ls_k-word2 = 'Thousand'.

    ls_m-num = ls_k-num * 1000.
    ls_m-word1 = 'Million'.
    ls_m-word2 = 'Million'.

    ls_b-num = ls_m-num * 1000.
    ls_b-word1 = 'Billion'.
    ls_b-word2 = 'Billion'.

*    Use the following if this is required in Lakhs/Crores instead of Millions/Billions
*
*    ls_h-num = 100.
*    ls_h-word1 = 'Hundred'.
*    ls_h-word2 = 'Hundred and'.

*    ls_k-num = ls_h-num * 10.
*    ls_k-word1 = 'Thousand'.
*    ls_k-word2 = 'Thousand'.

*    ls_m-num = ls_k-num * 100.             ""03.10.2023
*    ls_m-word1 = 'Lakh'.
*    ls_m-word2 = 'Lakh'.

*    ls_b-num = ls_m-num * 100.
*    ls_b-word1 = 'Crore'.
*    ls_b-word2 = 'Crore'.

    lv_int = iv_num.

    SELECT * FROM YNUM_WORDS1 INTO TABLE @DATA(lt_d).

    IF lt_d IS NOT INITIAL.
      IF lv_int <= 20.
        READ TABLE lt_d REFERENCE INTO DATA(ls_d) WITH KEY value = lv_int.
        rv_words = ls_d->words.
        RETURN.
      ENDIF.

      IF lv_int < 100 AND lv_int > 20.
        DATA(mod) = lv_int MOD 10.
        DATA(floor) = floor( lv_int DIV 10 ).
        IF mod = 0.
          READ TABLE lt_d REFERENCE INTO ls_d WITH KEY value = lv_int.
          rv_words = ls_d->words.
          RETURN.
        ELSE.
          READ TABLE lt_d REFERENCE INTO ls_d WITH KEY value = floor * 10.
          DATA(pos1) = ls_d->words.
          READ TABLE lt_d REFERENCE INTO ls_d WITH KEY value = mod.
          DATA(pos2) = ls_d->words.
          rv_words = |{ pos1 } | && |{ pos2 } |.
          RETURN.
        ENDIF.
      ELSE.
        IF lv_int  < ls_k-num.
          ls_o = ls_h.
        ELSEIF lv_int < ls_m-num.
          ls_o = ls_k.
        ELSEIF lv_int < ls_b-num.
          ls_o = ls_m.
        ELSE.
          ls_o = ls_b.
        ENDIF.
        mod = lv_int MOD ls_o-num.
        floor = floor( iv_num DIV ls_o-num ).
        lv_inp1 = floor.
        lv_inp2 = mod.

        IF mod = 0.
          DATA(output2) = ycl_spellinwords=>spellamt( currency = '' iv_num = lv_inp1  ). "num2words( lv_inp1 ).
          rv_words =  |{ output2 } | && |{ ls_o-word1 } |.
          RETURN.
        ELSE.
          output2 = ycl_spellinwords=>spellamt( iv_num = lv_inp1 ).
          DATA(output3) = ycl_spellinwords=>spellamt(  iv_num = lv_inp2 ).
          rv_words = |{ output2 } | && |{ ls_o-word2 } | && |{ output3 } |.
          RETURN.
        ENDIF.
      ENDIF.
    ENDIF.





  ENDMETHOD.
ENDCLASS.
