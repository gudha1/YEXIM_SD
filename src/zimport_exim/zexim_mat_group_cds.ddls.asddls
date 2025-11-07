@AbapCatalog.sqlViewName: 'ZEXIM_MAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Group Code Cds'
@Metadata.ignorePropagatedAnnotations: true
define view ZEXIM_MAT_GROUP_CDS as select from zexim_mat_group
{
   key matgrpcode as Matgrpcode,
   key type as Type,
   key matcode as Matcode,
   description1 as Matgrpdesc,
   description as matcodedesc,
   uom as Uom
}
