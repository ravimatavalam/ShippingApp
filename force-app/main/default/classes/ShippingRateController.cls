/*******************************************************************************************
* @Name         ShippingRateController
* @Author       Ravi
* @Date         04/02/2023
* @Description  This class is controller class which intract with client side
                contains method related to shipping rates
*******************************************************************************************/
public with sharing class ShippingRateController {

    /**************************************************************************************
    * @Description  This method gets shipping rates
    * @Param		String - jsonReq (FEDXApi.ShippingHQReq)
    * @Return       FEDXApi.ShippingHQRes - shippingHQResObj
    * @Example     
    * ShippingRateController.getShippingRates()
    **************************************************************************************/ 
    @AuraEnabled
    public static FEDXApi.ShippingHQRes getShippingRates(String jsonReq){
        System.debug(jsonReq);
        FEDXApi.ShippingHQReq shippingHQReqObj = (FEDXApi.ShippingHQReq) JSON.deserializeStrict(jsonReq, FEDXApi.ShippingHQReq.class);
        FEDXApi.ShippingHQRes shippingHQResObj  = FEDXApi.getFEDXShippingRates(shippingHQReqObj);
        return shippingHQResObj;
    }
}