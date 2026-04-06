#!/usr/bin/env python3
"""Parse Temporal workflow event history JSON and extract activity data.

Usage:
    python3 parse_events.py <events.json> [--yaml <workflow.yaml>]

Outputs JSON with activity names, types, timing, and inferred execution tiers.
"""

import json
import sys
import argparse
from datetime import datetime


def parse_timestamp(ts):
    return datetime.fromisoformat(ts.replace("Z", "+00:00"))


def extract_activities(events):
    scheduled = {}
    completed = {}

    for e in events:
        etype = e["eventType"]
        eid = int(e["eventId"])

        if etype == "EVENT_TYPE_ACTIVITY_TASK_SCHEDULED":
            attrs = e["activityTaskScheduledEventAttributes"]
            act_type = attrs["activityType"]["name"]
            payloads = attrs.get("input", {}).get("payloads", [])

            name = ""
            for p in payloads:
                d = p.get("data", {})
                if isinstance(d, dict):
                    name = d.get("ActivityName", "")
                    if not name and act_type == "GoRules":
                        name = d.get("Decision", "")
                    if not name:
                        name = f"{act_type}_{eid}"
                if name:
                    break

            scheduled[eid] = {
                "name": name,
                "type": act_type,
                "scheduledTime": e["eventTime"],
                "scheduledEventId": eid,
            }

        elif etype == "EVENT_TYPE_ACTIVITY_TASK_COMPLETED":
            attrs = e["activityTaskCompletedEventAttributes"]
            sched_id = int(attrs.get("scheduledEventId", 0))
            completed[sched_id] = e["eventTime"]

    activities = []
    for eid in sorted(scheduled.keys()):
        info = scheduled[eid]
        sched_time = parse_timestamp(info["scheduledTime"])
        comp_time_str = completed.get(eid, "")

        duration_ms = None
        if comp_time_str:
            comp_time = parse_timestamp(comp_time_str)
            duration_ms = round((comp_time - sched_time).total_seconds() * 1000)

        activities.append({
            "name": info["name"],
            "type": info["type"],
            "scheduledEventId": eid,
            "scheduledTime": info["scheduledTime"],
            "completedTime": comp_time_str,
            "durationMs": duration_ms,
        })

    return activities


def infer_tiers(activities, threshold_ms=5):
    """Group activities into execution tiers based on scheduling timestamps.

    Activities scheduled within threshold_ms of each other are considered
    part of the same tier (they were dispatched in the same workflow task).
    """
    if not activities:
        return activities

    sorted_times = sorted(set(parse_timestamp(a["scheduledTime"]) for a in activities))

    # Cluster timestamps into tiers using a gap threshold
    tier = 0
    time_to_tier = {sorted_times[0]: 0}
    for i in range(1, len(sorted_times)):
        gap_ms = (sorted_times[i] - sorted_times[i - 1]).total_seconds() * 1000
        if gap_ms > threshold_ms:
            tier += 1
        time_to_tier[sorted_times[i]] = tier

    for a in activities:
        a["tier"] = time_to_tier[parse_timestamp(a["scheduledTime"])]

    return activities


def parse_yaml_deps(yaml_path):
    """Parse depends_on from a DAG workflow YAML (simple parser, no pyyaml needed)."""
    deps = {}
    current_activity = None

    with open(yaml_path) as f:
        for line in f:
            stripped = line.rstrip()
            # Activity name (top-level key under activities:)
            if stripped and not stripped.startswith(" ") and not stripped.startswith("#"):
                continue
            # 2-space indented key ending with colon = activity name
            if len(stripped) - len(stripped.lstrip()) == 2 and stripped.rstrip().endswith(":") and not stripped.strip().startswith("#") and not stripped.strip().startswith("-"):
                current_activity = stripped.strip().rstrip(":")
                deps[current_activity] = []
            # depends_on list items
            elif current_activity and "depends_on" in stripped:
                continue  # next lines will have the deps
            elif current_activity and stripped.strip().startswith("- ") and current_activity in deps:
                dep = stripped.strip().lstrip("- ").strip()
                # Only add if it looks like a dependency (not a YAML list under params)
                if dep and not dep.startswith("{") and ":" not in dep:
                    deps[current_activity].append(dep)

    return deps


def main():
    parser = argparse.ArgumentParser(description="Parse Temporal event history JSON")
    parser.add_argument("events_json", help="Path to events JSON file")
    parser.add_argument("--yaml", help="Path to DAG workflow YAML for dependency info")
    args = parser.parse_args()

    with open(args.events_json) as f:
        data = json.load(f)

    events = data.get("events", data if isinstance(data, list) else [])
    activities = extract_activities(events)
    activities = infer_tiers(activities)

    yaml_deps = None
    if args.yaml:
        yaml_deps = parse_yaml_deps(args.yaml)

    output = {
        "totalActivities": len(activities),
        "activities": activities,
    }
    if yaml_deps:
        output["dependencies"] = yaml_deps

    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
