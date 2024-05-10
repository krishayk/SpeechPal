#include <SD.h>
#include <SPI.h>
#include <Audio.h>
#include <Wire.h>
#include <SerialFlash.h>

const int chipSelect = 10; // Set the chip select pin for SD card
const int buttonPin = 2;   // Set the button pin for start/stop recording

bool isRecording = false;

void setup() {
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
  if (!SD.begin(chipSelect)) {
    Serial.println("SD card initialization failed.");
    return;
  }
  Serial.println("SD card initialized.");
}

void loop() {
  int buttonState = digitalRead(buttonPin);
  if (buttonState == HIGH) {
    if (!isRecording) {
      startRecording();
    } else {
      stopRecording();
    }
    delay(1000); // Debounce delay
  }
}

void startRecording() {
  isRecording = true;
  Serial.println("Recording started.");
  // Implement code to start recording audio
}

void stopRecording() {
  isRecording = false;
  Serial.println("Recording stopped.");
  // Implement code to stop recording audio
}
