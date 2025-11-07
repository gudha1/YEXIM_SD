class ZCL_MM_IMPORT_HTTP definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .

  CLASS-DATA : it_data TYPE zexim_tab_struc,
               wa_data TYPE zexim_tab_struc,
               wa_head type zexim_save_tab.

             data  it_data2 type TABLE OF zexim_save_tab.
protected section.
private section.
ENDCLASS.



CLASS ZCL_MM_IMPORT_HTTP IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.
  DATA responce TYPE string.

    DATA(body)  = request->get_text(  ).

    xco_cp_json=>data->from_string( body )->write_to( REF #(  it_data ) ).
    DATA(req) = request->get_form_fields(  ).
    DATA(page) = value #( req[ name = 'page' ]-value optional ) .

IF page = 'Create'.

 DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
    TRY.
        CALL METHOD cl_numberrange_runtime=>number_get
          EXPORTING
            nr_range_nr = '01'
            object      = 'ZINT_BILL'
            quantity    = 0000000001
          IMPORTING
            number      = nr_number.

      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges.
    ENDTRY.
SHIFT nr_number LEFT DELETING LEADING '0'.
DATA NUMBERRANE TYPE C LENGTH 10 .

NUMBERRANE = nr_number .
CONDENSE NUMBERRANE NO-GAPS.


  LOOP AT  it_data-anewarr ASSIGNING FIELD-SYMBOL(<wat>).

wa_head-intbillofentrynumber  = NUMBERRANE.
wa_head-serialno               = <wat>-serialno.
wa_head-purchaseorder          = <wat>-purchaseorder.
wa_head-purchaseorderitem      = <wat>-purchaseorderitem.
wa_head-material               = <wat>-material.
wa_head-amountinr              = <wat>-amountinr.
wa_head-baseunit               = <wat>-baseunit.
wa_head-customdutyamount       = <wat>-customdutyamount.
wa_head-duty                   = <wat>-duty.
wa_head-freight                = <wat>-freight.
wa_head-hsncode                = <wat>-hsncode.
wa_head-igst                   = <wat>-igst.
wa_head-insurance              = <wat>-insurance.
wa_head-licenseno              = <wat>-licenseno.
wa_head-miscchanges            = <wat>-miscchanges.
wa_head-netpriceinr            = <wat>-netpriceinr.
wa_head-oldmaterialcode        = <wat>-oldmaterialcode.
wa_head-productdescription     = <wat>-productdescription.
wa_head-plant                  = <wat>-plant.
wa_head-purchaseorderdate      = <wat>-purchaseorderdate+6(4)  && <wat>-purchaseorderdate+3(2)  && <wat>-purchaseorderdate+0(2).
if <wat>-shipperinvoicedate is NOT INITIAL .
wa_head-shipperinvoicedate     = <wat>-shipperinvoicedate+6(4) && <wat>-shipperinvoicedate+3(2) && <wat>-shipperinvoicedate+0(2).
ENDIF.
wa_head-shipperinvoiceno       = <wat>-shipperinvoiceno.
wa_head-swcess                 = <wat>-swcess.
wa_head-swcessamt              = <wat>-swcessamt.
wa_head-additionalremark       = it_data-additionalremark.
wa_head-annexuredetails        = it_data-annexuredetails.
wa_head-baseunit               = <WAT>-baseunit.
wa_head-countryoforigin        = it_data-countryoforigin.
wa_head-exchangerate           = it_data-exchangerate.
wa_head-goodsclearingdata      = it_data-goodsclearingdata.
wa_head-idbalwbdate            = it_data-idbalwbdate+6(4)   && it_data-idbalwbdate+3(2)   && it_data-idbalwbdate+0(2) .
wa_head-idextboedate           = it_data-idextboedate+6(4)  && it_data-idextboedate+3(2)  && it_data-idextboedate+0(2)  .
wa_head-idextboeno             = it_data-idextboeno.
wa_head-idincoterms            = it_data-idincoterms.
wa_head-idtotalfreight1        = it_data-idtotalfreight1.
wa_head-idtotalfreight2        = it_data-idtotalfreight2.
wa_head-idtotalprodprice       = it_data-idtotalprodprice.
wa_head-loadingport            = it_data-loadingport.
wa_head-shipmentmode           = it_data-shipmentmode.
wa_head-totalarrivedqty        = it_data-totalarrivedqty.
wa_head-totalassbleval         = it_data-totalassbleval.
wa_head-totalassbleval2        = it_data-totalassbleval2.
wa_head-totalassigst           = it_data-totalassigst.
wa_head-totalassigst2          = it_data-totalassigst2.
wa_head-totalinsurance         = it_data-totalinsurance.
wa_head-totalitems             = it_data-totalitems.
wa_head-totalmiscchg           = it_data-totalmiscchg.
wa_head-totalmiscchg2          = it_data-totalmiscchg2.
wa_head-totdutyforegone        = it_data-totdutyforegone.
wa_head-totdutyforegone2       = it_data-totdutyforegone2.
wa_head-unloadingport          = it_data-unloadingport.
wa_head-supplier               = <wat>-supplier.
wa_head-suppliername           = <wat>-suppliername.
wa_head-orderqty               = <wat>-orderquantity.
wa_head-currency               = <wat>-documentcurrency.
wa_head-accessiblevalue        = <wat>-accessiblevalueinr.
wa_head-igstvalue              = <wat>-igstvalue.
wa_head-licencetype            = <wat>-lictype.
wa_head-totalduty              = <wat>-totalduty.
IF IT_DATA-internalboedate IS NOT INITIAL .
wa_head-intdate                = IT_DATA-internalboedate+6(4) && IT_DATA-internalboedate+3(2) && IT_DATA-internalboedate+0(2).
ENDIF.
wa_head-blewbno                = it_data-balwbno.

wa_head-headsupplier           = it_data-idsupplier.
wa_head-paymentterms           = it_data-idpaymentterms.
wa_head-incotermsloc           = it_data-location.
wa_head-countrynameoforigin    = it_data-countrynameoforigin.
wa_head-arrivedquantity        = <wat>-arrivedquantity.
 wa_head-bondamount                =     <wat>-bondamount          .
 wa_head-bondnumber               =      <wat>-bondnumber          .
 wa_head-idpaymenttermsname       =      it_data-idpaymenttermsname  .
 wa_head-licserialno              =      <wat>-licserialno         .


APPEND wa_head to it_data2 .
clear:wa_head.
ENDLOOP.

MODIFY zexim_save_tab FROM TABLE @it_data2.


     DATA WA_zbillof_atch_upl TYPE zbillof_atch_upl .
       LOOP AT it_data-aFiles INTO DATA(wa_ONUPLOAD).


       WA_zbillof_atch_upl-BILLOFENTRYNUMBER   = NUMBERRANE.
        WA_zbillof_atch_upl-attachment  = wa_ONUPLOAD-content.
        WA_zbillof_atch_upl-contentname  = wa_ONUPLOAD-filename.
        WA_zbillof_atch_upl-filename  = wa_ONUPLOAD-filename.
        WA_zbillof_atch_upl-mimetype  = wa_ONUPLOAD-mimetype.
        WA_zbillof_atch_upl-note  = wa_ONUPLOAD-programname.

        MODIFY zbillof_atch_upl FROM @WA_zbillof_atch_upl .
        CLEAR: wa_ONUPLOAD ,WA_zbillof_atch_upl.

      ENDLOOP.

responce = |Data saved successfully.{ NUMBERRANE }|.
    response->set_text( responce ).
ELSE.

  LOOP AT  it_data-anewarr ASSIGNING <wat>.

wa_head-intbillofentrynumber  = it_data-idInternalBOENo.
wa_head-serialno               = <wat>-serialno.
wa_head-purchaseorder          = <wat>-purchaseorder.
wa_head-purchaseorderitem      = <wat>-purchaseorderitem.
wa_head-material               = <wat>-material.
wa_head-amountinr              = <wat>-amountinr.
wa_head-baseunit               = <wat>-baseunit.
wa_head-customdutyamount       = <wat>-customdutyamount.
wa_head-duty                   = <wat>-duty.
wa_head-freight                = <wat>-freight.
wa_head-hsncode                = <wat>-hsncode.
wa_head-igst                   = <wat>-igst.
wa_head-insurance              = <wat>-insurance.
wa_head-licenseno              = <wat>-licenseno.
wa_head-miscchanges            = <wat>-miscchanges.
wa_head-netpriceinr            = <wat>-netpriceinr.
wa_head-oldmaterialcode        = <wat>-oldmaterialcode.
wa_head-productdescription     = <wat>-productdescription.
wa_head-plant                  = <wat>-plant.
IF <wat>-purchaseorderdate IS NOT INITIAL.
wa_head-purchaseorderdate      = <wat>-purchaseorderdate+6(4)  && <wat>-purchaseorderdate+3(2)  && <wat>-purchaseorderdate+0(2).
ENDIF.
IF <wat>-shipperinvoicedate IS NOT INITIAL.
wa_head-shipperinvoicedate     = <wat>-shipperinvoicedate+6(4) && <wat>-shipperinvoicedate+3(2) && <wat>-shipperinvoicedate+0(2).
ENDIF.
wa_head-shipperinvoiceno       = <wat>-shipperinvoiceno.
wa_head-swcess                 = <wat>-swcess.
wa_head-swcessamt              = <wat>-swcessamt.
wa_head-additionalremark       = it_data-additionalremark.
wa_head-annexuredetails        = it_data-annexuredetails.
wa_head-baseunit               = <WAT>-baseunit.
wa_head-countryoforigin        = it_data-countryoforigin.
wa_head-exchangerate           = it_data-exchangerate.
wa_head-goodsclearingdata      = it_data-goodsclearingdata.
IF it_data-idbalwbdate IS NOT INITIAL .
wa_head-idbalwbdate            = it_data-idbalwbdate+6(4)   && it_data-idbalwbdate+3(2)   && it_data-idbalwbdate+0(2) .
ENDIF.
IF it_data-idextboedate IS NOT INITIAL .
wa_head-idextboedate           = it_data-idextboedate+6(4)  && it_data-idextboedate+3(2)  && it_data-idextboedate+0(2)  .
ENDIF.
wa_head-idextboeno             = it_data-idextboeno.
wa_head-idincoterms            = it_data-idincoterms.
wa_head-idtotalfreight1        = it_data-idtotalfreight1.
wa_head-idtotalfreight2        = it_data-idtotalfreight2.
wa_head-idtotalprodprice       = it_data-idtotalprodprice.
wa_head-loadingport            = it_data-loadingport.
wa_head-shipmentmode           = it_data-shipmentmode.
wa_head-totalarrivedqty        = it_data-totalarrivedqty.
wa_head-totalassbleval         = it_data-totalassbleval.
wa_head-totalassbleval2        = it_data-totalassbleval2.
wa_head-totalassigst           = it_data-totalassigst.
wa_head-totalassigst2          = it_data-totalassigst2.
wa_head-totalinsurance         = it_data-totalinsurance.
wa_head-totalitems             = it_data-totalitems.
wa_head-totalmiscchg           = it_data-totalmiscchg.
wa_head-totalmiscchg2          = it_data-totalmiscchg2.
wa_head-totdutyforegone        = it_data-totdutyforegone.
wa_head-totdutyforegone2       = it_data-totdutyforegone2.
wa_head-unloadingport          = it_data-unloadingport.
wa_head-supplier               = <wat>-supplier.
wa_head-suppliername           = <wat>-suppliername.
wa_head-orderqty               = <wat>-orderquantity.
wa_head-currency               = <wat>-documentcurrency.
wa_head-accessiblevalue        = <wat>-accessiblevalueinr.
wa_head-igstvalue              = <wat>-igstvalue.
wa_head-licencetype            = <wat>-lictype.
wa_head-totalduty              = <wat>-totalduty.
IF IT_DATA-internalboedate IS NOT INITIAL.
wa_head-intdate                = IT_DATA-internalboedate+6(4) && IT_DATA-internalboedate+3(2) && IT_DATA-internalboedate+0(2).
ENDIF.
wa_head-blewbno                = it_data-balwbno.

wa_head-headsupplier           = it_data-idsupplier.
wa_head-paymentterms           = it_data-idpaymentterms.
wa_head-incotermsloc           = it_data-location.
wa_head-countrynameoforigin    = it_data-countrynameoforigin.
wa_head-arrivedquantity        = <wat>-arrivedquantity.
 wa_head-bondamount                =     <wat>-bondamount          .
 wa_head-bondnumber               =      <wat>-bondnumber          .
 wa_head-idpaymenttermsname       =      it_data-idpaymenttermsname  .
 wa_head-licserialno              =      <wat>-licserialno         .


APPEND wa_head to it_data2 .
clear:wa_head.

ENDLOOP.

MODIFY zexim_save_tab FROM TABLE @it_data2.



       LOOP AT it_data-aFiles INTO wa_ONUPLOAD.


       WA_zbillof_atch_upl-BILLOFENTRYNUMBER   = it_data-idInternalBOENo..
        WA_zbillof_atch_upl-attachment  = wa_ONUPLOAD-content.
        WA_zbillof_atch_upl-contentname  = wa_ONUPLOAD-filename.
        WA_zbillof_atch_upl-filename  = wa_ONUPLOAD-filename.
        WA_zbillof_atch_upl-mimetype  = wa_ONUPLOAD-mimetype.
        WA_zbillof_atch_upl-note  = wa_ONUPLOAD-programname.

        MODIFY zbillof_atch_upl FROM @WA_zbillof_atch_upl .
        CLEAR: wa_ONUPLOAD ,WA_zbillof_atch_upl.

      ENDLOOP.

responce = |Internal BOE. No. { it_data-idInternalBOENo } Change successfully.|.
    response->set_text( responce ).
ENDIF.
  endmethod.
ENDCLASS.
