@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'FREGHT CHARGES'
define root view entity ZFREGHTCHARGES_PR1 as select from zfreghtcharges
{
  key docno              as Docno, 
  key deliveryno         as Deliveryno,
      invoicedate        as Invoicedate,
      portofdischarge    as Portofdischarge,
      forwarder          as Forwarder,
      transportername    as Transportername,
      shippingline       as Shippingline,
      emptycontainer     as Emptycontainer,
      frecontainerno     as Frecontainerno,
      portofloading      as Portofloading,
      oceanfreight       as Oceanfreight,
      oceanfreightbillno as Oceanfreightbillno,
      othshiplinebillno  as Othshiplinebillno,
      traspoerterbillno  as Traspoerterbillno,
      agencybillno       as Agencybillno,
      bltellexbillno     as Bltellexbillno,
      conecorebillno     as Conecorebillno,
      bltellexbillamt    as Bltellexbillamt,
      conecoreamt        as Conecoreamt,
      thc                as Thc,
      doccharge          as Doccharge,
      inlandfreight      as Inlandfreight,
      agencycharge       as Agencycharge,
      totalcharge        as Totalcharge
}
