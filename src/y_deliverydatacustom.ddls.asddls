@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Delivery Data Custom'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Y_deliverydatacustom as select from I_DeliveryDocumentItem 
as a inner join  I_DeliveryDocumentItem as b on  a.DeliveryDocument = b.DeliveryDocument and a.DeliveryDocumentItem = b.HigherLvlItmOfBatSpltItm and 
b.Batch is not initial and  a.Batch is initial
//left outer join  YPACKNCDS as c on b.Batch = c.Batch
 {
key a.DeliveryDocument ,
a.DeliveryQuantityUnit ,

b.DeliveryQuantityUnit as unit1,
@Semantics.quantity.unitOfMeasure:'DeliveryQuantityUnit'
sum( b.ActualDeliveryQuantity ) as totalnetquantity ,
count( distinct(b.Batch) ) as zpackage 
//sum(c.Grosswt ) as totalgrossquantity
    
}
group by 
a.DeliveryDocument ,
a.DeliveryQuantityUnit,
b.DeliveryQuantityUnit

