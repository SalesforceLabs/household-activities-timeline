import getHouseholdActivities from '@salesforce/apex/HatHouseholdActivityService.getHouseholdActivities';
import { LightningElement, api, wire } from 'lwc';

export default class hatHouseholdActivitiesTimeline extends LightningElement {
  @api recordId;
  accountActivities;
  error;

  @wire(getHouseholdActivities, { householdAccountId: '$recordId' })
  wiredActivities({ error, data }) {
    if (data) {
        this.accountActivities = this.mapDataToList(data);
    } else if (error) {
        console.error('Error fetching household activities:', error);
    }
  }

  mapDataToList(data) {
    return Object.entries(data).map(([accountName, activities]) => ({
      accountName,
      activities: activities.map(activity => ({
        id: activity.id,
        subject: activity.subject,
        whoId: activity.whoId,
        whatId: activity.whatId,
        message: this.getActivityMessage(activity),
        url: this.getRecordUrl(activity.id),
        iconName: this.getIconName(activity)
      }))
    }));
  }
  
  toggleAccordion(event) {
    const accountName = event.currentTarget.getAttribute('aria-controls');
    this.accountActivities = this.accountActivities.map(account => {
      if (account.accountName === accountName) {
        account.expanded = !account.expanded;
        account.contentClass = account.expanded ? 'slds-accordion__content' : 'slds-accordion__content slds-hide';
      }
      return account;
    });
  }

  activeAccountName = '';
  handleToggleSection(event) {
    this.activeAccountName = event.detail.openSections[0];
  }

  getActivityMessage(activity) {
    return (activity.whatId!='' && activity.whatId != activity.whoId) ?
      `You have an upcoming ${activity.type} with ${activity.whoId} about ${activity.whatId}` :
      `You have an upcoming ${activity.type} with ${activity.whoId}`;
  }

  //to fetch task and events
  getRecordUrl(recordId) {
    return `/${recordId}`;
  }

  getIconName(activity) {
    if (activity.type === 'task') {
      return 'standard:task';
    } else if (activity.type === 'event') {
      return 'standard:event';
    }
    return '';
  }

}