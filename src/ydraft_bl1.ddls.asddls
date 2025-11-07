@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Daft BL Updated DocNO.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ydraft_bl1 as select from ydraft_bl
{   key lpad( docno, 10, '0' ) as Docno,
    key doctype  as Doctype,
    key lpad( litem, 6, '0' ) as Litem,

    material   as Material,
    mdesp      as Mdesp,
    fullmaterialdescription as FullMaterialDescription,
    lot        as Lot,
    fromto     as Fromto,
    taxid      as Taxid,
    details    as Details,
    deliveryno as Deliveryno,
    containerno as Containerno,
    itemnetwt  as Itemnetweight,
    itemgrosswt as Itemgrossweight
    } 
