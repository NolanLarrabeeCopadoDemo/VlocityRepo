import { LightningElement,wire,track} from 'lwc';
import getRedeemPointsProductCategoriesList from '@salesforce/apex/B2BCommunitiesRedemptionController.getRedeemPointsProductCategoriesList';

export default class NTOProductCatalog extends LightningElement {
    showFilter = true;
    breadcrumb = "HOME / MEN / JACKETS & VESTS";
    @track accounts;
    @track error;
    @track products=[];

    @wire(getRedeemPointsProductCategoriesList)
    wiredAccounts({ error, data }) {

        if (data) {
            this.allListViews = data;
            var listViewData = [];
            for(var i=0;i<this.allListViews.length;i++){
                var productImageUrl =  this.allListViews[i].Product_Image_Name__c;
                console.log('::::his.allListViews[i].Product__Image__c:::'+this.allListViews[i].Product_Image_Name__c);
                var nameProductVoucher;
                if(this.allListViews[i].RedemptionType__r.Name == 'Product'){
                    nameProductVoucher = this.allListViews[i].Product__r.Name;
                }
                else{
                    nameProductVoucher = this.allListViews[i].VoucherDefinitionId__r.Name;
                }
                listViewData.push({  "productName" : nameProductVoucher, "productPrice":this.allListViews[i].Points__c,"productImageUrl": productImageUrl ,"productId": this.allListViews[i].Product__c, "partnerId": this.allListViews[i].Partner__c, "journalSubtypeId":this.allListViews[i].RedemptionType__c, "voucherDefinitionId" : this.allListViews[i].VoucherDefinitionId__c, "category": this.allListViews[i].ProductCategory__c });
            }
            this.products = listViewData;
            //console.log('An error has occurred:'+JSON.parse(this.products));
        } else if (error) {
            console.log('An error has occurred:');
            console.log(error);
            // handle your error.
        }
    }
   
    
}