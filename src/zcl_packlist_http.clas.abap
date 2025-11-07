class ZCL_PACKLIST_HTTP definition
  public
  create public .

public section.

          TYPES : BEGIN OF ty_item1,
          DeliveryNumber  TYPE c LENGTH 10,
          BagNumber       TYPE c LENGTH 10,
     END OF ty_item1.

         DATA: item_tab TYPE TABLE OF ty_item1 .

          TYPES : BEGIN OF ty_item2,
          jumbo_bagno     TYPE c LENGTH 5,
          noofbags        TYPE c LENGTH 5,
          MoveType        TYPE c LENGTH 1,
          quantity        TYPE p LENGTH 5 DECIMALS 2,
          grossweight     TYPE p LENGTH 5 DECIMALS 2,
     END OF ty_item2.

        DATA: item_tab2 TYPE TABLE OF ty_item2 .

*{"sInvoice":"10000022","sBagType":"","sSelectNo":"","table1":[],
*"table2":[{"jumbo_bagno":"01","noofbags":"1","MoveType":"X","quantity":"25.00"},
*{"jumbo_bagno":"02","noofbags":"1","MoveType":"X","quantity":"25.00"}]}
   TYPES : BEGIN OF ty_hed,
          sInvoice TYPE c LENGTH 10,
          sBagType TYPE c LENGTH 15,
          table1 LIKE item_tab,
          table2 LIKE item_tab2,
        END OF ty_hed.

        DATA it_data TYPE ty_hed.

     DATA WA_TAB TYPE zpackinglist_exi.
     DATA: IT_TAB TYPE TABLE OF ty_hed.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_PACKLIST_HTTP IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

  DATA(body) = request->get_text( ).
 DATA(req) = request->get_form_fields(  ).

    DATA(type)        = VALUE #( req[ name = 'delete' ]-value OPTIONAL ).
 xco_cp_json=>data->from_string( body )->write_to( REF #( it_data ) ).


IF type = 'Delete'.

 LOOP AT it_data-table2 ASSIGNING FIELD-SYMBOL(<zfs2>).

 DELETE FROM zpackinglist_exi WHERE  invoicenumber = @it_data-sinvoice AND jumbo_bagno = @<zfs2>-jumbo_bagno.

 ENDLOOP.

ELSE.
 LOOP AT it_data-table1 ASSIGNING FIELD-SYMBOL(<zfs>).

  wa_tab-invoicenumber     = it_data-sinvoice.
  wa_tab-bagtype           = it_data-sbagtype.
  wa_tab-deliverynumber    = <zfs>-deliverynumber.
  wa_tab-bagnumber         = <zfs>-bagnumber.

  LOOP AT it_data-table2 ASSIGNING FIELD-SYMBOL(<zrs>).
  wa_tab-jumbo_bagno       = <zrs>-jumbo_bagno.
  wa_tab-noofbags          = <zrs>-noofbags.
  wa_tab-move_type         = <zrs>-movetype.
  wa_tab-quantity          = <zrs>-quantity.
  wa_tab-grossweight      = <ZRS>-grossweight.

  ENDLOOP.
 MODIFY zpackinglist_exi FROM @WA_TAB.
 ENDLOOP.
ENDIF.






  endmethod.
ENDCLASS.
