public with sharing class HouseholdActivitiesTimelineDao {

  public List<AccountContactRelation> getAccountContactRelation(String householdAccountId) {
    return [SELECT Contact.Id FROM AccountContactRelation WHERE AccountId = :householdAccountId];
  }

  public List<Task> getTasks(List<Id> contactIds) {
    return [SELECT Id, WhoId, Who.Name, Subject, WhatId, What.Name FROM Task WHERE WhoId IN :contactIds ];
  }

  public List<Event> getEvents(List<Id> contactIds) {
    return [SELECT Id, WhoId, Who.Name, Subject, WhatId, What.Name FROM Event WHERE WhoId IN :contactIds];
  }

  public List<Contact> getContacts(Set<Id> contactIds) {
    return [SELECT Id, AccountId, Account.Name FROM Contact WHERE Id IN :contactIds];
  }

}