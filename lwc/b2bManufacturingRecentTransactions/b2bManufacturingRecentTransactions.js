import { LightningElement,wire, api, track} from 'lwc';
import getRecentTransactions from '@salesforce/apex/B2BManufacturingTransactionsController.getTransactionJournals';
import { subscribe,unsubscribe,APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import redeemDetails from '@salesforce/messageChannel/RedeemDetails__c';
import { refreshApex } from '@salesforce/apex';

export default class NTOInsiderProfileRecentTractions extends LightningElement {
    @track recentTransactions;
    @track transactionPresent;
    @track visibleTransactions =[];
    columns = [
        { label: 'Transaction Date', fieldName: 'transactionDate',hideDefaultActions: true},
        { label: 'Details', fieldName: 'transactionDetails',hideDefaultActions: true},
        { label: 'Points', fieldName: 'rewardPoints' ,hideDefaultActions: true}
    ];

    @api memberId;


    connectedCallback() {
        getRecentTransactions() 
            .then(result => {
                this.recentTransactions =result;
                if(result.length>0 ){
                    this.transactionPresent =true;
                }
                else{
                    this.transactionPresent =false;
                }
            })
            .catch((error) => {
                this.error = error;
                this.transactionPresent =false;
            });
    }

    comupteClass(){
        let className = '';
        if(this.transactionPresent){
            className = 'transactionTabelHeight';
        }
        return className;
    }

    updateTransactionHandler(event){
        this.visibleTransactions=[...event.detail.records]
    }


}