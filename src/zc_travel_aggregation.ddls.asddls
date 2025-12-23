@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'Travel Aggregation Consumption View'
//@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@Analytics.query: true
define transient view entity ZC_TRAVEL_AGGREGATION
  provider contract analytical_query
  as projection on zi_travel_aggregation
{
  @UI.lineItem: [{ position: 10 }]
  @Consumption.filter: {
      mandatory: true,
      selectionType: #RANGE
  }
  @AnalyticsDetails.query.axis: #ROWS
  supplement_id,
  @UI.lineItem: [{ position: 20 }]
  @AnalyticsDetails.query.axis: #ROWS
  Tag,
  @UI.lineItem: [{ position: 30 }]
  @Aggregation.default: #SUM
  TotalPrice,
  @UI.lineItem: [{ position: 40 }]
  currency_code
}
