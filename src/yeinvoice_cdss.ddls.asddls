@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Yenvoice Cds For E-envoicing'
define root view entity YEINVOICE_CDSS
  as select   from    I_BillingDocumentItem          as a

    left outer join I_BillingDocumentPartner       as bILLINGPARTNR            on  a.BillingDocument             = bILLINGPARTNR.BillingDocument
                                                                               and bILLINGPARTNR.PartnerFunction = 'RE'
                                                                              

    left outer join I_BillingDocumentItemBasic     as SHIPPINGPARTNR           on  a.BillingDocument              = SHIPPINGPARTNR.BillingDocument
                                                                               and a.BillingDocumentItem          =   SHIPPINGPARTNR.BillingDocumentItem
                                                                             //  and SHIPPINGPARTNR.PartnerFunction = 'WE'
  
   left outer join I_BillingDocumentPartner     as transporterPARTNR           on  a.BillingDocument              = transporterPARTNR.BillingDocument
                                                                               and transporterPARTNR.PartnerFunction = 'SP'
   
    left outer join I_BillingDocumentPartner       as SoldTOpaty              on  a.BillingDocument                 = SoldTOpaty.BillingDocument
                                                                               and SoldTOpaty.PartnerFunction = 'AG'

    left outer join I_BillingDocumentPartner       as Payerparty              on  a.BillingDocument                 = Payerparty.BillingDocument
                                                                               and Payerparty.PartnerFunction = 'RG'
                                                                               
    left outer join I_Customer                  as bILLINGPARTNRADDRESS     on bILLINGPARTNR.Customer = bILLINGPARTNRADDRESS.Customer

   left outer join I_Customer                   as SoldTOpatyADDRESS        on SoldTOpaty.Customer = SoldTOpatyADDRESS.Customer
 
   left outer join I_Customer                   as  PayerpartyRADDRESS      on Payerparty.Customer = PayerpartyRADDRESS.Customer
 
    left outer join I_Supplier                  as transporterPARTNRADDRESS on transporterPARTNR.Supplier = transporterPARTNRADDRESS.Supplier


 
    left outer join I_Customer                     as SHIPPINGPARTNRADDRESS    on SHIPPINGPARTNR.ShipToParty = SHIPPINGPARTNRADDRESS.Customer

    left outer join I_BillingDocumentItemPrcgElmnt as ZPR0                     on  a.BillingDocument     = ZPR0.BillingDocument
                                                                               and a.BillingDocumentItem = ZPR0.BillingDocumentItem
//                                                                                and  ( ZPR0.ConditionType    = 'ZR00' 
                                                                                    and ( ZPR0.ConditionType    = 'ZPRI'  )
//                                                                                or  ( ZPR0.ConditionType    = 'PCIP' and 
//                                                                                a.DistributionChannel = '03' ) ) 
                                                                               and (
                                                                                      ZPR0.ConditionInactiveReason != 'X'
                                                                                  and ZPR0.ConditionInactiveReason != 'M'
                                                                                  and ZPR0.ConditionInactiveReason != 'T'
                                                                                  and ZPR0.ConditionInactiveReason != 'K'
                                                                                  and ZPR0.ConditionInactiveReason != 'Y'
                                                                                )
   left outer join I_BillingDocumentItemPrcgElmnt as ZDRD1                     on  a.BillingDocument     = ZDRD1.BillingDocument
                                                                               and a.BillingDocumentItem = ZDRD1.BillingDocumentItem
                                                                                and  ZDRD1.ConditionType    = 'DRD1'
                                                                               and (
                                                                                      ZDRD1.ConditionInactiveReason != 'X'
                                                                                  and ZDRD1.ConditionInactiveReason != 'M'
                                                                                  and ZDRD1.ConditionInactiveReason != 'T'
                                                                                  and ZDRD1.ConditionInactiveReason != 'K'
                                                                                  and ZDRD1.ConditionInactiveReason != 'Y'
                                                                                )                                                                             
                                                                                
                                                                                
    left outer join I_BillingDocumentItemPrcgElmnt as ZFRT                     on  a.BillingDocument     = ZFRT.BillingDocument
                                                                               and a.BillingDocumentItem = ZFRT.BillingDocumentItem
                                                                               and ( ZFRT.ConditionType    = 'ZFFA' or ZFRT.ConditionType    = 'ZFPW' )
