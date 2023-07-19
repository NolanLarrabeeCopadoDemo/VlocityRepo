import { LightningElement, api, wire, track } from 'lwc';
import getItemsFromSObject from '@salesforce/apex/Search2Controller.getItemsFromSObject';
import getStandardSearch from '@salesforce/apex/Search2Controller.getStandardSearch';
//import getItemsFromSObject from '@salesforce/apex/Search2Controller.getItemsFromSObject';


export default class Search2 extends LightningElement {
    //_searchType; comment 1.9: these don't seem to need getter/setter, so moving them to simple API call below
    //_objectName; 

    _value;
    @track _items;
    _selectedItem;
    _isLoading;
    _fieldNamesString; // Only Flow can be passed a list, so we also have a need to split
    _fields;  // Only Flow can be passed a list, so we also need a string to split
    get noMatchFound() {
        if (!this.items) return null;
        return !this.items.some(el => {
            return !el.hidden && !el.externallyFiltered;
        });
    }
    rendered;
    thisIsJustSettingAnInitialPassedInValue;
    _includeCard;
    valueEscrow = {};


    @api masterLabel;
    @api objectName;

    @api fieldNames;
    @api whereClause;
    @api orderByClause;

    @api isMultiSelect; // not used yet. maybe unnecessary with multiSelectType instead
    @api multiSelectType; // not used yet: options = None, Tile List, Table    
    @api stringList;
    @api searchType;

    searchDisabled;

    // StandardSearch variables
    @api standardSearchName;
    //@api validFieldTypes = [];


    // Preferences/settings
    @api ignoreSublabelsInSearch;
    @api noMatchFoundString = 'No matches found';
    @api loadingPlaceholder = 'Loading...';
    @api loadedPlaceholder = 'Type to search';
    @api mustSelectFromValues; // not in use yet
    @api validationErrorMessage = 'Invalid selection. Please select from the provided options.'
    @api iconName;
    placeholder = this.loadingPlaceholder;
    includeCardClass;

    connectedCallback() {
        //console.log('in search2 connectedCallback, standard search = ' + this.standardSearchName + ' - fieldNames = ' + this.fieldNames + ' - objectName = ' + this.objectName);
        this.searchDisabled = true;
        if (!this.items) {
            if (this.standardSearchName) {
                getStandardSearch({ standardSearchName: this.standardSearchName, objectName: this.objectName })
                    .then(result => {
                        //console.log('result: ' + result);
                        this.items = result;
                    })
                    .catch(error => {
                        console.log('error: ' + error.body);
                    });
            } else {
                getItemsFromSObject({ objectName: this.objectName, fieldNames: this.fieldNames, whereClause: this.whereClause, orderByClause: this.orderByClause })
                    .then(result => {
                        //console.log('result: ' + result);
                        this.items = result;
                        //console.log('result: '+ JSON.stringify(result));
                    })
                    .catch(error => {
                        console.log('error: ' + error.body);
                    });
            }
        }
    }

    get inputElement() {
        return this.template.querySelector('lightning-input');
        //return this.template.querySelector('.searchbox');
    }

    loadItems() {

    }

    /*
    @wire(getItemsFromSObject, { objectName: '$objectName', fieldNames: '$fieldNames', whereClause: '$whereClause', orderByClause: '$orderByClause' })
    getSObjectItems({ error, data }) {
        console.log('in getsobjectitems');
        console.log(this.objectName);
        if (data) {
            this.items = data;
        }
        if (error) {
            console.log('Error in getSObjectItems');
            console.log(error);
        }
    }

    @wire(getStandardSearch, { standardSearchName: '$standardSearchName', objName: '$objectName'})
    handleStandardSearch({ error, data }) {
        console.log('calling getStandardSearch, ' + this.standardSearchName);
        console.log('data = ' + data);
        console.log('error = ' + error);
        //console.log('standardSearchName = '+ this.standardSearchName);
        //console.log('objectName = '+ this.objectName);
        if (data) {
            //console.log('found data');
            //console.log('results = '+JSON.stringify(data));
            console.log('standard search results: ' + JSON.stringify(data));
            this.items = data;
        }
        if (error) {
            console.log('Error in handleStandardSearch');
            console.log(error);
        }
    }
    */

