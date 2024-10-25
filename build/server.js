import express from 'express';
import JGen from './index.js';
import path from 'path';
import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import fs from 'fs';
const __filename = fileURLToPath(import.meta.url); // get the resolved path to the file
const __dirname = path.dirname(__filename);
const app = express();
class Car {
    make;
    model;
    detail;
    image;
    constructor(make, model, detail, image) {
        this.make = make;
        this.model = model;
        this.detail = detail;
        this.image = image;
    }
}
const cars = [
    new Car("Mercedes", "CLA", "This is a great car", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVHqwbrOEbcYsaeZbWHLUXa7Ye55W_CALv4w&s"),
    new Car("BMW", "2", "This is also a great car", "https://www.bmw.nl/content/dam/bmw/common/all-models/m-series/m235i/2019/navigation/BMW-2-Series-gran-coupe_ModelCard.png"),
    new Car("Audi", "Quattro", "This is not a great car", "https://uploads.audi-mediacenter.com/system/production/media/13182/images/9070439c87474570d36def53ac8e39936da1d928/PQ100050_web_2880.jpg?1698189734"),
    new Car("Jeep", "Whatever", "This is an even greater car", "https://www.jeep.co.uk/content/dam/jeep/crossmarket/wrangler-full-model-mca-2024/02-trim-selector/sahara/figurines/sahara-black-565x330.png"),
    new Car("Range Rover", "Dont know", "This is a great 4 by 4", "https://jlr.scene7.com/is/image/jlr/L460_22MY_SV_002_GLHD_DX_2560x1440"),
];
app.use(express.json());
app.get("/server.html", (req, res) => {
    res.end(readFileSync(__dirname + "/server.html"));
});
app.use("/react", express.static(__dirname + "/react"));
app.use("/flutter", express.static(__dirname + "/flutter/build/web"));
app.use("/", express.static(__dirname + "/flutter/build/web"));
app.post('/app', async (req, res) => {
    await new JGen()._start("run", req.body, true);
    return res.redirect(`/${req.body.app.target}/index.html`);
});
app.get('/cars', (req, res) => {
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("content-type", "application/json");
    res.end(JSON.stringify(cars));
});
class RainStatistic {
    day;
    rainfall;
    constructor(day, rainfall) {
        this.day = day;
        this.rainfall = rainfall;
    }
}
const rainNorthHolland = [
    new RainStatistic(new Date("2024-01-01"), 5),
    new RainStatistic(new Date("2024-01-02"), 7),
    new RainStatistic(new Date("2024-01-03"), 0.5),
    new RainStatistic(new Date("2024-01-04"), 2),
    new RainStatistic(new Date("2024-01-05"), 0.9),
];
const rainSouthHolland = [
    new RainStatistic(new Date("2024-01-01"), 4.5),
    new RainStatistic(new Date("2024-01-02"), 6.5),
    new RainStatistic(new Date("2024-01-03"), 0.3),
    new RainStatistic(new Date("2024-01-04"), 1.9),
    new RainStatistic(new Date("2024-01-05"), 0.8),
];
const rainZeeland = [
    new RainStatistic(new Date("2024-01-01"), 4),
    new RainStatistic(new Date("2024-01-02"), 6),
    new RainStatistic(new Date("2024-01-03"), 0.2),
    new RainStatistic(new Date("2024-01-04"), 1.8),
    new RainStatistic(new Date("2024-01-05"), 0.7),
];
const rainUtrecht = [
    new RainStatistic(new Date("2024-01-01"), 5.1),
    new RainStatistic(new Date("2024-01-02"), 6.7),
    new RainStatistic(new Date("2024-01-03"), 0.4),
    new RainStatistic(new Date("2024-01-04"), 2.1),
    new RainStatistic(new Date("2024-01-05"), 1),
];
const rainGelderland = [
    new RainStatistic(new Date("2024-01-01"), 4.8),
    new RainStatistic(new Date("2024-01-02"), 6.2),
    new RainStatistic(new Date("2024-01-03"), 0.6),
    new RainStatistic(new Date("2024-01-04"), 1.7),
    new RainStatistic(new Date("2024-01-05"), 0.9),
];
const rainOverijssel = [
    new RainStatistic(new Date("2024-01-01"), 4.9),
    new RainStatistic(new Date("2024-01-02"), 6.3),
    new RainStatistic(new Date("2024-01-03"), 0.5),
    new RainStatistic(new Date("2024-01-04"), 1.6),
    new RainStatistic(new Date("2024-01-05"), 0.8),
];
const rainDrenthe = [
    new RainStatistic(new Date("2024-01-01"), 5.2),
    new RainStatistic(new Date("2024-01-02"), 7.1),
    new RainStatistic(new Date("2024-01-03"), 0.4),
    new RainStatistic(new Date("2024-01-04"), 2),
    new RainStatistic(new Date("2024-01-05"), 1.1),
];
const rainFriesland = [
    new RainStatistic(new Date("2024-01-01"), 5.5),
    new RainStatistic(new Date("2024-01-02"), 7.4),
    new RainStatistic(new Date("2024-01-03"), 0.3),
    new RainStatistic(new Date("2024-01-04"), 2.3),
    new RainStatistic(new Date("2024-01-05"), 1.2),
];
const rainGroningen = [
    new RainStatistic(new Date("2024-01-01"), 4.7),
    new RainStatistic(new Date("2024-01-02"), 6.8),
    new RainStatistic(new Date("2024-01-03"), 0.2),
    new RainStatistic(new Date("2024-01-04"), 1.5),
    new RainStatistic(new Date("2024-01-05"), 0.6),
];
const rainNorthBrabant = [
    new RainStatistic(new Date("2024-01-01"), 4.3),
    new RainStatistic(new Date("2024-01-02"), 6.1),
    new RainStatistic(new Date("2024-01-03"), 0.7),
    new RainStatistic(new Date("2024-01-04"), 1.4),
    new RainStatistic(new Date("2024-01-05"), 0.5),
];
const rainLimburg = [
    new RainStatistic(new Date("2024-01-01"), 5.3),
    new RainStatistic(new Date("2024-01-02"), 7.2),
    new RainStatistic(new Date("2024-01-03"), 0.6),
    new RainStatistic(new Date("2024-01-04"), 2.2),
    new RainStatistic(new Date("2024-01-05"), 1.3),
];
const rainFlevoland = [
    new RainStatistic(new Date("2024-01-01"), 4.6),
    new RainStatistic(new Date("2024-01-02"), 6.4),
    new RainStatistic(new Date("2024-01-03"), 0.4),
    new RainStatistic(new Date("2024-01-04"), 1.9),
    new RainStatistic(new Date("2024-01-05"), 0.7),
];
app.get('/rain', (req, res) => {
    console.log('Request for rain data');
    // const province = req.query.province;
    const province = typeof req.query.province === 'string' ? req.query.province : undefined;
    if (!province) {
        console.log('Province is undefined or not a string.');
        res.status(400).send('Invalid province');
        return;
    }
    const rainDataMap = {
        'Noord-Holland': rainNorthHolland,
        'Zuid-Holland': rainSouthHolland,
        'Zeeland': rainZeeland,
        'Utrecht': rainUtrecht,
        'Gelderland': rainGelderland,
        'Overijssel': rainOverijssel,
        'Drenthe': rainDrenthe,
        'Friesland (Fryslân)': rainFriesland,
        'Groningen': rainGroningen,
        'Noord-Brabant': rainNorthBrabant,
        'Limburg': rainLimburg,
        'Flevoland': rainFlevoland
    };
    const rainData = rainDataMap[province];
    if (!rainData) {
        console.log('Invalid province');
        console.log(province);
        res.status(400).send('Invalid province');
        return;
    }
    // Step 3: Return the matched rain data in the response
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("content-type", "application/json");
    res.send(JSON.stringify(rainData));
});
app.get('/polygons', (req, res) => {
    console.log('Request for polygons');
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("content-type", "application/json");
    // fs.readFile(path.join(__dirname, 'server_assets/DISTRICTENPolygon_WGS84.geojson'), 'utf8', (err, data) => {
    fs.readFile(path.join(__dirname, 'server_assets/nl_provinces.geojson'), 'utf8', (err, data) => {
        if (err) {
            console.error(err);
            res.status(500).send('Error reading the file');
            return;
        }
        res.send(data);
    });
});
class WeatherData {
    actualRainfallMM;
    predictedRainfallMM;
    date;
    constructor(actualRainfallMM, predictedRainfallMM, date) {
        this.actualRainfallMM = actualRainfallMM;
        this.predictedRainfallMM = predictedRainfallMM;
        this.date = date;
    }
}
class WeatherStation {
    title;
    latitude;
    longitude;
    weatherData;
    constructor(title, latitude, longitude, weatherData) {
        this.title = title;
        this.latitude = latitude;
        this.longitude = longitude;
        this.weatherData = weatherData;
    }
}
// Create a list of weather stations
const weatherStations = [
    new WeatherStation("Station 1", 52.379189, 4.899431, [
        new WeatherData(5, 4, new Date("2024-01-01")),
        new WeatherData(7, 6, new Date("2024-01-02")),
        new WeatherData(0.5, 0.3, new Date("2024-01-03")),
        new WeatherData(2, 1.9, new Date("2024-01-04")),
        new WeatherData(0.9, 0.8, new Date("2024-01-05"))
    ]),
    new WeatherStation("Station 2", 51.9225, 4.47917, [
        new WeatherData(4.5, 4.3, new Date("2024-01-01")),
        new WeatherData(6.5, 6.1, new Date("2024-01-02")),
        new WeatherData(0.3, 0.7, new Date("2024-01-03")),
        new WeatherData(1.9, 1.4, new Date("2024-01-04")),
        new WeatherData(0.8, 0.5, new Date("2024-01-05"))
    ]),
    new WeatherStation("Station 3", 51.2094, 3.2247, [
        new WeatherData(4, 4.6, new Date("2024-01-01")),
        new WeatherData(6, 6.4, new Date("2024-01-02")),
        new WeatherData(0.2, 0.4, new Date("2024-01-03")),
        new WeatherData(1.8, 1.9, new Date("2024-01-04")),
        new WeatherData(0.7, 0.7, new Date("2024-01-05"))
    ]),
    new WeatherStation("Station 4", 51.9225, 5.85833, [
        new WeatherData(5.1, 5.3, new Date("2024-01-01")),
        new WeatherData(6.7, 7.2, new Date("2024-01-02")),
        new WeatherData(0.4, 0.6, new Date("2024-01-03")),
        new WeatherData(2.1, 2.2, new Date("2024-01-04")),
        new WeatherData(1, 1.3, new Date("2024-01-05"))
    ]),
    new WeatherStation("Station 5", 51.2094, 5.08333, [
        new WeatherData(4.8, 4.7, new Date("2024-01-01")),
        new WeatherData(6.2, 6.8, new Date("2024-01-02")),
        new WeatherData(0.6, 0.2, new Date("2024-01-03")),
        new WeatherData(1.7, 1.5, new Date("2024-01-04")),
        new WeatherData(0.9, 0.6, new Date("2024-01-05"))
    ])
];
// Define the new endpoint
app.get('/weather-stations', (req, res) => {
    console.log('Request for weather stations');
    res.setHeader("Access-Control-Allow-Origin", "*");
    res.setHeader("content-type", "application/json");
    res.send(JSON.stringify(weatherStations));
});
app.listen(1337, () => {
    console.log("listening");
});
//# sourceMappingURL=server.js.map