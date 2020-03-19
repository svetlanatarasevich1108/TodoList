public with sharing class TaskManagerController {

    @AuraEnabled(Cacheable=true)
    public static Map<String, List<Task__c>> getAllTask() {
        List<Task__c> listTasks = [SELECT Id, Date__c, Task_Name__c,Checkbox__c FROM Task__c ORDER BY Date__c];
        Map<String, List<Task__c>> mapData = new Map<String, List<Task__c>> ();
        for (Task__c item : listTasks) {
            List<Task__c> newList = new List<Task__c>();
            String key = String.valueOf(item.Date__c);
            if (!mapData.keySet().contains(key)) {
                newList.add(item);
                mapData.put(key, newList);
            } else {
                mapData.get(key).add(item);
            }
        }
        return mapData;
    }

    @AuraEnabled
    public static Map<String, List<Task__c>> getChangeCheckbox(String recordId) {
        List<Task__c> lTasks = [SELECT Id, Task_Name__c, Date__c,Checkbox__c FROM Task__c WHERE Id = :recordId];
        lTasks[0].Status__c = 'Completed';
        lTasks[0].Checkbox__c = true;
        update lTasks;
        List<Task__c> listTasks = [SELECT Id, Date__c, Task_Name__c,Checkbox__c FROM Task__c ORDER BY Date__c];
        Map<String, List<Task__c>> mapData = new Map<String, List<Task__c>> ();
        for (Task__c item : listTasks) {
            List<Task__c> newList = new List<Task__c>();
            String key = String.valueOf(item.Date__c);
            if (!mapData.keySet().contains(key)) {
                newList.add(item);
                mapData.put(key, newList);
            } else {
                mapData.get(key).add(item);
            }
        }
        return mapData;
    }
}