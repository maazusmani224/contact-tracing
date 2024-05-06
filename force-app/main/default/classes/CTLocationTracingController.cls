public with sharing class CTLocationTracingController {
    public CTLocationTracingController() {

    }

    /**
     * Get list of visitors by Location Id
     * @return list of visitors
     */
    public static List<Location_Tracing__c> getVisitors(String locationId){
        return [SELECT Person__r.Id, Person__r.Name, Visit_Date__c FROM Location_Tracing__c WHERE Location__r.Id =: locationId ORDER BY Visit_Date__c DESC];
    }

    /**
     * Get list of locations visited by person in last 10 days
     * @return list of location
     */
    public static List<Location_Tracing__c> getLocationByPersonIds(Set<Id> personIds){
        return [SELECT Location__r.Id, Location__r.Name, Visit_Date__c FROM Location_Tracing__c 
        WHERE Person__r.Id IN: personIds AND Visit_Date__c = LAST_N_DAYS:10 ORDER BY Visit_Date__c DESC];
    }

    /**
     * Get list of locations where only persons with statuses green have visited in last 10 days
     * @return list of location
     */
    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds){
        String statusGreen = 'Green';
        return [SELECT Location__r.Id, Location__r.Name, Visit_Date__c FROM Location_Tracing__c 
        WHERE Location__r.Id IN: locationIds AND Person__r.Health_Status__c =: statusGreen 
        AND Visit_Date__c = LAST_N_DAYS:10 ORDER BY Visit_Date__c DESC];
    }

    /**
     * Get list of duplicate records
     * @return list of location tracing records
     */
    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces){
        Set<Id> personId = new Set<Id>();
        Set<Id> locationId = new Set<Id>();
        for (Location_Tracing__c locationTrace : locationTraces){
            personId.add(locationTrace.Person__c);
            locationId.add(locationTrace.Location__c);
        }

        List<Location_Tracing__c> allLocationTraces = [SELECT Person__c, Location__c 
                                                        FROM Location_Tracing__c 
                                                        WHERE Location__c IN: locationId 
                                                        AND Person__c IN: personId];

        Map<Id, Set<Id>> locationPersonMap = new Map<Id, Set<Id>>();
        for (Location_Tracing__c locationTrace : allLocationTraces){
            if (!locationPersonMap.containsKey(locationTrace.Location__c)){
                locationPersonMap.put(locationTrace.Location__c, new Set<Id>());
            }
            locationPersonMap.get(locationTrace.Location__c).add(locationTrace.Person__c);
        }

        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        for (Location_Tracing__c locationTrace : locationTraces){
            if (locationPersonMap.containsKey(locationTrace.Location__c) && locationPersonMap.get(locationTrace.Location__c).contains(locationTrace.Person__c)){
                duplicates.add(locationTrace);
            }
        }
        return duplicates;
    }
}