import { LightningElement,api } from 'lwc';
import { FlowNavigationNextEvent,FlowNavigationFinishEvent } from 'lightning/flowSupport';

export default class RewindOrders extends LightningElement {

    @api clickedButtonValue;

    handleClick(event) {
        this.clickedButtonValue = event.target.value;
        const nextNavigationEvent = new FlowNavigationNextEvent();
       this.dispatchEvent(nextNavigationEvent);
    }

}