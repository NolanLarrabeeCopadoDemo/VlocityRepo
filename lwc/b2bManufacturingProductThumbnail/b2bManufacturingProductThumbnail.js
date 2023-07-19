import { LightningElement, api ,track, wire } from 'lwc';
import redeemPoints from '@salesforce/apex/B2BCommunitiesRedemptionController.redeemPoints';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { NavigationMixin } from 'lightning/navigation';
import { publish, MessageContext } from 'lightning/messageService';
import redeemDetails from '@salesforce/messageChannel/RedeemDetails__c';

import assets from '@salesforce/resourceUrl/assets';

export default class NTOProductThumbnail extends NavigationMixin(LightningElement) {
    @api productUrl = "/nto/s/rainer";
    @api productImageUrl;
    @api productName;
    @api productPrice;
    @api showCompare = false;
    @api partnerId;
    @api productId;
    @api journalSubtypeId;
    @api voucherDefinitionId;
    @api category;

    @track isModalOpen = false;
    @track isSpinner = false;
    @track accounts;
    @track error;

    get quickViewTitle() {
        return "Quick View for " + this.productName;
    }
    openModalWindow() {
        this.isModalOpen = true;
    }
    closeModal() {
        this.isModalOpen = false;
    }
    initiateRedeemPoints() {
        this.isSpinner = true;
        this.isModalOpen = false;
        redeemPoints({productId : this.productId, partnerId : this.partnerId, journalsubtypeId : this.journalSubtypeId, voucherDefinitionId :  this.voucherDefinitionId, category  : this.category})
            .then(result => {
                var response = JSON.parse(result);
                if(response.isRedeemed){
                    this.isSpinner = false;
                    const evt = new ShowToastEvent({
                        title: 'SUCCESS!',
                        message: this.productPrice+ ' points were used for '+this.productName+'.',
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                    const payload = { pointBalance :response.currentPointsBalance};
                    publish(this.messageContext, redeemDetails, payload);
                }
                else if(!response.isRedeemed && response.pointsRequired > response.currentPointsBalance){
                    this.isSpinner = false;
                    const evt = new ShowToastEvent({
                        title: 'FAILURE!',
                        message: 'You don’t have enough points for this transaction.',
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                    
                }else{
                    this.isSpinner = false;
                    const evt = new ShowToastEvent({
                        title: 'FAILURE!',
                        message: 'We can’t redeem your points right now. Try again later.',
                        variant: 'error',
                    });
                    this.dispatchEvent(evt);
                    
                }
            })
            .catch(() => {
                this.isSpinner = false;
                const evt = new ShowToastEvent({
                    title: 'FAILURE!',
                    message: 'We can’t redeem your points right now. Try again later.',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
            });
      
    }
    @wire(MessageContext)
    messageContext;

    get confirmationSrc() {
        return `${assets}/icons/confirmation.png`;
    }
}