@AbapCatalog.sqlViewName: 'YLICMASTERREP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds For License Consumption Report'
@Metadata.ignorePropagatedAnnotations: true
define view ZLICENSE_MASTER_CDS as select from zim_maintain_lic
{   
@UI.lineItem             : [{ position: 1 }]
    @EndUserText.label       : 'License Ref No.'
    @UI.selectionField       : [{position: 2}]
    key licenserefno as licenserefno,
    @UI.lineItem             : [{ position: 2 }]
    @EndUserText.label       : 'Created On'
    @UI.selectionField       : [{position: 3}]
    key cusregdate as cusregdate,
    @UI.lineItem             : [{ position: 3 }]
    @EndUserText.label       : 'License Type'
    @UI.selectionField       : [{position: 1}]
    key licensetype as licensetype,
    @UI.lineItem             : [{ position: 4 }]
    @EndUserText.label       : 'License Status'
    @UI.selectionField       : [{position: 7}]
    key licsta as licsta,
    @UI.lineItem             : [{ position: 5 }]
    @EndUserText.label       : 'Ext. License No.'
    @UI.selectionField       : [{position: 4}]
    key extlicno as extlicno,
    @UI.lineItem             : [{ position: 6 }]
    @EndUserText.label       : 'License Date'
    @UI.selectionField       : [{position: 5}]
    key licensedate as licensedate,
    @UI.lineItem             : [{ position: 7 }]
    @EndUserText.label       : 'SION No.'
    @UI.selectionField       : [{position: 6}]
    key sionno as sionno,
    @UI.lineItem             : [{ position: 8 }]
    @EndUserText.label       : 'Changed By'
    changeby as changeby,
    @UI.lineItem             : [{ position: 9 }]
    @EndUserText.label       : 'Company code'
    compantcode as compantcode,
    @UI.lineItem             : [{ position: 10 }]
    @EndUserText.label       : 'Plant'
    plant as Plant,
    @UI.lineItem             : [{ position: 11 }]
    @EndUserText.label       : 'Remark'
    remark as remark,
//    @UI.lineItem             : [{ position: 12 }]
//    @EndUserText.label       : 'Port of Registration'
//    r as Plant,
    @UI.lineItem             : [{ position: 13 }]
    @EndUserText.label       : 'File No.'
    fileno as fileno,
    @UI.lineItem             : [{ position: 14 }]
    @EndUserText.label       : 'Issuing Officer'
    issuingofficer as issuingofficer,
    @UI.lineItem             : [{ position: 15 }]
    @EndUserText.label       : 'Import Valid From'
    importvalidfrom as importvalidfrom,
    @UI.lineItem             : [{ position: 16 }]
    @EndUserText.label       : 'Import Valid To'
    importvalidto as importvalidto,
    @UI.lineItem             : [{ position: 17 }]
    @EndUserText.label       : 'Export Valid From'
    exportvalidfrom as exportvalidfrom,
    @UI.lineItem             : [{ position: 18 }]
    @EndUserText.label       : 'Export Valid To'
    exportvalidto as exportvalidto,
    @UI.lineItem             : [{ position: 19 }]
    @EndUserText.label       : 'Import License Value(INR)'
    licensevalueinr as licensevalueinr,
    @UI.lineItem             : [{ position: 20 }]
    @EndUserText.label       : 'Total Import Qty'
    totimpqty as totimpqty,
    @UI.lineItem             : [{ position: 21 }]
    @EndUserText.label       : 'License Value(USD)'
    licensevalueusd as licensevalueusd,
    @UI.lineItem             : [{ position: 22 }]
    @EndUserText.label       : 'Exch Rate(USD)'
    exchrateusd as exchrateusd,
    @UI.lineItem             : [{ position: 23 }]
    @EndUserText.label       : 'License Value(FC)'
    licensevaluefc as licensevaluefc,
    @UI.lineItem             : [{ position: 24 }]
    @EndUserText.label       : 'Exch Rate(FC)'
    exchratefc as exchratefc,
    @UI.lineItem             : [{ position: 25 }]
    @EndUserText.label       : 'Import Dty Tolerance'
    importdtytoal as importdtytoal,
    @UI.lineItem             : [{ position: 26 }]
    @EndUserText.label       : 'Actual Duty Save(INR)'
    actualdutyinr as actualdutyinr,
    @UI.lineItem             : [{ position: 27 }]
    @EndUserText.label       : 'Planned Duty Save(INR)'
    pladutysave as pladutysave,
    @UI.lineItem             : [{ position: 28 }]
    @EndUserText.label       : 'Remaining Duty Save(INR)'
    remdutyinr as remdutyinr,
    @UI.lineItem             : [{ position: 29 }]
    @EndUserText.label       : 'Export Obligation(INR)'
    expoblinr as expoblinr,
    @UI.lineItem             : [{ position: 30 }]
    @EndUserText.label       : 'Total Export Qty'
    totecportpqty as totecportpqty,
    @UI.lineItem             : [{ position: 31 }]
    @EndUserText.label       : 'Export Obligation(USD)'
    expoblusd as expoblusd,
    @UI.lineItem             : [{ position: 32 }]
    @EndUserText.label       : 'Exch Rate(USD)'
    exrateusd as exrateusd,
    @UI.lineItem             : [{ position: 33 }]
    @EndUserText.label       : 'Export Obligation(FC)'
    expoblfc as expoblfc,
    @UI.lineItem             : [{ position: 34 }]
    @EndUserText.label       : 'Exch Rate(FC)'
    exratefc as exratefc,
    @UI.lineItem             : [{ position: 35 }]
    @EndUserText.label       : 'Max. Obli Qty'
    exportmaxobqty as exportmaxobqty,
    @UI.lineItem             : [{ position: 36 }]
    @EndUserText.label       : 'Max. Obli Amount'
    exportmaxobamt as exportmaxobamt,
    @UI.lineItem             : [{ position: 37 }]
    @EndUserText.label       : 'Obligation Permitted'
    obligationpermitted as obligationpermitted,
    @UI.lineItem             : [{ position: 38 }]
    @EndUserText.label       : 'Yield Report Waiting'
    yieldreportwaiting as yieldreportwaiting,
    @UI.lineItem             : [{ position: 39 }]
    @EndUserText.label       : 'Applied for EODC'
    appliedeodc as appliedeodc,
    @UI.lineItem             : [{ position: 40 }]
    @EndUserText.label       : 'EODC Received'
    eodcreceived as eodcreceived,
    @UI.lineItem             : [{ position: 41 }]
    @EndUserText.label       : 'Bond Cancel'
    bondcancel as bondcancel,
    @UI.lineItem             : [{ position: 42 }]
    @EndUserText.label       : 'Yield %(From Spice Board)'
    yieldfromspiceboard as yieldfromspiceboard
    
    
       
}
