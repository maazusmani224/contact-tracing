public with sharing class CTPersonController {
    public CTPersonController() {

    }

    /**
    Returns the hash of Mobile Number provided as String
     */
    public static String getToken(String mobileNumber){
        return EncodingUtil.base64Encode(Crypto.generateDigest('MD5', Blob.valueOf(mobileNumber)));
    }

    /**
    Returns list of Persons sorted by most recent Status Update Date
     */
    public static List<Person__c> getRecentHealthChanges(){
        return [SELECT Id, Name, Mobile__c, OwnerId, Token__c, Status_Update_Date__c, Health_Status__c, CreatedById, LastModifiedById 
        FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
    }

    /**
    Returns list of Persons based on Search criteria based on name, Phone or Token
     */
    public static List<Person__c> searchPeople(String searchString){
        String searchToken = '%' + searchString + '%';
        return [SELECT Id, Name, Mobile__c, OwnerId, Token__c, Status_Update_Date__c, Health_Status__c, CreatedById, LastModifiedById
        FROM Person__c WHERE Name LIKE: searchToken OR Mobile__c LIKE: searchToken OR Token__c LIKE: searchToken
        ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    /**
    Returns a Person account by Id
     */
    public static Person__c getPersonById(String personId){
        List<Person__c> person = [SELECT Id, Name, Mobile__c, OwnerId, Token__c, Status_Update_Date__c, Health_Status__c, CreatedById, LastModifiedById 
        FROM Person__c WHERE Id =: personId];
        if(person == null || person.size() == 0)
        return null;
        return person[0];
    }


    public static Map<String, Integer> getHealthStatusCount() {
        Map<String, Integer> healthStatusCount = new Map<String, Integer>();
        for (AggregateResult record : [SELECT Health_Status__c, COUNT(Id)CountId FROM Person__c GROUP BY Health_Status__c]){
            healthStatusCount.put(String.valueOf(record.get('Health_Status__c')), Integer.valueOf(record.get('CountId')));
        }
        return healthStatusCount;
    }

}