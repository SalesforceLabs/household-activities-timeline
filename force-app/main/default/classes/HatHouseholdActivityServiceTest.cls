/**
 * This class contains unit tests for validating the behavior of HouseholdActivitiesTimelineService class.
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
    
    System.assertEquals(2, activities.get('Brad Household').size());

    Map<String, String> taskActivity = activities.get('Brad Household')[0];
    Map<String, String> meetActivity = activities.get('Brad Household')[1];

    System.assertEquals('Call', taskActivity.get('subject'));
    System.assertEquals('task', taskActivity.get('type'));
    System.assertEquals('Jane Doe', taskActivity.get('whoId'));
    System.assertEquals('John Doe', taskActivity.get('whatId'));

    System.assertEquals('Meeting', meetActivity.get('subject'));
    System.assertEquals('May Doe', meetActivity.get('whoId'));
    System.assertEquals('event', meetActivity.get('type'));
    System.assertEquals('John Doe', meetActivity.get('whatId'));
  }
}