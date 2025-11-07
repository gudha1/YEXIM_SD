@AbapCatalog.sqlViewName: 'YIMPORTEXIMMAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Exim Import Group'
@Metadata.ignorePropagatedAnnotations: true
define view ZEXIM_MAT_IMPORT_GROUP_2 as select from ZEXIM_MAT_GROUP_CDS
{
    key Matgrpcode,
    key Type,
    key Matgrpdesc

} 
group by 
     Matgrpcode,
     Type,
     Matgrpdesc
