@AbapCatalog.sqlViewName: 'YINCOMTRES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For Import Exim'
@Metadata.ignorePropagatedAnnotations: true
define view ZINCOTERMS_F4 as select from I_IncotermsClassificationText as A
{
    key  A.IncotermsClassification,
         A.IncotermsClassificationName
}
where A.Language = 'E'
