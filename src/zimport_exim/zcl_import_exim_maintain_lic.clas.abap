class ZCL_IMPORT_EXIM_MAINTAIN_LIC definition
  public
  create public .

public section.

CLASS-DATA : BEGIN OF ZSTR,
  CreateLicenseType                           TYPE STRING ,
  CreateLicenseRefNo                          TYPE STRING,
  CreateCompantCode              TYPE STRING,
  CreateFileNo                  TYPE STRING,
  CreateLicenseDate             TYPE STRING,
  CreateCreatedBy               TYPE STRING,
  CreatePlant                   TYPE STRING,
  CreateissuingOfficer          TYPE STRING,
  CreateExtLicNo              TYPE STRING,
  CreateImportValidFrom     TYPE STRING,
  CreateImportValidTo     TYPE STRING,
  CreateExportValidFrom     TYPE STRING,
  CreateExportValidTo     TYPE STRING,
  CreateLicenseValueINR     TYPE STRING,
  CreateLicenseValueUSD     TYPE STRING,
  CreateLicenseValueFC     TYPE STRING,
  CreateImportDtyTol     TYPE STRING,
  CreatePlaDutySave      TYPE STRING,
  CreateExpOblINR        TYPE STRING,
  CreateExpOblUSD        TYPE STRING,
  CreateExpOblFC         TYPE STRING,
  CreateTotEcpQty        TYPE STRING,
  CreateExRateUSD        TYPE STRING,
  CreateExRateFC         TYPE STRING,
  CreateMaxObQty         TYPE STRING,
  CreateMaxObAmt         TYPE STRING,
  CreateLicSta           TYPE STRING,
  CreateStatusDate       TYPE STRING,
  ChangeBy               TYPE STRING,
  CreateTotEcportpQty    TYPE STRING,
  CreateRemark           TYPE STRING,
  CreExchRateUSD         TYPE STRING,
  CreExchRateFC          TYPE STRING,
  CreMaxObQty            TYPE STRING,
  CreMaxObAmt            TYPE STRING,
SIONNo                 TYPE STRING,
ObligationPermitted      TYPE STRING,
YieldReportWaiting       TYPE STRING,
AppliedEODC              TYPE STRING,
EODCReceived             TYPE STRING,
BondCancel               TYPE STRING,
YieldFromSpiceBoard      TYPE STRING,
CreatePortOfReg                        TYPE STRING,
CreateTotImpQty                        TYPE STRING,
CreateExchRateUSD                      TYPE STRING,
CreateExchRateFC                       TYPE STRING,
CreateActualDutyINR                    TYPE STRING,
CreateRemDutyINR                       TYPE STRING,
afiles              TYPE zafiles_type,
  END OF ZSTR.


  DATA : it_data LIKE ZSTR.


TYPES : BEGIN OF CUSRREGON,
             LicenseRefNo TYPE STRING,
               END OF CUSRREGON.

 CLASS-DATA TABle_CUSRREGON TYPE TABLE OF CUSRREGON.

TYPES : BEGIN OF CUSRREGON11,
             CustomRegistration LIKE TABle_CUSRREGON,
        END OF CUSRREGON11.

class-data IT_CUSRREGON11 type CUSRREGON11 .




TYPES : BEGIN OF REALSE,
             LicenseRefNo TYPE STRING,
               END OF REALSE.

 CLASS-DATA TABle_REALSE TYPE TABLE OF REALSE.

TYPES : BEGIN OF REALSE11,
             Released LIKE TABle_REALSE,
        END OF REALSE11.

class-data IT_REALSE11 type REALSE11 .



TYPES : BEGIN OF UnRelease,
             LicenseRefNo TYPE STRING,
               END OF UnRelease.

 CLASS-DATA TABle_UnRelease TYPE TABLE OF UnRelease.

TYPES : BEGIN OF UnRelease11,
             UnRelease LIKE TABle_UnRelease,
        END OF UnRelease11.

class-data IT_UnRelease11 type UnRelease11 .


TYPES : BEGIN OF handleClosed,
             LicenseRefNo TYPE STRING,
               END OF handleClosed.

 CLASS-DATA TABle_handleClosed TYPE TABLE OF handleClosed.

TYPES : BEGIN OF handleClosed11,
             handleClosed LIKE TABle_handleClosed,
        END OF handleClosed11.

class-data IT_handleClosed11 type handleClosed11 .


TYPES : BEGIN OF ImportCloseExportOpen,
             LicenseRefNo TYPE STRING,
               END OF ImportCloseExportOpen.

 CLASS-DATA TABle_ImportCloseExportOpen TYPE TABLE OF ImportCloseExportOpen.

