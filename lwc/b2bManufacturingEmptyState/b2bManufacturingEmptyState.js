import { LightningElement, api, track } from 'lwc';

export default class B2bEmptyState extends LightningElement {
    _title;
    @api message;
    @track emptyStateclassName = 'slds-illustration  slds-illustration_small';
    @api 
    get title() {
        return this._title;
    }

    set title(value) {
        if(value == "Nothing to show") {
            this.emptyStateclassName = 'slds-illustration  slds-illustration_large';
        }  
        else {
            this.emptyStateclassName = 'slds-illustration  slds-illustration_small';
        }
        this._title = value;
    }
   
}