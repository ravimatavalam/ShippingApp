@isTest
class ShippingRateControllerTest {
    @isTest
    static void  testShippingRateControllerTest() {

        Test.setMock(HttpCalloutMock.class, new FEDXMock());
        Test.startTest();
            new FEDXApi();
            FEDXApi.ShippingHQReq shippingHQReqObj = new  FEDXApi.ShippingHQReq();
            shippingHQReqObj.shipperPostalCode = 4566;
            shippingHQReqObj.recipientPostalCode = 4555;
            shippingHQReqObj.recipientCountryCode = 'US';
            shippingHQReqObj.shipperCoutryCode = 'US';
            FEDXApi.ShippingHQRes res = ShippingRateController.getShippingRates(JSON.serializePretty(shippingHQReqObj));
            system.assertEquals(true, res.isSuccess);
        Test.stopTest();
    }
}