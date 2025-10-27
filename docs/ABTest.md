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


Team Member: [Andrew Fleet]

A/B Test Name: AI Assistant Toggle: Every Page Placement vs Context-Specific Pages
User Story Number: US3 , US4 , US5
Metrics:

Happiness: User satisfaction with AI accessibility (NPS score, in-app satisfaction ratings)
Engagement: AI toggle click-through rate, number of AI interactions per session, time spent using AI features
Adoption: Percentage of users who activate AI toggle at least once, new user AI activation within first week
Retention: 7-day and 30-day retention rates for users who engage with AI features vs non-AI users
Task Success: Expense categorization accuracy, budget setup completion rate, financial insight utilization rate


Hypothesis:

What problem are we trying to solve? Its impact?

Problem: Currently only x% of Strive users engage with our AI financial assistant feature, despite data showing AI-assisted users categorize expenses. Many users are unaware the AI exists or cannot find it when they need help with complex financial tasks like setting up budgets or understanding spending patterns.

Impact: Low AI adoption means users struggle with manual expense categorization, take longer to set up budgets, and miss valuable insights. This leads to frustration, lower engagement, and higher churn rates. Through analytics, we identified that users drop off most frequently during: (1) first-time budget creation, (2) bulk expense categorization , and (3) monthly spending reviews . These are exactly the tasks where AI assistance would be most valuable.

Bottleneck: The AI assistant is currently buried in Settings → Help → AI Assistant. Users don't discover it when they need it most. Additionally, we're unsure if AI should be available everywhere (which might cause "banner blindness") or only on complex screens where it's truly helpful.
Single Variable: We are testing only the AI toggle button placement strategy (global vs context-specific), while keeping all other variables constant (button design, AI functionality, interaction patterns).


Hypothesis Statement:

If we place the AI toggle button on every screen in a consistent bottom-right corner, then we will increase AI adoption by x% because users will always know where to find assistance regardless of their task, establishing a predictable pattern for AI access.
Alternative Hypothesis: If we display the AI toggle only on high-complexity financial screens (expense entry, budget creation, spending analysis, receipt scanning), users will perceive the AI as more intelligent and contextually relevant, leading to 30-40% higher engagement per interaction, though overall discoverability may be 15-20% lower than the global approach.




Experiment:

Audience Allocation:

Total experiment allocation: 100% of active user base
Variation A (Global Placement): 50% of users
Variation B (Context-Specific): 50% of users


Rationale: 100% allocation provides sufficient data for statistical significance while equal split between test variations enables clear performance comparison.

Audience Segmentation:

Include: Users who completed onboarding (Day 3+), have logged at least 5 expenses



Experiment Duration: 21 days minimum to capture full monthly financial cycles and weekend vs weekday usage patterns. 

Firebase Analytics Tracking:

Events to track:

ai_toggle_impression - Parameters: screen_name, expense_count, user_segment, variation_id - Triggers when AI button renders on screen
ai_toggle_tap - Parameters: screen_name, action (open/close), time_on_screen, variation_id - Triggers on button tap
ai_conversation_start - Parameters: screen_name, query_type, variation_id - Triggers when user initiates AI chat
ai_task_completion - Parameters: task_type (categorize/budget/analyze), duration, satisfaction_rating, variation_id - Triggers when AI helps complete a task
expense_categorization - Parameters: ai_assisted (boolean), time_to_complete, accuracy, variation_id - Triggers on expense save
budget_setup_flow - Parameters: step_completed, ai_assisted (boolean), abandoned (boolean), variation_id - Triggers at each budget setup step
user_feedback_survey - Parameters: nps_score, ai_helpfulness_rating, discovery_ease, variation_id - Triggers via weekly prompt


Firebase Remote Config:

Key: ai_toggle_strategy
Values: global, context_specific, control
Dynamic toggle for real-time variant switching


Success Criteria:

Primary: 30% increase in AI feature adoption
Secondary: 20% improvement in budget setup completion rate
Secondary: NPS increase of 8+ points for AI users






Variations:

Variation A: Global AI Toggle (Every Screen)

