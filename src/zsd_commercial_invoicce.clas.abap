CLASS zsd_commercial_invoicce DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

 PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
    CLASS-DATA : template TYPE string .

    CLASS-METHODS :
      read_posts
        IMPORTING VALUE(variable) TYPE char10
                       printtype  TYPE STRING OPTIONAL
        RETURNING VALUE(result12) TYPE string
        RAISING   cx_static_check .

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS lc_storage_name TYPE string VALUE 'templateSource=storageName'.
    CONSTANTS lc_template_name TYPE string VALUE 'COMMERICAL_INVOICE/COMMERICAL_INVOICE'.

ENDCLASS.



CLASS ZSD_COMMERCIAL_INVOICCE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
   DATA(xml)  = read_posts( variable = 'U324200003'  )   .
  ENDMETHOD.


   METHOD read_posts.
    DATA TEMPLATE TYPE STRING.

 TEMPLATE =   'COMMERICAL_INVOICE/COMMERICAL_INVOICE' .
  variable = |{ variable ALPHA = in }|.
    SELECT * FROM  yeinvoice_cdss  as a  WHERE billingdocument = @variable   INTO TABLE @DATA(IT).

   READ TABLE IT INTO DATA(HEADWA) INDEX 1.


*    SELECT SINGLE * FROM zsd_dom_address WITH PRIVILEGED ACCESS WHERE addressid = @HEADWA-PayerpartYAddreid INTO @DATA(Payeradd1) .
*    SELECT SINGLE * FROM i_regiontext   WHERE  region = @Payeradd1-Region AND language = 'E'
*    AND country = @Payeradd1-country  INTO  @DATA(Payeradd1regiontext2) .

    SELECT SINGLE * FROM zsd_dom_address WITH PRIVILEGED ACCESS WHERE addressid = @HEADWA-SoldTOpatyAddreid INTO @DATA(Soldadd1) .
    SELECT SINGLE * FROM i_regiontext   WHERE  region = @Soldadd1-Region AND language = 'E'
    AND country = @Soldadd1-country  INTO  @DATA(Soldadd1regiontext2) .

    SELECT SINGLE * FROM zsd_dom_address WITH PRIVILEGED ACCESS WHERE addressid = @HEADWA-SHIPPINGPARTNRAddreid INTO @DATA(Shipadd1) .
    SELECT SINGLE * FROM i_regiontext   WHERE  region = @Shipadd1-Region AND language = 'E'
    AND country = @Shipadd1-country  INTO  @DATA(Shipadd1regiontext2) .

    SELECT SINGLE * FROM zsd_dom_address WITH PRIVILEGED ACCESS WHERE addressid = @HEADWA-bILLINGPARTNRAddreid INTO @DATA(Billtoadd1) .
    SELECT SINGLE * FROM i_regiontext   WHERE  region = @Billtoadd1-Region AND language = 'E'
    AND country = @Shipadd1-country  INTO  @DATA(Billtoadd1regiontext2) .

    SELECT SINGLE * FROM I_CountryText   WHERE  Country = @soldadd1-Country AND language = 'E'   INTO  @DATA(billtocountry) .

   SELECT SINGLE Distributionchannel , TransactionCurrency FROM I_BillingDocument   WITH PRIVILEGED ACCESS
     WHERE BillingDocument = @headwa-BillingDocument INTO @DATA(Distributionchannel).

     SELECT SINGLE * FROM I_BillingDocumentItem WHERE BillingDocument  = @headwa-BillingDocument  INTO @DATA(BILLINGQTY).

   SELECT SINGLE UserDescription FROM I_User   WITH PRIVILEGED ACCESS
     WHERE UserID = @headwa-CreatedByUser INTO @DATA(UserDescription).

   SELECT SINGLE UserDescription   FROM I_User   WITH PRIVILEGED ACCESS
   WHERE UserID = @headwa-useridecreate INTO @DATA(Userid).

     SELECT SINGLE * FROM I_IncotermsClassificationText  WHERE IncotermsClassification = @headwa-IncotermsClassification   AND language = 'E'  INTO @DATA(IncotermsClassification) .
     SELECT SINGLE * FROM I_CustomerPaymentTermsText WHERE  CustomerPaymentTerms = @headwa-CustomerPaymentTerms AND LANGUAGE = 'E' INTO @DATA(INCOTERMSTEXT) .


