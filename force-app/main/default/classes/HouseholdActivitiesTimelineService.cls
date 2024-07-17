public with sharing class HouseholdActivitiesTimelineService {

  private static String STRING_EMPTY = '';
  private static String ID = 'id';
  private static String SUBJECT = 'subject';
  private static String WHOID = 'whoId';
  private static String WHATID = 'whatId';
  private static String TYPE = 'type';
  private static String TYPE_TASK = 'task';
  private static String TYPE_EVENT = 'event';

  private static HouseholdActivitiesTimelineDao dao = new HouseholdActivitiesTimelineDao();

  @AuraEnabled(cacheable=true)
  public static Map<String, List<Map<String, String>>> getHouseholdActivities(String householdAccountId) {
    List<Id> contactIds = getContactIds(householdAccountId);
    Map<Id, List<Map<String, String>>> activities = getTaskAndEventActivities(contactIds);
    Map<String, List<Map<String, String>>> accountNameWithActivities = getPersonAccountActivities(activities);
    return accountNameWithActivities;
  }

  private static List<Id> getContactIds(String householdAccountId) {
    List<AccountContactRelation> recs = dao.getAccountContactRelation(householdAccountId);
    List<Id> contactIds = new List<Id>();
    for (AccountContactRelation rec : recs) {
      contactIds.add(rec.Contact.Id);
    }
    return contactIds;
  }

  private static Map<Id, List<Map<String, String>>> getTaskAndEventActivities(List<Id> contactIds) {
    Map<Id, List<Map<String, String>>> activities = new Map<Id, List<Map<String, String>>>();
    if (!contactIds.isEmpty()) {
      List<Task> tasks = dao.getTasks(contactIds);
      List<Event> events = dao.getEvents(contactIds);

      addTasksToActivities(activities, tasks);
      addEventsToActivities(activities, events);
    }
    return activities;
  }

  private static void addTasksToActivities(Map<Id, List<Map<String, String>>> activities, List<Task> tasks) {
    for (Task task : tasks) {
      if (!activities.containsKey(task.WhoId)) {
        activities.put(task.WhoId, new List<Map<String, String>>());
      }
      String relatedTo = task.What.Name != null ? task.What.Name : STRING_EMPTY;
      String name = task.Who.Name != null ? task.Who.Name : STRING_EMPTY;
      Map<String, String> taskMap = buildMap(task.Id, task.Subject, name, relatedTo, TYPE_TASK);
      activities.get(task.WhoId).add(taskMap);
    }
  }

  private static void addEventsToActivities(Map<Id, List<Map<String, String>>> activities, List<Event> events) {
    for (Event event : events) {
      if (!activities.containsKey(event.WhoId)) {
        activities.put(event.WhoId, new List<Map<String, String>>());
      }
      String relatedTo = event.What.Name != null ? event.What.Name : STRING_EMPTY;
      String name = event.Who.Name != null ? event.Who.Name : STRING_EMPTY;
      Map<String, String> eventMap = buildMap(event.Id, event.Subject, name, relatedTo, TYPE_EVENT);
      activities.get(event.WhoId).add(eventMap);
    }
  }

  private static Map<String, String> buildMap(Id recordId, String recordSubject, String name, String relatedto, String recordType) {
    return new Map<String, String>{
      ID => recordId,
      SUBJECT => recordSubject,
      WHOID => name,
      WHATID => relatedTo,
      TYPE => recordType
    };
  }

  private static Map<String, List<Map<String, String>>> getPersonAccountActivities(Map<Id, List<Map<String, String>>> activities) {
    Map<String, List<Map<String, String>>> accountNameWithActivities = new Map<String, List<Map<String, String>>>();
    List<Contact> contacts = dao.getContacts(activities.keySet());
    for (Contact contact : contacts) {
      if (contact.Account != null) {
        String accountName = contact.Account.Name;
        if (!accountNameWithActivities.containsKey(accountName)) {
          accountNameWithActivities.put(accountName, new List<Map<String, String>>());
        }
        accountNameWithActivities.get(accountName).addAll(activities.get(contact.Id));
      }
    }
    return accountNameWithActivities;
  }
}