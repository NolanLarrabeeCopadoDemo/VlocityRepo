import { LightningElement } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';

export default class B2bProgramTiers extends LightningElement {
    tiers = [
        {
            id: 1,
            name: "SILVER",
            icon: `${assets}/icons/Silver.png`,
            description: "Receive our monthly eNewsletter, join our partner portal, sign up for product and sales training, and much more."
        },
        {
            id: 2,
            name: "GOLD",
            icon: `${assets}/icons/Gold.png`,
            description: "Request market development funds, participate in annual partner conferences, get free shipping, and call for support."
        },
        {
            id: 3,
            name: "PLATINUM",
            icon: `${assets}/icons/Platinum.png`,
            description: "Get additional benefits such as early access to products, extended returns, premium support, and exclusive marketing collateral."
        }
    ]
}