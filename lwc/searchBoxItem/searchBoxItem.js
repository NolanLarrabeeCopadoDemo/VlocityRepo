import { LightningElement, api } from 'lwc';

export default class SearchBoxItem extends LightningElement {
    _hidden;
    _externallyFiltered;
    @api label;
    @api value;
    @api sublabel;
    @api icon;
    @api searchText;
    @api index;
    @api
    get hidden() {
        return this._hidden;
    }
    set hidden(value) {
        //console.log('in item hide '+ this.label);
        this._hidden = value;
        this.hideUnhide(value || this.externallyFiltered);
        //this.hideUnhide(value && !this.externallyFiltered);
        /* trying new 9/7
        let container = this.template.querySelector('.container');

        if (container) {
            this._hidden = value;
            if (value)
                container.classList.add('slds-hide');
            else {
                if (!this.externallyFiltered)
                    container.classList.remove('slds-hide');
            }
        }
        /**/
    }
    @api
    get externallyFiltered() {
        return this._externallyFiltered;
    }
    set externallyFiltered(value) {
        this._externallyFiltered = value;
        this.hideUnhide(value || this.hidden);
        //this.hideUnhide(value && !this.hidden);
    }

    hideUnhide(value) {
        let container = this.template.querySelector('.container');

        if (container) {
            if (value)
                container.classList.add('slds-hide');
            else {
                container.classList.remove('slds-hide');
            }
        }
    }

    /*
    handleItemSelect(event) {
        this.dispatchEvent(new CustomEvent('selectitem', {
            detail: {
                value: this.value,
                index: this.index
            }
        }));
    }
    */
}