let definition =
      {"states":[{"fields":[],"conditions":{"id":"state-condition-object","isParent":true,"group":[]},"definedActions":{"actions":[]},"name":"Active","isSmartAction":false,"smartAction":{},"styleObject":{"padding":[{"type":"around","size":"x-small"}],"margin":[{"type":"bottom","size":"x-small"}],"container":{"class":"slds-card"},"size":{"isResponsive":false,"default":"12"},"sizeClass":"slds-size_12-of-12","class":"slds-card slds-p-around_x-small slds-m-bottom_x-small"},"components":{"layer-0":{"children":[{"name":"Icon","element":"flexIcon","size":{"isResponsive":false,"default":"1"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","card":"{card}","iconType":"Salesforce SVG","iconName":"custom:custom67","size":"small","extraclass":"slds-icon_container slds-icon-custom-custom67 ","variant":"inverse","imgsrc":""},"type":"element","styleObject":{"sizeClass":"slds-size_1-of-12 ","size":{"isResponsive":false,"default":"1"},"padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"left","color":""},"inlineStyle":"","class":"slds-text-align_left ","style":"      \n         "},"elementLabel":"Icon-0","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_1-of-12 ","size":{"isResponsive":false,"default":"1"},"padding":[],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"left","color":""},"inlineStyle":"","class":"slds-text-align_left ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"10"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%20class=%22slds-text-heading_small%22%3E%3Cstrong%3E%3Cspan%20style=%22font-family:%20'Salesforce%20Sans',%20Arial,%20sans-serif;%22%3EAsset%20Details%3C/span%3E%3C/strong%3E%3C/div%3E","card":"{card}"},"type":"text","styleObject":{"sizeClass":"slds-size_10-of-12 ","size":{"isResponsive":false,"default":"10"}},"elementLabel":"Text-1"},{"name":"Block","element":"block","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"slds-col ","property":{"label":"\\{AssetName} - {SerialNumber}","collapsible":true,"record":"{record}","collapsedByDefault":false,"card":"{card}","styles":{"label":{"color":"#000000","fontSize":"Large"}}},"type":"block","styleObject":{"size":{"isResponsive":false,"default":"12"},"padding":[],"class":"","sizeClass":"slds-size_12-of-12 ","margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"styles":{"label":{"color":"#000000","fontSize":"Large"}}},"text":{"align":"","color":""},"inlineStyle":"","style":"      \n         "},"children":[{"key":"element_element_block_2_0_flexImg_0_0","name":"Image","element":"flexImg","size":{"isResponsive":false,"default":"7"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","card":"{card}","size":"","extraclass":"slds-align_absolute-center","stateImg":{"imgsrc":"{ImageURL}","alternativeText":"Image description"},"data-conditions":{"id":"state-condition-object","isParent":true,"group":[{"id":"state-new-condition-0","field":"ImageURL","operator":"!=","value":"","type":"custom","hasMergeField":false}]}},"type":"element","styleObject":{"sizeClass":"slds-size_7-of-12 ","size":{"isResponsive":false,"default":"7"}},"parentElementKey":"element_block_2_0","elementLabel":"Block-3-Image-0"},{"name":"AssetName","element":"outputField","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","fieldName":"AssetName","label":"Asset Name","card":"{card}","type":"text","styles":{"value":{"fontSize":"Large"}}},"type":"field","styleObject":{"sizeClass":"slds-size_12-of-12 ","padding":[{"type":"bottom","size":"medium","label":"bottom:medium"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"styles":{"value":{"fontSize":"Large"}}},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_medium ","style":"      \n         "},"elementLabel":"Block-3-AssetName-1","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_12-of-12 ","padding":[{"type":"bottom","size":"medium","label":"bottom:medium"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"styles":{"value":{"fontSize":"Large"}}},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_medium ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_2_0_outputField_1_0","parentElementKey":"element_block_2_0"},{"name":"PurchaseDate","element":"outputField","size":{"isResponsive":false,"default":"6"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","fieldName":"PurchaseDate","label":"Purchase Date","card":"{card}","type":"date","format":"M/D/YYYY"},"type":"field","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"x-small","label":"bottom:x-small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_x-small ","style":"      \n         "},"elementLabel":"Block-3-PurchaseDate-2","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"x-small","label":"bottom:x-small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_x-small ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_2_0_outputField_2_0","parentElementKey":"element_block_2_0"},{"name":"InstallDate","element":"outputField","size":{"isResponsive":false,"default":"6"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","fieldName":"InstallDate","label":"Install Date","card":"{card}","type":"date","format":"M/D/YYYY"},"type":"field","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"elementLabel":"Block-3-InstallDate-3","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_2_0_outputField_3_0","parentElementKey":"element_block_2_0"},{"name":"SerialNumber","element":"outputField","size":{"isResponsive":false,"default":"12"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","fieldName":"SerialNumber","label":"Serial Number","card":"{card}","type":"text"},"type":"field","styleObject":{"sizeClass":"slds-size_12-of-12 ","padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"elementLabel":"Block-3-SerialNumber-4","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_12-of-12 ","padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"12"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_2_0_outputField_4_0","parentElementKey":"element_block_2_0"},{"key":"element_element_block_2_0_outputField_5_0","name":"ProductModel","element":"outputField","size":{"isResponsive":false,"default":"6"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","fieldName":"ProductModel","label":"Model","card":"{card}","type":"text"},"type":"field","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"parentElementKey":"element_block_2_0","elementLabel":"Block-3-ProductModel-5","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]},{"key":"element_element_block_2_0_outputField_6_0","name":"ProductModel","element":"outputField","size":{"isResponsive":false,"default":"6"},"stateIndex":0,"class":"slds-col ","property":{"placeholder":"","record":"{record}","fieldName":"ProductModel","label":"Code","card":"{card}","type":"text"},"type":"field","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"parentElementKey":"element_block_2_0","elementLabel":"Block-3-ProductModel-5-clone-0","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_6-of-12 ","size":{"isResponsive":false,"default":"6"},"padding":[{"type":"bottom","size":"small","label":"bottom:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"","color":""},"inlineStyle":"","class":"slds-p-bottom_small ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"3"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3EWarranty%3C/div%3E%0A%3Cdiv%3EStatus:&nbsp;%3C/div%3E","card":"{card}"},"type":"text","styleObject":{"sizeClass":"slds-size_3-of-12 ","size":{"isResponsive":false,"default":"3"}},"elementLabel":"Block-3-Text-6","key":"element_element_block_2_0_outputField_7_0","parentElementKey":"element_block_2_0"},{"name":"Text","element":"outputField","size":{"isResponsive":false,"default":"3"},"stateIndex":0,"class":"slds-col ","property":{"record":"{record}","mergeField":"%3Cdiv%3E%7BWarranty%7D%3C/div%3E","card":"{card}"},"type":"text","styleObject":{"sizeClass":"slds-size_3-of-12 ","size":{"isResponsive":false,"default":"3"},"padding":[],"margin":[{"type":"top","size":"x-small","label":"top:x-small"}],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center slds-m-top_x-small ","style":"      \n         "},"elementLabel":"Block-3-Text-7","key":"element_element_block_2_0_outputField_8_0","parentElementKey":"element_block_2_0","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_3-of-12 ","size":{"isResponsive":false,"default":"3"},"padding":[],"margin":[{"type":"top","size":"x-small","label":"top:x-small"}],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"center","color":""},"inlineStyle":"","class":"slds-text-align_center slds-m-top_x-small ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]},{"name":"Menu","element":"flexMenu","size":{"isResponsive":false,"default":"6"},"stateIndex":0,"class":"slds-col ","property":{"type":"action","size":"x-small","variant":"brand","iconName":"utility:down","overflow":true,"record":"{record}","card":"{card}","menuItems":[{"name":"menu-item-1652199614079-0","label":"Submit Warranty Claim","iconName":"utility:edit_form","actionData":{"stateObj":"{record}","card":"{card}","stateAction":{"id":"flex-action-1652462344414","type":"Flyout","displayName":"Submit Warrant Claim","vlocityIcon":"utility:edit_form","openUrlIn":"Current Window","flyoutType":"OmniScripts","openFlyoutIn":"Modal","osName":"WarrantyClaim/OS/English","flyoutLwc":"warranty-claim-o-s-english","layoutType":"lightning","hasExtraParams":true,"flyoutParams":{"CaseId":"{recordId}"},"parent":"menu","actionConditions":null}},"actionList":[{"stateObj":"{record}","card":"{card}","stateAction":{"id":"flex-action-1652562624335","type":"OmniScript","displayName":"Submit Warrant Claim","vlocityIcon":"utility:edit_form","openUrlIn":"New Tab/Window","layoutType":"lightning","hasExtraParams":true,"actionConditions":null,"omniType":{"Name":"WarrantyClaim/OS/English","Id":"0jNHr000000XmrxEAG","isLwcOs":true},"isLwcOS":true,"tabLabel":"Claim","extraParams":{"CaseId":"{recordId}"}},"key":"1652469380584-oq9582o0j","label":"Action","draggable":false,"isOpen":true,"actionIndex":0,"contextId":"\\{recordId}"}],"showSpinner":"false","actionConditions":null}],"position":"right","label":"Menu","iconPosition":"right"},"type":"element","styleObject":{"sizeClass":"slds-size_6-of-12 ","padding":[{"type":"top","size":"small","label":"top:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"6"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"right","color":""},"inlineStyle":"","class":"slds-text-align_right slds-p-top_small ","style":"      \n         "},"elementLabel":"Block-3-Menu-8","styleObjects":[{"key":0,"conditions":"default","styleObject":{"sizeClass":"slds-size_6-of-12 ","padding":[{"type":"top","size":"small","label":"top:small"}],"margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"size":{"isResponsive":false,"default":"6"},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{},"text":{"align":"right","color":""},"inlineStyle":"","class":"slds-text-align_right slds-p-top_small ","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}],"key":"element_element_block_2_0_flexMenu_9_0","parentElementKey":"element_block_2_0"}],"elementLabel":"Block-3","styleObjects":[{"key":0,"conditions":"default","styleObject":{"size":{"isResponsive":false,"default":"12"},"padding":[],"class":"","sizeClass":"slds-size_12-of-12 ","margin":[],"background":{"color":"","image":"","size":"","repeat":"","position":""},"container":{"class":""},"border":{"type":"","width":"","color":"","radius":"","style":""},"elementStyleProperties":{"styles":{"label":{"color":"#000000","fontSize":"Large"}}},"text":{"align":"","color":""},"inlineStyle":"","style":"      \n         "},"label":"Default","name":"Default","conditionString":"","draggable":false}]}]}},"childCards":[],"actions":[],"omniscripts":[],"documents":[]}],"dataSource":{"type":"DataRaptor","value":{"dsDelay":"","bundle":"getAssetfromCase","bundleType":"","inputMap":{"CaseId":"{recordId}"},"resultVar":""},"orderBy":{"name":"","isReverse":false},"contextVariables":[]},"title":"CaseAsset","enableLwc":true,"isFlex":true,"theme":"slds","selectableMode":"Multi","lwc":{"DeveloperName":"cfCaseAsset_2_SalesforceDemo","Id":"0RbHr000000Z5tzCAE","MasterLabel":"cfCaseAsset_2_SalesforceDemo","NamespacePrefix":"c","ManageableState":"unmanaged"},"dynamicCanvasWidth":{"type":"mobile"},"osSupport":true,"Id":"0koHr000000XhFnAAG","OmniUiCardKey":"CaseAsset/SalesforceDemo/2.0","OmniUiCardType":"Parent"};
  export default definition