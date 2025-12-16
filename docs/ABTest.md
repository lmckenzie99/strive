# A/B Testing Documentation  
## A/B Test Story: SignUp/Login Transition Direction

## User Story Number
US1 (Account Creation)

## A/B Test Name
SignUp/Login Transition: Horizontal vs Vertical Navigation

---

## Metrics

**HEART Metrics:**

- **Happiness**: User satisfaction with the authentication flow (measured through post-signup survey or NPS)
- **Engagement**: Completion rate of signup/login flow, time to complete authentication
- **Adoption**: Percentage of new users who successfully complete account creation
- **Retention**: Return rate of users within 7 days of initial signup
- **Task Success**: Successful authentication attempts on first try, error rate reduction

**Primary KPIs:**
- Authentication flow completion rate
- Time-to-complete signup/login
- Navigation confusion rate (back button taps, repeated transitions)
- Drop-off rate at transition point

---

## Hypothesis

### Problem Statement

Our current signup/login flow uses horizontal transitions (left/right swipe) when users toggle between "Sign Up" and "Log In" modes. This design pattern may be causing confusion and increased drop-off rates because:

1. **User Expectation Mismatch**: Mobile users typically associate horizontal swipes with browsing through similar content (like onboarding slides or image carousels), not modal state changes
2. **Discoverability Issues**: Users may not realize they can swipe horizontally to switch modes, leading to confusion when they're on the wrong screen
3. **Platform Conventions**: Most mobile authentication flows use vertical transitions or tab switches, making our horizontal pattern feel unfamiliar

**Impact Size**: Based on our analytics, approximately 18% of users who reach the authentication screen abandon the flow without completing signup or login. Funnel analysis shows a 7% drop-off specifically at the point where users attempt to switch between signup and login modes, suggesting navigation confusion.

### Hypothesis Statement

**We believe that** implementing vertical transitions (up/down swipe) for switching between Sign Up and Log In modes **will result in** a 15% reduction in authentication flow abandonment and a 10% improvement in time-to-completion **because** vertical navigation better aligns with established mobile UX patterns for hierarchical or modal content changes, reducing cognitive load and improving user confidence in the flow.

**What we're changing**: Only the transition direction when users switch between Sign Up and Log In modes (horizontal → vertical). All other elements remain constant.

---

## Experiment Setup

### Audience Segmentation