variable = |{ variable ALPHA = out }|.
SELECT SINGLE * FROM zpregen_exim WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA).
SELECT SINGLE * FROM YCONSIGNEDATA_PR1 WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA1).
SELECT SINGLE * FROM YEXIM_CALCULATPROJ WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA2).
SELECT SINGLE * FROM ydraft_bl_cds WHERE doctype = 'PS' AND docno = @variable INTO  @DATA(LDATA3).

*     SELECT SINGLE WBSElement FROM ZWBSELEMENT_F4   WITH PRIVILEGED ACCESS
*     WHERE WBSElementInternalID = @headwa-WBSElement INTO @DATA(WBSElement).

DATA: lo_tstmp   TYPE TZNTSTMPS,
      INV_TIME  TYPE  sy-uzeit.
if HEADWA-ActualGoodsMovementDate <> 00000000 .

   DATA GG TYPE STRING.
      convert date HEADWA-ActualGoodsMovementDate  time HEADWA-ActualGoodsMovementTime
      into time stamp lo_tstmp time zone ' '.    " HHH

data(INV)   = cl_abap_tstmp=>add( tstmp = lo_tstmp
                                secs  =  3600 ).

CONVERT TIME STAMP INV TIME ZONE 'UTC' INTO TIME  INV_TIME .


DATA K1 TYPE STRING .
DATA K2 TYPE STRING .
DATA K3 TYPE STRING .
DATA INV_TIME1 TYPE STRING .

K1 =  INV_TIME+0(2).
K2 = INV_TIME+2(2).
K3 = INV_TIME+4(2).
CONCATENATE K1 ':' K2 ':' K3 INTO INV_TIME1 .

ENDIF.

   DATA lv_xml TYPE STRING.




 DATA(export1)  = ''  .
 DATA(export2)  = ''  .
 DATA(export3)  = ''  .


 SELECT SINGLE CREATIONDATE FROM I_DeliveryDocument  WHERE  DeliveryDocument = @headwa-delivery_number INTO @DATA(DeliveryDate).

  SELECT FROM I_BillingDocumentItem as B
  LEFT OUTER JOIN I_BillingDocument as a ON ( a~BillingDocument = b~BillingDocument )
  LEFT OUTER JOIN I_SalesDocument as bb on ( bb~SalesDocument = b~SalesDocument )
  LEFT OUTER JOIN I_IN_PlantBusinessPlaceDetail AS h ON ( h~Plant = b~Plant )
    LEFT OUTER JOIN I_IN_BusinessPlaceTaxDetail AS i ON ( i~BusinessPlace = h~BusinessPlace )
    LEFT OUTER JOIN ZSD_I_ADDRESSID_2 AS j ON ( j~AddressID = i~AddressID   )
     FIELDS DISTINCT
*     a~YY1_PortofLoading_BDH,
*     a~YY1_PortOfDischarge_BDH,
*     a~YY1_BillofLadingLRRRNo_BDH,
     j~OrganizationName1 ,
     j~OrganizationName2 ,
     j~OrganizationName3 ,
     j~Street as Street2,
     j~StreetPrefixName1 ,
     j~StreetPrefixName2 ,
     j~StreetSuffixName1 ,
     j~StreetSuffixName2 ,
     j~CityName,
     j~DistrictName,
     j~PostalCode,
     i~IN_GSTIdentificationNumber,
     j~AddressID,
     j~EmailAddress,
     j~InternationalFaxNumber,
     j~InternationalPhoneNumber,
     b~TransactionCurrency,
     bb~CustomerPurchaseOrderDate,
     bb~PurchaseOrderByCustomer
