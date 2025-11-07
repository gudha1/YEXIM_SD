@AbapCatalog.sqlViewName: 'YPOITEMDATA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Import Exim'
@Metadata.ignorePropagatedAnnotations: true
define view ZPO_ITEM_DATA as select from I_PurchaseOrderItemAPI01 as a 
left outer join I_PurchaseOrderAPI01 as b on (b.PurchaseOrder = a.PurchaseOrder)
left outer join I_ProductDescription_2 as c on ( c.Product = a.Material and c.Language = 'E')
left outer join I_Product as d on(a.Material = d.Product)
left outer join I_Supplier as e on(e.Supplier = b.Supplier )
left outer join I_PurOrdItmPricingElementAPI01 as f on(f.PurchaseOrder = a.PurchaseOrder and f.PurchaseOrderItem = a.PurchaseOrderItem and f.ConditionType = 'JCDB' 
                  and f.ConditionRateValue <> 0 )
left outer join I_PurOrdItmPricingElementAPI01 as g on(g.PurchaseOrder = a.PurchaseOrder and g.PurchaseOrderItem = a.PurchaseOrderItem and g.ConditionType = 'ZSWS' 
 and g.ConditionRateValue <> 0 )
left outer join I_PurOrdItmPricingElementAPI01 as h on(h.PurchaseOrder = a.PurchaseOrder and h.PurchaseOrderItem = a.PurchaseOrderItem and h.ConditionType = 'ZCVD' )
left outer join I_PurOrdItmPricingElementAPI01 as i on(i.PurchaseOrder = a.PurchaseOrder and i.PurchaseOrderItem = a.PurchaseOrderItem and i.ConditionType = 'ZCES' )
left outer join I_PurOrdItmPricingElementAPI01 as j on(j.PurchaseOrder = a.PurchaseOrder and j.PurchaseOrderItem = a.PurchaseOrderItem and j.ConditionType = 'ZANT' )
left outer join I_Supplier as k on(k.Supplier = f.FreightSupplier )
{
    key a.PurchaseOrder,
    key a.PurchaseOrderItem,
    key a.Material,
        b.PurchaseOrderDate,
        c.ProductDescription,
        a.BR_NCM as HsnCode,
        a.Plant,
        a.OrderQuantity,
        a.BaseUnit,
        b.Supplier,
        e.SupplierName,
        b.PurchaseOrderType,
       case when a.DocumentCurrency = 'JPY' then 
       a.NetPriceAmount * 100 else a.NetPriceAmount end as NetPriceINR,
       case when a.DocumentCurrency = 'JPY' then 
       a.NetAmount * 100 else a.NetAmount end as AmountINR,
         a.DocumentCurrency,
     //   cast( a.NetPriceAmount as abap.dec( 13, 3 ) ) * cast( b.ExchangeRate  as abap.dec( 13, 3 ) ) as NetPriceINR,
     //   cast( a.NetAmount as abap.dec( 13, 3 ) ) * cast( b.ExchangeRate  as abap.dec( 13, 3 ) ) as  AmountINR,
        b.ExchangeRate,
        d.ProductOldID as OldMaterialCode,
        cast( f.ConditionRateValue as abap.dec( 13, 9 ) ) as JCDBCONDITIONRATEVALUE,
        f.ConditionAmount as JCDBCONDITIONAMOUNT,
        f.FreightSupplier  as JCDBFREIGHTSUPPLIER,
        k.SupplierName  as JCDBFREIGHTSUPPLIERName,
        
        cast( g.ConditionRateValue as abap.dec( 13, 9 ) )  as ZSWSCONDITIONRATEVALUE,
        g.ConditionAmount as ZSWSCONDITIONAMOUNT,
        g.FreightSupplier  as ZSWSFREIGHTSUPPLIER,
        
        cast( h.ConditionRateValue as abap.dec( 13, 9 ) )  as ZCVDCONDITIONRATEVALUE,
        h.ConditionAmount as ZCVDCONDITIONAMOUNT,
        h.FreightSupplier  as ZCVDFREIGHTSUPPLIER,
        
        cast( i.ConditionRateValue as abap.dec( 13, 9 ) )  as ZCESCONDITIONRATEVALUE,
        i.ConditionAmount as ZCESCONDITIONAMOUNT,
        i.FreightSupplier  as ZCESFREIGHTSUPPLIER,
        
        cast( j.ConditionRateValue  as abap.dec( 13, 9 ) )  as ZANTCONDITIONRATEVALUE,
        j.ConditionAmount as ZANTCONDITIONAMOUNT,
        j.FreightSupplier  as ZANTFREIGHTSUPPLIER
        
}
