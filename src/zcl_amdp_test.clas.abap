CLASS zcl_amdp_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    TYPES: tt_cds TYPE TABLE OF zi_travel_aggregation.
    TYPES: BEGIN OF ty_cds,
             supplement_id TYPE /dmo/supplement_id,
             tag           TYPE char10,
             TotalPrice    TYPE /dmo/supplement_price,
             currency_code TYPE /dmo/currency_code,
           END OF ty_cds,
           tt_cds2 TYPE TABLE OF zi_travel_aggregation WITH EMPTY KEY.

    CLASS-METHODS get_data_cds
      AMDP OPTIONS CDS SESSION CLIENT DEPENDENT
*      IMPORTING
*        VALUE(iv_clnt) TYPE sy-mandt
      EXPORTING
        VALUE(it_cds) TYPE tt_cds2.

    CLASS-METHODS get_max_cds
      AMDP OPTIONS CDS SESSION CLIENT DEPENDENT
*      IMPORTING
*        VALUE(iv_clnt) TYPE sy-mandt
      EXPORTING
        VALUE(it_cds) TYPE tt_cds2.


  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS get_data_cds_p
      AMDP OPTIONS CDS SESSION CLIENT DEPENDENT
      EXPORTING
        VALUE(it_cds) TYPE tt_cds2.

    CLASS-METHODS get_data_cds_tf
      AMDP OPTIONS CDS SESSION CLIENT DEPENDENT
      READ-ONLY
      RETURNING VALUE(it_cds) TYPE tt_cds2.

    CLASS-METHODS get_max_cds_tf
      AMDP OPTIONS CDS SESSION CLIENT DEPENDENT
      READ-ONLY
      RETURNING VALUE(et_max) TYPE zi_travel_aggregation-TotalPrice.

ENDCLASS.



CLASS zcl_amdp_test IMPLEMENTATION.
  METHOD get_data_cds BY DATABASE PROCEDURE
                      FOR HDB
                      LANGUAGE SQLSCRIPT
                      OPTIONS READ-ONLY
                      USING zcl_amdp_test=>get_data_cds_tf.


*    it_max = Select TotalPrice from "ZCL_AMDP_TEST=>GET_MAX_CDS_TF" ( );

    it_cds = SELECT * FROM "ZCL_AMDP_TEST=>GET_DATA_CDS_TF" ( );

*    "ZCL_AMDP_TEST=>GET_DATA_CDS_P"(
*        it_cds => :it_cds
*    );

  ENDMETHOD.

  METHOD get_data_cds_p BY DATABASE PROCEDURE
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING zi_travel_aggregation.

    it_cds = SELECT supplement_id, Tag, TotalPrice, currency_code
               FROM zi_travel_aggregation ;
*              WHERE client = :iv_clnt;

  ENDMETHOD.

  METHOD get_data_cds_tf BY DATABASE FUNCTION
                         FOR HDB
                         LANGUAGE SQLSCRIPT
                         OPTIONS READ-ONLY
                         USING zi_travel_aggregation.

    RETURN select supplement_id, Tag, TotalPrice, currency_code
               FROM zi_travel_aggregation ;
*              WHERE client = :iv_clnt;

  ENDMETHOD.

  METHOD get_max_cds_tf BY DATABASE FUNCTION
                        FOR HDB
                        LANGUAGE SQLSCRIPT
                        OPTIONS READ-ONLY
                        USING zi_travel_aggregation.

    SELECT MAX (TotalPrice)
      INTO et_max
      FROM zi_travel_aggregation;

  ENDMETHOD.

  METHOD get_max_cds BY DATABASE PROCEDURE
                     FOR HDB
                     LANGUAGE SQLSCRIPT
                     OPTIONS READ-ONLY
                     USING zi_travel_aggregation zcl_amdp_test=>get_max_cds_tf.


    it_cds =  SELECT supplement_id,
                     Tag,
                     TotalPrice,
                     currency_code
                FROM zi_travel_aggregation
               WHERE TotalPrice = "ZCL_AMDP_TEST=>GET_MAX_CDS_TF" ( );

  ENDMETHOD.

ENDCLASS.
