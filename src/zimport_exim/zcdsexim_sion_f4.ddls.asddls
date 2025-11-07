@AbapCatalog.sqlViewName: 'YEIMSIONF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Exim SION f4'
@Metadata.ignorePropagatedAnnotations: true
define view zcdsexim_sion_f4 as select from zexim_sion
{
    key sionno as Sionno,
    key siontype as Siontype
   
} 
group by sionno,
siontype
