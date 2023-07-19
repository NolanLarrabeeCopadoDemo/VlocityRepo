import { LightningElement, api, wire, track } from 'lwc';
import getVouchers from '@salesforce/apex/B2BManufacturingBenefitAndVouchers.getVouchers';

export default class B2bManufacturingVouchers extends LightningElement {
    @api memberId;
    @track showArrows =false;
    @track records;
    @track error;
    @track voucherpresent;
    

    connectedCallback() {
        getVouchers() 
            .then(result => {
                this.records =result;
                if(result.length>0 ){
                    this.voucherpresent =true;
                    this.showArrows = result.length>5? true :false;
                }
                else{
                    this.voucherpresent =false;
                }
            })
            .catch((error) => {
                this.error = error;
                this.records = undefined;
                this.voucherpresent =false;
            });
    } 
 

    get vochersListElem() {
        return this.template.querySelector('ul');
    }

    scrollLeft() {
        this.vochersListElem.scrollLeft -= 240;
    }
    scrollRight() {
        this.vochersListElem.scrollLeft += 240;
    }
}