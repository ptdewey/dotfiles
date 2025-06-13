import QtQuick

import "./config"

Item {
    id: root

    required property bool shouldUpdate

    property real playerProgress: {
        const active = Players.active;
        return active?.length ? active.position / active.length : 0;
    }


    function lengthStr(length: int): string {
        if (length < 0)
        return "-1:-1";
        return `${Math.floor(length / 60)}:${Math.floor(length % 60).toString().padStart(2, "0")}`;
    }

    implicitWidth: cover.implicitWidth + DashboardConfig.sizes.mediaVisualiserSize * 2 + details.implicitWidth + details.anchors.leftMargin + bongocat.implicitWidth + bongocat.anchors.leftMargin * 2 + Appearance.padding.large * 2
    implicitHeight: Math.max(cover.implicitHeight + DashboardConfig.sizes.mediaVisualiserSize * 2, details.implicitHeight, bongocat.implicitHeight) + Appearance.padding.large * 2

    Behavior on playerProgress {
        NumberAnimation {
            duration: Appearance.anim.durations.large
            easing.type: Easing.BezierSpline
            easing.bezierCurve: Appearance.anim.curves.standard
        }
    }
}
