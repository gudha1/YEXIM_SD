@EndUserText.label: 'Draft Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity YDRAFT_BL_PROJ
  provider contract transactional_query
  as projection on ydraft_bl_cds
{
  key Docno,
  key Doctype,
  key Litem,
  BillingQuantityUnit,
  BillingQuantity,
      ItemWeightUnit,
      ItemGrossWeight, 
      ItemNetWeight,
      Material,
      BillingDocumentItemText,
      ConsumptionTaxCtrlCode,
      Customerhsncode
     }
