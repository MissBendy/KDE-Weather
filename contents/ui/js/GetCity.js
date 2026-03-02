// Retrieves the name of a city (or region fallback) using latitude and longitude coordinates
function getNameCity(latitude, longitud, language, callback) {
    // Construct the reverse geocoding URL from OpenStreetMap's Nominatim API
    // "accept-language" defines the response language for location names
    let url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitud}&accept-language=${language}`;
    // console.log("Location API URL: ", url);

    // Create a new asynchronous HTTP request
    let req = new XMLHttpRequest();
    req.open("GET", url, true); // true = asynchronous request

    // Identify the application (required by Nominatim usage policy)
    req.setRequestHeader("User-Agent", "PlasmoidTest/1.0 (your@email.com)");
    req.setRequestHeader("Accept", "application/json");

    // Optional timeout for safety
    req.timeout = 10000;

    // Handle state changes for the request
    req.onreadystatechange = function () {
        // Proceed only when request is complete
        if (req.readyState === 4) {
            // 200 = success
            if (req.status === 200) {
                try {
                    // Parse the response JSON
                    let data = JSON.parse(req.responseText);

                    // Safely access address object
                    let address = data.address || {};

                    // Extract location components
                    let city = address.city
                        || address.town
                        || address.village
                        || address.hamlet;

                    let county = address.county;
                    let state = address.state;

                    // Choose the most specific available name:
                    // city → state → county (fallback chain)
                    let full = city ? city : state ? state : county;

                    // Log and return the result via callback
                    console.log("Location:", full);
                    callback(full || "Unknown");

                } catch (e) {
                    // Handle any JSON parsing errors
                    console.error("Error parsing the response JSON: ", e);
                    console.error("Response:", req.responseText);
                }
            } else {
                // Handle non-200 HTTP responses
                console.error("city failed");
                console.error("HTTP Status:", req.status);
                console.error("Response:", req.responseText);
            }
        }
    };

    // Triggered if the network request itself fails
    req.onerror = function () {
        console.error("The request failed");
    };

    // Triggered if the request exceeds the timeout period
    req.ontimeout = function () {
        console.error("The request exceeded the waiting time");
    };

    // Send the HTTP request
    req.send();
}
