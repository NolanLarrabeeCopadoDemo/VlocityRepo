var myData = { 
    constant: {
        version: '3.1',
        versionNumber: '3.00',
        analyticsUrl: '/analytics/wave/wave.apexp',
        dataManagerUrl: '/analytics/wave/wave.apexp#dataManager',
        bulkDataLoadJobUrl: '/lightning/setup/AsyncApiJobStatus/home',
        storageUsageUrl: '/lightning/setup/CompanyResourceDisk/home',
        dataGenApiUrl: 'http://sfdc-wave-data-generator.herokuapp.com/api/v1/datasets'
    },
    test: {
        option: {
            title: {
                display: false
            },
            scales: {
                xAxes: [{
                    stacked: true,
                    categoryPercentage:0.4
                }],
                yAxes: [{
                    stacked: true
                }]
            },
            legend: {
                labels: {
                    boxWidth:20,
                    padding:15
                },
                display: true
            },
            tooltips:{
                mode:'label'
            }
        }
    },
    isEditPage: false,
    apt: false,
    recordAltering: false,
    ap: {
        loading: false,
        startGeneRecords : false,
        windowSize : {
            x: 0,
            y: 0
        },
        simulationRecordTotalCount: 1000,
        activeColorSet:[
            "hsl(0,60%,50%)","hsl(80,60%,50%)","hsl(160,60%,50%)","hsl(240,60%,50%)","hsl(320,60%,50%)","hsl(40,60%,50%)","hsl(120,60%,50%)","hsl(200,60%,50%)","hsl(280,60%,50%)",
            "hsl(0,100%,30%)","hsl(80,100%,30%)","hsl(160,100%,30%)","hsl(240,100%,30%)","hsl(320,100%,30%)","hsl(40,100%,30%)","hsl(120,100%,30%)","hsl(200,100%,30%)","hsl(280,100%,30%)",
            "hsl(0,90%,70%)","hsl(80,90%,70%)","hsl(160,90%,70%)","hsl(240,90%,70%)","hsl(320,90%,70%)","hsl(40,90%,70%)","hsl(120,90%,70%)","hsl(200,90%,70%)","hsl(280,90%,70%)"
        ],
        inactiveColor: '#E0E0E0',
        chartActive : false,
        changedData: false
    },
    step:{
        now: 1,
        steps: [
            {
                id: 1,
                title: 'Field Sets',
                subTitle: '',
                message: 'Invalid or duplicate Label / API Name',
                complete : true,
            },
            {
                id: 2,
                title: 'Records',
                subTitle: '',
                message: 'Invalid record or doesn\'t match format',
                complete : true,
            },
            {
                id: 3,
                title: 'Trends',
                subTitle: '',
                complete : false,
            },
            {
                id: 4,
                title: 'Export',
                subTitle: '',
                complete : false,
            }
        ]
    },
    step4tab : {
        active: '',
        tabs : [{
            id: 'csv',
            label: 'Preview',
            description: 'Preview and Download CSV'
        }, {
            id: 'analytics',
            label: 'Einstein Analytics',
            description: 'For Einstein Analytics and Einstein Discovery'
        }, {
            id: 'salesforce',
            label: 'Salesforce',
            description: 'For Einstein Discovery Write Back'
        }]
    },
    page: {
        alert: {
            show: false,
            message: ''
        },
        confirm: {
            show: false,
            message: 'Are you sure?',
            yesFunc: function(_t){_t.page.confirm.show = false;},
            noFunc: function(_t){_t.page.confirm.show = false;}
        },
        welcome : {
            moving: false,
            position: 0
        },
        step2hint : {
            show: false,
            result: '',
            code: '',
            oid: '',
            did: '',
            fid: ''
        },
        dataGenDialog : {
            show: false,
            step: 1,
            loading: false,
            input: {
                type: null,
                filter: {
                    key: null,
                    value: null
                },
                alias: null,
                count: 10,
                fields: []
            },
            optionsMeta: [],
            sampleRawData: null
        },
        exportToSalesforce : {
            objects : [],
            activeObject: ''
        },
        newProjectFromCsv : {
            show: false,
            step: 1,
            csv: '',
            maxRecords: 100
        },
        newTemplateDialog : {
            show: false,
            id: '',
            form: {
                title: '',
                memo: '',
                industry: '',
                lang: 'en',
                share: false,
                created: ''
            },
            share: {
                option: [{
                    label: "Don't share",
                    value: false
                },{
                    label: 'Share with everyone(Internal)',
                    value: true
                }]
            }
        },
        newProject : {
            show: false,
            id: '',
            form: {
                title: '',
                memo: ''
            }
        },
        newProjectFromTemplate : {
            show: false,
            loading: false,
            select: '',
            list: [],
            listPage: {
                now: 1,
                countPerPage: 24,
                countOption: [
                    {text:'6 per Page', value:6},
                    {text:'12 per Page', value:12},
                    {text:'24 per Page', value:24},
                    {text:'48 per Page', value:48},
                    {text:'96 per Page', value:48}
                ]
            },
            select: {
                id: '',
                data: {}                
            },
            private: false,
            favourite: false,
            sort: {
                by: '',
                option: [
                    {text: 'Likes', value:'likes'},
                    {text: 'Latest', value:'latest'}
                ]
            },
            lang: {
                select:'',
                option:[{
                    label:'English',
                    value:'en_US'
                },{
                    label:'Japanese',
                    value:'ja'
                },{
                    label:'Chinese_Simplified',
                    value:'zh_CN'
                },{
                    label:'Chinese_Traditional',
                    value:'zh_TW'
                },{
                    label:'Danish',
                    value:'da'
                },{
                    label:'Dutch',
                    value:'nl_NL'
                },{
                    label:'Finnish',
                    value:'fi'
                },{
                    label:'French',
                    value:'fr'
                },{
                    label:'German',
                    value:'de'
                },{
                    label:'Italian',
                    value:'it'
                },{
                    label:'Korean',
                    value:'ko'
                },{
                    label:'Norwegian',
                    value:'no'
                },{
                    label:'Portuguese_Brazil',
                    value:'pt_BR'
                },{
                    label:'Russian',
                    value:'ru'
                },{
                    label:'Spanish',
                    value:'es'
                },{
                    label:'Spanish_Mexico',
                    value:'es_MX'
                },{
                    label:'Swedish',
                    value:'sv'
                },{
                    label:'Thai',
                    value:'th'
                }]
            },
            industry: {
                select: [],
                option: [{
                    label:'Auto',
                    value:'at'
                },{
                    label:'Communications',
                    value:'cm'
                },{
                    label:'Education',
                    value:'ed'
                },{
                    label:'Financial Services',
                    value:'fn'
                },{
                    label:'Government',
                    value:'gv'
                },{
                    label:'Healthcare & Life Sciences',
                    value:'hl'
                },{
                    label:'Manufacturing',
                    value:'mn'
                },{
                    label:'Media',
                    value:'md'
                },{
                    label:'Real Estate',
                    value:'re'
                },{
                    label:'Retail',
                    value:'rt'
                },{
                    label:'Travel & Transportation & Hospitality',
                    value:'tr'
                },{
                    label:'Nonprofits',
                    value:'np'
                },{
                    label:'General',
                    value:'ot'
                }]
            }
        },
        openProject: {
            show: false
        },
        newSalesforceCustomObject : {
            show: false,
            form: {
                name: 'sssCustomObjectfff',
                label: 'sss Custom Object',
                plabel: 'sss Custom Object',
                description: 'Created by Insight Designer',
                nameField: {
                    type: 'AutoNumber'
                },
                fields : [{
                    fullName : 'Field1__c',
                    label : 'field 1',
                    type: 'Text',
                    length: '255'
                }],
                deploymentStatus: 'Deployed',
                sharingModel: 'ReadWrite'
            }
        },
        newObject : {
            show: false,
            form : {
                alias: '',
                keyFieldLabel: '',
                keyFieldName: '',
                keyFieldType: '',
                keyFieldFormat: ''
            }  
        },
        newField : {
            show: false,
            form: {
                label: '',
                name: '',
                type: ''
            },
            typeOptions : [{text: 'String'},{text: 'Number'},{text: 'Date'},{text: 'DateTime'}],
            scaleOptions: [
                {text:'Integer', value:0},{text:'.1', value:1},{text:'.02', value:2},{text:'.003', value:3},{text:'.0004', value:4},
                {text:'.00005', value:5},{text:'.000006', value:6},{text:'.0000007', value:7},{text:'.00000008', value:8},{text:'.000000009', value:9},
                {text:'.0000000010', value:10},{text:'.00000000011', value:11},{text:'.000000000012', value:12},{text:'.0000000000013', value:13},{text:'.00000000000014', value:14},
                {text:'.000000000000015', value:15},{text:'.0000000000000016', value:16},{text:'.00000000000000017', value:17}
            ],
            dateOptions: [
                {text:'yyyy-MM-dd'},{text:'yy-MM-dd'},{text:'dd.MM.yyyy'},{text:'dd.MM.yy'},{text:'dd/MM/yyyy'},
                {text:'dd/MM/yy'},{text:'dd/MM/yyyy'},{text:'dd/MM/yy'},{text:'dd-MM-yyyy'},{text:'dd-MM-yy'},
                {text:'MM/dd/yyyy'},{text:'MM/dd/yy'},{text:'MM-dd-yyyy'},{text:'MM-dd-yy'}
            ],
            dateTimeOptions: [
                {text:'yyyy-MM-dd HH:mm:ss'},{text:'yy-MM-dd HH:mm:ss'},{text:'dd.MM.yyyy HH:mm:ss'},{text:'dd.MM.yy HH:mm:ss'},{text:'dd/MM/yyyy HH:mm:ss'},
                {text:'dd/MM/yy HH:mm:ss'},{text:'dd/MM/yyyy hh:mm:ss a'},{text:'dd/MM/yy hh:mm:ss a'},{text:'dd-MM-yyyy HH:mm:ss'},{text:'dd-MM-yy HH:mm:ss'},
                {text:'dd-MM-yyyy hh:mm:ss a'},{text:'dd-MM-yy hh:mm:ss a'},{text:'MM/dd/yyyy hh:mm:ss a'},{text:'MM/dd/yy hh:mm:ss a'},{text:'MM-dd-yyyy hh:mm:ss a'},
                {text:'MM-dd-yy hh:mm:ss a'},{text:'HH:mm:ss dd/MM/yyyy'},{text:'HH:mm:ss dd/MM/yy'},{text:'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''},{text:'yy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''},
                {text:'yyyy-MM-dd\'T\'HH:mm:ss\'Z\''},{text:'yy-MM-dd\'T\'HH:mm:ss\'Z\''}
            ],
            functionOptions: [
                {text:'Sum'}
            ]
        },
        record: {
            typeOptions:{
                'String': [
                    {text: 'Static value', value: 'static'},
                    {text: 'Function (Javascript)', value: 'function'},
                    {text: 'Null value', value: 'null'}
                ],
                'Number': [
                    {text: 'Static value', value: 'static'},
                    {text: 'Random', value: 'rangeNumber'},
                    {text: 'Function (Javascript)', value: 'function'},
                    {text: 'Null value', value: 'null'}
                ],
                'Date': [
                    {text: 'Static value', value: 'static'},
                    {text: 'Random Date (relative)', value: 'rangeRelativeDate'},
                    {text: 'Random Date', value: 'rangeDate'},
                    {text: 'Function (Javascript)', value: 'function'},
                    {text: 'Null value', value: 'null'}
                ],
                'DateTime': [
                    {text: 'Static value', value: 'static'},
                    {text: 'Random Date(relative) / Time ', value: 'rangeRelativeDateAndTime'},
                    {text: 'Random Date / Time', value: 'rangeDateAndTime'},
                    {text: 'Random Datetime', value: 'rangeDatetime'},
                    {text: 'Function (Javascript)', value: 'function'},
                    {text: 'Null value', value: 'null'}
                ]
            },
            icons: {
                static: 'text_format',
                'function': 'mdi-function',
                rangeNumber: 'mdi-numeric',
                rangeDate: 'date_range',
                rangeRelativeDate: 'date_range',
                rangeDatetime: 'access_time',
                rangeDateAndTime: 'access_time',
                rangeRelativeDateAndTime: 'access_time',
                'null': 'mdi-border-none-variant'
            },
            dateRangeOptions: [
                {text: 'weeks ago - WEEK', value: 'wa'},
                {text: 'weeks later - WEEK', value: 'wl'},    
                {text: 'This week - WEEK', value: 'wt'},
                {text: 'months ago - MONTH', value: 'ma'},
                {text: 'months later - MONTH', value: 'ml'},                
                {text: 'This month - MONTH', value: 'mt'},
                {text: 'years ago - YEAR', value: 'ya'},
                {text: 'years later - YEAR', value: 'yl'},
                {text: 'This year - YEAR', value: 'yt'},
                {text: 'days ago - DAY', value: 'da'},
                {text: 'days later - DAY', value: 'dl'},    
                {text: 'Today - DAY', value: 'dt'}
            ]
        },
        lensDialog : {
            show: false,
            sliderMax: 1200,
            sliders: [],
            lastChangedIndex: 0,
            chartType: 0,
            ruleId: '',
            allRules : [],
            ruleCount: {}
        },
        objectItemSelect : {
            show: false
        },
        adjustSliders : {
            show: false
        },
        snackbar : {
            show: false,
            x : null,
            y: 'bottom',
            mode: '',
            timeout: 3000,
            color: 'success',
            text: 'Hey!'
        },
        currentProject : {
            templateId: '',
            id: '',
            title: '',
            memo: ''
        },
        importCsvDialog: {
            show: false,
            objectAlias: '',
            filePath: '',
            fileData: {},
            fields: {}
        },
        exportToAnalyticsDialog : {
            show: false,
            loading: false
        },
        exportToAnalyticsTab: {
            operations: [
                {text: 'Append', value: 'Append'}, {text: 'Overwrite', value: 'Overwrite'}
            ]
        },
        objectFilterItems: {
            data: {}
        },
        error : {
            show: false,
            message: ''
        }
    },
    chart : {
        label: [],
        data: [],
        dataset : []
    },
    lens : {
        group : {
            object: '',
            field: ''
        },
        filter: {},
        data: {
            rule: {},
            data: {}
        },
    },
    sys : {
        hashStrong: 10000000000
    },
    objectTab : {
        active : '',
        editMode: false
    },
    ea: {
        dataset: {
            label: '',
            name: '',
            fields: {
                
                
                
            }
        }
    },
    validation: {},
    duplication: {},
    meta : {},
    rule: {},
    records: [],
    mrecords : [],
    force : {},
    template : {},
    apexCallout : {},
    exportToDataset : {},
    exportToSalesforce: {},
    settings: {
        exportToAnalytics: {
            maxRows: 1000000,
            rowsPerTime: 10000
        },
        modal: {
            headerClass: 'title blue-grey white--text py-2'
        }
    }
};

