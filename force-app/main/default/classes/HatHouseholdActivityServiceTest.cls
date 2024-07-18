/**
 * @description This class contains unit tests for validating the behavior of HouseholdActivitiesTimelineService class.
 * @author tbal
 */
@isTest
public class HatHouseholdActivityServiceTest {

  private @isTest static void getHouseholdActivitiesTest() {
    
    Account householdAccount = new Account(Name = 'Brad Household');
    insert householdAccount;

    Contact contactJane = new Contact(
      AccountId = householdAccount.Id,
      FirstName = 'Jane',
      LastName = 'Doe'
    );
    insert contactJane;

    Contact contactMay = new Contact(
      AccountId = householdAccount.Id,
      FirstName = 'May',
      LastName = 'Doe'
    );
    insert contactMay;

    Account personAccJohn = new Account(Name = 'John Doe');
    insert personAccJohn;

    List<Task> tasks = new List<Task>();
    tasks.add(new Task(
      WhoId = contactJane.id,
      WhatId = personAccJohn.Id,
      Subject = 'Call',
      ActivityDate = Date.today()
    ));
    insert tasks;

    List<Event> events = new List<Event>();
    events.add(new Event(
      WhoId = contactMay.id,
      WhatId = personAccJohn.Id,
      Subject = 'Meeting',
      ActivityDate = Date.today(),
      DurationInMinutes = 60,
      ActivityDateTime = Datetime.now()
    ));
    insert events;

    Map<String, List<Map<String, String>>> activities = HatHouseholdActivityService.getHouseholdActivities(householdAccount.Id);
    
    System.assertEquals(2, activities.get('Brad Household').size(), 'There are 2 contacts with activities in this household');

    Map<String, String> taskActivity = activities.get('Brad Household')[0];
    Map<String, String> meetActivity = activities.get('Brad Household')[1];

    System.assertEquals('Call', taskActivity.get('subject'), 'Call subject');
    System.assertEquals('task', taskActivity.get('type'), 'Task activity');
    System.assertEquals('Jane Doe', taskActivity.get('whoId'), 'Who Id is Jane Doe');
    System.assertEquals('John Doe', taskActivity.get('whatId'), 'What Id is John Doe');

    System.assertEquals('Meeting', meetActivity.get('subject'), 'Meeting subject');
    System.assertEquals('May Doe', meetActivity.get('whoId'), 'Who Id is May Doe');
    System.assertEquals('event', meetActivity.get('type'), 'Event activity');
    System.assertEquals('John Doe', meetActivity.get('whatId'), 'What Id is John Doe');

  }
}