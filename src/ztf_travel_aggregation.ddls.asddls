@EndUserText.label: 'Table Function for aggregation'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
define table function ztf_travel_aggregation
  //  with parameters
  //    @Environment.systemField: #CLIENT
  //    iv_client : abap.clnt
returns
{
  key client        : abap.clnt;
  key supplement_id : /dmo/supplement_id;
      Tag           : abap.char( 10 );
      @Semantics.amount.currencyCode: 'currency_code'
      TotalPrice    : /dmo/supplement_price;
      @Semantics.amount.currencyCode: 'currency_code'
      MinPrice      : /dmo/supplement_price;
      @Semantics.amount.currencyCode: 'currency_code'
      MaxPrice      : /dmo/supplement_price;
      CountNo       : abap.int4;
      currency_code : /dmo/currency_code;

}
implemented by method
  zcl_travel_aggregation=>get_travel_aggregation;