var myMethods = {
    
    dummy: function(){},
    openAsNewWindow: function(){
        window.open('/apex/DemoADM__app', '_blank');  
    }, 
    isFunctionString: function(obj){
        if (obj.type == 'static'){
            var val = obj.value;
            if (val && val.length > 3){
                return /^\s*\{\{(.+)\}\}\s*$/.test(val);            
            }
        } else if (obj.type == 'function'){
            return true;
        }
        return false;
    },
    clickedOpenFunctionExplorer: function(code, oid, did, fid){
        this.page.step2hint.code = code && code.length > 0 ? code: '';
        this.page.step2hint.show = true; 
        this.page.step2hint.result = ''; 
        this.page.step2hint.oid = oid;
        this.page.step2hint.did = did;
        this.page.step2hint.fid = fid;
        this.clickedFunctionExplorerExecute();
    },
    setCodeToFunctionFinder: function(code){
        if(this.page.step2hint.code && this.page.step2hint.code.length > 0){
            this.page.step2hint.code += ' + ' + code;
        } else {
            this.page.step2hint.code = code;
        }
        this.clickedFunctionExplorerExecute();
    },
    clickedBringCodeToRecord: function(){
        var obj = this.page.step2hint;
        this.meta[obj.oid].data[obj.did][obj.fid].code =  obj.code;
        this.page.step2hint.show = false;
    },
    clickedFunctionExplorerExecute: function(){
        this.$set(this.page.step2hint, 'result', '---');
        var code = this.page.step2hint.code;
        var _t = this;
        if (code && code.length > 0){
            var conv = code.replace(/val\s*\(\s*\'\s*([a-zA-Z0-9_]+)\s*\'\s*\)/g, function(dmy, apiName){                                    
                var thisFid = _t.allFieldsIdByName[apiName];
                if (thisFid && thisFid.length > 0){
                    var ooid = Object.keys(_t.meta).find(function(oid){
                        return Object.keys(_t.meta[oid].fields).some(function(fid){
                            return (fid == thisFid);
                        });                    
                    });
                    if (ooid){
                        var dkeys = Object.keys(_t.meta[ooid].data);
                        var did = rand(0, (dkeys.length - 1));
                        var rtv = _t._normalizeFieldValue(_t.meta[ooid].data[dkeys[did]][thisFid], thisFid);
                        var typ = _t.allFieldsById[thisFid].type;
                        if (typ != 'Number') rtv = "'" + rtv + "'";
                        return rtv;
                    }
                }
                return null;
            }).replace(/row\s*\(\s*\)/g, function(){ return 1; });
            
            var result = this._normalizeFieldValue(
                {type:'static', value: '{{' + conv + '}}'}, this.page.step2hint.fid);
            this.$set(this.page.step2hint, 'result', result);
        }
    },
    doConfirm: function(yes){
        this.page.confirm.show = false;
        this.page.confirm.message = '';
        var yesFunc = this.page.yesFunc;
        var noFunc = this.page.noFunc;
        var _t = this;
        if (yes){
            if (yesFunc) yesFunc(_t);
        } else {
            if (noFunc) noFunc(_t);
        }
    },
    confirm : function(mes, yesFunc, noFunc){
        this.page.confirm.message = mes ? mes: 'Are you sure?';
        this.page.yesFunc = yesFunc ? yesFunc: function(_t){};
        this.page.noFunc = noFunc ? noFunc: function(_t){};
        this.page.confirm.show = true;
    },
    alert : function(mes){
        this.page.alert.message = mes;
        this.page.alert.show = true;
    }, 
    clickedNewSalesforceObject : function(){
        this.page.newSalesforceCustomObject.show = true;
        this.exportToSalesforce.totalCount = 0;
        var fields = [];
        var flds = this.allFields;
        for (var i=0; i<flds.length; i++){
            var fld = flds[i];
            var type = fld.type;
            var field = {
                fullName: fld.name + '__c',
                label: fld.label,
                active:true
            };
            var active = true;
            if (type == 'String'){
                field.length = '255';
                field.type = 'Text';
            } else if (type == 'Number'){
                field.scale = String(fld.format);
                field.precision = '18';
                field.type = 'Number';
            } else if (type == 'Date'){
                field.type = 'Date';
            } else if (type == 'DateTime'){
                field.type = 'DateTime';
            } else {
                active = false;
            }
            if (active) fields.push(field);
        }
        this.page.newSalesforceCustomObject.form.name = 'Custom_' + this.getId().substr(0, 5);
        this.page.newSalesforceCustomObject.form.label = this.page.currentProject.title;
        this.page.newSalesforceCustomObject.form.plabel = this.page.currentProject.title;
        
        this.$set(this.page.newSalesforceCustomObject.form, 'fields', fields);
    },
    clickedCreateSalesforceObject : function(){
        var _t = this;
        this.apt = true;
        this._createMetadataApi('CustomObject', [{
            fullName: this.page.newSalesforceCustomObject.form.name + '__c',
            label: this.page.newSalesforceCustomObject.form.label,
            description: this.page.newSalesforceCustomObject.form.description,
            pluralLabel: this.page.newSalesforceCustomObject.form.plabel,
            nameField: {
                type: this.page.newSalesforceCustomObject.form.nameField.type,
                label: this.page.newSalesforceCustomObject.form.label + ' Name'   
            },
            fields: this.fieldsForMetadataApi,
            deploymentStatus: this.page.newSalesforceCustomObject.form.deploymentStatus,
            sharingModel: this.page.newSalesforceCustomObject.form.sharingModel
        }], function(err, res) {
            _t.page.newSalesforceCustomObject.show = false;
            if (!err){
                var er = '';
                for (var i=0;i<res.length;i++){
                    if (res[i].success == false){
                        er += '[' + res[i].errors.statusCode + '] ';
                        er += res[i].errors.message + '  ';
                    }
                }
                if (er) {
                    _t._showError('<< API Error >> ' + er);
                    _t.apt = false;
                } else {
                    _t._deployToSalesforceSharingAccess();
                }
            }
        });
    },
    _deployToSalesforceSharingAccess : function(){
        var _t = this;
        var fldps = [];
        var co = this.page.newSalesforceCustomObject.form;
        var cfs = this.fieldsForMetadataApi;
        for (var i=0; i<cfs.length; i++){
            fldps.push({
                field : co.name + '__c.' + cfs[i].fullName,
                editable : true,
                readable : true,
                hidden : false
            });
        }
        this._upsertMetadataApi('Profile', [{
            fullName : 'Admin',
            fieldPermissions: fldps            
        }], function(err, ress) {
            if (!err){
                if (ress.success){
                    _t._deployToSalesforceListView();
                } else {
                    _t.alert('ERROR creating Profile. Detail: ' + JSON.stringify(ress));
                    _t.apt = false;
                }
            }
        });
    },
    _deployToSalesforceListView : function(){
        var _t = this;
        this._createMetadataApi('ListView', [{
            fullName: _t.page.newSalesforceCustomObject.form.name + '__c.All_created_by_InsightDesigner',
            columns : _t.fieldsForListView,
            label : 'All (created by Insight Designer)',
            filterScope : 'Everything'
        }], function(err, res){
            if (!err){
                if (res.success){
                    window.setTimeout(function(){
                        _t._doWorkAfterCreateCustomObject();
                    }, 700);
                } else {
                    _t.alert('ERROR creating ListView. Detail: ' + JSON.stringify(res));
                    _t.apt = false;
                }
            }
        });
    },
    _doWorkAfterCreateCustomObject : function(){
        var _t = this;
        this.showToast('success', 'Custom Object "' + _t.page.newSalesforceCustomObject.form.label + '" was successfly created.');
        this._getAllSalesforceObjects(function(res){
            var objs = res.data.objects;
            for (var k1 in objs){
                if (objs.hasOwnProperty(k1)){
                    if (~k1.indexOf(_t.page.newSalesforceCustomObject.form.name)){
                        _t.page.exportToSalesforce.activeObject = objs[k1].apiName;
                        _t._changeSalesforceObject(objs[k1].apiName);
                        break;
                    }
                    
                }
            }
            _t.apt = false;
        });  
    },
    _doDescribeMetadataApi: function(){
        
    },
    _getAllMetadataApi: function(types, opts, func){
        var _t = this;
        jsforceConn.metadata.list(types, ID_API_VERSION, function(err, res){
            if (err) { 
                _t._showError('<< API Error >> ' + err);
                _t.apt = false;
            } 
            if (func) func(err, res);
        });
    },
    _upsertMetadataApi: function(target, opts, func){
        var _t = this;
        jsforceConn.metadata.upsert(target, opts, function(err, res){
            if (err) { 
                _t._showError('<< API Error >> ' + err);
                _t.apt = false;
            } 
            if (func) func(err, res);
        });
    },
    _updateMetadataApi: function(target, opts, func){
        var _t = this;
        jsforceConn.metadata.update(target, opts, function(err, res){
            if (err) { 
                _t._showError('<< API Error >> ' + err);
                _t.apt = false;
            } 
            if (func) func(err, res);
        });
    },
    _createMetadataApi: function(target, opts, func){
        var _t = this;
        jsforceConn.metadata.create(target, opts, function(err, res){
            if (err) { 
                _t._showError('<< API Error >> ' + err);
                _t.apt = false;
            } 
            if (func) func(err, res);
        });
    },
    
    clickedChangeSalesforceObject : function(){
        var target = this.page.exportToSalesforce.activeObject;
        if (this.isValidSfdcActiveObject && this.sfdc1selectedFieldIds && this.sfdc1selectedFieldIds.length > 0){
            this.confirm('All the mappings for Object "' + this.rule.master.salesforce.object.label + '" will be lost. Are you OK?', function(_t){
                _t._changeSalesforceObject(target);
            });            
        } else {
            this._changeSalesforceObject(target);
        }        
    },
    _changeSalesforceObject : function(target){
        var _t = this;   
        forceGet(
            _t, 'ui-api/object-info/' + target, function(res){
                var oinfo = res.data;
                var thisLabel = oinfo.label;
                if (oinfo.createable && oinfo.deletable){
                    // Reset Mappings
                    _t.$set(_t.rule.master.salesforce, 'mappings', {});
                    _t.$set(_t.rule.master.salesforce, 'object', {
                        name: target, label: oinfo.label
                    });
                    var oflds = oinfo.fields;
                    var ret = [];
                    for (var k1 in oflds){
                        if (oflds.hasOwnProperty(k1)){
                            var dtl = oflds[k1];
                            if (dtl.createable){
                                ret.push(dtl);
                                // Create Mappings
                                _t.$set(_t.rule.master.salesforce.mappings, dtl.apiName, _t._pickProperFieldForSalesforceObject(dtl.apiName));
                            }
                        }
                    }
                    _t.$set(_t.rule.master.salesforce, 'fields', ret);
                } else {
                    _t.page.exportToSalesforce.activeObject = _t.rule.master.salesforce.object.name;
                    _t.alert('Object "' + thisLabel + '" can not be modified.');
                }
            }
        );
    },
    _pickProperFieldForSalesforceObject : function(sfdcFieldApiName){
        var opts = this.sfdc1option;
        var ret = '';
        for (var i=0; i<opts.length; i++){
            var opt = opts[i];
            if (~sfdcFieldApiName.indexOf(opt.value + '__c')){
                ret = opt.id;
                break;
            }
        }
        return ret;
    },
    _getAllSalesforceObjects : function(func){
        var _t = this;
        forceGet(
            _t, 'ui-api/object-info/', function(res){
                if (func) func(res);
                var obj = res.data.objects;
                var items = [];
                for(var key in obj){
                    if (obj.hasOwnProperty(key)){
                        if (obj[key].apiName.indexOf('InsightDesignerProject__c') == -1
                            && obj[key].apiName.indexOf('__x') == -1){
                            items.push({
                                text: obj[key].label,
                                value: obj[key].apiName
                            });
                        }
                    }
                }
                items.sort(function(a,b){
                    return a.text.localeCompare(b.text);
                });                
                _t.page.exportToSalesforce.objects = items;   
            }, function(err){
                
            }
        );  
    },
    handleScroll : function(e){
        if (this.isEditPage == false && this.page.newProjectFromTemplate.show == false){
            if (this.page.welcome.position == 0){
                if (e.deltaY > 60) this.page.welcome.position = 1;
            }
        }
    },
    handlePopState : function(e){
        history.pushState(null, null, null);
    },
    handleKeyDown : function(e){
        if (this.isEditPage){
            if (this.step.now == 1 || this.step.now == 2){
                if (e.key == 'e' && (e.metaKey || e.ctrlKey)){
                    this.objectTab.editMode = !this.objectTab.editMode;    
                }    
            }
            if (e.key == 'F1' && this.stepEditable[1]) this.step.now = 1;
            if (e.key == 'F2' && this.stepEditable[2]) this.step.now = 2;
            if (e.key == 'F3' && this.stepEditable[3]) this.step.now = 3;
            if (e.key == 'F4' && this.stepEditable[4]) this.step.now = 4;
        }
        
    },
    changedKeyField: function(oid, fid){
        this.meta[oid].keyField = fid;
    },
    _showError: function(mes){
        this.page.error.message = mes;
        this.page.error.show = true;  
    },
    changedObjectFilterItems : function(e){
        this.changedTryFilterItem(this.lens.group.object);
    },
    clickedDeleteTemplate: function(tid, title){
        this.confirm('Are you sure you want to delete Template "' + title + '" ?', function(_t){
            _t.doApexCallout('deleteTemplate', [
                tid
            ], function(e, res){
                _t.page.newTemplateDialog.show = false;
                _t._updateAllTemplateList();
                _t.showToast('success', 'Template "' + title + '" was deleted.');
            });
        });
    },
    clickedSaveAsTemplate: function(){
        this.$set(this.page.newTemplateDialog, 'form', {
            title: this.page.currentProject.title,
            memo: this.page.currentProject.memo || '',
            industry: '',
            lang: this.page.newProjectFromTemplate.lang.select,
            share: false,
            created: '',
            version: this.constant.versionNumber
        });
        this.page.newTemplateDialog.show = true;  
    },
    saveNewTemplate: function(){
        var _t = this;
        this.doApexCallout('newTemplate', [
            this.page.currentProject.id,
            JSON.stringify(this.page.newTemplateDialog.form)
        ], function(e, res){
            _t.showToast('success', 'Template "' + _t.page.newTemplateDialog.form.title + '" was published.');
            _t.page.newTemplateDialog.show = false;
        });
    },
    selectTemplate: function(tid){
        if (this.page.newProjectFromTemplate.select == tid){
            this.page.newProjectFromTemplate.select = '';
        } else {
            this.page.newProjectFromTemplate.select = tid;    
        }
    },
    star : function(tid){
        var items = this.page.newProjectFromTemplate.list;
        for (var i=0; i<items.length; i++){
            var item = items[i];
            if (item.id == tid){
                this.page.newProjectFromTemplate.list[i].stared = true;
                this.page.newProjectFromTemplate.list[i].star ++;
                break;
            }
        }
        this._star(tid, true);
    },
    unstar : function(tid){
        var items = this.page.newProjectFromTemplate.list;
        for (var i=0; i<items.length; i++){
            var item = items[i];
            if (item.id == tid){
                this.page.newProjectFromTemplate.list[i].stared = false;
                this.page.newProjectFromTemplate.list[i].star --;
                break;
            }
        }
        this._star(tid, false);
    },
    _star : function(tid, star){
        this.doApexCallout('star', [tid, star]);
    },
    clickedDoneEditRecord: function(){
        this._doUpdateDiff_3_0();
      	this.objectTab.editMode = false;  
    },
    clickedOpenNewProject : function(){
        this.$set(this.page, 'newProject', {
            show: true,
            id: null,
            form: {
                title: '',
                memo: ''
            }
        }); 
    },
    clickedOpenNewProjectFromTemplate : function(){
        this.page.newProjectFromTemplate.list = [];
        this._updateAllTemplateList();
        this.page.newProjectFromTemplate.show = true;
        this.page.welcome.position = 1;
    },
    clickedOpenNewProjectFromCsv : function(){
        this.page.newProjectFromCsv.show = true;
        this.page.newProjectFromCsv.step = 1;
        this.page.newProjectFromCsv.maxRecords = 100;        
    },
    uploadedCsvFileForNewProject: function(e){
        var _t = this;
        var files = e.target.files;
        if(files[0] !== undefined) {
            this.imageName = files[0].name;
            var fr = new FileReader();
            fr.onload = function(){
                var csvt = decodeURIComponent(escape(atob(fr.result.split(/,/)[1]))).replace(/(\r\n|\r|\n)+$/, '');
                var csvd = Papa.parse(csvt, { header: false });
                _t.$set(_t.page.newProjectFromCsv, 'fileData', csvd);
                var headers = csvd.data[0];
                var nms = _t._newFieldNameLabel(headers.length);
                var flds = [];
                for (var i=0; i<headers.length; i++){
                    flds.push({
                        label: headers[i],
                        name: nms[i],
                        type: 'String',
                        format: '',
                        active: true
                    });
                }
                _t.$set(_t.page.newProjectFromCsv, 'fields', flds);
                _t.page.newProjectFromCsv.step = 2;
            };
            fr.readAsDataURL(files[0]);            
        }
    },
    clickedImportCsvToProject: function(){
        
        //Start Loading
        this.page.openProject.show = true;
        this.step.now = 1;
        this.page.currentProject.id = null;
        this.page.currentProject.tempalteId = null;
        this.page.currentProject.title = '';
        this.page.currentProject.memo = '';        
        this.$delete(this.apexCallout, 'getConfig');
        this._initMeta();
        
        var fields = [];
        var records = [];
        var tids = [];
        this.page.newProjectFromCsv.fields.forEach(function(item, idx){
            if (item.active){
                tids.push(idx);
                fields.push(item);
            }
        });
        this.page.newProjectFromCsv.fileData.data.forEach(function(row, rowId){
            if (rowId > 0){
                var record = [];
                tids.forEach(function(idx){
                    record.push(row[idx]);
                });
                if (true || record.every(function(item){return item != null && item.length > 0;})){
                    records.push(record);
                }
            }
        });
        
        // Calc groups
        var ret = this._calcGroupForCSV(fields, records);
        var group = ret[0];
        var groupUq = ret[1];
        for (var i=0; i<groupUq.length; i++){
            var gid = groupUq[i];
            var idxs = [];
            var fieldIds = [];
            for(var k=0; k<group.length; k++){
                var val = group[k];
                if (gid === val){
                    idxs.push(k);
                }
            }
            var fld = fields[idxs[0]];
            var rt = this.saveNewObject(fld.label, fld.label, fld.name, fld.type, fld.format);
            var oid = rt[0];
            if (i == 0){
                this.objectTab.active = oid;
            }
            fieldIds.push(rt[1]);
            for (var k=0; k<idxs.length; k++){
                if (k > 0){
                    var fld2 = fields[idxs[k]];
                    var fid = this.saveNewField(oid, fld2.label, fld2.name, fld2.type, fld2.format);
                    fieldIds.push(fid);
                }
            }
            var record = {};
            var total = records.length;
            var count = 0;
            for (var r=0; r<records.length; r++){
                var key = records[r][idxs[0]];
                if (!record.hasOwnProperty(key)){
                    if (count < Number(this.page.newProjectFromCsv.maxRecords)){
                        count++;
                        record[key] = {
                            count: 1,
                            data: {}
                        }; 
                        for (var s=0; s<idxs.length; s++){
                            record[key].data[fieldIds[s]] = records[r][idxs[s]];
                        }
                    }
                } else {
                    record[key].count = record[key].count + 1;
                }
                
            }
            var rules = {};
            for (var k1 in record){
                if (record.hasOwnProperty(k1)){
                    var dat = record[k1].data;
                    var rid = this._newRecord(oid, dat);
                    rules[rid] = {probability: (record[k1].count / total)};
                }                
            }
            this.$set(this.rule.simple, oid, {rules:rules});
        }
        
        
        var _t = this;
        window.setTimeout(function(){
            _t.ap.changedData = false;
            _t.isEditPage = true;
            _t.page.openProject.show = false;
            _t.page.newProjectFromCsv.show = false;
            _t._checkRecordData();
        }, 400);
        
        
        
    },
    _calcGroupForCSV: function(fields, records){
        var group = [];
        for (i=0; i<fields.length; i++){
            group.push(i);
        }
        for (i=0; i<fields.length; i++){
            if (group[i] == i){
                for (k=0; k<(fields.length - i - 1); k++){
                    var check = 0;
                    var compare = {};
                    var a = k;
                    var b = k + i + 1;
                    for (var r=0; r<records.length; r++){
                        var va = records[r][a];
                        var vb = records[r][b];
                        if (compare.hasOwnProperty(va)){
                            if (compare[va] == vb){
                                check++;
                            } else {
                                check = 0;
                                break;
                            }
                        } else {
                            compare[va] = vb;
                        }
                    }
                    if (check > 0){
                        group[b] = group[a];			
                    }
                }
            }
        }
        var groupUq = group.filter((x, i, self) => self.indexOf(x) === i);
        return [group, groupUq];
    },        
    _updateAllTemplateList: function(ch){
        this.page.newProjectFromTemplate.loading = true;
        var cdo = {
            lang: this.page.newProjectFromTemplate.lang.select,
            mine: this.page.newProjectFromTemplate.private,
            favourite: this.page.newProjectFromTemplate.favourite,
            industry: this.page.newProjectFromTemplate.industry.select,
            version: this.constant.versionNumber
        };
        if (ch){
            for (var k1 in ch){
                if (ch.hasOwnProperty(k1)){
                    cdo[k1] = ch[k1];
                }
            }
        }
        var _t = this;
        if (!(cdo.industry.length > 0)){
            cdo.industry = Object.keys(this.industryImg);
        }
        this.doApexCallout('getAllTemplate', [JSON.stringify(cdo)], function(e, res){
            var ret = [];
            var list = JSON.parse(res);
            if (list && list.length > 0){
                ret = list;
            }
            _t.page.newProjectFromTemplate.listPage.now = 1;
            _t.page.newProjectFromTemplate.list = ret;
            _t.page.newProjectFromTemplate.loading = false;
        });
    },
    clickedOpenEditProject : function(id, title, memo){
        this.$set(this.page, 'newProject', {
            show: true,
            id: id,
            form: {
                title: title,
                memo: memo
            }
        });
    },
    typeChanged : function(a, b, c, d){
        var val = a == 'String' ? '':
        a == 'Number' ? this.page.newField.scaleOptions[0].value: 
        a == 'Date' ? this.page.newField.dateOptions[0].text: 
        a == 'DateTime' ? this.page.newField.dateTimeOptions[0].text:
        a == 'Function' ? this.page.newField.functionOptions[0].text:
        '';
        if (b == 'newObject'){
            this.page.newObject.form.keyFieldFormat = val;
        } else if (b == 'csvImport'){
            this.page.importCsvDialog.fields[c].format = val;
        } else if (b == 'newProjectFromCsv'){
            this.page.newProjectFromCsv.fields[c].format = val;
        } else if (b == 'dataGenDialog'){
            this.page.dataGenDialog.input.fields[c].format = val;
        } else if (b == 'standard'){
            this.$set(this.meta[c].fields[d], 'format', val);
        }        
    },
    recordTypeChanged: function(recordType, oid, did, fid){
        var obj = {type: recordType};
        if (recordType == 'static'){
            obj.value = '';
        } else if (recordType == 'rangeNumber'){
            obj.from = 10000;
            obj.to = 100000;
            obj.step = 1000;
        } else if (recordType == 'rangeRelativeDate'){
            obj.range = 'ma';
            obj.diff = 1;
        } else if (recordType == 'rangeDate'){
            obj.fromTo = [moment().toDate(), moment().add(1, 'months').toDate()];
        } else if (recordType == 'function'){
            obj.code = '';
        } else if (recordType == 'rangeRelativeDateAndTime'){
            obj.range = 'ma';
            obj.diff = 1;
            obj.fromToTime = [moment().set({'hour': 10, 'minute': 0, 'second': 0}).toDate(), moment().set({'hour': 18, 'minute': 59, 'second': 59}).toDate()];
        } else if (recordType == 'rangeDateAndTime'){
            obj.fromToDate = [moment().toDate(), moment().add(1, 'months').toDate()];
            obj.fromToTime = [moment().set({'hour': 10, 'minute': 0, 'second': 0}).toDate(), moment().set({'hour': 18, 'minute': 59, 'second': 59}).toDate()];
        } else if (recordType == 'rangeDatetime'){
            obj.fromToDateTime = [moment().set({'hour': 10, 'minute': 0, 'second': 0}).toDate(), moment().add(1, 'months').set({'hour': 18, 'minute': 59, 'second': 59}).toDate()];
        }
        this.$set(this.meta[oid].data[did], fid, obj);
    },
    _checkAndCorrectDataByFieldType: function(){
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var dats = this.meta[k1].data;
                for (var k2 in dats){
                    if (dats.hasOwnProperty(k2)){
                        var flds = dats[k2];
                        for (var k3 in flds){
                            if (flds.hasOwnProperty(k3)){
                                var val = flds[k3];
                                var field = this.allFieldsById[k3];
                                var fieldType = field.type;
                                var valType = val.type;
                                var targetTypes = this.page.record.typeOptions[fieldType];
                                var isValid = targetTypes.some(obj => obj.value === valType);
                                if (!isValid){
                                    this.$set(this.meta[k1].data[k2], k3, {
                                        type: 'static', value: ''
                                    })
                                }
                            }
                        }
                    }
                }
            }
        } 
    },
    checkDuplication: function(){
        var tmp = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var flds = this.meta[k1].fields;
                for (var k2 in flds){
                    if (flds.hasOwnProperty(k2)){
                        var api = flds[k2].name;
                        if (tmp.hasOwnProperty(api)){
                            tmp[api] ++;
                        } else {
                            tmp[api] = 1;
                        }
                    }
                }
            }
        }
        this.$set(this, 'duplication', {});
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var flds = this.meta[k1].fields;
                var obj = [];
                for (var k2 in flds){
                    if (flds.hasOwnProperty(k2)){
                        var api = flds[k2].name;
                        if (tmp[api] && tmp[api] > 1){
                            obj.push(k2);  
                        }                    
                    }
                }
                if (obj.length > 0){
                    this.$set(this.duplication, k1, obj);
                }
            }
        }
    },
    checkValidation: function(){
        var ret = {fields: {}, data: {}};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var fields = {};
                var flds = this.meta[k1].fields;
                for (var k2 in flds){
                    if (flds.hasOwnProperty(k2)){
                        var obj = {};
                        if (!this.isValidName(flds[k2].name)) obj['name'] = 'invalid';
                        if (!this.isValidLabel(flds[k2].label)) obj['label'] = 'invalid';
                        if (Object.keys(obj).length > 0){
                            fields[k2] = obj;
                        }
                    }
                }
                if (Object.keys(fields).length > 0) ret.fields[k1] = fields;
                var dao = {};
                var datas = this.meta[k1].data;
                for (var k3 in datas){
                    if (datas.hasOwnProperty(k3)){
                        var data =  datas[k3];
                        var obj = {};
                        for (var k4 in data){
                            if (data.hasOwnProperty(k4)){
                                var val = this._normalizeFieldValue(data[k4], k4);
                                var type = flds[k4].type;
                                var format = flds[k4].format;
                                if (type == 'String'){
                                    if (!this.isValidString(val)) obj[k4] = 'invalid';
                                } else if (type == 'Number'){
                                    if (!this.isValidNumber(val, format)) obj[k4] = 'invalid';
                                } else if (type == 'Date'){
                                    if (!this.isValidDate(val, format)) obj[k4] = 'invalid';
                                } else if (type == 'DateTime'){
                                    if (!this.isValidDateTime(val, format)) obj[k4] = 'invalid';
                                }
                            }
                        }
                        if (Object.keys(obj).length > 0){
                            dao[k3] = obj;
                        }
                    }
                }
                if (Object.keys(dao).length > 0) ret.data[k1] = dao;
                
            }
        } 
        this.$set(this, 'validation', ret);
    },
    isValidTitle : function(str){
        if (str){
            return /^.{1,300}$/.test(str);
        } else {
            return false;
        }
    },
    isValidMemo : function(str){
        if (str == ''){
            return true;
        } else if (str){
            return /^(?:.|\n|\r\n){1,8000}$/.test(str);
        } else {
            return false;
        }
    },
    isValidIndustry : function(str){
        if (str){
            var ret = false;
            var opts = this.page.newProjectFromTemplate.industry.option;
            for (var i=0; i<opts.length; i++){
                var val = opts[i].value;
                if (str == val){
                    ret = true;
                    break;
                }
            }
            return ret;
        } else {
            return false;
        }
    },
    isValidLang : function(str){
        if (str){
            var ret = false;
            var opts = this.page.newProjectFromTemplate.lang.option;
            for (var i=0; i<opts.length; i++){
                var val = opts[i].value;
                if (str == val){
                    ret = true;
                    break;
                }
            }
            return ret;
        } else {
            return false;
        }
    },
    isValidAlias : function(str){
        if (str){
            return /^.{1,30}$/.test(str);
        } else {
            return false;
        }
    },
    isValidLabel : function(str){
        if (str){
            return /^.{1,40}$/.test(str);
        } else {
            return false;
        }
    },
    isValidName : function(str){
        if (str){
            return /^[a-zA-Z]{1}[a-zA-Z0-9_]{0,38}[a-zA-Z0-9](?:__c)?$/.test(str);
        } else {
            return false;
        }
    },
    isValidString : function(str){
        if (str != null){
            return /^.{1,100}$/.test(str);  
        } else {
            return true;
        }
    },
    isValidNumber : function(str, scale){
        if (str == null){
            return true;
        }
        var precision = 18 - scale;
        var exp = scale == 0 ? '^\-?(?:[1-9]{1}[0-9]{0,16})?[0-9]{1}$':
        scale == 1 ? '^\-?(?:[1-9]{1}[0-9]{0,15})?[0-9]{1}(?:\\.[0-9]{1})?$':
        scale == 17 ? '^\-?[0-9]{1}(?:\\.[0-9]{1,17})?$':
        scale == 16 ? '^\-?(?:[1-9]{1})?[0-9]{1}(?:\\.[0-9]{1,16})?$':
        '^\-?(?:[1-9]{1}[0-9]{0,' + (precision - 2) + '})?[0-9]{1}(?:\\.[0-9]{1,' + scale + '})?$';
        var regExp = new RegExp(exp);
        return regExp.test(str);
    },
    isValidDate : function(str, format){
        if (str == null){
            return true;
        }
        var fmt = format.replace(/dd/g, 'DD').replace(/yyyy/g, 'YYYY').replace(/yy/g, 'YY');
        var valid = moment(str, fmt)._isValid;
        var exp = format.replace(/[yMd]/g, '[0-9]').replace(/\//g, '\\\/').replace(/\./g, '\\\.');
        var regExp = new RegExp('^' + exp + '$');
        return regExp.test(str) && valid;
    },
    isValidDateTime : function(str, format){
        if (str == null){
            return true;
        }
        var fmt = format.replace(/dd/g, 'DD').replace(/yyyy/g, 'YYYY').replace(/yy/g, 'YY');
        var valid = moment(str, fmt)._isValid;
        var exp = format.replace(/[yMdHhmsS]/g, '[0-9]').replace(/[a]/g, '(?:am|pm|AM|PM|a|p|A|P)').replace(/\//g, '\\\/').replace(/\'/g, '').replace(/\./g, '\\\.');
        var regExp = new RegExp('^' + exp + '$');
        return regExp.test(str) && valid;
    },
    
    openUrl : function(url){
        var childWindow = window.open('about:blank');
        if (childWindow != null){
            childWindow.location.href = url;
            childWindow = null;
        }
    },
    initExportToDataset : function(){
        this.$set(this, 'exportToDataset', {
            doneUpload: false,
            externalDataId: '',
            uploaded: 0,
            allDataPartCount: 0,
            uploadedList: [],
            doneCount: 0,
            totalCount: this.rule.master.analyticsTotal,
            currentCount: 0,
            work : {},
            countDataPart : 0
        });  
    },
    startImportingOnAnalytics : function(){
        var _t = this;
        window.setTimeout(function(){
            _t.doApexCallout('startImport', [_t.exportToDataset.externalDataId], function(e, res){
                if (e.type != 'exception' && res){
                    _t.apt = false;
                    _t.showToast('success', 'Successfuly exported. Check the import status in Data Manager.');
                    _t.openUrl(_t.constant.dataManagerUrl);                    
                }
            });        
        }, 1000);
    },
    exportToSalesforceAsObject : function(){
        this.apt = true;
        this._initExportToSalesforce();
        if (this.rule.master.salesforce.deleteBeforeExport){
            this._deleteAlreadyExistedRecords();
        } else {
            this._startBulkApiCreateInsertJob();    
        }        
    },
    _deleteAlreadyExistedRecords : function(){
        var _t = this;
        forceGet(_t, 'query/?q=SELECT+count(Id)+FROM+' + _t.rule.master.salesforce.object.name, function(res){
            var toDeleteCount = res.data.records[0].expr0;
            if (toDeleteCount > 0){
                _t.exportToSalesforce.toDeleteCount = toDeleteCount;
                _t._doBulkApiCreateDeleteJob();
            } else {
                _t._startBulkApiCreateInsertJob(); 
            }
        }, function(err){
            
        }); 
    },
    _initExportToSalesforce : function(){
        this.$set(this, 'exportToSalesforce', {
            work: {},
            jobIdForDelete: '',
            toDeleteCount: 0,
            deletedCount: 0,
            offsetForDelete: 0,
            doneUpload: false,
            jobId: '',
            doneCount: 0,
            totalCount: Number(this.rule.master.salesforce.total),
            countPerTime: 10000
        });  
    },
    _doBulkApiCreateDeleteJob : function(){
        var _t = this;
        forcePost(_t, 'jobs/ingest', {
            operation : 'delete',
            object : _t.rule.master.salesforce.object.name,
            contentType : 'CSV',
            lineEnding: 'LF'
        }, function(res){
            _t.exportToSalesforce.jobIdForDelete = res.data.id;
            _t._doRetreiveSalesforceRecordIds();
        }, function(err){
            
        }); 
    },
    _doRetreiveSalesforceRecordIds : function(){
        var _t = this;
        var query = 'SELECT+Id+FROM+' + _t.rule.master.salesforce.object.name + '+LIMIT+' + _t.exportToSalesforce.countPerTime + '+OFFSET+' + _t.exportToSalesforce.offsetForDelete;
        forceGet(_t, 'query/?q=' + query, function(res){
            _t.exportToSalesforce.offsetForDelete += _t.exportToSalesforce.countPerTime;
            var rcds = res.data.records;
            var csv = _t._convQueryResultToCsvForDelete(rcds);
            _t._doBulkApiPutDataToJob(_t.exportToSalesforce.jobIdForDelete, csv, function(res0){
                _t._doBulkApiCompleteJob(_t.exportToSalesforce.jobIdForDelete, function(res){
                    if (_t.exportToSalesforce.offsetForDelete < _t.exportToSalesforce.toDeleteCount){
                        _t._doBulkApiCreateDeleteJob();
                    } else {
                        _t._startBulkApiCreateInsertJob();
                    }
                });                
            });            
        }); 
    },
    _convQueryResultToCsvForDelete : function(rcds){
        var ret = 'Id\n';
        for (var i=0;i<rcds.length; i++){
            ret += rcds[i].Id + '\n';
        }    
        return ret;
    },
    _startBulkApiCreateInsertJob : function(){
        this._prepareUploadToSalesforceOnCreateRecords();
        this._doBulkApiCreateInsertJob();
    },
    _prepareUploadToSalesforceOnCreateRecords : function(){    
        var targetObj = this.rule.work.decisionRuleWithOrder;
        this.exportToSalesforce.work = Object.assign({}, this._initWorkOnCreateRecords(targetObj));      
    },
    _doBulkApiCreateInsertJob : function(){
        var _t = this;
        forcePost(_t, 'jobs/ingest', {
            operation : 'insert',
            object : _t.rule.master.salesforce.object.name,
            contentType : 'CSV',
            lineEnding: 'LF'
        }, function(res){
            _t.exportToSalesforce.jobId = res.data.id;
            _t._doUploadToSalesforceOnCreateRecordsJob();
        }); 
    },
    _doUploadToSalesforceOnCreateRecordsJob : function(){
        var raw = this.orderedRelations;     
        var rcs = [];
        var mrcs = [];
        while (this.exportToSalesforce.doneCount <= this.exportToSalesforce.totalCount){
            this.exportToSalesforce.doneCount ++;
            var record = {};
            var meta = {};
            for(var k=0; k<raw.length; k++){
                var k1 = raw[k].id;
                if(this.meta.hasOwnProperty(k1)){
                    var ruleInfo = this.whichRule(k1, meta);
                    var ruleId = ruleInfo.ruleId;
                    var ruleType = ruleInfo.type;
                    var rules = ruleInfo.rules;
                    var dats = this.meta[k1].data;
                    var keys = this.randArray(Object.keys(dats));
                    for (var j=0; j<keys.length; j++){
                        var count = this.exportToSalesforce.work[k1][ruleId].records[keys[j]].count;
                        var total = this.exportToSalesforce.work[k1][ruleId].total;
                        //var prob = rules[keys[j]].probability;
                        var prob = rules.hasOwnProperty(keys[j]) && rules[keys[j]].hasOwnProperty('probability') && (rules[keys[j]].probability > 0) ? rules[keys[j]].probability:0;
                        if(j ==  (keys.length - 1) || (prob > 0 && (total == 0 || (count / total) <= (prob * this.rule.master.rand)))){
                            this.exportToSalesforce.work[k1][ruleId].records[keys[j]].count ++;
                            var normalizeRecord = this.normalizeRecord(k1, this.meta[k1].data[keys[j]]);
                            record = Object.assign(record, normalizeRecord);
                            meta[k1] = keys[j];
                            break;
                        }   
                    }             
                    this.exportToSalesforce.work[k1][ruleId].total ++;
                }
            }
            rcs.push(record);
            mrcs.push(meta);
            if ((this.exportToSalesforce.doneCount % this.exportToSalesforce.countPerTime) == 0 || this.exportToSalesforce.doneCount >= this.exportToSalesforce.totalCount){
                var ret = this._adjustRecords([rcs, mrcs]); // For "sum" function since v1.38
                var rcds = this._normalizeRecordsForBulkApi(ret[0]); // For Bulk API, conv Date/DateTime => 'yyyy-mm-ddZ' / 'yyyy-mm-ddThh:mm:ssZ'
                rcds = this._convertRecordToCsvObjectForBulkApi(rcds); // key Change: Field ID => Salesforce Field API Name
                var csv = this._convertToCsvForBulkApi(rcds, true); // Conv: JSON => CSV String
                var _t = this;
                this._doBulkApiPutDataToJob(this.exportToSalesforce.jobId, csv, function(res0){
                    _t._doBulkApiCompleteJob(_t.exportToSalesforce.jobId, function(res){
                        if (_t.exportToSalesforce.doneCount < _t.exportToSalesforce.totalCount){
                            _t._doBulkApiCreateInsertJob();
                        } else {
                            _t.apt = false; // FINISH EXPORTING TO SALESFORCE!!!!!!!
                            _t.openUrl(_t.salesforceObjectListViewUrl);
                        }
                    });
                });
                break;
            }
        }
        
    },   
    _normalizeRecordsForBulkApi : function(rcs){
        var rets = [];
        for (var i=0; i<rcs.length; i++){
            var data = rcs[i];
            var ret = {};
            for (var k1 in data){
                if (data.hasOwnProperty(k1)){
                    var normed = data[k1];
                    var thisField = this.allFieldsById[k1];
                    if (thisField.type == 'Date'){
                        normed = this._convDateToStringForBulkApi(normed, thisField.format);
                    } else if (thisField.type == 'DateTime'){
                        normed = this._convDateTimeToStringForBulkApi(normed, thisField.format);                    
                    }
                    ret[k1] = normed;                
                }
            }
            rets.push(ret);
        }
        return rets;
    },
    _convertRecordToCsvObjectForBulkApi : function(records){
        var rets = [];
        for (var i=0; i<records.length; i++){
            var record = records[i];
            var ret = {};
            for (var sfdcFieldApiName in this.rule.master.salesforce.mappings){
                if (this.rule.master.salesforce.mappings.hasOwnProperty(sfdcFieldApiName)){
                    var thisFieldId = this.rule.master.salesforce.mappings[sfdcFieldApiName];
                    if (thisFieldId && this.allFieldsById.hasOwnProperty(thisFieldId)){
                        ret[sfdcFieldApiName] = this._normalizeValueForBulkApi(record[thisFieldId]);
                    } 
                }             
            }
            rets.push(ret);
        }
        return rets;
    },
    _normalizeValueForBulkApi : function(orgVal){
        if (orgVal == null){
            return '#N/A';
        }
        var  newVal = String(orgVal).replace(/"/g, '""');
        if (newVal.match(/\,|"|\r\n|\n|\r/)) newVal = '"' + newVal + '"';
        //if (newVal == '') newVal = '#N/A';
        return newVal;
    },
    _convertToCsvForBulkApi : function(dats, header){
        return Papa.unparse(dats, {
            quotes: true,
            quoteChar: '',
            escapeChar: '',
            delimiter: ",",
            header: header,
            newline: "\n"
        }) + '\n';
    },
    _doBulkApiPutDataToJob : function(jobId, csv, func){
        var _t = this;
        forcePut(_t, 'jobs/ingest/' + jobId + '/batches', csv, {
            headers : {
                'Content-Type': 'text/csv',
                'Accept': 'application/json'
            } 
        }, function(res){
            if (func) func(res);
        }); 
    },
    _doBulkApiCompleteJob : function(jobId, func){
        var _t = this;
        forcePatch(_t, 'jobs/ingest/' + jobId, {
            'state': 'UploadComplete'
        }, function(res){
            if (func) func(res);
        }); 
    },
    exportToAnalyticsAsDataset : function(){
        this.apt = true;
        this.initExportToDataset();
        var _t = this;
        var operation = this.rule.master.hasOwnProperty('eaOperation') ? this.rule.master.eaOperation: 'Append'; 
        this.doApexCallout('newDatasetMetadata', [
            this.rule.master.DatasetLabel, this.rule.master.DatasetApiName, this.allFields, operation
        ], function(e, res){
            if (e.type == 'exception'){
                _t.apt = false;
            } else if (res){
                _t.exportToDataset.externalDataId = res;
                _t._doUploadToAnalyticsOnCreateRecords();
            }
        });
    },
    _doUploadToAnalyticsOnCreateRecords : function(){
        var targetObj = this.rule.work.decisionRuleWithOrder;
        this.exportToDataset.work = Object.assign({}, this._initWorkOnCreateRecords(targetObj));
        this._doUploadToAnalyticsOnCreateRecordsJob();        
    },
    _doUploadToAnalyticsOnCreateRecordsJob : function(){
        var raw = this.orderedRelations;     
        var rcs = [];
        var mrcs = [];
        while (this.exportToDataset.currentCount <= this.exportToDataset.totalCount){
            this.exportToDataset.currentCount ++;
            var record = {};
            var meta = {};
            for(var k=0; k<raw.length; k++){
                var k1 = raw[k].id;
                if(this.meta.hasOwnProperty(k1)){
                    var ruleInfo = this.whichRule(k1, meta);
                    var ruleId = ruleInfo.ruleId;
                    var ruleType = ruleInfo.type;
                    var rules = ruleInfo.rules;
                    var dats = this.meta[k1].data;
                    var keys = this.randArray(Object.keys(dats));
                    for (var j=0; j<keys.length; j++){
                        var count = this.exportToDataset.work[k1][ruleId].records[keys[j]].count;
                        var total = this.exportToDataset.work[k1][ruleId].total;
                        //var prob = rules[keys[j]].probability;
                        var prob = rules.hasOwnProperty(keys[j]) && rules[keys[j]].hasOwnProperty('probability') && (rules[keys[j]].probability > 0) ? rules[keys[j]].probability:0;
                        if(j ==  (keys.length - 1) || (prob > 0 && (total == 0 || (count / total) <= (prob * this.rule.master.rand)))){
                            this.exportToDataset.work[k1][ruleId].records[keys[j]].count ++;
                            var normalizeRecord = this.normalizeRecord(k1, this.meta[k1].data[keys[j]]);
                            record = Object.assign(record, normalizeRecord);
                            meta[k1] = keys[j];
                            break;
                        }   
                    }             
                    this.exportToDataset.work[k1][ruleId].total ++;
                }
            }
            rcs.push(record);
            mrcs.push(meta);            
            if ((this.exportToDataset.currentCount % Number(this.settings.exportToAnalytics.rowsPerTime)) == 0 || this.exportToDataset.currentCount == this.exportToDataset.totalCount){
                var ret = this._adjustRecords([rcs, mrcs]);
                var rcds = this._convertRecordToCsvObjectForAnalytics(ret[0]);
                var csv = this._convertToCsv(rcds, false);
                this._setJobOfSendDataPartToAnalytics(csv, this.exportToDataset.countDataPart, rcs.length);
                this.exportToDataset.countDataPart ++;
                break;
            }
        }
    },
    _setJobOfSendDataPartToAnalytics : function(csv, count, len){
        var b64d = btoa(unescape(encodeURIComponent(csv)));
        var _t = this;
        this.exportToDataset.uploaded ++;
        forcePost(_t, 'sobjects/InsightsExternalDataPart', {
            InsightsExternalDataId : this.exportToDataset.externalDataId,
            PartNumber : this.exportToDataset.uploaded,
            DataFile : b64d
        }, function(res){
            if (_t.exportToDataset.currentCount < _t.exportToDataset.totalCount){
                _t.exportToDataset.uploadedList.push(res);
                _t.exportToDataset.doneCount += count;
                _t._doUploadToAnalyticsOnCreateRecordsJob();
            } else if (_t.exportToDataset.currentCount == _t.exportToDataset.totalCount){
                _t.exportToDataset.doneUpload = true;
                _t.exportToDataset.allDataPartCount = _t.exportToDataset.countDataPart;
                _t.exportToDataset.uploadedList.push(res);
                _t.exportToDataset.doneCount += count;
            }            
        }, function(err){
            _t.alert(err);
            _t.apt = false;
        });
    },
    _convertRecordToCsvObjectForAnalytics : function(records){
        var rets = [];
        if (records.length > 0){
            for (var i=0; i<records.length; i++){
                var record = records[i];
                var ret = {};
                for (var j=0; j<this.allFields.length; j++){                
                    ret[this.allFields[j].name] = record[this.allFields[j].id];
                }
                rets.push(ret);
            }
        }
        return rets;
    },
    _outputRecords : function(totalRecordCount){
        var targetObj = this.rule.work.decisionRuleWithOrder;
        var work = this._initWorkOnCreateRecords(targetObj);
        var raw = this.orderedRelations;     
        var rcs = [];
        var mrcs = [];
        for (var i=0; i<totalRecordCount; i++){
            var record = {};
            var meta = {};
            for(var k=0; k<raw.length; k++){
                var k1 = raw[k].id;
                if(this.meta.hasOwnProperty(k1)){
                    var ruleInfo = this.whichRule(k1, meta);
                    var ruleId = ruleInfo.ruleId;
                    var ruleType = ruleInfo.type;
                    var rules = ruleInfo.rules;
                    var dats = this.meta[k1].data;
                    var keys = this.randArray(Object.keys(dats));
                    for (var j=0; j<keys.length; j++){
                        var count = work[k1][ruleId].records[keys[j]].count;
                        var total = work[k1][ruleId].total;
                        var prob = rules.hasOwnProperty(keys[j]) && rules[keys[j]].hasOwnProperty('probability') && (rules[keys[j]].probability > 0) ? rules[keys[j]].probability:0;
                        if(j ==  (keys.length - 1) || (prob > 0 && (total == 0 || (count / total) <= (prob * this.rule.master.rand)))){
                            work[k1][ruleId].records[keys[j]].count ++;
                            var normalizeRecord = this.normalizeRecord(k1, this.meta[k1].data[keys[j]]);
                            record = Object.assign(record, normalizeRecord);
                            meta[k1] = keys[j];
                            break;
                        }   
                    }             
                    work[k1][ruleId].total ++;
                }
            }
            rcs.push(record);
            mrcs.push(meta);
        }
        return [rcs, mrcs];
    },
    _convertToCsv : function(dats, header){
        return Papa.unparse(dats, {
            quotes: true,
            quoteChar: '"',
            escapeChar: '"',
            delimiter: ",",
            header: header,
            newline: "\n"
        }) + '\n';
    },
    allSliderSetToZero : function(){
        var sliders = this.page.lensDialog.sliders;
        for (var i=0; i<sliders.length; i++){
            this.page.lensDialog.sliders[i].count = 0;
        }
    },
    openLoadCsvDialog : function(){
        this.$set(this.page, 'importCsvDialog', {
            show: true,
            step: 1,
            filePath: '',
            fileData: {},
            fields: {}
        });
    },
    openDataGenDialog: function(){
        var _t = this;
        this.$set(this.page.dataGenDialog, 'show', true);
        this.page.dataGenDialog.input.filter.value = null;
        this.page.dataGenDialog.input.filter.key = null;
        this.page.dataGenDialog.input.type = null;
        this.page.dataGenDialog.input.count = 10;
        this.page.dataGenDialog.input.alias = '';
        this.page.dataGenDialog.sampleRawData = null;
        this.page.dataGenDialog.step = 1;        
    },
    clickedCreateByDataGenApi: function(){
        var _t = this;
        var fieldMetas = this.page.dataGenDialog.input.fields.filter(function(field){
            return field.active;
        });

        var filteredColumns = this.dataGenDialogSampleHeaders.filter(function(_item, idx){
            return _t.page.dataGenDialog.input.fields[idx].active;
        }).map(function(item){
            return item.value;
        });
        var body = {
            type: this.page.dataGenDialog.input.type,
            columns: filteredColumns,
            count: Number(this.page.dataGenDialog.input.count)
        };
        var filter = this.page.dataGenDialog.input.filter;
        if (filter.key != null && filter.value != null){
            body.filters = {};
            body.filters[filter.key] = filter.value;
        }
        dataGenPost(_t, body, function(res){
            if (res.data && res.data.data){
                var dats = res.data.data;
                _t.createFieldSetsAndRecordsForDataGenDialog(fieldMetas, dats);
            }
        });
      	  
    },
    createFieldSetsAndRecordsForDataGenDialog: function(fieldMetas, dats){
        var newOid = this.getId();
        var fields = {};
        var fldIds = [];
        var data = {};
        var _t = this;
        fieldMetas.forEach(function(field){
            var newFid = _t.getId();
            fldIds.push(newFid);
            fields[newFid] = {
                id: newFid,
                label: field.label,
                name: field.name,
                type: field.type,
                format: field.format
            };
        });
        dats.forEach(function(dat, did){
            var newDid = _t.getId();
            data[newDid] = {};
            fieldMetas.forEach(function(field, fid){
                data[newDid][fldIds[fid]] = {type: 'static', value: dat[fid]};
            });
        });
        var obj = {
            alias: this.page.dataGenDialog.input.alias,
            id: newOid,
            keyField: fldIds[0],
            fields: fields,
            data: data
        };        
        this.$set(this.meta, newOid, obj);
        this.objectTab.active = newOid;
        this.objectTab.editMode = false;
        this.step.now = 1;
        this.page.dataGenDialog.show = false;
        var _t = this;
        window.setTimeout(function(){
            _t._checkRecordData();
        }, 50);
	},
    
    changedDataGenDialogFilterKey: function(val){
        var _t = this;
        this.page.dataGenDialog.input.filter.value = null;
        if (val == null){
            dataGenPost(_t, {
                type: this.page.dataGenDialog.input.type
            }, function(res){
                if (res.data){
                    _t.$set(_t.page.dataGenDialog, 'sampleRawData', res.data);
                }
            }); 
        }
    },
    changedDataGenDialogFilterValue: function(){
        var _t = this;
        var body = {
            type: this.page.dataGenDialog.input.type,
            filters: {}
        };
        var filter = this.page.dataGenDialog.input.filter;
        body.filters[filter.key] = filter.value;
        dataGenPost(_t, body, function(res){
            if (res.data){
                _t.$set(_t.page.dataGenDialog, 'sampleRawData', res.data);
            }
        });
    },
    changedDataGenDialogType: function(val){
        this.page.dataGenDialog.input.filter.key = null;
        this.page.dataGenDialog.input.filter.value = null;
        this.page.dataGenDialog.input.alias = this.dataGenDialogTypes.find(function(item){
            return item.value == val;
        })['text'];
        
        var _t = this;
        dataGenPost(_t, {type: val}, function(res){
            if (res.data){
                _t.$set(_t.page.dataGenDialog, 'sampleRawData', res.data);
                var fields = res.data.columns.map(function(field){
                    var apiName = field.replace(/\s/g, '');
                    var allFieldNames = _t.allFieldsName;
                    if (allFieldNames.indexOf(apiName) >= 0){
                        var count = 0;
                        while(count < 100){
                            count ++;
                            var candidateName = apiName + '_' + count;
                            if (allFieldNames.indexOf(candidateName) == -1){
                             	apiName = candidateName;
                                break;
                            }
                        }                        
                    }
                    return {
                        active: true,
                        name: apiName,
                        label: field,
                        type: 'String'
                    }
                });
                _t.$set(_t.page.dataGenDialog.input, 'fields', fields);
            }
        });
    },
    uploadedCsvFile : function(e){        
        var _t = this;
        var files = e.target.files;
        if(files[0] !== undefined) {
            this.imageName = files[0].name;
            var fr = new FileReader();
            fr.onload = function(){
                var csvt = decodeURIComponent(escape(atob(fr.result.split(/,/)[1]))).replace(/(\r\n|\r|\n)+$/, '');
                var csvd = Papa.parse(csvt, { header: false });
                _t.$set(_t.page.importCsvDialog, 'fileData', csvd);
                var headers = csvd.data[0];
                var nms = _t._newFieldNameLabel(headers.length);
                var flds = [];
                for (var i=0; i<headers.length; i++){
                    flds.push({
                        label: headers[i].replace(/^"/, '').replace(/"$/, ''),
                        name: nms[i],
                        type: 'String',
                        format: ''
                    });
                }
                _t.$set(_t.page.importCsvDialog, 'fields', flds);
                _t.page.importCsvDialog.step = 2;
            };
            fr.readAsDataURL(files[0]);            
        }
    },
    clickedStartImportCsv : function(){
        var newOid = this.getId();
        var fields = {};
        var fldIds = [];
        var data = {};
        var cfields = this.page.importCsvDialog.fields;
        for (var i=0; i<cfields.length; i++){
            var newFid = this.getId();
            fldIds.push(newFid);
            fields[newFid] = {
                id: newFid,
                label: cfields[i].label,
                name: cfields[i].name,
                type: cfields[i].type,
                format: cfields[i].format
            };
        }
        var fds = this.page.importCsvDialog.fileData.data;
        fds.shift();
        var mx = fds.length > 999 ? 999: fds.length;
        for (var i=0; i<mx; i++){
            var newDid = this.getId();
            data[newDid] = {};
            for (var j=0; j<cfields.length; j++){
                var thisValue = fds[i][j];
                if (thisValue && thisValue.length > 0){
	                data[newDid][fldIds[j]] = {type: 'static', value: fds[i][j]};                    
                } else {
                    data[newDid][fldIds[j]] = {type: 'null'};
                }
            }
        }
        var obj = {
            alias: this.page.importCsvDialog.objectAlias,
            id: newOid,
            keyField: fldIds[0],
            fields: fields,
            data: data
        };
        this.$set(this.meta, newOid, obj);
        this.page.importCsvDialog.show = false;
        this.objectTab.active = newOid;
        this.objectTab.editMode = false;
        this.step.now = 1;
        var _t = this;
        window.setTimeout(function(){
            _t._checkRecordData();
        }, 50);
    },
    closeProject : function(){
        this.isEditPage = false;
        this.init();
    },
    returnToTemplateList : function(){
        this.isEditPage = false;
        if (this.page.currentProject.title.length > 0 || this.page.currentProject.memo.length > 0){
            this.page.newProjectFromTemplate.show = true;
        } else {
            this.page.newProjectFromTemplate.show = false;            
        }
        this.init();
    },
    openProject : function(pid, title, memo, isTemplate){
        this.page.openProject.show = true;
        this.step.now = 1;
        this.step4tab.active = 0;
        this.page.currentProject.templateId = isTemplate ? pid: null;
        this.page.currentProject.id = isTemplate ? null: pid;
        this.page.currentProject.title = isTemplate ? 'Copy - ' + title: title;
        this.page.currentProject.memo = memo;        
        var _t = this;
        var method = isTemplate ? 'getTemplate': 'getConfig';
        this.doApexCallout(method, [pid], function(e, res){
            _t.$delete(_t.apexCallout, 'getConfig');
            if (res){
                var obj = JSON.parse(res);
                _t.$set(_t, 'meta', obj.meta);
                _t.$set(_t, 'rule', obj.rule);
                if (isTemplate){
                    _t.rule.master.DatasetLabel = '';
                    _t.rule.master.DatasetApiName = '';
                }
                _t.normalizeVersionUpdateDiff();
                _t.page.exportToSalesforce.activeObject = _t.rule.master.salesforce.object.name;
            }
            window.setTimeout(function(){
                _t.page.newProjectFromTemplate.show = false;
                _t.ap.changedData = false;
                _t.isEditPage = true;
                _t.page.openProject.show = false;
                _t._checkRecordData();
                _t._fixRule();
                if (_t.meta && Object.keys(_t.meta).length > 0){
                    _t.$set(_t.objectTab, 'active', Object.keys(_t.meta)[0]);
                }
            }, 400);
        });        
    },
    normalizeVersionUpdateDiff : function(){
        this._doUpdateDiff_1_38();
        this._doUpdateDiff_2_0();
        this._doUpdateDiff_3_0();
    },
    _doUpdateDiff_3_0: function(){
        var _t = this;
        Object.keys(_t.meta).forEach(function(oid){
            Object.keys(_t.meta[oid].data).forEach(function(did){
                Object.keys(_t.meta[oid].data[did]).forEach(function(fid){
                    var target = _t.meta[oid].data[did][fid];
                    if (target.type == 'static' && !(target.value && target.value.length > 0)){
                        _t.meta[oid].data[did][fid] = {
                            type: 'null'
                        };
                    }
                });                
            });
        });
    },
    _doUpdateDiff_2_0: function(){
        var _t = this;
        Object.keys(_t.meta).forEach(function(oid){
            Object.keys(_t.meta[oid].data).forEach(function(did){
                Object.keys(_t.meta[oid].data[did]).forEach(function(fid){
                    var target = _t.meta[oid].data[did][fid];
                    if (typeof target !== 'object'){
                        _t.meta[oid].data[did][fid] = {
                            type: 'static',
                            value: target
                        };
                    }
                });                
            });
        });
    },
    _doUpdateDiff_1_38: function(){
        if (!this.rule.master.hasOwnProperty('salesforce')){
            this.$set(this.rule.master, 'salesforce', {
                total: 100,
                object: {name: '', label: ''},
                fields: {},
                mappings: {},
                deleteBeforeExport : false
            });
        }
    },
    openBlankProject : function(){
        this.page.openProject.show = true;
        this.step.now = 1;
        this.page.currentProject.id = null;
        this.page.currentProject.tempalteId = null;
        this.page.currentProject.title = '';
        this.page.currentProject.memo = '';        
        this.$delete(this.apexCallout, 'getConfig');
        this._initMeta();
        var _t = this;
        window.setTimeout(function(){
            _t.page.newProjectFromTemplate.show = false;
            _t.ap.changedData = false;
            _t.isEditPage = true;
            _t.page.openProject.show = false;
            _t._checkRecordData();
        }, 400);
    },
    openSaveProjectAsNewEditDialog : function(){
        this.page.newProject.id = null;
        this.page.newProject.form.title = this.page.currentProject.title;
        this.page.newProject.form.memo = this.page.currentProject.memo;
        this.page.newProject.show = true;  
    },
    deleteObject : function(oid){
        var _t = this;
        
        this.confirm('Are you sure you want to delete this Field Set?', function(_t){
            var oids = Object.keys(_t.meta);
            var idx = oids.indexOf(oid);
            var nextOid = 
                oids.length == 1 ? 'newobject':
            idx == (oids.length - 1) ? oids[(idx - 1)]: oids[(idx + 1)];
            _t.objectTab.active = nextOid;
            _t.$delete(_t.meta, oid);
            if (_t.rule.simple.hasOwnProperty(oid)){
                _t.$delete(_t.rule.simple, oid);
            }
        });
        
    },
    createNewObject : function(){
        var nfn = this._newFieldNameLabel(1)[0];
        this.page.newObject.form.alias = '';
        this.page.newObject.form.keyFieldLabel = nfn;
        this.page.newObject.form.keyFieldName = nfn;
        this.page.newObject.form.keyFieldType = 'String';
        this.page.newObject.show = true;  
    },
    clickedNewFieldSet: function(){
        var aliasNumber = Object.keys(this.meta).length + 1;
        var field = this._newFieldNameLabel(1)[0];
        var ret = this.saveNewObject(
            'Alias' + aliasNumber,
            field,
            field,
            'String',
            null
        );		
        this.objectTab.active = ret[0];
        this.objectTab.editMode = true;   
        this.page.newObject.show = false;
        this.step.now = 1;
    },
    clickedSaveNewObject: function(){
        var ret = this.saveNewObject(
            this.page.newObject.form.alias,
            this.page.newObject.form.keyFieldLabel,
            this.page.newObject.form.keyFieldName,
            this.page.newObject.form.keyFieldType,
            this.page.newObject.form.keyFieldFormat
        );		
        this.objectTab.active = ret[0];
        this.objectTab.editMode = false;   
        this.page.newObject.show = false;
        this.step.now = 1;
    },
    saveNewObject : function(alias, label, name, type, format){
        var newOid = this.getId();
        var newFid = this.getId();
        var obj = {
            alias: alias,
            id: newOid,
            keyField: newFid,
            fields: {},
            data: {}
        };
        obj.fields[newFid] = {
            label: label,
            name: name,
            type: type,
            format: format,
            id: newFid
        };
        this.$set(this.meta, newOid, obj);
        return [newOid, newFid];
    },
    clickedSaveProject : function(){
        var _t = this;
        var callback = function(e, res){
            _t.ap.changedData = false;
            _t.showToast('success', 'Project "' + _t.page.currentProject.title + '" was saved.');
        };
        this._saveProject(callback);
    },
    _saveProject : function(callback){
        var _t = this;
        var meta = Object.assign({}, this.meta);
        var rule = Object.assign({}, this.rule);        
        this.doApexCallout('saveConfig', [this.page.currentProject.id, JSON.stringify({
            meta: meta,
            rule: rule
        })], function(e, res){
            if (callback) callback(e, res);
        }); 
    },
    clickedSaveProjectAsNew : function(){
        var _t = this;
        var meta = Object.assign({}, this.meta);
        var rule = Object.assign({}, this.rule);        
        this.doApexCallout('newProjectWithData', [this.page.newProject.form.title, this.page.newProject.form.memo, JSON.stringify({
            meta: meta,
            rule: rule
        })], function(e, res){
            _t.ap.changedData = false;
            _t.showToast('success', 'Project "' + _t.page.currentProject.title + '" was saved.');
        }); 
    },
    showToast : function(color, text, keep){
        this.page.snackbar.color = color;
        this.page.snackbar.text = text;
        this.page.snackbar.timeout = keep ? null: 6000;        
        this.page.snackbar.show = true;
    },
    clickedDeleteProject : function(){
        var _t = this;
        var pid = this.page.newProject.id;
        var targetProjectTitle = this.page.newProject.form.title;
        
        this.confirm('Are you sure you want to delete Project "' + targetProjectTitle + '"', function(_t){
            _t.doApexCallout('deleteProject', [pid], function(e, res){
                _t.page.newProject.show = false;
                _t.showToast('success', 'Project "' + targetProjectTitle + '" was deleted.'); 
                _t.doApexCallout('getAllProject');
            });  
        });
        
        
        
    },
    saveNewProject : function(){
        var _t = this;
        var pid = this.page.newProject.id;
        if (pid != null && pid.length > 4){
            this.doApexCallout('changeProject', [pid, this.page.newProject.form.title, this.page.newProject.form.memo], function(e, res){
                _t.page.newProject.show = false;
                if (res){
                    _t.showToast('success', 'Project "' + _t.page.newProject.form.title + '" was changed.');                
                    _t.doApexCallout('getAllProject');
                }
            });
        } else {    
            var meta = Object.assign({}, this.meta);
            var rule = Object.assign({}, this.rule);        
            var title = this.page.newProject.form.title;
            var memo = this.page.newProject.form.memo;
            this.doApexCallout('newProjectWithData', [
                title,
                memo,
                JSON.stringify({
                    meta: meta,
                    rule: rule
                })
            ], function(e, res){
                _t.page.newProject.show = false;
                if (res){
                    _t.showToast('success', 'Project "' + _t.page.newProject.form.title + '" was created.');                
                    _t.page.currentProject.id = res;
                    _t.page.currentProject.title = title;
                    _t.page.currentProject.memo = memo;
                    _t.ap.changedData = false;
                }
            });	
            if (this.page.currentProject.templateId != null && this.page.currentProject.templateId != ''){
                this.doApexCallout('usage', [this.page.currentProject.templateId]); 
            }
        }
    },
    clickedNewField : function(){
        var nfv = this._newFieldNameLabel(1)[0];
        this.saveNewField(this.activeTabObjectId, nfv, nfv, 'String', '');
    },
    saveNewField: function(oid, label, name, type, format){
        var newFid = this.getId();
        this.$set(this.meta[oid].fields, newFid, {
            id: newFid,
            label: label,
            name: name,
            type: type,
            format: format
        });
        for (var k1 in this.meta[oid].data){
            if (this.meta[oid].data.hasOwnProperty(k1)){
                this.$set(this.meta[oid].data[k1], newFid, '');
            }
        }  
        return newFid;
    },
    
    openNewField : function(){
        this.page.newField.form.label = '';
        this.page.newField.form.name = '';
        this.page.newField.form.type = '';
        this.page.newField.show = true;  
    },
    clickedDeleteField : function(fid){
        this.confirm('All the record values of the field also will be removed. Is it OK?', function(_t){
            _t.$delete(_t.meta[_t.activeTabObjectId].fields, fid);
            for (var k1 in _t.meta[_t.activeTabObjectId].data){
                if (_t.meta[_t.activeTabObjectId].data.hasOwnProperty(k1)){
                    _t.$delete(_t.meta[_t.activeTabObjectId].data[k1], fid);
                }
            }
        });
    },
    createNewRecord : function(){
        var dataId = Object.keys(this.meta[this.activeTabObjectId].data);
        var newId = this._newRecord(this.activeTabObjectId, {});
        if (dataId && dataId.length > 0){
            var did = dataId[(dataId.length - 1)];
            this._copyProbability(did, newId);
        }
    },
    _newRecord: function(oid, record){
        var rcd = {};
        for (var k1 in this.meta[oid].fields){
            if (this.meta[oid].fields.hasOwnProperty(k1)){
                if (record.hasOwnProperty(k1)){
                    var val = record[k1];
                    if (val && val.length > 0){
                    	rcd[k1] = {
                            type: 'static',
                            value: val
                        };
                    } else {
                        rcd[k1] = {
                            type: 'null'
                        }; 
                    }
                } else {
                    rcd[k1] = {
                        type: 'static',
                        value: ''
                    };
                }
            }
        }
        var newId = this.getId();
        this.$set(this.meta[oid].data, newId, rcd);
        return newId;
    },
    clickedCopyRecord : function(did){
        if (!this.recordAltering){
            this.recordAltering = true;
            var newId = this._copyRecord(did);
            this._copyProbability(did, newId);  
            var _t = this;
            window.setTimeout(function(){
                _t.recordAltering = false;
            }, 200);
        }
    },
    clickedDeleteRecord : function(did){
        if (!this.recordAltering){
            this.recordAltering = true;
            var oid = this.activeTabObjectId;
            this._deleteRecord(oid, did); 
            this._deleteTrend(oid, did);
            this._shapeUpRule();
            var _t = this;
            window.setTimeout(function(){
                _t.recordAltering = false;
            }, 200);
        }
    },
    _deleteRecord : function(oid, did){
        this.$delete(this.meta[oid].data, did);
    },
    _deleteTrend: function(oid, did){
        this._deleteRuleSimple(oid, did);
        this._deleteRuleMix(oid, did);
        this._deleteRuleMixConditions(oid, did);
    },
    _deleteRuleSimple : function(oid, did){
        if (this.rule.simple.hasOwnProperty(oid)){
            var rules = this.rule.simple[oid].rules;
            var rmOrgVal = rules[did].probability;
            var ratio = 1 / (1 - rmOrgVal);
            for (var k1 in rules){
                if (rules.hasOwnProperty(k1)){
                    this.$set(
                        this.rule.simple[oid].rules[k1],
                        'probability',
                        this.rule.simple[oid].rules[k1].probability * ratio);                    
                }
            }
            this.$delete(this.rule.simple[oid].rules, did);            
        }
    },
    _deleteRuleMix : function(oid, did){
        if (this.rule.mix.hasOwnProperty(oid)){
            var elms = this.rule.mix[oid];
            for (var i=0; i<elms.length; i++){
                var rules = elms[i].rules;
                var rmOrgVal = rules[did].probability;
                var ratio = 1 / (1 - rmOrgVal);
                for (var k1 in rules){
                    if (rules.hasOwnProperty(k1)){
                        this.$set(
                            this.rule.mix[oid][i].rules[k1],
                            'probability',
                            this.rule.mix[oid][i].rules[k1].probability * ratio);                    
                    }
                }
                this.$delete(this.rule.mix[oid][i].rules, did);            
            }
        }
    },
    _deleteRuleMixConditions : function(oid, did){
        for (var k1 in this.rule.mix){
            if (this.rule.mix.hasOwnProperty(k1) && oid != k1){
                var elms = this.rule.mix[k1];
                for (var i=elms.length - 1; i >= 0; i--){
                    var conditions = elms[i].conditions;
                    for (var j=conditions.length - 1; j>=0; j--){
                        var condition = conditions[j];
                        if (condition.base == oid){
                            var vals = condition.values;
                            var ido = vals.indexOf(did);
                            if (ido >= 0){
                                this.rule.mix[k1][i].conditions[j].values.splice(ido, 1); 
                            } 
                            if (!(this.rule.mix[k1][i].conditions[j].values.length > 0)){
                                this.rule.mix[k1][i].conditions.splice(j, 1);
                            }
                            break;
                        }
                    }
                    if (!(this.rule.mix[k1][i].conditions.length > 0)){
                        this.rule.mix[k1].splice(i, 1);
                    }           
                }
            }
        }
    },
    _shapeUpRule: function(){
        var sRuleIds = Object.keys(this.rule.simple);
        if (sRuleIds.length > 0){
            for (var i=0; i<sRuleIds.length; i++){
                if(!(this.rule.simple[sRuleIds[i]].hasOwnProperty('rules') && Object.keys(this.rule.simple[sRuleIds[i]].rules).length > 0)){
                    this.$delete(this.rule.simple, sRuleIds[i]);                    
                }
            }
        }
        var mRuleIds = Object.keys(this.rule.mix);
        if (mRuleIds.length > 0){
            for (var i=0; i<mRuleIds.length; i++){
                if (!(this.rule.mix[mRuleIds[i]].length > 0)){
                    this.$delete(this.rule.mix, mRuleIds[i]); 
                }
            }
        }      	  
    },
    _copyProbability: function(did, nid){
        if (this.rule.simple.hasOwnProperty(this.activeTabObjectId)){
            var rules = this.rule.simple[this.activeTabObjectId].rules;
            if (rules.hasOwnProperty(did) && rules[did].hasOwnProperty('probability')){
                var addOrgVal = rules[did].probability;
                if (addOrgVal > 0){
                    var ratio = 1 / (1 + addOrgVal);
                    for (var k1 in rules){
                        if (rules.hasOwnProperty(k1)){
                            this.$set(
                                this.rule.simple[this.activeTabObjectId].rules[k1],
                                'probability',
                                this.rule.simple[this.activeTabObjectId].rules[k1].probability * ratio);                    
                        }
                    }
                    this.$set(
                        this.rule.simple[this.activeTabObjectId].rules,
                        nid, {
                            probability :  addOrgVal * ratio
                        });
                }
            }
        }
        if (this.rule.mix.hasOwnProperty(this.activeTabObjectId)){
            var elms = this.rule.mix[this.activeTabObjectId];
            for (var i=0; i<elms.length; i++){
                var rules = elms[i].rules;
                if (rules.hasOwnProperty(did) && rules[did].hasOwnProperty('probability')){
                    var addOrgVal = rules[did].probability;
                    var ratio = 1 / (1 + addOrgVal);
                    for (var k1 in rules){
                        if (rules.hasOwnProperty(k1)){
                            this.$set(
                                this.rule.mix[this.activeTabObjectId][i].rules[k1],
                                'probability',
                                this.rule.mix[this.activeTabObjectId][i].rules[k1].probability * ratio);                    
                        }
                    }
                    this.$set(
                        this.rule.mix[this.activeTabObjectId][i].rules,
                        nid, {
                            probability :  addOrgVal * ratio
                        }); 
                }
            }
        }
    },
    _copyRecord: function(did){
        var rcd = JSON.parse(JSON.stringify(this.meta[this.activeTabObjectId].data[did]));
        var newId = this.getId();
        this.$set(this.meta[this.activeTabObjectId].data, newId, rcd);
        return newId;
    },
    clickedNewRule : function(){
        this.page.lensDialog.ruleId = this.lensRuleId;
        this.setSliders(this.lens.data.data); 
        this.page.adjustSliders.show = true;
    },
    showSnackbar : function(text, color){
        if(text){
            this.page.snackbar.text = text;
            if(color){
                this.page.snackbar.color = color;	   
            }
            this.page.snackbar.show = true;
        } 
    },
    clickedDeleteRule: function(rid){
        this.confirm('Are you sure you want to delete this Trend?', function(_t){
            _t.deleteRuleOf(rid); 
        });
    },
    clickedEditRule: function(rid){
        this.page.lensDialog.ruleId = rid;
        this.setSlidersById(); 
        this.page.adjustSliders.show = true;
    },
    clickedShowTrend: function(rid){
        var ret = {};        
        var conditions = [];
        if (this.rule.mix.hasOwnProperty(this.lens.group.object)){
            for (var i=0; i<this.rule.mix[this.lens.group.object].length; i++){
                if (this.rule.mix[this.lens.group.object][i].id == rid){
                    conditions = this.rule.mix[this.lens.group.object][i].conditions;
                }
            }
        }
        for (var i=0; i<conditions.length; i++){
            var items = [];
            for (var j=0; j<conditions[i].values.length; j++){
                items.push({
                    text: myFilters.showRecord(this.meta[conditions[i].base].data[conditions[i].values[j]][this.meta[conditions[i].base].keyField]),
                    value: conditions[i].values[j]
                });
            }
            ret[conditions[i].base] = items;
            
        }	
        this.$set(this.page.objectFilterItems, 'data', ret);
        this.changedTryFilterItem(this.lens.group.object);
    },
    deleteRuleOf: function(rid){    
        var done = false;
        for (var k1 in this.rule.mix){
            if (this.rule.mix.hasOwnProperty(k1)){
                for(var i=0; i<this.rule.mix[k1].length;i++){
                    if (rid == this.rule.mix[k1][i].id){
                        this.rule.mix[k1].splice(i, 1);
                        done = true;
                        break;
                    }
                }
            }
        }
        if (!done){
            if (rid in this.rule.simple){
                this.$delete(this.rule.simple, rid);
            }
        }
        this.setDecisionRuleWithOrder();
        this.changedTryFilterItem(this.lens.group.object);
        this.calcChartValues();
        this.calcChartValues2();        
    },
    _changeMixRuleOf: function(rid){
        var vals = this.page.lensDialog.sliders;
        var total = 0;
        for (var i=0; i<vals.length; i++){
            total += vals[i].count;
        }
        var ruleIndex = null;
        for (var i=0; i<this.rule.mix[this.lens.group.object].length; i++){
            if (this.rule.mix[this.lens.group.object][i].id == rid){
                ruleIndex = i;
                break;
            }
        }
        if(ruleIndex != null){
            for (var i=0; i<vals.length; i++){
                this.$set(this.rule.mix[this.lens.group.object][ruleIndex].rules[vals[i].id],  'probability', (vals[i].count / total));
            }
        }
    },
    _changeSimpleRuleOf: function(rid){
        var vals = this.page.lensDialog.sliders;
        var total = 0;
        for (var i=0; i<vals.length; i++){
            total += vals[i].count;
        }
        for (var i=0; i<vals.length; i++){
            this.$set(this.rule.simple[rid].rules[vals[i].id],  'probability', (vals[i].count / total));
        } 
    },
    saveRule: function(){
        var rid = this.page.lensDialog.ruleId;
        if (rid && !this.meta.hasOwnProperty(rid)){
            this._changeMixRuleOf(rid);    
        } else if (rid && this.rule.simple.hasOwnProperty(rid)){
            this._changeSimpleRuleOf(rid);    
        } else {
            this._saveRuleAsNew(rid);        
        }
        this.setDecisionRuleWithOrder();
        this.createRecords();
        this.page.adjustSliders.show = false;
    },
    _saveRuleAsNew: function(rid){
        if (!(rid && rid.length > 4)){
            rid = this.getId();
        }        
        
        if (Object.keys(this.lens.filter).length > 0){
            var rets = [];
            if (!this.rule.mix.hasOwnProperty(this.lens.group.object)){
                this.$set(this.rule.mix, this.lens.group.object,  []);
            }
            var ret = {
                id: rid,
                conditions: [],
                rules: {}
            };
            for (var k1 in this.lens.filter){
                if (this.lens.filter.hasOwnProperty(k1)){
                    if (this.lens.filter[k1].chip && this.lens.filter[k1].data.length > 0){
                        ret.conditions.push({
                            base : k1,
                            values : this.lens.filter[k1].data
                        });                        
                    }  
                }
            }
            var vals = this.page.lensDialog.sliders;
            var total = 0;
            for (var i=0; i<vals.length; i++){
                total += vals[i].count;
            }
            var ref = {};
            for (var i=0; i<vals.length; i++){
                ret.rules[vals[i].id] = {
                    probability: (vals[i].count / total)
                };
            }
            this.rule.mix[this.lens.group.object].push(ret);
        } else {
            this.$set(this.rule.simple, rid,  {rules : {}});
            var vals = this.page.lensDialog.sliders;
            var total = 0;
            for (var i=0; i<vals.length; i++){
                total += vals[i].count;
            }
            for (var i=0; i<vals.length; i++){
                this.$set(this.rule.simple[rid].rules, vals[i].id,  {
                    probability: (vals[i].count / total)
                });
            } 
        }
        
    },
    changedSliderValue: function(ti, e){
        var li = this.page.lensDialog.lastChangedIndex;
        if (e.shiftKey && ti != li){
            var sliders = this.page.lensDialog.sliders;
            var minI = ti;
            var maxI = li;
            if (ti > li){
                minI = li;
                maxI = ti;
            }
            var minV = sliders[minI].count;
            var maxV = sliders[maxI].count;
            for (var i = (minI + 1); i < maxI; i++){
                var val = minV + (i - minI) * ((maxV - minV) / (maxI - minI));
                this.$set(this.page.lensDialog.sliders[i], 'count', val);
            }
            
        }
        this.page.lensDialog.lastChangedIndex = ti;
    },
    sLoading : function(){
        //this.ap.loading = true;  
    },
    createRecordsReal : function(){
        this.createRecords(true);
        
    },
    createRecords : function(notSimulation){
        this.$set(this.ap, 'startGeneRecords', true);
        this.apt = true;
        var _t = this;
        window.setTimeout(function(){
            _t.createRecordJob(notSimulation);
        }, 200);
    },
    changedTryFilterItem : function(newObj){
        var _t = this;
        this.ap.chartActive = false;
        if (this.lens.group.object != newObj){
            this.lens.group.field = null; 
        }
        window.setTimeout(function(){
            changedTryFilterItemJob(_t, newObj);
        }, 400);                          
    },
    
    getRandomKeyFromObject : function(obj){
        var arr = Object.keys(obj);
        return arr[Math.floor(Math.random() * arr.length)];
    },
    randArray : function(array){
        for (var i = array.length - 1; i >= 0; i--){
            var rand = Math.floor( Math.random() * ( i + 1 ) );
            var ar1 = array[rand];
            var ar2 = array[i];
            array[i] = ar1;
            array[rand] = ar2;
        }
        return array;
    },
    getId : function(){
        return Math.floor(this.sys.hashStrong * Math.random()).toString(16) + new Date().getTime().toString(16);
    },
    removeFilterObject : function(obj){
        if (this.lens.filter.hasOwnProperty(obj)){
            this.$delete(this.lens.filter, obj);
            this.changedTryFilterItem(this.lens.group.object);
        }   
    },
    checkDoneLensStep : function(){
        if (Object.keys(this.rule.simple).length > 0 || Object.keys(this.rule.mix).length > 0){
            this.step.steps[3].complete = true;
        } else {
            this.step.steps[3].complete = false;
        }
    },
    onResize : function(){
        this.ap.windowSize = { x: window.innerWidth, y: window.innerHeight };
    },
    removeAllLensFilter : function(){
        this.$set(this.page.objectFilterItems, 'data', {});
    },
    whichRule : function(objectId, meta){
        var ret = {
            ruleId : '',
            type: '',
            rules : {}
        };
        var rules = this.rule.work.decisionRuleWithOrder[objectId];
        for(var m=0; m<rules.length; m++){
            if (rules[m].type == 'mix'){
                var thisConditions = rules[m].conditions;
                var meet = 0;
                for (var cn=0;cn<thisConditions.length;cn++){
                    var ths = meta[thisConditions[cn].base];
                    var oks = thisConditions[cn].values;
                    if (ths && ths.length > 0 && oks && oks.length > 0 && oks.indexOf(ths) >= 0){
                        meet ++;
                    }
                }
                if (meet > 0 && meet == thisConditions.length){
                    ret.rules = rules[m].rules;
                    ret.ruleId = rules[m].id;
                    ret.type = 'mix';
                    break;
                }
            } else {
                ret.rules = rules[m].rules;
                ret.ruleId = rules[m].id;
                ret.type = rules[m].type;
                break;
            }
        }
        return ret;
    },
    setSliders: function(ref){
        var rets = [];
        var total = 0;
        var thisObj = this.lens.group.object;
        var rid = this.page.lensDialog.ruleId;
        if (this.lensRuleIdActual == null){
            for (var k1 in ref){
                if(ref.hasOwnProperty(k1)){
                    rets.push(Object.assign({}, ref[k1]));
                    total += ref[k1].count;            
                }
            }
        } else {
            var rules;
            if (thisObj == this.lensRuleIdActual){
                rules = this.rule.simple[thisObj].rules;			
            } else {
                var objs = this.rule.mix[thisObj];
                for (var i=0; i<objs.length; i++){
                    if (objs[i].id == this.lensRuleIdActual){
                        rules = objs[i].rules;
                    }
                }
            }
            for(var k2 in rules){
                if (rules.hasOwnProperty(k2)){
                    var count = Math.round(1000 * rules[k2].probability);
                    rets.push({
                        label: this.meta[thisObj].data[k2][this.meta[thisObj].keyField],
                        id: k2,
                        count: count
                    });
                    total += count;
                }
            }
        }
        for(var i=0;i<rets.length;i++){
            var val = 100 * rets[i].count / total;
            rets[i].count = _simplifyDecimal(val);
        }
        this.$set(this.page.lensDialog, 'sliders', rets);
    },
    setSlidersById: function(){
        var rets = [];
        var total = 0;
        var thisObj = this.lens.group.object;
        var rid = this.page.lensDialog.ruleId;
        
        var rules;
        if (thisObj == rid){
            rules = this.rule.simple[thisObj].rules;			
        } else {
            var objs = this.rule.mix[thisObj];
            for (var i=0; i<objs.length; i++){
                if (objs[i].id == rid){
                    rules = objs[i].rules;
                }
            }
        }
        for(var k2 in rules){
            if (rules.hasOwnProperty(k2)){
                var count = Math.round(1000 * rules[k2].probability);
                rets.push({
                    label: this.meta[thisObj].data[k2][this.meta[thisObj].keyField],
                    id: k2,
                    count: count
                });
                total += count;
            }
        }
        
        for (var i=0;i<rets.length;i++){
            var val = 100 * rets[i].count / total;
            rets[i].count = _simplifyDecimal(val);
        }
        this.$set(this.page.lensDialog, 'sliders', rets);
    },
    setDecisionRuleWithOrder : function(){
        var ret = {};
        for (var k11 in this.meta){
            if(this.meta.hasOwnProperty(k11)){
                ret[k11] = [];
                if(k11 in this.rule.mix){ 
                    var rules = this.rule.mix[k11].slice();
                    rules.sort(function(a,b){
                        if( a.conditions.length > b.conditions.length ) return -1;
                        if( a.conditions.length < b.conditions.length ) return 1;
                        return 0;
                    });
                    for (var i=0; i<rules.length; i++){
                        rules[i].type = 'mix';
                    }
                    ret[k11] = rules;
                }
                if(k11 in this.rule.simple){
                    var obj = Object.assign({}, this.rule.simple[k11]);
                    obj.id = k11;
                    obj.type = 'simple';
                    ret[k11].push(obj);
                }
                if (true){
                    var obj = {
                        type: 'none',
                        id: '-',
                        rules: {}
                    };
                    var datKeys = Object.keys(this.meta[k11].data);
                    for(var i=0; i<datKeys.length; i++){                        
                        obj.rules[datKeys[i]] = {
                            probability : (1 / datKeys.length) 
                        };
                    }
                    ret[k11].push(obj);
                }
            }
        }
        this.$set(this.rule.work, 'decisionRuleWithOrder', ret);
    },
    calcChartValues : function(){
        var ret = [];        
        if (this.lens.group.object in this.rule.work.decisionRuleWithOrder){
            var rules = this.rule.work.decisionRuleWithOrder[this.lens.group.object].slice().reverse();
            for(var i=0; i<rules.length; i++){
                var thisId = rules[i].id;
                if (this.lens.data.rule[thisId] ||  this.lens.data.rule[thisId] > 0){
                    var colorIndex = this.decisionRuleIndexByRuleId[this.lens.group.object][thisId];
                    var thisColor = this.ap.activeColorSet[colorIndex];
                    var thisLabel = colorIndex == 0 ? 'No Trend' : 'TREND-' + ('000' + i).slice(-3);
                    var thisData = [];
                    for(var j=0; j<this.fitems.total.length; j++){
                        var dataId = this.fitems.total[j].dataId;
                        var val = this.lens.data.data[dataId].detail[thisId].count;
                        thisData.push(val / 10);
                    }
                    ret.push({
                        label: thisLabel,
                        borderWidth: 1,
                        borderColor: thisColor,
                        backgroundColor: thisColor,
                        data: thisData
                    });
                }
            }   
        }
        this.$set(this.chart, 'dataset', ret);
    },
    calcChartValues2 : function(){
        var ret2 = {
            label : [],
            data : []
        };
        for (var i=0;i<this.fitems.total.length;i++){
            ret2.label.push(myFilters.showRecord(this.fitems.total[i].groupby));
            ret2.data.push(this.fitems.total[i].count);
        } 
        this.$set(this.chart, 'data', ret2.data);
        this.$set(this.chart, 'label', ret2.label);
    },
    setShowAllRules: function(k1){
        if (this.meta.hasOwnProperty(k1)){
            while(this.page.lensDialog.allRules.length > 0){
                this.page.lensDialog.allRules.splice(0, 1);
            }
            var count = 0;
            if (k1 in this.rule.simple){
                count ++;
                this.page.lensDialog.allRules.push({
                    mix: false,
                    id: k1,
                    active: true
                });
            }
            if (k1 in this.rule.mix){
                var tgts = this.rule.mix[k1];
                for (var i=0; i<tgts.length; i++){
                    var ref2 = {
                        id: this.rule.mix[k1][i].id,
                        mix: true,
                        from: [],
                        active: true
                    };
                    var conditions = this.rule.mix[k1][i].conditions;
                    for(var j=0; j<conditions.length; j++){
                        var values = conditions[j].values.slice();
                        ref2.from.push({
                            id: conditions[j].base,
                            alias: this.meta[conditions[j].base].alias,
                            values: values
                        });
                    }
                    count ++;
                    this.page.lensDialog.allRules.push(ref2);
                }                        
            }
            var found = false;
            if (count > 0) {
                for (var i=0; i<this.page.lensDialog.allRules.length; i++){
                    if (this.lensRuleIdActual == this.page.lensDialog.allRules[i].id){
                        this.page.lensDialog.allRules[i]['current'] = true;
                        found = true;
                    } else {
                        this.page.lensDialog.allRules[i]['current'] = false;
                    }
                }
            }
            this.page.lensDialog.allRules.unshift({
                id: 'null',
                active: false
            }); 
        }            
    },
    initShowAllRules : function(){        
        while(this.page.lensDialog.allRules.length > 0){
            this.page.lensDialog.allRules.splice(0, 1);
        }
        this.page.lensDialog.allRules.push({
            id: 'null',
            active: false                    
        });        
    },
    normalizedNameForFileName: function(){
        var title = this.page.currentProject.title || 'Dataset';
        return title.replace(/[\s\.]+/g, '_') + '.csv';
        
    },
    downloadAsCsv: function() {
        var headers = [];
        var records = [];
        var title = this.normalizedNameForFileName();
        for (var i=0; i<this.sheaders.length; i++){
            headers.push(this.sheaders[i].text);
        }
        for (var j=0; j<this.records.length; j++){
            var record = [];
            for (var i=0; i<this.sheaders.length; i++){
                record.push(this.records[j][this.sheaders[i].value]);
            }
            records.push(record);
        }
        var csv = Papa.unparse({
            fields : headers,
            data : records
        }, title);
        var blb = new Blob([csv], { type: 'text/csv' });
        var link = document.createElement('a');
        link.href = window.URL.createObjectURL(blb);
        link.download = title;
        link.click();
    },
    resetRecord : function(){
        this.records = [];
        this.mrecords = [];
    },
    userSetForTracking : function(){
        this.doApexCallout('getUserEmail', [], function(e, res){
            if (res && res.length > 5 &&  typeof dataLayer !== 'undefined'){
                dataLayer.push({event: 'setUserEmail', userEmail:res})
            } else {
                console.log('DataLayer is not defined.');
            }
        });
    },
    appInit : function(){
        var _t = this;
        history.pushState(null, null, null);
        this.doApexCallout('getLang', [], function(e, res){
            _t.page.newProjectFromTemplate.lang.select = res;
        });
        this._getAllSalesforceObjects();
        dataGenPost(_t, {}, function(res){
            if (res.data && res.data.length > 0){
                _t.$set(_t.page.dataGenDialog, 'optionsMeta', res.data);
            }
        });        
    },
    init : function(){
        this._initMeta();
        this.$set(this, 'objectTab', {
            active : '',
            editMode: false
        });
        var _t = this;
        this.doApexCallout('getAllProject', [], function(e, res){
            if (res && res.length > 0){
                _t.page.welcome.position = 1;
            }
        });
    },
    _initMeta : function(){
        this.$set(this, 'meta', {});
        this.$set(this, 'rule', {
            master: {
                rand: 1,
                total: 5000,
                analyticsTotal: 10000,
                DatasetLabel: '',
                DatasetApiName: ''
            },
            mix : {},
            simple: {},
            work: {
                decisionRuleWithOrder : {}
            }
        });  
        this.normalizeVersionUpdateDiff();
    },
    doApexCallout : function(mtd, params, callback){
        var _t = this;
        this.$set(this.apexCallout, mtd, null);
        var args = [remoteAction[mtd]];
        if (params && params.length > 0){
            for (var i=0; i<params.length; i++){
                args.push(params[i]);
            }
        }
        args.push(function(res, e){
            _t.$set(_t.apexCallout, mtd, res);
            if (e.type == 'exception'){
                _t._showError('APEX Error: ' + e.message + ' : ' + e.where);
            } else if (typeof res == 'string' && res.match(/^Error\:/)){
                _t._showError('APEX Error: ' + res);
            } else {
                if (callback) callback(e, res);                
            }
        });
        args.push({
            escape: false
        });
        Visualforce.remoting.Manager.invokeAction(...args);
    },
    normalizeRecord : function(oid, data){
        var ret = {};
        for (var k1 in data){
            if (data.hasOwnProperty(k1)){
                ret[k1] = this._normalizeFieldValue(data[k1], k1);
            }
        }
        return ret;
    },
    _convDateToStringForBulkApi : function(orgVal, format){
        if (orgVal == null){
            return null;
        }
        var fmt = format.replace(/dd/g, 'DD').replace(/yyyy/g, 'YYYY');
        return moment(orgVal, fmt).format('YYYY-MM-DDZ');
    },
    _convDateTimeToStringForBulkApi : function(orgVal, format){
        if (orgVal == null){
            return null;
        }
        var fmt = format.replace(/dd/g, 'DD').replace(/yyyy/g, 'YYYY');
        return moment(orgVal, fmt).format();;
    },
    _normalizeFieldValue : function(obj, fieldId){
        try{
            var field = this.allFieldsById[fieldId];
            if (obj.type == 'null'){
                return null;
            } else if (obj.type == 'static' || obj.type == 'function'){
                var orgVal = obj.value;
                var newVal = orgVal || '';
                var reg0 = (orgVal || '').match(/^\s*\{\{(.+)\}\}\s*$/);
                if (reg0 || obj.type == 'function'){
                    var scrpt = obj.type == 'function' ? obj.code : reg0[1];
                    try {
                        newVal = eval(scrpt);
                    } catch(e){
                        newVal = 'Warning - ' + e;
                    }
                }
                return newVal;
            } else if (obj.type == 'rangeNumber'){
                var newVal = '';
                try {
                    newVal = eval("rand(" + obj.from + "," + obj.to + "," + obj.step + ")");
                } catch(e){
                    newVal = 'Warning - ' + e;
                }
                return newVal;
            } else if (obj.type == 'rangeDate'){
                var mo = randDate(moment(Date.parse(obj.fromTo[0])), moment(Date.parse(obj.fromTo[1])));
                return mo.format(field.format.replace('yyyy', 'YYYY').replace('yy', 'YY').replace('dd', 'DD'));
            } else if (obj.type == 'rangeRelativeDate'){
                var range = obj.range;
                var rangeName = ~range.indexOf('m') ? 'month': ~range.indexOf('y') ? 'year': ~range.indexOf('w') ? 'week': ~range.indexOf('d') ? 'day': '';
                var add = ~range.indexOf('t') ? 0: ~range.indexOf('a') ? (Number(obj.diff) * -1): ~range.indexOf('l') ? Number(obj.diff): 0; 
                var mo1 = moment().add(add, rangeName + 's').startOf(rangeName);
                var mo2 = moment().add(add, rangeName + 's').endOf(rangeName);
                var mo = randDate(mo1, mo2);            
                return mo.format(field.format.replace('yyyy', 'YYYY').replace('yy', 'YY').replace('dd', 'DD'));
            } else if (obj.type == 'rangeRelativeDateAndTime'){
                //Date
                var range = obj.range;
                var rangeName = ~range.indexOf('m') ? 'month': ~range.indexOf('y') ? 'year': ~range.indexOf('w') ? 'week': ~range.indexOf('d') ? 'day': '';
                var add = ~range.indexOf('t') ? 0: ~range.indexOf('a') ? (Number(obj.diff) * -1): ~range.indexOf('l') ? Number(obj.diff): 0; 
                var mo1 = moment().add(add, rangeName + 's').startOf(rangeName);
                var mo2 = moment().add(add, rangeName + 's').endOf(rangeName);
                var mo = randDate(mo1, mo2);
                //Time
                var mt= randDatetime(moment(Date.parse(obj.fromToTime[0])), moment(Date.parse(obj.fromToTime[1])));
                //Combine
                mo.set('hour', mt.get('hour'));
                mo.set('minute', mt.get('minute'));
                mo.set('second', mt.get('second'));
                return mo.format(field.format.replace('yyyy', 'YYYY').replace('yy', 'YY').replace('dd', 'DD'));
            } else if (obj.type == 'rangeDatetime'){
                var mo = randDatetime(moment(Date.parse(obj.fromToDateTime[0])), moment(Date.parse(obj.fromToDateTime[1])));
                return mo.format(field.format.replace('yyyy', 'YYYY').replace('yy', 'YY').replace('dd', 'DD'));
            } else if (obj.type == 'rangeDateAndTime'){
                //Date
                var mo = randDate(moment(Date.parse(obj.fromToDate[0])), moment(Date.parse(obj.fromToDate[1])));
                //Time
                var mt= randDatetime(moment(Date.parse(obj.fromToTime[0])), moment(Date.parse(obj.fromToTime[1])));
                //Combine
                mo.set('hour', mt.get('hour'));
                mo.set('minute', mt.get('minute'));
                mo.set('second', mt.get('second'));
                return mo.format(field.format.replace('yyyy', 'YYYY').replace('yy', 'YY').replace('dd', 'DD'));
            }
        } catch(ex){
            return 'error';
        }
        return 'Unknown type';
        
    },
    createRecordJob : function(notSimulation){
        var totalRecordCount = notSimulation ? this.rule.master.total: this.ap.simulationRecordTotalCount;
        var ret = this._outputRecords(totalRecordCount);
        if (notSimulation) var ret = this._adjustRecords(ret); // For "sum" function since v1.38
        this.$set(this, 'records', ret[0]);
        this.$set(this, 'mrecords', ret[1]);
        this.$set(this.ap, 'startGeneRecords', false);
        this.apt = false;
        this.step.steps[2].complete = true;
    },
    _adjustRecords : function(ret){
        var _t = this;
        var rcs = [];
        if (Object.keys(this.afterCreateFieldDataIds).length > 0){
            var rts = ret[0];
            for (var i=0; i<rts.length; i++){
                var mrc = ret[1][i];
                for (var k1 in this.afterCreateFieldDataIds){
                    if (this.afterCreateFieldDataIds.hasOwnProperty(k1)){
                        if (rts[i].hasOwnProperty(k1)){
                            var datId = mrc[this.afterCreateFieldDataIds[k1].obj];
                            if (this.afterCreateFieldDataIds[k1].dats.indexOf(datId) >= 0){
                                var dat = this.meta[this.afterCreateFieldDataIds[k1].obj].data[datId][k1];                         
                                var thisFldVal = dat.type == 'static' ? dat.value: dat.type == 'function' ? '{{' + dat.code + '}}': '';                                
                                var conv = thisFldVal.replace(/val\s*\(\s*\'\s*([a-zA-Z0-9_]+)\s*\'\s*\)/g, function(dmy, apiName){                                    
                                    var thisFid = _t.allFieldsIdByName[apiName];
                                    if (thisFid && thisFid.length > 0){
                                        var rtv = rts[i][thisFid];
                                        var typ = _t.allFieldsById[thisFid].type;
                                        if (typ != 'Number') rtv = "'" + rtv + "'";
                                        return rtv;
                                    } else {
                                        return null;
                                    }
                                }).replace(/row\s*\(\s*\)/g, function(){ return i + 1; });
                                ret[0][i][k1] = this._normalizeFieldValue({type: 'static', value: conv}, k1);
                            }
                        }                    
                    }
                }
            }
        }
        return ret;  
    },
    _initWorkOnCreateRecords : function(targetObj){
        var work = {};
        for (var k1 in targetObj){
            if(targetObj.hasOwnProperty(k1)){
                work[k1] = {};
                var rules = targetObj[k1];
                for (var i=0; i<rules.length; i++){
                    work[k1][rules[i].id] = {
                        total:0,
                        records: {}
                    };
                    var dats = this.meta[k1].data;
                    for (var k2 in dats){
                        if(dats.hasOwnProperty(k2)){
                            work[k1][rules[i].id].records[k2] = {
                                count:0
                            }; 
                        }
                    }
                }   
            }
        }
        return work;
    },
    changeLang : function(lang){
        this.page.newProjectFromTemplate.lang.select = lang;
    },
    _labelFormat : function(type, fmt){
        var ret = type == 'Number' ? 'Precision:18, Decimal Places:' + fmt:
        type == 'String' ? '---': fmt;
        return ret;
    },
    _newFieldNameLabel : function(count){
        var going = true;
        var i=0;
        var ret = [];
        var j = count && count > 0 ? count: 1;
        var work = 0;
        while(going){
            i++;
            var tryname = 'Field' + i;
            if (this.allFieldsLabel.indexOf(tryname) == -1 && this.allFieldsName.indexOf(tryname) == -1){
                ret.push(tryname);
                work ++;
                if (work >= j){
                    going = false;
                }
            }
            if (i > 1000){
                ret.push('');
                going = false;
            }
        }
        return ret;
    },
    _checkRecordData : function(){
        this.checkValidation();
        this.checkDuplication();
    },
    _fixRule : function(){
        var tgs = this._findMixTargets();
        for (var k1 in tgs){
            if (tgs.hasOwnProperty(k1)){
                var dids = tgs[k1];
                for (var i=0; i<dids.length; i++){
                    this._deleteTrend(k1, dids[i]);
                }
            }
        }
    },
    _findMixTargets : function(){
        var rets = {};
        var mixs = this.rule.mix;
        for (var oid in mixs){
            if (mixs.hasOwnProperty(oid)){
                var mix = mixs[oid];
                for (var i=0; i<mix.length; i++){
                    var conds = mix[i].conditions;
                    for (var j=0; j<conds.length; j++){
                        var vals = conds[j].values;
                        var obj = conds[j].base;
                        for (var k=0; k<vals.length; k++){
                            var val = vals[k];
                            if (this.allDataIds.indexOf(val) == -1){
                                if (!rets.hasOwnProperty(obj)){
                                    rets[obj] = [];
                                }
                                if (rets[obj].indexOf(val) == -1){
                                    rets[obj].push(val);
                                }
                            }
                        }
                    }
                }                   
            }            
        }
        return rets;
    }
    
};


var myComputed = {
    canSaveForImportCsvFromDataGenApi: function(){
		return this.page.dataGenDialog.input.alias &&
            this.page.dataGenDialog.input.alias.length > 0 && 
            this.page.dataGenDialog.input.count > 0 && 
            this.page.dataGenDialog.input.count <= 500 &&
            this.page.dataGenDialog.input.fields.some(item => {
                return item.active == true;
            });        
    },
    canShowDataGenDialogFilterOption: function(){
      	return this.page.dataGenDialog.input.type != null && this.dataGenDialogFilterTargets && this.dataGenDialogFilterTargets.length > 0;  
    },
    dataGenDialogSampleHeaders: function(){
        if (this.page.dataGenDialog.sampleRawData){
            return this.page.dataGenDialog.sampleRawData.columns.map(function(item){
                return {
                    text: item,
                    align: 'left',
                    sortable: false,
                    value: item
                }
            });
        }
        return [];
    },
    dataGenDialogSampleRows: function(){
        var _t = this;
        if (this.page.dataGenDialog.sampleRawData){
            return this.page.dataGenDialog.sampleRawData.data.map(function(item){
                var ret = {};
                item.forEach(function(itemVal, idx){
                    ret[_t.dataGenDialogSampleHeaders[idx].value] = itemVal;                        
                });
                return ret;
            });
        }
        return [];
    },
    dataGenDialogTypes: function(){
        var metas = this.page.dataGenDialog.optionsMeta;
        if (metas && metas.length > 0){
            return metas.map(function(item){
                return {
                    text: item.label, value: item.name  
                };
            });
        }  
        return [];
    },
    dataGenDialogFilterTargets: function(){
        var _t = this;
        var metas = this.page.dataGenDialog.optionsMeta;
        if (metas && metas.length > 0){
            var typeMeta = metas.find(function(type){
                return type.name == _t.page.dataGenDialog.input.type
            });
            if (typeMeta){
                return typeMeta.filters.map(function(item){
                    return {
                        text: item.label, value: item.name  
                    };
                });    
            }            
        }  
        return [];
    },
    dataGenDialogFilterTargetsWithNull: function(){
        return [{text: '(No filter)', value: null}].concat(this.dataGenDialogFilterTargets);
    },
    dataGenDialogFilterOptions: function(){
        var _t = this;
        var metas = this.page.dataGenDialog.optionsMeta;
        if (metas && metas.length > 0){
            var typeMeta = metas.find(function(type){
                return type.name == _t.page.dataGenDialog.input.type
            });
            if (typeMeta){
                var filterMeta = typeMeta.filters.find(function(item){
                    return item.name == _t.page.dataGenDialog.input.filter.key;
                });
                if (filterMeta){
                    return filterMeta.options.map(function(item){
                        return {
                            text: item.label, value: item.name  
                        };
                    });
                }                    
            }            
        }  
        return [];
    },
    canStartImportCsvToNewProject: function(){
        var _t = this;
        return this.page.newProjectFromCsv.fields.every(function(field){
            if (field.active){
                return _t.isValidLabel(field.label) && _t.isValidName(field.name);
            } else {
                return true;
            }
            return false;
        });  
    },
    isActiveFooter: function(){
        if (this.isEditPage){
            if (this.step.now == 4){
                if (this.step4tab.active == 2){
                    if (!this.page.newSalesforceCustomObject.show){
                        return true;
                    }
                } else {
                    return true;
                }
            }
        } else {
            if (this.page.newProjectFromCsv.show == true && this.page.newProjectFromCsv.step == 2){
                return true;
            }
        }
        return false;  
    },
    functionFinderResultBgColor: function(){
        var result = this.page.step2hint.result;
        if (result && result.length > 0){
            if (result.match(/^Warning\s-\s/)){
                return 'error';
            }
        }
        return 'blue-grey darken-4';
    },
    allFunctionCandidates: function(){
        var ret = [ {
            value: '\'-hoge-\'', text: 'String literal - "-hoge-"', icon: 'text_format'
        }, {
            value: 'row()', text: 'Row number started from 1 and counted up', icon: 'mdi-numeric'
        }, {
            value: 'rand(0,100)', text: 'Random value between 0 and 100 (STEP:1)', icon: 'mdi-numeric'
        },{
            value: 'rand(0,1000,10)', text: 'Random value between 0 and 1000 (STEP:10)', icon: 'mdi-numeric'
        }];
        var thisFieldId = this.page.step2hint.fid;
        for (var fid in this.allFieldsById){
            if (this.allFieldsById.hasOwnProperty(fid)){
                if (fid != thisFieldId){
                    var type = this.allFieldsById[fid].type;
                    var icon = type == 'String' ? 'text_format': type == 'Number' ? 'mdi-numeric': 
                    type == 'Date' ? 'date_range': type == 'DateTime' ? 'access_time': '';
                    ret.push({
                        value: 'val(\'' + this.allFieldsById[fid].name + '\')', text: 'Value of another field: ' + this.allFieldsById[fid].label, icon: icon
                    });
                }
            }  
        }
        ret.push({
            value:'moment().add(-1, \'days\').format(\'dddd\')', text: 'The date of yesterday', icon: 'text_format'
        });
        return ret;        
    },
    elTimePickerDefaultTimes: function(){
        var yyyymmdd = moment().format('YYYY-MM-DD');
        return [new Date(yyyymmdd + 'T09:00:00'), new Date(yyyymmdd + 'T09:59:00')];
    },
    canExportToSalesforce : function(){
        var fieldMaps = this.sfdc1selectedFieldIds.length > 0;
        var isValidObject = this.isValidSfdcActiveObject;
        return  fieldMaps && isValidObject;
    },
    isValidSfdcActiveObject : function(){
        var incld = false;
        if (this.rule.master.salesforce.object.name){
            var objs = this.page.exportToSalesforce.objects;
            for (var i=0; i<objs.length; i++){
                if (objs[i].value == this.rule.master.salesforce.object.name){
                    incld = true;
                    break;
                }
            }
        }
        return incld;
    },
    step4sliderColor : function(){
        return this.step4tab.active == 0 ? 'blue-grey':
        this.step4tab.active == 1 ? 'deep-purple':
        this.step4tab.active == 2 ? 'blue':
        'black';        
    },
    fieldsForListView : function(){
        var ret = [];
        var flds = this.page.newSalesforceCustomObject.form.fields;
        var ct=0;
        for (var i=0; i<flds.length; i++){
            if (ct >= 15){
                break; 
            } else if (flds[i].active){
                ct += 1;
                ret.push(flds[i].fullName);
            } 
        }        
        return ret;
    },
    fieldsForMetadataApi : function(){
        var rets = [];
        var flds = this.page.newSalesforceCustomObject.form.fields;
        for (var i=0; i<flds.length; i++){
            if (flds[i].active){
                var ret = Object.assign({}, flds[i]);
                delete ret.active;
                rets.push(ret);
            }
        }
        return rets;
    },
    salesforceObjectListViewUrl: function(){
        return this.rule.master.salesforce.object.name.length > 0 ? 
            '/lightning/o/' + this.rule.master.salesforce.object.name + '/list': '';  
    },
    salesforceObjectManagerUrl : function(){
        return this.rule.master.salesforce.object.name.length > 0 ? 
            '/lightning/setup/ObjectManager/' + this.rule.master.salesforce.object.name + '/Details/view': '';  
    },
    canCreateNewSalesforceCustomObject : function(){
        var apiName = this.isValidName(this.page.newSalesforceCustomObject.form.name);
        var label = this.isValidLabel(this.page.newSalesforceCustomObject.form.label);
        var plabel = this.isValidLabel(this.page.newSalesforceCustomObject.form.plabel);
        return apiName && label && plabel;  
    },
    canSaveNewTemplate : function(){
        var title = this.isValidTitle(this.page.newTemplateDialog.form.title);  
        var memo = this.isValidMemo(this.page.newTemplateDialog.form.memo);  
        var industry = this.isValidIndustry(this.page.newTemplateDialog.form.industry);  
        var lang = this.isValidLang(this.page.newTemplateDialog.form.lang);
        return title && memo && industry && lang;
    },
    canSaveNewProject : function(){
        var title = this.isValidTitle(this.page.newProject.form.title);  
        var memo = this.isValidMemo(this.page.newProject.form.memo);  
        return title && memo;
    },
    canSaveNewObject : function(){
        var alias = this.isValidAlias(this.page.newObject.form.alias);
        var fieldLabel = this.isValidLabel(this.page.newObject.form.keyFieldLabel);
        var fieldName = this.isValidName(this.page.newObject.form.keyFieldName);
        return alias && fieldLabel && fieldName;
    },
    canSaveNewObjectFromCsv : function(){
        var alias = this.isValidAlias(this.page.importCsvDialog.objectAlias);
        return alias;
    },
    canCsvGenerate : function(){
        var ret = false;
        if (this.apt == false && this.rule.master.total > 0 && this.rule.master.total < 100000){
            ret = true;
        }
        return ret;
    },
    allDataIds : function(){
        var rets = [];
        for (var oid in this.meta){
            if (this.meta.hasOwnProperty(oid)){
                var datas = this.meta[oid].data;
                for (var did in datas){
                    if (datas.hasOwnProperty(did)){
                        rets.push(did);
                    }
                }
            }
        }
        return rets;
    },
    allFieldsLabel : function(){
        var ret = [];
        for (var i=0; i<this.allFields.length; i++){
            ret.push(this.allFields[i].label);
        }
        return ret;
    },
    allFieldsIdByName : function(){
        var ret = {};
        for (var i=0; i<this.allFields.length; i++){
            ret[this.allFields[i].name] = this.allFields[i].id;
        }
        return ret;
        
    },
    allFieldsName : function(){
        var ret = [];
        for (var i=0; i<this.allFields.length; i++){
            ret.push(this.allFields[i].name);
        }
        return ret;        
    },
    afterCreateFieldDataIds : function(){       
        var fields = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                for (var k2 in this.meta[k1].data){
                    if (this.meta[k1].data.hasOwnProperty(k2)){
                        var dat = this.meta[k1].data[k2];
                        for (var k3 in dat){
                            if (dat.hasOwnProperty(k3)){
                                if (dat[k3].type == 'static' || dat[k3].type == 'function'){
                                    var val = dat[k3].type == 'static' ? dat[k3].value: dat[k3].type == 'function' ? '{{' + dat[k3].code + '}}': null;
                                    if (val){
                                        var reg0 = val.match(/^\s*\{\{.*val\(.+\).*\}\}\s*$/);
                                        var reg1 = val.match(/^\s*\{\{.*row\(\s*\).*\}\}\s*$/);
                                        if (reg0 || reg1){
                                            if (!fields.hasOwnProperty(k3)){
                                                fields[k3] = {obj: k1, dats: []};
                                            }
                                            fields[k3].dats.push(k2);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return fields;
    },
    objectFilterItems : function(){
        var rets = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var ret = [];
                var keyField = this.meta[k1].keyField;
                for (var k2 in this.meta[k1].data){
                    if (this.meta[k1].data.hasOwnProperty(k2)){
                        var data = this.meta[k1].data[k2];
                        ret.push({
                            text: myFilters.showRecord(data[keyField]),
                            value: k2
                        });
                    }
                }
                rets[k1] = ret;
            }
        }
        return rets;
    },
    showTemplateList : function(){
        var ret = [];
        var min = 0 + ((this.page.newProjectFromTemplate.listPage.now - 1) * this.page.newProjectFromTemplate.listPage.countPerPage);
        var max = (this.page.newProjectFromTemplate.listPage.now * this.page.newProjectFromTemplate.listPage.countPerPage) - 1;
        for (var i=0; i<this.page.newProjectFromTemplate.list.length; i++){
            if (i <= max && i >= min){
                ret.push(this.page.newProjectFromTemplate.list[i]);
            }         	   
        }        
        return ret;
    },
    industryImg : function(){
        return {
            'at': at_img,
            'ot' : ot_img,
            'np' : np_img,
            'fn' : fn_img,
            'tr' : tr_img,
            'rt' : rt_img,
            're' : re_img,
            'md' : md_img,
            'mn' : mn_img,
            'hl' : hl_img,
            'gv' : gv_img,
            'ed' : ed_img,
            'cm' : cm_img
        }; 
    },
    getIndustryLabelByVal : function(){
        var ret = {};
        var items = this.page.newProjectFromTemplate.industry.option;
        for (var i=0; i<items.length; i++){
            ret[items[i].value] = items[i].label;
        }
        return ret;
    },
    getLanguageLabelByVal : function(){
        var ret = {};
        var items = this.page.newProjectFromTemplate.lang.option;
        for (var i=0; i<items.length; i++){
            ret[items[i].value] = items[i].label;
        }
        return ret;
    },
    chartBarLabelAxisSize : function(){
        var count = this.chart.dataset.length > 0 ? this.chart.dataset[0].data.length: 1;
        return count < 5 ? count * 12 : count > 100 ? 800: count * 8;
    },
    chartBarMeasureAxisSize : function(){
        return 100;
    },
    datasetFieldHeader : function(){
        var ret = [{
            text:'',
            value:'meta',
            align: 'left',
            sortable: false
        }];
        for (var i=0; i<this.allFields.length; i++){
            var idx = i + 1;
            ret.push({
                text:'#' + idx,
                value:'field'+idx,
                align: 'left',
                sortable: false
            });            
        }
        return ret;
    },
    datasetFieldItems : function(){
        var ret = [['Label'],['API Name'],['Type'],['Format']];
        for (var i=0; i<this.allFields.length; i++){
            var fld = this.allFields[i];
            ret[0].push(fld.label);
            ret[1].push(fld.name);
            ret[2].push(fld.type);
            ret[3].push(this._labelFormat(fld.type, fld.format));
        }
        return ret;
    },
    step1TdClass : function(){
        var ret = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                if (this.validation.fields.hasOwnProperty(k1)){
                    var flds = this.validation.fields[k1];
                    for (var k2 in flds){
                        if (flds.hasOwnProperty(k2)){
                            ret[k2] = {};
                            for (var k3 in flds[k2]){
                                if (flds[k2].hasOwnProperty(k3)){
                                    ret[k2][k3] = 'invalid-td';                                    
                                }
                            }
                        }
                    }
                }
                if (this.duplication.hasOwnProperty(k1)){
                    for (var i=0; i<this.duplication[k1].length; i++){
                        var kk = this.duplication[k1][i];
                        if (ret.hasOwnProperty(kk) == false) ret[kk] = {};
                        ret[kk]['name'] = 'invalid-td';
                    }
                }
            }
        }
        return ret;
    },
    step2TdClass : function(){
        var ret = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var dats = this.meta[k1].data;
                for (var k2 in dats){
                    if (dats.hasOwnProperty(k2)){
                        ret[k2] = {};
                        if (this.validation.data.hasOwnProperty(k1) && this.validation.data[k1].hasOwnProperty(k2)){
                            for (var k3 in this.validation.data[k1][k2]){
                                if (this.validation.data[k1][k2].hasOwnProperty(k3)){
                                    ret[k2][k3] = 'invalid-td';
                                }
                            }
                        }
                    }
                }
            }
        }
        return ret;
    },
    isValidStep : function(){
        var ret = {
            1: ((Object.keys(this.validation.fields).length == 0) && (Object.keys(this.duplication).length == 0)),
            2: (Object.keys(this.validation.data).length == 0),
            3: true,
            4: true
        };
        return ret;
    },
    step1InvalidCount : function(){
        var ret = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var count = 0;
                if (this.validation.fields.hasOwnProperty(k1)){
                    count += Object.keys(this.validation.fields[k1]).length;
                }
                if (this.duplication.hasOwnProperty(k1)){
                    count += this.duplication[k1].length;
                }
                ret[k1] = count;
            }
        }
        return ret;
    },
    step2InvalidCount : function(){
        var ret = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var count = 0;
                if (this.validation.data.hasOwnProperty(k1)){
                    count += Object.keys(this.validation.data[k1]).length;
                }
                ret[k1] = count;
            }
        }
        return ret;
    },
    invalidFieldCount : function(){
        var ret = {};
        for (var k1 in this.validation){
            if (this.validation.hasOwnProperty(k1)){
                var fields = this.validation[k1].fields;
                if (Object.keys(fields).length > 0){
                    
                }
            }
        }
        
    },
    allFields : function(){
        var ret = [];
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var fields = this.meta[k1].fields;
                for (var k2 in fields){
                    if (fields.hasOwnProperty(k2)){
                        var fobj = fields[k2];
                        ret.push(fobj);
                    }
                }                    
            }
        }
        return ret;
    },
    allFieldsById : function(){
        var ret = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var fields = this.meta[k1].fields;
                Object.assign(ret, fields);
            }
        }
        return ret;
    },
    step3props: function(){
        if (this.step.now == 3){
            if (this.activeTabObjectId && this.meta.hasOwnProperty(this.activeTabObjectId)){
                var recs = Object.keys(this.meta[this.activeTabObjectId].data);
                var ret = {};
                
                //Rule - Simple
                if (this.rule.simple.hasOwnProperty(this.activeTabObjectId)){
                    var props = this.rule.simple[this.activeTabObjectId].rules;
                    ret['simple'] = [];
                    for (var i=0; i<recs.length; i++){
                        var prop = 
                            props.hasOwnProperty(recs[i]) && props[recs[i]].hasOwnProperty('probability') && (props[recs[i]].probability > 0) ? props[recs[i]].probability * 100:
                        0;
                        ret['simple'].push(prop);    
                    }
                }
                
                //Rule - Mix
                if (this.rule.mix.hasOwnProperty(this.activeTabObjectId)){
                    var rules = this.rule.mix[this.activeTabObjectId];
                    for (var k=0; k<rules.length; k++){
                        var rule = rules[k];
                        ret[rule.id] = [];
                        for (var i=0; i<recs.length; i++){
                            var prop = 
                                rule.hasOwnProperty('rules') && rule.rules.hasOwnProperty(recs[i]) && rule.rules[recs[i]].hasOwnProperty('probability') && (rule.rules[recs[i]].probability > 0) ? rule.rules[recs[i]].probability * 100:
                            0;
                            ret[rule.id].push(prop);    
                        }                        
                    }                    
                }
                
                return ret;
                
            }
        }
        return {};
    },
    deletableObject : function(){
        var ret = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                ret[k1] = true;
            }
        }
        for (var k1 in this.rule.mix){
            if (this.rule.mix.hasOwnProperty(k1)){
                if (this.rule.mix[k1].length > 0){
                    ret[k1] = false;
                    var rules = this.rule.mix[k1];
                    for (var i=0; i<rules.length; i++){
                        var conditions = rules[i].conditions;
                        for (var j=0; j<conditions.length; j++){
                            var elm = conditions[j];
                            ret[elm.base] = false;
                        }
                    }
                }
            }
        }
        return ret;
    },
    stepEditable : function(){
        var ret = {
            1: true,
            2: true,
            3: true,
            4: true
        }
        if (this.objectTab.editMode == true){
            ret[1] = false;
            ret[2] = false;
            ret[3] = false;
            ret[4] = false;
        } else if (!(Object.keys(this.meta).length > 0)){
            ret[2] = false;
            ret[3] = false;
            ret[4] = false;
        } else if (!(this.isValidStep[1] && this.isValidStep[2])) {
            ret[3] = false;
            ret[4] = false;
        } else {
            var isLackRecord = false;
            for (var k1 in this.meta){
                if (this.meta.hasOwnProperty(k1)){
                    var count = Object.keys(va.meta[k1].data).length;
                    if (!(count > 0)){
                        isLackRecord = true; 
                    }
                }
            }
            if (isLackRecord){
                ret[3] = false; 
                ret[4] = false; 
            }
            
        }
        return ret;
    },
    keyFieldOptions: function(){
        var ret = [];
        if (this.objectTab.active != 'newobject'){
            for (var k1 in this.meta[this.objectTab.active].fields){
                if (this.meta[this.objectTab.active].fields.hasOwnProperty(k1)){
                    ret.push({
                        text: this.meta[this.objectTab.active].fields[k1].label,
                        value: k1
                    });
                }
            }
        }
        return ret;
    },
    relation : function(){
        var ret = {};
        var targets = [];
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                ret[k1] = {
                    relations: [k1]
                }
                targets.push(k1);
            }
        }
        var cno = {};
        for (var k1 in this.rule.mix){
            if (this.rule.mix.hasOwnProperty(k1)){
                var idx = targets.indexOf(k1);
                if (idx >= 0){
                    targets.splice(idx, 1);
                }
                var rules = this.rule.mix[k1]; 
                for (var i=0; i<rules.length;i++){
                    var conditions = rules[i].conditions;
                    for (var j=0; j<conditions.length;j++){
                        var target = conditions[j].base;
                        if (!cno.hasOwnProperty(target)) cno[target] = {};
                        if (!cno[target].hasOwnProperty(k1)) cno[target][k1] = true;
                        cno[target][k1] = true;
                    }
                }
            }
        }
        var finished = Object.keys(cno).length > 0 ? false: true;
        var count = 0;
        while (!finished && count < (Object.keys(this.meta).length * 2)){
            count ++;
            var ary = [];
            for (var i=0; i<targets.length; i++){
                var from = targets[i];
                if (cno.hasOwnProperty(from)){
                    for (var to in cno[from]){
                        if (cno[from].hasOwnProperty(to)){
                            var nxt = to;
                            if (ary.indexOf(to) == -1) ary.push(to);
                            for (var k1 in ret){
                                if(ret.hasOwnProperty(k1)){
                                    if (ret[k1].relations.indexOf(to) >= 0){
                                        for (var j=0; j<ret[from].relations.length; j++){  
                                            if(ret[k1].relations.indexOf(ret[from].relations[j]) == -1){
                                                ret[k1].relations.push(ret[from].relations[j]); 
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }   
                }                
            }
            if (ary.length > 0){
                targets = ary;
            } else {
                finished = true;
            }
        }
        return ret;
    },
    canAdjustSliders : function(){
        var ret = true;
        if (Object.keys(this.lens.filter).length > 0){
            var to = this.lens.group.object;
            for (var k1 in this.lens.filter){
                if (this.lens.filter.hasOwnProperty(k1)){
                    var from = k1;
                    if (!_validRelation(this.relation[from].relations,to)){
                        ret = false;
                        break;
                    }
                }
            }   
        }
        return ret;
    },
    canFilterObject : function(){
        var ret = [];
        var to = this.lens.group.object;
        for (var k1 in this.objectFilterItemsOption){
            if (this.objectFilterItemsOption.hasOwnProperty(k1)){
                var from = this.objectFilterItemsOption[k1].value;
                if (from != to){
                    ret[from] = _validRelation(this.relation[from].relations, to);   
                }                
            }            
        }
        return ret;
    },
    sheaders: function(){
        var ret = [];
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var flds = this.meta[k1].fields;
                for (var k2 in flds){
                    if (flds.hasOwnProperty(k2)){                    
                        ret.push({
                            value: flds[k2].id,
                            name: flds[k2].name,
                            sortable: true,
                            text: flds[k2].label,
                            align: (flds[k2].type == 'Number' ? 'right': 'left') 
                        });
                    }
                }
            }
        }
        return ret;
    },
    tryFilterItems : function(){
        var ret = [];
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1) && !this.lens.filter.hasOwnProperty(k1)){
                ret.push({
                    text: this.meta[k1].alias,
                    value: k1
                });
            }
        }
        return ret;
    },
    _tryFilterItemFields : function(){
        var ret = [];
        if (this.meta[this.lens.group.object]){
            var flds = this.meta[this.lens.group.object].fields;            
            for (var k1 in flds){
                if (flds.hasOwnProperty(k1)){
                    ret.push({
                        text: flds[k1].label,
                        value: k1
                    });
                }
            }
        }
        return ret;
    },
    sfdc0headers : function(){
        var tgs = [{
            label: 'Label', value: 'id_label'
        }, {
            label: 'API Name', value: 'id_name'
        },{ 
            label: 'Data Type', value: 'id_type'
        },{
            label: '', value: 'joint'
        },{
            label: 'Label', value: 'sfdc_label'
        }, {
            label: 'API Name', value: 'sfdc_name'
        },{ 
            label: 'Data Type', value: 'sfdc_type'
        }];
        var ret = [];
        for (var i=0; i<tgs.length; i++){
            ret.push({
                value: tgs[i].value,
                sortable: false,
                text: tgs[i].label,
                align: 'left' 
            });
        }
        return ret;
    },
    sfdc0items : function(){        
        var ret = [];
        if (this.sfdc2items && this.sfdc2items.length > 0){            
            for (var i=0; i<this.sfdc2items.length; i++){
                var item =  this.sfdc2items[i];
                var fid = this.rule.master.salesforce.mappings[item.name];
                if (fid && this.allFieldsById.hasOwnProperty(fid)){
                    ret.push({
                        id_label: this.allFieldsById[fid].label,
                        id_name: this.allFieldsById[fid].name,
                        id_type: this.allFieldsById[fid].type,
                        target: item.name,
                        joint: true,
                        sfdc_label : item.label,
                        sfdc_name : item.name,
                        sfdc_type : item.type
                    });
                } else {
                    ret.push({
                        id_label: '',
                        id_name: '',
                        id_type: '',
                        target: item.name,
                        joint: false,
                        sfdc_label : item.label,
                        sfdc_name : item.name,
                        sfdc_type : item.type
                    });
                }
            }            
        }
        return ret;       
    },
    sfdc1headers : function(){
        var tgs = [{
            label: 'Label',
            value: 'label'
        }, {
            label: 'API Name',
            value: 'name'
        },{ 
            label: 'Data Type',
            value: 'type'
        }];
        var ret = [];
        for (var i=0; i<tgs.length; i++){
            ret.push({
                value: tgs[i].value,
                sortable: false,
                text: tgs[i].label,
                align: 'left' 
            });
        }
        return ret;
    },
    sfdc1items : function(){        
        var ret = [];
        if (this.sfdc2items && this.sfdc2items.length > 0){            
            for (var i=0; i<this.sfdc2items.length; i++){
                var item =  this.sfdc2items[i];
                var fid = this.rule.master.salesforce.mappings[item.name];
                if (fid && this.allFieldsById.hasOwnProperty(fid)){
                    ret.push({
                        label: this.allFieldsById[fid].label,
                        name: this.allFieldsById[fid].name,
                        type: this.allFieldsById[fid].type,
                        target: item.name
                    });
                } else {
                    ret.push({
                        label: '',
                        name: '',
                        type: '',
                        target: item.name
                    });
                }
            }            
        }
        return ret;       
    },
    sfdc1selectedFieldIds: function(){
        var ret = [];
        for (var k1 in this.rule.master.salesforce.mappings){
            if (this.rule.master.salesforce.mappings.hasOwnProperty(k1)){
                if (this.rule.master.salesforce.mappings[k1].length > 0){
                    ret.push(this.rule.master.salesforce.mappings[k1]);                
                }
            }
        }
        return ret;
    },
    sfdc1options : function(){
        var ro = {};
        if (this.sfdc1items){            
            for (var k1 in this.sfdc1items){
                if (this.sfdc1items.hasOwnProperty(k1)){
                    var ret = [];
                    ret.push({text: '---', value: ''});
                    var mappingFieldId = this.rule.master.salesforce.mappings[this.sfdc1items[k1].target];
                    for (var i=0; i<this.allFields.length; i++){
                        if (mappingFieldId == this.allFields[i].id || this.sfdc1selectedFieldIds.indexOf(this.allFields[i].id) == -1){
                            ret.push({
                                text: this.allFields[i].label,
                                value: this.allFields[i].id,
                                type: this.allFields[i].type
                            });
                        }
                    }
                    ro[this.sfdc1items[k1].target] = ret;
                }
            }
        }
        return ro;
    },
    sfdc1option : function(){
        var ret = [];
        for (var i=0; i<this.allFields.length; i++){
            if (this.sfdc1selectedFieldIds.indexOf(this.allFields[i].id) == -1){
                ret.push({
                    text: this.allFields[i].label,
                    value: this.allFields[i].name,
                    type: this.allFields[i].type,
                    id: this.allFields[i].id
                });
            }
        }
        return ret;
    },
    sfdc2headers : function(){
        var tgs = [{
            label: 'Label',
            value: 'label'
        }, {
            label: 'API Name',
            value: 'name'
        },{ 
            label: 'Data Type',
            value: 'type'
        }];
        var ret = [];
        for (var i=0; i<tgs.length; i++){
            ret.push({
                value: tgs[i].value,
                sortable: false,
                text: tgs[i].label,
                align: 'left' 
            });
        }
        return ret;
    },
    sfdc2items : function(){        
        var ret = [];
        if (this.isValidSfdcActiveObject && this.rule.master.salesforce && this.rule.master.salesforce.fields.length > 0){            
            for (var i = 0; i < this.rule.master.salesforce.fields.length; i++){
                var fld = this.rule.master.salesforce.fields[i];
                ret.push({
                    label : (fld.required ? '* ' + fld.label: fld.label),
                    name: fld.apiName,
                    type : fld.dataType
                });
            }
        }
        return ret;       
    },
    fheaders : function(){        
        var ret = [];
        if (this.lens.group.object && this.lens.group.field){            
            if (this.meta[this.lens.group.object] && this.meta[this.lens.group.object].fields[this.lens.group.field]){
                ret.push({
                    text : this.meta[this.lens.group.object].fields[this.lens.group.field].label,
                    value: 'groupby'
                });
                ret.push({
                    text : 'Count',
                    value: 'count'
                });
            }
        }
        return ret;
        
    },
    fitems : function(){        
        var ret = {
            total: []
        };
        if (this.lens.group.object && this.lens.group.field){
            
            for (var key in this.lens.data.data){
                if (this.lens.data.data.hasOwnProperty(key)){    
                    if (this.meta[this.lens.group.object].data.hasOwnProperty(key) &&
                        this.meta[this.lens.group.object].data[key].hasOwnProperty(this.lens.group.field)){
                        ret.total.push({
                            'groupby' : this.meta[this.lens.group.object].data[key][this.lens.group.field],
                            'count' : this.lens.data.data[key].count,
                            'dataId' : key
                        });
                    }
                }
            }
        }
        return ret;       
    },
    fitemsObj : function(){
        var ret = {
            label : [],
            data : []
        };
        for (var i=0;i<this.fitems.total.length;i++){
            ret.label.push(this.fitems.total[i].groupby);
            ret.data.push(this.fitems.total[i].count);
        } 
        return ret;
    },
    mheaders : function(){
        var tgs = [{
            label: 'Label',
            value: 'label'
        }, {
            label: 'API Name',
            value: 'name'
        },{ 
            label: 'Data Type',
            value: 'type'
        },{ 
            label: 'Format',
            value: 'format'
        }];
        var ret = [];
        for (var i=0; i<tgs.length; i++){
            ret.push({
                value: tgs[i].value,
                sortable: false,
                text: tgs[i].label,
                align: 'left' 
            });
        }
        if(ret.length > 0){
            ret.unshift({
                value: 'isKey',
                sortable: false,
                text: 'Key Field',
                align: 'right'
            });
            if (this.objectTab.editMode){
                ret.push({
                    value: 'action',
                    sortable: false,
                    text: '#',
                    align: 'left'
                });
            }
        }
        return ret;
    },
    mitems : function(){        
        var ret = [];
        if (this.meta.hasOwnProperty(this.activeTabObjectId)){
            var fields = this.meta[this.activeTabObjectId].fields;
            for (var k1 in fields){
                if (fields.hasOwnProperty(k1)){    
                    ret.push({
                        'label' : fields[k1].label,
                        'name' : fields[k1].name,
                        'type' : fields[k1].type,
                        'fid' : k1
                    });
                }
            }
        }
        return ret;       
    },
    cheaders : function(){
        var ret = [];
        if (this.page.importCsvDialog.hasOwnProperty('fields')){
            var headers = this.page.importCsvDialog.fields;
            for (var i=0; i<headers.length; i++){
                ret.push({
                    value: 'field' + (i + 1),
                    sortable: false,
                    text: headers[i],
                    align: 'right' 
                });
            }
        }
        return ret;
    },
    citems : function(){
        var ret = [];
        if (this.page.importCsvDialog.hasOwnProperty('fileData') && this.page.importCsvDialog.hasOwnProperty('fields')){
            var bodys = this.page.importCsvDialog.fileData.data;
            var headers = this.page.importCsvDialog.fields;
            var mx = bodys.length > 1000 ? 1000 : bodys.length;
            for (var i=1; i<mx; i++){
                var row = {}
                for (var j=0; j<headers.length; j++){
                    row['field' + (j + 1)] = bodys[i][j];
                }
                ret.push(row);
            }
        }
        return ret;
    },
    npfcHeaders : function(){
        var ret = [];
        if (this.page.importCsvDialog.hasOwnProperty('fileData') && this.page.newProjectFromCsv.hasOwnProperty('fields')){
            var headers = this.page.newProjectFromCsv.fields;
            for (var i=0; i<headers.length; i++){
                ret.push({
                    value: 'field' + (i + 1),
                    sortable: false,
                    text: headers[i],
                    align: 'right' 
                });
            }
        }
        return ret;
    },
    npfcItems : function(){
        var ret = [];
        if (this.page.newProjectFromCsv.hasOwnProperty('fields')){
            var bodys = this.page.newProjectFromCsv.fileData.data;
            var headers = this.page.newProjectFromCsv.fields;
            var mx = bodys.length > 100 ? 100 : bodys.length;
            for (var i=1; i<mx; i++){
                var row = {}
                for (var j=0; j<headers.length; j++){
                    row['field' + (j + 1)] = bodys[i][j];
                }
                ret.push(row);
            }
        }
        return ret;
    },
    oheaders : function(){
        var ret = [];
        var k1 = this.objectTab.active;
        if (this.meta.hasOwnProperty(k1)){
            var flds = this.meta[k1].fields;
            for (var k2 in flds){
                if (flds.hasOwnProperty(k2)){                    
                    ret.push({
                        value: flds[k2].id,
                        sortable: false,
                        text: flds[k2].label,
                        align: (flds[k2].type == 'Number' ? 'right': 'left') 
                    });
                }
            }
        }
        if(ret.length > 0 && this.objectTab.editMode){
            ret.push({
                value: 'action',
                sortable: false,
                text: '#',
                align: 'left'
            });
            
        }
        return ret;
    },
    activeTabObjectId : function(){
        return this.objectTab.active;  
    },
    oitems : function(){
        var ret = [];
        var k1 = this.activeTabObjectId;
        if (this.meta.hasOwnProperty(k1)){
            var data = this.meta[k1].data;
            for (var k2 in data){
                if(data.hasOwnProperty(k2)){
                    var obj = Object.assign({}, data[k2]);
                    obj.did = k2;
                    ret.push(obj);
                }
            }
        }
        return ret;        
    },    
    objectFilterItemsOption: function(){
        var arr = [];
        for (var key in this.meta){
            if(this.meta.hasOwnProperty(key)){
                if (key != this.lens.group.object){
                    arr.push({
                        text: this.meta[key].alias,
                        value: key
                    });
                }
            }
        }
        return arr; 
    },
    lensRuleId : function(){
        var ruleId = null;
        if (this.lens.group.object){
            if (Object.keys(this.lens.filter).length > 0){
                ruleId = this.lensRuleIdActual; 
            } else {
                if (this.meta.hasOwnProperty(this.lens.group.object)){
                    ruleId = this.lens.group.object;
                }
            }
        }
        return ruleId;
    },
    lensRuleIdActual : function(){
        var ruleId = null;
        if (this.lens.group.object){
            if (Object.keys(this.lens.filter).length > 0){
                if (this.rule.mix.hasOwnProperty(this.lens.group.object)){
                    var rules = this.rule.mix[this.lens.group.object];
                    for (var i=0; i<rules.length;i++){
                        if (_isMatchConditions(rules[i].conditions, this.lens.filter)){
                            ruleId = rules[i].id;
                            break;
                        }  
                    }
                }  
            } else {
                if (this.rule.simple.hasOwnProperty(this.lens.group.object)){
                    ruleId = this.lens.group.object;
                }
            }
        }
        return ruleId;
    },
    
    decisionRuleIndexByRuleId : function(){
        var ret = {};
        for (var k1 in this.rule.work.decisionRuleWithOrder){
            if(this.rule.work.decisionRuleWithOrder.hasOwnProperty(k1)){
                ret[k1] = {};
                var arr = this.rule.work.decisionRuleWithOrder[k1].slice().reverse();
                for (var i=0; i<arr.length;i++){
                    ret[k1][arr[i].id] = i;
                }
            }
        } 
        return ret;
    },
    orderedRelations : function(){
        var raw = [];
        for (var k1 in this.relation){
            if(this.meta.hasOwnProperty(k1)){
                raw.push({
                    id: k1,
                    count: this.relation[k1].relations.length
                });
            }
        }
        raw.sort(function(a,b){
            if( a.count > b.count ) return 1;
            if( a.count < b.count ) return -1;
            return 0;
        });        
        return raw;
    },
    allRules: function(){
        var _t = this;
        
        _t.setShowAllRules(_t.lens.group.object);
        var ret = {};
        for (var k1 in this.meta){
            if (this.meta.hasOwnProperty(k1)){
                var ref = {
                    id: k1,
                    alias : this.meta[k1].alias,
                    ruleCount: 0,
                    rules: []
                };
                if (k1 in this.rule.simple){
                    ref.ruleCount ++;
                    ref.rules.push({
                        mix: false,
                        id: k1
                    });
                }
                if (k1 in this.rule.mix){
                    var tgts = this.rule.mix[k1];
                    for (var i=0; i<tgts.length; i++){
                        ref.ruleCount ++;
                        var ref2 = {
                            id: this.rule.mix[k1][i].id,
                            mix: true,
                            from: []
                        };
                        var conditions = this.rule.mix[k1][i].conditions;
                        for(var j=0; j<conditions.length; j++){
                            ref2.from.push({
                                id: conditions[j].base,
                                alias: this.meta[conditions[j].base].alias
                            });
                        }
                        ref.rules.push(ref2);
                    }                        
                }
                ret[k1] = ref;
            }        
        }
        return ret;
    },
    showConditionOfNewRule : function(){
        var ret = '';
        var objs = [];
        for (var k1 in this.lens.filter){
            if (this.lens.filter.hasOwnProperty(k1)){
                var obj = this.meta[k1].alias;
                var vals = [];
                for (var i=0; i<this.lens.filter[k1].data.length; i++){
                    vals.push(myFilters.showRecord(this.meta[k1].data[this.lens.filter[k1].data[i]][this.meta[k1].keyField]));
                }
                if (this.lens.filter[k1].chip){
                    objs.push('' + obj + ' is "' + vals.join('" or "') + '"');
                }
            }
        }
        if (objs.length > 0){
            ret = 'When ' + objs.join(' AND ') + '..';
        } else {
            ret = 'General Trend'
        }
        return ret;
    }
    
    
};

