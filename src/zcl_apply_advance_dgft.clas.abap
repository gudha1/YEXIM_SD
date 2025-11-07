class ZCL_APPLY_ADVANCE_DGFT definition
  public
  create public .

public section.

         TYPES : BEGIN OF ty_item2,
      ImportMatGrp         TYPE STRING,
      ImportMaterial       TYPE STRING,
      CalQty               TYPE STRING,
      Price                TYPE STRING,
      Currency             TYPE STRING,
      AmountFC             TYPE STRING,
      ExchRateFC           TYPE STRING,
      AmountINR            TYPE STRING,
      ExchRateUSD          TYPE STRING,
      AmountUSD            TYPE STRING,
      CIFValue             TYPE STRING,
      AssessableValueINR   TYPE STRING,
      CustomDutyPercent    TYPE STRING,
      DutySaveINR          TYPE STRING,

     END OF ty_item2.

        DATA: item_tab2 TYPE TABLE OF ty_item2 .

   TYPES : BEGIN OF ty_hed,

          FGmaterial1    TYPE STRING,
  FGmaterial2            TYPE STRING,
  FGmaterial3            TYPE STRING,
  FGmaterial4            TYPE STRING,
  FGmaterial5            TYPE STRING,
  FGmaterial6            TYPE STRING,
  FGmaterial7            TYPE STRING,
  FGmaterial8            TYPE STRING,
  totalsionqt            TYPE STRING,
  FGplannedqt            TYPE STRING,
  qty1                   TYPE STRING,
  qty2                   TYPE STRING,
  qty3                   TYPE STRING,
  qty4                   TYPE STRING,
  totalimportqty         TYPE STRING,
  fileno                 TYPE STRING,
  calcrefno              TYPE STRING,
  valueadd               TYPE STRING,
  fcprice                TYPE STRING,
  usdprice               TYPE STRING,
  inrprice               TYPE STRING,
  Unit                   TYPE STRING,
  Unit1                  TYPE STRING,
  Unit2                  TYPE STRING,
  exch1                  TYPE STRING,
  exch2                  TYPE STRING,
  sionvalue1             TYPE STRING,
  sionvalue2             TYPE STRING,
  sionvalue3             TYPE STRING,
  FOBvalue1              TYPE STRING,
  FOBvalue2              TYPE STRING,
  FOBvalue3              TYPE STRING,
  cifvalue1              TYPE STRING,
  cifvalue2              TYPE STRING,
  cifvalue3              TYPE STRING,
  CIFunit1               TYPE STRING,
  CIFunit2               TYPE STRING,
  CIFunit3               TYPE STRING,
  DutySave1              TYPE STRING,
  DutySave2              TYPE STRING,
  DutySave3              TYPE STRING,
  DutySaveunit1          TYPE STRING,
  DutySaveunit2          TYPE STRING,
  DutySaveunit3          TYPE STRING,
          TableDataArray1 LIKE item_tab2,
        END OF ty_hed.

        DATA it_data TYPE ty_hed.
  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_APPLY_ADVANCE_DGFT IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.


   DATA(body) = request->get_text( ).
 DATA(req) = request->get_form_fields(  ).

    DATA(type)        = VALUE #( req[ name = 'delete' ]-value OPTIONAL ).
 xco_cp_json=>data->from_string( body )->write_to( REF #( it_data ) ).
 DATA wa_zadvance_dgft TYPE zadvance_dgft.



 LOOP AT it_data-tabledataarray1 ASSIGNING FIELD-SYMBOL(<zfs>).
 wa_zadvance_dgft-amountfc =   <zfs>-amountfc.
 wa_zadvance_dgft-amountinr = <zfs>-amountinr.
 wa_zadvance_dgft-amountusd = <zfs>-amountusd.
 wa_zadvance_dgft-assessablevalueinr = <zfs>-assessablevalueinr.
 wa_zadvance_dgft-calqty = <zfs>-calqty.
 wa_zadvance_dgft-customdutypercent = <zfs>-customdutypercent.
 wa_zadvance_dgft-currency = <zfs>-currency.
 wa_zadvance_dgft-cifvalue = <zfs>-cifvalue.
 wa_zadvance_dgft-dutysaveinr = <zfs>-dutysaveinr.
 wa_zadvance_dgft-exchratefc = <zfs>-exchratefc.
 wa_zadvance_dgft-exchrateusd = <zfs>-exchrateusd.
 wa_zadvance_dgft-price = <zfs>-price.
 wa_zadvance_dgft-importmaterial = <zfs>-importmaterial.


 wa_zadvance_dgft-fgmaterial1 = it_data-fgmaterial1.
 wa_zadvance_dgft-fgmaterial2 = it_data-fgmaterial2.
 wa_zadvance_dgft-fgmaterial3 = it_data-fgmaterial3.
 wa_zadvance_dgft-fgmaterial4 = it_data-fgmaterial4.
 wa_zadvance_dgft-fgmaterial5 = it_data-fgmaterial5.
 wa_zadvance_dgft-fgmaterial6 = it_data-fgmaterial6.
 wa_zadvance_dgft-fgmaterial7 = it_data-fgmaterial7.
 wa_zadvance_dgft-fgmaterial8 = it_data-fgmaterial8.
 wa_zadvance_dgft-totalsionqt = it_data-totalsionqt.
 wa_zadvance_dgft-fgplannedqt = it_data-fgplannedqt.
 wa_zadvance_dgft-qty1 = it_data-qty1.
 wa_zadvance_dgft-qty2 = it_data-qty2.
 wa_zadvance_dgft-qty3 = it_data-qty3.
 wa_zadvance_dgft-qty4 = it_data-qty4.
 wa_zadvance_dgft-totalimportqty = it_data-totalimportqty.
 wa_zadvance_dgft-fileno = it_data-fileno.
 wa_zadvance_dgft-calcrefno = it_data-calcrefno.
 wa_zadvance_dgft-valueadd = it_data-valueadd.
 wa_zadvance_dgft-fcprice = it_data-fcprice.
 wa_zadvance_dgft-usdprice = it_data-usdprice.
 wa_zadvance_dgft-inrprice = it_data-inrprice.
 wa_zadvance_dgft-unit = it_data-unit.
 wa_zadvance_dgft-unit1 = it_data-unit1.
 wa_zadvance_dgft-unit2 = it_data-unit2.
 wa_zadvance_dgft-exch1 = it_data-exch1.
 wa_zadvance_dgft-exch2 = it_data-exch2.
 wa_zadvance_dgft-sionvalue1 = it_data-sionvalue1.
 wa_zadvance_dgft-sionvalue2 = it_data-sionvalue2.
 wa_zadvance_dgft-sionvalue3 = it_data-sionvalue3.
 wa_zadvance_dgft-fobvalue1 = it_data-fobvalue1.
 wa_zadvance_dgft-fobvalue2 = it_data-fobvalue2.
     wa_zadvance_dgft-fobvalue3 = it_data-fobvalue3.
 wa_zadvance_dgft-cifvalue1 = it_data-cifvalue1.
 wa_zadvance_dgft-cifvalue2 = it_data-cifvalue2.
 wa_zadvance_dgft-cifvalue3 = it_data-cifvalue3.
 wa_zadvance_dgft-cifunit1 = it_data-cifunit1.
 wa_zadvance_dgft-cifunit2 = it_data-cifunit2.
 wa_zadvance_dgft-cifunit3 = it_data-cifunit3.
 wa_zadvance_dgft-dutysave1 = it_data-dutysave1.
 wa_zadvance_dgft-dutysave2 = it_data-dutysave2.
 wa_zadvance_dgft-dutysave3 = it_data-dutysave3.
 wa_zadvance_dgft-dutysaveunit1 = it_data-dutysaveunit1.
 wa_zadvance_dgft-dutysaveunit2 = it_data-dutysaveunit2.
     wa_zadvance_dgft-dutysaveunit3 = it_data-dutysaveunit3.

MODIFY zadvance_dgft FROM @wa_zadvance_dgft.

CLEAR:wa_zadvance_dgft.

 ENDLOOP.

  endmethod.
ENDCLASS.