    /************************
     *  only FlowScreen supports list, so the other page types will need to supply a comma-separated string which we then split into an array (see meta.xml file) 
     * */
    @api
    get fieldNamesString() {
        return this._fieldNamesString;
    }
    set fieldNamesString(value) {
        //console.log('in set fieldNamesString, value = ' + value);
        this._fieldNamesString = value.replace(/\s+/g, '');
        //console.log('after replacing spaces, this._fieldNamesString = ' + this._fieldNamesString);
        this.fieldNames = this._fieldNamesString.split(',');
        //console.log('after splitting, this.fieldNames = ' + this.fieldNames);
        //console.log('fieldNames is array? ' + Array.isArray(this.fieldNames));
    }

    @api
    get fields() {
        //console.log('in get fields', this._fields);
        return this._fields;
    }
    set fields(value) {
        //console.log('in set fields');
        this._fields = value;
        //console.log('in set fields', this._fields);
    }
    /* end flow support section */

    @api
    get items() {
        return this._items;
    }
    set items(value) {
        //console.log('in set items');
        let items = [];
        for (let i = 0; i < value.length; i++) {
            //for (let i=0; i< 20; i++) {
            let item = { ...value[i] };//Object.assign({}, value[i]);
            item.index = i;
            items.push(item);
        }
        this.selectItemFromPropertyValue(items, null, 'label');
        this._items = items;
        /*
        if (this.value) {   
            console.log('found this.value in set items', this.value);
            this.thisIsJustSettingAnInitialPassedInValue = true;
            this.selectedItem = this.findItemFromValue(this.value);
        }
        */
        if (this.rendered)
            this.isLoading = false;
        console.log('finished setting ' + items.length + ' items')
    }

    @api
    get value() {
        //console.log('in get value', this._value);
        return this._value;
    }
    set value(val) {
        //console.log('in set value, value = '+ val);
        this._value = val;
        //console.log('this.items = '+ JSON.stringify(this.items));
        this.selectItemFromPropertyValue(null, val, 'label');
        /*
        if (this.items && this.items.length > 0) {
            console.log('found this.items in set value');
            this.thisIsJustSettingAnInitialPassedInValue = true;
            this.selectedItem = this.findItemFromValue(val);    
            console.log('after setting value and finding item frmo value, this.selectedItem', JSON.stringify(this.selectedItem));
        }
        */

        //this.prevValue = val;
        //this.findItemFromValue(value);
    }

    @api
    get selectedItem() {
        return this._selectedItem;
    }
    set selectedItem(value) {
        //console.log('in set selectedItem, '+ JSON.stringify(value));
        //console.log('inputElement = '+ this.inputElement.value);
        let prevValue = this._selectedItem;
        //console.log('prevValue = '+ prevValue);
        this._selectedItem = value;
        if ((!prevValue && value) || (prevValue && !value) || (prevValue && value && prevValue.value !== value.value)) {
            //if (this.thisIsJustSettingAnInitialPassedInValue) {
            //console.log('not firing because thisIsJustSettingAnInitialPassedInValue');
            //this.thisIsJustSettingAnInitialPassedInValue = false;
            //} else {
            const selectionEvent = new CustomEvent('selectitem', { detail: value });
            //console.log('selectionEvent.detail', JSON.stringify(selectionEvent.detail));
            this.dispatchEvent(selectionEvent);
            //}
        } else {
            //console.log('selectedItem has not changed');
        }

        if (value && value.label && this.inputElement)
            this.inputElement.value = value.label;

        //console.log('finished set selectedItem');
    }

    get isLoading() {
        return this._isLoading;
    }
    set isLoading(value) {
        //console.log('is loading = '+ value);
        if (!value) {
            this.placeholder = this.loadedPlaceholder;
            this.inputElement.removeAttribute('disabled');
            this.searchDisabled = false;
        } else {
            this.placeholder = this.loadingPlaceholder;
            this.inputElement.setAttribute('disabled', '');
            this.searchDisabled = true;
        }
        this._isLoading = value;
    }

