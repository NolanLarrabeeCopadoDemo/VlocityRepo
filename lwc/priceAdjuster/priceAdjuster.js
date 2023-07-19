import { LightningElement, track, wire } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import PRODUCT2_OBJECT from '@salesforce/schema/Product2';
import PRODUCT_FAMILY_FIELD from '@salesforce/schema/Product2.Family';
import APEX_getActiveContracts from '@salesforce/apex/PriceAdjusterController.getActiveContracts';
import APEX_submitForPriceAdjustment from '@salesforce/apex/PriceAdjusterController.submitForPriceAdjustment';

export default class PriceAdjuster extends LightningElement {
  family = '';
  geography = '';
  adjustment = 0;
  loading = false;
  @track geographyOptions = [];


  @wire(getObjectInfo, { objectApiName: PRODUCT2_OBJECT })
  productMetadata;
  @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
  accountMetadata;
  @wire(getPicklistValues,
    { 
      recordTypeId: '$productMetadata.data.defaultRecordTypeId', 
      fieldApiName: PRODUCT_FAMILY_FIELD 
    })
  productFamilyPicklist;


  connectedCallback() {
    APEX_getActiveContracts().then(result => {
      const records = result;
      let uniqueValues = [];

      for(const record of records){
        const option = {
            label: record.Account.BillingAddress.country,
            value: record.Account.BillingAddress.country
        };

        if (!uniqueValues.find(e => e === option.value)) {
          uniqueValues.push(option.value);
          this.geographyOptions = [ ...this.geographyOptions, option ];
        }

      }
    })
  }

  handleChangeFam(event) {
    this.family = event.detail.value;
  }
  handleChangeGeo(event) {
    this.geography = event.detail.value;
  }
  handleChangeAdjustment(event) {
    this.adjustment = event.detail.value;
  }
  handleSubmit() {
    this.loading = true;
    this.validation() ? console.log('valid config') : console.log('non-valid config');
    console.log(`${this.family}, ${this.geography}, ${this.adjustment}`);
    APEX_submitForPriceAdjustment({productFamily: this.family, billingCountry: this.geography, adjustment: this.adjustment});
    this.loading = false;
  }

  validation() {
    if (!this.family || !this.geography) { return false; }
    if (this.adjustment <= 0) { return false; }
    return true;
  }

}