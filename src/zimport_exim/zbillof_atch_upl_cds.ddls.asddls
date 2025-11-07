@AbapCatalog.sqlViewName: 'YBILLOFENTRY22'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Bill Of Entry Atch Upload'
@Metadata.ignorePropagatedAnnotations: true
define view ZBILLOF_ATCH_UPL_CDS as select from zbillof_atch_upl
{
    key contentname as Contentname,
    key billofentrynumber as Billofentrynumber,
  //  key srno as Srno,
    attachment as Attachment,
    mimetype as Mimetype,
    filename as Filename, 
    xml as Xml,
    zschema as Zschema,
    note as Note
}