var myWatch = {
    'page.objectFilterItems.data' : {
        handler: function(nv){
            var ret = {};
            for (var k1 in nv){
                if (nv.hasOwnProperty(k1) && nv[k1].length > 0){
                    var items = [];
                    for (var i=0; i<nv[k1].length; i++){
                        items.push(nv[k1][i].value);
                    }
                    ret[k1] = {
                        chip: true,
                        data: items
                    };
                }
            }
            this.$set(this.lens, 'filter', ret);
        },
        deep: true
    },
    meta : {
        handler: function(){
            this.resetRecord();
            if (this.isEditPage) this.ap.changedData = true;
        },
        deep: true
    },
    records: function(nv){ 
        this.setDecisionRuleWithOrder();
        if(!this.lens.group.object){
            this.lens.group.object = Object.keys(this.meta)[0];
        };        
        var _t = this;
        this.ap.chartActive = false;
        if (this.lens.group.object){
            window.setTimeout(function(){
                changedTryFilterItemJob(_t, _t.lens.group.object);
            }, 100); 
        }
        if (nv.length > 0){
            this.step.steps[3].editable = true;
        } else {
            this.step.steps[3].editable = false;            
        }
    },
    'rule.master.total' : function(newVal){
        if (newVal > 100000){
            this.rule.master.total = 100000;
        }
    },
    'rule.simple' : {
        handler: function(){            
            this.checkDoneLensStep();
            if (this.isEditPage) this.ap.changedData = true;
        },
        deep: true
    },
    'rule.mix' : {
        handler: function(){
            this.checkDoneLensStep();
            if (this.isEditPage) this.ap.changedData = true;
        },
        deep: true
    },
    'step.now' : function(nv){
        this.initShowAllRules();
        this.resetRecord();
        if (nv == 3){
            this._shapeUpRule();
            this.lens.group.object = this.objectTab.active;
            this.setDecisionRuleWithOrder();
            this.createRecords();
        } else if (nv != 3){
            this.ap.chartActive = false;
        }
    },
    'objectTab.editMode' : function(nv){
        if (nv == false){
            this._checkAndCorrectDataByFieldType();
            this._checkRecordData();
        } 
    },
    'objectTab.active' : function(nv){
        if (nv != 'newobject' && this.step.now == 3){
            this.lens.group.object = nv;
            this.removeAllLensFilter();        
            this.changedTryFilterItem(this.lens.group.object);
        }
    },
    'lens.data' : function(ref){
        this.calcChartValues();
        this.calcChartValues2();
        this.ap.chartActive = true;
    },
    'exportToDataset.uploadedList' : function(newList){
        if (this.exportToDataset.doneUpload && this.exportToDataset.allDataPartCount > 0){
            if (newList.length == this.exportToDataset.allDataPartCount){
                this.startImportingOnAnalytics();
            }
        }
    },
    'page.newProjectFromTemplate.lang.select' : function(nv){
        if (this.page.newProjectFromTemplate.show) this._updateAllTemplateList({lang:nv});
    },
    'page.newProjectFromTemplate.industry.select' : function(nv){
        if (this.page.newProjectFromTemplate.show) this._updateAllTemplateList({industry: nv});
    },
    'page.newProjectFromTemplate.private' : function(nv){
        if (this.page.newProjectFromTemplate.show) this._updateAllTemplateList({mine: nv});
    },
    'page.newProjectFromTemplate.favourite' : function(nv){
        if (this.page.newProjectFromTemplate.show) this._updateAllTemplateList({favourite: nv});
    }
};

