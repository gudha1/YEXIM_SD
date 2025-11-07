@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice data summary'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Y_INVOICEDATA as select from I_BillingDocumentItem as a
  left outer join I_BillingDocItemPrcgElmntBasic as b 
   on a.BillingDocument = b.BillingDocument  and a.BillingDocumentItem = b.BillingDocumentItem and b.ConditionAmount is not initial  
 {
key a.BillingDocument ,
key a.BillingDocumentItem ,
b.TransactionCurrency ,
@Semantics.amount.currencyCode: 'TransactionCurrency'
sum( b.ConditionAmount ) as grossamtexim ,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'JOIG' then  sum( b.ConditionAmount ) end as GST ,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'JOIG' then  b.ConditionBaseAmount  end as ASSEEBLEAMT ,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZFFA' then   sum( b.ConditionAmount ) end as FREIGHT1,  
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZFMK' then  sum( b.ConditionAmount ) end as FREIGHT2 ,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZFOC' then  sum( b.ConditionAmount ) end as OCEANFREIGHT ,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZEIN' then  sum( b.ConditionAmount ) end as INSURANCE1,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZFCO' then  sum( b.ConditionAmount ) end as ADDAMT,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZAG4' then  sum( b.ConditionAmount ) end as COMMISION1,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZAG5' then  sum( b.ConditionAmount ) end as COMMISION2,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZFCO' then  sum( b.ConditionAmount ) end as INSURANCEPREMIUM,
//@Semantics.amount.currencyCode: 'TransactionCurrency'
//case when b.ConditionType = 'ZFCO' then  sum( b.ConditionAmount ) end as COMMISION1,
@Semantics.amount.currencyCode: 'TransactionCurrency'
case when b.ConditionType = 'ZDIS' then  sum( b.ConditionAmount ) end as DISCOUNT 

} where a.SalesDocumentItemCategory = 'TAN'

group by 
a.BillingDocument ,
a.BillingDocumentItem ,
b.ConditionType ,
b.TransactionCurrency ,
b.ConditionBaseAmount
