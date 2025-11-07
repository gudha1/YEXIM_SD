@AbapCatalog.sqlViewName: 'YLICCONSREP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For License Consumption Report'
@Metadata.ignorePropagatedAnnotations: true
define view ZLICENSE_CONSUMPTION_CDS as select from zexim_save_tab
{   
    @UI.lineItem             : [{ position: 21 }]
    @EndUserText.label       : 'Purchase Order'
    @UI.selectionField       : [{position: 7}]
    key purchaseorder as Purchaseorder,
    @UI.lineItem             : [{ position: 22 }]
    @EndUserText.label       : 'Purchaseorder item'
    key purchaseorderitem as Purchaseorderitem,
    @UI.lineItem             : [{ position: 1 }]
    @EndUserText.label       : 'Internal BOE No.'
    @UI.selectionField       : [{position: 1}]
//      @Consumption.valueHelpDefinition: [{ entity : { name:    'ZI_SalesOrganization_F4', element   : 'SalesOrganization'  }}]
    key intbillofentrynumber as Intbillofentrynumber,
    @UI.lineItem             : [{ position: 2 }]
    @EndUserText.label       : 'Created On'
    @UI.selectionField       : [{position: 2}]
    intdate as Intdate,
    @UI.lineItem             : [{ position: 3 }]
    @EndUserText.label       : 'License Type'
    @UI.selectionField       : [{position: 3}]
    licencetype as Licencetype,
    @UI.lineItem             : [{ position: 4 }]
    @EndUserText.label       : 'License No.'
    @UI.selectionField       : [{position: 4}]
    licenseno as Licenseno,
    @UI.lineItem             : [{ position: 5 }]
    @EndUserText.label       : 'Ext. BOE No.'
    @UI.selectionField       : [{position: 5}]
    idextboeno as Idextboeno,   
    @UI.lineItem             : [{ position: 6 }]
    @EndUserText.label       : 'BOE Date'
    @UI.selectionField       : [{position: 6}]
    idextboedate as Idextboedate,
    @UI.lineItem             : [{ position: 23 }]
    @EndUserText.label       : 'PO Date'
    purchaseorderdate as Purchaseorderdate,
    @UI.lineItem             : [{ position: 24 }]
    @EndUserText.label       : 'Material'
    material as Material,
    @UI.lineItem             : [{ position: 25 }]
    @EndUserText.label       : 'Description'
    productdescription as Productdescription,
    @UI.lineItem             : [{ position: 26 }]
    @EndUserText.label       : 'Old Material Code'
    oldmaterialcode as Oldmaterialcode,
    @UI.lineItem             : [{ position: 27 }]
    @EndUserText.label       : 'HSN/SAC'
    hsncode as Hsncode,
    @UI.lineItem             : [{ position: 28 }]
    @EndUserText.label       : 'Plant'
    plant as Plant,
    @UI.lineItem             : [{ position: 56 }]
    @EndUserText.label       : 'Baseunit'
    baseunit as Baseunit,
    @UI.lineItem             : [{ position: 31 }]
    @EndUserText.label       : 'Net Price'
    netpriceinr as Netpriceinr,
    @UI.lineItem             : [{ position: 32 }]
    @EndUserText.label       : 'Net Amount'
    amountinr as Amountinr,
    @UI.lineItem             : [{ position: 36 }]
    @EndUserText.label       : 'Exchange Rate'
    exchangerate as Exchangerate,
    @UI.lineItem             : [{ position: 34 }]
    @EndUserText.label       : 'Shipper Invoice No.'
    shipperinvoiceno as Shipperinvoiceno,
    @UI.lineItem             : [{ position: 35 }]
    @EndUserText.label       : 'Shipper Invoice Date'
    shipperinvoicedate as Shipperinvoicedate,
    @UI.lineItem             : [{ position: 40 }]
    @EndUserText.label       : 'Duty Amount'
    customdutyamount as Customdutyamount,
    @UI.lineItem             : [{ position: 39 }]
    @EndUserText.label       : 'Custom Duty%'
    duty as Duty,
    @UI.lineItem             : [{ position: 41 }]
    @EndUserText.label       : 'SWS Cess%'
    swcess as Swcess,
    @UI.lineItem             : [{ position: 42 }]
    @EndUserText.label       : 'SWS Amount'
    @DefaultAggregation : #SUM
    swcessamt as Swcessamt,
    @UI.lineItem             : [{ position: 43 }]
    @EndUserText.label       : 'IGST%'
    igst as Igst,
    @UI.lineItem             : [{ position: 45 }]
    @EndUserText.label       : 'Freight'
    freight as Freight,
    @UI.lineItem             : [{ position: 46 }]
    @EndUserText.label       : 'Insurance'
    insurance as Insurance,
    @UI.lineItem             : [{ position: 47 }]
    @EndUserText.label       : 'Misc. Charges'
    miscchanges as Miscchanges,
    @UI.lineItem             : [{ position: 18 }]
    @EndUserText.label       : 'Incoterm'
    idincoterms as Idincoterms,
    @UI.lineItem             : [{ position: 9 }]
    @EndUserText.label       : 'Shipment Mode'
    shipmentmode as Shipmentmode,
    @UI.lineItem             : [{ position: 10 }]
    @EndUserText.label       : 'Loading Port'
    loadingport as Loadingport,
    @UI.lineItem             : [{ position: 11 }]
    @EndUserText.label       : 'UnLoading Port'
    unloadingport as Unloadingport,
    @UI.lineItem             : [{ position: 12 }]
    @EndUserText.label       : 'Goods Clearing Data'
    goodsclearingdata as Goodsclearingdata,
    @UI.lineItem             : [{ position: 13 }]
    @EndUserText.label       : 'Annexure Detail'
    annexuredetails as Annexuredetails,
    @UI.lineItem             : [{ position: 14 }]
    @EndUserText.label       : 'Additional Remark'
    additionalremark as Additionalremark,
    @UI.lineItem             : [{ position: 20 }]
    @EndUserText.label       : 'Country'
    countryoforigin as Countryoforigin,
    @UI.lineItem             : [{ position: 37 }]
    @EndUserText.label       : 'Custom Duty Vendor'
    supplier as Supplier,
    @UI.lineItem             : [{ position: 38 }]
    @EndUserText.label       : 'Custom Duty Vendor Name'
    suppliername as Suppliername,
    @UI.lineItem             : [{ position: 29 }]
    @EndUserText.label       : 'Order Qty'
    orderqty as Orderqty,
    @UI.lineItem             : [{ position: 33 }]
    @EndUserText.label       : 'Currency'
    currency as Currency,
    @UI.lineItem             : [{ position: 44 }]
    @EndUserText.label       : 'IGST Amount'
    igstvalue as Igstvalue,
    @UI.lineItem             : [{ position: 48 }]
    @EndUserText.label       : 'Total Duty'
    totalduty as Totalduty,
    @UI.lineItem             : [{ position: 7 }]
    @EndUserText.label       : 'BL/AWB No.'
    blewbno as Blewbno,
    @UI.lineItem             : [{ position: 15 }]
    @EndUserText.label       : 'Supplier'
    headsupplier as Headsupplier,
    @UI.lineItem             : [{ position: 17 }]
    @EndUserText.label       : 'Payment Term'
    paymentterms as Paymentterms,
    @UI.lineItem             : [{ position: 19 }]
    @EndUserText.label       : 'Inco Location'
    incotermsloc as Incotermsloc,
    @UI.lineItem             : [{ position: 34 }]
    @EndUserText.label       : 'Arrived Qty'
    arrivedquantity as Arrivedquantity
}
