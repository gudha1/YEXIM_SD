@AbapCatalog.sqlViewName: 'YYPARF4'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS FOR GATING PATNERFUNTION'
@Metadata.ignorePropagatedAnnotations: true
define view ZSD_PATNERFUNTION_CDS as select from  I_BillingDocument as A
left outer join  I_BillingDocumentPartner as B on ( B.BillingDocument = A.BillingDocument and B.PartnerFunction = 'ZC' )  
left outer join  I_Supplier as D on ( D.Supplier = B.Supplier  )  
left outer join  I_BillingDocumentPartner as C on ( C.BillingDocument = A.BillingDocument and C.PartnerFunction = 'ZF' )  
left outer join  I_Supplier as E on ( E.Supplier = C.Supplier  )  
{
     key A.BillingDocument ,
     key D.SupplierName as CLAGENT,
     key E.SupplierName as FORWARTAGENT
} 
