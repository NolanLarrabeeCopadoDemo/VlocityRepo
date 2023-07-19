import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {
    currentPage =1
    totalRecords
    _recordSize = 10
    totalPage = 0
    @api
    get recordSize(){
        return this._recordSize;
    }
    set recordSize(value){
        if(value){
            this._recordSize = Number(value);
        }
        else {
            this._recordSize = 10;
        }
    }

    @api 
    get records(){
        return this.visibleRecords
    }
    
    set records(data){
        if(data){ 
            this.totalRecords = data
            
            this.updateRecords()
        }
    }

    get disablePrevious(){ 
        return this.currentPage<=1
    }
    get disableNext(){ 
        return this.currentPage>=this.totalPage
    }
    previousHandler(){ 
        if(this.currentPage>1){
            this.currentPage = this.currentPage-1
            this.updateRecords()
        }
    }
    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage+1
            this.updateRecords()
        }
    }
    updateRecords(){ 
        this.totalPage = Math.ceil(this.totalRecords.length/this.recordSize)
        const start = (this.currentPage-1)*this.recordSize
        const end = this.recordSize*this.currentPage
        console.log(this.totalPage);
        console.log(start);
        console.log(end);
        console.log(this.currentPage);
        this.visibleRecords = this.totalRecords.slice(start, end)
        this.dispatchEvent(new CustomEvent('update',{ 
            detail:{ 
                records:this.visibleRecords
            }
        }))
    }
}