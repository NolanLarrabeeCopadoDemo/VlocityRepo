import { LightningElement, api } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';

export default class B2bAccelerateTile extends LightningElement {
    @api name;
    @api tierHeading;
    @api tierCard;
    @api description;
    @api benifits = [];

}