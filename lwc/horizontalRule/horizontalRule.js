import { LightningElement,api, track } from 'lwc';

export default class HorizontalRule extends LightningElement {


@api hrColor = "";
@api hrStyle= "";
@api hrSize="";
@api hrWidth="";

renderedCallback(){
    var myhrcolor = this.template.querySelector('hr').style.cssText = 'margin:auto;width:'+(this.hrWidth)+';border-top:'+(this.hrSize)+'px '+(this.hrStyle)+' ' +(this.hrColor);
  
}
}