@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Draft CDS view'
define root view entity ydraft_bl_cds
  as select from  I_BillingDocumentItem  as item 
   left outer join I_BillingDocument      as bill on  item.BillingDocument = bill.BillingDocument
   left outer join I_ProductPlantBasic      as prod on  item.Product = prod.Product
   left outer join ydraft_bl      as draft on  draft.docno = item.BillingDocument
   
//  left outer join I_Product              as bo   on  a.Material = bo.Product
  
//      on   a.Docno = b.BillingDocument //and a.Litem = b.BillingDocumentItem )
{
//  key a.Docno    as Docno,
//  key a.Doctype  as Doctype,
//  key a.Litem    as Litem,
//
//    a.Material   as Material,
//    a.Mdesp      as Mdesp,
//    a.FullMaterialDescription as FullMaterialDescription,
//    a.Lot        as Lot,
//    a.Fromto     as Fromto,
//    a.Taxid      as Taxid,
//    a.Details    as Details,
//    a.Deliveryno as Deliveryno,
//    a.Containerno as Containerno,
//    a.itemnetwt  as Itemnetweight,
//    a.itemgrosswt as Itemgrossweight,
    key item.BillingDocument as Docno,
    key item.BillingDocumentType as Doctype,
    key item.BillingDocumentItem as Litem,
    item.BillingQuantityUnit,

    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    item.BillingQuantity as BillingQuantity,

    item.ItemWeightUnit as ItemWeightUnit,

    @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
    item.ItemGrossWeight as ItemGrossWeight,

    @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
    item.ItemNetWeight as ItemNetWeight,
    item.Material as Material,
    item.BillingDocumentItemText as BillingDocumentItemText,
    prod.ConsumptionTaxCtrlCode as ConsumptionTaxCtrlCode,
    draft.customerhsncode as Customerhsncode
    
} where item.BillingQuantity is not initial

group by item.BillingDocument,
item.BillingDocumentType,
item.BillingDocumentItem, 
item.BillingQuantityUnit,
    item.BillingQuantity,
    item.ItemWeightUnit,
    item.ItemGrossWeight,
    item.ItemNetWeight,
    item.Material,
    item.BillingDocumentItemText,
    prod.ConsumptionTaxCtrlCode,
    draft.customerhsncode  
                                        