*     a~YY1_TransportMode_BDH,
*     a~YY1_VehicleNumber_BDH





     WHERE b~BillingDocument = @variable INTO table @data(add) .

    READ TABLE add INTO data(address) INDEX 1  .

  CONCATENATE address-OrganizationName1 address-OrganizationName2 address-OrganizationName3 into data(add1)  SEPARATED BY space.
  CONCATENATE address-StreetPrefixName1 address-streetprefixname2 address-StreetSuffixName1
              address-DistrictName address-CityName  address-PostalCode  into data(toadd2)  SEPARATED BY space."Soldadd1regiontext2-RegionName
  data shiptopan2 TYPE string .
 shiptopan2 = address-IN_GSTIdentificationNumber+2(10).


*        DATA transport TYPE string.
*  if address-YY1_TransportMode_BDH = '01'.
*     transport = 'By Road'.
*    ELSEIF
*      address-YY1_TransportMode_BDH = '02'.
*     transport = 'By Sea'.
*    ELSEIF
*      address-YY1_TransportMode_BDH = '03'.
*     transport = 'By Air'.
*    ELSEIF
*      address-YY1_TransportMode_BDH = '04'.
*     transport = 'By Head'.
*    ELSEIF
*      address-YY1_TransportMode_BDH = '05'.
*     transport = 'By Courier'.
*   ENDIF.
DATA(lv_billingdoc) = |{ variable ALPHA = IN }|.
SELECT SINGLE plant FROM I_BillingDocumentItem WHERE BillingDocument = @lv_billingdoc INTO  @DATA(PLANT).
data : name1 type string .
data : addr1 type string .
data : addr2 type string .
data : tele type string .
data : email type string .
data : website type string .
data : iec type string .
data : gst type string .
data : pan type string .

CASE plant.
  WHEN '1000'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'PLOT E-10, 11, F-14 to 16, RIICO Industrial Area, Sitapura'.
    addr2   = 'Jaipur 302022'.
    tele    = '091-141-2770202, 2770203, 2770287'.
    email   = 'jaipur@poddarpigmentsltd.com'.
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '08AAACP1125E2ZY'.
    pan     = 'AAACP1125E'.

  WHEN '1100'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'PLOT E-10, 11, F-14 to 16, RIICO Industrial Area, Sitapura'.
    addr2   = 'Jaipur 302022'.
    tele    = '091-141-2770202, 2770203, 2770287'.
    email   = 'jaipur@poddarpigmentsltd.com'.
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '08AAACP1125E1ZZ'.
    pan     = 'AAACP1125E'.

  WHEN '1110'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'Greater Sitapura Industrial Park, National Highway 12 (Jaipur-Tonk Road), Brijpura village, Chaksu'.
    addr2   = 'Jaipur 303901'.
    tele    = '091-141-2770202, 2770203, 2770287'.
    email   = 'jaipur@poddarpigmentsltd.com'.
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '08AAACP1125E1ZZ'.
    pan     = 'AAACP1125E'.

  WHEN '1200'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'Rosy Tower, 3rd Floor 8, Mahatma Gandhi Road, Nungambakkam'.
    addr2   = 'Chennai 600034'.
    tele    = '091-141-2770202, 2770203, 2770287'.
    email   = 'jaipur@poddarpigmentsltd.com'.   "default
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '33AAACP1125E3Z4'.
    pan     = 'AAACP1125E'.

  WHEN '1210'.
    name1   = 'PODDAR PIGMENTS LIMITED'.
    addr1   = 'A-283 Ground floor Okhla Industrial Area Phase-1'.
    addr2   = 'New Delhi 110020'.
    tele    = '091-141-2770202, 2770203, 2770287'.
    email   = 'jaipur@poddarpigmentsltd.com'.   "default
    website = 'www.poddarpigmentsltd.com'.
    iec     = '0591047314'.
    gst     = '07AAACP1125E4ZY'.
    pan     = 'AAACP1125E'.

ENDCASE.
variable = |{ variable ALPHA = IN }|.

