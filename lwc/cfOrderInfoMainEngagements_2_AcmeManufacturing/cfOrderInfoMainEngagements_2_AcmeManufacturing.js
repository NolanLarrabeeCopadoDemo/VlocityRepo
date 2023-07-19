import { FlexCardMixin } from "omnistudio/flexCardMixin";
    import {interpolateWithRegex, interpolateKeyValue, loadCssFromStaticResource } from "omnistudio/flexCardUtility";
    import { load } from "omnistudio/newportLoader";
          
          import { LightningElement, api, track, wire } from "lwc";
          import pubsub from "omnistudio/pubsub";
          import { getRecord } from "lightning/uiRecordApi";
          
          import data from "./definition";
          
          import styleDef from "./styleDefinition";
              
          export default class cfOrderInfoMainEngagements_2_AcmeManufacturing extends FlexCardMixin(LightningElement){
              @api debug;
              @api recordId;
              @api objectApiName;
              
              @track record;
              
              
              pubsubEvent = [];
              customEvent = [];
              
              connectedCallback() {
                super.connectedCallback();
                this.setStyleDefinition(styleDef);
                data.Session = {} //reinitialize on reload
                
                
                
                
                
                
                load(this)
                .then(() => {
                  this.setDefinition(data); 
 this.registerEvents();
                  this.isProcessing = false;
                  //this.isNewport = false;
                })
                .catch(() => {
                  this.setDefinition(data); 
 this.registerEvents();
                });
                
              }
              
              disconnectedCallback(){
                super.disconnectedCallback();
                    
                    

                  this.unregisterEvents();
              }

              registerEvents() {
                
              }

              unregisterEvents(){
                
              }
            
              renderedCallback() {
                super.renderedCallback();
                
              }
          }