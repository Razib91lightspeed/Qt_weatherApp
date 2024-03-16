// Copyright (C) 2021 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

import QtQuick 6.5
import QtQuick.Controls
import Exercise1

ApplicationWindow {
    visible: true
    width: 400
    height: 600
    title: "Weather App"

    Rectangle {
        id: weatherUiBackground
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "lightblue" }
            GradientStop { position: 0.8; color: "lightgray" }
        }

        Column {
            anchors.centerIn: parent
            spacing: 10

            TextField {
                id: cityInput
                width: parent.width * 0.8
                placeholderText: "Enter city name"
                font.pixelSize: 20
                onAccepted: fetchWeather() // Fetch weather when Enter is pressed
            }

            Text {
                id: locationText
                color: "darkblue"
                font.pixelSize: 30
                text: "City"
            }

            Text {
                id: weatherDescriptionText
                color: "darkblue"
                font.pixelSize: 20
                text: "Weather"
            }

            Text {
                id: temperatureText
                color: "darkblue"
                font.pixelSize: 20
                text: "Temperature"
            }

            Text {
                id: windSpeedText
                color: "darkblue"
                font.pixelSize: 20
                text: "Wind Speed"
            }

            Image {
                id: weatherIcon
                width: 100
                height: 100
                fillMode: Image.PreserveAspectFit
            }

            Button {
                text: "Update Weather"
                onClicked: fetchWeather() // Fetch weather when button is clicked
                anchors.horizontalCenter: parent.horizontalCenter
                width: 150
                height: 40
            }
        }
    }

    function fetchWeather() {
        var http = new XMLHttpRequest();
        var cityName = cityInput.text.trim(); // Trim whitespace from input
        if (!cityName) {
            locationText.text = "Please enter a city name";
            return;
        }
        var url = "https://api.openweathermap.org/data/2.5/weather?q=" + encodeURIComponent(cityName) + "&units=metric&appid=6c433438776b5be4ac86001dc88de74d"; // Replace YOUR_API_KEY with your OpenWeatherMap API key
        http.onreadystatechange = function () {
            if (http.readyState === XMLHttpRequest.DONE) {
                if (http.status === 200) {
                    processJson(http.responseText);
                } else {
                    locationText.text = "Error fetching data";
                }
            }
        };
        http.open("GET", url);
        http.send();
        locationText.text = "Fetching...";
    }

    function processJson(response) {
        var weatherJsonObject = JSON.parse(response);
        try {
            locationText.text = weatherJsonObject.name;
            weatherDescriptionText.text = weatherJsonObject.weather[0].main;
                       // Round temperature to nearest integer
            var temperature = Math.round(weatherJsonObject.main.temp);
            temperatureText.text = temperature + " °C";

            // Round wind speed to nearest integer
            var windSpeed = Math.round(weatherJsonObject.wind.speed);
            windSpeedText.text = "Wind: " + windSpeed + " m/s";
            weatherIcon.source = "http://openweathermap.org/img/wn/" + weatherJsonObject.weather[0].icon + ".png";

            // Adjust the background gradient based on the main weather condition
            switch (weatherJsonObject.weather[0].main) {
                case "Clear":
                    weatherUiBackground.gradient.stops = [{position: 0, color: 'skyblue'}, {position: 1, color: 'white'}];
                    break;
                case "Clouds":
                    weatherUiBackground.gradient.stops = [{position: 0, color: 'gray'}, {position: 1, color: 'lightgray'}];
                    break;
                case "Rain":
                case "Drizzle":
                case "Thunderstorm":
                    weatherUiBackground.gradient.stops = [{position: 0, color: 'darkgray'}, {position: 1, color: 'gray'}];
                    break;
                case "Snow":
                    weatherUiBackground.gradient.stops = [{position: 0, color: 'white'}, {position: 1, color: 'lightblue'}];
                    break;
                default:
                    weatherUiBackground.gradient.stops = [{position: 0, color: 'lightblue'}, {position: 1, color: 'lightgray'}];
                    break;
            }
        } catch (error) {
            console.log("Error parsing JSON: " + error);
            locationText.text = "Error parsing data";
        }
    }
}