SELECT SINGLE a~billingdocument,
       a~transactioncurrency,
       b~currencyname
       FROM i_billingdocument AS A
       LEFT OUTER JOIN i_currencytext AS b ON ( B~Currency = A~TransactionCurrency AND B~Language = 'E' )
       WHERE BillingDocument = @variable INTO @DATA(currdata).


       DATA: lv_billingdocument       TYPE i_billingdocumentitem-billingdocument,
      lv_ref_doc_delivery      TYPE i_deliverydocumentitem-ReferenceSDDocument,
      lv_ref_doc_sales         TYPE i_salesdocumentitem-ReferenceSDDocument,
      lv_final_ref_doc_DATE    TYPE I_SalesQuotation-CreationDate,
      lv_ref_doc_contract      TYPE i_salescontractitem-ReferenceSDDocument.

SELECT SINGLE ReferenceSDDocument
  FROM I_BillingDocumentItem
  WHERE BillingDocument = @variable
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

   lv_xml =

   |<form1>| &&
   |<NAME1>{ name1 }</NAME1>| &&
   |<UNIT1>{ addr1 }</UNIT1>| &&
   |<UNIT2>{ addr2 }</UNIT2>| &&
*   |<Jurisdiction>Factory Address : { toadd2 }</Jurisdiction>| &&
*   |<add></add>| &&
   |<tel>: { tele }</tel>| &&
   |<email>: { email }</email>| &&
   |<web>: { website }</web>| &&    "{ address-InternationalFaxNumber }
   |<IECNO>: { iec } </IECNO>| &&
   |<GSTNO>: { gst }</GSTNO>| &&
   |<PANNO>: { pan }</PANNO>| &&
   |<Cancelled>: { HEADWA-BILLINGDOCUMENTISCANCELLED }</Cancelled>| &&
   |<INVOICE-NO>: { variable } </INVOICE-NO>| &&
   |<DATE>: { ldata-doc_date+6(2) }/{ ldata-doc_date+4(2) }/{ ldata-doc_date+0(4) }</DATE>| &&
*   |<DATE>: { ldata-doc_date }</DATE>| &&
   |<POnumber>: { ldata-refreance_no }</POnumber>| &&
   |<PODate>:  { ldata-refreance_date+6(2) }/{ ldata-refreance_date+4(2) }/{ ldata-refreance_date+0(4) }</PODate>| &&
   |<ProformaInvoiceNo>: { lv_final_ref_doc } </ProformaInvoiceNo>| &&
   |<ProformaInvoicedate>: { lv_final_ref_doc_DATE+6(2) }/{ lv_final_ref_doc_DATE+4(2) }/{ lv_final_ref_doc_DATE+0(4) }</ProformaInvoicedate>| &&
   |<exporterref>: </exporterref>| &&
   |<FinalDestination> { LDATA1-Constocountry } </FinalDestination>| &&
   |<ADDRESS>  { ldata1-Billtobuyrname }</ADDRESS>| &&
   |<LOGIC>  { ldata1-Billtostreet1 } { ldata1-Billtostreet2 } { ldata1-Billtostreet3 } { ldata1-Billtocity } { ldata1-Billtocountry } </LOGIC>| &&
   |<TEXT2>  { export2 }</TEXT2>| &&
   |<NOTIFY1>  { LDATA1-Notifyname }</NOTIFY1>| &&
   |<NOTIFY2>  { ldata1-Notifystreet1 } { ldata1-Notifystreet2 } { ldata1-Notifystreet3 } { ldata1-Notifycity } { ldata1-Notifycountry }</NOTIFY2>| &&
   |<NOTIFY3>  { export2 }</NOTIFY3>| &&
   |<air>: { ldata-precarrier }</air>| &&
   |<PlaceofReceipt>: </PlaceofReceipt>| &&
   |<VesselFlightNo.>: { ldata-vesselno }</VesselFlightNo.>| &&
   |<PortofLoading>: { ldata-portofloading }</PortofLoading>| &&
   |<PortofDischarge>: { ldata-portofdischarge }</PortofDischarge>| &&
   |<FinalDestination1>: { ldata-final_destination }</FinalDestination1>| &&
   |<BYERADDRESS> { LDATA1-Constoname }</BYERADDRESS>| &&
   |<BYERADDRESS1> { LDATA1-Constostreet1 } { LDATA1-Constostreet2 } </BYERADDRESS1>| &&
   |<BYERADDRESS2> { LDATA1-Constostreet3 } { LDATA1-Constocity } { LDATA1-Constocountry }</BYERADDRESS2>| &&
   |<ExchangeRate> { LDATA2-Exchangerate }  </ExchangeRate>| &&
   |<curr> { currdata-CurrencyName } </curr>| &&
   |<COUNTRY> </COUNTRY>| &&
   |<DESTINATION> { Billtoadd1-city } { billtocountry-CountryName }</DESTINATION>| &&
   |<Turms.of.Delevery>: { LDATA-deliveryterms  }  </Turms.of.Delevery>| &&
   |<PAYMENT>: { LDATA-payment_terms }</PAYMENT>| &&
   |<GROSSWT>: { LDATA2-Totalgrosswt  }</GROSSWT>| &&
   |<NETWT>: { LDATA2-Totalnetqty  }</NETWT>| &&
   |<Billoflading>: { '' }</Billoflading>| &&
   |<Date>: </Date>| &&
   |<shipingbillno>: </shipingbillno>| &&
   |<Date1>: </Date1>| .


