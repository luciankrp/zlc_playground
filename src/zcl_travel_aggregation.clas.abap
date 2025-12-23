CLASS zcl_travel_aggregation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS get_travel_aggregation FOR TABLE FUNCTION ztf_travel_aggregation.


    INTERFACES if_amdp_marker_hdb .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_travel_aggregation IMPLEMENTATION.
  METHOD get_travel_aggregation BY DATABASE FUNCTION
                                FOR HDB
                                LANGUAGE SQLSCRIPT
                                OPTIONS READ-ONLY
                                USING /dmo/travel /dmo/booking /dmo/book_suppl /dmo/supplement.

    declare lv_client nvarchar( 3 );
    lv_client := session_context('CDS_CLIENT');

    lt_supplid = SELECT a.client,
                        d.supplement_id,
                        case when sum(d.price) < 1000 then 'LOW'
                             WHEN sum(d.price) > 1001 and sum(d.price) < 4000 then 'MEDIUM'
                             WHEN sum(d.price) > 4001 then 'HIGH'
                             ELSE 'N/A' END as Tag,
                        sum(d.price)        as TotalPrice,
                        min(d.price)        as MinPrice,
                        max(d.price)        as MaxPrice,
                        count(*)            as CountNo,
                        d.currency_code
                   from "/DMO/TRAVEL" as a
                   inner join   "/DMO/BOOKING"    as b on a.travel_id = b.travel_id
                   inner join   "/DMO/BOOK_SUPPL" as c on  b.travel_id  = c.travel_id
                                                    and b.booking_id = c.booking_id
                   inner join   "/DMO/SUPPLEMENT" as d on c.supplement_id = d.supplement_id
                   where a.client = lv_client
                   group by a.client, d.supplement_id, d.currency_code
                   order by TotalPrice desc;

      lt_supplid2 =  select client,
                            supplement_id,
                            cast( Tag as char (10)) as Tag,
                            TotalPrice,
                            MinPrice,
                            MaxPrice,
                            CountNo,
                            currency_code,
                            dense_rank ( ) over ( partition by Tag order by TotalPrice desc ) as DenseRank
                       from :lt_supplid;

      RETURN select client,
                    supplement_id,
                    cast( Tag as char (10)) as Tag,
                    TotalPrice,
                    MinPrice,
                    MaxPrice,
                    CountNo,
                    currency_code
               from :lt_supplid2 where DenseRank = 1 ORDER BY TotalPrice desc;

  ENDMETHOD.
ENDCLASS.
