@AbapCatalog.sqlViewName: 'YSUPPF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Import Exim'
@Metadata.ignorePropagatedAnnotations: true
define view ZSUPPLIRF4 as select from I_Supplier
{
    key Supplier,
        SupplierName
}
