---
name: temporal-flowchart
description: Generate ASCII flowcharts and activity tables from Temporal workflow event history JSON files. This skill should be used when the user asks to "chart a workflow", "visualize temporal events", "create a flowchart from events", "show activity dependencies", "analyze workflow execution", or provides a Temporal event history JSON file for analysis.
---

# Temporal Workflow Flowchart Generator

Generate ASCII dependency flowcharts and activity summary tables from Temporal workflow event history JSON exports and/or DAG workflow YAML configs.

## Input Sources

1. **Event history JSON** - Exported from Temporal UI or `tctl`. Contains `events` array with activity scheduling, start, and completion events. Provides actual execution timing.
2. **DAG workflow YAML** - The workflow config YAML (e.g., `lease-short-app.yaml`). Contains the canonical `depends_on` relationships and activity definitions. Provides dependency structure.

Use both when available. The YAML gives the full dependency graph; the JSON gives actual runtime behavior and timing.

## Process

### Step 1: Extract Activity Data

From the event JSON, extract activities from `EVENT_TYPE_ACTIVITY_TASK_SCHEDULED` events:

- **Activity name**: Found in `activityTaskScheduledEventAttributes.input.payloads[0].data.ActivityName` for HTTP activities
- **GoRules decision name**: Found in `activityTaskScheduledEventAttributes.input.payloads[0].data.Decision` for GoRules activities
- **Activity type**: Found in `activityTaskScheduledEventAttributes.activityType.name` (HTTP, GoRules, WriteLegacyDecision, AuditLog, etc.)
- **Timing**: Compare `eventTime` of SCHEDULED vs COMPLETED events (matched via `scheduledEventId`)

Use `scripts/parse_events.py` to automate extraction. Pass the JSON file path as an argument.

### Step 2: Build Dependency Graph

From the DAG workflow YAML, extract the `depends_on` lists for each activity. If no YAML is available, infer execution tiers from scheduling timestamps in the JSON (activities scheduled at the same time are in the same tier).

Compute topological tiers: an activity's tier = max(tier of dependencies) + 1. Activities with no dependencies are tier 0.

### Step 3: Generate Output

Produce two sections:

#### ASCII Flowchart

Group activities by execution tier. Show dependencies with `<-` arrows. Format:

```
TIER 0 (no deps - all parallel)
├── ACTIVITY-A ──── (HTTP, 69ms)
├── ACTIVITY-B ──── (HTTP, 40ms)
└── ACTIVITY-C ──── (GoRules, 39ms)

TIER 1
├── ACTIVITY-D ──── (HTTP, 32ms)  <- ACTIVITY-A
└── ACTIVITY-E ──── (HTTP, 85ms)  <- ACTIVITY-B, ACTIVITY-C

...

POST-DAG (parallel)
├── WriteLegacyDecision (30ms)
└── AuditLog            (20ms)
```

Use `├──` for non-last items and `└──` for the last item in each tier. Right-pad activity names for alignment. Include type and duration in parentheses. Show `skipped` for activities that were conditionally skipped.

#### Activity Table

Markdown table with columns: Tier, Activity, Type, Dependencies, Duration.

#### Notes Section

Include:
- **Critical path**: The longest dependency chain with summed duration
- **Bottlenecks**: Activities with the highest individual duration
- **Skipped activities**: Note any conditionally skipped activities and why
- **Counts**: Total activities, total tiers, how many start in parallel

### Step 4: Write Output

Write the result to a `.md` file. Use the workflow name or a sensible default derived from the input filename.

## Additional Resources

### Scripts

- **`scripts/parse_events.py`** - Parses a Temporal event history JSON file and outputs activity names, types, dependencies (inferred from timing), and durations as JSON. Use this for quick extraction before formatting.
