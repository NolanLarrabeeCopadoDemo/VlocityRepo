import { LightningElement, api } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';


export default class NTOInsiderProfilePoints extends LightningElement {
    @api pointsBalance = 0;
    @api expiringPoints = 0;
    @api membershipNumber = 0;
    @api expiryDate = '';
    @api tierName = '';
    @api tierPoints = 0;
    @api tierSteps = []; 

    isRendered = false;

    get expiringInfo() {
        return `${this.expiringPoints} on ${this.expiryDate}`;
    }

    get tierPointsLabel() {
        return `Tier Points: ${this.tierPoints}`;
    }


    get styles() {
        return `
            background-image: url(${this.tierBgImg});
            background-position: center;
            background-size: cover;
        `;
    }

    get membershipBanner() {
        return `${assets}/icons/Banner_1.png`;
    }

    get pointsBalanceBanner() {
        return `${assets}/icons/Banner_2.png`;
    }

    get tierBanner() {
        return `${assets}/icons/Banner_3.png`;
    }

    adjustContainerWidths() {
        let container = this.template.querySelector('.profile-points-wrapper');
        const screenWidth = screen.availWidth;
        const containerWidth = container.offsetWidth;
        const diff = screenWidth - containerWidth;
        if(diff > 0) {
            const maringValue = "-" + diff/2 + "px";
            container.style.marginLeft = maringValue;
            container.style.marginRight = maringValue;
        }
    }

    renderedCallback() {
        if(this.isRendered) {
            return;
        }
        this.adjustContainerWidths();
        this.isRendered = true;
    }
}