CLASS zcl_amdp_consumption DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .


  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA : out TYPE REF TO if_oo_adt_classrun_out.
    METHODS : get_data.

ENDCLASS.



CLASS zcl_amdp_consumption IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me->out = out.
    get_data(  ).
  ENDMETHOD.

  METHOD get_data.
*    DATA: lt_cds TYPE TABLE OF zi_travel_aggregation.
*    zcl_amdp_test=>get_data_cds( IMPORTING it_cds = DATA(lt_cds) ).
    zcl_amdp_test=>get_max_cds( IMPORTING it_cds = DATA(lt_cds) ).

*    zcl_amdp_test=>get_data_cds_tf(
*      RECEIVING
*        it_cds = DATA(lt_cds)
*    ).

    IF lt_cds IS NOT INITIAL.
      out->write( lt_cds ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.
