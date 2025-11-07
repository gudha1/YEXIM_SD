
CLASS zexim_ssf_sd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    CLASS-DATA : access_token TYPE string .
    CLASS-DATA : xml_file TYPE string .
    TYPES :
      BEGIN OF struct,
        xdp_template TYPE string,
        xml_data     TYPE string,
        form_type    TYPE string,
        form_locale  TYPE string,
        tagged_pdf   TYPE string,
        embed_font   TYPE string,
      END OF struct."
      CLASS-DATA : BTH_LOT TYPE STRING,
                 MAT     TYPE CHAR40.

    CLASS-METHODS :

      create_client
        IMPORTING url           TYPE string
        RETURNING VALUE(result) TYPE REF TO if_web_http_client
        RAISING   cx_static_check,

      read_posts
        IMPORTING variable        TYPE char10
                  form            TYPE string
                  text            TYPE string

        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS lc_ads_render TYPE string VALUE '/ads.restapi/v1/adsRender/pdf'.
    CONSTANTS  lv1_url    TYPE string VALUE 'https://adsrestapi-formsprocessing.cfapps.eu10.hana.ondemand.com/v1/adsRender/pdf?templateSource=storageName&TraceLevel=2'  .
    CONSTANTS  lv2_url    TYPE string VALUE 'https://sagar.authentication.eu10.hana.ondemand.com/oauth/token'  .
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS  lc_template_name TYPE string VALUE 'VGM_EXIM/VGM_EXIM'.
    CONSTANTS  lc_template_name1 TYPE string VALUE 'NOTIFICATION_EXIM/NOTIFICATION_EXIM'.
    CONSTANTS  lc_template_name2 TYPE string VALUE 'NHAVASHEVA_EXIM/NHAVASHEVA_EXIM'.
    CONSTANTS  lc_template_name3 TYPE string VALUE 'MONDIDEEP_EXIM/MONDIDEEP_EXIM'.
    CONSTANTS  lc_template_name4 TYPE string VALUE 'ANX_EXIM/ANX_EXIM'.
    CONSTANTS  lc_template_name5 TYPE string VALUE 'SHIPPING_ADVICE_EXIM/SHIPPING_ADVICE_EXIM'.
    CONSTANTS  lc_template_name6 TYPE string VALUE 'BENIFICIARY_NONPLASTIC/BENIFICIARY_NONPLASTIC'.
    CONSTANTS  lc_template_name7 TYPE string VALUE 'COUNTRY_OF_ORIGIN_EXIM/COUNTRY_OF_ORIGIN_EXIM'.
    CONSTANTS  lc_template_name8 TYPE string VALUE 'QUANTITY_EXIM/QUANTITY_EXIM'.
    CONSTANTS  lc_template_name9 TYPE string VALUE 'WEIGHT_LIST_EXIM/WEIGHT_LIST_EXIM'.
    CONSTANTS  lc_template_name10 TYPE string VALUE 'WEIGHT_AND_MEASUREMENT_EXIM/WEIGHT_AND_MEASUREMENT_EXIM'.
   CONSTANTS  lc_template_name11 TYPE string VALUE 'SHIPPINGADVICE_WEBER_EXIM/SHIPPINGADVICE_WEBER_EXIM'.
*   CONSTANTS  lc_template_name12 TYPE string VALUE 'PACKING_LIST_DETAILS_EXIM/PACKING_LIST_DETAILS_EXIM'.
*   CONSTANTS  lc_template_name13 TYPE string VALUE 'PACKING_LIST_EXIM/PACKING_LIST_EXIM'.
ENDCLASS.



CLASS ZEXIM_SSF_SD IMPLEMENTATION.


  METHOD create_client .
    DATA(dest) = cl_http_destination_provider=>create_by_url( url ).
    result = cl_web_http_client_manager=>create_by_http_destination( dest ).

  ENDMETHOD .


  METHOD if_oo_adt_classrun~main.

    TRY.

    ENDTRY.

  ENDMETHOD.


  METHOD read_posts .
    DATA temp   TYPE  string  .


    SELECT SINGLE * FROM zpregen_exi WHERE docno = @variable   INTO @DATA(gendata) .
    SELECT SINGLE * FROM zpregen_exi WHERE docno = @variable AND Doctype = 'PS'   INTO @DATA(gendataps) .
    SELECT SINGLE * FROM zpregen_exi WHERE docno = @variable AND Doctype = 'PO'  INTO @DATA(gendata1) .

    SELECT SINGLE * FROM yconsignedata_pr1 WHERE docno = @variable INTO @DATA(considata) .
    SELECT SINGLE * FROM yconsignedata_pr1 WHERE docno = @variable AND Doctype = 'PS' INTO @DATA(considata1ps) .
    SELECT SINGLE * FROM yconsignedata_pr1 WHERE docno = @variable AND Doctype = 'PO' INTO @DATA(considata1) .
    SELECT * FROM yeinvoice_cdss WHERE billingdocument =  @variable INTO TABLE @DATA(billitemdata) .
    READ TABLE billitemdata INTO  DATA(wt) INDEX 1 .


    SELECT SINGLE * FROM i_customer WHERE customer = @wt-billtoparty INTO @DATA(billto) .

*    SELECT SINGLE * FROM zsd_dom_address WITH PRIVILEGED ACCESS WHERE addressid = @billto-addressid INTO @DATA(billtoadd1)   .

*    SELECT SINGLE * FROM i_countrytext WHERE country = @billtoadd1-country AND language = 'E' INTO @DATA(country).


    SELECT SINGLE * FROM i_billingdocumentbasic WHERE billingdocument =  @variable INTO @DATA(billhead) .

    SELECT SINGLE * FROM i_paymenttermstext WHERE
    paymentterms = @billhead-customerpaymentterms AND language = 'E'
       INTO @DATA(terms) .

    SELECT SINGLE * FROM yexim_calculatproj WHERE docno = @variable INTO @DATA(calculatproj).
        SELECT SINGLE * FROM yexim_calculatproj WHERE docno = @variable and Doctype = 'PO' INTO @DATA(calculatprojvs).
    SELECT SINGLE * FROM yexim_calculatproj WHERE docno = @variable  and Doctype = 'PS' INTO @DATA(calculatprojps).

    SELECT SINGLE * FROM ybilling_datta WHERE billingdocument = @variable INTO @DATA(billheaddata) .

    """New Logic for grossweight 19.05.2025
    SELECT * FROM  yeinvoice_cdss   WHERE billingdocument = @variable   INTO TABLE @DATA(it) .

     SELECT SINGLE * FROM  i_billingdocumentitem AS a
    LEFT OUTER JOIN i_deliverydocumentitem AS b ON ( a~referencesddocument = b~deliverydocument AND a~referencesddocumentitem = b~deliverydocumentitem )
    INNER JOIN   i_deliverydocument AS f ON ( b~deliverydocument = f~deliverydocument )
    LEFT OUTER JOIN i_shippingtypetext AS s ON ( f~shippingtype = s~shippingtype AND s~language = 'E'  )
       WHERE  billingdocument  =  @variable INTO @DATA(billingitemA)  .

   LOOP AT it INTO DATA(wa) .

      SELECT SINGLE deliverydocument, deliverydocumentitem   FROM i_deliverydocumentitem AS a
      WHERE deliverydocument = @wa-delivery_number AND material = @wa-material AND deliverydocumentitem = @wa-delivery_number_item

      AND batch IS INITIAL INTO @DATA(it_itab1).


*   IF BTH_LOT NE it_itab1-yy1_lotno_dli .

      SELECT
      SUM(  grosswt )
         FROM i_deliverydocumentitem  AS a
         INNER JOIN zpackn_cds AS b ON
                          ( a~batch = b~batch  AND  b~batch NE ' ' )
                                             WHERE  a~deliverydocument =  @wa-delivery_number
                                                AND a~batch IS NOT INITIAL

                                                AND a~material = @wa-material
*                                                AND b~lotnumber        = @it_itab1-yy1_lotno_dli
*                                                AND b~Batch = @it_itab1-Batch
                                                 INTO @DATA(grossweight1) .
      DATA :   grossweight TYPE p DECIMALS 3 .


      grossweight = grossweight + grossweight1 .


*     ENDIF.

*      BTH_LOT  = it_itab1-yy1_lotno_dli.
      MAT  = WA-Material.

      CLEAR grossweight1.
    ENDLOOP.



    IF grossweight  IS INITIAL .
      SELECT SUM( itemgrossweight ) FROM i_deliverydocumentitem WHERE deliverydocument = @billingitemA-a-referencesddocument INTO @grossweight .

    ENDIF .

    IF billhead-division = '50' .

      SELECT SUM( itemgrossweight ) FROM i_deliverydocumentitem WHERE deliverydocument = @billingitemA-a-referencesddocument INTO @grossweight .

    ENDIF.

    IF billhead-division = '30' .

      SELECT
         SUM(  grosswt )
            FROM i_deliverydocumentitem  AS a
            INNER JOIN zpackn_cds AS b ON
                             ( a~batch = b~batch  AND a~batch NE ' ' AND  b~batch NE ' ' )
                                                WHERE  a~deliverydocument =  @billingitemA-a-referencesddocument   INTO @grossweight .

    ENDIF.





*     billheaddata-totalgrossquantity = grossweight.
  """'End of logic

    SELECT SINGLE * FROM ydraft_bl_cds WHERE docno = @variable INTO @DATA(draft).
     SELECT SINGLE * FROM ydraft_bl_cds WHERE docno = @variable AND Doctype = 'PS' INTO @DATA(drafmat) .

     SELECT SINGLE * FROM ydraft_bl_cds WHERE docno = @variable AND Doctype = 'PO' INTO @DATA(draft7).



*    SELECT SINGLE * FROM y_invoicedata_cds WHERE BillingDocument = @VARIABLE INTO @DATA(vsinvoice).

   SELECT SINGLE * FROM i_billingdocumentbasic WHERE billingdocument =  @variable INTO @DATA(billhead1) .

    SELECT SINGLE * FROM  i_billingdocumentitem AS a
    LEFT OUTER JOIN i_deliverydocumentitem AS b ON ( a~referencesddocument = b~deliverydocument AND a~referencesddocumentitem = b~deliverydocumentitem )
    INNER JOIN   i_deliverydocument AS f ON ( b~deliverydocument = f~deliverydocument )
    LEFT OUTER JOIN i_shippingtypetext AS s ON ( f~shippingtype = s~shippingtype AND s~language = 'E'  )
       WHERE  billingdocument  =  @variable INTO @DATA(billingitem)  .


if calculatprojvs-Lcdate1 = '00000000'.
   calculatprojvs-Lcdate1 = ''.
ENDIF.

DATA(lv_billingdoc1) = |{ variable ALPHA = IN }|.
SELECT SINGLE plant FROM I_BillingDocumentItem WHERE BillingDocument = @lv_billingdoc1 INTO  @DATA(PLANT).
data : name1 type string .
data : addr1 type string .
data : addr2 type string .
data : tele type string .
data : email type string .
data : website type string .
data : iec type string .
data : gst type string .
data : pan type string .
data : cin type string .


 SELECT SINGLE * FROM i_billingdocumentbasic WHERE billingdocument =  @lv_billingdoc1 INTO @DATA(billhead2) .


CASE plant.
  WHEN '1000'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'PLOT E-10, 11, F-14 to 16, RIICO Industrial Area, Sitapura'.
    addr2   = 'Jaipur 302022'.
    tele    = '0141-270202 & 0141-270203'.
    email   = 'jaipur@poddarpigmentsltd.com'.
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '08AAACP1125E2ZY'.
    pan     = 'AAACP1125E'.
    cin     = 'L24117RJ1991PLC006307'.

  WHEN '1100'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'PLOT E-10, 11, F-14 to 16, RIICO Industrial Area, Sitapura'.
    addr2   = 'Jaipur 302022'.
    tele    = '0141-270202 & 0141-270203'.
    email   = 'jaipur@poddarpigmentsltd.com'.
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '08AAACP1125E1ZZ'.
    pan     = 'AAACP1125E'.
    cin     = 'L24117RJ1991PLC006307'.

  WHEN '1110'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'Greater Sitapura Industrial Park, National Highway 12 (Jaipur-Tonk Road), Brijpura village, Chaksu'.
    addr2   = 'Jaipur 303901'.
    tele    = '0141-270202 & 0141-270203'.
    email   = 'jaipur@poddarpigmentsltd.com'.
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '08AAACP1125E1ZZ'.
    pan     = 'AAACP1125E'.
    cin     = 'L24117RJ1991PLC006307'.

  WHEN '1200'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'Rosy Tower, 3rd Floor 8, Mahatma Gandhi Road, Nungambakkam'.
    addr2   = 'Chennai 600034'.
    tele    = '0141-270202 & 0141-270203'.
    email   = 'jaipur@poddarpigmentsltd.com'.   "default
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '33AAACP1125E3Z4'.
    pan     = 'AAACP1125E'.
    cin     = 'L24117RJ1991PLC006307'.

  WHEN '1210'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'A-283 Ground floor Okhla Industrial Area Phase-1'.
    addr2   = 'New Delhi 110020'.
    tele    = '0141-270202 & 0141-270203'.
    email   = 'jaipur@poddarpigmentsltd.com'.   "default
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '07AAACP1125E4ZY'.
    pan     = 'AAACP1125E'.
    cin     = 'L24117RJ1991PLC006307'.
ENDCASE.
    SELECT SINGLE * FROM i_billingdocument WHERE billingdocument =  @lv_billingdoc1 INTO @DATA(billingdocument).

    IF form = 'notification'  .

      temp = 'NOTIFICATION_EXIM/NOTIFICATION_EXIM' .


      DATA(lv_xml) =
      |<form1>| &&
      |<Page>| &&
      |<Subform1/>| &&
      |<Subform2/>| &&
      |<Subform3>| &&
      |<Table1>| &&
      |<Row1>| &&
      |<Nameofexporter>{ gendata-authorisedsigntory }</Nameofexporter>| &&
      |<CustomerBroker>{ gendata-nameofcustomsbroker  }</CustomerBroker>| &&
      |</Row1>| &&
      |<Row2>| &&
      |<DesignationExp>{ gendata-designation }</DesignationExp>| &&
      |<DesignationCust></DesignationCust>| &&
      |</Row2>| &&
      |<Row3>| &&
      |<IdentityCardNo></IdentityCardNo>| &&
      |</Row3>| &&
      |</Table1>| &&
      |</Subform3>| &&
      |<Subform4>| &&
      |<Date>{ gendata-docdate+6(2) } / { gendata-docdate+4(2) } / { gendata-docdate+0(4)  }</Date>| &&
      |</Subform4>| &&
      |</Page>| &&
      |</form1>| .


    ENDIF .

    DATA(mon) = gendata-docdate+4(2) .

    DATA(month) = SWITCH string( mon


     WHEN 01 THEN 'JAN'
     WHEN 02 THEN 'FEB'
     WHEN 03 THEN 'MAR'
     WHEN 04 THEN 'APR'
     WHEN 05 THEN 'MAY'
     WHEN 06 THEN 'JUN'
     WHEN 07 THEN 'JUL'
     WHEN 08 THEN 'AUG'
     WHEN 09 THEN 'SEP'
     WHEN 10 THEN 'OCT'
     WHEN 11 THEN 'NOV'
     WHEN 12 THEN 'DEC'

    )  .

    SELECT SINGLE * FROM ZPREGN_EXIPROJ WHERE docno = @variable   INTO @DATA(it_itabl).

DATA(lv_billingdoc) = |{ variable ALPHA = IN }|.  "Convert to 10 length with leading zeros
    SELECT SINGLE DistributionChannel, creationdate FROM  I_BillingDocument   WHERE billingdocument = @lv_billingdoc   INTO @DATA(dist) .
    IF  form = 'annexure'  .
      temp = 'ANX_EXIM/ANX_EXIM'.



*    SELECT SINGLE DistributionChannel FROM  I_BillingDocument   WHERE billingdocument = @lv_billingdoc   INTO @DATA(dist) .

*      SELECT SINGLE Authorisedsigntory, Designation, Shipmentdate, PaymentTerms, Deliveryterms, Weightofcontainer FROM ZPREGN_EXIPROJ
*      WHERE Docno = @variable INTO @DATA(it_itabl).

    DATA tick1   TYPE  string  .
    DATA tick2   TYPE  string  .

