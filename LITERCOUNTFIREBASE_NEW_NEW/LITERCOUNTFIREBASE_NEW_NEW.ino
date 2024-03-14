#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Galaxy M2101B9"
#define WIFI_PASSWORD "gjca0597"

// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino

/* 2. Define the API Key */
#define API_KEY "AIzaSyCa4umza8Fj6xKAQniPbdmsy0FFtCG9w20"

/* 3. Define the RTDB URL */
#define DATABASE_URL "https://projectfinalyear-60646-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "sidharthan.24ec@licet.ac.in"
#define USER_PASSWORD "Sidharthan@2003"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

unsigned long count = 0;

int literCount1 = 0; // Liter count for water flow meter 1
int literCount2 = 0; // Liter count for water flow meter 2
int literCount3 = 0; // Liter count for water flow meter 3

int resetLimit = 50;
const int buttonPin1 = 15; // Pin for button 1
const int buttonPin2 = 18; // Pin for button 2
const int buttonPin3 = 19; // Pin for button 3

int buttonState1 = 0; // State of button 1
int buttonState2 = 0; // State of button 2
int buttonState3 = 0; // State of button 3

int previousState1 = 0; // Previous state of button 1
int previousState2 = 0; // Previous state of button 2
int previousState3 = 0; // Previous state of button 3

void setup()
{

  Serial.begin(9600);

  pinMode(buttonPin1, INPUT);
  pinMode(buttonPin2, INPUT);
  pinMode(buttonPin3, INPUT);

  literCount1 = 0;
  literCount2 = 0;
  literCount3 = 0;

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Comment or pass false value when WiFi reconnection will control by your code or third party library e.g. WiFiManager
  Firebase.reconnectNetwork(true);
  fbdo.setBSSLBufferSize(4096 /* Rx buffer size in bytes from 512 - 16384 */, 1024 /* Tx buffer size in bytes from 512 - 16384 */);

  Firebase.begin(&config, &auth);

  Firebase.setDoubleDigits(5);
}


void loop()
{

  // Firebase.ready() should be called repeatedly to handle authentication tasks.
  buttonState1 = digitalRead(buttonPin1);
  buttonState2 = digitalRead(buttonPin2);
  buttonState3 = digitalRead(buttonPin3);

  if (buttonState1 != previousState1) {
    literCount1++;
  }
  if (buttonState2 != previousState2) {
    literCount2++;
  }
  if (buttonState3 != previousState3) {
    literCount3++;
  }

  // Update previous states for next iteration
  previousState1 = buttonState1;
  previousState2 = buttonState2;
  previousState3 = buttonState3;
  Serial.print("Total Liters Meter 1: ");
  Serial.println(literCount1);
  Serial.print("Total Liters Meter 2: ");
  Serial.println(literCount2);
  Serial.print("Total Liters Meter 3: ");
  Serial.println(literCount3);

  // Update Firebase data for each water flow meter
  Firebase.setFloat(fbdo,F("/Sensors/House 1/Total Liters/"), literCount1);
  Firebase.setFloat(fbdo,F("/Sensors/House 2/Total Liters/"), literCount2);
  Firebase.setFloat(fbdo,F("/Sensors/House 3/Total Liters/"), literCount3);

  // Reset count if limit is reached for each water flow meter
  if (literCount1 >= resetLimit || literCount2 >= resetLimit || literCount3 >= resetLimit) {
    Serial.println("Reset the count? Press 'R' to reset or any other key to continue.");
    while (!Serial.available()) {
    }
    char userInput = Serial.read();
    if (userInput == 'R' || userInput == 'r') {
      literCount1 = 0;
      literCount2 = 0;
      literCount3 = 0;
      Serial.println("Counts reset!");

      // Update reset counts in Firebase
      Firebase.setFloat(fbdo,F("/Sensors/House 1/Total Liters/"), literCount1);
      Firebase.setFloat(fbdo,F("/Sensors/House 2/Total Liters/"), literCount2);
      Firebase.setFloat(fbdo,F("/Sensors/House 3/Total Liters/"), literCount3);
    }
  }


}