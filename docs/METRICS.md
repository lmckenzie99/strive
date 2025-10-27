HEART Framework Metrics
- https://docs.google.com/presentation/d/1DQiLZtovgMRINwEHNepGJAObAbs4A98cLrvkJ5Q9jdk/edit?usp=sharing

### Happiness Metrics

* **Net Promoter Score (NPS)** - Implement an in-app survey prompt (Firebase Cloud Functions trigger after 7 days of usage) asking "How likely are you to recommend Strive to a friend?" (0-10 scale). Store responses in Firestore collection `nps_surveys` with fields: `userId`, `score`, `timestamp`, `feedback_text`.  

* **% of positive vs negative reviews** - Use App Store Connect API and Google Play Console API to fetch reviews programmatically. Store aggregated data in Firestore `app_reviews` collection, or manually track weekly in Firebase Analytics custom events.  

* **Customer Satisfaction Score (CSAT)** - Add post-interaction surveys (e.g., after completing first savings goal) with "How satisfied are you with this experience?" (1-5 scale). Store in Firestore `csat_responses` collection with `userId`, `rating`, `feature`, `timestamp`.  

### Engagement Metrics

* **Average Daily Habit Tracking Rate**  
  Measures the percentage of habits tracked by users each day compared to the total habits created.  
  Use Firebase Analytics to log a `habit_tracked` event and store total habits per user in Firestore.  
  **Formula:** `(habits_tracked_today / total_habits_created) * 100`  
  This shows how consistently users engage with their habits after onboarding.

* **DAU / MAU Ratio**  
  Tracks product stickiness by comparing the number of daily active users (DAU) to monthly active users (MAU).  
  Use Firebase Analytics’ active user metrics or custom events like `app_open` or `dashboard_view`.  
  **Formula:** `(DAU / MAU) * 100`  
  A higher ratio indicates users return frequently and are forming usage habits.

* **Average Session Duration**  
  Calculates how long users spend in the app per session.  
  Firebase automatically records session durations using `user_engagement` events.  
  **Formula:** `total_session_time / number_of_sessions`  
  Longer average durations may suggest strong engagement or that users find value in the app’s features.

* **Number of Habits per Active User**  
  Measures how many unique habits each active user tracks over a given period.  
  Pull data from the Firestore `habits` collection and divide total habits by the number of active users in the same timeframe.  
  **Formula:** `total_habits / active_users`  
  This metric helps identify how deeply users are adopting the habit-tracking functionality.
  
### Adoption Metrics

* **% of downloads who complete onboarding** - Firebase Analytics tracks app installs via `first_open` event. Create custom event `onboarding_completed` triggered when users reach final onboarding screen. Calculate conversion rate: (onboarding_completed / first_open) * 100.  

* **% of users who create 3+ habits in first week** - Firebase Authentication provides signup timestamps. Query Firestore `habits` collection where `createdAt` is within 7 days of user's `creationTime` in Firebase Auth. Count users with ≥3 habits and divide by total new signups.  

* **New user activation rate** - Define "activated" (e.g., completed onboarding + logged first habit + visited dashboard). Create custom Firebase Analytics event `user_activated` with these conditions. Track ratio of activated users to new signups.  

* **Time to first habit created** - Calculate difference between Firebase Authentication `creationTime` and earliest `createdAt` timestamp in user's Firestore `habits` subcollection. Store aggregated data in BigQuery or calculate on-demand.

### Task Success Metrics

* **Average Savings Per User per Month** - Query Firestore `habits` collection for habits marked as "savings" (vs "drains"). Sum `costPerOccurrence * timesCompleted` per user per month. Store monthly aggregates in `user_stats` collection.

* **% of users hitting first savings goal** - Store savings goals in Firestore `users/{userId}/goals` with fields: `targetAmount`, `currentAmount`, `achieved`, `achievedDate`. Create custom Firebase Analytics event `first_goal_achieved`. Calculate percentage of users with at least one `achieved: true` goal.

* **Habit logged without errors** - Track error rate by logging custom events: `habit_log_attempt` and `habit_log_error` (with error type parameter). Calculate success rate: 1 - (errors / attempts). Store error logs in Firestore `error_logs` for debugging.

* **Support ticket volume** - If using Firebase Extensions for customer support, track tickets in Firestore. Otherwise, integrate with third-party support tools (Zendesk, Intercom) and pull data via API. Store monthly counts in `support_metrics` collection or export to BigQuery for trending analysis.