if dist = '12'.
tick1 = 'Y'.
tick2 = ''.
ELSEIF dist = '18'.
tick1 = ''.
tick2 = 'X'.
ENDIF.

      lv_xml =
      |<form1>| &&
      |<Page1>| &&
      |<Subform1/>| &&
      |<SubMain>| &&
      |<Billnodate></Billnodate>| &&
      |<Invnodate>{ gendata-docno } - { gendata-peformadate+6(2) }/{ gendata-peformadate+4(2) }/{ gendata-peformadate+0(4) }</Invnodate>| &&
      |<SaleCK>{ tick1 }</SaleCK>| &&
      |<BasisCK></BasisCK>| &&
      |<GiftCK></GiftCK>| &&
      |<SampleCK>{ tick2 }</SampleCK>| &&
      |<OtherCK>0</OtherCK>| &&
      |<Rule3CK>0</Rule3CK>| &&
      |<Rule4CK>0</Rule4CK>| &&
      |<Rule5CK>0</Rule5CK>| &&
      |<Rule6CK>0</Rule6CK>| &&
      |<YesCK>0</YesCK>| &&
*      |<NOCK>0</NOCK>| &&
      |<YesCK>0</YesCK>| &&
*      |<NoCK>0</NoCK>| &&
*      |<Termpay>{ terms-paymenttermsdescription }</Termpay>| &&
*      |<TermDelivery>{ billhead-incotermsclassification }</TermDelivery>| &&
      |<Termpay>{ it_itabl-CustomerPaymentTerms }</Termpay>| &&
      |<TermDelivery>{ it_itabl-Deliveryterms } - { it_itabl-Incotermslocation }</TermDelivery>| &&
      |<ShippingBillNoDate></ShippingBillNoDate>| &&
      |<RelevantInfo></RelevantInfo>| &&
      |</SubMain>| &&
      |<Subform3/>| &&
      |<Subform4>| &&
      |<Place>JAIPUR, RAJASTHAN</Place>| &&
      |<Date> { it_itabl-Shipmentdate+6(2) }/{ it_itabl-Shipmentdate+4(2) }/{ it_itabl-Shipmentdate+0(4) }</Date>| &&
*      |<Date> { it_itabl-Shipmentdate }</Date>| &&
      |</Subform4>| &&
      |<Subform5/>| &&
      |<AuthorizedSignatory> { it_itabl-Authorisedsigntory }</AuthorizedSignatory>| &&
      |<Designation> { it_itabl-Designation }</Designation>| &&
      |</Page1>| &&
      |</form1>| .

* |<Date>{ gendata-docdate+6(2) }/{ month }/{ gendata-docdate+0(4)  }</Date>| &&
    ENDIF.

    IF  form = 'mandideep'  .
      temp = 'MONDIDEEP_EXIM/MONDIDEEP_EXIM'.


*lv_xml =

      DATA(lv_xml1) =

      |<form1>| &&
      |<InvoiceNo>{ gendata-docno }</InvoiceNo>| &&
      |<Date>{ gendata-docdate+6(2) }/{ gendata-docdate+4(2) }/{ gendata-docdate+0(4) }</Date>| &&
      |<Table1>| &&
      |<Row1>| &&
      |<ContainerNo>{ gendata-containerno }</ContainerNo>| &&
      |</Row1>| .
      DATA xsml TYPE string .
      DATA n TYPE string.
      LOOP AT billitemdata INTO DATA(iv).

        SELECT SINGLE * FROM ydeli_data WHERE
        deliverydocument = @iv-delivery_number AND
        deliverydocumentitem = @iv-delivery_number_item INTO @DATA(pack) .
        n = n + 1 .

        SELECT SINGLE * FROM i_deliverydocumentitem WHERE deliverydocument = @iv-delivery_number AND
        deliverydocumentitem = @iv-delivery_number_item INTO @DATA(lot)   .

        DATA material TYPE string .

*        SELECT SINGLE yy1_fulldescription_prd FROM i_product WHERE  product = @iv-material    INTO @DATA(mat2)  .



        SELECT SINGLE * FROM i_salesdocumentitem WHERE salesdocument = @iv-sddocu AND salesdocumentitem = @iv-sddocuitem INTO @DATA(sdata)  .

*        material  = sdata-yy1_customermaterialde_sdi .

        IF material IS INITIAL .
*          material =  |{ iv-materialdescription } { mat2 }| . .

        ENDIF .

 if lot-Division = '30'     or lot-Division = '40'   .         "ch-shivraj17-03-2025
      data  LEN TYPE string.
*         LEN = lot-yy1_lotno_dli+0(4).

*          DATA(LOT_NO) = LEN+0(4).

        SELECT SUM( grosswt ) FROM zpackn_cds AS a LEFT OUTER JOIN i_deliverydocumentitem AS b
                                          ON ( a~batch  = b~batch   )
                                          WHERE b~higherlvlitmofbatspltitm  =
                                          @iv-delivery_number_item
                                           AND b~deliverydocument = @iv-delivery_number
                                           AND a~lotnumber = @len
**                                           and @lot-YY1_LotNo_DLI + 0(7) .
                                           AND b~batch IS NOT INITIAL
                                          INTO @DATA(gross)  .
          else.


        SELECT SUM( grosswt ) FROM zpackn_cds AS a LEFT OUTER JOIN i_deliverydocumentitem AS b
                                          ON ( a~batch  = b~batch   )
                                          WHERE b~higherlvlitmofbatspltitm  =
                                          @iv-delivery_number_item
                                           AND b~deliverydocument = @iv-delivery_number
*                                           AND a~lotnumber = @lot-yy1_lotno_dli
**                                           and @lot-YY1_LotNo_DLI + 0(7) .
                                           AND b~batch IS NOT INITIAL
                                          INTO @gross  .
      endif.



        DATA grosstot TYPE string .
        DATA netwt TYPE string .
        DATA package TYPE string .



        DATA(lv_xml2) =

        |<Row2>| &&
        |<SNo>{ n }</SNo>| &&
        |<Date>{ gendata-docdate+6(2) }/{ gendata-docdate+4(2) }/{ gendata-docdate+0(4) }</Date>| &&
        |<GoodsValue>{ material }</GoodsValue>| &&
*        |<NoofPackage>{ pack-zpackage }</NoofPackage>| &&
        |<GrossWt>{ gross }</GrossWt>| &&
        |<NetWt>{ pack-delievered_quantity }</NetWt>| &&
        |<COntainerNo>{ gendata-containerno }</COntainerNo>| &&
        |<ESealNo>{ gendata-rfidno }</ESealNo>| &&
        |</Row2>| .

        grosstot = grosstot + gross .
        netwt = netwt + pack-delievered_quantity.
*        package = package + pack-zpackage.


        CONCATENATE xsml lv_xml2 INTO  xsml .
        CLEAR : material .
      ENDLOOP .





      DATA(lv_xml3) = |<Row3>| &&
      |<TotGoodsValue>{ billhead-totalnetamount + billhead-totaltaxamount  }</TotGoodsValue>| &&
      |<Totpackage>{ package }</Totpackage>| &&
      |<TotGross>{ grosstot }</TotGross>| &&
      |<TotNet>{ netwt }</TotNet>| &&
      |</Row3>| &&
      |</Table1>| &&
      |</form1>| .
      CONCATENATE lv_xml1 xsml lv_xml3 INTO lv_xml .

    ENDIF.
DATA(lv_date) = cl_abap_context_info=>get_system_date( ).

    IF form = 'nhavasheva'  .
      temp = 'NHAVASHEVA_EXIM/NHAVASHEVA_EXIM'.

lv_xml =
|<form1>| &&
|<Page1>| &&
|<Subform1/>| &&
|<Subform2>| &&
|<Header>| &&
|<date1>DATE : { lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) } </date1>| &&
|<TextField20>PODDAR PIGMENTS LIMITED</TextField20>| &&
|<TextField2>{ pan } & { cin }</TextField2>| &&
|<TextField3></TextField3>| &&
|<TextField4>{ gst }</TextField4>| &&
|<TextField5></TextField5>| &&
|<FactoryAdd>{ addr1 } { addr2 }</FactoryAdd>| &&
|<DateField1> { lv_date+6(2) }/{ lv_date+4(2) }/{ lv_date+0(4) } </DateField1>| &&
|<InvoicDate> SGST, Circle-H, Jaipur-II, Jaipur </InvoicDate>| &&
|<TextField9></TextField9>| &&
|<TextField10></TextField10>| &&
|<TextField11>{ gendata-docno } Dated { dist-CreationDate+6(2) }/{ dist-CreationDate+4(2) }/{ dist-CreationDate+0(4) }</TextField11>| &&
|<TextField12>{ calculatproj-Totalqty }</TextField12>| &&
|<street1>{ it_itabl-Street1 }</street1>| &&
|<street2>{ it_itabl-Street2 }</street2>| &&
|<street3>{ it_itabl-Street3 }</street3>| &&
|<street4>{ it_itabl-Country }</street4>| &&
|</Header>| &&
|<table>| &&
|<Table1>| &&
|<Row1/>| &&
|<Row3>| &&
|<ContainerNo>{ gendata-Containerno }</ContainerNo>| &&
|<SIZE>{ gendata-Containersize }</SIZE>| &&
|<RFIDNO>{ gendata-RfidNo }</RFIDNO>| &&
|<ShippingNo>{ gendata-Lineseal }</ShippingNo>| &&
|<Totpackage>{ calculatproj-Totalpackages }</Totpackage>| &&
|</Row3>| &&
|</Table1>| &&
|</table>| &&
|<Text>| &&
|<permissionNo.>  VII-48(38)ICD-KKU/JPR/05/7582 DT.28.12.05</permissionNo.>| &&
|<SelfSealing>  41/2017 CUSTOMS DT.30.10.2017 </SelfSealing>| &&
|</Text>| &&
|<date>| &&
|<poddar>PODDAR PIGMENTS LIMITED</poddar>| &&
|<last>{ gendata-Authorisedsigntory }</last>| &&
|<plant>{ gendata-Designation }</plant>| &&
|</date>| &&
|</Subform2>| &&
|</Page1>| &&
|</form1>| .


    ENDIF.


    IF  form = 'vgm'  .
      temp = 'VGM_EXIM/VGM_EXIM'.

      DATA totwt  TYPE string.
      SELECT SINGLE Totalnetqty, Totalgrosswt FROM YEXIM_CALCULATPROJ
      WHERE Docno = @variable INTO @DATA(calculation).

      lv_xml =
         |<form1>| &&
         |<Row1/>| &&
*         |<RegistLicenceNo>0591047314</RegistLicenceNo>| &&
         |<NameDesignation>{ gendata-authorisedsigntory }  { gendata-designation }</NameDesignation>| &&
*         |<ContactDetails>9314417793</ContactDetails>| &&
         |<ContainerNo>{ gendata-containerno }</ContainerNo>| &&
         |<ContainerSize>{ gendata-containersize }</ContainerSize>| &&
         |<CSCplant> { gendata-maxperwt } </CSCplant>| &&
*         |<Cell3></Cell3>| &&
         |<TaraWeight>{ it_itabl-Weightofcontainer } Kgs </TaraWeight>| &&
         |<Table2>| &&
         |<Row1>| &&
**         |<NAMEYARN>{ desc }</NAMEYARN>| &&
         |<GrossWt>{ calculation-Totalgrosswt } Kgs </GrossWt>| &&
         |</Row1>| &&
         |</Table2>| &&
         |<TotalWt>{ calculation-Totalnetqty } Kgs </TotalWt>| &&
         |<DateTime>{ sy-datum+6(2) }/{ sy-datum+4(2) }/{ sy-datum+0(4) }</DateTime>| &&
         |<SlipNo>{ gendata-weighslip }</SlipNo>| &&
         |<Cell3> NORMAL</Cell3>| &&
         |<Cell4> NA</Cell4>| &&
         |<Name>{ it_itabl-Authorisedsigntory }</Name>| &&
*         |<DateField1>{ billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DateField1>| &&
         |<DateField1>{ sy-datum+6(2) }/{ sy-datum+4(2) }/{ sy-datum+0(4) }</DateField1>| &&
         |<name1>{ name1 }</name1>| &&
         |<DIV>{ billhead-Division }</DIV>| &&
         |<addr1>{ addr1 }</addr1>| &&
         |<addr2>{ addr2 }</addr2>| &&
         |<tele>TEL: { tele }</tele>| &&
         |<email>Email: { email }</email>| &&
         |<website>Website: { website }</website>| &&
         |<gst>GSTIN. { gst }</gst>| &&
         |<cin>CIN. { cin }</cin>| &&
         |</form1>|.
.
    ENDIF .


    DATA: port TYPE string.

    IF gendata1-portofloading = '01' .
      port = 'PIPAVAV' .
    ELSEIF  gendata1-portofloading =  '02' .
      port = 'NHAVA SHEVA,INDIA' .
    ELSEIF gendata1-portofloading =  '03' .
      port = 'J.N.P.T MUMBAI' .
    ELSEIF gendata1-portofloading =  '04' .
      port = 'MUNDRA' .
    ELSEIF gendata1-portofloading =  '05' .
      port = 'PETRA POLE' .
    ELSEIF gendata1-portofloading =  '06' .
      port =  'ANY PORT OF INDIA' .
    ELSEIF gendata1-portofloading =  '07' .
      port = 'HAZIRA PORT' .
    ELSEIF gendata1-portofloading =  '08' .
      port = 'MUMBAI AIRPORT' .
    ELSEIF gendata1-portofloading =  '09' .
      port = 'ICD MANDIDEEP' .
    ELSEIF gendata1-portofloading =  '10' .
      port = 'IGI, DELHI, INDIA' .
    ELSEIF gendata1-portofloading =  '11' .
      port = 'NSICT, INDIA' .
    ELSEIF gendata1-portofloading =  '12' .
      port = 'GTI, INDIA' .
    ELSEIF gendata1-portofloading =  '13' .
      port = 'KOLKATA PORT INDIA' .
    ELSEIF gendata1-portofloading =  '14' .
      port = 'BHILWARA/INDIA' .
    ELSEIF gendata1-portofloading =  '15' .
      port = 'VISHAKHAPATNAM' .
    ELSEIF gendata1-portofloading =  '16' .
      port = 'ATTARI BORDER' .
    ELSEIF gendata1-portofloading =  '17' .
      port = 'JOGBANI ' .
    ELSEIF gendata1-portofloading =  '18' .
      port = ' VIZAG PORT '  .
    ELSEIF gendata1-portofloading =  '19' .
      port = 'TAMOT,RAISEN M.P'  .
    ELSEIF gendata1-portofloading =  '20' .
      port = 'SONAULI '  .
    ELSEIF gendata1-portofloading =  '21' .
        port = 'ICD POWARKHEDA' .
    ELSEIF gendata1-portofloading =  '22' .
        port = 'TUTICORIN ' .
      ENDIF .

SELECT SINGLE * FROM zpregen_exim WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA).
SELECT SINGLE * FROM YCONSIGNEDATA_PR1 WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA1).
SELECT SINGLE * FROM YEXIM_CALCULATPROJ WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA2).
SELECT SINGLE * FROM ydraft_bl_cds WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA3).

    IF form = 'bldraft'  .

      temp = 'BL_DRAFT_EXIM/BL_DRAFT_EXIM' .


      lv_xml =   |<form1>| &&
    |<Subform1>| &&
       |<BOOKING_NO></BOOKING_NO>| &&
    |</Subform1>| &&
    |<Subform2>| &&
       |<Subform3>| &&
          |<Subform4>| &&
             |<TextField1>{ it_itabl-Exportname1 }</TextField1>| &&
             |<TextField2>{ it_itabl-Street1 }</TextField2>| &&
             |<TextField3>{ it_itabl-Street2 }</TextField3>| &&
             |<TextField4>{ it_itabl-Street3 }</TextField4>| &&
             |<TextField5>{ it_itabl-Country }</TextField5>| &&
             |<TextField6>Website: { website }</TextField6>| &&
             |<TextField7>Telephone Nos.: { tele }</TextField7>| &&
             |<TextField8>CIN No.: { cin }</TextField8>| &&

          |</Subform4>| &&
          |<Subform5>| &&
             |<EXPORT_REFERENCES></EXPORT_REFERENCES>| &&
          |</Subform5>| &&
       |</Subform3>| &&
       |<Subform6>| &&
         |<CONSIGNEE>{ considata1ps-Conslctoname }</CONSIGNEE>| &&
           |<street1>{ considata1ps-Conslctostreet1 }</street1>| &&
           |<street2>{ considata1ps-Conslctostreet2 }</street2>| &&
           |<street3>{ considata1ps-Conslctostreet3 }</street3>| &&
           |<city>{ considata1ps-Conslctocity }</city>| &&
           |<country>{ considata1ps-Conslctocountry }</country>| &&
           |<taxid>{ considata1-taxid }</taxid>| &&
          |<FORWARDING_AGENT></FORWARDING_AGENT>| &&
       |</Subform6>| &&
       |<Subform7>| &&
           |<NOTIFY>{ considata1ps-Notifyname }</NOTIFY>| &&
           |<street1b>{ considata1ps-Notifystreet1 }</street1b>| &&
           |<street2b>{ considata1ps-Notifystreet2 }</street2b>| &&
           |<street3b>{ considata1ps-Notifystreet3 }</street3b>| &&
           |<cityb>{ considata1ps-Notifycity }</cityb>| &&
           |<countryb>{ considata1ps-Notifycountry }</countryb>| &&
           |<taxidb>{ considata1-taxid }</taxidb>| &&
        |<ALSO_NOTIFY>{ considata1ps-notify2name }</ALSO_NOTIFY>| &&
           |<street1c>{ considata1ps-notify2street1 }</street1c>| &&
           |<street2c>{ considata1ps-notify2street2 }</street2c>| &&
           |<street3c>{ considata1ps-notify2street3 }</street3c>| &&
              |<cityc>{ considata1ps-notify2city }</cityc>| &&
           |<countryc>{ considata1ps-notify2country }</countryc>| &&
           |<taxidc></taxidc>| &&
       |</Subform7>| &&
       |<Subform8>| &&
          |<VESSEL>{ it_itabl-Vesselno }</VESSEL>| &&
          |<PROFORMMA>{ it_itabl-Peformano }</PROFORMMA>| &&
          |<INVOICE_NO.>{ it_itabl-Peformadate+6(2) }/{ it_itabl-Peformadate+4(2) }/{ it_itabl-Peformadate+0(4) }</INVOICE_NO.>| &&
          |<SHIPPING_NO></SHIPPING_NO>| &&
          |<PLACE_OF_RECEIPT>{ gendata1-portofloading }</PLACE_OF_RECEIPT>| &&
          |<PORT_OF_LOADING> { it_itabl-Portofloading } </PORT_OF_LOADING>| &&
          |<PORT_OF_DISCHARGE>{ it_itabl-Portofdischarge }</PORT_OF_DISCHARGE>| &&
          |<PLACE_OF_DELIVERY>{ it_itabl-incotermslocation }</PLACE_OF_DELIVERY>| &&
       |</Subform8>| &&
       |<Subform9>| &&
          |<CONTAINER_NO>{ it_itabl-Containerno }</CONTAINER_NO>| &&
          |<CUSTOM_SEAL_NO>{ gendata1-rfidno }</CUSTOM_SEAL_NO>| &&
          |<LINE_SEAL_NO>{ it_itabl-lineseal }</LINE_SEAL_NO>| &&
       |</Subform9>| &&
       |<Subform10>| &&
                    |<Table1>| &&
                    |<Row1/>|
                      .

