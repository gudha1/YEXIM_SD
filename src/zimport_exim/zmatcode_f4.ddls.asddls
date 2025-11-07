@AbapCatalog.sqlViewName: 'ZMATCODE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Code Desc'
@Metadata.ignorePropagatedAnnotations: true
define view zmatcode_f4 as select from I_Product as a
left outer join I_ProductDescription as b on ( b.Product = a.Product )
{ 
    key a.Product,
        a.BaseUnit,
        b.ProductDescription
    
}

where b.Language = $session.system_language
