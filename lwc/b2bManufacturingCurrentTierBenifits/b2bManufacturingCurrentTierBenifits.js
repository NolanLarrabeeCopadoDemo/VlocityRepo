import { LightningElement, api, track, wire } from 'lwc';
import getBenefits from '@salesforce/apex/B2BManufacturingBenefitAndVouchers.getBenefits';
import assets from '@salesforce/resourceUrl/assets';

export default class B2bManufacturingBenefits extends LightningElement {
    @track benefits;
    @track benefitspresent;
    @track tierData = {};
    @api tierName ;
    @api memberId;

    @wire(getBenefits, { memberId: '$memberId'})  
    wirebenefit({ error, data }) {
        if (data) {
            this.benefits = data;
            this.error = undefined;
            if(data.length>0 ){
                this.benefitspresent =true;
            }
            else{
                this.benefitspresent =false;
            }
        } else if (error) {
            this.error = error;
            this.benefits = undefined;
            this.benefitspresent =false;
        }
        
    }



    get tierIcon() {
        return `${assets}/icons/benefit_list_header.png`;
    }
}