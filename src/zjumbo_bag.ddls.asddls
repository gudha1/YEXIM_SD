@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'JUMBO_BAG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZJUMBO_BAG as select from zpackinglist_exi
{
    key invoicenumber,
    key jumbo_bagno    ,
    noofbags         ,
    quantity ,
    palletno,
    grossweight
}
 group by 
  invoicenumber,
     jumbo_bagno    ,
    noofbags         ,
    quantity ,
    palletno,
    grossweight
