# Household Activities Timeline

Overview:
A solution that pertains to Salesforce Financial Services Cloud platform that includes an advanced Activity Timeline Component designed to enhance visibility and organisation of activities within a financial services context. The component is engineered to display activities based on multiple criteria including Name, Related To, AccountId, and Household.

Key Features:
Activity Association:When an activity is linked to a Person Account or Individual through Name (WhoID) or Related To (WhatId), the system identifies if the individual belongs to a Household.

Household Roll-Up:
If the individual is part of a Household, a Financial Services Cloud Trigger automatically updates the activity to include a reference to the Household by populating the activity's Household lookup field.

Comprehensive Activity Timeline:
The Activity Timeline Component ensures that activities are "rolled up" and displayed on the Household’s Activity Timeline. This provides a consolidated view of all activities associated with the Household.

Problem Addressed:
In existing systems, activities linked to individual members of a Household do not appear on the Household's Activity Timeline. Users must navigate to each member's Activity Timeline or check the Household's Activities related list to view these activities, leading to fragmented and inefficient activity tracking.

Solution:
The proposed Activity Timeline Component addresses this issue by ensuring that all relevant activities are visible directly on the Household’s Activity Timeline. This consolidation simplifies tracking and provides a unified view of all interactions and activities related to the Household.

Benefits:
Improved Visibility: Users can see all activities associated with a Household in one place, enhancing their ability to manage and analyse interactions.

Enhanced Efficiency: Reduces the need to navigate between multiple timelines or lists, saving time and improving workflow efficiency.

Better Organisation: Centralises activity data, making it easier to track and manage household-related activities.

Use Case:
Financial Advisors: Can efficiently monitor all client interactions at the household level, ensuring comprehensive oversight and better client service.

Customer Support: Provides a complete view of household activities, enabling support staff to assist clients more effectively.

Github Repository:
This is an open source project.
https://github.com/SalesforceLabs/household-activities-timeline

Developers:
Tejas Bal
Pratisha Sarma


- [Salesforce AppExchange Listing](https://appexchange.salesforce.com/appxListingDetail?listingId=5aa1cec0-4e65-438b-8349-cc1f1be9d4fa)
- [Documentation](https://salesforce.quip.com/STUhAcMaTtC1)
- [Report issues, ask questions, seek help](https://github.com/SalesforceLabs/household-activities-timeline/issues)