var dateToDisplayDate = function(dt){
    return moment(Date.parse(dt)).format('MMM Do, YYYY');
}
var dateToDisplayTime = function(dt){
    var mt = moment(Date.parse(dt));
    if (mt.second() == 0){
        return moment(Date.parse(dt)).format('HH:mm');
    } else {
        return moment(Date.parse(dt)).format('HH:mm:ss');
    }
}
var dateToDisplayDatetime = function(dt){
    var mt = moment(Date.parse(dt));
    if (mt.second() == 0){
        return moment(Date.parse(dt)).format('MMM Do, YYYY, HH:mm');
    } else {
        return moment(Date.parse(dt)).format('MMM Do, YYYY, HH:mm:ss');
    }
}

var myFilters = {
    normalizeDate : function(dt){
        var mo = moment(dt);
        return mo.format('MMMM Do, YYYY');
    },
    showRecord : function(obj){
        if (obj.type == 'static'){
            return obj.value;
        } else if (obj.type == 'null'){
            return 'Null';
        } else if (obj.type == 'function'){
            return obj.code;
        } else if (obj.type == 'rangeNumber'){
            return obj.from + '..' + obj.to + ' (Step: ' + obj.step + ')';
        } else if (obj.type == 'rangeDate'){
            if (obj.fromTo && obj.fromTo.length == 2){
                return dateToDisplayDate(obj.fromTo[0]) + ' - ' + dateToDisplayDate(obj.fromTo[1]);
            }
        } else if (obj.type == 'rangeRelativeDate'){
            if (obj.hasOwnProperty('range') && obj.range){
                var range = ~obj.range.indexOf('y') ? 'year': ~obj.range.indexOf('w') ? 'week': ~obj.range.indexOf('m') ? 'month': ~obj.range.indexOf('d') ? 'day': null;
                var single = obj.diff && obj.diff == 1? true: false;
                if (range){
                    if (~obj.range.indexOf('t')){
                        if (range == 'day'){
                            return 'Today';
                        } else {
                            return 'This ' + range;      
                        }
                    } else if (~obj.range.indexOf('a')){
                        if (single){
                            if (range == 'day'){
                                return 'Yesterday';
                            } else {
                                return 'Last ' + range;      
                            }
                        } else {
                            return obj.diff + ' ' + range + 's ago';
                        }
                    } else if (~obj.range.indexOf('l')){
                        if (single){
                            if (range == 'day'){
                                return 'Tomorrow';
                            } else {
                                return 'Next ' + range;
                            }
                        } else {
                            return obj.diff + ' ' + range + 's later';
                        }                    
                    }
                }
            }
        } else if (obj.type == 'rangeRelativeDateAndTime'){
            if (obj.hasOwnProperty('range') && obj.range && obj.fromToTime && obj.fromToTime.length == 2){
                var showTime = dateToDisplayTime(obj.fromToTime[0]) + ' - ' + dateToDisplayTime(obj.fromToTime[1]);
                var range = ~obj.range.indexOf('y') ? 'year': ~obj.range.indexOf('w') ? 'week': ~obj.range.indexOf('m') ? 'month': ~obj.range.indexOf('d') ? 'day': null;
                var single = obj.diff && obj.diff == 1? true: false;
                if (range){
                    if (~obj.range.indexOf('t')){
                        if (range == 'day'){
                            return 'Today / ' + showTime;
                        } else {
                            return 'This ' + range + ' / ' + showTime;                            
                        }
                    } else if (~obj.range.indexOf('a')){
                        if (single){
                            if (range == 'day'){
                                return 'Yesterday / ' + showTime;
                            } else {
                                return 'Last ' + range + ' / ' + showTime;
                            }
                            
                        } else {
                            return obj.diff + ' ' + range + 's ago' + ' / ' + showTime;
                        }
                    } else if (~obj.range.indexOf('l')){
                        if (single){
                            if (range == 'day'){
                                return 'Tomorrow / ' + showTime;
                            } else {
                                return 'Next ' + range + ' / ' + showTime;
                            }
                        } else {
                            return obj.diff + ' ' + range + 's later' + ' / ' + showTime;
                        }                    
                    }
                }
            }
        } else if (obj.type == 'rangeDatetime'){
            if (obj.fromToDateTime && obj.fromToDateTime.length == 2){
                return dateToDisplayDatetime(obj.fromToDateTime[0]) + ' - ' + dateToDisplayDatetime(obj.fromToDateTime[1]);
            }
        } else if (obj.type == 'rangeDateAndTime'){
            if (obj.fromToTime && obj.fromToTime.length == 2 && obj.fromToDate && obj.fromToDate.length == 2){
                return  dateToDisplayTime(obj.fromToTime[0]) + ' - ' + dateToDisplayTime(obj.fromToTime[1]) + ' / ' + 
                    dateToDisplayDate(obj.fromToDate[0]) + ' - ' + dateToDisplayDate(obj.fromToDate[1]);
            }
        }
        return '(Unknown)';
        
    }
};

