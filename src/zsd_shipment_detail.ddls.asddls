@AbapCatalog.sqlViewName: 'YYSHIPF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for shipment details'
@Metadata.ignorePropagatedAnnotations: true
define view zsd_shipment_detail as select distinct from I_BillingDocumentBasic as a
left outer join I_BillingDocumentItem as c on (c.BillingDocument = a.BillingDocument) 
left outer join ZSD_PATNERFUNTION_CDS as CF on (CF.BillingDocument = a.BillingDocument  )
left outer join zshiping_table as d on (d.billingdocument =a.BillingDocument and d.billingdocumentitem = c.BillingDocumentItem)
left outer join I_BillingDocItemPrcgElmntBasic as mm on (mm.BillingDocument = a.BillingDocument  and mm.ConditionType = 'ZFOC' )
left outer join I_Customer as SD on  (SD.Customer = a.SoldToParty)
left outer join I_DeliveryDocumentItem as PP on ( PP.DeliveryDocument = c.ReferenceSDDocument    and PP.DeliveryDocumentItem = c.ReferenceSDDocumentItem   )


{

    key a.BillingDocument,
     key c.SalesDocument,
     key c.BillingDocumentItem,
       a.SoldToParty,
         SD.CustomerName,
        a.BillingDocumentDate,
        c.BillingDocumentItemText,
//        a.YY1_LCDate_BDH,
//        a.YY1_LCNo_BDH,
//        a.YY1_VehicleContainerNu_BDH,
        a.IncotermsLocation1,
        c.BillingQuantity,
        d.gateopen as Gateopen,
        d.cuttoff as Cuttoff,
        d.getin as Getin,
        d.remark as Remark,
//        a.YY1_VesselFlightNo_BDH,
        d.sob as Sob,
        d.trasittime as Trasittime,
        d.blremark as Blremark,
        d.obl as Obl,
        d.billreciveaging as Billreciveaging,
        d.billnum as Billnum,
        d.billcurritracnum as Billcurritracnum,
        d.billsummr as Billsummr,
        d.lds as Lds,
//        a.YY1_VehicleNumber_BDH ,
        d.eta as Eta,
        d.sobblfollowup as Sobblfollowup,
        d.draftok as Draftok,
        d.oceanfright as Oceanfright,
        d.lotno as Lotno,
        d.bokking as Bokking,
        d.shpingline as Shpingline,
        d.telex as Telex,
        d.place_container_of_receipt as PlaceContainerOfReceipt,
        d.billreciveaging_date,
        d.agingsobdate,
        mm.ConditionRateAmount,
        mm.ConditionType,
//        PP.YY1_LotNo_DLI,
        CF.CLAGENT,
        CF.FORWARTAGENT
      
        
        
        


        
        
        
      
} ///where mm.ConditionType = 'ZFOC'
  
