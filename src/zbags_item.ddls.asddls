@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 Help for Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZBAGS_ITEM as select distinct from I_BillingDocument as a 
                   left outer join I_BillingDocumentItem as B on ( B.BillingDocument = a.BillingDocument )
                   left outer join zsd_bag_master as c on ( c.delivery_no = B.ReferenceSDDocument and c.special_stock = 'E' )
                   left outer join zpackinglist_exi as D on ( D.bagnumber = c.bag_no )
{
   key a.BillingDocument,
   key B.ReferenceSDDocument,
       c.bag_no,
       c.product,
       c.batch,
       B.BillingQuantityUnit,
       @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
       c.quantity,
       c.sku,
       D.move_type
       
   
}
//where D.move_type = ''
