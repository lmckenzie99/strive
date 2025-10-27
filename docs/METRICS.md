HEART Framework Metrics
- https://docs.google.com/presentation/d/1DQiLZtovgMRINwEHNepGJAObAbs4A98cLrvkJ5Q9jdk/edit?usp=sharing

Happiness -  • Net Promoter Score (NPS)
             • % of positive vs negative reviews
             • Customer Satisfaction Score (CSAT)
  
### Adoption Metrics

* **% of downloads who complete onboarding** - Firebase Analytics tracks app installs via `first_open` event. Create custom event `onboarding_completed` triggered when users reach final onboarding screen. Calculate conversion rate: (onboarding_completed / first_open) * 100.  

* **% of users who create 3+ habits in first week** - Firebase Authentication provides signup timestamps. Query Firestore `habits` collection where `createdAt` is within 7 days of user's `creationTime` in Firebase Auth. Count users with ≥3 habits and divide by total new signups.  

* **New user activation rate** - Define "activated" (e.g., completed onboarding + logged first habit + visited dashboard). Create custom Firebase Analytics event `user_activated` with these conditions. Track ratio of activated users to new signups.  

* **Time to first habit created** - Calculate difference between Firebase Authentication `creationTime` and earliest `createdAt` timestamp in user's Firestore `habits` subcollection. Store aggregated data in BigQuery or calculate on-demand.  

