import { LightningElement, track, wire } from 'lwc';
import getProfileDetails from '@salesforce/apex/B2BManufacturingPointsController.getMemberDetails';

export default class NTOInsiderProfile extends LightningElement {
    membershipNumber;
    pointsBalance;
    memberId;


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

    @wire(getProfileDetails)
    wiredProfileDetails ({ error, data }) {
        if (data) {
            this.memberId = data.memberId;
            this.membershipNumber = data.membershipNumber;
            this.pointsBalance = data.pointBalance;

            this.tierInfo.name = data.tier;
            if (this.tierInfo.name == 'Silver') {
                this.tierInfo.points = 0;
            } else if (this.tierInfo.name == 'Gold') {
                this.tierInfo.points = 1250;
            } else {
                this.tierInfo.points = 2500;
            }

        } else if (error) {
            this.error = error;
        }
    }
}