//                                                                                or ZFRT.ConditionType    = 'ZFCR'  )
                                                                               and ( 
                                                                                    ZFRT.ConditionInactiveReason != 'X'
                                                                               and  ZFRT.ConditionInactiveReason != 'M'
                                                                               and  ZFRT.ConditionInactiveReason != 'T'
                                                                               and  ZFRT.ConditionInactiveReason != 'K'
                                                                              and   ZFRT.ConditionInactiveReason != 'Y'  )    
                                                                                   

    left outer join I_BillingDocumentItemPrcgElmnt as JOIG                     on  a.BillingDocument     = JOIG.BillingDocument
                                                                               and a.BillingDocumentItem = JOIG.BillingDocumentItem
                                                                               and JOIG.ConditionType    = 'JOIG'
                                                                               and (
                                                                                    JOIG.ConditionInactiveReason != 'X'
                                                                               and  JOIG.ConditionInactiveReason != 'M'
                                                                               and  JOIG.ConditionInactiveReason != 'T'
                                                                               and  JOIG.ConditionInactiveReason != 'K'
                                                                               and  JOIG.ConditionInactiveReason != 'Y' ) 
                                                                                

    left outer join I_BillingDocumentItemPrcgElmnt as JOCG                     on  a.BillingDocument     = JOCG.BillingDocument
                                                                               and a.BillingDocumentItem = JOCG.BillingDocumentItem
                                                                               and JOCG.ConditionType    = 'JOCG'
                                                                               and ( 
                                                                                  JOCG.ConditionInactiveReason != 'X'
                                                                               and JOCG.ConditionInactiveReason != 'M'
                                                                               and JOCG.ConditionInactiveReason != 'T'
                                                                               and JOCG.ConditionInactiveReason != 'K'
                                                                               and JOCG.ConditionInactiveReason != 'Y' )
                                                                                  

    left outer join I_BillingDocumentItemPrcgElmnt as JOSG                     on  a.BillingDocument     = JOSG.BillingDocument
                                                                               and a.BillingDocumentItem = JOSG.BillingDocumentItem
                                                                               and JOSG.ConditionType    = 'JOSG'
                                                                               and ( 
                                                                               JOSG.ConditionInactiveReason     != 'X'
                                                                               and JOSG.ConditionInactiveReason != 'M'
                                                                               and JOSG.ConditionInactiveReason != 'T'
                                                                               and JOSG.ConditionInactiveReason != 'K'
                                                                               and JOSG.ConditionInactiveReason != 'Y' )
                                                                               
   left outer join I_BillingDocumentItemPrcgElmnt as JTCB                     on  a.BillingDocument     = JTCB.BillingDocument
                                                                               and a.BillingDocumentItem = JTCB.BillingDocumentItem
                                                                               and JTCB.ConditionType    = 'JTCB'
                                                                               and ( 
                                                                               JTCB.ConditionInactiveReason     != 'X'
                                                                               and JTCB.ConditionInactiveReason != 'M'
                                                                               and JTCB.ConditionInactiveReason != 'T'
                                                                               and JTCB.ConditionInactiveReason != 'K'
                                                                               and JTCB.ConditionInactiveReason != 'Y' )                                                                           
                                                                               

  left outer join I_BillingDocumentItemPrcgElmnt as ZTCS                      on  a.BillingDocument     = ZTCS.BillingDocument
                                                                               and a.BillingDocumentItem = ZTCS.BillingDocumentItem
                                                                               and ZTCS.ConditionType    = 'ZTCS'
                                                                            //   or ZTCS.ConditionType    = 'JTC1'
                                                                               and ( 
                                                                               ZTCS.ConditionInactiveReason     != 'X'
                                                                               and ZTCS.ConditionInactiveReason != 'M'
                                                                               and ZTCS.ConditionInactiveReason != 'T'
                                                                               and ZTCS.ConditionInactiveReason != 'K'
                                                                               and ZTCS.ConditionInactiveReason != 'Y' )
                                                                               
   left outer join I_BillingDocumentItemPrcgElmnt as JTC1                     on  a.BillingDocument     = JTC1.BillingDocument
                                                                               and a.BillingDocumentItem = JTC1.BillingDocumentItem
                                                                               and JTC1.ConditionType    = 'JTC2'
                                                                               and ( 
                                                                               JTC1.ConditionInactiveReason     != 'X'
                                                                               and JTC1.ConditionInactiveReason != 'M'
                                                                               and JTC1.ConditionInactiveReason != 'T'
                                                                               and JTC1.ConditionInactiveReason != 'K'
                                                                               and JTC1.ConditionInactiveReason != 'Y' )
                                                                               
    left outer join I_BillingDocumentItemPrcgElmnt as ZINS                     on  a.BillingDocument     = ZINS.BillingDocument
                                                                               and a.BillingDocumentItem = ZINS.BillingDocumentItem
                                                                               and ZINS.ConditionType    = 'ZINC'
                                                                               and ( 
                                                                               ZINS.ConditionInactiveReason      != 'X'
                                                                               and  ZINS.ConditionInactiveReason != 'M'
                                                                               and  ZINS.ConditionInactiveReason != 'T'
                                                                               and  ZINS.ConditionInactiveReason != 'K'
                                                                               and  ZINS.ConditionInactiveReason != 'Y' )
                                                                               
                                                                               

    left outer join I_BillingDocumentItemPrcgElmnt as ZADV                     on  a.BillingDocument     = ZADV.BillingDocument
                                                                               and a.BillingDocumentItem = ZADV.BillingDocumentItem
                                                                               and ZADV.ConditionType    = 'ZADV'
                                                                               and (
                                                                                   ZADV.ConditionInactiveReason     != 'X'
                                                                              and  ZADV.ConditionInactiveReason  != 'M'
                                                                              and   ZADV.ConditionInactiveReason != 'T'
                                                                              and  ZADV.ConditionInactiveReason  != 'K'
                                                                              and  ZADV.ConditionInactiveReason  != 'Y' )
                                                                              
    left outer join I_BillingDocumentItemPrcgElmnt as ZPAC                     on  a.BillingDocument     = ZPAC.BillingDocument
                                                                               and a.BillingDocumentItem = ZPAC.BillingDocumentItem
                                                                               and ZPAC.ConditionType    = 'ZPAC'
                                                                               and (
                                                                                ZPAC.ConditionInactiveReason != 'X'
                                                                                and ZPAC.ConditionInactiveReason != 'M'
                                                                                and ZPAC.ConditionInactiveReason != 'T'
                                                                                and ZPAC.ConditionInactiveReason != 'K'
                                                                                and ZPAC.ConditionInactiveReason != 'Y' )
                                                                                
   left outer join I_BillingDocumentItemPrcgElmnt as ZDIS                     on  a.BillingDocument     = ZDIS.BillingDocument
                                                                               and a.BillingDocumentItem = ZDIS.BillingDocumentItem
                                                                               and ( ZDIS.ConditionType    = 'ZDPQ' or ZDIS.ConditionType    = 'ZDCH' or
                                                                                ZDIS.ConditionType    = 'ZDFA' )    //or ZDIS.ConditionType    = 'ZDCM' or ZDIS.ConditionType    = 'ZADC'  )//ASHISH
                                                                               and ( ZDIS.ConditionInactiveReason != 'X'
                                                                               and   ZDIS.ConditionInactiveReason != 'M'
                                                                               and   ZDIS.ConditionInactiveReason != 'T'
                                                                               and   ZDIS.ConditionInactiveReason != 'K'
                                                                               and   ZDIS.ConditionInactiveReason != 'Y' )                                                                                                                                                        

    left outer join I_BillingDocumentItemPrcgElmnt as ZBCC                     on  a.BillingDocument     = ZBCC.BillingDocument
                                                                               and a.BillingDocumentItem = ZBCC.BillingDocumentItem
                                                                               and ZBCC.ConditionType    = 'ZBCC'
                                                                               and (
                                                                                 ZBCC.ConditionInactiveReason != 'X'
                                                                                and  ZBCC.ConditionInactiveReason != 'M'
                                                                                and  ZBCC.ConditionInactiveReason != 'T'
                                                                                and  ZBCC.ConditionInactiveReason != 'K'
                                                                                and  ZBCC.ConditionInactiveReason != 'Y' )
                                                                                
                                                                                
   left outer join I_BillingDocumentItemPrcgElmnt as ZBCR                       on  a.BillingDocument     = ZBCR.BillingDocument
                                                                                and a.BillingDocumentItem = ZBCR.BillingDocumentItem
                                                                                and ZBCR.ConditionType    = 'ZBCR'
                                                                                and (ZBCR.ConditionInactiveReason != 'X'
                                                                                and  ZBCR.ConditionInactiveReason != 'M'
                                                                                and  ZBCR.ConditionInactiveReason != 'T'
                                                                                and  ZBCR.ConditionInactiveReason != 'K'
                                                                                and  ZBCR.ConditionInactiveReason != 'Y' )                                                                           
                                                                                
    left outer join I_BillingDocumentItemPrcgElmnt as ZFIR                     on  a.BillingDocument     = ZFIR.BillingDocument
                                                                               and a.BillingDocumentItem = ZFIR.BillingDocumentItem
                                                                               and ZFIR.ConditionType    = 'ZFIR'
                                                                               and ZFIR.ConditionAmount is not initial 
                                                                               and ( ZFIR.ConditionInactiveReason != 'X'
                                                                               and ZFIR.ConditionInactiveReason != 'M'
                                                                               and ZFIR.ConditionInactiveReason != 'T'
                                                                               and ZFIR.ConditionInactiveReason != 'K'
                                                                               and ZFIR.ConditionInactiveReason != 'Y' )


   
    left outer join I_BillingDocumentItemPrcgElmnt as ZENDC                     on  a.BillingDocument     = ZENDC.BillingDocument
                                                                               and a.BillingDocumentItem = ZENDC.BillingDocumentItem
                                                                               and ZENDC.ConditionType    = 'ZE&C'
                                                                               and ( ZENDC.ConditionInactiveReason != 'X'
                                                                                and ZENDC.ConditionInactiveReason != 'M'
                                                                                and ZENDC.ConditionInactiveReason != 'T'
                                                                                and ZENDC.ConditionInactiveReason != 'K'
                                                                                and ZENDC.ConditionInactiveReason != 'Y' )


    left outer join I_BillingDocumentItemPrcgElmnt as ZFIV                     on  a.BillingDocument     = ZFIV.BillingDocument
                                                                               and a.BillingDocumentItem = ZFIV.BillingDocumentItem
                                                                               and ZFIV.ConditionType    = 'ZFIV'
                                                                               and ( ZFIV.ConditionInactiveReason != 'X'
                                                                               and ZFIV.ConditionInactiveReason != 'M'
                                                                               and ZFIV.ConditionInactiveReason != 'T'
                                                                               and ZFIV.ConditionInactiveReason != 'K'
                                                                               and ZFIV.ConditionInactiveReason != 'Y' )
