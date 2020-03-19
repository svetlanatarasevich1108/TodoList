public with sharing class TaskManagerController {
    public static final String COMPLETED_STATUS = 'Completed';
    @AuraEnabled(Cacheable=true)
    public static Map<String, List<Task__c>> getMapAllTasksFromDatabase() {
        Map<String, List<Task__c>> mapAllTasksValue = new Map<String, List<Task__c>> ();
        List<Task__c> listAllTasksFromDatabase = [
                SELECT
                        Id,
                        Date__c,
                        Task_Name__c,
                        Checkbox__c
                FROM Task__c
                ORDER BY Date__c
        ];
        for (Task__c item : listAllTasksFromDatabase) {
            List<Task__c> listAllTasksForMapValue = new List<Task__c>();
            String keyForMapAllTasks = String.valueOf(item.Date__c);
            if (!mapAllTasksValue.keySet().contains(keyForMapAllTasks)) {
                listAllTasksForMapValue.add(item);
                mapAllTasksValue.put(keyForMapAllTasks, listAllTasksForMapValue);
            } else {
                mapAllTasksValue.get(keyForMapAllTasks).add(item);
            }
        }
        return mapAllTasksValue;
    }
    @AuraEnabled
    public static Map<String, List<Task__c>> updateTasksInDatabaseByRecordId(String recordId) {
        List<Task__c> listTasksForUpdate = [
                SELECT
                        Status__c,
                        Checkbox__c
                FROM Task__c
                WHERE Id = :recordId
        ];
        listTasksForUpdate[0].Status__c = COMPLETED_STATUS;
        listTasksForUpdate[0].Checkbox__c = true;
        update listTasksForUpdate;
        return getMapAllTasksFromDatabase();
    }
}