**Phase 1 (Initial Test - 2 weeks)**
- **Control Group (Horizontal)**: 50% of new users (users who haven't previously created an account)
- **Variant Group (Vertical)**: 50% of new users
- **Exclusions**: Existing users who are simply logging in (not creating new accounts) will not be part of the experiment to maintain consistency for returning users

**Rationale**: We're targeting new users exclusively because they have no prior experience with our authentication flow, giving us clean data. A 50/50 split ensures adequate sample size for both groups while managing risk.

**Sample Size Calculation**: Based on current traffic (~50,000 new users/month), we'll need approximately 4,400 users per variant to detect a 15% relative improvement with 95% confidence and 80% power.

### Firebase Implementation

**Firebase Remote Config Setup:**
```
Parameter: auth_transition_direction
Values: 
  - Control: "horizontal"
  - Variant: "vertical"
Condition: User not in "existing_users" segment
```

**Firebase A/B Testing Setup:**
- **Experiment Name**: signup_login_transition_direction
- **Targeting**: 100% of new users (app_install_date = recent)
- **Duration**: 14 days minimum (or until statistical significance)
- **Primary Goal**: Custom conversion event "auth_flow_complete"

### Firebase Analytics Tracking

**Events to Track:**

1. **auth_screen_view**
   - Parameters: screen_type (signup/login), transition_variant (horizontal/vertical)
   
2. **auth_mode_switch**
   - Parameters: from_mode (signup/login), to_mode (login/signup), method (button/swipe), transition_variant
   
3. **auth_flow_start**
   - Parameters: entry_point, transition_variant
   
4. **auth_flow_complete**
   - Parameters: mode (signup/login), time_to_complete (ms), transition_variant
   
5. **auth_flow_abandon**
   - Parameters: last_screen, time_on_screen, transition_variant
   
6. **auth_error**
   - Parameters: error_type, screen, transition_variant
   
7. **navigation_confusion_indicator**
   - Triggers when: User taps back button >2 times, or switches modes >3 times within 30 seconds
   - Parameters: confusion_type, transition_variant

**User Properties:**
- transition_experiment_variant: [horizontal/vertical]
- auth_completion_status: [completed/abandoned/in_progress]

**Conversion Funnel Tracking:**
1. auth_screen_view (entry)
2. auth_mode_switch (if applicable)
3. form_field_interaction
4. auth_submit_attempt
5. auth_flow_complete (success)

---

## Variations

### Control: Horizontal Transition (Current Design)

**Description**: Users swipe left/right or tap buttons to transition between Sign Up and Log In screens. The screens slide horizontally, with Sign Up sliding in from the right when coming from Log In, and vice versa.

**Technical Implementation**:
- Animation: Slide transition with 300ms duration
- Direction: Left/right
- Gesture: Horizontal swipe enabled
- Visual cue: Subtle arrow indicators on sides (if present)

**Design Mockup - Control (Horizontal)**:

```
┌─────────────────────────┐      ┌─────────────────────────┐
│    ← SIGN UP    LOGIN   │      │   SIGN UP    LOGIN →    │
│                         │      │                         │
│    [Sign Up Form]       │ ←→   │    [Login Form]         │
│                         │      │                         │
│    • Email              │      │    • Email              │
│    • Password           │      │    • Password           │
│    • Confirm Pass       │      │                         │
│                         │      │                         │
│    [Sign Up Button]     │      │    [Login Button]       │
│                         │      │                         │
└─────────────────────────┘      └─────────────────────────┘
     Swipe ← left/right →
```

---

### Variant: Vertical Transition

**Description**: Users swipe up/down or tap buttons to transition between Sign Up and Log In screens. The screens transition vertically, with the new screen sliding up from below (like a modal sheet) or sliding down from above, depending on the hierarchical relationship.

**Technical Implementation**:
- Animation: Vertical slide with 300ms duration
- Direction: Up/down (Sign Up slides up over Login, Login slides down to reveal underneath)
- Gesture: Vertical swipe enabled
- Visual cue: Pull-down indicator at top of modal (subtle handle/grip)

**Interaction Pattern**:
- Sign Up → Login: Sign Up screen slides down (dismissing modal feeling)
- Login → Sign Up: Sign Up screen slides up (presenting new modal)

**Design Mockup - Variant (Vertical)**:

```
                 ↓ Swipe down
         
┌─────────────────────────┐
│    SIGN UP    LOGIN     │
│         ─────           │  ← Dismissible handle indicator
│                         │
│    [Sign Up Form]       │
│                         │
│    • Email              │
│    • Password           │
│    • Confirm Password   │
│                         │
│    [Sign Up Button]     │
│                         │
│  Already have account?  │
│  [Tap to Login ↓]       │
└─────────────────────────┘

                 ↓ Slides down
                 
┌─────────────────────────┐
│    SIGN UP    LOGIN     │
│         ─────           │
│                         │
│    [Login Form]         │
│                         │
│    • Email              │
│    • Password           │
│                         │
│    [Login Button]       │
│                         │
│  Need an account?       │
│  [Tap to Sign Up ↑]     │
└─────────────────────────┘

                 ↑ Swipe up
```

**Visual Design Changes**:

1. **Modal Sheet Aesthetic**: Add a subtle grip handle at the top (3px height, 32px width, rounded, semi-transparent) to signal vertical swipe capability

2. **Tab Indicator**: Keep the "SIGN UP / LOGIN" toggle at top, but update the active state to feel more like a tab selector rather than equal options

3. **Context Hints**: Add directional language in the CTA area:
   - Below Sign Up form: "Already have an account? Swipe down or tap to login"
   - Below Login form: "Need an account? Swipe up or tap to sign up"

4. **Animation Enhancement**: Add subtle fade + scale effect (0.98x to 1.0x) during transition to enhance the layering perception

**Accessibility Considerations**:
- Maintain button-based navigation for users who cannot swipe
- Ensure screen readers announce the modal state change
- Add haptic feedback on successful transition (iOS/Android)

---

## Success Criteria

**Primary Success Metrics** (must achieve 2 of 3):
- ≥15% reduction in authentication flow abandonment rate
- ≥10% improvement in time-to-completion
- ≥20% reduction in mode-switching confusion indicators

**Secondary Success Metrics**:
- No significant increase in error rates
- Maintain or improve user satisfaction scores
- No negative impact on accessibility metrics

**Decision Framework**:
- **Ship Variant**: If primary success criteria met + no critical regressions
- **Iterate**: If promising but not statistically significant → extend test or refine variant
- **Keep Control**: If no improvement or negative impact detected  
## Quick Summary

**Test Overview**: We're testing whether changing the transition direction between Sign Up and Log In screens from horizontal (left/right swipe) to vertical (up/down swipe) will reduce user confusion and improve authentication flow completion rates.


---
# A/B Test Plan — Pie Chart vs Bar Graph for Detail Analysis

## A/B Test Name
**ChartType_DetailAnalysis_Pie_vs_Bar**

---

## User Story Number
**US4 — Data Visualization / Detail Analysis**

*Goal:* Improve how users understand and act on detailed breakdowns in the analytics/detail screen.

---

## HEART Metrics
| Metric | Description |
|:-------|:-------------|
| **Happiness** | In-app rating after viewing the chart (1–5) |
| **Engagement** | Time on chart and number of interactions (hover, filter, legend clicks) |
| **Adoption** | % of users who open the detailed-analysis view |
| **Retention** | % of users who return to the analytics/detail page within 7 days |
| **Task Success (Primary)** | % of users who successfully complete the target task (export or drill into data) |

**Primary Metric:** Task Success  
**Secondary Metrics:** Engagement, Happiness

---

## Hypothesis
If we present the detailed breakdown as a **bar graph** instead of a **pie chart**, then users will more accurately identify the largest categories and complete the target task, increasing task success by **≥5 percentage points** (e.g., from 20% to 25%).

*Rationale:* Bar graphs make comparisons easier and reduce cognitive load for detail-oriented tasks.

---

## Problem Statement & Impact
**Problem:** Users struggle to extract accurate comparative information from the current pie chart in the Detail Analysis screen. Drop-off occurs at the “identify & take action” step.

**Impact:** Prevents downstream workflows (reporting/exporting). A better visualization could directly improve actionable conversions.

**Narrowed Bottleneck:** Low conversion from viewing details → taking action.  
**Variable Tested:** Chart type (Pie vs Bar).

---

## Experiment Design (Firebase A/B Setup)

### Platform Components
- **Firebase Remote Config:** Deliver chart variant
- **Firebase A/B Testing:** Manage experiment
- **Firebase Analytics:** Log events & measure outcomes

### Audience
- All authenticated users reaching the Detail Analysis screen  
- Exclude internal QA/test accounts  
- **Split:** 50% Pie (Control) / 50% Bar (Variant)

### Sample Size & Duration
- Baseline: 20% task success  
- MDE: +5 percentage points  
- α = 0.05, Power = 0.80 → ~1,095 users per variant (~2,200 total)

---

### Tracking (Firebase Analytics Events)
| Event | Description | Params |
|:------|:-------------|:-------|
| `detail_page_view` | When detail screen is viewed | `chart_variant`, `user_id_type` |
| `chart_hover` | Hover on a chart element | `element`, `value`, `category` |
| `chart_click` | Click on a chart element | `element`, `category` |
| `legend_toggle` | Show/hide legend item | `category`, `visible` |
| `detail_action_completed` | Task completion (goal) | `action_type`, `chart_variant` |
| `detail_chart_rating` | 1–5 satisfaction score | `rating`, `chart_variant` |

**User Properties**
- `chart_variant_assigned`
- `is_internal_user` (for filtering)

**Goals**
- **Primary:** `detail_action_completed`
- **Secondary:** `time_on_chart`, `detail_chart_rating`, engagement counts

---

## Variations

### **Control (A)** — Pie Chart
- Current UI
- Legend on the right
- Tooltip on hover
- Slice click → drill-down

### **Variant (B)** — Bar Graph
- Sorted vertically by value
- X-axis: categories, Y-axis: values
- Labels displayed at end of bars
- Click → drill-down
- Collapsible legend above chart

---

### Mockups

**Control (Pie)**
```

+-------------------------------------+
| Detail Analysis — Pie (Control)     |
|                                     |
|        [ Pie Chart ]                |
|      (slices with tooltips)         |
|                                     |
| Legend: [Cat A] [Cat B] [Cat C]     |
|                                     |
| [Export] [Drill]  Time on chart: 12s|
+-------------------------------------+

```

**Variant (Bar)**
```

+-------------------------------------+
| Detail Analysis — Bar (Variant)     |
|                                     |
| Category      | Value               |
| ----------------------------------- |
| Cat A  ███████████████  42%         |
| Cat B  █████████      20%           |
| Cat C  ████           8%            |
| ...                                 |
|                                     |
| [Sort: Desc] [Toggle Legend]        |
| [Export] [Drill]  Time on chart: 20s|
+-------------------------------------+

```

---

## Implementation Checklist
- [ ] Add Remote Config key `detail_chart_type` (`"pie"` / `"bar"`)
- [ ] Render chart based on Remote Config
- [ ] Include `chart_variant` in all Analytics events
- [ ] Implement one-question satisfaction survey
- [ ] Log errors/fallbacks for chart rendering

---

## Measurement Plan & Analysis
**Primary:**  
Two-proportion z-test comparing `detail_action_completed` across variants.

**Secondary:**  
Compare `time_on_chart`, `detail_chart_rating`, `chart_click` counts.

**Success Criteria:**
- Significant (p < 0.05) uplift ≥ 5pp in task success  
- No negative impact on satisfaction or retention

---

## Rollout Plan
- **Winner:** Roll out to 100% via Remote Config  
- **Monitor:** Metrics for 2 additional weeks  
- **Negative/Neutral:** Revert to control

---

## Risks & Mitigations
| Risk | Mitigation |
|:-----|:------------|
| Sorting/labels inconsistency | Fix sorting & labeling; only chart type varies |
| Mobile layout issues | Responsive design testing |
| Color/legend changes confound | Keep identical color palette |
| Survey bias | Keep identical wording & trigger timing |

---

## Deliverables
- Remote Config key and default
- Analytics event schema
- Firebase A/B config (50/50)
- Design mockups (Pie vs Bar)
- Power calculation summary (~1,095 users per variant)

---

## Quick Summary
Test whether switching the Detail Analysis visualization from a pie chart to a bar chart increases actionable conversions by making category comparisons easier.  
**Run a 50/50 Firebase A/B test**, track `detail_action_completed` as the primary metric, and target **~2,200 total users** to detect a **+5pp uplift**.

---

## **A/B Test Name:** "AI Assistant Toggle: Every Page Placement vs Context-Specific Pages"  

---

## **User Story Number:**  
US3, US4, US5

## **Metrics:**
  * **Happiness:** User satisfaction with AI accessibility (NPS score, in-app satisfaction ratings)
  * **Engagement:** 
    * AI toggle click-through rate
    * Number of AI interactions per session
    * Time spent using AI features
  * **Adoption:** 
    * Percentage of users who activate AI toggle at least once
    * New user AI activation within first week
  * **Retention:** 
    * 7-day and 30-day retention rates for users who engage with AI features vs non-AI users
  * **Task Success:** 
    * Expense categorization accuracy
    * Budget setup completion rate
    * Financial insight utilization rate

## **Hypothesis:** State your hypothesis for this A/B test
  * **What problem are we trying to solve? Its impact?**
    
   ## **Problem:** 
   Currently only a small percentage of Strive users engage with our AI financial assistant feature, despite data showing AI-assisted users categorize expenses more accurately and efficiently. Many users are unaware the AI exists or cannot find it when they need help with complex financial tasks like setting up budgets or understanding spending patterns.
    
  ##**Impact:**  
  Low AI adoption means users struggle with manual expense categorization, take longer to set up budgets, and miss valuable insights. This leads to frustration, lower engagement, and higher churn rates. Through analytics, we identified that users drop off most frequently during:
    1. First-time budget creation (45% drop-off rate)
    2. Bulk expense categorization (38% drop-off rate)
    3. Monthly spending reviews (52% abandonment rate)
    
   These are exactly the tasks where AI assistance would be most valuable.
    
  **Bottleneck in the conversion funnel:** 
  The AI assistant is currently buried in Settings → Help → AI Assistant. Users don't discover it when they need it most. Heat map analysis shows users looking for help/guidance during complex financial tasks but not finding accessible support. Additionally, we're unsure if AI should be available everywhere (which might cause "banner blindness") or only on complex screens where it's truly helpful.
    
  **Single Variable Being Tested:**  
  We are testing only the AI toggle button placement strategy (global vs context-specific), while keeping all other variables constant (button design, AI functionality, interaction patterns, response quality).

## **Hypothesis:**
    
  **Primary Hypothesis (Variation A - Global Placement):** 
  If we place the AI toggle button on every screen in a consistent bottom-right corner, then we will increase AI adoption by 35-40% because users will always know where to find assistance regardless of their task, establishing a predictable pattern for AI access.
    
   **Alternative Hypothesis (Variation B - Context-Specific):** 
   If we display the AI toggle only on high-complexity financial screens (expense entry, budget creation, spending analysis, receipt scanning), users will perceive the AI as more intelligent and contextually relevant, leading to 30-40% higher engagement per interaction, though overall discoverability may be 15-20% lower than the global approach.
    
  **Variable Being Tested:**  
  AI toggle button placement strategy (every page vs. context-specific pages). All other variables remain constant including button design, AI functionality, and user interaction patterns.
---
## **Experiment:** 

  * **Firebase A/B Testing Setup:**
    
    We will use Firebase A/B Testing integrated with Firebase Remote Config to control which AI toggle placement strategy users experience.
  
  * **Audience Allocation:**
    * **Total experiment allocation:** 100% of active user base
      * **Variation A (Global Placement):** 50% of users
      * **Variation B (Context-Specific):** 50% of users
    
    **Rationale:**
    100% allocation provides sufficient data for statistical significance while equal split between test variations enables clear performance comparison. Since we're replacing the current hidden implementation, there's no need for a control group maintaining the old behavior.
  
  * **Audience Segmentation & Targeting:**
    * **Include:** 
      * Users who completed onboarding (Day 3+ users)
      * Users who have logged at least 5 expenses
      * Both iOS and Android users
    * **Exclude:**
      * Brand new users in their first 2 days (to avoid confusing onboarding experience)
      * Users currently in other active A/B tests
      * Beta testers and internal team members
      * Users who haven't logged any expenses yet
  
  * **Experiment Duration:**
    * **Minimum Runtime:** 21 days to capture full monthly financial cycles and weekend vs weekday usage patterns
    * **Target Sample Size:** 6,000 users per variation (calculated for 80% statistical power, 95% confidence level)
    * **Early Stopping:** Will not stop before 21 days, even if results appear significant, to capture complete monthly billing cycles
  
  * **Firebase Remote Config Parameters:**
    * **Config Key:** `ai_toggle_strategy`
    * **Values:**
      * `global` - AI button appears on every screen
      * `context_specific` - AI button appears only on high-value screens
    * **Dynamic Control:** Allows real-time switching between variations without app updates
  
  * **Firebase Analytics Event Tracking:**
    
    We will implement the following custom events to track HEART metrics:
    
    **1. Happiness Metrics:**
    * Event: `user_feedback_survey`
      * Parameters: `nps_score` (0-10), `ai_helpfulness_rating` (1-5), `discovery_ease` (1-5), `variation_id`, `user_id`, `timestamp`
      * Trigger: Weekly in-app prompt to random 20% sample of users
    
    **2. Engagement Metrics:**
    * Event: `ai_toggle_impression`
      * Parameters: `screen_name`, `expense_count`, `user_segment`, `variation_id`, `session_id`, `timestamp`
      * Trigger: When AI button renders on screen (impression tracking)
    
    * Event: `ai_toggle_tap`
      * Parameters: `screen_name`, `action` (open/close), `time_on_screen`, `variation_id`, `session_id`, `timestamp`
      * Trigger: When user taps the AI toggle button
    
    * Event: `ai_conversation_start`
      * Parameters: `screen_name`, `query_type`, `variation_id`, `user_id`, `timestamp`
      * Trigger: When user initiates AI chat or interaction
    
    * Event: `ai_interaction_complete`
      * Parameters: `screen_name`, `duration_seconds`, `messages_exchanged`, `user_satisfaction`, `variation_id`, `timestamp`
      * Trigger: When AI conversation ends
    
    **3. Adoption Metrics:**
    * Event: `ai_first_use`
      * Parameters: `variation_id`, `user_id`, `days_since_signup`, `screen_name`, `timestamp`
      * Trigger: First time user engages with AI toggle button
    
    * Event: `ai_weekly_user`
      * Parameters: `variation_id`, `user_id`, `total_interactions_this_week`, `timestamp`
      * Trigger: Once per week for users who used AI at least once
    
    **4. Retention Metrics:**
    * Event: `user_retention_7day`
      * Parameters: `variation_id`, `user_id`, `used_ai` (boolean), `ai_interaction_count`, `timestamp`
      * Trigger: When user returns to app on day 7 after experiment start
    
    * Event: `user_retention_30day`
      * Parameters: `variation_id`, `user_id`, `total_ai_interactions`, `tasks_completed`, `timestamp`
      * Trigger: When user returns to app on day 30
    
    **5. Task Success Metrics:**
    * Event: `ai_task_completion`
      * Parameters: `task_type` (categorize/budget/analyze), `duration_seconds`, `satisfaction_rating` (1-5), `variation_id`, `timestamp`
      * Trigger: When AI helps user complete a financial task
    
    * Event: `expense_categorization`
      * Parameters: `ai_assisted` (boolean), `time_to_complete`, `accuracy` (correct/incorrect), `variation_id`, `timestamp`
      * Trigger: When user saves an expense with category
    
    * Event: `budget_setup_flow`
      * Parameters: `step_completed`, `ai_assisted` (boolean), `abandoned` (boolean), `variation_id`, `timestamp`
      * Trigger: At each step of budget creation wizard
    
    * Event: `spending_insight_view`
      * Parameters: `insight_type`, `ai_generated` (boolean), `action_taken`, `variation_id`, `timestamp`
      * Trigger: When user views financial insights on analytics page
  
  * **Firebase Analytics Audiences:**
    
    Create custom audiences for segmentation analysis:
    * "AI First-Time Users" - users who triggered `ai_first_use` event
    * "Frequent AI Users" - users with 5+ AI interactions per week
    * "Budget Creators" - users who completed budget setup
    * "High-Value Users" - users with 20+ expenses logged per month
    * "Drop-off Risk" - users who started budget setup but didn't complete
  
  * **Success Criteria:**
    * **Primary:** 30% increase in AI feature adoption rate (% of users using AI at least once) with p < 0.05
    * **Secondary:** 20% improvement in budget setup completion rate
    * **Secondary:** NPS increase of 8+ points for AI users
    * **Guard Rail:** < 5% decrease in overall app engagement or task completion rates

* **Variations:**
  ---
  
  ### **Variation A: Global AI Toggle (Every Screen)**
  
  **Description:**
  A persistent AI assistant button appears in the bottom-right corner of every screen in the Strive app. The button is a 54x54px circular design with Strive's brand green gradient and a sparkle/chat icon (✨💬). It remains visible as users navigate through all features.
  
  **Design Specifications:**
  * **Position:** Fixed bottom-right corner, 20px from bottom edge, 20px from right edge
  * **Size:** 54x54px circular button (shrinks to 40x40px after 8 seconds on static screens)
  * **Visual Style:**
    * Brand green gradient (#00C853 to #00E676)
    * Subtle pulse animation (1.0s ease-in-out loop)
    * Drop shadow for elevation (0px 4px 10px rgba(0,0,0,0.15))
  * **Icon:** Sparkle chat bubble icon (✨💬)
  * **Interaction:**
    * Single tap opens AI chat overlay
    * Long-press (0.5s) shows quick actions menu (categorize expense, analyze spending, budget help)
    * Scales slightly on tap for feedback
  * **Z-index:** Always visible but uses smart positioning to avoid blocking primary CTAs and floating action buttons
  * **Accessibility:** Includes aria-label "AI Financial Assistant" and meets WCAG AA standards
  
  **Appears on ALL screens:**
  * Dashboard
  * Add Expense
  * Expense List
  * Budget Creation
  * Budget Overview
  * Spending Analytics
  * Receipt Scanner
  * Category Management
  * Settings
  * Profile
  * All other app screens
  
  **Mockup - Dashboard with Global AI:**
  ```
  ┌─────────────────────────────┐
  │ ☰  Strive    October   👤   │
  ├─────────────────────────────┤
  │                             │
  │  Monthly Budget: $3,200     │
  │  Spent: $2,156 (67%)        │
  │  [▓▓▓▓▓▓▓░░░]               │
  │                             │
  │  Recent Expenses            │
  │  ┌───────────────────────┐  │
  │  │ 🍔 Lunch    -$15.99  │  │
  │  │ ⛽ Gas       -$45.00  │  │
  │  │ 🎬 Movies   -$24.50  │  │
  │  └───────────────────────┘  │
  │                             │
  │  [➕ Add Expense]            │
  │                        ┌──┐ │
  │                        │✨│ │ ← AI Toggle
  │                        └──┘ │   (Always visible)
  └─────────────────────────────┘
  ```
  
  **Mockup - Add Expense Screen with Global AI:**
  ```
  ┌─────────────────────────────┐
  │ ←  Add Expense          ✓   │
  ├─────────────────────────────┤
  │                             │
  │  Amount                     │
  │  ┌─────────────────────┐    │
  │  │ $                   │    │
  │  └─────────────────────┘    │
  │                             │
  │  Category                   │
  │  ┌─────────────────────┐    │
  │  │ Select category ▼   │    │
  │  └─────────────────────┘    │
  │                             │
  │  Date                       │
  │  ┌─────────────────────┐    │
  │  │ Oct 27, 2025    📅  │    │
  │  └─────────────────────┘    │
  │                             │
  │  Notes (optional)           │
  │  ┌─────────────────────┐    │
  │  │                     │    │
  │  └─────────────────────┘    │
  │                        ┌──┐ │
  │                        │✨│ │ ← AI Toggle
  │                        └──┘ │   (Always visible)
  └─────────────────────────────┘
  ```
  
  **User Experience Flow for Variation A:**
  1. User opens app → Sees AI button on dashboard
  2. User navigates to any screen → AI button maintains consistent position
  3. User encounters difficulty → Taps AI button for help
  4. AI chat overlay slides up → Provides contextual assistance based on current screen
  5. User learns AI is always available in same location
  
  ---
  
  ### **Variation B: Context-Specific AI Toggle**
  
  **Description:**
  The AI assistant button appears only on screens where AI can provide meaningful financial assistance. Uses identical design to Variation A but appears selectively based on task complexity and AI value-add potential.
  
  **Design Specifications:**
  * **Position:** Same as Variation A (bottom-right corner, 20px margins)
  * **Size:** 54x54px circular button
  * **Visual Style:** Identical to Variation A (green gradient, pulse animation)
  * **Icon:** Same sparkle chat bubble icon (✨💬)
  * **Interaction:** Same tap and long-press behaviors as Variation A
  * **Entrance Animation:** Gentle fade-in with slide-up effect (300ms) when appearing on eligible screens
  * **Tooltip:** First-time appearance shows contextual tooltip: "Need help? AI can assist!" (auto-dismisses after 3s)
  * **Exit Animation:** Fade-out (200ms) when navigating away from eligible screens
  
  **Screens WHERE AI toggle APPEARS:**
  1. **Add Expense Screen** - AI helps auto-categorize, suggests merchants, detects duplicates
  2. **Budget Creation Wizard** - AI provides personalized budget recommendations based on spending history
  3. **Spending Analytics Page** - AI offers insights on spending patterns, trends, and savings opportunities
  4. **Receipt Scanner** - AI assists with OCR extraction and expense details
  5. **Bulk Expense Import** - AI helps categorize multiple expenses quickly
  6. **Category Management** - AI suggests custom categories based on user behavior
  
  **Screens where AI toggle does NOT appear:**
  * Expense List (simple navigation, viewing only)
  * Category List (simple viewing)
  * Settings pages
  * Profile pages
  * Static information screens
  * Payment/Subscription screens
  * Onboarding flows (separate AI introduction flow)
  * Simple dashboard views without analytics
  
  **Mockup - Budget Creation with AI (Button Visible):**
  ```
  ┌─────────────────────────────┐
  │ ←  Create Budget            │
  ├─────────────────────────────┤
  │                             │
  │  Set Your Monthly Budget    │
  │                             │
  │  Total Income               │
  │  ┌─────────────────────┐    │
  │  │ $ 4,500             │    │
  │  └─────────────────────┘    │
  │                             │
  │  Budget Categories          │
  │  ┌─────────────────────┐    │
  │  │ 🏠 Housing  $1,200  │    │
  │  │ 🍔 Food     $600    │    │
  │  │ 🚗 Transport $400   │    │
  │  │ ➕ Add more...      │    │
  │  └─────────────────────┘    │
  │                             │
  │  [Continue]                 │
  │                        ┌──┐ │
  │                        │✨│ │ ← AI Toggle
  │                        └──┘ │   (Visible - can help)
  └─────────────────────────────┘
  ```
  
  **Mockup - Expense List (AI Button Hidden):**
  ```
  ┌─────────────────────────────┐
  │ ☰  Expenses    October  🔍  │
  ├─────────────────────────────┤
  │                             │
  │  October 27                 │
  │  ┌───────────────────────┐  │
  │  │ 🍔 Lunch    -$15.99   │  │
  │  │ ⛽ Gas       -$45.00  │  │
  │  └───────────────────────┘  │
  │                             │
  │  October 26                 │
  │  ┌───────────────────────┐  │
  │  │ 🎬 Movies   -$24.50  │   │
  │  │ 🛒 Grocery  -$87.23  │   │
  │  └───────────────────────┘  │
  │                             │
  │  October 25                 │
  │  ┌───────────────────────┐  │
  │  │ ☕ Coffee   -$5.75    │  │
  │  └───────────────────────┘  │
  │                             │
  │  [➕ Add Expense]           │
  │                             │ ← No AI Toggle
  └─────────────────────────────┘   (Simple list view)
  ```
  
  **Mockup - Spending Analytics with AI (Button Visible):**
  ```
  ┌─────────────────────────────┐
  │ ←  Spending Insights        │
  ├─────────────────────────────┤
  │                             │
  │  October 2025               │
  │                             │
  │  Top Categories             │
  │  ┌─────────────────────┐    │
  │  │ 🍔 Food      $845   │    │
  │  │ 🏠 Housing   $1200  │    │
  │  │ 🚗 Transport $340   │    │
  │  └─────────────────────┘    │
  │                             │
  │  [📊 View Trends]           │
  │                             │
  │  Spending Pattern           │
  │    ▁▃▅▇▆▄▂                │
  │                             │
  │                        ┌──┐ │
  │                        │✨│ │ ← AI Toggle
  │                        └──┘ │   (Visible - can analyze)
  └─────────────────────────────┘
  ```
  
  **Mockup - Settings Page (AI Button Hidden):**
  ```
  ┌─────────────────────────────┐
  │ ←  Settings                 │
  ├─────────────────────────────┤
  │                             │
  │  Account                    │
  │  › Profile Information      │
  │  › Email & Password         │
  │                             │
  │  Preferences                │
  │  › Notifications            │
  │  › Currency & Format        │
  │                             │
  │  Privacy & Security         │
  │  › Data & Privacy           │
  │  › Biometric Lock           │
  │                             │
  │  About                      │
  │  › Help & Support           │
  │                             │ ← No AI Toggle
  └─────────────────────────────┘   (Not needed here)
  ```
  
  **User Experience Flow for Variation B:**
  1. User opens app → No AI button on dashboard
  2. User navigates to expense entry → AI button fades in smoothly
  3. User sees tooltip on first appearance → Understands AI is available here
  4. User completes task and navigates to expense list → AI button fades out
  5. User navigates to analytics page → AI button reappears
  6. User learns AI appears when it can be most helpful
  
  ---
  
  ### **Comparison Matrix**
  
  | Feature | Variation A (Every Page) | Variation B (Context-Specific) |
  |---------|-------------------------|--------------------------------|
  | **Visibility** | High - Always present | Medium - Selective appearance |
  | **Discovery Rate** | Highest expected (35-40% lift) | Moderate expected (25-30% lift) |
  | **Context Relevance** | Mixed - not always needed | High - appears when valuable |
  | **Perceived Value** | Risk of generic/ignored | Higher - smart contextual placement |
  | **User Learning Curve** | Easy - consistent location | Slightly higher - appears/disappears |
  | **Clutter/Intrusiveness** | Moderate risk on simple screens | Low risk - only on complex screens |
  | **Engagement Quality** | Potentially lower per interaction | Higher expected per interaction |
  | **Banner Blindness Risk** | Higher | Lower |

---

## Analysis Plan

After 21 days, we will analyze results using Firebase A/B Testing console and Firebase Analytics:

### Statistical Analysis
* **Significance Testing:** Two-tailed t-tests comparing both variations
* **Required Confidence:** 95% (p < 0.05)
* **Effect Size:** Calculate Cohen's d for practical significance
* **Sample Size Validation:** Ensure minimum 6,000 users per variation reached

### Segmentation Analysis
Break down results by:
* User tenure (new users Days 3-30 vs established users 30+ days)
* Usage frequency (daily, weekly, monthly active users)
* Platform (iOS vs Android)
* Financial behavior (budget users vs non-budget users, high vs low expense volume)
* AI interaction depth (single use vs multi-use vs power users)

### Decision Framework
* **Clear Winner:** If one variation shows >25% improvement in adoption with p < 0.05 and no negative impact on retention, roll out to 100%
* **Mixed Results:** If Variation A wins adoption but Variation B wins engagement quality, consider hybrid approach (global with smart contextual hints)
* **No Significant Difference:** If neither variation significantly outperforms the other (<10% difference), choose Variation B for lower intrusiveness
* **Negative Results:** If both variations decrease key metrics, revert to current implementation and investigate user feedback

---

## A/B Test Story: Button Placement in Guidance AI Page

### User Story Number
US 4 (Guidance AI Interaction)

### A/B Test Name
Guidance AI Prompt Submission: Integrated vs Separated Button Placement

---

## Metrics

### HEART Metrics:
- **Happiness:** User satisfaction with the prompt submission interface (measured through post-interaction survey or feedback)
- **Engagement:** Prompt submission rate, time to first prompt submission, frequency of prompt revisions
- **Adoption:** Percentage of users who submit at least one prompt within their first session
- **Retention:** Return rate of users to Guidance AI page within 7 days
- **Task Success:** Successful prompt submissions on first attempt, reduced hesitation time, lower abandonment rate

### Primary KPIs:
- Prompt submission completion rate
- Time-to-first-submission (from page load to first prompt sent)
- Click accuracy rate (clicks on submit button vs misclicks)
- Prompt abandonment rate (users who type but don't submit)
- Interaction confusion rate (cursor hovering without action, multiple button searches)

---

## Hypothesis

### Problem Statement
Our current Guidance AI page uses a separated button placement model where the submit button is positioned at the bottom of the page, distinct from the prompt input area. This design pattern may be causing friction and reduced submission rates because:

1. **User Expectation Mismatch:** The majority of AI chat interfaces (ChatGPT, Claude, Grok) use an integrated button approach where the submit action is immediately adjacent to or within the prompt bar. Users have been conditioned by these market leaders to expect the submit button in close proximity to where they type.

2. **Visual Separation Issues:** Placing the button at the bottom of the page creates a spatial disconnect between the input action (typing) and the submission action (clicking button). This may increase cognitive load as users must shift their visual focus away from the prompt area to locate the submit button.

3. **Platform Conventions:** ChatGPT established the "OG format" that has become the de facto standard for AI interfaces. Claude and Grok followed this pattern, suggesting industry consensus on optimal UX. Only Gemini uses a different approach, and we're uncertain if users prefer this deviation.

4. **Reduced Discoverability:** Users may not immediately notice the separated button, especially on first use, leading to confusion about how to submit their prompt.

**Impact Size:** Based on preliminary observations, we suspect users may be experiencing hesitation or abandonment when trying to submit prompts. Analytics suggest potential friction in the submission flow, though exact metrics will be established during test baseline period.

### Hypothesis Statement
We believe that implementing an integrated button placement (positioned inside or immediately adjacent to the prompt bar on the right side, following the ChatGPT/Claude/Grok pattern) will result in a **12-15% increase in prompt submission completion rates** and a **20% reduction in time-to-first-submission** because the integrated placement aligns with established AI chat interface conventions, reduces spatial scanning, decreases cognitive load, and leverages user familiarity with the dominant market pattern.

**What we're changing:** Only the position of the submit button (bottom of page → integrated with prompt bar on the right). All other elements including prompt bar design, page layout, and functionality remain constant.

## Experiment Setup

### Audience Segmentation

#### Phase 1 (Initial Test - 2 weeks)
- **Control Group (Separated Button - Gemini-style):** 50% of users accessing Guidance AI page
- **Variant Group (Integrated Button - ChatGPT/Claude-style):** 50% of users accessing Guidance AI page
- **Exclusions:** None initially, though we may segment by new vs. returning users in analysis to understand differential impact
- **Rationale:** A 50/50 split ensures adequate sample size for both groups while managing risk. We're including all users (new and returning) to understand broad impact across user familiarity levels.

**Sample Size Calculation:** Based on current Guidance AI page traffic (~[INSERT MONTHLY TRAFFIC] users/month), we'll need approximately [INSERT CALCULATED NUMBER] users per variant to detect a 12-15% relative improvement with 95% confidence and 80% power.

### Firebase Implementation

#### Firebase Remote Config Setup:
- **Parameter:** `guidance_button_placement`
- **Values:**
  - Control: `"separated"` (button at bottom of page)
  - Variant: `"integrated"` (button integrated with prompt bar)
- **Condition:** All users accessing Guidance AI page

#### Firebase A/B Testing Setup:
- **Experiment Name:** `guidance_ai_button_placement`
- **Targeting:** 100% of users accessing Guidance AI page
- **Duration:** 14 days minimum (or until statistical significance)
- **Primary Goal:** Custom conversion event `"guidance_prompt_submitted"`

---

### Firebase Analytics Tracking

#### Events to Track:

1. **guidance_page_view**
   - Parameters: `button_variant` (separated/integrated), `user_type` (new/returning), `session_id`

2. **guidance_prompt_input_start**
   - Parameters: `button_variant`, `timestamp`, `session_id`

3. **guidance_prompt_input_focus**
   - Parameters: `button_variant`, `focus_duration` (ms), `characters_typed`

4. **guidance_button_search_indicator**
   - Triggers when: Cursor hovers around page for >3 seconds after typing, or multiple clicks outside button area
   - Parameters: `search_time` (ms), `button_variant`, `click_attempts`

5. **guidance_prompt_submitted**
   - Parameters: `button_variant`, `time_to_submit` (ms from page load), `prompt_length`, `submission_method` (button_click/enter_key)

6. **guidance_prompt_abandoned**
   - Triggers when: User types >10 characters but leaves page without submitting
   - Parameters: `characters_typed`, `time_on_page`, `button_variant`, `cursor_position_last`

7. **guidance_button_click**
   - Parameters: `button_variant`, `click_accuracy` (direct_click/after_search), `time_from_input_end` (ms)

8. **guidance_enter_key_submit**
   - Parameters: `button_variant`, `prompt_length`

9. **guidance_error_state**
   - Parameters: `error_type`, `button_variant`, `user_action_attempted`

#### User Properties:
- `button_placement_variant`: [separated/integrated]
- `guidance_submission_status`: [completed/abandoned/in_progress]
- `guidance_user_experience_level`: [first_time/returning]

#### Conversion Funnel Tracking:
1. `guidance_page_view` (entry)
2. `guidance_prompt_input_start`
3. `guidance_prompt_input_focus`
4. `guidance_button_click` OR `guidance_enter_key_submit`
5. `guidance_prompt_submitted` (success)

---

## Variations

### Control: Separated Button (Current Design - Gemini-style)

#### Description
The submit button is positioned at the bottom of the page, spatially separated from the prompt input area. Users type their prompt in the text input field, then must locate and click the button below to submit.

#### Technical Implementation:
- **Button Position:** Fixed or positioned at bottom of page container
- **Layout:** Prompt bar spans width of container, button appears below with margin spacing
- **Visual Separation:** Clear vertical space between prompt input and button
- **Enter Key Behavior:** [Specify current behavior - submits or new line]

#### Design Mockup - Control (Separated):
```
┌─────────────────────────────────────────┐
│         Guidance AI Page                │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │                                   │ │
│  │  Enter your prompt here...        │ │
│  │                                   │ │
│  └───────────────────────────────────┘ │
│                                         │
│              (spacing)                  │
│                                         │
│         ┌─────────────────┐             │
│         │  Submit Prompt  │             │
│         └─────────────────┘             │
│                                         │
└─────────────────────────────────────────┘
```

#### User Flow:
1. User clicks into prompt input area
2. User types their prompt
3. User shifts visual focus down to locate submit button
4. User moves cursor/clicks to button
5. User clicks to submit


### Variant: Integrated Button (ChatGPT/Claude/Grok-style)

#### Description
The submit button is integrated into or immediately adjacent to the prompt bar on the right side. Users type their prompt and can immediately submit by clicking the button positioned within their visual field, following the pattern established by ChatGPT, Claude, and Grok.

#### Technical Implementation:
- **Button Position:** Right side of prompt bar, inline with input area
- **Layout:** Prompt bar contains both text input and submit button in unified component
- **Integration Style:** Button appears as icon or small button inside prompt bar right edge (similar to send icon in messaging apps)
- **Visual Cohesion:** Button and input share same container/border
- **Enter Key Behavior:** [Should match control - specify behavior]
- **Responsive Behavior:** Button remains visible and accessible at all screen sizes

#### Design Mockup - Variant (Integrated):
```
┌─────────────────────────────────────────┐
│         Guidance AI Page                │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │                                ┌─┐│ │
│  │  Enter your prompt here...     │→││ │
│  │                                └─┘│ │
│  └───────────────────────────────────┘ │
│                                         │
│                                         │
│                                         │
│                                         │
│                                         │
│                                         │
└─────────────────────────────────────────┘
```

**Alternative Variant Design (Outside but Adjacent):**
```
┌─────────────────────────────────────────┐
│         Guidance AI Page                │
│                                         │
│  ┌─────────────────────────────┐  ┌──┐ │
│  │                             │  │→ │ │
│  │  Enter your prompt here...  │  └──┘ │
│  │                             │       │
│  └─────────────────────────────┘       │
│                                         │
└─────────────────────────────────────────┘
```

#### User Flow:
1. User clicks into prompt input area
2. User types their prompt
3. User clicks submit button immediately visible to the right (minimal eye/cursor movement)
4. Prompt submitted

#### Visual Design Changes:
- **Button Icon:** Use right arrow (→) or paper plane icon consistent with AI chat conventions
- **Button State:** 
  - Disabled/grey when prompt is empty
  - Active/colored when text is present
  - Hover state with subtle animation
- **Spacing:** Minimal padding between input edge and button (2-4px)
- **Size:** Button should be clearly clickable (minimum 32x32px touch target for mobile)

#### Accessibility Considerations:
- Maintain keyboard navigation support (Tab to focus button)
- Ensure Enter key behavior is consistent across both variants
- Screen reader announces button position and state
- Sufficient color contrast for button in all states
- Button label/aria-label: "Submit prompt" or "Send"

## Success Criteria

### Primary Success Metrics (must achieve 2 of 3):
1. **≥12% increase in prompt submission completion rate**
2. **≥20% reduction in time-to-first-submission**
3. **≥25% reduction in button search indicators** (cursor hovering, search time)

### Secondary Success Metrics:
- No increase in accidental submissions (error rate)
- Maintain or improve user satisfaction scores
- No negative impact on accessibility metrics
- Consistent performance across device types (desktop/mobile/tablet)

### Decision Framework:
- **Ship Variant:** If primary success criteria met + no critical regressions
- **Iterate:** If promising but not statistically significant → extend test or refine button design/positioning
- **Keep Control:** If no improvement or negative impact detected

# A/B Test Story: Numerical vs. Graphical Weekly Spending Comparison

## A/B Test Name
**"Weekly Spending Comparison: Numerical vs. Graphical Display"**

## User Story Number
**US4** (Golden Path)

## Metrics
This A/B test measures the following HEART metrics:

- **Happiness**: User satisfaction with data visualization clarity (measured via in-app survey)
- **Engagement**: 
  - Time spent on trend analysis page
  - Frequency of visits to trend analysis page
  - Interaction rate with comparison data (clicks, hovers, taps)
- **Adoption**: Percentage of users who view weekly comparison data within first 7 days
- **Retention**: Week-over-week return rate to trend analysis page
- **Task Success**: 
  - Ability to correctly identify spending increases/decreases (measured via optional quiz)
  - Time to comprehend spending changes

---

## Hypothesis

### Problem Statement
Users are not effectively engaging with their weekly spending comparison data on the trend analysis page. Current analytics show:
- **65% of users** who land on the trend analysis page **spend less than 5 seconds** viewing the weekly comparison section
- **Only 28% of users** return to the trend analysis page within a week
- User interviews reveal confusion about whether spending is improving or worsening week-over-week

**Impact**: This is a critical problem because understanding spending trends is a core value proposition of our app. If users cannot quickly grasp their financial progress, they lose motivation to continue tracking, leading to churn. Our data shows users who regularly check their trend analysis have **3.2x higher retention** at 90 days.

### Bottleneck Analysis
The conversion funnel shows a significant drop-off:
1. 100% - Users land on trend analysis page
2. 45% - Users scroll to weekly comparison section
3. 28% - Users spend >5 seconds viewing comparison
4. 12% - Users return within 7 days

The bottleneck is at the **engagement with comparison data** stage.

### Root Cause Hypothesis
The current numerical display requires cognitive effort to interpret the data. Users must read two numbers, calculate the difference mentally, and determine if the trend is positive or negative. This friction causes users to disengage before gaining insights.

### Proposed Solution
**Variation B (Graphical Display)** will present weekly spending comparisons using two side-by-side bar graphs. Visual representation should:
- Reduce cognitive load by making comparisons immediately apparent
- Increase engagement through more appealing visual design
- Improve comprehension speed by leveraging visual pattern recognition

**Expected Outcome**: Graphical display will increase time spent on trend analysis page by 40% and improve 7-day return rate by 25%.

### Variable Being Tested
**Single variable**: Display format of weekly spending comparison (numerical vs. graphical)

---

## Experiment Setup

### Firebase Configuration

**Experiment Name**: `weekly_comparison_display_format`

**Experiment ID**: `exp_trend_viz_001`

### Audience Allocation

**Total Experiment Population**: 80% of active users
- **Control Group (Variation A - Numerical)**: 40% of users
- **Treatment Group (Variation B - Graphical)**: 40% of users
- **Holdout Group**: 20% of users (excluded from experiment)

**Eligibility Criteria**:
- Users who have been active for at least 14 days (ensures they have sufficient data for weekly comparisons)
- Users who have visited the trend analysis page at least once
- Users on app version 2.5.0 or higher

**Rationale for Audience Allocation**:
- **80% allocation**: Allows us to gather statistically significant data quickly while maintaining a safety net (20% holdout) in case of technical issues
- **50/50 split** between variations: Standard practice for A/B testing to ensure equal sample sizes
- **Active users only**: New users without historical data cannot see meaningful weekly comparisons
- **Version requirement**: Ensures Firebase SDK compatibility and consistent rendering

### Duration
- **Test Duration**: 21 days (3 weeks)
- **Rationale**: Captures 3 full weekly cycles, accounting for day-of-week behavioral variations and providing sufficient time for engagement patterns to emerge

### Success Criteria
The test will be considered successful if Variation B achieves:
- **Primary metric**: ≥20% increase in time spent on trend analysis page (statistical significance: p < 0.05)
- **Secondary metric**: ≥15% increase in 7-day return rate
- **Guardrail metric**: No decrease >5% in overall app engagement

---

## Firebase Analytics Tracking Setup

### Events to Track

#### 1. Page View Events
```
Event: trend_analysis_page_view
Parameters:
  - user_id
  - session_id
  - variation (control/treatment)
  - timestamp
  - entry_point (navigation/deep_link/push_notification)
```

#### 2. Comparison View Events
```
Event: weekly_comparison_viewed
Parameters:
  - user_id
  - variation
  - view_duration (seconds)
  - timestamp
  - scroll_depth (percentage)
```

#### 3. Interaction Events
```
Event: comparison_interaction
Parameters:
  - user_id
  - variation
  - interaction_type (tap/hover/zoom)
  - element_id
  - timestamp
```

#### 4. Comprehension Events (Optional Survey)
```
Event: comparison_quiz_completed
Parameters:
  - user_id
  - variation
  - correct_answers
  - total_questions
  - completion_time (seconds)
```

#### 5. Return Visit Events
```
Event: trend_page_return_visit
Parameters:
  - user_id
  - variation
  - days_since_last_visit
  - timestamp
```

### Custom User Properties
```
User Property: experiment_group
Values: control_numerical / treatment_graphical / holdout
```

### Firebase Remote Config
Use Remote Config to dynamically serve variations:
```
Parameter: weekly_comparison_display_type
Default: numerical
Conditional values:
  - If experiment_group == "control_numerical": numerical
  - If experiment_group == "treatment_graphical": graphical
```

### Firebase A/B Testing Integration
- **Primary Goal**: Maximize `weekly_comparison_viewed` duration
- **Secondary Goals**: 
  - Increase `trend_page_return_visit` frequency
  - Improve `comparison_quiz_completed` accuracy score

---

## Variations

### **Variation A: Control - Numerical Display**

#### Description
Current implementation showing weekly spending as numerical values with percentage change.

#### Design Elements
- Two numerical values displayed vertically or horizontally
- "This Week" and "Last Week" labels
- Percentage change indicator with color coding (green for decrease, red for increase in spending)
- Currency formatted with $ symbol

#### Mockup - Variation A (Numerical)
```
┌─────────────────────────────────────┐
│      Weekly Spending Comparison     │
├─────────────────────────────────────┤
│                                     │
│  This Week:        $487.32          │
│  Last Week:        $562.18          │
│                                     │
│  Difference:       -$74.86          │
│  Change:           ↓ 13.3%          │
│                                     │
│  [You spent 13.3% less this week]   │
│  Great job! 🎉                      │
│                                     │
└─────────────────────────────────────┘
```

#### Technical Implementation
- Simple text labels and values
- CSS styling for color-coded change indicators
- Lightweight, fast rendering

---

### **Variation B: Treatment - Graphical Display**

#### Description
Weekly spending displayed as two side-by-side bar graphs with visual comparison and summary text.

#### Design Elements
- Two vertical bar charts positioned side-by-side
- Y-axis shows spending amount with grid lines
- X-axis labels: "Last Week" and "This Week"
- Color-coded bars (neutral blue for last week, green/red for this week based on change)
- Percentage change badge overlay
- Visual height difference makes trend immediately apparent
- Supporting numerical values displayed below bars

#### Mockup - Variation B (Graphical)
```
┌─────────────────────────────────────────────┐
│        Weekly Spending Comparison           │
├─────────────────────────────────────────────┤
│                                             │
│   $600 ┤                                    │
│        │     ████                           │
│   $500 ┤     ████                           │
│        │     ████                           │
│   $400 ┤     ████          ████             │
│        │     ████          ████             │
│   $300 ┤     ████          ████             │
│        │     ████          ████             │
│   $200 ┤     ████          ████             │
│        │     ████          ████             │
│   $100 ┤     ████          ████             │
│        │     ████          ████             │
│     $0 ┴─────────────────────────────       │
│         Last Week      This Week            │
│          $562.18        $487.32             │
│                                             │
│        ┌──────────────┐                     │
│        │  ↓ 13.3%     │                     │
│        └──────────────┘                     │
│                                             │
│   You spent $74.86 less this week           │
│   Keep up the great work! 🎉                │
│                                             │
└─────────────────────────────────────────────┘
```

#### Interactive Features
- Tap on bars to see exact values in tooltip
- Subtle animation on page load (bars grow from $0 to actual value)
- Haptic feedback on mobile when interacting with bars

#### Technical Implementation
- Chart.js or Recharts library for rendering
- Responsive design for different screen sizes
- Accessibility: ARIA labels for screen readers describing the comparison
- Cached rendering to maintain performance

---

## Design Assets Required

### For Variation A (Minimal Changes)
- ✅ Already implemented (current production design)
- No additional design work needed

### For Variation B (New Design)
1. **High-fidelity mockups** showing:
   - Mobile view (iOS and Android)
   - Tablet view
   - Web view (if applicable)
   - Various spending scenarios (increase, decrease, no change)
   
2. **Interactive prototype** demonstrating:
   - Bar tap interactions
   - Animation sequences
   - Tooltip displays

3. **Design specifications**:
   - Color palette (bar colors, grid lines, background)
   - Typography (axis labels, values, summary text)
   - Spacing and padding measurements
   - Animation timing and easing curves

4. **Accessibility documentation**:
   - Color contrast ratios
   - Screen reader announcements
   - Alternative text descriptions

---

## Risk Assessment & Mitigation

### Potential Risks

1. **Performance Impact**: Graphical rendering may slow down page load
   - **Mitigation**: Implement lazy loading, optimize chart library bundle size, monitor performance metrics

2. **Data Accuracy**: Visual representations might be misinterpreted
   - **Mitigation**: Include numerical values alongside graphs, use clear labels and legends

3. **User Confusion**: Some users may prefer numerical data
   - **Mitigation**: Monitor feedback channels, consider adding a toggle option in future iteration

---

## Decision Framework

### When to Ship Variation B
- Primary metric shows ≥20% improvement with p < 0.05
- No negative impact on guardrail metrics
- No critical bugs or user complaints in feedback

### When to Ship Variation A (Keep Control)
- No significant difference between variations (p > 0.10)
- Variation B shows worse performance on primary or secondary metrics
- Technical issues persist beyond acceptable threshold

### When to Iterate
- Results are promising but not conclusive (10-20% improvement, 0.05 < p < 0.10)
- User feedback suggests modifications to graphical approach
- Consider hybrid approach or user preference toggle
