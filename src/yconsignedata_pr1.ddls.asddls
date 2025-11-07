@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consignee Data  For  Preshipment Data'
define root view entity YCONSIGNEDATA_PR1
  as select from yconsignedata_pr as A 
  left outer join I_BillingDocumentPartner    as         B on A.docno = B.BillingDocument and B.PartnerFunction = 'WE'
  left outer join I_Customer                  as         C on C.Customer = B.Customer
  left outer join I_Address_2                 as         D on D.AddressID = C.AddressID
{
 key A.docno           as Docno,
 key A.doctype         as Doctype,
     A.billtobuyrname  as Billtobuyrname,
     A.billtostreet1   as Billtostreet1,
     A.billtostreet2   as Billtostreet2,
     A.billtostreet3   as Billtostreet3,
     A.billtocity      as Billtocity,
     A.billtocountry   as Billtocountry,
     A.constoname      as Constoname,
     A.constostreet1   as Constostreet1,
     A.constostreet2   as Constostreet2,
     A.constostreet3   as Constostreet3,
     A.constocity      as Constocity,
     A.constocountry   as Constocountry,
     A.notifyname      as Notifyname,
     A.notifystreet1   as Notifystreet1,
     A.notifystreet2   as Notifystreet2,
     A.notifystreet3   as Notifystreet3,
     A.notifycity      as Notifycity,
     A.notifycountry   as Notifycountry,
     A.conslctoname    as Conslctoname,
     A.conslctostreet1 as Conslctostreet1,
     A.conslctostreet2 as Conslctostreet2,
     A.conslctostreet3 as Conslctostreet3,
     A.conslctocity    as Conslctocity,
     A.conslctocountry as Conslctocountry,
     A.notify2name     as Notify2name,
     A.notify2street1  as Notify2street1,
     A.notify2street2  as Notify2street2,
     A.notify2street3  as Notify2street3,
     A.notify2city     as Notify2city,
     A.notify2country  as Notify2country,
     A.notify3name     as Notify3name,
     A.notify3street1  as Notify3street1,
     A.notify3street2  as Notify3street2,
     A.notify3street3  as Notify3street3,
     A.notify3city     as Notify3city,
     A.notify3country  as Notify3country,
     A.tobecontinue    as Tobecontinue,
     A.taxid           as Taxid,
     A.secondbuyer     as Secondbuyer,
     A.secondbuyername as Secondbuyername,
     A.secondstreet1   as Secondstreet1,
     A.secondstreet2   as Secondstreet2,
     A.secondstreet3   as Secondstreet3,
     A.secondcity      as Secondcity,
     A.secondcountry   as Secondcountry,
     A.consigneebuyer  as Consigneebuyer,
     D.StreetPrefixName2
     //    _association_name // Make association public
}
