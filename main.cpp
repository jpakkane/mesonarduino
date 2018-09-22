//#include "WProgram.h"
#include "Arduino.h"

void __cxa_pure_virtual() {
	while(1){
		digitalWrite(13, LOW);
		delay(500);
		digitalWrite(13, HIGH);
		delay(2500);
	}
}

int main() {
	uint8_t led_pin = 13;
	init();
  delay(15000);
	Serial.begin(57600);
	pinMode(led_pin, OUTPUT);
	analogReference(DEFAULT);
	while(1){
		// Check MavLink communication
		// Check FrSky S.Port communication
	}
	return 0; //unreachable
}
