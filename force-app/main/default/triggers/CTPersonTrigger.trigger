trigger CTPersonTrigger on Person__c (before insert, after insert, before update, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            CTPersonTriggerHandler.beforeInsertHandler(Trigger.new);
        }

        when BEFORE_UPDATE {
            CTPersonTriggerHandler.beforeUpdateHandler(Trigger.new, Trigger.oldMap);
        }

        when AFTER_UPDATE {
            CTPersonTriggerHandler.afterUpdateHandler(Trigger.newMap.keySet());
        }
    }
}