Description: A persistent AI assistant button appears in the bottom-right corner of every screen in the Strive app. The button is a 54x54px circular design with Strive's brand green gradient and a sparkle/chat icon (✨💬). It remains visible as users navigate through all features.
Design Specifications:

Position: Fixed bottom-right, 20px from bottom, 20px from right edge
Size: 54x54px (shrinks to 40x40px after 8 seconds on static screens)
Color: Brand green gradient (#00C853 to #00E676) with subtle pulse animation
Icon: Sparkle chat bubble icon
Interaction: Tap opens AI chat overlay, long-press shows quick actions (categorize expense, analyze spending, budget help)
Z-index: Always visible but smart positioning avoids blocking primary CTAs and FABs


Appears on ALL screens: Dashboard, Add Expense, Expense List, Budget Creation, Budget Overview, Spending Analytics, Receipt Scanner, Categories, Settings, Profile, all other screens
Mockup - Dashboard with Global AI:





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
      │                        │✨│ │ <- AI Toggle
      │                        └──┘ │ (Always visible)
      └─────────────────────────────┘
```
    * Mockup - Add Expense Screen with Global AI:
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
      │                        │✨│ │ <- AI Toggle
      │                        └──┘ │ (Always visible)
      └─────────────────────────────┘
```
  
  * **Variation B: Context-Specific AI Toggle**
    * Description: The AI assistant button appears only on screens where AI can provide meaningful financial assistance. Uses identical design to Variation A but appears selectively based on task complexity and AI value-add.
    * Design Specifications: Same 54x54px size, green gradient, sparkle icon, and interaction patterns as Variation A. Includes gentle fade-in animation (300ms) when appearing on eligible screens. Shows contextual tooltip on first appearance: "Need help? AI can assist!"
    * Screens WHERE AI toggle appears:
      1. **Add Expense Screen** - AI helps auto-categorize, suggests merchants, detects duplicates
      2. **Budget Creation Wizard** - AI provides personalized budget recommendations based on spending history
      3. **Spending Analytics Page** - AI offers insights on spending patterns, trends, and savings opportunities
      4. **Receipt Scanner** - AI assists with OCR extraction and expense details
      5. **Bulk Expense Import** - AI helps categorize multiple expenses quickly
      6. **Category Management** - AI suggests custom categories based on user behavior
    * Screens where AI toggle does NOT appear:
      * Simple navigation (Expense List, Category List)
      * Settings and Profile pages
      * Static information pages
      * Payment/Subscription screens
      * Onboarding flows (separate AI introduction)
    * Mockup - Budget Creation with AI (Visible):
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
      │                        │✨│ │ <- AI Toggle
      │                        └──┘ │ (Visible - can help)
      └─────────────────────────────┘
```
    * Mockup - Expense List (AI Hidden):
```
      ┌─────────────────────────────┐
      │ ☰  Expenses    October  🔍  │
      ├─────────────────────────────┤
      │                             │
      │  October 27                 │
      │  ┌───────────────────────┐  │
      │  │ 🍔 Lunch    -$15.99  │  │
      │  │ ⛽ Gas       -$45.00  │  │
      │  └───────────────────────┘  │
      │                             │
      │  October 26                 │
      │  ┌───────────────────────┐  │
      │  │ 🎬 Movies   -$24.50  │  │
      │  │ 🛒 Grocery  -$87.23  │  │
      │  └───────────────────────┘  │
      │                             │
      │  October 25                 │
      │  ┌───────────────────────┐  │
      │  │ ☕ Coffee   -$5.75   │  │
      │  └───────────────────────┘  │
      │                             │
      │  [➕ Add Expense]            │
      │                             │ <- No AI Toggle
      └─────────────────────────────┘ (Simple list view)
```
    * Mockup - Spending Analytics with AI (Visible):
```
      ┌─────────────────────────────┐
      │ ←  Spending Insights         │
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
      │  [📊 View Trends]            │
      │                             │
      │  Spending Pattern           │
      │    ▁▃▅▇▆▄▂                  │
      │                             │
      │                        ┌──┐ │
      │                        │✨│ │ <- AI Toggle
      │                        └──┘ │ (Visible - can analyze)
      └─────────────────────────────┘

