@AbapCatalog.sqlViewName: 'YBILLOFENTRY'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Import Exim Bill of Entry'
@Metadata.ignorePropagatedAnnotations: true
define view ZBILL_OF_ENTRY_F4 as select from zexim_save_tab
{
    key intbillofentrynumber,
    key idextboeno
}
group by 
intbillofentrynumber,
idextboeno
