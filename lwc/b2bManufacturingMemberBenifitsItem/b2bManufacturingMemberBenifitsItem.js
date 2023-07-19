import { LightningElement, api } from 'lwc';

export default class B2bMemberBenifitsItem extends LightningElement {
    @api icon;
    @api name;
    @api description;
}