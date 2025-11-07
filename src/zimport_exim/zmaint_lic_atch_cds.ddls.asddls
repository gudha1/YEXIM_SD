@AbapCatalog.sqlViewName: 'YATCHME'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Maintain Lic Import Exim Attachment'
@Metadata.ignorePropagatedAnnotations: true
define view zmaint_lic_atch_CDS as select from zmaint_lic_atch
{
    key contentname as Contentname,
    key licenserefno as Licenserefno,
    key srno as Srno,
    attachment as Attachment,
    mimetype as Mimetype,
    filename as Filename,
    xml as Xml,
    zschema as Zschema,
    note as Note
}
