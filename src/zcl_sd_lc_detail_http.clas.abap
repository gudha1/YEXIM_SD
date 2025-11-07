class ZCL_SD_LC_DETAIL_HTTP definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
  CLASS-METHODS :  modify_create
                IMPORTING VALUE(tab) TYPE zmn2_respo OPTIONAL
                 RETURNING VALUE(resp)  TYPE string .

  DATA : WA TYPE zmn2_respo.
protected section.
private section.
ENDCLASS.



CLASS ZCL_SD_LC_DETAIL_HTTP IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

   DATA(body)  = request->get_text(  )  .
xco_cp_json=>data->from_string( body )->write_to( REF #( wa ) ).

SELECT * FROM zsd_lc_table
INNER JOIN @wa-items AS a
ON (  a~salesdocument = zsd_lc_table~salesdocument  )
INTO TABLE @DATA(tab) .




*ELSE .
data(resp) = modify_create( tab = wa ) .
response->set_text( resp ) .
*ENDIF.
endmethod.


METHOD modify_create.
data : create TYPE STANDARD TABLE OF zsd_lc_table .
create = VALUE #( FOR any in tab-items  (


   salesdocument        = any-salesdocument
  salesdocumentdate     = any-salesdocumentdate
  soldtoparty           = any-soldtoparty
  customername          = any-customername
  salesdocumentitem     = any-salesdocumentitem
  salesdocumentitemtext = any-salesdocumentitemtext
  orderquantity         = any-orderquantity
  netpriceamount        = any-netpriceamount
  lccopy                = any-lccopy
  lcnum                 = any-lcnum
  lcdate                = any-lcdate
  lcexpirydate          = any-lcexpirydate
  lcbankcountry         = any-lcbankcountry
  draftsat              = any-draftsat
  lcquantity            = any-lcquantity
  lcvalue               = any-lcvalue
  toleranceinlc         = any-toleranceinlc
  lcunitprice           = any-lcunitprice
  lastshipmentdate      = any-lastshipmentdate
  presentationperiod    = any-presentationperiod
  destinationport       = any-destinationport
  freedaysatdestination = any-freedaysatdestination
  anyotherspecialclause = any-anyotherspecialclause
  partialshipment       = any-partialshipment
  transshipment         = any-transshipment
  amendmnet             = any-amendment
  amendmnetdate         = any-amendmentdate
  amendmentresion       = any-amendmentresion
  amendmnetno          = any-amendmentno
  swiftcode            = any-swiftcode
  incotermslocation1   = any-incotermslocation1

*  item                 = any-item
) ) .

MODIFY zsd_lc_table FROM TABLE @create.
if sy-subrc = 0 .
resp =  ' Data Created SuceessFully '    .
ENDIF.
endmethod.
ENDCLASS.
