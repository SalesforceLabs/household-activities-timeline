/**
 * @description This class calls the dao and builds map of events and tasks of all the contacts in the household
 * and used in the LWC wiring to get the activities and show it in the view.
 * @author tbal
 */
public class HatHouseholdActivityService {

  private static HatHouseholdActivityDao dao = new HatHouseholdActivityDao();

  @AuraEnabled(cacheable=true)
  /**
   * @description This function calls the method to get the tasks and events of the contacts in the household
   * @param householdAccountId
   * @return Map<String, List<Map<String, String>>>
   */
  public static Map<String, List<Map<String, String>>> getHouseholdActivities(String householdAccountId) {
    List<Id> contactIds = getContactIds(householdAccountId);
    Map<Id, List<Map<String, String>>> activities = getTaskAndEventActivities(contactIds);
    Map<String, List<Map<String, String>>> accountNameWithActivities = getPersonAccountActivities(activities);
    return accountNameWithActivities;
  }

  /**
   * @description This function calls the method to get the contacts in the household
   * @param householdAccountId
   * @return List<Id>
   */
  private static List<Id> getContactIds(String householdAccountId) {
    List<AccountContactRelation> recs = dao.getAccountContactRelation(householdAccountId);
    List<Id> contactIds = new List<Id>();
    for (AccountContactRelation rec : recs) {
      contactIds.add(rec.Contact.Id);
    }
    return contactIds;
  }

  /**
   * @description This function calls the method to get all the tasks and events of the contacts in the household
   * @param contactIds
   * @return Map<Id, List<Map<String, String>>>
   */
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

  /**
   * @description This function calls the method to build tasks
   * @param activities
   * @param tasks
   */
  private static void addTasksToActivities(Map<Id, List<Map<String, String>>> activities, List<Task> tasks) {
    for (Task task : tasks) {
      if (!activities.containsKey(task.WhoId)) {
        activities.put(task.WhoId, new List<Map<String, String>>());
      }
      String relatedTo = task.What.Name != null ? task.What.Name : '';
      String name = task.Who.Name != null ? task.Who.Name : '';
      Map<String, String> taskMap = new Map<String, String> {
        'id' => task.Id,
        'subject' => task.Subject,
        'whoId' => name,
        'whatId' => relatedTo,
        'type' => 'task'
      };
      activities.get(task.WhoId).add(taskMap);
    }
  }

  /**
   * @description This function calls the method to build events
   * @param activities
   * @param events
   */
  private static void addEventsToActivities(Map<Id, List<Map<String, String>>> activities, List<Event> events) {
    for (Event event : events) {
      if (!activities.containsKey(event.WhoId)) {
        activities.put(event.WhoId, new List<Map<String, String>>());
      }
      String relatedTo = event.What.Name != null ? event.What.Name : '';
      String name = event.Who.Name != null ? event.Who.Name : '';
      Map<String, String> eventMap = new Map<String, String> {
        'id' => event.Id,
        'subject' => event.Subject,
        'whoId' => name,
        'whatId' => relatedTo,
        'type' => 'event'
      };
      activities.get(event.WhoId).add(eventMap);
    }
  }

  /**
   * @description This function calls the method to get the person account activities
   * @param activities
   * @return Map<String, List<Map<String, String>>>
   */
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