TYPES : BEGIN OF ImportCloseExportOpen11,
             ImportCloseExportOpen LIKE TABle_ImportCloseExportOpen,
        END OF ImportCloseExportOpen11.

class-data IT_ImportCloseExportOpen1 type ImportCloseExportOpen11 .


TYPES : BEGIN OF Delete,
             LicenseRefNo TYPE STRING,
               END OF Delete.

 CLASS-DATA TABle_Delete TYPE TABLE OF Delete.

TYPES : BEGIN OF Delete11,
             Delete LIKE TABle_Delete,
        END OF Delete11.

class-data IT_Delete1 type Delete11 .


  interfaces IF_HTTP_SERVICE_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IMPORT_EXIM_MAINTAIN_LIC IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

   DATA(body)  = request->get_text(  ).
   DATA(req) = request->get_form_fields(  ).
   xco_cp_json=>data->from_string( body )->write_to( REF #(  it_data ) ).
   DATA(type) = value #( req[ name = 'type' ]-value optional ) .

   DATA responce TYPE string.

SELECT SINGLE * FROM I_User WITH PRIVILEGED ACCESS as a WHERE a~UserID = @SY-uname  INTO @DATA(USERNAME).

if type = 'CustomRegistration'.

 xco_cp_json=>data->from_string( body )->write_to( REF #(  IT_CUSRREGON11 ) ).

 READ TABLE IT_CUSRREGON11-customregistration INTO DATA(HEAD1) INDEX 1.

UPDATE zim_maintain_lic SET cusreg1 = 'X',
  cusregdate    = @SY-datum,
  cusregtime    = @SY-timlo,
  cusregid      = @USERNAME-UserDescription,
  currentstatus1 = 'Custom Registration',
  currentstatusid = @USERNAME-UserDescription,
  currentstatusdate = @SY-datum,
  currentstatustime = @SY-timlo

  WHERE licenserefno = @HEAD1-licenserefno .

responce = |License { HEAD1-licenserefno } set for Custom Registration successfully.|.

elseIF type = 'Released' .


 xco_cp_json=>data->from_string( body )->write_to( REF #(  IT_REALSE11 ) ).
  READ TABLE IT_REALSE11-Released INTO HEAD1 INDEX 1.

 UPDATE zim_maintain_lic SET released = 'X',
  reldate    = @SY-datum,
  reltime    = @SY-timlo,
  relid      = @USERNAME-UserDescription,
  currentstatus1 = 'Released',
  currentstatusid = @USERNAME-UserDescription,
  currentstatusdate = @SY-datum,
  currentstatustime = @SY-timlo
  WHERE licenserefno = @HEAD1-licenserefno .

responce = |License { HEAD1-licenserefno } Released successfully.|.

elseIF type = 'UnRelease' .

 xco_cp_json=>data->from_string( body )->write_to( REF #(  IT_UnRelease11 ) ).

  READ TABLE IT_UnRelease11-unrelease INTO HEAD1 INDEX 1.
 UPDATE zim_maintain_lic SET released = '',
  reldate    = @SY-datum,
  reltime    = @SY-timlo,
  relid      = @USERNAME-UserDescription,
  currentstatus1 = 'UnRelease',
  currentstatusid = @USERNAME-UserDescription,
  currentstatusdate = @SY-datum,
  currentstatustime = @SY-timlo
  WHERE licenserefno = @HEAD1-licenserefno .

responce = |License { HEAD1-licenserefno } UnReleased successfully.|.

elseIF type = 'handleClosed' .

 xco_cp_json=>data->from_string( body )->write_to( REF #(  IT_handleClosed11 ) ).

  READ TABLE IT_handleClosed11-handleClosed INTO HEAD1 INDEX 1.

 UPDATE zim_maintain_lic SET closed1 = 'X',
  closedate    = @SY-datum,
  closetime    = @SY-timlo,
  closeid      = @USERNAME-UserDescription,
  currentstatus1 = 'Closed',
  currentstatusid = @USERNAME-UserDescription,
  currentstatusdate = @SY-datum,
  currentstatustime = @SY-timlo
  WHERE licenserefno = @HEAD1-licenserefno .

responce = |License { HEAD1-licenserefno } Closed successfully.|.

elseIF type = 'ImportCloseExportOpen' .

 xco_cp_json=>data->from_string( body )->write_to( REF #(  IT_ImportCloseExportOpen1 ) ).

  READ TABLE IT_ImportCloseExportOpen1-importcloseexportopen INTO HEAD1 INDEX 1.

 UPDATE zim_maintain_lic SET imcloseexo1 = 'X',
  imcloseexodate    = @SY-datum,
  imcloseexotime    = @SY-timlo,
  imcloseexoid      = @USERNAME-UserDescription,
    currentstatus1 = 'Import Close Export Open',
  currentstatusid = @USERNAME-UserDescription,
  currentstatusdate = @SY-datum,
  currentstatustime = @SY-timlo
  WHERE licenserefno = @HEAD1-licenserefno .

responce = |License { HEAD1-licenserefno } Import Closed successfully.|.


elseIF type = 'Delete' .

 xco_cp_json=>data->from_string( body )->write_to( REF #(  IT_Delete1 ) ).

  READ TABLE IT_Delete1-Delete INTO HEAD1 INDEX 1.

 UPDATE zim_maintain_lic SET deleted1 = 'X',
  deleteddate    = @SY-datum,
  deletedtime    = @SY-timlo,
  deletedid      = @USERNAME-UserDescription,
  currentstatus1 = 'Delete',
  currentstatusid = @USERNAME-UserDescription,
  currentstatusdate = @SY-datum,
  currentstatustime = @SY-timlo
  WHERE licenserefno = @HEAD1-licenserefno .

responce = |License { HEAD1-licenserefno } Deleted successfully.|.


elseIF type = 'Create' .

   DATA wa_head type zim_maintain_lic.

    DATA: nr_number     TYPE cl_numberrange_runtime=>nr_number.
    TRY.
        CALL METHOD cl_numberrange_runtime=>number_get
          EXPORTING
            nr_range_nr = '01'
            object      = 'ZLIC_REF'
            quantity    = 0000000001
          IMPORTING
            number      = nr_number.

      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges.
    ENDTRY.
SHIFT nr_number LEFT DELETING LEADING '0'.
DATA NUMBERRANE TYPE C LENGTH 10 .

NUMBERRANE = nr_number .
CONDENSE NUMBERRANE NO-GAPS.

wa_head-compantcode            =  it_data-createcompantcode  .
wa_head-createdby  =                                      it_data-createcreatedby  .
wa_head-exchratefc  =                                     it_data-createexratefc  .
wa_head-exchrateusd  =                                    it_data-createexrateusd  .
wa_head-expoblfc  =                                       it_data-createexpoblfc  .
wa_head-expoblinr  =                                      it_data-createexpoblinr  .
wa_head-expoblusd  =                                      it_data-createexpoblusd  .
wa_head-exportmaxobamt  =                                 it_data-createmaxobamt  .
wa_head-exportmaxobqty  =                                 it_data-createmaxobqty  .

IF it_data-createexportvalidfrom  IS NOT INITIAL .
wa_head-exportvalidfrom  =                                it_data-createexportvalidfrom+6(4) && it_data-createexportvalidfrom+3(2) && it_data-createexportvalidfrom+0(2)  .
ENDIF.

IF it_data-createexportvalidto  IS NOT INITIAL .
wa_head-exportvalidto  =                                  it_data-createexportvalidto+6(4) && it_data-createexportvalidto+3(2) && it_data-createexportvalidto+0(2)  .
ENDIF.

wa_head-exratefc  =                                       it_data-createexratefc  .
wa_head-exrateusd  =                                      it_data-createexrateusd  .
wa_head-extlicno  =                                       it_data-createextlicno  .
wa_head-fileno  =                                         it_data-createfileno  .
wa_head-importdtytoal  =                                  it_data-CreateImportDtyTol  .
IF it_data-createimportvalidfrom  IS NOT INITIAL.
wa_head-importvalidfrom  =                                it_data-createimportvalidfrom+6(4) && it_data-createimportvalidfrom+3(2) && it_data-createimportvalidfrom+0(2)  .
ENDIF.
IF  it_data-createimportvalidto  IS NOT INITIAL .
wa_head-importvalidto  =                                  it_data-createimportvalidto+6(4) && it_data-createimportvalidto+3(2) && it_data-createimportvalidto+0(2)  .
ENDIF.
wa_head-issuingofficer  =                                 it_data-createissuingofficer  .

IF    it_data-createlicensedate  IS NOT INITIAL .
wa_head-licensedate  =                                    it_data-createlicensedate+6(4) && it_data-createlicensedate+3(2) && it_data-createlicensedate+0(2)   .
ENDIF.
wa_head-licenserefno  =                                   NUMBERRANE  .
wa_head-licensetype  =                                    it_data-createlicensetype  .
wa_head-licensevaluefc  =                                 it_data-createlicensevaluefc  .
wa_head-licensevalueinr  =                                it_data-createlicensevalueinr  .
wa_head-licensevalueusd  =                                it_data-createlicensevalueusd  .
wa_head-licsta  =                                         it_data-createlicsta  .
wa_head-pladutysave  =                                    it_data-createpladutysave  .
wa_head-plant  =                                          it_data-createplant  .
wa_head-remark  =                                         it_data-createremark  .

wa_head-changeby  =                                        it_data-ChangeBy.

IF    it_data-createstatusdate IS NOT INITIAL.
wa_head-statusdate  =                                     it_data-createstatusdate+6(4) && it_data-createstatusdate+3(2) && it_data-createstatusdate+0(2)  .
ENDIF.
wa_head-statusmaxobamt  =                                 it_data-cremaxobamt  .
wa_head-statusmaxobqty  =                                 it_data-cremaxobqty  .
wa_head-totecportpqty  =                                  it_data-createtotecportpqty  .
wa_head-totecpqty  =                                      it_data-createtotecpqty  .

wa_head-SIONNo                                   =     it_data-SIONNo                .
wa_head-ObligationPermitted                      =     it_data-ObligationPermitted   .
wa_head-YieldReportWaiting                       =     it_data-YieldReportWaiting    .
wa_head-AppliedEODC                              =     it_data-AppliedEODC           .
wa_head-EODCReceived                             =     it_data-EODCReceived          .
wa_head-BondCancel                               =     it_data-BondCancel            .
wa_head-YieldFromSpiceBoard                      =     it_data-YieldFromSpiceBoard   .
wa_head-createportofreg                         = it_data-CreatePortOfReg                  .
wa_head-totimpqty                               = it_data-CreateTotImpQty                  .
wa_head-impexchrateusd                          = it_data-CreateExchRateUSD                .
wa_head-impexchratefc                           = it_data-CreateExchRateFC                 .
wa_head-actualdutyinr                           = it_data-CreateActualDutyINR              .
wa_head-remdutyinr                              = it_data-CreateRemDutyINR                 .


MODIFY zim_maintain_lic FROM @wa_head.
responce = |Data saved successfully.{ NUMBERRANE }|.





     DATA WA_zmaint_lic_atch TYPE zmaint_lic_atch .
       LOOP AT it_data-aFiles INTO DATA(wa_ONUPLOAD).


        WA_zmaint_lic_atch-licenserefno   = NUMBERRANE.
        WA_zmaint_lic_atch-attachment  = wa_ONUPLOAD-content.
        WA_zmaint_lic_atch-contentname  = wa_ONUPLOAD-filename.
        WA_zmaint_lic_atch-filename  = wa_ONUPLOAD-filename.
        WA_zmaint_lic_atch-mimetype  = wa_ONUPLOAD-mimetype.
        WA_zmaint_lic_atch-note  = wa_ONUPLOAD-programname.

        MODIFY zmaint_lic_atch FROM @WA_zmaint_lic_atch .
        CLEAR: wa_ONUPLOAD ,WA_zmaint_lic_atch.

      ENDLOOP.

***************************************************************************change****************************************************

ELSEIF TYPE = 'Change'.


wa_head-compantcode            =  it_data-createcompantcode  .
wa_head-createdby  =                                      it_data-createcreatedby  .
wa_head-exchratefc  =                                     it_data-createexratefc  .
wa_head-exchrateusd  =                                    it_data-createexrateusd  .
wa_head-expoblfc  =                                       it_data-createexpoblfc  .
wa_head-expoblinr  =                                      it_data-createexpoblinr  .
wa_head-expoblusd  =                                      it_data-createexpoblusd  .
wa_head-exportmaxobamt  =                                 it_data-createmaxobamt  .
wa_head-exportmaxobqty  =                                 it_data-createmaxobqty  .

IF it_data-createexportvalidfrom  IS NOT INITIAL .
wa_head-exportvalidfrom  =                                it_data-createexportvalidfrom+6(4) && it_data-createexportvalidfrom+3(2) && it_data-createexportvalidfrom+0(2)  .
ENDIF.

IF it_data-createexportvalidto  IS NOT INITIAL .
wa_head-exportvalidto  =                                  it_data-createexportvalidto+6(4) && it_data-createexportvalidto+3(2) && it_data-createexportvalidto+0(2)  .
ENDIF.

wa_head-exratefc  =                                       it_data-creexchratefc  .
wa_head-exrateusd  =                                      it_data-creexchrateusd  .
wa_head-extlicno  =                                       it_data-createextlicno  .
wa_head-fileno  =                                         it_data-createfileno  .
wa_head-importdtytoal  =                                  it_data-CreateImportDtyTol  .
IF it_data-createimportvalidfrom  IS NOT INITIAL.
wa_head-importvalidfrom  =                                it_data-createimportvalidfrom+6(4) && it_data-createimportvalidfrom+3(2) && it_data-createimportvalidfrom+0(2)  .
ENDIF.
IF  it_data-createimportvalidto  IS NOT INITIAL .
wa_head-importvalidto  =                                  it_data-createimportvalidto+6(4) && it_data-createimportvalidto+3(2) && it_data-createimportvalidto+0(2)  .
ENDIF.
wa_head-issuingofficer  =                                 it_data-createissuingofficer  .

IF    it_data-createlicensedate  IS NOT INITIAL .
wa_head-licensedate  =                                    it_data-createlicensedate+6(4) && it_data-createlicensedate+3(2) && it_data-createlicensedate+0(2)   .
ENDIF.
wa_head-licenserefno  =                                   it_data-CreateLicenseRefNo  .
wa_head-licensetype  =                                    it_data-createlicensetype  .
wa_head-licensevaluefc  =                                 it_data-createlicensevaluefc  .
wa_head-licensevalueinr  =                                it_data-createlicensevalueinr  .
wa_head-licensevalueusd  =                                it_data-createlicensevalueusd  .
wa_head-licsta  =                                         it_data-createlicsta  .
wa_head-pladutysave  =                                    it_data-createpladutysave  .
wa_head-plant  =                                          it_data-createplant  .
wa_head-remark  =                                         it_data-createremark  .

wa_head-changeby  =                                        it_data-ChangeBy.

IF    it_data-createstatusdate IS NOT INITIAL.
wa_head-statusdate  =                                     it_data-createstatusdate+6(4) && it_data-createstatusdate+3(2) && it_data-createstatusdate+0(2)  .
ENDIF.
wa_head-statusmaxobamt  =                                 it_data-cremaxobamt  .
wa_head-statusmaxobqty  =                                 it_data-cremaxobqty  .
wa_head-totecportpqty  =                                  it_data-createtotecportpqty  .
wa_head-totecpqty  =                                      it_data-createtotecpqty  .
wa_head-SIONNo                                   =     it_data-SIONNo                .
wa_head-ObligationPermitted                      =     it_data-ObligationPermitted   .
wa_head-YieldReportWaiting                       =     it_data-YieldReportWaiting    .
wa_head-AppliedEODC                              =     it_data-AppliedEODC           .
wa_head-EODCReceived                             =     it_data-EODCReceived          .
wa_head-BondCancel                               =     it_data-BondCancel            .
wa_head-YieldFromSpiceBoard                      =     it_data-YieldFromSpiceBoard   .
wa_head-createportofreg                         = it_data-CreatePortOfReg                  .
wa_head-totimpqty                               = it_data-CreateTotImpQty                  .
wa_head-impexchrateusd                          = it_data-CreateExchRateUSD                .
wa_head-impexchratefc                           = it_data-CreateExchRateFC                 .
wa_head-actualdutyinr                           = it_data-CreateActualDutyINR              .
wa_head-remdutyinr                              = it_data-CreateRemDutyINR                 .


MODIFY zim_maintain_lic FROM @wa_head.
responce = |Data Change successfully.{ it_data-CreateLicenseRefNo }|.


       LOOP AT it_data-aFiles INTO wa_ONUPLOAD.


        WA_zmaint_lic_atch-licenserefno   = it_data-CreateLicenseRefNo.
        WA_zmaint_lic_atch-attachment  = wa_ONUPLOAD-content.
        WA_zmaint_lic_atch-contentname  = wa_ONUPLOAD-filename.
        WA_zmaint_lic_atch-filename  = wa_ONUPLOAD-filename.
        WA_zmaint_lic_atch-mimetype  = wa_ONUPLOAD-mimetype.
        WA_zmaint_lic_atch-note  = wa_ONUPLOAD-programname.

        MODIFY zmaint_lic_atch FROM @WA_zmaint_lic_atch .
        CLEAR: wa_ONUPLOAD ,WA_zmaint_lic_atch.

      ENDLOOP.

ENDIF.
    response->set_text( responce ).
  endmethod.
ENDCLASS.