*      SELECT * FROM ydraft_bl_cds WHERE docno = @variable INTO TABLE @DATA(draft2).
**      DATA: matnr TYPE ydraft_bl_cds-material.
**      LOOP AT draft2 INTO DATA(wa_draft2).
*        "  IF sy-tabix = 1.
*        SELECT SUM( totalgrosswt ) AS totalgrosswt,
*               SUM( totalnetqty ) AS totalnetqty FROM yexim_calculatproj WHERE docno = @wa_draft2-docno INTO @DATA(calculatproj2).
*        " ENDIF.
*        SELECT SINGLE totalpackages FROM yexim_calculatproj WHERE docno = @wa_draft2-docno INTO @DATA(totalpack).


*        IF wa_draft2-material NE matnr.
*variable = |{ variable ALPHA = out }|.


SELECT * FROM  yeinvoice_cdss  as a  WHERE billingdocument = @lv_billingdoc   INTO TABLE @DATA(IT1).
SORT it1 BY billingdocumentitem.
DELETE ADJACENT DUPLICATES FROM it1 COMPARING billingdocumentitem.
DATA(lv_first_row) = abap_true.

LOOP AT it1 INTO DATA(WA_ITEM1).

SELECT SINGLE * FROM  I_BillingDocumentItem  WHERE billingdocument = @lv_billingdoc
and BillingDocumentItem = @WA_ITEM1-BillingDocumentItem
and Batch is NOT INITIAL INTO @DATA(amountt).

          data : LONGTEXT type string .
IF  WA_ITEM1-DistributionChannel = '50'.

data : HSNCODE type string .

IF HSNCODE <> ''.
WA_ITEM1-Hsncode = HSNCODE.
ENDIF.
ENDIF.

IF LONGTEXT = '' AND WA_ITEM1-BillingDocumentType = 'F2'.
LONGTEXT = WA_ITEM1-MaterialDescription.
ENDIF.

IF WA_ITEM1-BillingDocumentType <> 'F2'.
DATA(MATDES) = WA_ITEM1-MaterialDescription.
ENDIF.

  IF lv_first_row = abap_true.
          lv_xml = lv_xml &&
                    |<Row2>| &&
                    |<LOT_NO>{ ldata-containerno }</LOT_NO>| &&
*                    |<NUMBER_OF>{ calculatprojvs-Totalpackages }</NUMBER_OF>| &&
                    |<NUMBER_OF>{ ldata2-Totalpackages } { ldata2-Typeofpackages }</NUMBER_OF>| &&
*                    |</Row1>| &&
*                    |<Row2>| &&
*                    |<PACKAGESS>{ calculatprojvs-Typeofpackages }</PACKAGESS>| &&
*                 |</Row2>| &&
*                 |</Table3>| &&
                 |<DESCRIPTION_OF_GOODS>{ LONGTEXT }</DESCRIPTION_OF_GOODS>| &&
                 |<GROSS_WT>{ amountt-ItemGrossWeight }</GROSS_WT>| &&
                 |<NET_WT>{ amountt-ItemNetWeight }</NET_WT>| &&
                 |<CBM>{ wa_item1-Hsncode }</CBM>| &&
                 |</Row2>| .
    lv_first_row = abap_false.
        ELSE.
        lv_xml = lv_xml &&
                    |<Row2>| &&
                    |<LOT_NO></LOT_NO>| &&
*                    |<NUMBER_OF>{ calculatprojvs-Totalpackages }</NUMBER_OF>| &&
                    |<NUMBER_OF></NUMBER_OF>| &&
*                    |</Row1>| &&
*                    |<Row2>| &&
*                    |<PACKAGESS>{ calculatprojvs-Typeofpackages }</PACKAGESS>| &&
*                 |</Row2>| &&
*                 |</Table3>| &&
                 |<DESCRIPTION_OF_GOODS>{ LONGTEXT }</DESCRIPTION_OF_GOODS>| &&
                 |<GROSS_WT>{ amountt-ItemGrossWeight }</GROSS_WT>| &&
                 |<NET_WT>{ amountt-ItemNetWeight }</NET_WT>| &&
                 |<CBM>{ wa_item1-Hsncode }</CBM>| &&
                 |</Row2>| .


  ENDIF.
 CLEAR:WA_ITEM1,LONGTEXT.
ENDLOOP.

*          matnr = wa_draft2-material.
*        ELSE.
*          lv_xml = lv_xml &&
*                    |<Row2>| &&
**                    |<Table2>| &&
**                    |<Row1>| &&
**                    |<LOT_NO>{ gendata-Marksndnumber }</LOT_NO>| &&
**                    |</Row1>| &&
**                    |<Row2>| &&
**                    |<carton_no>{ wa_draft2-fromto }</carton_no>| &&
**                    |</Row2>| &&
**                    |</Table2>| &&
*                    |<Table3>| &&
*                    |<Row1>| &&
*                    |<NUMBER_OF></NUMBER_OF>| &&
*                    |</Row1>| &&
*                    |<Row2>| &&
*                    |<PACKAGESS></PACKAGESS>| &&
*                 |</Row2>| &&
*                 |</Table3>| &&
**                 |<DESCRIPTION_OF_GOODS>{ wa_draft2-mdesp }</DESCRIPTION_OF_GOODS>| &&
*                 |<GROSS_WT></GROSS_WT>| &&
*                 |<NET_WT></NET_WT>| &&
*                 |<CBM></CBM>| &&
*                 |</Row2>| .
*        ENDIF.
*        CLEAR: calculatproj2.
*
*      ENDLOOP.






      lv_xml = lv_xml &&


      |</Table1>| &&
               |</Subform10>| &&

      |<Subform11>| &&
         |<ACID>{ gendata1-descgoods }</ACID>| &&
      |</Subform11>| &&
      |<Subform12>| &&
         |<BL_WITHOUT_RATYES></BL_WITHOUT_RATYES>| &&
         |<BL_DATE>{ gendata1-Bldate+8(2) }/{ gendata1-Bldate+5(2) }/{ gendata1-Bldate+0(4) }</BL_DATE>| &&

         |<FRIGHT_CHARGE>{ calculatprojvs-Frightchargetype }</FRIGHT_CHARGE>| &&
         |<ARB_CHRGE></ARB_CHRGE>| &&
      |</Subform12>| &&
      |<Subform13>| &&
         |<SELECT_ONE></SELECT_ONE>| &&
         |<SHIPPED_BOARD></SHIPPED_BOARD>| &&
         |<BOARD_CONTNR></BOARD_CONTNR>| &&
         |<SPECIAL_INSTRUCTION></SPECIAL_INSTRUCTION>| &&
      |</Subform13>| &&
   |</Subform2>| &&
|</form1>|.

    ENDIF.

    IF form = 'prerequisiteform'  .
      temp = 'PREREQUISITE_EXIM/PREREQUISITE_EXIM'.

      SELECT SINGLE * FROM i_deliverydocumentitem WHERE deliverydocument = @iv-delivery_number AND
     deliverydocumentitem = @iv-delivery_number_item INTO @lot   .

      SELECT SINGLE * FROM i_salesdocumentitem WHERE salesdocument = @iv-sddocu AND salesdocumentitem = @wt-sddocuitem INTO @sdata  .

      lv_xml =  |<form1>| &&
                |<Subform1>| &&
                |<Subform3>| &&
                |<date>{ sdata-creationdate }</date>| &&
                |</Subform3>| &&
                |</Subform1>| &&
                |<Subform2>| &&
                |<CUSTOMER>{ wt-customername }</CUSTOMER>| &&
            |<PINO>{ gendata-peformano }{ gendata-peformadate }</PINO>| &&
            |<COUNT></COUNT>| &&
            |<QUALITY></QUALITY>| &&
            |<MATERIAL>{ sdata-material }</MATERIAL>| &&
            |<TextField1>{ sdata-quantityisfixed }</TextField1>| &&
            |<conewt>{ sdata-itemweightunit }</conewt>| &&
            |<CONDITION>{ billheaddata-conditionrateratiounit }</CONDITION>| &&
            |<CARTON></CARTON>| &&
            |<REGULAR></REGULAR>| &&
            |<specialrequirment></specialrequirment>| &&
            |<shippingmark>{ gendata-shipmentmark }</shippingmark>| &&
            |<SINGLEYARN></SINGLEYARN>| &&
            |<DOUBLEYARN></DOUBLEYARN>| &&
            |<SINGLEYARNHOS></SINGLEYARNHOS>| &&
            |<TFOYARN></TFOYARN>| &&
            |<CHEESEWINDING></CHEESEWINDING>| &&
            |<WAXEDYARN></WAXEDYARN>| &&
            |<QUALITYSPEC></QUALITYSPEC>| &&
            |<PREVIOUSSUPPLY></PREVIOUSSUPPLY>| &&
            |<OTHERPARAMETER></OTHERPARAMETER>| &&
         |</Subform2>| &&
         |<Subform4/>| &&
      |</form1>| .

    ENDIF.

    IF form = 'billofexchange'  .
      temp = 'BILL_OF_EXCHANGE_EXIM/BILL_OF_EXCHANGE_EXIM'.

*    //  READ TABLE billitemdata INTO  wt INDEX 1 .
*  //   DATA  amt04 TYPE int4.
*     DATA  VJ002 TYPE STRING .

