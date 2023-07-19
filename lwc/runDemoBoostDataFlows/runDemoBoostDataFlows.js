import { LightningElement } from 'lwc';
import runDataFlows from '@salesforce/apex/DemoBoostRunDataFlows.runDataFlows';

export default class RunDemoBoostDataFlows extends LightningElement {
    resultMessage;

    connectedCallback(){
        this.runDataFlows();
    }

    runDataFlows(){
        runDataFlows()
            .then(result => {
                this.resultMessage = result;
            })
            .catch(error => {
                this.resultMessage = error;
            });
    }
}