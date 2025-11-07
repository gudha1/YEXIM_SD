class ZCL_SD_HTTP_SHIPMENTDTLS definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .

CLASS-METHODS :  modify_create
                IMPORTING VALUE(tab) TYPE zmn_str_respo OPTIONAL
                 RETURNING VALUE(resp)  TYPE string .

DATA : wa TYPE zmn_str_respo.
protected section.
private section.
ENDCLASS.



CLASS ZCL_SD_HTTP_SHIPMENTDTLS IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

  DATA(body)  = request->get_text(  )  .
xco_cp_json=>data->from_string( body )->write_to( REF #( wa ) ).

SELECT * FROM zshiping_table
INNER JOIN @wa-items AS a
ON (  a~billingdocument = zshiping_table~billcurritracnum and a~salesdocument = zshiping_table~salesdocument )
INTO TABLE @DATA(tab) .


**** erorr of key  already  exists ***************
IF   tab IS NOT  INITIAL .

  LOOP AT tab ASSIGNING FIELD-SYMBOL(<wa1>)  .
data :  str TYPE string .
    IF  <wa1>-zshiping_table-billcurritracnum is not INITIAL  AND <wa1>-zshiping_table-salesdocument IS NOT INITIAL .
      str = str && | Billing Document and sales Docuent  {  <wa1>-a-billingdocument } { <wa1>-a-salesdocument } Already Exist{ cl_abap_char_utilities=>cr_lf }| .
      response->set_text( |ERROR { str } | )  .
    ENDIF.
  ENDLOOP.


ELSE .
data(resp) = modify_create( tab = wa ) .
response->set_text( resp ) .
ENDIF.
endmethod.


METHOD modify_create.

data : create TYPE STANDARD TABLE OF zshiping_table .

create = VALUE #( FOR any in tab-items  (
                   billingdocument  = any-billingdocument
                   billingdocumentitem = any-billingdocumentitem
                   billingdocumentitemtext = any-billingdocumentitemtext
                   billingdocumentdate = any-billingdocumentdate
                   agingsobdate       = any-agingsobdate
                   billingquantity   = any-billingquantity
                   billcurritracnum  = any-billcurritracnum
                   billnum   =  any-billnum
                   billreciveaging  = any-billreciveaging
                   billreciveaging_date = any-billreciveaging_date
                   billsummr = any-billsummr
                   blremark  = any-blremark
                   bokking  = any-bokking
                   clagent = any-clagent
                   conditionrateamount = any-conditionrateamount
                   customername  = any-customername
                   cuttoff   = any-cuttoff
                   gateopen = any-gateopen
                   getin   = any-getin
                   draftok = any-draftok
                   eta  = any-eta
                   obl = any-obl
                   sob = any-sob
                   sobblfollowup = any-sobblfollowup
                   soldtoparty = any-soldtoparty
                   forwartagent = any-forwartagent
                   incotermslocation1 = any-incotermslocation1
                   lds = any-lds
                   salesdocument = any-salesdocument
                   place_container_of_receipt = any-placecontainerofreceipt
                   remark = any-remark
                   shpingline = any-shpingline
                   telex  = any-telex
                   trasittime = any-trasittime
                   yy1_lcdate_bdh = any-yy1_lcdate_bdh
                    yy1_lcno_bdh = any-yy1_lcno_bdh
                    yy1_lotno_dli  = any-yy1_lotno_dli
                    yy1_vehiclecontainernu_bdh = any-yy1_vehiclecontainernu_bdh
                    yy1_vehiclenumber_bdh = any-yy1_vehiclenumber_bdh
                    yy1_vesselflightno_bdh = any-yy1_vesselflightno_bdh


 ) ) .
MODIFY  zshiping_table from TABLE @create .
if sy-subrc = 0 .
resp = 'Data Saved Sucessfully' .
endif .
ENDMETHOD.
ENDCLASS.