DATA N TYPE I.
DATA BasicRate TYPE P DECIMALS 2.
data(it1) = it[].

*SORT it BY Material Basic_Amount.
*DELETE ADJACENT DUPLICATES FROM it COMPARING Material Basic_Amount.


SORT it BY billingdocumentitem.
DELETE ADJACENT DUPLICATES FROM it COMPARING billingdocumentitem.
*SELECT SINGLE * FROM I_BillingDocumentItem WHERE BillingDocument  = @headwa-BillingDocument
*and BillingDocumentItem = @headwa-BillingDocumentItem
*and BillingQuantity <> '' INTO @DATA(prodcode).


DATA(lv_first_row) = abap_true.
LOOP AT it INTO DATA(WA_ITEM).

*variable = |{ variable ALPHA = IN }|.


SELECT SINGLE * FROM I_BillingDocumentItem WHERE BillingDocument  = @variable
and BillingDocumentItem = @wa_item-BillingDocumentItem
and BillingQuantity <> '' INTO @DATA(prodcode).

SELECT SINGLE * FROM I_BILLINGDOCUMENTITEMPRCGELMNT WHERE BillingDocument = @variable
AND BillingDocumentItem = @wa_item-BillingDocumentItem
AND ConditionType = 'ZGIV' INTO @DATA(LAMOUNT).

SELECT SINGLE * FROM I_BillingDocument WHERE BillingDocument = @variable
*AND BillingDocumentItem = @wa_item-BillingDocumentItem
*AND ConditionType = 'ZGIV'
INTO @DATA(RATE).

DATA RATE2 TYPE P DECIMALS 2.
DATA TOTALAMOUNT TYPE P DECIMALS 2.

rate2 = lamount-ConditionBaseValue / rate-AccountingExchangeRate.

TOTALAMOUNT = rate2 * prodcode-BillingQuantity.

SELECT FROM @it1 AS A FIELDS sum( BillingQuantity )  AS qty , sum( Basic_Amount ) as Amt
WHERE Material = @wa_item-Material AND BasicRate = @wa_item-basicrate INTO @data(qty).


DATA RateINR TYPE P DECIMALS 2.
RateINR = wa_item-basicrate.

if WA_ITEM-BillingQuantityUnit = 'ST'.
WA_ITEM-BillingQuantityUnit  = 'Nos'.
ELSEif WA_ITEM-BillingQuantityUnit = 'ZST'.
WA_ITEM-BillingQuantityUnit  = 'Set'.
ENDIF.

