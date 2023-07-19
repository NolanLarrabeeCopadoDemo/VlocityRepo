/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class QuickSetupController {
    global QuickSetupController() {

    }
    @Deprecated
    @RemoteAction
    global static String addQueueMember(String userId, String queueId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.ResultSuccessMsg addQueueMemberSuccessFlag(String userId, String queueId) {
        return null;
    }
    @RemoteAction
    global static String assignLicense(String userId, String licenseId) {
        return null;
    }
    @RemoteAction
    global static LiveChatDeployment checkChatDeployment(String devName) {
        return null;
    }
    @RemoteAction
    global static Boolean checkGuestAccessToTheSupportAPI(String communityName) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.Permission checkPermissionSet(String name, String servicePresenceId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.Queue checkQueue(String devName, String routingConfigId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.Queue checkQueueLiveAgentSession(String devName, String routingConfigId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.SOSDeploy checkSOSDeployment(String devName, String queueId) {
        return null;
    }
    @RemoteAction
    global static List<ConnectApi.Community> communities() {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.DefaultDeployment defaultDeployment() {
        return null;
    }
    @Deprecated
    @RemoteAction
    global static String enableServiceCloud(String userId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.ResultSuccessMsg enableServiceCloudSuccessFlag(String userId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.ResultSuccessMsg existContact(String email) {
        return null;
    }
    @RemoteAction
    global static List<LiveChatDeployment> getChatDeployment() {
        return null;
    }
    @RemoteAction
    global static List<SCQuickSetup.QuickSetupController.DataCategoryGroup> getDataCategoryAssignment(String properties, String zip) {
        return null;
    }
    @RemoteAction
    global static String getLicense() {
        return null;
    }
    @RemoteAction
    global static List<LiveChatButton> getLiveChatButton() {
        return null;
    }
    @RemoteAction
    global static List<SOSDeployment> getSOSDeployment() {
        return null;
    }
    @RemoteAction
    global static List<User> getUsers(String name) {
        return null;
    }
    @RemoteAction
    global static Boolean hasLicense() {
        return null;
    }
    @RemoteAction
    global static Boolean isKnowledgeArticleVersion() {
        return null;
    }
    @RemoteAction
    global static Boolean isKnowledgeUser() {
        return null;
    }
    @RemoteAction
    global static Boolean isNetwork() {
        return null;
    }
    @RemoteAction
    global static Boolean isOmniChannelEnabled() {
        return null;
    }
    @RemoteAction
    global static Boolean isSOSSession() {
        return null;
    }
    @RemoteAction
    global static Boolean isServiceChannelExists() {
        return null;
    }
    @RemoteAction
    global static Boolean isServiceCloudUser() {
        return null;
    }
    @RemoteAction
    global static List<ListView> listViews() {
        return null;
    }
    @RemoteAction
    global static List<SCQuickSetup.QuickSetupController.ConnectedApp> loadConnectedApp(String zip, String properties) {
        return null;
    }
    @RemoteAction
    global static List<SCQuickSetup.QuickSetupController.QuickActionSite> quickActions() {
        return null;
    }
    @RemoteAction
    global static String selectedTab() {
        return null;
    }
    @RemoteAction
    global static String serviceChannelId() {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.ServiceChannelData servicePresenceStatus(String devName) {
        return null;
    }
    @RemoteAction
    global static Boolean setLiveAgentUser(String userId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.Permission updatePermissionSet(String devName, String name, Boolean isSOSEnabled, String id, String servicePresenceId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.Queue upsertQueue(String devName, String label, String routingConfigId, String id, Boolean isQueueSobject) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.Queue upsertQueueLiveAgentSession(String devName, String label, String routingConfigId, String id, Boolean isQueueSobject) {
        return null;
    }
    @Deprecated
    @RemoteAction
    global static String upsertUserToPermissionSet(String userId, String permissionSetId, String servicePresenceId) {
        return null;
    }
    @RemoteAction
    global static SCQuickSetup.QuickSetupController.ResultSuccessMsg upsertUserToPermissionSetSuccessFlag(String userId, String permissionSetId, String servicePresenceId) {
        return null;
    }
global class ConnectedApp {
    global ConnectedApp() {

    }
}
global class DataCategory {
}
global class DataCategoryGroup {
}
global class DefaultDeployment {
    global DefaultDeployment() {

    }
}
global class Permission {
    global Permission() {

    }
}
global class Queue {
    global Queue() {

    }
}
global class QuickActionSite {
}
global class ResultSuccessMsg {
    global ResultSuccessMsg() {

    }
}
global class RoutingConfig {
    global RoutingConfig() {

    }
}
global class SOSDeploy {
    global SOSDeploy() {

    }
}
global class ServiceChannelData {
    global ServiceChannelData() {

    }
}
}
