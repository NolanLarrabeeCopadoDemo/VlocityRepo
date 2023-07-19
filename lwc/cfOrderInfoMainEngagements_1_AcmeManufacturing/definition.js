let definition =
      {"states":[{"fields":[],"conditions":{"id":"state-condition-object","isParent":true,"group":[]},"definedActions":{"actions":[]},"name":"Active","isSmartAction":false,"smartAction":{},"styleObject":{"padding":[{"type":"around","size":"x-small","label":"around:x-small"}],"margin":[{"type":"around","size":"none","label":"around:none"}],"container":{"class":"nds-card"},"size":{"isResponsive":false,"default":"12"},"sizeClass":"nds-size_12-of-12 ","class":"nds-theme_default nds-card nds-p-around_x-small nds-m-around_none ","background":{"color":"","image":"","size":"","repeat":"","position":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","theme":"theme_default","style":"      \n         "},"components":{"layer-0":{"children":[{"name":"Block","element":"block","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"nds-col ","property":{"label":"Block","collapsible":false,"record":"{record}","collapsedByDefault":false,"card":"{card}"},"type":"block","styleObject":{"padding":[{"type":"around","size":"x-small"}],"class":"nds-p-around_x-small","sizeClass":"nds-size_12-of-12"},"children":[{"key":"element_element_block_0_0_flexIcon_0_0","name":"Icon","element":"flexIcon","size":{"isResponsive":true,"default":"1","large":"1","medium":"1","small":"1"},"stateIndex":0,"class":"nds-col ","property":{"record":"{record}","card":"{card}","iconType":"Salesforce SVG","iconName":"action:approval","size":"medium","extraclass":"slds-icon_container slds-icon-action-approval slds-icon_container--circle","variant":"success","imgsrc":""},"type":"element","styleObject":{"sizeClass":"nds-large-size_1-of-12 nds-medium-size_1-of-12 nds-small-size_1-of-12 nds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"1","large":"1","medium":"1","small":"1"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"parentElementKey":"element_block_0_0","elementLabel":"Block-0-Icon-0","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"nds-large-size_1-of-12 nds-medium-size_1-of-12 nds-small-size_1-of-12 nds-size_1-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"1","large":"1","medium":"1","small":"1"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]},{"key":"element_element_block_0_0_outputField_1_0","name":"Text","element":"outputField","size":{"isResponsive":true,"default":"10","large":"10","medium":"10","small":"10"},"stateIndex":0,"class":"nds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3EGreat%20News%20-%20No%20delays%20in%20%7BAccountName%7D%20Orders%3C/div%3E","card":"{card}"},"type":"text","styleObject":{"sizeClass":"nds-large-size_10-of-12 nds-medium-size_10-of-12 nds-small-size_10-of-12 nds-size_10-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"10","large":"10","medium":"10","small":"10"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"parentElementKey":"element_block_0_0","elementLabel":"Block-0-Text-1","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"nds-large-size_10-of-12 nds-medium-size_10-of-12 nds-small-size_10-of-12 nds-size_10-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"10","large":"10","medium":"10","small":"10"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]}],"elementLabel":"Block-0"}]}},"childCards":[],"actions":[],"omniscripts":[],"documents":[],"blankCardState":true},{"fields":[],"conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-35","field":"Delayed","operator":"==","value":"true","type":"custom","hasMergeField":false}]},"name":"Issue","isSmartAction":false,"smartAction":{},"styleObject":{"padding":[{"type":"around","size":"x-small","label":"around:x-small"}],"margin":[{"type":"around","size":"none","label":"around:none"}],"container":{"class":""},"size":{"isResponsive":true,"default":"12","large":"12","medium":"12","small":"12"},"sizeClass":"nds-large-size_12-of-12 nds-medium-size_12-of-12 nds-small-size_12-of-12 nds-size_12-of-12 ","class":"nds-theme_alert-texture nds-border_top nds-border_right nds-border_bottom nds-border_left nds-p-around_x-small nds-m-around_none ","background":{"color":"","image":"","size":"","repeat":"","position":""},"border":{"type":["border_top","border_right","border_bottom","border_left"],"width":"3","color":"#FDBB37","radius":"25","style":"solid"},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","style":"     border-top: #FDBB37 3px solid;border-right: #FDBB37 3px solid;border-bottom: #FDBB37 3px solid;border-left: #FDBB37 3px solid; \n    border-radius:25;     ","theme":"theme_alert-texture"},"blankCardState":false,"components":{"layer-0":{"children":[{"name":"Block","element":"block","size":{"isResponsive":true,"default":"12","large":"12","medium":"12","small":"12"},"stateIndex":1,"class":"nds-col ","property":{"label":"\\Order {OrderNumber} Delayed","collapsible":true,"record":"{record}","collapsedByDefault":true,"card":"{card}"},"type":"block","styleObject":{"padding":[{"type":"around","size":"x-small","label":"around:x-small"}],"class":"nds-text-align_left nds-p-around_x-small ","sizeClass":"nds-large-size_12-of-12 nds-medium-size_12-of-12 nds-small-size_12-of-12 nds-size_12-of-12 ","margin":[],"background":{"color":"","image":"","size":"","repeat":"no-repeat","position":""},"size":{"isResponsive":true,"default":"12","large":"12","medium":"12","small":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"left","color":""},"inlineStyle":"","style":"  background-repeat:no-repeat;    \n         "},"children":[{"name":"Delayed","element":"outputField","size":{"isResponsive":true,"default":"6","large":"6","medium":"6","small":"6"},"stateIndex":1,"class":"nds-col ","property":{"placeholder":"","record":"{record}","fieldName":"OrderNumber","label":"Order Number","card":"{card}","type":"text","styles":{"label":{"fontSize":"1em"}}},"type":"field","styleObject":{"sizeClass":"nds-large-size_6-of-12 nds-medium-size_6-of-12 nds-small-size_6-of-12 nds-size_6-of-12 ","size":{"isResponsive":true,"default":"6","large":"6","medium":"6","small":"6"},"padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"styles":{"label":{"fontSize":"1em"}}},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"elementLabel":"Block-0-OrderNumber-0","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"nds-large-size_6-of-12 nds-medium-size_6-of-12 nds-small-size_6-of-12 nds-size_6-of-12 ","size":{"isResponsive":true,"default":"6","large":"6","medium":"6","small":"6"},"padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"styles":{"label":{"fontSize":"1em"}}},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_0_1_outputField_0_1","parentElementKey":"element_block_0_1","userUpdatedElementLabel":true},{"key":"element_element_block_0_1_outputField_1_1","name":"DelayReason","element":"outputField","size":{"isResponsive":false,"default":6},"stateIndex":1,"class":"nds-col ","property":{"placeholder":"","record":"{record}","fieldName":"DelayReason","label":"Delay Reason","card":"{card}","type":"text"},"type":"field","styleObject":{"size":{"isResponsive":false,"default":6},"sizeClass":"nds-size_6-of-12"},"parentElementKey":"element_block_0_1","elementLabel":"Block-0-DelayReason-1"},{"key":"element_element_block_0_1_outputField_2_1","name":"ShippingCity","element":"outputField","size":{"isResponsive":true,"default":"12","large":"6","medium":"6","small":"6"},"stateIndex":1,"class":"nds-col ","property":{"placeholder":"","record":"{record}","fieldName":"ShippingCity","label":"Shipping Location","card":"{card}","type":"text"},"type":"field","styleObject":{"sizeClass":"nds-large-size_6-of-12 nds-medium-size_6-of-12 nds-small-size_6-of-12 nds-size_12-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"12","large":"6","medium":"6","small":"6"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"parentElementKey":"element_block_0_1","elementLabel":"Block-0-ShippingCity-2","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"nds-large-size_6-of-12 nds-medium-size_6-of-12 nds-small-size_6-of-12 nds-size_12-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"12","large":"6","medium":"6","small":"6"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]},{"name":"StartDate","element":"outputField","size":{"isResponsive":true,"default":"12","large":"6","medium":"6","small":"6"},"stateIndex":1,"class":"nds-col ","property":{"placeholder":"","record":"{record}","fieldName":"StartDate","label":"Start Date","card":"{card}","type":"text"},"type":"field","styleObject":{"sizeClass":"nds-large-size_6-of-12 nds-medium-size_6-of-12 nds-small-size_6-of-12 nds-size_12-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"12","large":"6","medium":"6","small":"6"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"elementLabel":"Block-0-StartDate-3","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"nds-large-size_6-of-12 nds-medium-size_6-of-12 nds-small-size_6-of-12 nds-size_12-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"12","large":"6","medium":"6","small":"6"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_0_1_outputField_3_1","parentElementKey":"element_block_0_1"},{"name":"Action","element":"action","size":{"isResponsive":true,"default":"2","large":"2","medium":"2","small":"2"},"stateIndex":1,"class":"nds-col ","property":{"stateObj":"{record}","card":"{card}","record":"{record}","displayAsButton":false,"buttonVariant":"neutral","iconOnly":true,"iconSize":"medium","iconColor":"#4176D3","actionList":[{"stateObj":"{record}","card":"{card}","record":"{record}","stateAction":{"id":"flex-action-1637712838565","type":"Custom","displayName":"Modify Order","vlocityIcon":"utility:edit","targetType":"Record","openUrlIn":"New Tab/Window","Record":{"targetAction":"edit","targetId":"{OrderId}","targetName":"Order"}},"displayAsButton":false,"buttonVariant":"neutral","iconOnly":true,"iconSize":"medium","iconColor":"#4176D3"}],"label":"Modify Order","iconName":"utility:edit","showSpinner":"false","hideActionIcon":false},"type":"element","styleObject":{"sizeClass":"nds-large-size_2-of-12 nds-medium-size_2-of-12 nds-small-size_2-of-12 nds-size_2-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"2","large":"2","medium":"2","small":"2"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"iconSize":"medium","iconColor":"#4176D3"},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n     height:25px;    ","height":"25px"},"elementLabel":"Block-0-Action-4","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"nds-large-size_2-of-12 nds-medium-size_2-of-12 nds-small-size_2-of-12 nds-size_2-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":true,"default":"2","large":"2","medium":"2","small":"2"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"iconSize":"medium","iconColor":"#4176D3"},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n     height:25px;    ","height":"25px"},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_0_1_action_4_1","parentElementKey":"element_block_0_1"},{"name":"Action","element":"action","size":{"isResponsive":true,"default":"2","large":"2","medium":"2","small":"2"},"stateIndex":1,"class":"nds-col ","property":{"stateObj":"{record}","card":"{card}","record":"{record}","iconOnly":true,"iconSize":"medium","iconColor":"#4176D3","actionList":[{"stateObj":"{record}","card":"{card}","record":"{record}","stateAction":{"id":"flex-action-1637731479994","type":"Custom","displayName":"View Order","vlocityIcon":"utility:preview","targetType":"Record","openUrlIn":"New Tab/Window","Record":{"targetName":"Order","targetAction":"view","targetId":"{OrderId}"}},"iconOnly":true,"iconSize":"medium","iconColor":"#4176D3"}],"label":"View Order","iconName":"utility:preview","showSpinner":"false"},"type":"element","styleObject":{"size":{"isResponsive":true,"default":"2","large":"2","medium":"2","small":"2"},"sizeClass":"nds-large-size_2-of-12 nds-medium-size_2-of-12 nds-small-size_2-of-12 nds-size_2-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"iconSize":"medium","iconColor":"#4176D3"},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"elementLabel":"Block-0-Action-5","styleObjects":[{"key":0,"conditions":"default","styleObject":{"size":{"isResponsive":true,"default":"2","large":"2","medium":"2","small":"2"},"sizeClass":"nds-large-size_2-of-12 nds-medium-size_2-of-12 nds-small-size_2-of-12 nds-size_2-of-12 ","padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"iconSize":"medium","iconColor":"#4176D3"},"text":{"align":"","color":""},"inlineStyle":"","class":"","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_0_1_action_5_1","parentElementKey":"element_block_0_1"},{"name":"Action","element":"action","size":{"isResponsive":true,"default":"8","large":"8","medium":"8","small":"8"},"stateIndex":1,"class":"nds-col ","property":{"stateObj":"{record}","card":"{card}","record":"{record}","displayAsButton":false,"iconOnly":true,"buttonVariant":"outline-brand","iconSize":"medium","iconColor":"#4176D3","actionList":[{"stateObj":"{record}","card":"{card}","record":"{record}","stateAction":{"id":"flex-action-1637727552357","type":"Flyout","displayName":"Product Details","vlocityIcon":"utility:summarydetail","openUrlIn":"Current Window","flyoutType":"childCard","openFlyoutIn":"Popover","cardName":"OrderInfoNew","flyoutLwc":"OrderInfoNew","hasExtraParams":true,"flyoutParams":{"OrderId":"{OrderId}","OrderItemId":"{OrderItemId}"}},"displayAsButton":false,"iconOnly":true,"buttonVariant":"outline-brand","iconSize":"medium","iconColor":"#4176D3"}],"label":"Product Details","iconName":"utility:summarydetail","showSpinner":"false"},"type":"element","styleObject":{"sizeClass":"nds-large-size_8-of-12 nds-medium-size_8-of-12 nds-small-size_8-of-12 nds-size_8-of-12 ","size":{"isResponsive":true,"default":"8","large":"8","medium":"8","small":"8"},"padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"iconSize":"medium","iconColor":"#4176D3"},"text":{"align":"right","color":""},"inlineStyle":"","class":"nds-text-align_right ","style":"      \n         "},"elementLabel":"Block-0-Action-6","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"nds-large-size_8-of-12 nds-medium-size_8-of-12 nds-small-size_8-of-12 nds-size_8-of-12 ","size":{"isResponsive":true,"default":"8","large":"8","medium":"8","small":"8"},"padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"iconSize":"medium","iconColor":"#4176D3"},"text":{"align":"right","color":""},"inlineStyle":"","class":"nds-text-align_right ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_0_1_action_6_1","parentElementKey":"element_block_0_1"}],"elementLabel":"Block-0","styleObjects":[{"key":0,"conditions":"default","styleObject":{"padding":[{"type":"around","size":"x-small","label":"around:x-small"}],"class":"nds-text-align_left nds-p-around_x-small ","sizeClass":"nds-large-size_12-of-12 nds-medium-size_12-of-12 nds-small-size_12-of-12 nds-size_12-of-12 ","margin":[],"background":{"color":"","image":"","size":"","repeat":"no-repeat","position":""},"size":{"isResponsive":true,"default":"12","large":"12","medium":"12","small":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"left","color":""},"inlineStyle":"","style":"  background-repeat:no-repeat;    \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]}]}},"childCards":[],"actions":[],"omniscripts":[],"documents":[]}],"dataSource":{"type":"DataRaptor","value":{"dsDelay":"","resultVar":"[0].[Order]","bundle":"getContactOrders","bundleType":"","inputMap":{"currentContact":"{recordId}"},"jsonMap":"{\"currentContact\":\"{currentContact}\",\"recordId\":\"{recordId}\"}"},"orderBy":{"name":"","isReverse":false},"contextVariables":[]},"title":"OrderInfoMainEngagements","enableLwc":true,"isFlex":true,"theme":"nds","selectableMode":"Multi","lwc":{"DeveloperName":"cfOrderInfoMainEngagements_1_AcmeManufacturing","Id":"0RbHr000000Z5t4KAK","MasterLabel":"cfOrderInfoMainEngagements_1_AcmeManufacturing","NamespacePrefix":"c","ManageableState":"unmanaged"},"dynamicCanvasWidth":{"type":"desktop"},"isRepeatable":true,"Id":"0koHr000000XhFtIAS","OmniUiCardKey":"OrderInfoMainEngagements/AcmeManufacturing/1.0","OmniUiCardType":"Child"};
  export default definition