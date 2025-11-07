@AbapCatalog.sqlViewName: 'ZSD_UO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Uom cds view'
@Metadata.ignorePropagatedAnnotations: true
define view zsd_uom as select from  I_UnitOfMeasureText as A

{
   key A.UnitOfMeasure,
       A.UnitOfMeasureLongName
  
       
}

where Language = $session.system_language
