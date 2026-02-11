#include <WiFi.h>
#include <HTTPClient.h>
#include "DHT.h"
#include <time.h>

// ===== FIREBASE =====
String firebaseURL =
"link project database firebase";


// ===== PIN =====
#define DHTPIN    5
#define DHTTYPE   DHT22
#define LDR_PIN   32
#define SOUND_PIN 33

DHT dht(DHTPIN, DHTTYPE);

// ===== TIMER =====
unsigned long lastMillis = 0;
const long interval = 2000;

// ===== NTP TIME =====
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 7 * 3600; // WIB
const int   daylightOffset_sec = 0;

// ===== WIFI DEFAULT =====
const char* WIFI_SSID = "wifi";
const char* WIFI_PASS = "wifi";

// ===== CONNECT WIFI =====
void connectWiFi() {
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print("Coba konek WiFi: ");
    Serial.println(WIFI_SSID);
    WiFi.begin(WIFI_SSID, WIFI_PASS);
    int timeout = 0;
    while (WiFi.status() != WL_CONNECTED && timeout < 20) {
      delay(500);
      Serial.print(".");
      timeout++;
    }
    if (WiFi.status() == WL_CONNECTED) {
      Serial.println("\nWiFi CONNECTED!");
      Serial.print("IP: ");
      Serial.println(WiFi.localIP());
      break;
    }
    Serial.println("\nGagal konek WiFi, coba lagi...");
    WiFi.disconnect(true);
    delay(1000);
  }
}

// ===== HITUNG KUALITAS TIDUR =====
void calculateSleepScore(float temp, float hum, int lightScore, int sound, int &score, String &quality) {
  int sTemp, sSound;

  // Suhu
  if (temp >= 23 && temp <= 28) sTemp = 25;            
  else if ((temp >= 21 && temp < 23) || (temp > 28 && temp <= 30)) sTemp = 15; 
  else sTemp = 5;                                       

  // Suara
  if (sound < 100) sSound = 25;         
  else if (sound <= 150) sSound = 15;   
  else sSound = 5;                      

  // Total score
  score = sTemp + lightScore + sSound;

  // Kualitas tidur
  if (score >= 65) quality = "Nyaman";
  else if (score >= 50) quality = "Cukup";
  else quality = "Kurang";

  Serial.print("Suhu Score : "); Serial.println(sTemp);
  Serial.print("Suara Score : "); Serial.println(sSound);
}

// ===== SEND FIREBASE =====
void sendToFirebase(float t, float h, int ldr, int sound, int score, String quality, String timestamp) {
  if (WiFi.status() != WL_CONNECTED) connectWiFi();
  HTTPClient http;
  String json = "{";
  json += "\"timestamp\":\"" + timestamp + "\",";
  json += "\"temperature\":" + String(t, 1) + ",";
  json += "\"humidity\":" + String(h, 1) + ",";
  json += "\"light\":" + String(ldr) + ",";
  json += "\"sound\":" + String(sound) + ",";
  json += "\"score\":" + String(score) + ",";
  json += "\"quality\":\"" + quality + "\"";
  json += "}";
  http.begin(firebaseURL);
  http.addHeader("Content-Type", "application/json");
  int code = http.POST(json);
  Serial.print("Firebase response: ");
  Serial.println(code);
  http.end();
}

// ===== SETUP =====
void setup() {
  Serial.begin(115200);
  dht.begin();
  pinMode(LDR_PIN, INPUT);
  pinMode(SOUND_PIN, INPUT);
  connectWiFi();
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  Serial.println("Sync waktu...");
}

// ===== LOOP =====
void loop() {
  if (millis() - lastMillis >= interval) {
    lastMillis = millis();

    float hum = dht.readHumidity();
    float temp = dht.readTemperature();
    int ldrVal = analogRead(LDR_PIN);
    int soundVal = analogRead(SOUND_PIN);

    if (isnan(temp) || isnan(hum)) {
      Serial.println("Gagal baca DHT22");
      return;
    }

    // Waktu
    struct tm timeinfo;
    while (!getLocalTime(&timeinfo)) {
      Serial.print(".");
      delay(500);
    }
    char timeString[25];
    strftime(timeString, sizeof(timeString), "%Y-%m-%d %H:%M:%S", &timeinfo);

    // Display LDR (terang = besar)
    int displayLight = 4095 - ldrVal;

    // Hitung skor cahaya (logika benar: terang → skor rendah)
    int lightScore;
    if (displayLight >= 3000 && displayLight <= 5000 ) lightScore = 5;       // terang → kurang nyaman
    else if (displayLight <= 3000 && displayLight >= 1000) lightScore = 15; // agak terang → cukup
    else lightScore = 25;                      // gelap → nyaman

    Serial.print("Light Score : "); Serial.println(lightScore);
    Serial.print("Nilai Light : "); Serial.println(ldrVal);
    

    // Hitung total score
    int score;
    String quality;
    calculateSleepScore(temp, hum, lightScore, soundVal, score, quality);

    // SERIAL MONITOR
    Serial.println("--------------------");
    Serial.print("Waktu    : "); Serial.println(timeString);
    Serial.print("Suhu     : "); Serial.println(temp);
    Serial.print("Humidity : "); Serial.println(hum);
    Serial.print("Cahaya   : "); Serial.println(displayLight);
    Serial.print("Suara    : "); Serial.println(soundVal);
    Serial.print("Score    : "); Serial.println(score);
    Serial.print("Kualitas : "); Serial.println(quality);

    // FIREBASE
    sendToFirebase(temp, hum, displayLight, soundVal, score, quality, String(timeString));
  }
}
