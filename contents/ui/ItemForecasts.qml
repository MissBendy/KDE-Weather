// QML item displaying hourly and daily weather forecasts using Kirigami components
import QtQuick
import QtQuick.Layouts 1.1
import org.kde.kirigami as Kirigami

Item {
    id: root

    // Stores the maximum width needed for forecast text labels
    property int widthTxt: 0

    // Top half: hourly forecast
    Row {
        id: hourlyForecast
        width: parent.width
        height: parent.height / 2

        // Repeat for each hourly forecast entry
        Repeater {
            model: forecastHours
            delegate: Item {
                width: parent.width / 5
                height: parent.height

                Column {
                    width: parent.width
                    height: parent.height
                    spacing: Kirigami.Units.iconSizes.small / 3
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Hour label (12h or 24h format)
                    Kirigami.Heading {
                        text: {
                            if (wrapper.timeFormat === 24) {
                                return model.hours;
                            } else {
                                var hour12 = model.hours % 12;
                                if (hour12 === 0) hour12 = 12;
                                var suffix = (model.hours >= 12) ? "pm" : "am";
                                return hour12 + suffix;
                            }
                        }
                        color: Kirigami.Theme.textColor
                        level: 5
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                    }

                    // Weather icon for the hour
                    Kirigami.Icon {
                        source: model.icon
                        width: Kirigami.Units.iconSizes.medium
                        height: width
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    // Temperature label for the hour
                    Kirigami.Heading {
                        text: " " + model.temp + "°"
                        color: Kirigami.Theme.textColor
                        horizontalAlignment: Text.AlignHCenter
                        width: parent.width
                        level: 5
                    }
                }
            }
        }
    }

    // Bottom half: daily forecast
    Column {
        width: parent.width
        anchors.top: hourlyForecast.bottom
        anchors.topMargin: -9
        spacing: 2

        // Repeat for each daily forecast entry
        Repeater {
            model: forecastFullModel
            delegate: RowLayout {
                width: parent.width

                // Day of the week
                Kirigami.Heading {
                    id: day
                    text: model.date
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.4
                    Layout.leftMargin: 4    // distance from left edge
                    color: Kirigami.Theme.textColor
                    level: 5
                }

                // Weather icon for the day
                Kirigami.Icon {
                    id: logo
                    width: Kirigami.Units.iconSizes.medium
                    height: width
                    source: model.icon
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.rightMargin: 2
                }


                // Temperature display
                Kirigami.Heading {
                    id: forecastText
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.preferredWidth: parent.width * 0.25
                    Layout.rightMargin: parent.width * 0.04
                    color: Kirigami.Theme.textColor
                    level: 5

                    RowLayout {
                        id: tempRow
                        anchors.fill: parent
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 4

                        property int tempWidth: Math.max(maxTempLabel.implicitWidth, minTempLabel.implicitWidth)

                        // Max temperature
                        Kirigami.Heading {
                            id: maxTempLabel
                            text: model.maxTemp + "°"
                            level: 5
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: tempRow.implicitWidth
                            horizontalAlignment: Text.AlignRight
                        }

                        // Temperature Separator "/"
                        Kirigami.Heading {
                            text: "/"
                            level: 5
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        }

                        // Min temperature
                        Kirigami.Heading {
                            id: minTempLabel
                            text: model.minTemp + "°"
                            level: 5
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: tempRow.implicitWidth
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                }
            }
        }
    }
}
