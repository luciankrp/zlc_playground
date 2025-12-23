@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel Interface for aggregation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Analytics.dataCategory: #CUBE
define view entity zi_travel_aggregation
  as select from ztf_travel_aggregation
{
  key supplement_id,
      Tag,
      @Semantics.amount.currencyCode: 'currency_code'
      @Aggregation.default: #SUM
      TotalPrice,
      currency_code

}