    @api
    get includeCard() {
        return this._includeCard;
    }
    set includeCard(value) {
        //console.log('in includeCard = ' + value);
        this._includeCard = value;
        if (value)
            this.includeCardClass = 'slds-card slds-m-small';
        else
            this.includeCardClass = null;
    }

    renderedCallback() {
        if (!this.rendered) {
            this.isLoading = true;
            this.rendered = true;
        }
    }

    handleItemSelect(event) {
        //console.log('in handleItemSelect');
        //console.log('dataset.value', event.currentTarget.index, event.currentTarget.dataset.index);
        
        //this.selectedItem = this.findItemFromIndex(event.currentTarget.index);
        this.selectedItem = this.items.find(el => {
            return el.index === event.currentTarget.index;
        });
        //console.log('finished handleItemSelect, selectedItem '+ JSON.stringify(this.selectedItem));
        if (false) {
            console.log(event.currentTarget.index);
            let x = selectItemFromPropertyValue(this.items, event.currentTarget.index, 'index');
            console.log('x', x);
            this.selectedItem = selectItemFromPropertyValue(this.items, event.currentTarget.index, 'index');
            console.log('still in handleItemselect, this.selectedItem', this.selectedItem);
        }
    }

    /******************
     * this is kinda a hot mess, sorry
     * ***************/
    selectItemFromPropertyValue(items, value, property) {
        //console.log('in selectItemFromPropertyValue');
        //console.log(!items, value, property);
        //if (this.valueEscrow.isSpent)
        //    return;

        if (items) {
            //console.log('valueEscrow.items to ', items.length);
            this.valueEscrow.items = items;
        }
        if (value) {
            //console.log('valueescrow.value = '+ value);
            this.valueEscrow.value = value;
        }

        if (this.valueEscrow.items && this.valueEscrow.value) {
            //console.log('we have both!', JSON.stringify(value).length, items);
            //this.valueEscrow.isSpent = true;

            //console.log('sifpv: selectedItem currently = '+ JSON.stringify(this.selectedItem));
            let foundItem = this.valueEscrow.items.find(item => {
                return item[property] === this.valueEscrow.value;
            });
            //console.log('sifpv: found ', JSON.stringify(foundItem));
            this.selectedItem = foundItem;

            this.valueEscrow.items = null;
            this.valueEscrow.value = null;
        }
        //console.log('finishing selectItemFromPropertyValue');
    }

    selectItemFromLabel(items, label) {

    }

    findItemFromIndex(value) {
        //console.log('in findItemFromIndex, index = ' + value);
        //console.log('selectedItem currently = ' + JSON.stringify(this.selectedItem));
        let ret = this.items.find(item => {
            return item.index === value;
        });
        console.log('found ', JSON.stringify(ret));
        return ret;
        console.log('selectedItem after = ' + JSON.stringify(this.selectedItem));
    }

    findItemFromValue(value) {
        //console.log('in findItemFromValue, value = ' + value);
        //console.log('selectedItem currently = ' + JSON.stringify(this.selectedItem));
        let ret = this.items.find(item => {
            return item.value === value;
        });
        //console.log('found ', JSON.stringify(ret));
        return ret;
        console.log('selectedItem after = ' + JSON.stringify(this.selectedItem));
    }

    handleBlur(event) {
        //console.log('in handleBlur');
        this.hideList();
        this.validateInput();
    }

    handleFocus(event) {
        //console.log('in handleFocus');
        this.doSearch();
        //console.log('finished handleFocus');
    }

    handleSearchKeyUp(event) {
        //console.log('in handleSearchKeyUp');
        this.handleSearchChange(event);
        /*
        const searchText = event.currentTarget.value;
        //console.log('setting customValidity');
        this.setErrorMessage('');
        this.filterOptions(searchText);
        */
    }

    handleSearchChange(event) {
        //console.log('in handleSearchChange');
        const searchText = event.currentTarget.value;
        //console.log('setting customValidity');
        this.setErrorMessage('');
        this.filterOptions(searchText);
        //console.log('in handleSearchChange');
        //this.handleSearchKeyUp(event);
        //console.log('finished handleSearchChange');
    }

    handleCommit(event) {
        console.log('in handleCommit, event.currentTarget.value = ' + event.currentTarget.value);
    }

