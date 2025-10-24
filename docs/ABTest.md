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