//STO PRICING CONDITION
  left outer join I_BillingDocumentItemPrcgElmnt as ZFWD                       on  a.BillingDocument     = ZFWD.BillingDocument
                                                                               and a.BillingDocumentItem = ZFWD.BillingDocumentItem
                                                                               and ZFWD.ConditionType    = 'ZFWD'
                                                                               and ( ZFWD.ConditionInactiveReason != 'X'
                                                                               and ZFWD.ConditionInactiveReason != 'M'
                                                                               and ZFWD.ConditionInactiveReason != 'T'
                                                                               and ZFWD.ConditionInactiveReason != 'K'
                                                                               and ZFWD.ConditionInactiveReason != 'Y' )
  
    left outer join I_BillingDocumentItemPrcgElmnt as ZISP                       on  a.BillingDocument     = ZISP.BillingDocument
                                                                               and a.BillingDocumentItem = ZISP.BillingDocumentItem
                                                                               and ZISP.ConditionType    = 'ZISP'
                                                                               and ( ZISP.ConditionInactiveReason != 'X'
                                                                               and ZISP.ConditionInactiveReason != 'M'
                                                                               and ZISP.ConditionInactiveReason != 'T'
                                                                               and ZISP.ConditionInactiveReason != 'K'
                                                                               and ZISP.ConditionInactiveReason != 'Y' )
                                                                               
     left outer join I_BillingDocumentItemPrcgElmnt as ZMIS                       on  a.BillingDocument     = ZMIS.BillingDocument
                                                                               and a.BillingDocumentItem = ZMIS.BillingDocumentItem
                                                                               and ZMIS.ConditionType    = 'ZMIS'
                                                                               and ( ZMIS.ConditionInactiveReason != 'X'
                                                                               and ZMIS.ConditionInactiveReason != 'M'
                                                                               and ZMIS.ConditionInactiveReason != 'T'
                                                                               and ZMIS.ConditionInactiveReason != 'K'
                                                                               and ZMIS.ConditionInactiveReason != 'Y' )
                                                                               
    left outer join I_BillingDocumentItemPrcgElmnt as ZOTH                       on  a.BillingDocument     = ZOTH.BillingDocument
                                                                               and a.BillingDocumentItem = ZOTH.BillingDocumentItem
                                                                               and  ( ZOTH.ConditionType    = 'ZP01' or ZOTH.ConditionType    = 'ZP02' )
                                                                               and ( ZOTH.ConditionInactiveReason != 'X'
                                                                               and ZOTH.ConditionInactiveReason != 'M'
                                                                               and ZOTH.ConditionInactiveReason != 'T'
                                                                               and ZOTH.ConditionInactiveReason != 'K'
                                                                               and ZOTH.ConditionInactiveReason != 'Y' )                                                                          
   
     left outer join I_BillingDocumentItemPrcgElmnt as ZODC                    on  a.BillingDocument     = ZODC.BillingDocument
                                                                               and a.BillingDocumentItem    = ZODC.BillingDocumentItem
                                                                               and ZODC.ConditionType    = 'ZODC'
                                                                               and ( ZODC.ConditionInactiveReason != 'X'
                                                                               and ZODC.ConditionInactiveReason != 'M'
                                                                               and ZODC.ConditionInactiveReason != 'T'
                                                                               and ZODC.ConditionInactiveReason != 'K'
                                                                               and ZODC.ConditionInactiveReason != 'Y' )
                                                                               
     left outer join I_BillingDocumentItemPrcgElmnt as ZPVC                    on  a.BillingDocument     = ZPVC.BillingDocument
                                                                               and a.BillingDocumentItem = ZPVC.BillingDocumentItem
                                                                               and ZPVC.ConditionType    = 'ZPVC'
                                                                               and ( ZPVC.ConditionInactiveReason != 'X'
                                                                               and ZPVC.ConditionInactiveReason != 'M'
                                                                               and ZPVC.ConditionInactiveReason != 'T'
                                                                               and ZPVC.ConditionInactiveReason != 'K'
                                                                               and ZPVC.ConditionInactiveReason != 'Y' )                                                                                                                                                                                                                                                                                                                 

   left outer join I_BillingDocumentItemPrcgElmnt as ZDRG                    on  a.BillingDocument     = ZDRG.BillingDocument
                                                                               and a.BillingDocumentItem = ZDRG.BillingDocumentItem
                                                                               and ZDRG.ConditionType    = 'ZDRG'
                                                                               and ( ZDRG.ConditionInactiveReason != 'X'
                                                                               and ZDRG.ConditionInactiveReason != 'M'
                                                                               and ZDRG.ConditionInactiveReason != 'T'
                                                                               and ZDRG.ConditionInactiveReason != 'K'
                                                                               and ZDRG.ConditionInactiveReason != 'Y' ) 
   
   left outer join I_BillingDocumentItemPrcgElmnt as ZPRT                     on  a.BillingDocument     = ZPRT.BillingDocument
                                                                               and a.BillingDocumentItem = ZPRT.BillingDocumentItem
                                                                                and ZPRT.ConditionType    = 'ZPRT'
                                                                               and (
                                                                                      ZPRT.ConditionInactiveReason != 'X'
                                                                                  and ZPRT.ConditionInactiveReason != 'M'
                                                                                  and ZPRT.ConditionInactiveReason != 'T'
                                                                                  and ZPR0.ConditionInactiveReason != 'K'
                                                                                  and ZPRT.ConditionInactiveReason != 'Y'
                                                                                )
     
