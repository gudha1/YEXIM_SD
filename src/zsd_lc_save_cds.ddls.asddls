@AbapCatalog.sqlViewName: 'YYF4LC'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for lc save data'
@Metadata.ignorePropagatedAnnotations: true
define view zsd_lc_save_cds as select  distinct from zsd_lc_table as a
left outer join zsd_lc_report as b on (a.salesdocument = b.Salesdocument and a.salesdocumentitem = b.SalesDocumentItem)
//and a.salesdocumentitem = b.SalesDocumentItem )
left outer join I_SalesDocument as C on (C.SalesDocument = a.salesdocument)
//l//eft outer join I_SalesDocument as c on (c.SalesDocument = b.Salesdocument  )

{
    key a.salesdocument as Salesdocument,
    key a.salesdocumentitem as Salesdocumentitem,
        a.salesdocumentdate as Salesdocumentdate,
        a.soldtoparty as Soldtoparty,
        a.customername as Customername,
        a.salesdocumentitemtext as Salesdocumentitemtext,
        a.orderquantity as Orderquantity,
        a.netpriceamount as Netpriceamount,
        a.lccopy as Lccopy,
        a.lcnum as Lcnum,
        a.lcdate as Lcdate,
        a.lcexpirydate as Lcexpirydate,
        a.lcbankcountry as Lcbankcountry,
        a.draftsat as Draftsat,
        a.lcquantity as Lcquantity,
        a.lcvalue as Lcvalue,
        a.toleranceinlc as Toleranceinlc,
        a.lcunitprice as Lcunitprice,
        a.lastshipmentdate as Lastshipmentdate,
        a.presentationperiod as Presentationperiod,
       // a.dischargeport as Dischargeport,
        a.destinationport as Destinationport,
        a.freedaysatdestination as Freedaysatdestination,
        a.anyotherspecialclause as Anyotherspecialclause,
        a.partialshipment as Partialshipment,
        a.transshipment as Transshipment,
        a.amendmnet as Amendmnet ,
        a.amendmnetdate ,
        a.amendmnetno  ,
        a.amendmentresion  ,
        a.swiftcode as SwiftCode,
        C.IncotermsLocation1 as IncotermsLocation1
       // c.IncotermsLocation1 as IncotermsLocation1
       
}
 
