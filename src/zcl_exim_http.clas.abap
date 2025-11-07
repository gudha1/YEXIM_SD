class ZCL_EXIM_HTTP definition
  public
  create public .

public section.
  CLASS-DATA: invoice type char10.

  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_EXIM_HTTP IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.



   DATA(req) = request->get_form_fields(  ).
    response->set_header_field( i_name = 'Access-Control-Allow-Origin' i_value = '*' ).
    response->set_header_field( i_name = 'Access-Control-Allow-Credentials' i_value = 'true' ).

  invoice = value #( req[ name = 'invoice' ]-value optional ) .
  data(value1) = value #( req[ name = 'value1' ]-value optional ) .
  data(printtype) =  value #( req[ name = 'printtype' ]-value optional ) .
  data(textdata) =  value #( req[ name = 'textdata' ]-value optional ) .

if value1 = 'custominvoice'.
DATA(pdf2) = zsd_exim_invoce=>read_posts( variable = invoice form = value1 ) .
elseif value1 = 'commercialinvoice'.
  pdf2 = zsd_commercial_invoicce=>read_posts( variable = invoice printtype = printtype ) .
else.
pdf2 = zexim_ssf_sd=>read_posts( variable = invoice  form = value1 text = textdata ) .
endif.
response->set_text( pdf2  ).


  endmethod.
ENDCLASS.
