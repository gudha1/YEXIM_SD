@AbapCatalog.sqlViewName: 'YYLCF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds lc Report'
@Metadata.ignorePropagatedAnnotations: true
define view zsd_lc_report as select distinct from I_SalesDocumentItem as a
left outer join zsd_lc_table as b on (a.SalesDocument = b.salesdocument  and a.SalesDocumentItem = b.salesdocumentitem)
left outer join I_Customer as c on   (a.SoldToParty = c.Customer)
left outer join I_SalesDocument  as KK on  (KK.SalesDocument = a.SalesDocument)


{
    key  a.SalesDocument as Salesdocument,
     key   a.SalesDocumentItem,
//         a.SalesDocumentDate as Salesdocumentdate,

concat(
    concat(
        substring( cast( a.SalesDocumentDate as abap.char(10) ), 7 , 2 ),  -- DD
        '-'
    ),
    concat(
        substring( cast( a.SalesDocumentDate as abap.char(10) ), 5 , 2 ),  -- MM
        concat(
            '-',
            substring( cast( a.SalesDocumentDate as abap.char(10) ), 1 , 4 )  -- YYYY
        )
    )
) as Salesdocumentdate,


    
         a.SoldToParty,
       
         a.SalesDocumentItemText,
         a.OrderQuantity,
         a.NetPriceAmount,
         b.lccopy as Lccopy,
         b.lcnum as Lcnum,
         b.lcdate as Lcdate,
         b.lcexpirydate as Lcexpirydate,
         b.lcbankcountry as Lcbankcountry,
         b.draftsat as Draftsat,
         b.lcquantity as Lcquantity,
         b.lcvalue as Lcvalue,
         b.toleranceinlc as Toleranceinlc,
         b.lcunitprice as Lcunitprice,
         b.lastshipmentdate as Lastshipmentdate,
         b.presentationperiod as Presentationperiod,
         c.CustomerName,
         KK.IncotermsLocation1
         
       
       
    
         
         
}



         
      
         