------------ADDED BY VISHWAJEET FOR NATE RATE                                                                                 
       left outer join I_BillingDocumentItemPrcgElmnt as ZTIV                     on  a.BillingDocument     = ZTIV.BillingDocument
                                                                               and a.BillingDocumentItem = ZTIV.BillingDocumentItem
                                                                                and ZTIV.ConditionType    = 'ZTIV'
                                                                               and (
                                                                                      ZTIV.ConditionInactiveReason != 'X'
                                                                                  and ZTIV.ConditionInactiveReason != 'M'
                                                                                  and ZTIV.ConditionInactiveReason != 'T'
                                                                                  and ZTIV.ConditionInactiveReason != 'K'
                                                                                  and ZTIV.ConditionInactiveReason != 'Y'
                                                                                )                                                                                                                                                         

    left outer join I_ProductText                  as maktx                    on  a.Material     = maktx.Product
                                                                               and maktx.Language = 'E'

    left outer join I_ProductPlantBasic            as HSNCODE                  on  a.Material = HSNCODE.Product
                                                                               and a.Plant    = HSNCODE.Plant
    left outer join I_BillingDocumentBasic         as DOCHEAD                  on a.BillingDocument = DOCHEAD.BillingDocument
    left outer join YJ1IG_EWAYBILLDD               as EWAYBILL                 on a.BillingDocument = EWAYBILL.Docno
    left outer join Y1IG_INVREFNUM_DD              as IRNDETALS                on a.BillingDocument = IRNDETALS.Docno
    left outer join I_DeliveryDocument             as DELIVERYDATA             on a.ReferenceSDDocument = DELIVERYDATA.DeliveryDocument
    left outer join I_SalesDocument                as SalesDATA                on a.SalesDocument = SalesDATA.SalesDocument
    
    left outer join I_BillingDocument              as RSJ on a.BillingDocument = RSJ.BillingDocument 
   
