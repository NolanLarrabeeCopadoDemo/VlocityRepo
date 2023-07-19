html {
  scroll-behavior: smooth;
  overscroll-behavior: none;
}
[v-cloak] {
  display:none;
}
.my-brand {
    background-image: radial-gradient( circle farthest-corner at 10% 20%,  rgba(10,174,227,1) 0%, rgba(124,182,255,1) 100.2% );
}
.my-brand-small {
    background-image: radial-gradient( circle farthest-corner at 10% 20%,  rgba(10,174,227,1) 0%, rgba(20,174,227,1) 100.2% );
}
.v-btn-toggle--selected {
    box-shadow: none;
    border: 1px solid #E0E0E0;
}
.v-overlay--active:before {
    opacity: 0.4;
}
.v-overlay:before {
    background-color: #455A64;
}
.v-pagination__navigation, .v-pagination__item, .v-pagination__item--active {
    box-shadow: none;
}
.v-menu__content {
    border: 1px solid #e0e0e0;
    box-shadow: none;
}
.v-dialog {
    box-shadow: none;
}
.theme--light .v-btn--floating {
    box-shadow: none !important;
}
.theme--light.v-stepper {
    border-bottom: 1px solid #e0e0e0;
}
.theme--light.v-card {
    box-shadow: none;
    border: 1px solid #e0e0e0;
}
.v-dialog>.theme--light.v-card {
	border: none;
}
.v-footer .theme--light.v-card {
	border-left: none;
    border-right: none;
    border-bottom: none;
}
.td-active-false {
    color: #BDBDBD;
}

html::-webkit-scrollbar {
    display: none;
}
.mycontent.object-edit-true .step2record-table .v-table thead tr th {
    min-width: 600px;
}
.my-footer {
    z-index:210;
}
.v-btn--bottom.v-btn--fixed.my-action {
    bottom: 14px;
}
.v-btn--bottom.v-btn--fixed.my-action.my-action-2 {
 	bottom: 20px;
    left: 95px;
}
.v-stepper__header{
    height: 60px;
}
.template-list-scroll-div {
    height: calc(100vh - 50px);
    overflow-y: scroll;
    margin-top:-25px;
    padding:25px 0;
}
.template-list-scroll-div.template-list-left {
    height: calc(100vh - 95px);
}
.template-list-scroll-div::-webkit-scrollbar {
    display: none;    
}

.my-app-title {
    cursor: pointer;
}
.my-app-title:hover {
    color: #00BCD4 !important;
}

.welcome {
    position:fixed;top:0;left:0;right:0;
        transition-duration: .6s;
    transition-timing-function:ease-in-out;
}
.welcome.welcome1{
    top:-100vh;
}


.welcome-next-btn {
    -webkit-animation: sdb04 2s infinite;
  animation: sdb04 2s infinite;
}

@-webkit-keyframes sdb04 {
  0% {
    -webkit-transform: translate(0, 0);
  }
  20% {
    -webkit-transform: translate(0px, 10px);
  }
  50% {
    -webkit-transform: translate(0, 0);
  }
}
@keyframes sdb04 {
  0% {
    transform: translate(0, 0);
  }
  20% {
    transform: translate(0px, 10px);
  }
  
  50% {
    transform: translate(0, 0);
  }
}


.rule-card.v-card.rule-card-active {
    z-index: 1;
    transform: translate(0,1px) scale(1.02);
    background-color: #fff;
    box-shadow: none;
    opacity: 1;
}
.v-input {
    font-size: 14px;
}
.v-text-field.v-text-field--solo {
    min-height: 36px;
}
.v-tabs__slider-wrapper {
    top:0;
    bottom: unset;
}

.step4tab000 .v-tabs__item--active {
    background-color: rgba(96, 125, 139, .1);   
}
.step4tab001 .v-tabs__item--active {
    background-color: rgba(103, 58, 183, .1);   
}
.step4tab002 .v-tabs__item--active {
    background-color: rgba(33, 150, 243, .1);   
}

.step1to3tab .v-tabs__item--active {
    background-color: rgba(63, 81, 181, .1);   
}

.v-tabs__item--active .v-input{
	margin-top: 0;
}
.v-tabs__item--active input{
    text-align: center;
    background-color: #fff;
}
.v-tabs__container {
    border-bottom: 1px solid rgb(236,236,236);
    height: 38px;
}
.v-tabs__div {
    
}
.v-stepper__step {
    padding-top: 10px;
    padding-bottom: 10px;
}
.v-stepper__step__step.primary {
    background-color: #00BCD4 !important;
    border-color: #00BCD4 !important;
}



.myloading-true {
    opacity: 0.4;
    pointer-events: none;
}
.layout::-webkit-scrollbar {
    display: none;
    -webkit-overflow-scrolling: touch;
	overflow-scrolling: touch;
}

.v-table thead tr th {
    text-align: left;
}
.template-item-media .v-card__media__background {
    transition: all 0.4s ease-out;
    transform: matrix3d(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    );
    will-change: transform;
    filter: brightness(0.8);
}
.template-item:hover .template-item-media .v-card__media__background,
.template-list-item-active .template-item-media .v-card__media__background {
    transform: matrix3d(
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 0.95
    );
    filter: brightness(0.65);
}
.mylabel {
    background-color: blue;
    width: 1.5rem;
    height: 1rem;
    display: inline-block;
    line-height: 1rem;
}
.myheader {
    position:fixed;
    z-index:1;
    top:0;
    left:0;
    right:0;                
}
.mycontent {
    position: fixed;
    top: 55px;
    left: 0;
    right: 0;
    bottom: 0;
    overflow-y: scroll;
    -webkit-overflow-scrolling: touch
}


