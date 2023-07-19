import { LightningElement, wire } from 'lwc';
import getProfileDetails from '@salesforce/apex/B2BManufacturingPointsController.getMemberDetails';
import { subscribe, MessageContext } from 'lightning/messageService';
import redeemDetails from '@salesforce/messageChannel/RedeemDetails__c';
import { refreshApex } from '@salesforce/apex';

export default class NTOInsiderProfile extends LightningElement {
    membershipNumber;
    pointsBalance;
    memberId;
    memberProfile;

    pointsExpiryInfo = {
        points: 210,
        date: "Mar 18, 2021"
    };

    tierInfo = {
        name: '',
        points: 0
    }

    tierSteps = [
        {
            "label": "Silver",
            "points": 0,
            "isCompleted": (this.tierInfo.name == 'Silver')
        },
        {
            "label": "Gold",
            "points": 1000,
            "isCompleted": (this.tierInfo.name == 'Gold')
        },
        {
            "label": "Platinum",
            "points": 2500,
            "isCompleted": (this.tierInfo.name == 'Platinum')
        }
    ];

    connectedCallback() { 
        this.subscribeToMessageChannel();
    }

    @wire(getProfileDetails)
    wiredProfileDetails (result) {
        this.memberProfile =result;
        if (result.data) {
            this.memberId = result.data.memberId;
            this.membershipNumber = result.data.membershipNumber;
            this.pointsBalance = result.data.pointBalance;

            this.tierInfo.name = result.data.tier;
            if (this.tierInfo.name == 'Silver') {
                this.tierInfo.points = 0;
            } else if (this.tierInfo.name == 'Gold') {
                this.tierInfo.points = 1250;
            } else {
                this.tierInfo.points = 2500;
            }
            
        } else if (result.error) {
            this.error = result.error;
        }
    }
    currentPointsBalance
    subscribeToMessageChannel() { 
        this.subscription = subscribe(
            this.messageContext,
            redeemDetails,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message) { 
    return refreshApex(this.memberProfile);
    }

    @wire(MessageContext)
    messageContext;
}