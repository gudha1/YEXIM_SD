@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Exim Invoice Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity yinvdata_final as select from Y_INVOICEDATA  {
    key BillingDocument,
    TransactionCurrency,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(grossamtexim) as grossamt,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(GST) as gst_exim,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(ASSEEBLEAMT) as assesible,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(FREIGHT1) as freightX1,
     @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(FREIGHT2) as freightX2,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(OCEANFREIGHT) as OCEANFREIGHT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(INSURANCE1) as INSURANCE ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(ADDAMT) as ADDAMT,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(COMMISION1) as COMMISION1,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(COMMISION2) as COMMISION2 ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(INSURANCEPREMIUM) as INSURANCEPREMIUM ,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    sum(DISCOUNT) as DISCOUNT 
   
//    case when FREIGHT1 is null 
//        then cast( 0 as abap.sstring( 256 ) ) 
//        else
//    cast( FREIGHT1 * 1 as abap.sstring( 256 ) ) end as FRTEXIM1
//    
    
//    cast( cast( case when freight1 is not null then freight1  else 0 end as abap.char( 15 )CHAR  ) as abap.curr(10, 2 ) ) AS  EXIMFREIGHT1 ,
//    cast( cast( case when freight2 is not null then freight1  else 0 end as abap.int2  ) as abap.INT2 ) AS  EXIMFREIGHT2  
    
    
}
where TransactionCurrency <> ''
group by 
  BillingDocument,
  TransactionCurrency
 

  
  
