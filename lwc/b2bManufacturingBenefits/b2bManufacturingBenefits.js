import { LightningElement, api, wire, track } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';
import getProfileDetails from '@salesforce/apex/B2BManufacturingPointsController.getMemberDetails';

const goldTier = {
    "name": "Gold Tier",
    "tierCard": `${assets}/icons/Gold_Accelerate.png`,
    "description": "For Exclusive Benefits including Premium Support Access to Platinum Partner Funds and many more",
    "benifits": [
        {
            id: 0,
            icon: `${assets}/icons/accelerate_to_platinum_1.png`,
            text: '2 years of partnership'
        },
        {
            id: 2,
            icon: `${assets}/icons/accelerate_to_platinum_2.png`,
            text: '$1M in Annual Sales'
        },
        {
            id: 3,
            icon: `${assets}/icons/accelerate_to_platinum_3.png`,
            text: '50% Training Compliance and 1 or more Quarterly Conferences'
        }
    ]
}

const platinumTier = {
    "name": "Platinum Tier",
    "tierCard": `${assets}/icons/Platinum_Accelerate.png`,
    "description": "For Exclusive Benefits including Premium Support Access to Platinum Partner Funds and many more",
    "benifits": [
        {
            id: 0,
            icon: `${assets}/icons/accelerate_to_platinum_1.png`,
            text: '4 years of partnership'
        },
        {
            id: 2,
            icon: `${assets}/icons/accelerate_to_platinum_2.png`,
            text: '$2.5M in Annual Sales'
        },
        {
            id: 3,
            icon: `${assets}/icons/accelerate_to_platinum_3.png`,
            text: '70% Training Compliance and 2 or more Quarterly Conferences'
        }
    ]
}

export default class B2bManufacturingBenefits extends LightningElement {
    _tierName;
    @track accelerateTier;
    @track tierHeading;
    @api memberId;
    @api 
    get tierName() {
        return this._tierName;
    }

    set tierName(value) {
        if(value == "Silver") {
            this.accelerateTier = goldTier;
            this.tierHeading = 'Make the Move to';
        } else if(value == 'Gold') {
            this.accelerateTier = platinumTier;
            this.tierHeading = 'Make the Move to';
        } else if(value == 'Platinum') {
            this.accelerateTier = platinumTier;
            this.tierHeading = 'Retain Your';
        }
        else {
            this.accelerateTier = undefined;
        }
        this._tierName = value;
    }

    get computedCurrentTierClassnames() {
        let classNames = 'slds-col slds-size_1-of-1';
        if(this.accelerateTier) {
            classNames = classNames + " slds-medium-size_8-of-12";
        }
        return classNames;
    }
}