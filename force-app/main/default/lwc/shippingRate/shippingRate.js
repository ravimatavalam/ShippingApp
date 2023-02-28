import { LightningElement, api, wire } from 'lwc';
import getShippingRates from '@salesforce/apex/ShippingRateController.getShippingRates';

import {CurrentPageReference} from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class ShippingRate extends LightningElement {

    @api recordId;
    rateReplyDetails;

    shipperPostalCode;
    shipperCoutryCode;
    recipientPostalCode;
    recipientCountryCode;
    
    isInit = false;
    connectedCallback(){
        debugger;
        if(this.isInit){
            return;
        }
        this.isInit = true;
        debugger;

    }

    getShippingRatesJS(){
        getShippingRates( { jsonReq : JSON.stringify({shipperPostalCode : this.shipperPostalCode, shipperCoutryCode : this.shipperCoutryCode,
            recipientPostalCode : this.recipientPostalCode,  recipientCountryCode : this.recipientCountryCode})})
        .then(result =>{
            let jsonRes = result;
            console.log(jsonRes);
            let response = JSON.parse(jsonRes.response);
            if(response.errors && response.errors.length){
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: response.errors[0].message,
                        variant: 'error'
                    })
                );
            }else{
                this.rateReplyDetails = response.output.rateReplyDetails;
            }
        })
        .catch(result => {
            console.log(result);
            console.log('shipperrrrttttt');
        });
    }

    handleChange(e){
        let name = e.currentTarget.dataset.name;
        if(name == 'shipperPostalCode'){
            this.shipperPostalCode = e.currentTarget.value; 
        }else if(name == 'shipperCoutryCode'){
            this.shipperCoutryCode = e.currentTarget.value; 
        }else if(name == 'recipientPostalCode'){
            this.recipientPostalCode = e.currentTarget.value; 
        }else if(name == 'recipientCountryCode'){
            this.recipientCountryCode = e.currentTarget.value; 
        }
    }

    handleGetRates(){
        debugger;
        let isValid = true;
        let inputFields = this.template.querySelectorAll('.slds-input');
        for(let i=0;i<inputFields.length;i++){
            let inputField = inputFields[i];
            if(!inputField.checkValidity()) {
                inputField.reportValidity();
                isValid = false;
                break;
            }
        }
        if(isValid){
            this.getShippingRatesJS();    
        }   
    }
}