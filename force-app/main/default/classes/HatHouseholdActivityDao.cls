/**
 * @description This class has the SOQL queries to get tasks and events for contacts in the household.
 * @author tbal
 */
public with sharing class HatHouseholdActivityDao {

  /**
   * @description getAccountContactRelation
   * @param householdAccountId
   * @return List<AccountContactRelation>
   */
  public List<AccountContactRelation> getAccountContactRelation(String householdAccountId) {
    return [SELECT Contact.Id FROM AccountContactRelation WHERE AccountId = :householdAccountId WITH USER_MODE];
  }

  /**
   * @description getTasks
   * @param contactIds
   * @return List<Task>
   */
  public List<Task> getTasks(List<Id> contactIds) {
    return [SELECT Id, WhoId, Who.Name, Subject, WhatId, What.Name FROM Task WHERE WhoId IN :contactIds WITH USER_MODE];
  }

  /**
   * @description getEvents
   * @param contactIds
   * @return List<Event>
   */
  public List<Event> getEvents(List<Id> contactIds) {
    return [SELECT Id, WhoId, Who.Name, Subject, WhatId, What.Name FROM Event WHERE WhoId IN :contactIds WITH USER_MODE];
  }

  /**
   * @description getContacts
   * @param contactIds
   * @return List<Contact>
   */
  public List<Contact> getContacts(Set<Id> contactIds) {
    return [SELECT Id, AccountId, Account.Name FROM Contact WHERE Id IN :contactIds WITH USER_MODE];
  }

}