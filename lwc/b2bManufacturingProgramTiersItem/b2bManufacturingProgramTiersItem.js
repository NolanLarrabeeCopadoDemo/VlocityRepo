import { LightningElement, api } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';

export default class B2bProgramTiersItem extends LightningElement {
    @api name;
    @api description;
    @api icon;

    get iconSrc() {
        return `${assets}/icons/Gold.png`;
    }
}