*data(LONGTEXT) = zcl_sales_order_itemtext_data=>Sales_Order_ItemText_DATA(  salesorder =  WA_ITEM-sddocu salesorderitem = WA_ITEM-sddocuitem  salesorderitemtextid = '0001' )  .
data : LONGTEXT type string .
IF  WA_ITEM-DistributionChannel = '50'.

*data(HSNCODE) = zcl_sales_order_itemtext_data=>Sales_Order_ItemText_DATA(  salesorder =  WA_ITEM-sddocu salesorderitem = WA_ITEM-sddocuitem  salesorderitemtextid = 'ZHSN' )  .
data : HSNCODE type string .

IF HSNCODE <> ''.
WA_ITEM-Hsncode = HSNCODE.
ENDIF.
ENDIF.

IF LONGTEXT = '' AND WA_ITEM-BillingDocumentType = 'F2'.
LONGTEXT = WA_ITEM-MaterialDescription.
ENDIF.

IF WA_ITEM-BillingDocumentType <> 'F2'.
DATA(MATDES) = WA_ITEM-MaterialDescription.
ENDIF.
*   N = N + 1.
   BasicRate  = WA_ITEM-basicrate.

      SELECT COUNT( * ) FROM  I_DeliveryDocumentItem WHERE DeliveryDocument = @wa_item-ReferenceSDDocument
  and HigherLvlItmOfBatSpltItm = @wa_item-DELIVERY_NUMBER_item INTO @DATA(PCS).

  SELECT SINGLE * FROM I_BILLINGDOCUMENTITEMPRCGELMNT WHERE BillingDocument = @variable
AND BillingDocumentItem = @wa_item-BillingDocumentItem
and ConditionRateValue <> 0
AND ConditionType = 'ZPRI' INTO @DATA(LAMOUNT1).

  SELECT SINGLE * FROM I_BILLINGDOCUMENTITEMPRCGELMNT WHERE BillingDocument = @variable
AND BillingDocumentItem = @wa_item-BillingDocumentItem
and ConditionBaseValue <> 0
AND ConditionType = 'ZTIV' INTO @DATA(LAMOUNT2).

  IF lv_first_row = abap_true.

   lv_xml = lv_xml &&
   |<Row1>| &&
*   |   <S.No>{ N }</S.No>| &&
   |   <Containerno>{ ldata-containerno }</Containerno>| &&
   |   <Kindofpackages>{ ldata2-Totalpackages } { ldata2-Typeofpackages }</Kindofpackages>| &&
   |   <meterialdescription>| &&
*   |      <material>{ headwa-Material }</material>| &&
   |      <Description>{ LONGTEXT }</Description>| &&
*   |      <Description>{ prodcode-BillingDocumentItemText }</Description>| &&
   |   </meterialdescription>| &&
   |      <material>{ prodcode-Material }</material>| &&
*   |      <DescriptionTEXT>{ export2 }</DescriptionTEXT>| &&
   |   <HSN_SAC>{ WA_ITEM-Hsncode }</HSN_SAC>| &&
   |   <CUSTOMERHSNCODE>{ LDATA3-Customerhsncode }</CUSTOMERHSNCODE>| &&
   |   <quantity_kgs>{ prodcode-BillingQuantity }</quantity_kgs>| &&
*   |   <PCS>{ PCS }</PCS>| &&
   |   <Quantity>{ LAMOUNT1-ConditionRateValue }</Quantity>| &&
*   |   <RateINR>{ rate2 }</RateINR>| &&
   |   <Amount>{ LAMOUNT2-ConditionBaseValue }</Amount>| &&
   |</Row1>| .
    lv_first_row = abap_false.
    ELSE.
    lv_xml = lv_xml &&
   |<Row1>| &&
*   |   <S.No>{ N }</S.No>| &&
   |   <Containerno></Containerno>| &&
   |   <Kindofpackages></Kindofpackages>| &&
   |   <meterialdescription>| &&