//Vue.config.performance = true;
Vue.use(VueCharts);

/* Data Gen API */
var dataGenAPI = axios.create({
    baseURL: myData.constant.dataGenApiUrl,
    timeout: 60000,
    headers: {
        'Content-Type': 'application/json'
    }
});
var dataGenPost = function(_t, form, func1, func2){
    _t.$set(_t.page.dataGenDialog, 'loading', true);
    dataGenAPI.post('', form).then(function(res){
        if (func1) func1(res);
    }).catch(function (err) {
        va._showError('[DATA GEN API Error] ' + err);
        va.apt = false;
        if (func2) func2(err);
    }).then(function(){
        _t.$set(_t.page.dataGenDialog, 'loading', false);
    });    
};
/* Data Gen API */


var forceAPI = axios.create({
    baseURL: ENDPOINT + VERSION,
    timeout: 60000,
    headers: {
        'Authorization': 'Bearer ' + ACCESS_TOKEN,
        'Content-Type': 'application/json'
    }
});


var forceGet = function(_t, _url, func1, func2){
    _t.$set(_t.force, url, null);
    var url = _url.replace(VERSION, '').replace(/^\//, '');
    forceAPI.get(url).then(function(res){
        _t.$set(_t.force, url, res.data);    
        if (func1) func1(res);
    }).catch(function (err) {
        va._showError('[API Error] ' + err);
        va.apt = false;
        if (func2) func2(err);
    });    
};

var forcePost = function(_t, _url, form, func1, func2){
    _t.$set(_t.force, url, null);
    var url = _url.replace(VERSION, '').replace(/^\//, '');
    forceAPI.post(url, form).then(function(res){
        _t.$set(_t.force, url, res.data);    
        if (func1) func1(res);
    }).catch(function (err) {
        va._showError('[API Error] ' + err);
        va.apt = false;
        if (func2) func2(err);
    });    
};
var forcePatch = function(_t, _url, form, func1, func2){
    _t.$set(_t.force, url, null);
    var url = _url.replace(VERSION, '').replace(/^\//, '');
    forceAPI.patch(url, form).then(function(res){
        _t.$set(_t.force, url, res.data);    
        if (func1) func1(res);
    }).catch(function (err) {
        va._showError('[API Error] ' + err);
        va.apt = false;
        if (func2) func2(err);
    });    
};
var forcePut = function(_t, _url, form, config, func1, func2){
    _t.$set(_t.force, url, null);
    var url = _url.replace(VERSION, '').replace(/^\//, '');
    forceAPI.put(url, form, config).then(function(res){
        _t.$set(_t.force, url, res.data);    
        if (func1) func1(res);
    }).catch(function (err) {
        va._showError('[API Error] ' + err);
        va.apt = false;
        if (func2) func2(err);
    });    
};

var _isMatchConditions = function(conditions, filter){
    var ret = false;
    for (var i = 0; i<conditions.length; i++){
        if (filter.hasOwnProperty(conditions[i].base)){
            if (_sameArrays(conditions[i].values, filter[conditions[i].base].data)){
                ret = true;
            } else {
                ret = false;
                break;
            }
        } else {
            ret = false;
            break;
        }
    }   
    if (ret){
        if (conditions.length != Object.keys(filter).length){
            ret = false;  
        }
    }
    return ret;
};

var _sameArrays = function(arr1, arr2){
    var ret = false;
    if (arr1.length > 0 && arr1.length == arr2.length){
        for (var i=0; i<arr1.length; i++){
            var count = 0;
            for (var j=0; j<arr2.length; j++){
                if (arr1[i] == arr2[j]){
                    count ++;
                }
            }
            if(count == 1){
                ret = true;
            } else {
                ret = false;
                break;
            }
        }
    }
    return ret;
};

var _isValidRelation = function(froms, tos){
    var count = 0;
    var ret = false;
    if (froms.length > 0 && tos.length > 0){
        for(var i=0; i<froms.length; i++){
            for(var j=0; j<tos.length; j++){
                if (froms[i] == tos[j]){
                    count ++;
                    break;
                }
            }   
        }
        if (count == froms.length || count == 0){
            ret = true;
        }        
    }
    return ret;
};

var _validRelation = function(froms, to){
    var ret = false;
    if (froms.indexOf(to) == -1) ret = true;
    return ret;
};


var randDate = function(mo1, mo2){
    var diff = mo2.diff(mo1, 'days');
    var addDays = rand(0, diff, 1);
    var mo = mo1.add(addDays, 'days');
    return mo;
};

var randDatetime = function(mo1, mo2){
    var range = mo1.second() == 0 && mo2.second() == 0 ? 'minutes': 'seconds'; 
    var diff = mo2.diff(mo1, range);
    var add = rand(0, diff, 1);
    var mo = mo1.add(add, range);
    return mo;
};

var rand = function(min, max, step){
    if (!(step && step > 0)){
        step = 1;
    }
    step = Number(step);
    max = Number(max);
    min = Number(min)
    var diff = max - min;
    var total = Math.floor(diff / step);
    var rand = Math.floor(Math.random() * (total + 1));
    var ret = min + rand * step;
    var ns = String(step).split('.');
    var dl = 0;
    if (ns.length == 2){
        dl = ns[1].length;        
    }
    return Number(ret.toFixed(dl));
};

var row = function(...args){
    if (args.length > 0){
        return null;  
    } else {
        return 1;
    }
}

var _val = function(nam){
    var flds = va.allFields;
    var ret;
    for (var i=0; i<flds.length; i++){
        var apn = flds[i].name;
        if (apn == nam){
            ret = va._normalizeFieldValue({type: 'static', value: ''}, flds[i].name);
        }
    }
    return ret;
};
var val = function(nam){
    var flds = va.allFields;
    var ret;
    for (var i=0; i<flds.length; i++){
        var apn = flds[i].name;
        if (apn == nam){
            if (flds[i].type == 'String'){
                ret = 'Dummy data';
            } else if (flds[i].type == 'Number'){
                ret = flds[i].format;
            } else if (flds[i].type == 'Date' || flds[i].type == 'DateTime'){
                ret = flds[i].format.replace(/[yMdHhmsS]/g, '1');
            }
        }
    }
    return ret;
};

var _simplifyDecimal = function(val){
    if (val == 0){
        return 0;
    } else if (val > 0){
        return (Math.round(val * 100) / 100);
    } else {
        return 0;
    }
};

var changedTryFilterItemJob = function(_t, newObj){
    var ref = {
        data: {},
        rule: {}
    };
    if (newObj && _t.meta[newObj]){
        var dats = _t.meta[newObj].data;
        for (var k1 in dats){
            if(dats.hasOwnProperty(k1)){
                ref.data[k1] = {
                    label: _t.meta[newObj].data[k1][_t.meta[newObj].keyField],
                    id: k1,
                    count: 0,
                    detail: {}
                };
                for (var j=0; j<_t.rule.work.decisionRuleWithOrder[newObj].length; j++){
                    ref.data[k1].detail[_t.rule.work.decisionRuleWithOrder[newObj][j].id] = {
                        count: 0
                    }
                }
            }                
        }
        var rules = _t.rule.work.decisionRuleWithOrder[newObj];
        for (var i=0; i<rules.length;i++){
            ref.rule[rules[i].id] = 0;
        }
        for (var i=0; i<_t.mrecords.length; i++){
            
            // Check if meet the filter conditions
            var pass = true;
            for (var key in _t.lens.filter){
                if (_t.lens.filter.hasOwnProperty(key)){
                    var targets = _t.lens.filter[key].data;
                    if (targets.length > 0){
                        if (targets.indexOf(_t.mrecords[i][key]) == -1){
                            pass = false;
                            break;
                        }
                    }    
                }                    
            }
            
            if (pass){
                ref.data[_t.mrecords[i][_t.lens.group.object]].count ++;
                var matchRuleId = _t.whichRule(newObj, _t.mrecords[i]).ruleId;
                ref.data[_t.mrecords[i][_t.lens.group.object]].detail[matchRuleId].count ++;
                ref.rule[matchRuleId] ++;
            }
        }
        _t.lens.group.field = _t.meta[newObj].keyField;
    }
    _t.$set(_t.lens, 'data', ref);
};

var va = new Vue({
    el: '#app',
    data: myData,
    methods: myMethods,
    computed: myComputed,
    watch: myWatch,
    mounted: function(){
        this.appInit();
        this.onResize();
        this.init();
        this.userSetForTracking();
        window.addEventListener('wheel', this.handleScroll);
        window.addEventListener('popstate', this.handlePopState);
        window.addEventListener('keydown', this.handleKeyDown);        
    },
    filters: myFilters
});


