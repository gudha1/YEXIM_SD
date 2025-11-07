@AbapCatalog.sqlViewName: 'YPURHCASEF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Import Exim'
@Metadata.ignorePropagatedAnnotations: true
define view ZPURCHASE_ORDER_F4 as select from I_PurchaseOrderAPI01 as A 
left outer join I_Supplier as B on (B.Supplier = A.Supplier)
left outer join I_CountryText as c on (c.Country = B.Country and c.Language = 'E')
left outer join I_PaymentTermsText as d on (d.PaymentTerms = A.PaymentTerms and d.Language = 'E' )
{
    key A.PurchaseOrder,
    A.PurchaseOrderType,
    A.IncotermsClassification,
    A.IncotermsTransferLocation,
    A.PaymentTerms,
    A.Supplier,
    B.SupplierName,
    B.Country,
    c.CountryName,
    d.PaymentTermsDescription
} 
group by 
A.PurchaseOrder,
A.PurchaseOrderType,
A.Supplier,
A.IncotermsClassification,
A.IncotermsTransferLocation,
A.PaymentTerms,
B.SupplierName,
    B.Country,
    c.CountryName,
    d.PaymentTermsDescription
