@AbapCatalog.sqlViewName: 'YMATGRP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material Group F4'
@Metadata.ignorePropagatedAnnotations: true
define view YMATGRP_F4 as select from ZEXIM_MAT_GROUP_CDS
{
    key Matgrpcode,
    key Type,
   key Matgrpdesc
   
}

group by 
Matgrpcode,
Type,
Matgrpdesc


