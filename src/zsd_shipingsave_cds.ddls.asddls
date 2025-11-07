@AbapCatalog.sqlViewName: 'YYSAVE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'cds for gatting Shiping cds'
@Metadata.ignorePropagatedAnnotations: true
define view zsd_shipingsave_cds as select from zshiping_table as a
left outer join zsd_shipment_detail as b on (a.billingdocument = b.BillingDocument and a.billingdocumentitem = b.BillingDocumentItem)


{


   key a.billingdocument as BillingDocument,
   key a.salesdocument as SalesDocument,
   key a.billingdocumentitem as BillingDocumentItem,
    a.soldtoparty  as SoldToParty,
       a.billingdocumentdate as BillingDocumentDate,                   
       a.yy1_lcno_bdh as    YY1_LCNo_BDH,                              
       a.billingquantity as BillingQuantity,                           
       a.gateopen as Gateopen,                                         
       a.cuttoff as Cuttoff,                                           
       a.getin as Getin,                                               
       a.incotermslocation1 as IncotermsLocation1,                     
       a.remark as Remark,                                             
       a.yy1_vesselflightno_bdh as YY1_VesselFlightNo_BDH,             
       a.sob as Sob,                                                   
       a.trasittime as Trasittime,                                     
       a.blremark as Blremark,                                         
       a.obl as Obl,                                                   
       a.billreciveaging as Billreciveaging,                           
       a.billreciveaging_date as billreciveaging_date,                 
       a.billnum as Billnum,                                           
       a.billcurritracnum as Billcurritracnum,                         
       a.billsummr as Billsummr,                                       
       a.lds as Lds,                                                   
       a.forwartagent as FORWARTAGENT,                                                                                
       a.yy1_vehiclenumber_bdh as YY1_VehicleNumber_BDH,              
       a.eta as Eta,                                                   
       a.sobblfollowup as Sobblfollowup,                               
       a.draftok as Draftok,                                             
       a.conditionrateamount as ConditionRateAmount,                     
       a.yy1_lotno_dli  as YY1_LotNo_DLI ,                                                    
       a.bokking as Bokking,                                                
       a.shpingline as Shpingline,                                          
       a.telex as Telex,                                                    
       a.place_container_of_receipt as PlaceContainerOfReceipt ,             
       a.yy1_vehiclecontainernu_bdh as YY1_VehicleContainerNu_BDH,          
       a.yy1_lcdate_bdh as YY1_LCDate_BDH,                                  
       a.agingsobdate as Agingsobdate,                                      
       a.customername  as  CustomerName,                                 
       a.clagent as CLAGENT,                                                
       a.billingdocumentitemtext as BillingDocumentItemText 
   
   


//  
        
}