*   |      <material>{ headwa-Material }</material>| &&
   |      <Description>{ LONGTEXT }</Description>| &&
*   |      <Description>{ prodcode-BillingDocumentItemText }</Description>| &&
   |   </meterialdescription>| &&
   |      <material>{ prodcode-Material }</material>| &&
*   |      <DescriptionTEXT>{ export2 }</DescriptionTEXT>| &&
   |   <HSN_SAC>{ WA_ITEM-Hsncode }</HSN_SAC>| &&
   |   <CUSTOMERHSNCODE>{ LDATA3-Customerhsncode }</CUSTOMERHSNCODE>| &&
   |   <quantity_kgs>{ prodcode-BillingQuantity }</quantity_kgs>| &&
*   |   <PCS>{ PCS }</PCS>| &&
   |   <Quantity>{ lamount1-ConditionRateValue }</Quantity>| &&
*   |   <RateINR>{ rate2 }</RateINR>| &&
   |   <Amount>{ LAMOUNT2-ConditionBaseValue }</Amount>| &&
   |</Row1>| .
       lv_first_row = abap_false.
ENDIF.
 CLEAR:WA_ITEM,BasicRate,LONGTEXT,qty,RateINR.

ENDLOOP.

  SELECT SINGLE FROM @IT1 AS a FIELDS
          SUM( totalTCS ) AS totalTCS,
          SUM( TCSAMT ) AS TCSAMT,
           SUM( Basic_Amount ) AS Basic_Amount,
           SUM( ZDIS_AMT ) AS ZDIS_AMT,
          SUM( ZFIR_AMT ) AS ZFIR_AMT,
           SUM( BillingQuantity ) AS qty
          WHERE BillingDocument = @variable INTO  @DATA(amt_tot).

 DATA AMOUNT TYPE I_BillingDocumentItemPrcgElmnt-ConditionAmount.
 DATA quantity TYPE I_BillingDocumentItem-BillingQuantityInBaseUnit.


DATA NetAmount TYPE P DECIMALS 2.
*data totalamount TYPE p DECIMALS 2.
*DATA TOTALQTY TYPE P DECIMALS 2.
AMOUNT  =  amt_tot-basic_amount + amt_tot-ZDIS_AMT + amt_tot-zfir_amt.
Quantity = quantity + billingqty-BillingQuantityInBaseUnit .

  SELECT SINGLE * FROM zbank_tms WHERE company = @HEADWA-CompanyCode INTO @DATA(bank).

*  DATA EPCGdata TYPE string.
*  EPCGdata = 'MATERIAL IS BEING SENT UNDER EPCG LICENSE AS PER THE DETAILS GIVEN BELOW UNDER EPCG LICENCE = '

   lv_xml = lv_xml &&
   |<Currency1>{ address-TransactionCurrency }</Currency1>| &&
   | <NOTEWORD></NOTEWORD>| &&
   | <prepaidby>{ UserDescription }</prepaidby>| &&
   |<AuthorisedSignatory>{ userid }</AuthorisedSignatory>| &&
   | <accholdername>: { add1 }</accholdername>| &&
   | <bankname>: { bank-name_of_bank }</bankname>| &&
   | <accountno>: { bank-bank_account_number }</accountno>| &&
   | <Branchifsccode>: { bank-bank_branch }{ bank-ifsc_code }</Branchifsccode>| &&
   | <INO>{ lv_final_ref_doc }</INO>| &&
   | <INOD>{ lv_final_ref_doc_DATE }</INOD>| &&
   | <EPCG>{ LDATA-epcgno }</EPCG>| &&
   | <EPCGd>{ LDATA-epcgdate }</EPCGd>| &&
*   | <EPCGdata>{ LDATA-epcgdate }</EPCGdata>| &&
   | </form1>| .



    CALL METHOD zadobe_print=>adobe(
      EXPORTING
        xml  = lv_xml
        form_name = TEMPLATE
      RECEIVING
        result   = result12 ).
ENDMETHOD.
ENDCLASS.