.csv-import-table table.v-table thead th {
    background-color: #3F51B5;
    min-width: 200px;
}

.fade-enter-active {
    transition: opacity .4s;
}
.fade-leave-active {
    transition: opacity .2s;
}
.fade-enter, .fade-leave-to {
    opacity: 0;
}


.layout.show-rule-box {
    position: relative;
}
.layout.show-rule-box .flex.list-item {
 	   padding: 0 4px;
}
.list-item {
    transition: all .8s;
    display: inline-block;
}
.list-enter {
    opacity: 0.4;
    transform: translateY(15px);
}
.list-leave-to {
    opacity: 0;
    transform: translateX(-100px);
}
.list-leave-active {
    position: absolute;
    width: 100vw;
}

.custom-loader {
    animation: loader 1s infinite;
    display: flex;
}
@-moz-keyframes loader {
    from {
        transform: rotate(0);
    }
    to {
        transform: rotate(360deg);
    }
}
@-webkit-keyframes loader {
    from {
        transform: rotate(0);
    }
    to {
        transform: rotate(360deg);
    }
}
@-o-keyframes loader {
    from {
        transform: rotate(0);
    }
    to {
        transform: rotate(360deg);
    }
}
@keyframes loader {
    from {
        transform: rotate(0);
    }
    to {
        transform: rotate(360deg);
    }
}

.rule-card {
    border: 1px solid #ddd;
}
.card--raised {
    cursor: default;
    transform: scale(1.04);
}
.rule-card.v-card {
    background-color: #FAFAFA;
    margin-top: 10px;
    opacity: 0.6;
}
.new-rule-card.v-card {
    margin-top: 10px;
	z-index:1;   
        opacity: 1;
}
.rule-card.v-card:hover, .rule-card.v-card.v-card--raised, .new-rule-card {
    background-color: #FFFFFF;
        opacity: 1;
}
.tab-bracket-lighten {
    color: #aaa;
}


table.table tbody td:first-child, table.table tbody td:not(:first-child), table.table tbody th:first-child, table.table tbody th:not(:first-child), table.table thead td:first-child, table.table thead td:not(:first-child), table.table thead th:first-child, table.table thead th:not(:first-child), table.table tbody td {
    height: auto;
    padding: 1rem 1.5rem;
}

.invalid-td {
    background-color: #FFEBEE;
}

.mycontent.object-edit-true table.v-table tbody tr td{
    vertical-align: middle;
}
.mycontent.object-edit-true table.v-table tbody tr td .v-input{
	padding-top: 8px;
}
.mycontent.object-edit-true table.v-table tbody tr td .v-text-field{
	min-width: 150px;
}
.mycontent.object-edit-true .step2record-table table.v-table tbody tr td .v-text-field{
	min-width: 50px;
}
.mypb120 {
    margin-bottom: 140px;
}
.container.fluid.rule-item-container {
    padding-top: 0;
    margin: 0 -32px;
    padding-bottom: 0;
    max-width: calc(100% + 64px);
    width: calc(100% + 64px);
    overflow-x: scroll;
    overflow-y: hidden;
    list-style: none !important;
}
.min-width-rule-item {
    min-width: 200px;
}
.el-popper{
    font-family: Roboto,"Hiragino Kaku Gothic Pro W3", "Noto Sans Japanese Regular",sans-serif;
}
.el-range-editor.el-input__inner {
    width: 100%;
    margin-top: 8px;
    color: rgba(0,0,0,.87);
    box-shadow: 0 3px 1px -2px rgba(0,0,0,.2), 0 2px 2px 0 rgba(0,0,0,.14), 0 1px 5px 0 rgba(0,0,0,.12);
    border-radius: 2px;
    border-color: #fff;
    min-height: 48px;
    padding: 3px 0px 3px 7px; 
}
.el-date-editor .el-range-separator {
    line-height: 40px;
}
.el-date-editor .el-range-input {
  color: rgba(0,0,0,.87);
}
.el-time-panel__btn.confirm {
    color: #00BCD4;
}
.el-button.is-plain:focus, .el-button.is-plain:hover {
    border-color: #00BCD4;
    color: #00BCD4;
}
.el-button--text {
    color: #757575;
}
.el-date-table td.end-date span, .el-date-table td.start-date span {
    background-color: #3949AB;
}

.el-date-table td.in-range div, .el-date-table td.in-range div:hover, .el-date-table.is-week-mode .el-date-table__row.current div, .el-date-table.is-week-mode .el-date-table__row:hover div {
    background-color: #E8EAF6;
}
.el-date-table td.today span {
    color: #00BCD4;
    font-weight: bold;
}
.npfc-table .theme--light.v-table{
    background-color: #FFF;
}

.container.fluid.chart-card-container {
    margin: 0 -32px;
    max-width: calc(100% + 64px);
    width: calc(100% + 64px);
}
.template-list-item {
    padding: 8px;
}
.template-list-item-active {
    
}