//    left outer join I_DeliveryDocumentItem as bb on ( bb.DeliveryDocument = DELIVERYDATA.DeliveryDocument )
//                                            and bb.DeliveryDocumentItemCategory = 'CB99' )
//    left outer join I_DeliveryDocumentItem as b1 on ( b1.DeliveryDocument = bb.DeliveryDocument and b1.DeliveryDocumentItem = bb.DeliveryDocumentItem
//                                                     and b1.HigherLvlItmOfBatSpltItm = bb.HigherLvlItmOfBatSpltItm  and b1.DeliveryDocumentItemCategory = 'CB99'
//                                                     and b1.Material = bb.Material and b1.Batch is not initial )
                     {

  key a.BillingDocument,
  key a.BillingDocumentItem,
  key a.CompanyCode,
      a.Plant,
      a.Batch,
      a.Material,
      a.Division,
      maktx.ProductName                                                                              as MaterialDescription,
      HSNCODE.ConsumptionTaxCtrlCode                                                                 as Hsncode,
      a.BillingQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      a.BillingQuantity,
      a.TransactionCurrency,
      a.BillingQuantityUnit                                                                          as unit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.NetAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.GrossAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      a.TaxAmount,

      a.ReferenceSDDocument                                                                          as DELIVERY_NUMBER,
      a.ReferenceSDDocumentItem                                                                      as DELIVERY_NUMBER_item,
      a.SalesDocument as SDDOCU,
      a.SalesDocumentItem as SDDOCUITEM ,
      a.ReferenceSDDocument,
      cast(a.WBSElement as abap.char( 8 ) ) as WBSElement, 
      
//      a.YY1_PCs_BDI,
//      a.YY1_Cut_BDI,                                                                       

      bILLINGPARTNR.Customer                                                                         as BILLTOPARTY,
      bILLINGPARTNRADDRESS.AddressID           as  bILLINGPARTNRAddreid,
      bILLINGPARTNRADDRESS.CustomerName,
      bILLINGPARTNRADDRESS.CustomerFullName,
      bILLINGPARTNRADDRESS.TaxNumber3                                                                as billinggstin,
      bILLINGPARTNRADDRESS.StreetName,
      bILLINGPARTNRADDRESS.Region,
       bILLINGPARTNRADDRESS.Country,
      bILLINGPARTNRADDRESS.CityName,
      bILLINGPARTNRADDRESS.PostalCode,
      
      SoldTOpaty.Customer                      as SoldTOpaty,
      SoldTOpatyADDRESS.AddressID             as  SoldTOpatyAddreid,
      SoldTOpatyADDRESS.CustomerName          as  SoldTOpatyCustomerName,
      SoldTOpatyADDRESS.CustomerFullName      as  SoldTOpatyCustomerFullName,
      SoldTOpatyADDRESS.TaxNumber3            as  SoldTOpatyTaxNumber3  ,
      SoldTOpatyADDRESS.StreetName            as  SoldTOpatyStreetName,
      SoldTOpatyADDRESS.Region                as  SoldTOpatyRegion,
      SoldTOpatyADDRESS.CityName              as  SoldTOpatyCityName,
      SoldTOpatyADDRESS.PostalCode            as  SoldTOpatyPostalCode,
      
      
      Payerparty.Customer                    as Payerparty,
      PayerpartyRADDRESS.AddressID           as PayerpartYAddreid,
      PayerpartyRADDRESS.CustomerName        as PayerpartyCustomerName,
      PayerpartyRADDRESS.CustomerFullName    as PayerpartyCustomerFullName,
      PayerpartyRADDRESS.TaxNumber3          as PayerpartyTaxNumber3 ,
      PayerpartyRADDRESS.StreetName          as PayerpartyStreetName,
      PayerpartyRADDRESS.Region              as PayerpartyRegion,
      PayerpartyRADDRESS.CityName            as PayerpartyCityName,
      PayerpartyRADDRESS.PostalCode          as PayerpartyPostalCode,
   
      SHIPPINGPARTNR.ShipToParty                                                                     as ShippingPartner,
      SHIPPINGPARTNRADDRESS.AddressID                                                                as SHIPPINGPARTNRAddreid,
      SHIPPINGPARTNRADDRESS.CustomerName                                                             as SHIPTONAME,
      SHIPPINGPARTNRADDRESS.CustomerFullName                                                         as SHIPTOFULLNAME,
      SHIPPINGPARTNRADDRESS.StreetName                                                               as SHIPTOADDRSS,
      SHIPPINGPARTNRADDRESS.TaxNumber3                                                               as SHIPPINGPARTNRgstin,
      SHIPPINGPARTNRADDRESS.Region                                                                   as SHIPTOREGION,
      SHIPPINGPARTNRADDRESS.CityName                                                                 as SHIPTOCITY,
      SHIPPINGPARTNRADDRESS.PostalCode                                                               as SHIPTOPO,


      transporterPARTNR.AddressID                                                                    as transpoter1,
      transporterPARTNR.Customer                                                                     as transpotercustomer,
      transporterPARTNR.Supplier                                                                     as transpotersupplier,


      transporterPARTNRADDRESS.TaxNumber3                                                            as TRANSID,
      transporterPARTNRADDRESS.SupplierName                                                          as transname,
      transporterPARTNRADDRESS.SupplierFullName                                                      as TRANSPORTERNAME,
      transporterPARTNRADDRESS.Supplier                                                              as TransDocNo1,
      transporterPARTNRADDRESS.TaxNumber4                                                            as VEHICLENUMBER2,



      ZPR0.ConditionType                                                                             as CONDTYPE,
      ZPR0.ConditionCurrency                                                                         as CURRENCY,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZPR0.ConditionRateAmount                                                                       as BASICRATE,
      ZPR0.ConditionAmount                                                                           as Basic_Amount,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZDRD1.ConditionRateAmount                                                                       as Roundingrate,
      ZDRD1.ConditionAmount                                                                           as RoundingAmount,
      
      ZINS.ConditionType                                                                             as CONDTY,
      ZINS.ConditionRateRatioUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZINS.ConditionRateRatio                                                                        as INSURANCEPERCENTAGE,
      ZINS.ConditionAmount                                                                           as ZINSAMT,

      ZBCC.ConditionCurrency                                                                         as ZBCCCURRENCY,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZBCC.ConditionRateAmount                                                                       as ZBCC_RATE,
      ZBCC.ConditionAmount                                                                           as ZBCC_Amount,
      
      ZBCR.ConditionCurrency                                                                         as ZBCRCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZBCR.ConditionRateAmount                                                                       as ZBCR_RATE,
      ZBCR.ConditionAmount                                                                           as ZBCR_Amount,    
      
      
      
      ZFRT.ConditionType                                                                             as FREIGHT1,
      ZFRT.ConditionAmount                                                                           as FREIGHT1AMT,

      ZPAC.ConditionAmount                                                                           as ZPAC_PaclingAmt,
      ZPAC.ConditionType                                                                             as ZPAC_COND,
      

      ZDIS.ConditionAmount                                                                           as ZDIS_AMT,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZDIS.ConditionRateAmount                                                                       as ZDIS_rate,  
      ZDIS.ConditionType                                                                             as ZDIS_COND,
      
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZADV.ConditionRateRatio                                                                        as ADVRATE,
      ZADV.ConditionAmount                                                                           as ZADV_AMT,
      ZADV.ConditionType                                                                             as ZADV_COND,

      ZFIR.ConditionAmount                                                                           as ZFIR_AMT,
      ZFIR.ConditionType                                                                             as ZFIR_COND,

      ZENDC.ConditionAmount                                                                           as ZENDC_AMT,
      ZENDC.ConditionType                                                                             as ZENDC_COND,

      ZFIV.ConditionAmount                                                                           as ZFIV_AMT,
      ZFIV.ConditionType                                                                             as ZFIV_COND,
      
      ZFWD.ConditionAmount                                                                           as ZFWD_AMT,
      ZFWD.ConditionType                                                                             as ZFWD_COND,
      
      ZISP.ConditionAmount                                                                           as ZISP_AMT,
      ZISP.ConditionType                                                                             as ZISP_COND,
      
      ZMIS.ConditionAmount                                                                           as ZMIS_AMT,
      ZMIS.ConditionType                                                                             as ZMIS_COND,
      
      ZOTH.ConditionAmount                                                                           as ZOTH_AMT,
      ZOTH.ConditionType                                                                             as ZOTH_COND,
      
      ZODC.ConditionAmount                                                                           as ZODC_AMT,
      ZODC.ConditionType                                                                             as ZODC_COND,
      
      ZPRT.ConditionAmount                                                                           as ZPRT_AMT,
      ZPRT.ConditionType                                                                             as ZPRT_COND,
      
      ZTIV.ConditionAmount                                                                           as ZTIV_AMT,  -----VISHWAJEET
      ZPRT.ConditionType                                                                             as ZTIV_COND,
      
      ZPVC.ConditionAmount                                                                           as ZPVC_AMT,
      ZPVC.ConditionType                                                                             as ZPVC_COND,
      
      ZDRG.ConditionAmount                                                                           as ZDRG_AMT,
      ZDRG.ConditionType                                                                             as ZDRG_COND,
      
      JOIG.ConditionType                                                                             as TAXCOND1,
      JOIG.ConditionRateRatioUnit                                                                    as igstunit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      JOIG.ConditionRateRatio                                                                        as IGSTRATE,
      JOIG.ConditionAmount                                                                           as IGST,
      JOIG.ConditionBaseValue                                                                        as Assesmentvalue_inIgst,

      JOCG.ConditionType                                                                             as TAXCOND2,
      JOCG.ConditionRateRatioUnit                                                                    as cgstunit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      JOCG.ConditionRateRatio                                                                        as CGSTRATE,
      JOCG.ConditionAmount                                                                           as CGST,
      JOCG.ConditionBaseValue                                                                        as Assesmentvalue_inGst,

      JOSG.ConditionType                                                                             as TAXCOND3,
      JOIG.ConditionRateRatioUnit                                                                    as sgstunit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      JOSG.ConditionRateRatio                                                                        as SGSTRATE,
      JOSG.ConditionAmount                                                                           as SGST,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZTCS.ConditionRateRatio                                                                        as TCSRATE,
      ZTCS.ConditionAmount                                                                           as TCSAmt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      JTC1.ConditionRateRatio                                                                        as JTC1RATE,
      JTC1.ConditionAmount                                                                           as JTC1Amt,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      JTCB.ConditionRateRatio                                                                        as JTCBRATE,
      JTCB.ConditionAmount                                                                           as JTCBAmt,
      //ZLDA','ZPCA','JTC1','JTC2'
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ( JOCG.ConditionAmount  + JOSG.ConditionAmount + JOIG.ConditionAmount )                        as totalGST,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ( JTC1.ConditionAmount + JTCB.ConditionAmount)                                                 as totalTCS,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ( ZFRT.ConditionAmount )                                                                       as totalfreight,
    //  @Semantics.amount.currencyCode: 'TransactionCurrency'
    //  ( ZPAC.ConditionAmount + JTC1.ConditionAmount + JTC2.ConditionAmount  ) as OTHERCHARGES,
      DOCHEAD.BillingDocumentDate,
      DOCHEAD.TotalNetAmount                                                                         as docuhead_netamt,
      DOCHEAD.TotalTaxAmount                                                                         as docuhead_total_tax,
      DOCHEAD.IncotermsClassification,
      DOCHEAD.PaymentMethod,
      DOCHEAD.SDPricingProcedure,     
      DOCHEAD.CustomerPaymentTerms,
      DOCHEAD.IncotermsTransferLocation,
//   DOCHEAD .YY1_TransportMode_BDH  as TransDocNo,
//     DOCHEAD.YY1_VehicleNumber_BDH         as VEHICLENUMBER, 
     
      DOCHEAD.BillingDocumentType,
      DOCHEAD.CreatedByUser,
      DOCHEAD.BillingDocumentIsCancelled,
      IRNDETALS.SignedInv,
      IRNDETALS.SignedQrcode,
      IRNDETALS.Irn,
      IRNDETALS.IrnStatus,
      IRNDETALS.AckNo,
      IRNDETALS.useridecreate,
      IRNDETALS.AckDate,
      EWAYBILL.Ebillno,        
      EWAYBILL.EgenDat,
//      EWAYBILL.validupto,
      EWAYBILL.Status,
      EWAYBILL.Distance, 
      EWAYBILL.Vdtodate,
      EWAYBILL.Vdfmdate,  
      DELIVERYDATA.DeliveryDate,
      DELIVERYDATA.ActualGoodsMovementTime,
      DELIVERYDATA.ActualGoodsMovementDate,
      SalesDATA.PurchaseOrderByCustomer,
      SalesDATA.CustomerPurchaseOrderDate,
//      SalesDATA.YY1_Market_SDH ,
//      DOCHEAD.YY1_VehicleNumber_BDH,
//      
      a.DistributionChannel,
      RSJ.SDDocumentCategory    
      //      RSJ.YY1_LCBank_BDH,
//      RSJ.YY1_LCDate_BDH
//      b1.Batch as Batch1,
//      b1.Material as material2,
//      bb.HigherLvlItmOfBatSpltItm    as BATCH_ITEM
      

}
where a.BillingQuantity <> 0.000



