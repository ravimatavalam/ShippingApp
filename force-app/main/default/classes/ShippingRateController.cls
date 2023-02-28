public with sharing class ShippingRateController {
    @AuraEnabled
    public static FEDXApi.ShippingHQRes getShippingRates(String jsonReq){
        System.debug(jsonReq);
        FEDXApi.ShippingHQReq shippingHQReqObj = (FEDXApi.ShippingHQReq) JSON.deserializeStrict(jsonReq, FEDXApi.ShippingHQReq.class);
        FEDXApi.ShippingHQRes shippingHQResObj  = FEDXApi.getFEDXShippingRates(shippingHQReqObj);
        return shippingHQResObj;
    }
}