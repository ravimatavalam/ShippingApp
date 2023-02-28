public with sharing class FEDXApi {
    public FEDXApi() {}

    public static String getAccessToken(){

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('callout:FEDX/oauth/token');
        req.setMethod('POST');
        req.setBody('grant_type=client_credentials&client_id={!$Credential.UserName}&client_secret={!$Credential.Password}');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        String accessToken;
        try {
            res = http.send(req);
            System.debug('FEDXApi:getAccessToken:'+res.getBody());
            Map<String, object> resMap = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            accessToken =  (String) resMap.get('access_token');
        } catch(System.CalloutException e) {
            System.debug('FEDXApi:getAccessToken:Callout error: '+ e);
            System.debug(res.toString());
        }
        return accessToken;
    }

    public static ShippingHQRes getFEDXShippingRates(ShippingHQReq shippingHQReqObj){
        ShippingHQRes shippingHQResObj = new ShippingHQRes();
        String accessToken = FEDXApi.getAccessToken();
        System.debug('accessToken:'+accessToken);


        Map<String,Object> reqBody = new Map<String,Object>{
            'accountNumber' => new Map<String,Object>{'value' => '740561073'},
            'requestedShipment' => new Map<String,Object>{
                                  'shipper' => new Map<String,Object>{
                                               'address' => new Map<String,Object>{
                                                            'postalCode' => shippingHQReqObj.shipperPostalCode,
                                                            'countryCode' => shippingHQReqObj.shipperCoutryCode
                                                            }
                                                },
                                    'recipient' => new Map<String,Object>{
                                        'address' => new Map<String,Object>{
                                                    'postalCode' => shippingHQReqObj.recipientPostalCode,
                                                    'countryCode' => shippingHQReqObj.recipientCountryCode
                                                }
                                        
                                        },
                                    'pickupType' => 'DROPOFF_AT_FEDEX_LOCATION',
                                    'rateRequestType' =>  new List<String>{
                                                            'ACCOUNT',
                                                            'LIST'
                                                          },
                                    'requestedPackageLineItems' => new List<Object>{
                                                                        new Map<String,Object>{
                                                                            'weight' => new Map<String,Object>{
                                                                                        'units' => 'LB',
                                                                                        'value' => 10
                                                                            }
                                                                            
                                                                        }
                                                                    }
            }


        };

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
       System.debug(JSON.serializePretty(reqBody));
        req.setEndpoint('callout:FEDX/rate/v1/rates/quotes');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody( JSON.serializePretty(reqBody));
        req.setHeader('authorization', 'Bearer ' + accessToken);
        req.setHeader('x-locale', 'en_US');

        try {
            res = http.send(req);
            System.debug(res.getBody());
            Map<String, object> resMap = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
            shippingHQResObj.isSuccess = true;
            shippingHQResObj.response = res.getBody();

        } catch(System.CalloutException e) {
            System.debug('Callout error: '+ e);
            System.debug(res.toString());
            shippingHQResObj.isSuccess = false;
            shippingHQResObj.response = res.toString();
        }
        return shippingHQResObj;
    }

    public class ShippingHQRes{
        @AuraEnabled public Boolean isSuccess{get;set;}
        @AuraEnabled public String error{get;set;}
        @AuraEnabled public String response{get;set;}
    }
    public class ShippingHQReq{
        @AuraEnabled public String originAddress{get;set;}
        @AuraEnabled public Integer shipperPostalCode{get;set;}
        @AuraEnabled public String shipperCoutryCode{get;set;}
        @AuraEnabled public Integer recipientPostalCode{get;set;}
        @AuraEnabled public String recipientCountryCode{get;set;}
        @AuraEnabled public String detinationAddress{get;set;}
    }
}