public with sharing class CTLocationController {
    public CTLocationController() {
    }

    /**
     * Fetch the last 100 location records that were updated
     * @params
     * @return List of Location objects
     */
    public static List<Location__c> getRecentStatusChanges() {
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c 
        FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    /**
     * Fetch all matching locations by a seach string
     * @params search string
     * @return List of matching locations
     */
    public static List<Location__c> searchLocations(String searchString) {
        String searchToken = '%' + searchString + '%';
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c 
        FROM Location__c WHERE Name LIKE: searchToken OR Address__c LIKE: searchToken OR Pincode__c LIKE:searchToken
        ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    /**
     * Fetches a location record by Id
     * @params location id
     * @return Location object 
     */
    public static Location__c getLocationById(String locationId) {
        List<Location__c> locations = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status__c, Status_Update_Date__c 
        FROM Location__c WHERE Id =: locationId];
        if(locations == null || locations.size()==0)
        return null;
        return locations[0];
    }


    public static Map<String, Integer> getHealthStatusCount() {
        Map<String, Integer> healthStatusCount = new Map<String, Integer>();
        for (AggregateResult record : [SELECT Status__c, COUNT(Id) IdCount FROM Location__c GROUP BY Status__c]){
            healthStatusCount.put(String.valueOf(record.get('Status__c')), Integer.valueOf(record.get('IdCount')));
        }
        System.debug(healthStatusCount);
        return healthStatusCount;
    }

}