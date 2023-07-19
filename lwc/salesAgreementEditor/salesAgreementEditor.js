import { LightningElement, track, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { createRecord } from 'lightning/uiRecordApi';
import insertSAProds from '@salesforce/apex/SaagDemoController.insertSAProds';

export default class SalesAgreementEditor extends NavigationMixin(LightningElement) {
    @api recordId;

    @track saProds = [];

    @track salesAgreement;
    errorMessage;
    isProcessing;
    rerenderedTable; // boolean flag used to rerender the table after rows have been added or deleted
    linkToSA;
    showModal;

    @track tableData = [];
    @track periods = this.newPeriods;
    @track newPeriods = [];
    @track sa; // sales agreement
    @track products = []; // sales agreement products (including schedules)
    @track metrics = ['PlannedQuantity', 'ActualQuantity'/*, 'SalesPrice', 'DerivedPlannedAmount'*/];    
    @track selectedProduct;
    get defaultStartDate() {
        let dsd = new Date();
        dsd.setMonth(dsd.getMonth() - 6);
        dsd.setUTCHours(0,0,0,0);
        return dsd.toISOString();
    }
    defaultSAName;// = 'New Sales Agreement';

    objectName;
    fieldNames;
    whereClause;
    startDate;
    pricebookId;

    connectedCallback() {
        //console.log('in connectedcallback for SalesAgreeemntEditor');
        this.fieldNames = ['Name', 'ProductCode', 'ProductFamily', 'UnitPrice'];
        this.phase = 0;
    }

    // We need to wait until after the rows have been added to the DOM before can set the future periods to 'disabled'
    renderedCallback() {
        if (!this.rerenderedTable) {
            this.rerenderedTable = true;
            this.disableFuturePeriods();
        }
    }

    phases = ['Sales Agreement Details', 'Add Products', 'Confirm & Create'];
    //currentPhaseIndex;
    //currentPhaseName = this.phases[this.currentPhaseIndex];

    _phase = {};
    get phase() {
        return this._phase;
    }
    // expecting integer input
    set phase(value) {
        this._phase = {
            currentIndex: value,
            currentName: this.phases[value],
            add: function (inc) {
                this._phase.currentIndex += inc;
            }
        }
        this._phase['is' + value] = true;
        console.log('new phase = ' + JSON.stringify(this._phase));
    }

    popToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            variant: variant,
            message: message
        });
        this.dispatchEvent(event);
    }

    handlePhaseUp(event) {
        this.phase = this.phase.currentIndex + 1;
    }

    handlePhaseDown(event) {
        this.phase = this.phase.currentIndex - 1
    }



    handleValueChange(event) {
        console.log('in handleValueChange');
        let targ = event.currentTarget;
        let newVal = targ.value;
        console.log('targ = ' + targ);
        let row = this.findRow(targ.dataset.productId, targ.dataset.metric);
        // Determine if the changed value is a column 'Total' or a period value
        let isTotal = targ.classList.contains("rowTotal");
        if (!isTotal) {
            // Update the stored value of the changed cell
            row.vals[targ.dataset.columnIndex].value = newVal;
            // Reset the row total to 0 and then re-sum it by looping through all the row values
            let newTotal = 0;
            for (let rowVal of row.vals) {
                newTotal += Number(rowVal.value);
            }
            row.total = newTotal;
        } else {
            row.total = newVal;
            // Count how many 'active' periods are in the row. This includes all Planned values, and any Actual values that are not in the future
            let numActivePeriods = 0;
            for (let rowVal of row.vals) {
                if (rowVal.isFuture && row.metric.toLowerCase().includes('actual'))
                    break;
                numActivePeriods++;
            }
            // Evenly distribute the new total across the column values
            let portion = Math.floor(row.total / numActivePeriods);
            let remainder = row.total - portion * numActivePeriods;
            for (let i = 0; i < numActivePeriods; i++) {
                row.vals[i].value = portion + ((i < remainder) ? 1 : 0);
            }
        }
    }

    // used for search-2
    handleSelectProduct(event) {
        console.log('in handleSelectProduct');
        console.log('val = ' + JSON.stringify(event.detail));
        if (event.detail && event.detail.value) {
            console.log('event.currentTarget.value = '+ event.currentTarget.value);
            event.currentTarget.value = null;
            console.log('event.currentTarget.value = '+ event.currentTarget.value);            
            this.addProduct(event.detail.value, event.detail.label);
        }
    }

    handleDeleteProduct(event) {
        console.log('in handleDeleteProduct');
        this.tableData = this.tableData.filter(el => {
            return el.productId != event.currentTarget.dataset.productId;
        });
    }

    findRow(productId, metric) {
        return this.tableData.find(el => {
            return el.productId === productId && (!metric || el.metric === metric);
        })
    }

    handleModalSave() {
        this.handleSave();
        this.showModal = false;
    }

    handleModalCancel() {
        this.showModal = false;
    }

    openWarningModal() {
        if (!this.tableData || this.tableData.length == 0) {
            this.popToast('No Products Entered', 'Please enter some products to proceed.', 'error');
            return;
        }
        this.showModal = true;
    }

    handleSave() {
        this.isProcessing = true;
        // First, insert the sales agreement
        createRecord({ apiName: 'SalesAgreement', fields: this.salesAgreement }).then(result => {
            // If the sales agreement was successfully created, save the id to pass to the apex method
            console.log('sales agreement agreement successfully saved, id = ' + result.id);
            this.salesAgreement.id = result.id;
            let saProds = [];
            let currentSAProd;
            // loop through every row in the table
            for (let row of this.tableData) {
                // if it's a new product, add the previous product (if any) that has now been fully built out to the list
                if (row.productName) {  // only the first metric row for each product will have productName set
                    // if this wasn't the first product in the table, add the previous one to the list
                    if (currentSAProd) {
                        saProds.push(Object.assign({}, currentSAProd));
                    }
                    // initialize data for the current product
                    currentSAProd = {
                        pricebookEntryId: row.productId,
                        productName: row.productName,
                        schedules: []
                    }
                }
                // loop through each period in the row
                for (let val of row.vals) {
                    let existingSchedule = currentSAProd.schedules.find(el => {
                        return el.startDate === val.startDate;
                    })
                    if (existingSchedule) {
                        existingSchedule.metricValueMap[row.metric] = val.value;
                    } else {
                        let newSchedule = {
                            startDate: val.startDate,
                            endDate: val.endDate,
                            metricValueMap: {}
                        }
                        //newSchedule[row.metric] = val.value;
                        newSchedule.metricValueMap[row.metric] = val.value;
                        currentSAProd.schedules.push(newSchedule);
                    }
                }
            }
            // add the final product to the list
            saProds.push(Object.assign({}, currentSAProd));

            // construct the saverequest to pass to the apex method
            console.log('saId: ' + this.salesAgreement.id);
            let saveRequest = {
                saId: this.salesAgreement.id,
                saProds: saProds,
                pricebookId: this.pricebookId
            }
            console.log('saveRequest = ' + JSON.stringify(saveRequest));
            // call the apex method to create the salesagreementproduct data and the orders
            insertSAProds({ saveRequestString: JSON.stringify(saveRequest) }).then(result => {                
                console.log(result.Id, result.Name); 
                console.log('result = ' + JSON.stringify(result));
                this[NavigationMixin.GenerateUrl]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: result.Id,
                        actionName: 'view',
                    },
                }).then(url => {
                    this.linkToSA = url;
                    console.log('linkToSA = '+ this.linkToSA);
                    this.isProcessing = false;
                    this.phase = this.phase.currentIndex + 1;
                    const event = new ShowToastEvent({
                        title: "Success!",
                        variant: 'success',
                        message: "'{0}' created! See it {1}!",
                        messageData: [
                            result.Name,
                            {
                                url,
                                label: 'here'
                            }
                        ]
                    });
                    this.dispatchEvent(event);
                });
            }).catch(error => {
                this.isProcessing = false;
                this.popToast('Error', 'Something went wrong. Error: ' + error.body.message, 'error');
            });
        }).catch(error => {
            this.isProcessing = false;
            console.log('error = ' + JSON.stringify(error));
            this.popToast('Error', 'There was an error saving the sales agreement. Error: '+ error.body.message, 'error');
            return;
        });
    }

    createPeriods(ogStartDate, numberPeriods, scheduleFrequency) {
        let periods = []; // value to be returned;
        console.log('in createPeriods');
        let periodName;
        let periodIncrement;
        switch (scheduleFrequency) {
            case 'Monthly':
                periodName = 'Month';
                periodIncrement = '1';
                break;
            case 'Quarterly':
                periodName = 'Quarter';
                periodIncrement = '3';
                break;
            case 'Yearly':
                periodName = 'Year';
                periodIncrement = '12';
                break;
        }
        console.log('period name and increment: ' + periodName, periodIncrement)
        // getPeriod and setPeriod represent javascript Date functions based on the periodName set above
        let getPeriod = 'get' + periodName;
        let setPeriod = 'set' + periodName;
        this.newPeriods = [];
        console.log('typeof ogStartDate', typeof ogStartDate);
        console.log('ogStartDate', ogStartDate);
        let ogStartDateFormatted;
        if(ogStartDate.indexOf("T") > -1){
            ogStartDateFormatted = ogStartDate.substring(0, ogStartDate.indexOf("T"));
        } else{
            ogStartDateFormatted = ogStartDate;
        }
        console.log('ogStartDateFormatted', ogStartDateFormatted);
        const datePartsArray = ogStartDateFormatted.split('-');
        ogStartDateFormatted = datePartsArray[1] + '-' + datePartsArray[2] + '-' + datePartsArray[0];
        console.log('ogStartDateFormatted after reorder', ogStartDateFormatted);
        for (let i = 0; i < numberPeriods; i++) {
            if(periodName === 'Month'){
                // get the sales agreement startdate
                const startDate = new Date(ogStartDateFormatted);
                const endYear = startDate.getFullYear();
                const startYear = startDate.getFullYear();
                const m = startDate.getMonth() + (periodIncrement * i);
                let periodStart;
                if(i === 0){
                    periodStart = startDate;
                } else{
                    periodStart = new Date(startYear, m, startDate.getDate());
                }
                const periodEnd = new Date(endYear, m + 1, startDate.getDate() - 1);
                // console.log('periodStart', periodStart);
                // console.log('periodEnd', periodEnd);
                
                const newPeriod = {
                    startDate: periodStart,
                    endDate: periodEnd,
                    name: Number(periodStart.getMonth()) + Number(1) + '/' + periodStart.getFullYear().toString().substr(-2)
                }
                console.log('newPeriod = '+ newPeriod.startDate +' - '+ newPeriod.endDate);
                this.newPeriods.push(newPeriod);
            } else if(periodName === 'Year'){
                // get the sales agreement startdate
                const startDate = new Date(ogStartDateFormatted);
                const startYear = startDate.getFullYear() + i;
                const endYear = startDate.getFullYear() + 1 + i;
    
                const m = startDate.getMonth();
                let periodStart;
                if(i === 0){
                    periodStart = startDate;
                } else{
                    periodStart = new Date(startYear, m, startDate.getDate());
                }
                const periodEnd = new Date(endYear, m, startDate.getDate() - 1);
                // console.log('periodStart', periodStart);
                // console.log('periodEnd', periodEnd);
                
                const newPeriod = {
                    startDate: periodStart,
                    endDate: periodEnd,
                    name: Number(periodStart.getMonth()) + Number(1) + '/' + periodStart.getFullYear().toString().substr(-2)
                }
                console.log('newPeriod = '+ newPeriod.startDate +' - '+ newPeriod.endDate);
                this.newPeriods.push(newPeriod);
            } else if(periodName === 'Quarter'){
                // get the sales agreement startdate
                const startDate = new Date(ogStartDateFormatted);
                const endYear = startDate.getFullYear();
                const startYear = startDate.getFullYear();
                const m = startDate.getMonth() + (periodIncrement * i);
                let periodStart;
                if(i === 0){
                    periodStart = startDate;
                } else{
                    periodStart = new Date(startYear, m, startDate.getDate());
                }
                const periodEnd = new Date(endYear, m + 3, startDate.getDate() - 1);
                // console.log('periodStart', periodStart);
                // console.log('periodEnd', periodEnd);
                
                const newPeriod = {
                    startDate: periodStart,
                    endDate: periodEnd,
                    name: Number(periodStart.getMonth()) + Number(1) + '/' + periodStart.getFullYear().toString().substr(-2)
                }
                console.log('newPeriod = '+ newPeriod.startDate +' - '+ newPeriod.endDate);
                this.newPeriods.push(newPeriod);
            }
        }
    }

    createPeriodsTwo(ogStartDate, numberPeriods, scheduleFrequency) {
        let periods = []; // value to be returned;
        console.log('in createPeriods');
        let periodName;
        let periodIncrement;
        switch (scheduleFrequency) {
            case 'Monthly':
                periodName = 'Month';
                periodIncrement = '1';
                break;
            case 'Quarterly':
                periodName = 'Quarter';
                periodIncrement = '3';
                break;
            case 'Yearly':
                periodName = 'Year';
                periodIncrement = '12';
                break;
        }
        console.log('period name and increment: ' + periodName, periodIncrement)
        // getPeriod and setPeriod represent javascript Date functions based on the periodName set above
        let getPeriod = 'get' + periodName;
        let setPeriod = 'set' + periodName;
        this.newPeriods = [];
        console.log('typeof ogStartDate', typeof ogStartDate);
        console.log('ogStartDate', ogStartDate);
        let ogStartDateFormatted;
        if(ogStartDate.indexOf("T") > -1){
            ogStartDateFormatted = ogStartDate.substring(0, ogStartDate.indexOf("T"));
        } else{
            ogStartDateFormatted = ogStartDate;
        }
        console.log('ogStartDateFormatted', ogStartDateFormatted);
        const datePartsArray = ogStartDateFormatted.split('-');
        ogStartDateFormatted = datePartsArray[1] + '-' + datePartsArray[2] + '-' + datePartsArray[0];
        console.log('ogStartDateFormatted after reorder', ogStartDateFormatted);
        for (let i = 0; i < numberPeriods; i++) {
            if(periodName === 'Month'){
                // get the sales agreement startdate
                const startDate = new Date(ogStartDateFormatted);
                const endYear = startDate.getFullYear();
                const startYear = startDate.getFullYear();
                const m = startDate.getMonth() + (periodIncrement * i);
                let periodStart;
                if(i === 0){
                    periodStart = startDate;
                } else{
                    periodStart = new Date(startYear, m, 1);
                }
                const periodEnd = new Date(endYear, m + 1, 0);
                // console.log('periodStart', periodStart);
                // console.log('periodEnd', periodEnd);
                
                const newPeriod = {
                    startDate: periodStart,
                    endDate: periodEnd,
                    name: Number(periodStart.getMonth()) + Number(1) + '/' + periodStart.getFullYear().toString().substr(-2)
                }
                console.log('newPeriod = '+ newPeriod.startDate +' - '+ newPeriod.endDate);
                this.newPeriods.push(newPeriod);
            } else if(periodName === 'Year'){
                // get the sales agreement startdate
                const startDate = new Date(ogStartDateFormatted);
                const startYear = startDate.getFullYear() + i;
                const endYear = startDate.getFullYear() + 1 + i;
    
                const m = startDate.getMonth();
                let periodStart;
                if(i === 0){
                    periodStart = startDate;
                } else{
                    periodStart = new Date(startYear, m, 1);
                }
                const periodEnd = new Date(endYear, m, 0);
                // console.log('periodStart', periodStart);
                // console.log('periodEnd', periodEnd);
                
                const newPeriod = {
                    startDate: periodStart,
                    endDate: periodEnd,
                    name: Number(periodStart.getMonth()) + Number(1) + '/' + periodStart.getFullYear().toString().substr(-2)
                }
                console.log('newPeriod = '+ newPeriod.startDate +' - '+ newPeriod.endDate);
                this.newPeriods.push(newPeriod);
            } else if(periodName === 'Quarter'){
                // get the sales agreement startdate
                const startDate = new Date(ogStartDateFormatted);
                const endYear = startDate.getFullYear();
                const startYear = startDate.getFullYear();
                const m = startDate.getMonth() + (periodIncrement * i);
                let periodStart;
                if(i === 0){
                    periodStart = startDate;
                } else{
                    periodStart = new Date(startYear, m, 1);
                }
                const periodEnd = new Date(endYear, m + 3, 0);
                // console.log('periodStart', periodStart);
                // console.log('periodEnd', periodEnd);
                
                const newPeriod = {
                    startDate: periodStart,
                    endDate: periodEnd,
                    name: Number(periodStart.getMonth()) + Number(1) + '/' + periodStart.getFullYear().toString().substr(-2)
                }
                console.log('newPeriod = '+ newPeriod.startDate +' - '+ newPeriod.endDate);
                this.newPeriods.push(newPeriod);
            }
        }
    }

    // createPeriodsOld(ogStartDate, numberPeriods, scheduleFrequency) {
    //     let periods = []; // value to be returned;
    //     console.log('in createPeriods');
    //     let periodName;
    //     let periodIncrement;
    //     switch (scheduleFrequency) {
    //         case 'Monthly':
    //             periodName = 'Month';
    //             periodIncrement = '1';
    //             break;
    //         case 'Quarterly':
    //             periodName = 'Month';
    //             periodIncrement = '3';
    //             break;
    //         case 'Yearly':
    //             periodName = 'FullYear';
    //             periodIncrement = '1';
    //             break;
    //     }
    //     console.log('period name and increment: ' + periodName, periodIncrement)
    //     // getPeriod and setPeriod represent javascript Date functions based on the periodName set above
    //     let getPeriod = 'get' + periodName;
    //     let setPeriod = 'set' + periodName;
    //     this.newPeriods = [];
    //     console.log('typeof ogStartDate', typeof ogStartDate);
    //     console.log('ogStartDate', ogStartDate);
    //     let ogStartDateFormatted;
    //     if(ogStartDate.indexOf("T") > -1){
    //         ogStartDateFormatted = ogStartDate.substring(0, ogStartDate.indexOf("T"));
    //     } else{
    //         ogStartDateFormatted = ogStartDate;
    //     }
    //     console.log('ogStartDateFormatted', ogStartDateFormatted);
    //     const datePartsArray = ogStartDateFormatted.split('-');
    //     ogStartDateFormatted = datePartsArray[1] + '-' + datePartsArray[2] + '-' + datePartsArray[0];
    //     console.log('ogStartDateFormatted after reorder', ogStartDateFormatted);
    //     for (let i = 0; i < numberPeriods; i++) {
    //         // get the sales agreement startdate
    //         let startDate = new Date(ogStartDateFormatted);
    //         // const utcDate = startDate.getUTCDate();
    //         // startDate.setDate(utcDate);
    //         console.log('startDate', startDate);
    //         // console.log('startDate UTC', startDate.getUTCDate());
            
    //         // returns the starting date 'number', which can be a month or a year based on the periodName
    //         let startNumber = startDate[getPeriod]();
    //         startDate[setPeriod](startNumber + periodIncrement * i);

    //         let endDate = new Date(startDate);
    //         console.log('endDate', endDate);
    //         let endNumber = endDate[getPeriod]();
    //         console.log('startNumber', startNumber, 'endNumber', endNumber, 'periodIncrement', periodIncrement);
    //         endDate[setPeriod]((Number(endNumber) + Number(periodIncrement)));
    //         let dayOfMonth = endDate.getDate();
    //         endDate.setDate(dayOfMonth - 1); // end 1 day earlier, to allow next period to start on same date
    //         let newPeriod = {
    //             startDate: startDate,
    //             endDate: endDate,
    //             name: Number(startDate.getMonth()) + Number(1) + '/' + startDate.getFullYear().toString().substr(-2)
    //         }
    //         console.log('newPeriod = '+ newPeriod.startDate +' - '+ newPeriod.endDate);
    //         this.newPeriods.push(newPeriod);
    //     }
    //     console.log('newPeriods', this.newPeriods);
    // }

    // add a selected product to the table
    addProduct(prodId, prodName, existingData) {
        console.log('in addProduct ', prodId, prodName, existingData);
        let includeName = true;
        for (let metric of this.metrics) {
            // only display the product name for the first row of each product
            let newRow = {
                productId: prodId,
                productName: includeName ? prodName : '',
                productLink: includeName ? '/' + prodId : '',
                metric: metric,
                vals: [],
                total: 0,
            };
            includeName = false;

            console.log('periods', this.periods);

            // note: we're not using existingData anymore
            if (existingData) {
                for (let sched of existingData) {
                    // If the period doesn't exist in the list yet, add it
                    if (!this.periods.some(el => {
                        return el.startDate === sched.StartDate && el.endDate === sched.EndDate;
                    })) {
                        this.periods.push({
                            name: sched.Name,
                            startDate: sched.StartDate,
                            endDate: sched.EndDate,
                            index: this.periods.length,
                        });
                    }

                    newRow[sched.Name] = sched[metric];
                    newRow.periods.push({
                        id: sched.id,
                        metric: metric,
                        value: sched[metric],
                    });
                    //newRow.vals.push(sched[metric]);
                    newRow.total += sched[metric];
                }
                //console.log('row for ' + productName + '-' + metric + ' = ', JSON.stringify(newRow));
            } else {
                console.log('newRow = ' + newRow);
                let columnIndex = 0;
                for (let period of this.newPeriods) {
                    newRow.vals.push({
                        startDate: period.startDate,
                        endDate: period.endDate,
                        metric: metric,
                        value: 0,
                        columnIndex: columnIndex,
                        isFuture: period.startDate.getTime() > new Date().getTime()
                    })
                    columnIndex++;
                }
            }
            this.tableData.push(newRow);
        }
        this.rerenderedTable = false;
    }

    captureSAFieldsFormData() {
        // clear any error message
        this.errorMessage = null;
        // query all of the input fields
        let inputFields = this.template.querySelectorAll('.saFieldsForm lightning-input-field');
        // map field values to the sales agreement object
        this.salesAgreement = {};
        for (let inputField of inputFields) {
            // all fields are required, so if any are missing value then display an error message and quit the function
            if (!inputField.value) {
                this.errorMessage = 'Missing field value: ' + inputField.fieldName;
                return;
            }
            // add the [fieldName : value] pair to the sales agreement object
            this.salesAgreement[inputField.fieldName] = inputField.value;
        }
        // whereClause is used to filter the available products in the product search component to the ones in the pricebook
        this.whereClause = 'Pricebook2Id = \'' + this.salesAgreement.PricebookId + '\'';
        // create the sales agreement periods based on the start date, schedule count, and schedule frequency
        this.createPeriods(this.salesAgreement.StartDate, this.salesAgreement.ScheduleCount, this.salesAgreement.ScheduleFrequency);
        // advance to the next phase (adding products)
        this.phase = this.phase.currentIndex + 1;
    }

    disableFuturePeriods() {
        console.log('in disableFuturePeriods');
        for (let cell of this.template.querySelectorAll('.scheduleInput')) {
            cell.removeAttribute('disabled');
            if (cell.dataset.isFuture === 'true' && cell.dataset.metric.startsWith('Actual')) {
                cell.setAttribute('disabled', 'disabled');
            }
        }
    }
    
    updatePBId(event) {
        this.pricebookId = event.detail.value[0];
    }

    /* This is a holdover from a previous version where we might be editing an existing SalesAgreement
    Now the tool is only meant to create new ones, so we don't need this
    @wire(getSAData, { recordId: '$recordId' })
    getData({ error, data }) {
        if (data) {
            console.log('In getData');
            this.sa = data.sa;
            for (let prod of data.products) {
                this.products = [...this.products, Object.assign({}, prod)];
            }
            console.log('products', this.products);
            this.periods = [];
            for (let prod of this.products) {
                this.addProduct(prod.ProductId, prod.Product.Name, prod.SalesAgreementProductSchedules);
            }
            console.log('periods = ', JSON.stringify(this.periods));
        } else if (error) {
            console.log('error', error);
        }
    }
    */

    /*
       addProduct(prodId, prodName, existingData) {
           // 10/30/2020 [DID NOT WORK, see note in markup]
           // v2 attempt using products as primary grouping instead of rows
           // TODO: account for existing data
           let newProd = {
               productId: prodId,
               productName: includeName ? prodName : '',
               productLink: includeName ? '/' + prodId : '',
               total: 0,
               schedules: []
           }
           for (let period of this.newPeriods) {
               let newSchedule = {
                   startDate: period.startDate,
                   endDate: period.endDate,
                   isFuture: period.startDate.getTime() > new Date().getTime()
               }
               for (let metric of this.metrics) {
                   newSchedule[metric] = 0;
               }
               newProd.schedules.push(newSchedule);
           }
           this.saProds.push(newProd);
           this.rerenderedTable = false;
           this.selectedProduct = null;        
       }
       */
}