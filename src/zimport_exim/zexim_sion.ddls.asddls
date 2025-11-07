@AbapCatalog.sqlViewName: 'ZEXIM_SI'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'exim cds'
@Metadata.ignorePropagatedAnnotations: true
define view zexim_sioncds as select from zexim_sion
{
    key sionno as Sionno,
    key siontype as Siontype,
    key imp_mat_grp as ImpMatGrp,
    exp_mat_grp as ExpMatGrp,
    exp_mat_grpadd1 as ExpMatGrpadd1,
    exp_mat_grpadd2 as ExpMatGrpadd2,
    exp_mat_grpadd3 as ExpMatGrpadd3,
    creation_date as CreationDate,
    description as Description,
    desc1 as Desc1,
    desc2 as Desc2,
    desc3 as Desc3,
    base_uom as BaseUom,
    dgft_sionno as DgftSionno,
    qty as Qty,
    qty1 as Qty1,
    qty2 as Qty2,
    qty3 as Qty3,
    totqty as Totqty,
    matgrp_desc as MatgrpDesc,
    matgrp_qty as MatgrpQty,
    matgrp_uom as MatgrpUom
}
