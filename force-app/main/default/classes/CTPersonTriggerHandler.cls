public with sharing class CTPersonTriggerHandler {
    public CTPersonTriggerHandler() {

    }

    public static void beforeInsertHandler(List<Person__c> records) {
        for (Person__c record : records){
            record.Health_Status__c='Green';
            record.Token__c=CTPersonController.getToken(record.Mobile__c);
        }        
    }

    public static void beforeUpdateHandler(List<Person__c> records, Map<Id, Person__c> oldMap) {
        for (Person__c record : records){
            if (record.Health_Status__c != oldMap.get(record.Id).Health_Status__c){
                record.Status_Update_Date__c=Date.today();
            }
        }
    }

    public static void afterUpdateHandler(Set<Id> records) {
        List<Location_Tracing__c> lastVisited = CTLocationTracingController.getLocationByPersonIds(records);
        List<Location__c> locations = new List<Location__c>();
        for(Location_Tracing__c locationTracingRecord : lastVisited){
            locations.add(new Location__c(Id=locationTracingRecord.Location__r.Id, Red_Score__c=CTLocationController.getHealthStatusCount().get('Red')));
        }
        System.debug(locations);
        update locations;
    }
}