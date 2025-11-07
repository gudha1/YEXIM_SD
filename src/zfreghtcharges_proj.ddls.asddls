@EndUserText.label: 'FREGHT CHARGES'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZFREGHTCHARGES_proj  provider contract transactional_query
  as projection on  ZFREGHTCHARGES_PR1 
{
    key Docno,
    key Deliveryno,
    Invoicedate,
    Portofdischarge,
    Forwarder,
    Transportername,
    Shippingline,
    Emptycontainer,
    Frecontainerno,
    Portofloading,
    Oceanfreight,
    Oceanfreightbillno,
    Othshiplinebillno,
    Traspoerterbillno,
    Agencybillno     ,
    Bltellexbillno   ,
    Conecorebillno   ,
    Bltellexbillamt  ,
    Conecoreamt      ,
    Thc,
    Doccharge,
    Inlandfreight,
    Agencycharge,
    Totalcharge
}
