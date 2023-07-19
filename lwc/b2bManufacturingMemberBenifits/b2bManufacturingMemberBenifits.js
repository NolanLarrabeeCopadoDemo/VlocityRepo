import { LightningElement } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';

export default class B2bMemberBenifits extends LightningElement {
    benifits = [
        {
            id: 1,
            icon: `${assets}/icons/benefit_icon_1.png`,
            name:"Member Exclusives",
            description: "Get early access to new products."
        },
        {
            id: 2,
            icon: `${assets}/icons/benefit_icon_2.png`,
            name:"Marketing Support",
            description: "Get access to market development funds, marketing collaterals, our partner portal, and other benefits."
        },
        {
            id: 3,
            icon: `${assets}/icons/benefit_icon_3.png`,
            name:"Training",
            description: "Enroll in exclusive product and sales classes and get access to e-learning resources."
        },
        {
            id: 4,
            icon: `${assets}/icons/benefit_icon_4.png`,
            name:"Free Shipping",
            description: "Get free shipping on your orders."
        },
        {
            id: 5,
            icon: `${assets}/icons/benefit_icon_5.png`,
            name:"Extended Return Windows",
            description: "Receive additional time for order returns."
        },
        {
            id: 6,
            icon: `${assets}/icons/benefit_icon_6.png`,
            name:"Technical Support",
            description: "Find answers to your questions by calling one of our phone support experts."
        },
    ]
}