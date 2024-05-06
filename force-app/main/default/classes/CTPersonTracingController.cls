public with sharing class CTPersonTracingController {
    public CTPersonTracingController() {

    }

    /**
     * Get list of all traces for pwerson id
     * @return list of all traces
     */
    public static List<People_Tracing__c> getTraces(String recordId) {
        return [SELECT Id, Person_1__c, Person_2__c, Contact_Date__c, Contact_Type__c 
                FROM People_Tracing__c WHERE Person_1__c =: recordId OR Person_2__c=:recordId 
                ORDER BY Contact_Date__c DESC];
    }

    
    /**
     * Get list of duplicates records being entered
     * @return list of already existing people tracing records
     */
    public static List<People_Tracing__c> checkDuplicates(List<People_Tracing__c> newTraces) {
        Set<Id> person1Id = new Set<Id>();
        Set<Id> person2Id = new Set<Id>();

        for (People_Tracing__c newTrace : newTraces){
            person1Id.add(newTrace.Person_1__c);
            person2Id.add(newTrace.Person_2__c);
        }

        List<People_Tracing__c> existingTraces = [SELECT Person_1__c, Person_2__c 
                                                    FROM People_Tracing__c 
                                                    WHERE Person_1__c IN: person1Id 
                                                    AND Person_2__c IN: person2Id];

        Map<Id, Set<Id>> personsMap = new Map<Id, Set<Id>>();
        for (People_Tracing__c existingTrace : existingTraces){
            if(! personsMap.containsKey(existingTrace.Person_1__c)){
                personsMap.put(existingTrace.Person_1__c, new Set<Id>());
            }
            personsMap.get(existingTrace.Person_1__c).add(existingTrace.Person_2__c);
        }

        List<People_Tracing__c> duplicates = new List<People_Tracing__c>();
        for (People_Tracing__c newTrace : newTraces){
            if (personsMap.containsKey(newTrace.Person_1__c) && personsMap.get(newTrace.Person_1__c).contains(newTrace.Person_2__c)){
                duplicates.add(newTrace);
            }
            if (personsMap.containsKey(newTrace.Person_2__c) && personsMap.get(newTrace.Person_2__c).contains(newTrace.Person_1__c)){
                duplicates.add(newTrace);
            }
        }
        return duplicates;
    }
}