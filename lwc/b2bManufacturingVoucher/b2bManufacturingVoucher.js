import { LightningElement, api } from 'lwc';
import assets from '@salesforce/resourceUrl/assets';

export default class B2bManufacturingVoucher extends LightningElement {
    @api name = "Toolkit Voucher";
    @api code = "TOOL2003URSA";
    @api expirationDate ="1616652711409";
    @api type;

    get iconSrc() {
        switch (this.type) {
            case 'FixedValue':
                return `${assets}/icons/voucher_2.png`;
            case 'DiscountPercentage':
                return `${assets}/icons/voucher_3.png`;
            default:
                return `${assets}/icons/voucher_1.png`;
        }
    }

    get pathIcon() {
        return `${assets}/icons/path.png`;
    }
}