*      amt04 = (  WT-NetAmount ) - ( billhead-TransactionCurrency ).
** billhead-AccountingExchangeRate .
*

      lv_xml =

        |<form1>| &&
     |<Subform1/>| &&
     |<Subform2>| &&
        |<REF>{ wt-billingdocument }</REF>| &&
        |<BLDATE>{ gendata1-Bldate }</BLDATE>| &&
        |<DATED>{ billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DATED>| &&
     |</Subform2>| &&
     |<Subform3>| &&
*        |<CREDITNO>{ billhead-yy1_lcno_bdh }</CREDITNO>| &&
*        |<DATED>{ billhead-yy1_lcdate_bdh+6(2) }/{ billhead-yy1_lcdate_bdh+4(2) }/{ billhead-yy1_lcdate_bdh+0(4) }</DATED>| &&
        |<USD>{ wt-netamount }</USD>| &&
        |<REMARK>{ calculatprojvs-Boeheader }</REMARK>| &&
     |</Subform3>| &&
     |<Subform4>| &&
        |<ADDRESS>{ calculatprojvs-Boebanksname }</ADDRESS>| &&
        |<numvam11>{ wt-netamount }</numvam11>| &&
        |<WORDS_AMT>{ wt-netamount }</WORDS_AMT>| &&
        |<SMPL>{ wt-billingdocument }</SMPL>| &&
        |<DATED>{ billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DATED>| &&
        |<NUMC_AMT>{ wt-netamount }</NUMC_AMT>| &&
        |<pay>{ calculatprojvs-Boeitem }</pay>| &&
        |<currency>{ calculatprojvs-Doccurrency }</currency>| &&
         |<CURRYNVY>{ calculatprojvs-Doccurrency }</CURRYNVY>| &&
     |</Subform4>| &&
     |<Subform5>| &&
        |<bankdetail>{ calculatprojvs-Draweesiftcode }</bankdetail>| &&
     |</Subform5>| &&
     |<Subform6>| &&
      |<editing></editing>| &&
   |</Subform6>| &&

****************************************

    |<Subform1a/>| &&
     |<Subform2a>| &&
        |<REFa>{ wt-billingdocument }</REFa>| &&
        |<BLDATEa>{ gendata1-Bldate }</BLDATEa>| &&
        |<DATEDa>{ billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DATEDa>| &&
     |</Subform2a>| &&
     |<Subform3a>| &&
*        |<CREDITNOa>{ billhead-yy1_lcno_bdh }</CREDITNOa>| &&
*        |<DATEDa>{ billhead-yy1_lcdate_bdh+6(2) }/{ billhead-yy1_lcdate_bdh+4(2) }/{ billhead-yy1_lcdate_bdh+0(4) }</DATEDa>| &&
        |<USDa>{ wt-netamount }</USDa>| &&
        |<REMARK2>{ calculatprojvs-Boeheader }</REMARK2>| &&
     |</Subform3a>| &&
     |<Subform4a>| &&
        |<ADDRESSa>{ calculatprojvs-Boebanksname }</ADDRESSa>| &&
        |<numvam11a>{ wt-netamount }</numvam11a>| &&
        |<WORDS_AMTa>{ wt-netamount }</WORDS_AMTa>| &&
        |<SMPLa>{ wt-billingdocument }</SMPLa>| &&
        |<DATEDa>{ billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DATEDa>| &&
        |<NUMC_AMTa>{ wt-netamount }</NUMC_AMTa>| &&
        |<paya>{ calculatprojvs-Boeitem }</paya>| &&
        |<currency1>{ calculatprojvs-Doccurrency }</currency1>| &&
        |<hiddencurry>{ calculatprojvs-Doccurrency }</hiddencurry>| &&
     |</Subform4a>| &&
     |<Subform5a>| &&
        |<bankdetaila>{ calculatprojvs-Draweesiftcode }</bankdetaila>| &&
     |</Subform5a>| &&
     |<Subform6a>| &&
      |<editinga></editinga>| &&
   |</Subform6a>| &&
  |</form1>| .

    ENDIF.

    IF form = 'countryoforigin'  .
      temp = 'COUNTRY_OF_ORIGIN_EXIM/COUNTRY_OF_ORIGIN_EXIM'.
      lv_xml =  |<form1>| &&
                 |<Subform1>| &&
                 |<invoiceno>{ wt-billingdocument }</invoiceno>| &&
                 |<date>{  billhead-billingdocumentdate }</date>| &&
                 |</Subform1>| &&
           |<Subform2>| &&
           |<CREDITNO>{ calculatprojvs-Lcno }</CREDITNO>| &&
           |<DATED>{ calculatprojvs-Lcdate }</DATED>| &&
           |<BANK>{ calculatprojvs-Issueingbank }</BANK>| &&
           |</Subform2>| &&
           |<Subform3>| &&
           |<BOX1>{ GENDATA1-Billofexchange }</BOX1>| &&
           |</Subform3>| &&
*           |<Subform3/>| &&
*           |<Subform4>| &&
          |<Subform4>| &&
          |<BOX2>{ gendata1-Detailsbylc }</BOX2>| &&
          |</Subform4>| &&
          |<Subform5/>| &&
          |</form1>| .
    ENDIF.

    IF form = 'certificate5050'  .
      temp = 'BENIFICIARY_50_50_EXIM/BENIFICIARY_50_50_EXIM'.

      lv_xml =
      |<form1>| &&
      |<Subform1/>| &&
      |<Subform2>| &&
      |<INVOICENUMBERANDDATE>Ego ille</INVOICENUMBERANDDATE>| &&
      |<LCNUMBER>Si manu vacuas</LCNUMBER>| &&
      |<APPLICATIONREFERANCE>Apros tres et quidem</APPLICATIONREFERANCE>| &&
      |</Subform2>| &&
      |<Subform3/>| &&
      |<Subform4/>| &&
      |</form1>|.

    ENDIF.

    IF form = 'certificateforh'  .
      temp = 'BENIFICIARY_FORTH_EXIM/BENIFICIARY_FORTH_EXIM'.


    ENDIF.

    IF form = 'certificatemanufacturing'  .
      temp = 'Certificate_Manufacturing_Exim/Certificate_Manufacturing_Exim'.
      lv_xml =
     |<form1>| &&
                 |<Subform1>| &&
                 |<invoiceno>{ wt-billingdocument }</invoiceno>| &&
                 |<date>{  billhead-billingdocumentdate }</date>| &&
                 |</Subform1>| &&
           |<Subform2>| &&
           |<CREDITNO>{ calculatprojvs-Lcno }</CREDITNO>| &&
           |<DATED>{ calculatprojvs-Lcdate }</DATED>| &&
           |<BANK>{ calculatprojvs-Issueingbank }</BANK>| &&
           |</Subform2>| &&
           |<Subform3>| &&
           |<BOX1>{ GENDATA1-Nonegotiable }</BOX1>| &&
           |</Subform3>| &&
*           |<Subform3/>| &&
*           |<Subform4>| &&
          |<Subform4>| &&
          |<BOX2>{ GENDATA1-Detailsbylc }</BOX2>| &&
          |</Subform4>| &&
          |<Subform5/>| &&
          |</form1>| .


    ENDIF.




    DATA: lv_billingdocument       TYPE i_billingdocumentitem-billingdocument,
      lv_ref_doc_delivery      TYPE i_deliverydocumentitem-ReferenceSDDocument,
      lv_ref_doc_sales         TYPE i_salesdocumentitem-ReferenceSDDocument,
      lv_final_ref_doc_DATE    TYPE I_SalesQuotation-CreationDate,
      lv_ref_doc_contract      TYPE i_salescontractitem-ReferenceSDDocument.



  SELECT SINGLE ReferenceSDDocument
  FROM I_BillingDocumentItem
  WHERE BillingDocument = @lv_billingdoc1
  INTO @lv_ref_doc_delivery.


  SELECT SINGLE ReferenceSDdocument
  FROM I_DeliveryDocumentItem
  WHERE DeliveryDocument = @lv_ref_doc_delivery
  INTO @lv_ref_doc_sales.


  SELECT SINGLE ReferenceSDdocument
  FROM I_SalesDocumentItem
  WHERE SalesDocument = @lv_ref_doc_sales
  INTO @lv_ref_doc_contract.


  SELECT SINGLE ReferenceSDdocument
  FROM I_SalesContractItem
  WHERE SalesContract = @lv_ref_doc_contract
  INTO @DATA(lv_final_ref_doc).


  SELECT SINGLE CREATIONDATE
  FROM I_SalesQuotation
  WHERE SalesQuotation = @lv_final_ref_doc
  INTO @lv_final_ref_doc_DATE.


    IF form = 'certificateforh'  .
      temp = 'BENIFICIARY_FORTH_EXIM/BENIFICIARY_FORTH_EXIM'.
      lv_xml =
      |<form1>| &&
      |<Subform1>| &&
      |<INVOICENO>{ gendata-DocNo }</INVOICENO>| &&
      |<DATED>{ billhead2-BillingDocumentDate }</DATED>| &&
      |</Subform1>| &&
      |<Subform2>| &&
      |<LCNO>Apros tres et quidem</LCNO>| &&
      |<DATE>Mirum est</DATE>| &&
      |</Subform2>| &&
      |<Subform3>| &&
*      |<WEIGHT>{ calculatproj-Totalgrosswt }</WEIGHT>| &&
*      |<PINO>{ calculatproj-Totalgrosswt }{ calculatproj-Totalgrosswt }</PINO>| &&
*      |<PINODATE>{ gendata-Peformadate }</PINODATE>| &&
*      |<PONO></PONO>| &&
*      |<PODATE></PODATE>| &&

        |<WEIGHT>{ calculatproj-Totalqty }</WEIGHT>| &&
        |<PINO>{ lv_final_ref_doc }</PINO>| &&
        |<PINODATE>{ lv_final_ref_doc_DATE }</PINODATE>| &&
        |<PONO>{ billingdocument-PurchaseOrderByCustomer }</PONO>| &&
        |<INVOICENO>{ gendata-Docno }</INVOICENO>| &&
        |<INVOICEDATE>{ billhead2-BillingDocumentDate }</INVOICEDATE>| &&
        |<BLNO>{ gendata-Blno }</BLNO>| &&
        |<DATED>{ gendata-Bldate }</DATED>| &&
        |<LCNO>{ calculatproj-Lcno }</LCNO>| &&
        |<LCDATE>{ calculatproj-Lcdate1 }</LCDATE>| &&
        |<bank>{ calculatproj-Issueingbank }</bank>| &&

      |</Subform3>| &&
      |<Subform5>| &&
      |<p2>{ text }</p2>| &&
      |</Subform5>| &&
      |<Subform4>| &&

      |<currentdate>{ sy-datum }</currentdate>| &&
      |</Subform4>| &&
      |</form1>|.

    ENDIF.

    IF form = 'certificatenonplastic'  .
      temp = 'BENIFICIARY_NONPLASTIC/BENIFICIARY_NONPLASTIC '.
      lv_xml =
   |<form1>| &&
   |<Subform1/>| &&
   |<Subform2>| &&
   |<TextField1>Ego ille</TextField1>| &&
   |<TextField2>Si manu vacuas</TextField2>| &&
   |<TextField3>Apros tres et quidem</TextField3>| &&
   |<TextField4>Mirum est</TextField4>| &&
   |<TextField5>Licebit auctore</TextField5>| &&
   |</Subform2>| &&
   |<Subform3>| &&
   |<FCIU>Proinde</FCIU>| &&
   |<INVOICENUMBER>Am undique</INVOICENUMBER>| &&
   |<DTD>Ad retia sedebam</DTD>| &&
   |<LCNUMBER>Vale</LCNUMBER>| &&
   |<DTD>Ego ille</DTD>| &&
   |<BAGSTOTAL>Si manu vacuas</BAGSTOTAL>| &&
   |<PEPLASTIC>Apros tres et quidem</PEPLASTIC>| &&
   |<PPPLASTIC>Mirum est</PPPLASTIC>| &&
   |<TOTAL>Licebit auctore</TOTAL>| &&
   |<INDIAAT>Proinde</INDIAAT>| &&
   |</Subform3>| &&
   |</form1>|.

    ENDIF.

*DATA(lv_date) = cl_abap_context_info=>get_system_date( ).
    IF form = 'shippingadvice'  .
      temp = 'SHIPPING_ADVICE_EXIM/SHIPPING_ADVICE_EXIM'.

      lv_xml =  |<form1>| &&
   |<Subform1>| &&
      |<ADDRESS1>| &&
        |<COMNAME>{ considata1ps-Billtobuyrname }</COMNAME>| &&
         |<ADD1>{ considata1ps-Billtostreet1 }</ADD1>| &&
         |<ADD2>{ considata1ps-Billtostreet2 }</ADD2>| &&
         |<ADD3>{ considata1ps-Billtostreet3 }</ADD3>| &&
         |<ADD4>{ considata1ps-Billtocity }, { considata1ps-Billtocountry } </ADD4>| &&
      |</ADDRESS1>| &&
      |<DATE>| &&
         |<DATE>{ lv_date }</DATE>| &&
      |</DATE>| &&
   |</Subform1>| &&
   |<Subform2>| &&
      |<COVERNO>{ LDATA2-Totalqty }</COVERNO>| &&
      |<COVERDATE>{ ldata-peformano }</COVERDATE>| &&
      |<DOCUMENTRYNO>{ variable }</DOCUMENTRYNO>| &&
      |<DOCUMENTRYDATE>{ ldata-peformadate }</DOCUMENTRYDATE>| &&
      |<Table1>| &&
      |<HeaderRow/>| .

      SELECT * FROM  yeinvoice_cdss  as a  WHERE billingdocument = @lv_billingdoc   INTO TABLE @DATA(IT2).
SORT it2 BY billingdocumentitem.
DELETE ADJACENT DUPLICATES FROM it2 COMPARING billingdocumentitem.
*DATA(lv_first_row) = abap_true.

LOOP AT it2 INTO DATA(WA_ITEM2).

SELECT SINGLE * FROM  I_BillingDocumentItem  WHERE billingdocument = @lv_billingdoc
and BillingDocumentItem = @WA_ITEM2-BillingDocumentItem
and Batch is NOT INITIAL INTO @DATA(amount2).

          data : LONGTEXT1 type string .
IF  WA_ITEM2-DistributionChannel = '50'.

*data : HSNCODE type string .

IF HSNCODE <> ''.
WA_ITEM2-Hsncode = HSNCODE.
ENDIF.
ENDIF.

IF LONGTEXT1 = '' AND WA_ITEM2-BillingDocumentType = 'F2'.
LONGTEXT1 = WA_ITEM2-MaterialDescription.
ENDIF.

IF WA_ITEM2-BillingDocumentType <> 'F2'.
DATA(MATDESH) = WA_ITEM2-MaterialDescription.
ENDIF.

        lv_xml = lv_xml &&
      |<Row1>| &&
      |<DESCRIPTION>{ amount2-BillingDocumentItemText }</DESCRIPTION>| &&
      |<PCODE>{ amount2-Material }</PCODE>| &&
      |<QUANTITY>{ amount2-BillingQuantity }</QUANTITY>| &&
      |</Row1>| .

      ENDLOOP.

        lv_xml = lv_xml &&
   |</Table1>| &&
   |</Subform2>| &&
   |<text/>| &&
   |<Subform3>| &&
   |<COMMERCIALINVOICE>:   { variable } - { billingdocument-BillingDocumentDate+6(2) }/{ billingdocument-BillingDocumentDate+4(2) }/{ billingdocument-BillingDocumentDate+0(4) }</COMMERCIALINVOICE>| &&
   |<BILLOFLADINGNO>:   </BILLOFLADINGNO>| &&
   |<BILLOFLADINGDATE>:   </BILLOFLADINGDATE>| &&
   |<VESSELNAMEVOYNO>:   { LDATA-vesselno }</VESSELNAMEVOYNO>| &&
   |<QUANTITY>:   { LDATA2-Totalqty } KG</QUANTITY>| &&
   |<CONTAINERNUMBER>:   { LDATA-containerno }</CONTAINERNUMBER>| &&
   |<KINDOFPACKAGES>:   { LDATA2-Totalpackages } { ldata2-Typeofpackages }</KINDOFPACKAGES>| &&
   |<LRNUMBERDATE>:   { LDATA-lrno } - { ldata-lr_date+6(2) }/{ ldata-lr_date+4(2) }/{ ldata-lr_date+0(4) }</LRNUMBERDATE>| &&
   |<TRANSPORTERNAME>:   { LDATA2-Shippingline }</TRANSPORTERNAME>| &&
   |<PORTOFLOADING>:   { ldata-portofloading } - { ldata2-Etddate }</PORTOFLOADING>| &&
   |<PORTOFDISCHARGE>:   { ldata-portofdischarge } - { ldata2-Etadate }</PORTOFDISCHARGE>| &&
   |<SHIPMENTVALUE>:   { LDATA2-Invoiceamount } { LDATA2-Doccurrency }</SHIPMENTVALUE>| &&
   |<SHIPPINGAGENTNAME>:   </SHIPPINGAGENTNAME>| &&
      |<box1>{ GENDATA1-Detailsbylc }</box1>| &&
  |</Subform3>| &&
   |<Subform4/>| &&
|</form1>| .

    ENDIF.




    IF form = 'quantityandweight'  .
      temp = 'QUANTITY_EXIM/QUANTITY'.
      lv_xml =

   |<form1>| &&
   |<Subform1>| &&
   |<INVOICENO></INVOICENO>| &&
   |<DATED></DATED>| &&
   |<CONTARCTNO></CONTARCTNO>| &&
   |<CREDITNO></CREDITNO>| &&
   |<DATED></DATED>| &&
   |</Subform1>| &&
   |<Subform2>| &&
   |<Table1>| &&
   |<HeaderRow/>| &&
   |<Row1>| &&
   |<CONTAINERNO></CONTAINERNO>| &&
   |<LOTNO></LOTNO>| &&
   |<TOTNOCARTON></TOTNOCARTON>| &&
   |<NETWTCONS></NETWTCONS>| &&
   |<NETWTCARTONS></NETWTCARTONS>| &&
   |<GROSSWTCARTONS></GROSSWTCARTONS>| &&
   |<TOTNETWT></TOTNETWT>| &&
   |<TOTGROSSWT></TOTGROSSWT>| &&
   |<PACKCONDITION></PACKCONDITION>| &&
   |</Row1>| &&
   |<FooterRow>| &&
   |<TOT1></TOT1>| &&
   |<TOTNETWT></TOTNETWT>| &&
   |<TOTGROSSWT></TOTGROSSWT>| &&
   |</FooterRow>| &&
   |</Table1>| &&
   |</Subform2>| &&
   |<Subform3/>| &&
   |</form1>|.

    ENDIF.
    IF form = 'weightlist'  .
      temp = 'WEIGHT_LIST_EXIM/WEIGHT_LIST_EXIM'.
**      lv_xml =
DATA(lv_xml4) =
 |<form1>| &&
 |<Subform1>| &&
 |<SubForm>| &&
 |<Subform2>| &&
 |<invoiceno> { considata-docno } </invoiceno>| &&
 |<DTD>{  billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DTD>| &&
 |<Consignee>{  considata-constoname }{ considata-constostreet1 }{ considata-constostreet2 }{ considata-constostreet3 }{ considata-constocity }{ considata-constocountry }</Consignee>| &&
 |<PINO>{ gendata-peformano }</PINO>| &&
 |<DTD>{  billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DTD>| &&
 |<BILLOFLADINGNO>{ gendata-Blno }</BILLOFLADINGNO>| &&
 |<DTD>{ gendata-Bldate }</DTD>| &&
 |<LCREF></LCREF>| &&
 |</Subform2>| &&
 |<Subform3>| &&
 |<PORTOFDIS>{ gendata-incotermslocation }</PORTOFDIS>| &&
 |<PORTY>{ gendata-Portofloading }</PORTY>| &&
 |<LINESEAL>{ gendata-lineseal }</LINESEAL>| &&
 |<CUSTOMSEALNO>{ gendata-rfidno }</CUSTOMSEALNO>| &&
 |<CONTAINERNO>{ gendata-containerno }</CONTAINERNO>| &&
 |<Documentry>{ calculatproj-Lcno }</Documentry>| &&
 |<DATED>{ calculatproj-Lcdate }</DATED>| &&
 |</Subform3>| &&
 |</SubForm>| &&
 |<Table1>| &&
 |<Row1/>| .
* SELECT SINGLE * FROM i_salesdocumentitem WHERE salesdocument = @iv-sddocu AND salesdocumentitem = @iv-sddocuitem INTO @DATA(sdata)  .

SELECT * FROM ydraft_bl_cds WHERE docno = @variable INTO TABLE @DATA(draft5).

 LOOP AT DRAFT5 INTO DATA(IV1).

SELECT SINGLE * FROM ydraft_bl_cds WHERE docno = @variable INTO @draft.

SELECT SINGLE * FROM i_salesdocumentitem WHERE salesdocument = @iv-sddocu AND salesdocumentitem = @wt-sddocuitem INTO  @sdata  .

      SELECT SINGLE * FROM  yeinvoice_cdss   WHERE billingdocument = @IV1-docno and BillingDocumentItem = @iv1-Litem
             INTO  @DATA(cout1) .

        SELECT COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @cout1-delivery_number AND
               deliverydocumentitem =  @cout1-delivery_number_item AND batch IS NOT INITIAL INTO @DATA(count1)   .

        SELECT SINGLE actualdeliveryquantity FROM  i_deliverydocumentitem WHERE deliverydocument = @cout1-delivery_number AND
               deliverydocumentitem =  @cout1-delivery_number_item AND batch IS NOT INITIAL INTO @DATA(package2) .

        IF count1 IS INITIAL .
          SELECT COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @cout1-delivery_number AND
               higherlvlitmofbatspltitm =  @cout1-delivery_number_item AND batch IS NOT INITIAL INTO @count1    .

          SELECT SINGLE actualdeliveryquantity FROM i_deliverydocumentitem WHERE deliverydocument = @cout1-delivery_number AND
                 higherlvlitmofbatspltitm =  @cout1-delivery_number_item AND batch IS NOT INITIAL INTO @package2   .
                data  tot1 TYPE int4.


                 tot1 = tot1 + count1.

  ENDIF.
***********************************************TotalNwtkg*******************************************
   SELECT SINGLE * FROM  i_deliverydocumentitem WHERE deliverydocument = @cout1-delivery_number AND
               deliverydocumentitem =  @cout1-delivery_number_item  INTO @DATA(NETWTCARTON1) .
***********************************************TotalNwtkg*******************************************

************************************************TotalGrosswt******************************************
   SELECT SINGLE * FROM  i_deliverydocumentitem WHERE deliverydocument = @cout1-delivery_number AND
               deliverydocumentitem =  @cout1-delivery_number_item AND  batch IS NOT INITIAL INTO @DATA(grodwwt1) .

*   SELECT SINGLE * FROM zpackncds  WHERE
*        lotnumber = @grodwwt1-yy1_lotno_dli AND batch = @grodwwt1-Batch INTO @DATA(matdocdata1)  .
*************************************************TotalGrosswt******************************************




*DATA(PLUS) = gross + '2' .

 DATA(lv_xml5) =
      |<Row2>| &&
      |<DescofGoods>{ IV1-BillingDocumentItemText }</DescofGoods>| &&
      |<LotNo></LotNo>| &&
      |<TotofPallCart>{ count1 }</TotofPallCart>| &&
*      |<NetWtCone>{  sdata-YY1_ConeNetWeight_SDI  }</NetWtCone>| &&
      |<NetWtPallCart>{ package2 }</NetWtPallCart>| &&
*      |<GrossWtkgs>{ matdocdata1-Grosswt }</GrossWtkgs>| &&
      |<TotalNwwt>{  NETWTCARTON1-CumulativeBatchQtyInBaseUnit  }</TotalNwwt>| &&
*      |<TotalGrosswt>{  matdocdata1-Grosswt  }</TotalGrosswt>| &&
      |</Row2>| .

  CONCATENATE xsml lv_xml5 INTO  xsml .
   CLEAR :IV1,draft.
   ENDLOOP.
DATA(LV_XML6) =
      |<Row3>| &&
      |<Tot1></Tot1>| &&
      |<TotNet></TotNet>| &&
      |<TotGross></TotGross>| &&
      |</Row3>| &&
      |</Table1>| &&
      |</Subform1>| &&
      |</form1>|.
**  CONCATENATE xsml lv_xml6 INTO  xsml .
  CONCATENATE lv_xml4 xsml lv_xml6 INTO lv_xml .

    ENDIF.

    IF form = 'weightmeasurelist'  .
      temp = 'WEIGHT_AND_MEASUREMENT_EXIM/WEIGHT_AND_MEASUREMENT_EXIM'.
      lv_xml  =


   |<form1>| &&
   |<Subform1>| &&
   |<Subform2>| &&
   |<invoicenumber>{ considata-docno }</invoicenumber>| &&
   |<DTD>{  billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DTD>| &&
   |<Consignee>{  considata-constoname }{ considata-constostreet1 }{ considata-constostreet2 }{ considata-constostreet3 }{ considata-constocity }{ considata-constocountry }</Consignee>| &&
   |<billofldno>{ gendata-Blno }</billofldno>| &&
   |</Subform2>| &&
   |<Subform3>| &&
   |<Portofdischarge>{ gendata-incotermslocation }</Portofdischarge>| &&
   |<Linesealno>{ gendata-lineseal }</Linesealno>| &&
   |<Esealno>{ gendata-rfidno }</Esealno>| &&
   |<ContainerNo>{ gendata-containerno }</ContainerNo>| &&
   |<Doccrno></Doccrno>| &&
   |<DATED>{  billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DATED>| &&
   |<Proinvoice>{ gendata-peformano }</Proinvoice>| &&
   |<DTD>{  billhead-billingdocumentdate+6(2) }/{ billhead-billingdocumentdate+4(2) }/{ billhead-billingdocumentdate+0(4) }</DTD>| &&
   |</Subform3>| &&
   |<Table1>| .

      SELECT * FROM ydraft_bl_cds  WHERE docno = @variable INTO TABLE @DATA(draft1).

      LOOP AT draft1 INTO DATA(wa_draft).

         SELECT SINGLE * FROM  yeinvoice_cdss   WHERE billingdocument = @wa_draft-docno and BillingDocumentItem = @wa_draft-Litem
             INTO  @DATA(cout) .
        SELECT SINGLE * FROM yexim_calculatproj WHERE docno = @wa_draft-docno INTO @DATA(calculatproj1).



        SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @cout-delivery_number AND
               deliverydocumentitem =  @cout-delivery_number_item AND batch IS NOT INITIAL INTO @DATA(count)   .

        SELECT SINGLE actualdeliveryquantity FROM  i_deliverydocumentitem WHERE deliverydocument = @cout-delivery_number AND
               deliverydocumentitem =  @cout-delivery_number_item AND batch IS NOT INITIAL INTO @DATA(package1) .

        IF count IS INITIAL .
          SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @cout-delivery_number AND
               higherlvlitmofbatspltitm =  @cout-delivery_number_item AND batch IS NOT INITIAL INTO @count    .

          SELECT SINGLE actualdeliveryquantity FROM i_deliverydocumentitem WHERE deliverydocument = @cout-delivery_number AND
                 higherlvlitmofbatspltitm =  @cout-delivery_number_item AND batch IS NOT INITIAL INTO @package1   .


        ENDIF .


        SELECT SINGLE * FROM  i_deliverydocumentitem WHERE deliverydocument = @cout-delivery_number AND
               deliverydocumentitem =  @cout-delivery_number_item  INTO @DATA(NETWTCARTON) .

*        SELECT a~*,
*          000 AS lot
*            FROM i_deliverydocumentitem AS a WHERE deliverydocument = @NETWTCARTON-deliverydocument
*    AND batch IS NOT INITIAL INTO TABLE @DATA(it_itab).


         SELECT SINGLE * FROM  i_deliverydocumentitem WHERE deliverydocument = @cout-delivery_number AND
               deliverydocumentitem =  @cout-delivery_number_item AND  batch IS NOT INITIAL INTO @DATA(grodwwt) .

*         SELECT SINGLE * FROM zpackncds  WHERE
*        lotnumber = @grodwwt-yy1_lotno_dli AND batch = @grodwwt-Batch INTO @DATA(matdocdata)  .
** actualdeliveryquantity

        lv_xml = lv_xml &&
        |<Row2>| &&
        |<Count>{  wa_draft-BillingDocumentItemText }</Count>| &&
        |<Lot></Lot>| &&
        |<Cartonfrto></Cartonfrto>| &&
        |<Totalcartons>{ count }</Totalcartons>| &&
        |<Ntwtcartonkg>{ package1 }</Ntwtcartonkg>| &&
*        |<Grosswtcartonkg>{ matdocdata-Grosswt }</Grosswtcartonkg>| &&
        |<totntwtcartonkg>{ NETWTCARTON-CumulativeBatchQtyInBaseUnit }</totntwtcartonkg>| &&
        |<Totgrwtkgs>{ gross }</Totgrwtkgs>| &&
        |<Measurment></Measurment>| &&
        |</Row2>|.
        CLEAR :wa_draft,calculatproj1  .

      ENDLOOP.

      lv_xml = lv_xml &&

     |<Row3>| &&
     |<totcarton></totcarton>| &&
     |<totntwt></totntwt>| &&
     |<Totgrwt></Totgrwt>| &&
     |</Row3>| &&
     |</Table1>| &&
     |<Subform4>| &&
     |<Allitem></Allitem>| &&
     |</Subform4>| &&
     |</Subform1>| &&
     |</form1>|.

*  CONCATENATE lv_xml4 xsml lv_xml6 INTO lv_xml .

    ENDIF.


    IF form = 'packinglistdetail'  .

      temp = 'PACKING_LIST_EXIM/PACKING_LIST_EXIM'.

      lv_xml =

 |<form1>| &&
 |<Subform1/>| &&
 | <Subform2>| &&
 |<Subform3>| &&
 |<EXPORTBENIFICARY></EXPORTBENIFICARY>| &&
 |<LCNO>{ calculatproj-Lcno }</LCNO>| &&
 |</Subform3>| &&
 |<Subform4>| &&
 |<CONSIGNEEAPPLICANT></CONSIGNEEAPPLICANT>| &&
 |<INVOICENO>{ gendata-Docno }</INVOICENO>| &&
 |</Subform4>| &&
 |<Subform5>| &&
 |<NOTIFYBUYER>{ considata-Billtobuyrname }</NOTIFYBUYER>| &&
 |<INVDATE>{ gendata-DocDate }</INVDATE>| &&
 |</Subform5>| &&
 |<Subform6>| &&
 |<BLNO>{ gendata-Blno }</BLNO>| &&
 |<BLDATE></BLDATE>| &&
 |<ORIGINOFGOODS>INDIA</ORIGINOFGOODS>| &&
 |<PORTOFLOADING>{ gendata-Portofloading }</PORTOFLOADING>| &&
 |<PORTOFDISCHARGE>{ gendata-Portofdischarge }</PORTOFDISCHARGE>| &&
 |<PROFORMANO>{ gendata-Peformano }</PROFORMANO>| &&
 |<TextField13>{ gendata-Peformadate }</TextField13>| &&
 |</Subform6>| &&
 |</Subform2>| &&
 |<Subform7>| &&
 |<Table1>| &&
 |<Row1/>| .


 SELECT * FROM ydraft_bl_cds  WHERE docno = @variable INTO TABLE @DATA(draftVS).
  LOOP AT draftVS INTO DATA(wa_draftVS).
*  SELECT SINGLE * FROM zpregen_exi WHERE docno = @variable INTO @DATA(gendataVS) .

 lv_xml = lv_xml &&

 |<Row2>| &&
 |<ContainerNo>{ gendata-Containerno }</ContainerNo>| &&
 |<Totalpallet></Totalpallet>| &&
 |<totalcartoons></totalcartoons>| &&
 |<totalcones></totalcones>| &&
 |<woodenpallet></woodenpallet>| &&
 |<height></height>| &&
 |<lengthcm></lengthcm>| &&
 |<width></width>| &&
 |<numberlayer></numberlayer>| &&
 |<description>{ wa_draftvs-BillingDocumentItemText }</description>| &&
 |<kgnetwteach></kgnetwteach>| &&
 |<kggrosswteach></kggrosswteach>| &&
 |<lotno></lotno>| &&
 |</Row2>|.

 ENDLOOP.

 lv_xml = lv_xml &&
 |<Row3>| &&
 |<TOTALPALLETTOTAL></TOTALPALLETTOTAL>| &&
 |<TOTALCONESTOAL></TOTALCONESTOAL>| &&
 |<KGNETWTEACHtotal></KGNETWTEACHtotal>| &&
 |<KGGROSSWTEACHTOTAL></KGGROSSWTEACHTOTAL>| &&
 |</Row3>| &&
 |</Table1>| &&
 |</Subform7>| &&
 |</form1>|.

    ENDIF.
*******************************************************************************************
********************************************************************************************
IF form = 'preshipmentadvice'  .
      temp = 'PRE_SHIPMENT_ADVICE/PRE_SHIPMENT_ADVICE'.



      lv_xml =
          |<form1>| &&
          |<Subform1>| &&
          |<Consignee>{ considata1ps-Billtobuyrname }</Consignee>| &&
          |<Invoiceno>{ gendataps-docno } { 'DATE' } { gendataps-DocDate+6(2) }/{ gendataps-DocDate+4(2) }/{ gendataps-DocDate+0(4) }</Invoiceno>| &&
          |<PINoDate>{ gendataps-peformano } </PINoDate>| &&
          |<ACIDNO>{ gendata-Remarks1 }</ACIDNO>| &&
          |<LCnoDate>{ calculatprojps-Lcno } { 'DATE' } { calculatprojps-Lcdate+8(2) }/{ calculatprojps-Lcdate+5(2) }/{ calculatprojps-Lcdate+0(4) }</LCnoDate>| &&
          |<IncoTerm>{ gendataps-Deliveryterms }</IncoTerm>| &&
          |<PaymentTerms>{ gendataps-PaymentTerms }</PaymentTerms>| &&
          |<DescriptionofGoods></DescriptionofGoods>| &&
          |<Table2>| &&
          |<HeaderRow/>| .






     lv_xml  = lv_xml &&
           |<Row1>| &&
           |<degoods></degoods>| &&
           |</Row1>| .


   lv_xml = lv_xml &&
          |</Table2>| &&
          |<Table1>| &&
          |<HeaderRow/>| &&
           |<Row1>| &&
           |<CURRY>{ calculatprojps-Doccurrency }</CURRY>| &&
           |<CURRRY1>{ calculatprojps-Doccurrency }</CURRRY1>| &&
         |</Row1>| .


       SELECT
      a~BillingDocument,
      a~BillingDocumentItem,
      a~ReferenceSDDocument,
      a~ReferenceSDDocumentITEM,
      b~batch,
      c~netwt,
      c~grosswt,
      c~ConeWeight,
      c~PackingType,
      d~Totalpackages,
*      e~yy1_lotNo_DLI,
      e~CumulativeBatchQtyInBaseUnit,
      F~basicrate,
      F~netamount,
      D~Doctype
      FROM  I_BillingDocumentItem as a
        INNER JOIN  i_deliverydocumentitem as b on ( a~ReferenceSDDocument = b~DeliveryDocument
                                                AND a~ReferenceSDDocumentITEM = b~HigherLvlItmOfBatSpltItm
                                                AND b~batch is not INITIAL  )
        LEFT OUTER JOIN zpackn_cds as c on ( c~Batch = b~Batch )
        LEFT OUTER  JOIN yexim_calculatproj AS d on ( d~Docno = a~BillingDocument AND D~Doctype = 'PS')
        INNER JOIN  i_deliverydocumentitem as e on ( a~ReferenceSDDocument = e~DeliveryDocument
                                             AND a~ReferenceSDDocumentITEM = e~deliverydocumentitem )
        LEFT OUTER JOIN yeinvoice_cdss AS F ON ( F~BillingDocument = A~BillingDocument and f~BillingDocumentItem = a~HigherLvlItmOfBatSpltItm )
              WHERE a~BillingDocument = @variable  INTO  TABLE @DATA(prishdata).

   DATA totinvoci TYPE p DECIMALS 2.
   DATA  rate TYPE p DECIMALS 2.
   DATA TOTINVALUE TYPE P DECIMALS 2.
   DATA TOTGROSVALUE TYPE P DECIMALS 2.
   DATA TOTNETVALUE TYPE P DECIMALS 2.
   DATA totnopack TYPE int4.


 LOOP AT prishdata  INTO DATA(wa_prishdata).

        rate = wa_prishdata-basicrate .

         SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @wa_prishdata-ReferenceSDDocument
                              AND  HigherLvlItmOfBatSpltItm = @wa_prishdata-ReferenceSDDocumentItem
               AND batch is not INITIAL INTO @DATA(precount3)   .

                SELECT SUM( grosswt ) FROM zpackn_cds AS a LEFT OUTER JOIN i_deliverydocumentitem AS b
                                          ON ( a~batch  = b~batch   )
                                          WHERE b~higherlvlitmofbatspltitm  =
                                          @wa_prishdata-ReferenceSDDocumentITEM
                                          AND b~deliverydocument = @wa_prishdata-ReferenceSDDocument
*                                          AND a~lotnumber = @wa_prishdata-yy1_lotNo_DLI
                                          INTO @DATA(pregross4)  .
     SELECT SINGLE * from yeinvoice_cdss where BillingDocument = @wa_prishdata-BillingDocument into @data(inv).
      TOTINVALUE = TOTINVALUE + wa_prishdata-NetAmount.
      TOTGROSVALUE = TOTGROSVALUE + pregross4 .
      TOTNETVALUE = TOTNETVALUE + wa_prishdata-CumulativeBatchQtyInBaseUnit .
      totnopack = totnopack  + precount3  .
****************************************************************************************
   DATA: packingtype TYPE string.

*CASE wa_prishdata-PackingType.
*  WHEN 'PL'.
*    packingtype = 'Pallet'.
*  WHEN 'RC'.
*    packingtype = 'Carton'.
*  WHEN 'NC'.
*      packingtype = 'Carton'.
*  WHEN ''.
*    packingtype = 'Roll'.
*
*ENDCASE.

IF wa_prishdata-PackingType+0(2) = 'PL'.
    packingtype = 'Pallet'.

  ELSEIF ( wa_prishdata-PackingType+0(2)  = 'RC' OR wa_prishdata-PackingType+0(2) = 'NC' ) ..
     packingtype = 'Carton'.

* ELSEIF wa_prishdata-PackingType = 'NC'.
*      packingtype = 'Carton'.

      ELSEIF wa_prishdata-PackingType = ' '.
    packingtype = 'Roll'.

ENDIF..

*****************************************************************************************



     lv_xml  =  lv_xml &&
            |<Row2>| &&
            |<TypeofPackage>{ packingtype }</TypeofPackage>| &&
*            |<TypeofPackage>{ wa_prishdata-PackingType }</TypeofPackage>| &&
            |<No.OfPackages>{ precount3 }</No.OfPackages>| &&
*            |<LOtno>{ wa_prishdata-YY1_LotNo_DLI }  </LOtno>| &&
            |<NetWt>{ wa_prishdata-Netwt }</NetWt>| &&
            |<GrossWt>{ wa_prishdata-Grosswt }</GrossWt>| &&
            |<TotalNETWtKgs>{ wa_prishdata-CumulativeBatchQtyInBaseUnit }</TotalNETWtKgs>| &&
            |<TotalGrossWtKgs>{ pregross4 }</TotalGrossWtKgs>| &&
            |<PriceKg>{ rate }</PriceKg>| &&
            |<InvoiceValue>{ wa_prishdata-NetAmount }</InvoiceValue>| &&
            |</Row2>| .

*       CONCATENATE xsml lv_xml2 INTO  xsml .



 DELETE ADJACENT DUPLICATES FROM  prishdata COMPARING  ReferenceSDDocument  ReferenceSDDocumentITEM  .

CLEAR : RATE.

ENDLOOP.



   lv_xml3 =
            |<Row3>| &&
            |<TOTALNo.OfPackages>{ totnopack }</TOTALNo.OfPackages>| &&
            |<TOTALTotalNETWtKgs>{ TOTNETVALUE }</TOTALTotalNETWtKgs>| &&
            |<TOTALTotalGrossWtKgs>{ TOTGROSVALUE }</TOTALTotalGrossWtKgs>| &&
            |<TOTALInvoiceValue>{ TOTINVALUE }</TOTALInvoiceValue>| &&
            |</Row3>| &&
            |</Table1>| &&
            |</Subform1>| &&
            |<Subform2>| &&
            |<Lotno>Ego ille</Lotno>| &&
            |<Containerno>{ gendataps-Containerno }</Containerno>| &&
            |<ShippingLine>{ calculatprojps-Shippingline }</ShippingLine>| &&
            |<Vessel>{ gendataps-Vesselno }</Vessel>| &&
            |<EstimatedDeparture>{ calculatprojps-Etddate+8(2) }/{ calculatprojps-Etddate+5(2) }/{ calculatprojps-Etddate+0(4) }</EstimatedDeparture>| &&
            |<EstimatedArrival>{ calculatprojps-Etadate+8(2) }/{ calculatprojps-Etadate+5(2) }/{ calculatprojps-Etadate+0(4) }</EstimatedArrival>| &&
            |<PortofLoading>{ gendataps-Portofloading }</PortofLoading>| &&
            |<DestinationPort>{ gendataps-Portofdischarge }</DestinationPort>| &&
            |<lot>Vale</lot>| &&
            |</Subform2>| &&
            |</form1>| .

           CONCATENATE lv_xml xsml lv_xml3 INTO lv_xml .


 ENDIF.
*********************************************************
********************************************************



*
** IF form = 'commercialinvoice'  .
**      temp = 'COMMERCIAL_EXIM/COMMERCIAL_EXIM'.
**
**if  gendata1-Deliveryterms  = 'FOB' .
** gendata1-Incotermslocation = ' '.
**
** ENDIF.
**
** CONCATENATE GENDATA1-Peformano GENDATA1-PerformaNoMore INTO DATA(PERNO).
**
**lv_xml =
**
**
**
**|<form1>| &&
**   |<Subform2>| &&
**
**      |<Subform3>| &&
**         |<companyname>{ gendata1-Exportname1 }</companyname>| &&
**         |<Address1>{ gendata1-Street1 }</Address1>| &&
**         |<Address2>{ gendata1-Street2 }</Address2>| &&
**         |<Address3>{ gendata1-Street3 }</Address3>| &&
**         |<Address4>{ gendata1-City } { gendata1-Country }</Address4>| &&
**         |<Address5>{ gendata1-Exporteriecno }</Address5>| &&
**      |</Subform3>| &&
**      |<Subform4>| &&
**         |<PACKINGLISTNO>{ considata1-docno }</PACKINGLISTNO>| &&
**         |<InvoiceDate>{ billhead-billingdocumentdate }</InvoiceDate>| &&
**         |<PROGINVNO>{ PERNO }</PROGINVNO>| &&
**         |<PROGINVNO_MORE></PROGINVNO_MORE>| &&
**         |<ProfInvDate>{ gendata1-Peformadate }</ProfInvDate>| &&
**         |<BLNO>{ gendata1-Blno }</BLNO>| &&
**         |<BLDATE>{ gendata1-Bldate }</BLDATE>| &&
**         |<LRNO>{ gendata1-Lrno }</LRNO>| &&
**         |<LRDATE>{ gendata1-LrDate }</LRDATE>| &&
**         |<TRUCKNO>{ gendata1-TruckNo }</TRUCKNO>| &&
**         |<OtherReference>{ gendata1-Weightofcontainer }</OtherReference>| &&
**      |</Subform4>| &&
**   |</Subform2>| &&
**   |<Subform5>| &&
**      |<ConsigneeBuyer>{ considata1-Consigneebuyer }</ConsigneeBuyer>| &&
**      |<APPLICANT>{ considata1-billtobuyrname }</APPLICANT>| &&
**      |<APPLICENT2>{ considata1-billtostreet1 }</APPLICENT2>| &&
**      |<APPLICENT3>{ considata1-billtostreet2 }</APPLICENT3>| &&
**      |<APPLICENT4>{ considata1-billtostreet3 }</APPLICENT4>| &&
**      |<APPLICENT5>{ considata1-billtocity }</APPLICENT5>| &&
**      |<BUYERADD6>{ considata1-Billtocountry }</BUYERADD6>| &&
**      |<Subform6>| &&
**         |<APPLICANT11>{ considata1-Secondbuyer }</APPLICANT11>| &&
**         |<APPLICANT22>{ considata1-Secondbuyername }</APPLICANT22>| &&
**         |<APPLICANT33>{ considata1-Secondstreet1 }</APPLICANT33>| &&
**         |<APPLICANT44>{ considata1-Secondstreet2 }</APPLICANT44>| &&
**         |<APPLICANT55>{ considata1-Secondstreet3 }</APPLICANT55>| &&
**         |<APPLICANT66>{ considata1-Secondcity }</APPLICANT66>| &&
**         |<APPLICANT77>{ considata1-Secondcountry }</APPLICANT77>| &&
**      |</Subform6>| &&
**   |</Subform5>| &&
**   |<Subform7>| &&
**      |<PreCarrageBy>{ gendata1-Precarrier }</PreCarrageBy>| &&
**      |<VesselFlightNo>{ gendata1-vesselno }</VesselFlightNo>| &&
**      |<PortofDischarge>{ gendata1-portofdischarge }</PortofDischarge>| &&
**      |<PortOfLoading>{ gendata1-portofloading }</PortOfLoading>| &&
***      |<PlaceofRecept>{ billhead-YY1_PreCarrier_BDH }</PlaceofRecept>| &&
***      |<FinalDescription>{  gendata1-portofdischarge }</FinalDescription>| &&
**      |<FinalDescription>{  gendata1-Finaldestination  }</FinalDescription>| &&
**      |<Subform8>| &&
**         |<CountryOrigin>INDIA</CountryOrigin>| &&
**         |<TERMSOFPAY>{ gendata1-paymentterms }</TERMSOFPAY>| &&
**         |<DCNO>{ calculatprojvs-Lcno }-{ calculatprojvs-Lcdate1+6(2) }/{ calculatprojvs-Lcdate1+4(2) }/{ calculatprojvs-Lcdate1+0(4) }</DCNO>| &&
**         |<CountryfinalDesc>{ calculatprojvs-Countryfinaldest  }</CountryfinalDesc>| &&
**         |<TERMOFDEL>{ gendata1-Deliveryterms } { gendata1-Incotermslocation }</TERMOFDEL>| &&
**         |<ISSUINGBANK>{ calculatprojvs-Issueingbank }</ISSUINGBANK>| &&
**         |<THROUGHINGBANK>{ calculatprojvs-Documentthrough }</THROUGHINGBANK>| &&
**      |</Subform8>| &&
**   |</Subform7>| &&
**   |<Table1>| &&
**      |<Row1/>| .
*
*      DATA: packingtype11 TYPE string.
*
*
*
*
*SELECT * FROM ydraft_bl_cds  WHERE docno = @variable AND Doctype = 'PO' INTO TABLE @DATA(draft20).
*
*  LOOP AT draft20 INTO DATA(i) .
*   SELECT SINGLE * FROM I_BillingDocumentItem
*                WHERE billingdocument = @i-Docno AND BillingDocumentItem = @i-Litem INTO  @DATA(billingitem123)  .
*
*   SELECT SINGLE * from i_deliverydocumentitem where DeliveryDocument = @billingitem123-ReferenceSDDocument AND DeliveryDocumentItem = @billingitem123-ReferenceSDDocumentItem
*    INTO @DATA(DEL1).
*    SELECT SINGLE *  FROM  i_deliverydocumentitem WHERE deliverydocument = @billingitem123-ReferenceSDDocument
*  and HigherLvlItmOfBatSpltItm = @billingitem123-ReferenceSDDocumentItem AND batch is not INITIAL INTO @DATA(ZPN)   .. " AND YY1_LotNo_DLI = @i-Lot
*
*
*   SELECT SINGLE * FROM zpackn_cds WHERE Batch = @ZPN-Batch and PackingType <> ''  INTO @DATA(ZPN1) .
*
*   SELECT COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @billingitem123-ReferenceSDDocument  AND
*               deliverydocumentitem = @billingitem123-ReferenceSDDocumentItem  AND batch IS NOT INITIAL INTO @DATA(Total)   .
*  SELECT SINGLE * from I_ProductPlantBasic where Product  = @billingitem123-Material into @data(prod).
*
*
*
***SELECT single  * FROM yeinvoice_cdss WHERE billingdocument =  @i-Docno INTO @DATA(billitemdata1) .
*
*  SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @billingitem123-ReferenceSDDocument
*  and HigherLvlItmOfBatSpltItm = @billingitem123-ReferenceSDDocumentItem AND batch is not INITIAL INTO @DATA(precount9)   .
*
*
*
*
*IF ZPN1-PackingType+0(2) = 'PL'.
*    packingtype11 = 'PALLET'.
*
*  ELSEIF ( ZPN1-PackingType+0(2)  = 'RC' OR ZPN1-PackingType+0(2) = 'NC' ) .
*     packingtype11 = 'CARTONS NO'.
*
** ELSEIF wa_prishdata-PackingType = 'NC'.
**      packingtype = 'Carton'.
*
*      ELSEIF ZPN1-PackingType = ' '.
*    packingtype11 = 'ROLL'.
*
*ENDIF.
*
*
*                  LV_XML = LV_XML &&
*
*
*      |<Row2>| &&
*         |<Table5>| &&
*            |<Row1>| &&
*               |<LotNo>LOT NO.{ i-Lot }</LotNo>| &&
*            |</Row1>| &&
*            |<Row2>| &&
*               |<Cartons>{ packingtype11 }</Cartons>| &&
*            |</Row2>| &&
*            |<Row3>| &&
**               |<PackagR>{ DEL1-YY1_FromBoxRoll_DLI } TO { DEL1-YY1_ToBoxRolls_DLI }</PackagR>| &&
*            |</Row3>| &&
*         |</Table5>| &&
*         |<Table6>| &&
*            |<Row1>| &&
*               |<CartonsNO>{ precount9 } </CartonsNO>| &&
*               |<package>{ packingtype11 }</package>| &&
*               |<Word></Word>| &&
*            |</Row1>| &&
*            |<Row2>| &&
*               |<ContainerDetails>{ gendata1-Containersize }</ContainerDetails>| &&
*            |</Row2>| &&
*            |<Row3>| &&
*               |<GoodsDesc>{ I-Mdesp }</GoodsDesc>| &&
*            |</Row3>| &&
*         |</Table6>| &&
*      |</Row2>| .
*      clear : i , PackingType11 , ZPN1 .
*
*      ENDLOOP.
*       LV_XML = LV_XML &&
*
*   |</Table1>| &&
*   |<Table2>| &&
*      |<Row1>| &&
*         |<QuantityU>{ billingitem-a-BillingQuantityUnit }</QuantityU>| &&
*      |</Row1>| .
*
*SORT billitemdata  by BillingDocumentItem .
*       LOOP AT billitemdata INTO DATA(iv9) .
*
***               DATA(rat1) = iv9-basicrate .
*               DATA(orgqty1) = iv9-billingquantity.
*
*
*               LV_XML = LV_XML &&
*      |<Row2>| &&
*         |<QuantityV>{ ORGQTY1 }</QuantityV>| &&
*      |</Row2>| .
*
*       clear : iv9.
*                ENDLOOP.
*     LV_XML = LV_XML &&
*   |</Table2>| &&
*   |<Table3>| &&
*      |<Row1>| &&
*         |<UnitPrice>{ billhead1-TransactionCurrency }</UnitPrice>| &&
*      |</Row1>| .
*
*       LOOP AT billitemdata INTO iv9 .
*
*               DATA(rat1) = iv9-basicrate .
***               DATA(orgqty1) = iv9-billingquantity.
*
*
*               LV_XML = LV_XML &&
*      |<Row2>| &&
*         |<UnitPr>{ RAT1 }</UnitPr>| &&
*      |</Row2>| .
*
*       clear : iv9.
*                ENDLOOP.
*
*    LV_XML = LV_XML &&
*   |</Table3>| &&
*   |<Table4>| &&
*      |<Row1>| &&
*         |<Currency>{ billhead1-TransactionCurrency }</Currency>| &&
*      |</Row1>| .
*
*      LOOP AT billitemdata INTO iv9 .
*
**               DATA(rat1) = iv9-basicrate .
**               DATA(orgqty1) = iv9-billingquantity.
*
*
*               LV_XML = LV_XML &&
*      |<Row2>| &&
*         |<AmountV>{ IV9-NetAmount }</AmountV>| &&
*      |</Row2>| .
*        clear : iv9.
*                ENDLOOP.
*
*     LV_XML = LV_XML &&
*   |</Table4>| &&
*   |<BOX1>{ gendata1-Descgoodsother }</BOX1>| &&
*   |<Box2>{ gendata1-Detailsbylc }</Box2>| &&
*   |<Table7>| &&
*      |<Row1/>| &&
*      |<Row2>| &&
*         |<ContainerNo>{ gendata1-containerno }</ContainerNo>| &&
*         |<LineSealNo>{ gendata1-lineseal }</LineSealNo>| &&
*         |<CustomSealNo>{ gendata1-rfidno }</CustomSealNo>| &&
*      |</Row2>| &&
*   |</Table7>| &&
*   |<Table8>| &&
*      |<Row1/>| .
*
*      SELECT
*      a~BillingDocument,
*      a~BillingDocumentItem,
*      a~ReferenceSDDocument,
*      a~ReferenceSDDocumentITEM,
*      b~batch,
*      b~material,
**      c~netwt,
**      c~grosswt,
**      c~ConeWeight,
*      d~Totalpackages,
**      E~yy1_lotNo_DLI,
*      e~CumulativeBatchQtyInBaseUnit
*      FROM  I_BillingDocumentItem as a
*
*
*        LEFT OUTER JOIN  i_deliverydocumentitem as b on ( b~DeliveryDocument = a~ReferenceSDDocument
*                                                AND  b~HigherLvlItmOfBatSpltItm = a~ReferenceSDDocumentITEM
*                                                AND b~batch is not INITIAL  )
*       LEFT OUTER JOIN  i_deliverydocumentitem as e on (  e~DeliveryDocument = a~ReferenceSDDocument
*                        AND  e~deliverydocumentitem = a~ReferenceSDDocumentITEM  )
**        LEFT OUTER JOIN zpackn_cds as c on ( c~Batch = b~Batch  and c~LotNumber = E~YY1_LotNo_DLI  and c~material = b~material )
*        LEFT OUTER  JOIN yexim_calculatproj AS d on ( d~Docno = a~BillingDocument )
*              WHERE a~BillingDocument = @variable INTO  TABLE @DATA(draft8).
*
****************************
*
**SELECT FROM I_DeliveryDocumentitem as a
**inner join zpackn as b on b~batch = a~Batch and b~lot_number = a~YY1_LotNo_DLI
**FIELDS
**a~DeliveryDocument ,
**a~Batch ,
**b~netwt ,
**b~grosswt ,
**b~cone_weight ,
**b~lot_number
**WHERE a~batch is NOT INITIAL   and a~DeliveryDocument = '8252000129'
**INTO TABLE @data(drft9) .
*
************************************
*
**  SORT draft8 DESCENDING by Netwt .  "batch YY1_LotNo_DLI
*
*data(draft111)  = draft8 .      """"""""duplicate data draft8
*
*DELETE ADJACENT DUPLICATES FROM  draft8 COMPARING  ReferenceSDDocument billingdocumentitem   . "YY1_LotNo_DLI Netwt
*
*data nett_weight1 TYPE zpackn-netwt.
*
* .
* LOOP AT draft8  INTO DATA(WA_draft8).
*
*         SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem   as a inner join zpackn_cds as b on
*                                                     A~Batch =  b~Batch and a~Material =  b~Material "and a~YY1_LotNo_DLI = b~LotNumber
*
*         WHERE deliverydocument = @WA_draft8-ReferenceSDDocument AND
**               b~Netwt = @WA_draft8-Netwt  and
*               higherlvlitmofbatspltitm =  @WA_draft8-ReferenceSDDocumentITEM AND a~batch is not INITIAL  INTO @DATA(count8)   .
*
*                SELECT SUM( grosswt ) FROM zpackn_cds AS a LEFT OUTER JOIN i_deliverydocumentitem AS b
*                                          ON ( a~batch  = b~batch   )
*                                          WHERE b~higherlvlitmofbatspltitm  =
*                                          @WA_draft8-ReferenceSDDocumentITEM
*                                          AND b~deliverydocument = @WA_draft8-ReferenceSDDocument
**                                          AND a~lotnumber = @WA_draft8-yy1_lotNo_DLI
*                                          INTO @DATA(gross8)  .
*
*                  SELECT SINGLE COUNT(*) FROM zpackn_cds where Batch = @wa_draft8-Batch and batch  is not INITIAL INTO @DATA(count9).
*
*   clear : netwt  .
*
**   DELETE ADJACENT DUPLICATES FROM draft111 COMPARING Batch .
*DELETE ADJACENT DUPLICATES FROM  draft111 COMPARING   ReferenceSDDocument billingdocumentitem  .
*  loop at draft111 ASSIGNING FIELD-SYMBOL(<fs>) . "YY1_LotNo_DLI Netwt
*
**
**         SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem   as a inner join zpackn_cds as b on
**                                                     A~Batch =  b~Batch and a~Material =  b~Material and a~YY1_LotNo_DLI = b~LotNumber
**
**         WHERE deliverydocument = @<fs>-ReferenceSDDocument AND
**               b~Netwt = @<fs>-Netwt  and
**               higherlvlitmofbatspltitm =  @<fs>-ReferenceSDDocumentITEM AND a~batch is not INITIAL  INTO @count8 .
*
*
**  count8 =  count8 + 1 .
***    COUNT8 = COUNT8 .
**  nett_weight1  =  nett_weight1 + <fs>-Netwt  .
*
*
*  endloop .
*
*DATA : NW TYPE STRING.
*DATA : GW TYPE STRING.
**
**NW = WA_draft8-Netwt * count8 .
**GW =  WA_draft8-Grosswt * count8.
*
*
*                  LV_XML = LV_XML &&
*
*
*      |<Row2>| &&
**         |<LotNo>{ WA_draft8-yy1_lotNo_DLI }</LotNo>| &&
*         |<TotPackage>{  count8   }</TotPackage>| &&
**         |<NetWtCone>{ WA_draft8-ConeWeight }</NetWtCone>| &&
***         |<NetWtCone>{ nett_weight1 }</NetWtCone>| &&
**         |<NetWtPackage>{ WA_draft8-Netwt }</NetWtPackage>| &&
***         |<NetWtPackage>{ nett_weight1 }</NetWtPackage>| &&
**         |<GrossWt>{ WA_draft8-Grosswt }</GrossWt>| &&
***         |<TotalNetWt>{ WA_draft8-CumulativeBatchQtyInBaseUnit }</TotalNetWt>| &&
*         |<TotalNetWt>{ NW }</TotalNetWt>| &&
***         |<TotGrossWt>{ gross8 }</TotGrossWt>| &&
*         |<TotGrossWt>{ GW }</TotGrossWt>| &&
*      |</Row2>| .
*
***      DELETE ADJACENT DUPLICATES FROM  draft8 COMPARING  BillingDocumentItem ReferenceSDDocument ReferenceSDDocumentITEM ReferenceSDDocument   .
*
**    clear bill1.
*clear : count8.
*ENDLOOP.
*        DATA fobtot TYPE P DECIMALS 2.
*
*   FOBTOT = calculatprojvs-Invoiceamount + calculatprojvs-Oceanfreight + calculatprojvs-Insurance .
*  LV_XML = LV_XML &&
*
*
*      |<Row3>| &&
*         |<TotPack></TotPack>| &&
*         |<TotNet></TotNet>| &&
*         |<TotGross></TotGross>| &&
*      |</Row3>| &&
*   |</Table8>| &&
*   |<Table15>| &&
*      |<Row1>| &&
*         |<SUBTAB1>| &&
*            |<TERMS>{ gendata1-Deliveryterms }</TERMS>| &&
*            |<CURR1>{ calculatprojvs-Doccurrency }</CURR1>| &&
*            |<CFRTOTAL>{ calculatprojvs-Invoiceamount }</CFRTOTAL>| &&
*         |</SUBTAB1>| &&
*      |</Row1>| &&
*      |<Row2>| &&
*         |<SUBTAB2>| &&
*            |<CURR2>{ calculatprojvs-Doccurrency }</CURR2>| &&
*            |<AMOUNT1>{ calculatprojvs-Oceanfreight }</AMOUNT1>| &&
*         |</SUBTAB2>| &&
*      |</Row2>| &&
*      |<Row3>| &&
*         |<SUBTAB3>| &&
*            |<CURR3>{ calculatprojvs-Doccurrency }</CURR3>| &&
*            |<INSUTOTAL>{ calculatprojvs-Insurance }</INSUTOTAL>| &&
*         |</SUBTAB3>| &&
*      |</Row3>| &&
*      |<Row4>| &&
*         |<SUBTAB4>| &&
*            |<CURR4>{ calculatprojvs-Doccurrency }</CURR4>| &&
*            |<FOBTOTAL1>{ FOBTOT }</FOBTOTAL1>| &&
*         |</SUBTAB4>| &&
*      |</Row4>| &&
*   |</Table15>| .
*
*
*      DATA tot3 TYPE string .
*       data invamt type p DECIMALS 2.
*       invamt = calculatprojvs-Invoiceamount.
**       calculatprojvs-Invoiceamount = invamt.
*      tot3 = invamt .
*      CONDENSE tot3 .
*      SPLIT tot3 AT '.' INTO tot3 DATA(tot2).
*
*      IF tot2 NE '00' .
*        DATA: amt_in2 TYPE string.
*        DATA(amt_in) = ycl_spellinwords=>spellamt( iv_num =  tot3 )  .
*        CLEAR:amt_in2.
*        amt_in2  = ycl_spellinwords=>spellamt( iv_num =  tot2 )  .
*        CONDENSE amt_in2.
*        REPLACE ALL OCCURRENCES OF ' and ' IN amt_in WITH  ' ' .
*
*        IF calculatprojvs-Doccurrency EQ 'USD'.
*         amt_in2 = COND #( WHEN amt_in2 IS NOT INITIAL THEN |USD { amt_in } And Cents { amt_in2 } Only|
*                           ELSE |USD { amt_in }| )."|{ amt_in } DOLLARS { amt_in2 } CENTS |  .
*
*        ELSEIF calculatprojvs-Doccurrency  EQ 'EUR' .
*             amt_in2 = COND #( WHEN amt_in2 IS NOT INITIAL THEN |EUR { amt_in } And Cents { amt_in2 } Only|
*                           ELSE |EUR { amt_in }| )."|{ amt_in } DOLLARS { amt_in2 } CENTS |  .
*        ELSEIF calculatprojvs-Doccurrency  EQ 'INR' .
*             amt_in2 = COND #( WHEN amt_in2 IS NOT INITIAL THEN |INR { amt_in } And  { amt_in2 } PAISA Only|
*                           ELSE |INR { amt_in }| )."|{ amt_in } DOLLARS { amt_in2 } CENTS |  .
*        ENDIF.
*
*      ELSE .
*"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*   amt_in = ycl_spellinwords=>spellamt( iv_num =  tot3 )  .
*
*         IF calculatprojvs-Doccurrency EQ 'USD'.
*         amt_in2 = COND #( WHEN amt_in2 IS NOT INITIAL THEN |USD { amt_in } And Cents { amt_in2 } Only|
*                           ELSE |USD { amt_in }| ).
*
*        ELSEIF calculatprojvs-Doccurrency  EQ 'EUR' .
*             amt_in2 = COND #( WHEN amt_in2 IS NOT INITIAL THEN |EUR { amt_in } And Cents { amt_in2 } Only|
*                           ELSE |EUR { amt_in }| ).
*
*         ELSEIF calculatprojvs-Doccurrency  EQ 'INR' .
*             amt_in2 = COND #( WHEN amt_in2 IS NOT INITIAL THEN |INR { amt_in } And  { amt_in2 } PAISA Only|
*                           ELSE |INR { amt_in }| ).
*        ENDIF.
*"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
*      ENDIF .
*
*       amt_in2 = to_upper( amt_in2 ).
*
*******************************************
*  DATA tot4 TYPE string .
*  data invamt1 type p DECIMALS 2.
*  invamt1 = calculatprojvs-Grandtotalamount.
*      tot4 = invamt1 .
*      CONDENSE tot4 .
*      SPLIT tot4 AT '.' INTO tot4 DATA(tot5).
*
*      IF tot5 NE '00' .
*        DATA: amt_in5 TYPE string.
*        DATA(amt_in1) = ycl_spellinwords=>spellamt( iv_num =  tot4 )  .
*        CLEAR:amt_in5.
*        amt_in5  = ycl_spellinwords=>spellamt( iv_num =  tot5 )  .
*        CONDENSE amt_in5.
*        REPLACE ALL OCCURRENCES OF ' and ' IN amt_in WITH  ' ' .
*        IF calculatprojvs-Doccurrency EQ 'USD'.
*       amt_in5 = COND #( WHEN amt_in5 IS NOT INITIAL THEN |USD { amt_in1 } And Cents  { amt_in5 } Only|
*                           ELSE |USD { amt_in1 }| )."|{ amt_in } DOLLARS { amt_in2 } CENTS |  .
*
*          ELSEIF calculatprojvs-Doccurrency EQ 'EUR' .
*                amt_in5 = COND #( WHEN amt_in5 IS NOT INITIAL THEN |EUR { amt_in1 } And Cents  { amt_in5 } Only|
*                           ELSE |EUR { amt_in1 }| )."|{ amt_in } DOLLARS { amt_in2 } CENTS |  .
*
*           ELSEIF calculatprojvs-Doccurrency EQ 'INR' .
*                amt_in5 = COND #( WHEN amt_in5 IS NOT INITIAL THEN |INR { amt_in1 } And { amt_in5 } PAISA Only|
*                           ELSE |INR { amt_in1 }| )."|{ amt_in } DOLLARS { amt_in2 } CENTS |  .
*              ENDIF.
***        to_upper( [ 'amt_in5'] )
*      ELSE .
*
*
*
*        amt_in1 = ycl_spellinwords=>spellamt( iv_num =  tot4 )  .
*
*          IF calculatprojvs-Doccurrency EQ 'USD'.
*
**        amt_in2 = |{ amt_in } DOLLARS |  .
*        amt_in5 = COND #( WHEN amt_in5 IS NOT INITIAL THEN |USD { amt_in1 } And Cents { amt_in5 } only|
*                           ELSE |USD { amt_in1 }| ).
*          ELSEIF calculatprojvs-Doccurrency  EQ 'EUR' .
*          amt_in5 = COND #( WHEN amt_in5 IS NOT INITIAL THEN |EUR { amt_in1 } And Cents { amt_in5 } only|
*                           ELSE |EUR { amt_in1 }| ).
*
*           ELSEIF calculatprojvs-Doccurrency  EQ 'INR' .
*          amt_in5 = COND #( WHEN amt_in5 IS NOT INITIAL THEN |INR { amt_in1 } And { amt_in5 } PAISA only|
*                           ELSE |INR { amt_in1 }| ).
*          ENDIF.
*
*      ENDIF .
*
*      """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*
**  DATA(lv_otherdetails) = gendata1-otherdetails.
*
*" Remove extra spaces
**REPLACE ALL OCCURRENCES OF REGEX '\s+' IN lv_otherdetails WITH ' '.
*
*" Remove spaces after a period
**REPLACE ALL OCCURRENCES OF '. ' IN lv_otherdetails WITH '.'.
*
*" Trim leading and trailing spaces
** CONDENSE lv_otherdetails NO-GAPS.
*
*" Update the field with the cleaned value
**gendata1-otherdetails = lv_otherdetails.
*
*
*""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
*      amt_in5 = to_upper( amt_in5 ).
*
*     LV_XML = LV_XML &&
*    |<Subform10>| &&
*      |<Box3>{ gendata1-Otherdetails }</Box3>| &&
*   |</Subform10>| &&
*   |<Subform9>| &&
*      |<AmountInWords>{ amt_in2 }</AmountInWords>| &&
*      |<TotalAmount>{ calculatprojvs-Invoiceamount }</TotalAmount>| &&
*      |<TextField25></TextField25>| &&
*      |<LessAdv>{ calculatprojvs-Lessamt }</LessAdv>| &&
*      |<WordBalanceP>{ amt_in5 }</WordBalanceP>| &&
*      |<BalancePay>{ calculatprojvs-Grandtotalamount }</BalancePay>| &&
*   |</Subform9>| &&
**   |<Subform10>| &&
**      |<Box3>{ gendata1-Otherdetails }</Box3>| &&
**   |</Subform10>| &&
*|</form1>| .


* ENDIF.
***********************************************

    IF form = 'packinglist'  .
*      temp = 'PACKING_LIST_DETAILS_EXIM/PACKING_LIST_DETAILS_EXIM'.  "12.12
       temp = 'PACKING_EXIM/PACKING_EXIM'.

       SELECT  * FROM I_BillingDocumentItemBasic AS A
                LEFT OUTER JOIN I_SalesDocumentItem  AS B ON ( A~SalesDocument = B~SalesDocument AND A~SalesDocumentItem = B~SalesDocumentItem )
                WHERE billingdocument = @variable INTO TABLE @DATA(billingitem1)  .
*LOOP AT billingitem1  INTO DATA(bill1).
if  gendata1-Deliveryterms  = 'FOB' .
 gendata1-Incotermslocation = ' '.

 ENDIF.



READ TABLE billingitem1   INTO  DATA(BILL1) INDEX 1 .
CONCATENATE gendata1-Peformano  gendata1-PerformaNoMore INTO DATA(PER).

 lv_xml =

|<form1>| &&
   |<Subform1>| &&
      |<Subform2>| &&
        |<Subform3>| &&
            |<Companyname>{ gendata1-Exportname1 }</Companyname>| &&
            |<Address1>{ gendata1-Street1 }</Address1>| &&
            |<Address2>{ gendata1-Street2 }</Address2>| &&
            |<Address3>{ gendata1-Street3 }</Address3>| &&
            |<Address4>{ gendata1-City } { gendata1-Country }</Address4>| &&
            |<Address5>{ gendata1-Exporteriecno }</Address5>| &&
         |</Subform3>| &&
         |<Subform4>| &&
            |<PACKINGLISTNO>{ gendata1-Docno }</PACKINGLISTNO>| &&
            |<InvoiceDate>{ gendata1-DocDate }</InvoiceDate>| &&
            |<PROGINVNO>{ PER }</PROGINVNO>| &&
            |<PROGINVNO_MORE></PROGINVNO_MORE>| &&
            |<ProfInvDate>{ gendata1-Peformadate }</ProfInvDate>| &&
            |<BLNO>{ gendata1-Blno }</BLNO>| &&
            |<BLDATE>{ gendata1-Bldate }</BLDATE>| &&
            |<LRNO>{ gendata1-Lrno }</LRNO>| &&
             |<LRDATE>{ gendata1-LrDate }</LRDATE>| &&
            |<TRUCKNO>{ gendata1-TruckNo }</TRUCKNO>| &&
            |<OtherReference>{ gendata1-Weightofcontainer }</OtherReference>| &&
         |</Subform4>| &&
      |</Subform2>| &&
      |<Subform5>| &&
         |<Consign>{ considata1-Consigneebuyer }</Consign>| &&
         |<APPLICANT>{ considata1-billtobuyrname }</APPLICANT>| &&
         |<APPLICENT2>{ considata1-billtostreet1 }</APPLICENT2>| &&
         |<APPLICENT3>{ considata1-billtostreet2 }</APPLICENT3>| &&
         |<APPLICENT4>{ considata1-billtostreet3 }</APPLICENT4>| &&
         |<APPLICENT5>{ considata1-billtocity }</APPLICENT5>| &&
         |<BUYERADD6>{ considata1-Billtocountry }</BUYERADD6>| &&
         |<Subform6>| &&
            |<APPLICANT11>{ considata1-Secondbuyer }</APPLICANT11>| &&
            |<APPLICANT22>{ considata1-Secondbuyername }</APPLICANT22>| &&
            |<APPLICANT33>{ considata1-Secondstreet1 }</APPLICANT33>| &&
            |<APPLICANT44>{ considata1-Secondstreet2 }</APPLICANT44>| &&
            |<APPLICANT55>{ considata1-Secondstreet3 }</APPLICANT55>| &&
            |<APPLICANT66>{ considata1-Secondcity }</APPLICANT66>| &&
            |<APPLICANT77>{ considata1-Secondcountry }</APPLICANT77>| &&
         |</Subform6>| &&
      |</Subform5>| &&
      |<Subform7>| &&
         |<PRECARRIAGE>{ gendata1-Precarrier }</PRECARRIAGE>| &&
         |<VESSELNO>{ gendata1-vesselno }</VESSELNO>| &&
         |<PortofDischarge>{ gendata1-portofdischarge }</PortofDischarge>| &&
*         |<PLACEOFRECEIPT>{ billhead-YY1_PreCarrier_BDH }</PLACEOFRECEIPT>| &&
         |<PORTOFLOAD>{ gendata1-portofloading }</PORTOFLOAD>| &&
*         |<FinalDescription>{ gendata1-portofdischarge }</FinalDescription>| &&
         |<FinalDescription>{ gendata1-Finaldestination }</FinalDescription>| &&
         |<Subform8>| &&
            |<CountryOrigin>INDIA</CountryOrigin>| &&
            |<TERMSOFPAY>{ gendata1-paymentterms }</TERMSOFPAY>| &&
            |<DCNO>{ calculatprojvs-Lcno }-{ calculatprojvs-Lcdate1+6(2) }/{ calculatprojvs-Lcdate1+4(2) }/{ calculatprojvs-Lcdate1+0(4) } </DCNO>| &&
            |<CountryfinalDesc>{ calculatprojvs-Countryfinaldest }</CountryfinalDesc>| &&
            |<TERMOFDEL>{ gendata1-Deliveryterms } { gendata1-Incotermslocation }</TERMOFDEL>| &&
            |<ISSUINGBANK>{ calculatprojvs-Issueingbank }</ISSUINGBANK>| &&
            |<THROUGHINGBANK>{ calculatprojvs-Documentthrough }</THROUGHINGBANK>| &&
         |</Subform8>| &&
      |</Subform7>| &&
      |<Subform9>| &&
         |<Table1>| &&
            |<Row1/>| .


     DATA: packingtype21 TYPE string.





            SELECT * FROM ydraft_bl_cds  WHERE docno = @variable AND Doctype = 'PO' INTO TABLE @DATA(draft11).
    LOOP AT draft11  INTO DATA(dr).


   SELECT SINGLE * FROM I_BillingDocumentItem
                WHERE billingdocument = @DR-Docno AND BillingDocumentItem = @DR-Litem INTO  @DATA(billingitem12)  .

    SELECT SINGLE * from i_deliverydocumentitem where DeliveryDocument =  @billingitem12-ReferenceSDDocument AND DeliveryDocumentItem = @billingitem12-ReferenceSDDocumentItem
    INTO @DATA(DEL).

     SELECT SINGLE *  FROM  i_deliverydocumentitem WHERE deliverydocument = @billingitem12-ReferenceSDDocument
     and HigherLvlItmOfBatSpltItm = @billingitem12-ReferenceSDDocumentItem AND batch is not INITIAL INTO @DATA(ZPN3)   ." AND YY1_LotNo_DLI = @dr-Lot

       SELECT SINGLE * FROM zpackn_cds WHERE Batch = @ZPN3-Batch INTO @DATA(ZPN11) .
       SELECT SINGLE * from I_ProductPlantBasic where Product  = @billingitem12-Material into @data(prod1).

       SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @billingitem12-ReferenceSDDocument
       and HigherLvlItmOfBatSpltItm = @billingitem12-ReferenceSDDocumentItem AND batch is not INITIAL INTO @DATA(precount19)   .

  IF ZPN11-PackingType+0(2) = 'PL'.
     packingtype21 = 'PALLET'.

  ELSEIF ( ZPN11-PackingType+0(2)  = 'RC' OR ZPN11-PackingType+0(2) = 'NC' ) .
     packingtype21 = 'CARTONS NO'.

      ELSEIF ZPN11-PackingType = ' '.
    packingtype21 = 'ROLL'.

ENDIF.


        LV_XML = LV_XML &&

            |<Row2>| &&
               |<Table2>| &&
                  |<Row1>| &&
                     |<LOTNO>LOT NO.</LOTNO>| &&
                  |</Row1>| &&
                  |<Row2>| &&
                     |<CARTON>{ packingtype21 }</CARTON>| &&
                  |</Row2>| &&
                  |<Row3>| &&
*                     |<NoofCartons>{ DEL-YY1_FromBoxRoll_DLI }TO { DEL-YY1_ToBoxRolls_DLI }</NoofCartons>| &&
                  |</Row3>| &&
               |</Table2>| &&
               |<Table3>| &&
                  |<Row1>| &&
                     |<TotPackage>{ precount19 }</TotPackage>| &&
                     |<package>{ packingtype21 }</package>| &&
                     |<Word></Word>| &&
                  |</Row1>| &&
                  |<Row2>| &&
                     |<Desc1>{ GENDATA1-Containersize }</Desc1>| &&
                  |</Row2>| &&
                  |<Row3>| &&
                     |<GoodsOfDesc>{ dr-BillingDocumentItemText }</GoodsOfDesc>| &&
                  |</Row3>| &&
               |</Table3>| &&
            |</Row2>| .

        clear : dr , packingtype21 ,ZPN11.
ENDLOOP.
LV_XML = LV_XML &&

         |</Table1>| &&
         |<Subform10>| &&
            |<Table7>| &&
               |<Row1>| &&
                  |<NetWeightQty>{ billingitem-a-BillingQuantityUnit }</NetWeightQty>| &&
               |</Row1>| .
           SELECT * FROM ydraft_bl_cds  WHERE docno = @variable AND Doctype = 'PO' INTO TABLE @draft11.
    LOOP AT draft11  INTO dr.


SELECT SINGLE * FROM I_BillingDocumentItem
                WHERE billingdocument = @DR-Docno AND BillingDocumentItem = @DR-Litem INTO  @billingitem12  .


        LV_XML = LV_XML &&

               |<Row2>| &&
                  |<NetweightQ>{ BILLINGITEM12-BillingQuantity }</NetweightQ>| &&
               |</Row2>| .

        clear : dr.
ENDLOOP.
LV_XML = LV_XML &&
            |</Table7>| &&
         |</Subform10>| &&
         |<Subform11>| &&
            |<Table8>| &&
               |<Row1/>| &&


               |<Row2>| &&
                  |<Remark></Remark>| &&
               |</Row2>| &&




            |</Table8>| &&
         |</Subform11>| &&
         |<BOX1>{ gendata1-Descgoodsother }</BOX1>| &&
         |<Table4>| &&
            |<Row1/>| &&
            |<Row2>| &&
               |<ContainerNo>{ gendata1-containerno }</ContainerNo>| &&
               |<LineSealNo>{ gendata1-lineseal }</LineSealNo>| &&
               |<RFIDESeal>{ gendata1-rfidno }</RFIDESeal>| &&
            |</Row2>| &&
         |</Table4>| &&
         |<Table6>| &&
            |<Row1/>| .

     SELECT
      a~BillingDocument,
      a~BillingDocumentItem,
      a~ReferenceSDDocument,
      a~ReferenceSDDocumentITEM,
      b~batch,
      b~material,
*      c~netwt,
*      c~grosswt,
*      c~ConeWeight,
      d~Totalpackages,
*      e~yy1_lotNo_DLI,
      e~CumulativeBatchQtyInBaseUnit
      FROM  I_BillingDocumentItem as a
        LEFT OUTER JOIN  i_deliverydocumentitem as b on ( a~ReferenceSDDocument = b~DeliveryDocument
                                                AND a~ReferenceSDDocumentITEM = b~HigherLvlItmOfBatSpltItm
                                                AND b~batch is not INITIAL  )
*        LEFT OUTER JOIN zpackn_cds as c on ( c~Batch = b~Batch  and c~LotNumber = b~YY1_LotNo_DLI )
        LEFT OUTER  JOIN yexim_calculatproj AS d on ( d~Docno = a~BillingDocument )
        LEFT OUTER JOIN  i_deliverydocumentitem as e on ( a~ReferenceSDDocument = e~DeliveryDocument
                                             AND a~ReferenceSDDocumentITEM = e~deliverydocumentitem )
              WHERE a~BillingDocument = @variable INTO  TABLE @DATA(draft4).

***************************************************************************
 SORT draft4." DESCENDING by YY1_LotNo_DLI Netwt Batch.


data(draft112)  = draft4 .      """"""""duplicate data draft8

*DELETE ADJACENT DUPLICATES FROM  draft4 COMPARING Netwt . " YY1_LotNo_DLI

data nett_weight2 TYPE zpackn-netwt.


*****************************************************
            LOOP AT draft4  INTO DATA(WA_draft4).

         SELECT SINGLE COUNT(*)  FROM  i_deliverydocumentitem WHERE deliverydocument = @WA_draft4-ReferenceSDDocument AND
               higherlvlitmofbatspltitm =  @WA_draft4-ReferenceSDDocumentITEM AND batch is not INITIAL INTO @DATA(count3)   .

                SELECT SUM( grosswt ) FROM zpackn_cds AS a LEFT OUTER JOIN i_deliverydocumentitem AS b
                                          ON ( a~batch  = b~batch   )
                                          WHERE b~higherlvlitmofbatspltitm  =
                                          @WA_draft4-ReferenceSDDocumentITEM
                                          AND b~deliverydocument = @WA_draft4-ReferenceSDDocument
*                                          AND a~lotnumber = @WA_draft4-yy1_lotNo_DLI
                                          INTO @DATA(gross4)  .



   clear : netwt ,count3.

   DELETE ADJACENT DUPLICATES FROM draft112 COMPARING Batch.
  loop at draft112 ASSIGNING FIELD-SYMBOL(<fs1>)." where Netwt = WA_draft4-Netwt and YY1_LotNo_DLI =  WA_draft4-YY1_LotNo_DLI   .

  count3 =  count3 + 1 .
**    COUNT8 = COUNT8 .
*  nett_weight2  =  nett_weight2 + <fs1>-Netwt  .


  endloop .

DATA : NW1 TYPE STRING .
DATA : GW1 TYPE STRING.
*
*NW1 = WA_draft4-Netwt * count3 .
*GW1 =  WA_draft4-Grosswt * count3.




LV_XML = LV_XML &&
            |<Row2>| &&
*               |<LotNo>{ WA_draft4-yy1_lotNo_DLI }</LotNo>| &&
               |<NumofPack>{  count3   }</NumofPack>| &&
*               |<CONEWEIGHT>{ WA_draft4-ConeWeight }</CONEWEIGHT>| &&
*               |<NetWeightPack>{ WA_draft4-Netwt }</NetWeightPack>| &&
*               |<GrossWeightPack>{ WA_draft4-Grosswt }</GrossWeightPack>| &&
               |<TotalNetWeight>{ NW1 }</TotalNetWeight>| &&
**               |<TotalNetWeight>{ WA_draft4-CumulativeBatchQtyInBaseUnit }</TotalNetWeight>| &&
               |<TotalGrossWeight>{ GW1 }</TotalGrossWeight>| &&
**               |<TotalGrossWeight>{ gross4 }</TotalGrossWeight>| &&
            |</Row2>| .



*      DELETE ADJACENT DUPLICATES FROM  draft4 COMPARING  BillingDocumentItem ReferenceSDDocument ReferenceSDDocumentITEM ReferenceSDDocument .

*    clear bill1.
ENDLOOP.
LV_XML = LV_XML &&


            |<Row3>| &&
               |<TotOfPack></TotOfPack>| &&
               |<TotNetWeight></TotNetWeight>| &&
               |<TotGrossWeight></TotGrossWeight>| &&
            |</Row3>| &&
         |</Table6>| &&
         |<BOX2>{ gendata1-Detailsbylc }</BOX2>| &&
      |</Subform9>| &&
      |<BOX3>{ gendata1-Otherdetails }</BOX3>| &&
   |</Subform1>| &&
|</form1>|.
ENDIF.



 IF form = 'shippingadviceweber'  .
    temp = 'SHIPPINGADVICE_WEBER_EXIM/SHIPPINGADVICE_WEBER_EXIM'.
 lv_xml =


|<form1>| &&
|<Subform1>| &&
|<ADDRESS1>| &&
|<COMNAME>Mirum est ut animus agitatione motuque corporis excitetut.</COMNAME>| &&
|<ADD1>Ad retia sedebam: erat in proximo non venabulum aut lancea, sed stilus et pugilares:</ADD1>| &&
|</ADDRESS1>| &&
|<DATE>| &&
|<DATE>20040606T101010</DATE>| &&
|</DATE>| &&
|</Subform1>| &&
|<Subform2>| &&
|<ADDRESS1>Ego ille</ADDRESS1>| &&
|<ADDRESS2>Si manu vacuas</ADDRESS2>| &&
|<ADDRESS3>Apros tres et quidem</ADDRESS3>| &&
|<ADDRESS4>Mirum est</ADDRESS4>| &&
|<EMAIL>Licebit auctore</EMAIL>| &&
|<COVERNO>{ calculatproj-Covernoteno }</COVERNO>| &&
|<COVERDATE>{ calculatproj-Covernotedate } </COVERDATE>| &&
|<DOCUMENTRYNO>{ calculatproj-Lcno } </DOCUMENTRYNO>| &&
|<DOCUMENTRYDATE>{ calculatproj-Lcdate }</DOCUMENTRYDATE>| &&
|</Subform2>| &&
|<text/>| &&
|<TABLE>| &&
|<Table1>| &&
|<HeaderRow>| &&
|<DESC1>Ad retia sedebam</DESC1>| &&
|<DESC2>Vale</DESC2>| &&
|<DESC3>Ego ille</DESC3>| &&
|</HeaderRow>| &&
|<Row1>| &&
|<QUANTITYkgs>Si manu vacuas</QUANTITYkgs>| &&
|</Row1>| &&
|<Row2>| &&
|<TOTALPACK>Apros tres et quidem</TOTALPACK>| &&
|</Row2>| &&
|<Row3>| &&
|<BLNO>Mirum est</BLNO>| &&
|</Row3>| &&
|<Row4>| &&
|<NAMEOFVESSEL>Licebit auctore</NAMEOFVESSEL>| &&
|</Row4>| &&
|<Row5>| &&
|<CARRIERNAME>Proinde</CARRIERNAME>| &&
|</Row5>| &&
|<Row6>| &&
|<ETD>Am undique</ETD>| &&
|</Row6>| &&
|<Row7>| &&
|<EAT>Ad retia sedebam</EAT>| &&
|</Row7>| &&
|<Row8>| &&
|<INVNODATE>Vale</INVNODATE>| &&
|</Row8>| &&
|<Row9>| &&
|<SHIPPMENTVALUE>Ego ille</SHIPPMENTVALUE>| &&
|</Row9>| &&
|<Row10>| &&
|<CONTAINERNO>Si manu vacuas</CONTAINERNO>| &&
|</Row10>| &&
|<Row11>| &&
|<PORTOFLOADING>Apros tres et quidem</PORTOFLOADING>| &&
|</Row11>| &&
|<Row12>| &&
|<PORTOFDISCHARGE>Mirum est</PORTOFDISCHARGE>| &&
|</Row12>| &&
|</Table1>| &&
|</TABLE>| &&
|<Subform3>| &&
|<IRCNO>Licebit auctore</IRCNO>| &&
|<LCAFNO>Proinde</LCAFNO>| &&
|<HSCODE>Am undique</HSCODE>| &&
|<TINNO>Ad retia sedebam</TINNO>| &&
|<EBIN>Vale</EBIN>| &&
|<BANKBINNO>Ego ille</BANKBINNO>| &&
|<LCNO>Si manu vacuas</LCNO>| &&
|<DATED>20040606T101010</DATED>| &&
|<APPLICANTNAME>Apros tres et quidem</APPLICANTNAME>| &&
|<APPLICANTADD1>Mirum est</APPLICANTADD1>| &&
|<APPLICANTADD2>Licebit auctore</APPLICANTADD2>| &&
|<IRCNO1>Proinde</IRCNO1>| &&
|</Subform3>| &&
|<Subform4/>| &&
|</form1>|.

    ENDIF.


    CALL METHOD zadobe_print=>adobe(
      EXPORTING
        xml  = lv_xml
        form_name = temp
      RECEIVING
        result   = result12 ).


  ENDMETHOD.
ENDCLASS.
