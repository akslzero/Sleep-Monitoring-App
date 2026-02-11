# [sleep_monitor_app]

Aplikasi untuk memonitor kualitas lingkungan tidur secara real-time menggunakan perangkat IoT.



## Fitur

- Monitoring sensor secara real-time  
- Dashboard interaktif dengan grafik/status device  
- Notifikasi otomatis untuk perubahan kondisi

---

## Sensor yang Digunakan

- Modul utama ESP32 Devkit v1
- Sensor 1: Sensor Suhu dan Kelembapan DHT22 (AM2302)  
- Sensor 2: Light Sensor LDR  
- Sensor 3: Sound Sensor KY-037  


---

## Instalasi Project Aplikasi

Buka terminal/shell, lalu ikuti langkah berikut:

### 1. Clone repository
```bash
git clone https://github.com/akslzero/Sleep-Monitoring-App
```

### 2. Masuk ke folder project
```bash
cd nama-repo
```

### 3. Install dependencies Flutter
```bash
flutter pub get
```
### 4. Jalankan aplikasi (emulator atau device Android tersambung)
```bash
flutter run
```

### 5. (Opsional) Build APK release
```bash
flutter build apk
```

---

## Instalasi untuk ESP32 & Sketch

1. Buat project realtime database pada Google Firebase, copy link url projectnya lalu paste ke sketch esp32
2. Set SSID Wifi dan Password
3. Build dan Upload sketch.ino arduino IDE ke ESP32, pastikan pin sesuai pada sketch
