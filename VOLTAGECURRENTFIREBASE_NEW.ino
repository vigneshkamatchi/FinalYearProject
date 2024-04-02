#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "Rax Tech"
#define WIFI_PASSWORD "rax@12356"

// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino

/* 2. Define the API Key */
#define API_KEY "AIzaSyCa4umza8Fj6xKAQniPbdmsy0FFtCG9w20"

/* 3. Define the RTDB URL */
#define DATABASE_URL "https://projectfinalyear-60646-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "udaykiran.24ec@licet.ac.in"
#define USER_PASSWORD "Uday@1903"

// Define Firebase Data object
FirebaseData fbdo;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

unsigned long count = 0;

void setup()
{

  Serial.begin(9600);

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
  int adc1 = analogRead(15);
  float voltage1 = adc1*5/1023.0;
  float current1 = (voltage1-2.5)/0.185;
  if (current1<0)
  {
    current1=0;
  }
  Serial.println("Current1 = ");
  Serial.print(current1);
  Serial.println("Voltage1 = ");
  Serial.print(voltage1);
  Serial.println();
  Firebase.setString(fbdo, F("/Sensors/House 1/Location/"), "House1");
  Firebase.setFloat(fbdo,F("/Sensors/House 1/Current/"), current1);
  Firebase.setFloat(fbdo,F("/Sensors/House 1/Voltage/"), voltage1);
  
  int adc2 = analogRead(25);
  float voltage2 = adc2*5/1023.0;
  float current2 = (voltage2-2.5)/0.185;
  if (current2<0)
  {
    current2=0;
  }
  Serial.println("Current2 = ");
  Serial.print(current2);
  Serial.println("Voltage2 = ");
  Serial.print(voltage2);
  Serial.println();
  Firebase.setString(fbdo, F("/Sensors/House 2/Location/"), "House2");
  Firebase.setFloat(fbdo,F("/Sensors/House 2/Current/"), current2);
  Firebase.setFloat(fbdo,F("/Sensors/House 2/Voltage/"), voltage2);
  

  int adc3 = analogRead(35);
  Serial.println(adc3);
  float voltage3 = adc3*5/4096.0;
  float current3 = (voltage3-2.5)/0.185;
  if (current3<0)
  {
    current3=0;
  }
  Serial.println("Current3 = ");
  Serial.print(current3);
  Serial.println("Voltage3 = ");
  Serial.print(voltage3);
  Serial.println();
  Firebase.setString(fbdo, F("/Sensors/House 3/Location/"), "House3");
  Firebase.setFloat(fbdo,F("/Sensors/House 3/Current/"), current3);
  Firebase.setFloat(fbdo,F("/Sensors/House 3/Voltage/"), voltage3);
}