    setErrorMessage(msg) {
        //console.log('in setErrorMessage, setting to '+ msg);
        this.inputElement.setCustomValidity(msg);
        this.inputElement.reportValidity();
        //console.log('finished setting error message');
    }


    validateInput() {
        //console.log('in validateInput');
        const value = this.inputElement.value;
        //console.log('value = ' + JSON.stringify(value));
        if (!value) {
            this.selectedItem = null;
            this.setErrorMessage('');
        } else {
            // TODO: before looking for founditem, should first to see if selecteditem.label matches inputElement.value
            //console.log('validating to see if value (' + value + ') returns any found items');
            let foundItem = this.items.find(item => {
                return value.toLowerCase() === item.label.toLowerCase();
            });
            //console.log('foundItem = ' + JSON.stringify(foundItem));
            //console.log('selectedItem = '+ this.selectedItem, 'foundItem = '+ foundItem+', === '+ this.selectedItem===foundItem);
            if (this.selectedItem !== foundItem)
                this.selectedItem = foundItem;
            //console.log('selectedItem = ' + this.selectedItem);
            //console.log('in validate: selectedItem = '+ this.selectedItem);
            this.setErrorMessage(foundItem || !value ? '' : this.validationErrorMessage);
        }
        //console.log('finished validateInput');
    }



    filterOptions(searchText) {
        //console.log('in filterOptions for', searchText + ', searching ' + this.items.length + ' items');
        //this.noMatchFound = true;
        searchText = searchText.toLowerCase();
        for (let item of this.items) {
            item.hidden = true;
            let fields = this.ignoreSublabelsInSearch ? [item.fields[0]] : item.fields;
            for (let field of fields) {
                // no longer need to check about Id field, either it's an invisible field
                if (!field.invisibleField && field.value && String(field.value).toLowerCase().includes(searchText)) {
                    //isMatch = true;
                    item.hidden = false;
                    //this.noMatchFound = false;
                    break;
                }
            }
        }
        //this.items = this.items;
        //console.log('finished filterOptions');
    }

    doSearch(event) {
        //console.log('in doSearch');
        this.filterOptions(this.inputElement.value);
        this.showList();
    }

    showList() {
        //console.log('in showList');
        this.template.querySelector('.slds-dropdown-trigger').classList.add('slds-is-open');
    }

    hideList() {
        //console.log('in showList');
        if (this.template.querySelector('.slds-dropdown-trigger'))
            this.template.querySelector('.slds-dropdown-trigger').classList.remove('slds-is-open');
    }

    /* comment 1.9
    @api 
    get searchType() {
        return this._searchType;
    };
    set searchType(value) {
        this._searchType = value;
    }

    @api
    get objectName() {
        return this._objectName;
    }
    set objectName(value) {
        this._objectName = value;
    }
    */

    /* experiment 9/7 */
    @api
    filterByFieldValue(fieldNames, searchValues) {
        //console.log('in filterByFieldValue');
        //console.log(fieldNames, searchValues);
        if (fieldNames) {
            if (!Array.isArray(fieldNames))
                fieldNames = [fieldNames];
            fieldNames = fieldNames.map(el => { return el.toLowerCase() });
        }
        //console.log('fieldnames again', fieldNames);

        if (!Array.isArray(searchValues))
            searchValues = [searchValues];
        //console.log('searchValues again', searchValues);

        for (let item of this.items) {
            item.externallyFiltered = true;
            let fields = item.fields;
            //if (fieldNames)
            //fields = fields.filter(el => { return fieldNames.includes(el.fieldName.toLowerCase() )});
            for (let field of fields) {
                if (fieldNames.includes(field.fieldName.toLowerCase()) && field.value && searchValues.includes(field.value)) {
                    //isMatch = true;
                    item.externallyFiltered = false;
                    //this.noMatchFound = false;
                    break;
                }
            }
            if (!item.externallyFiltered) {
                //console.log(item.label + ' is unhidden');
            }
        }
        //console.log('reached end of filterByFieldValue');
    }

    @api
    clearFilter() {
        this.items.map(el => { el.externallyFiltered = false });
        /*
        for (let item of this.items) {
            item.externallyFiltered = false;
        } 
        */
    }
}