int echoPin = 4;
int trigPin = 5;

void setup()
{
   Serial.begin(9600);
   pinMode(echoPin, INPUT);
   pinMode(trigPin, OUTPUT);
   pinMode(10, OUTPUT);
   pinMode(11, OUTPUT);
}

void loop()
{
  float distanceCentimeters;
  int pulseLenMicroseconds;

  digitalWrite(trigPin, LOW);
  delayMicroseconds(20);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(100);
  digitalWrite(trigPin, LOW);


  pulseLenMicroseconds = pulseIn(echoPin, HIGH);
  distanceCentimeters = pulseLenMicroseconds / 29.387 / 2;

  if(distanceCentimeters >= 0 && distanceCentimeters < 50 )
  {
     digitalWrite(10, HIGH);
     digitalWrite(11,HIGH);
  }
  else if(distanceCentimeters > 50 && distanceCentimeters < 150)
  {
    digitalWrite(10, LOW);
    digitalWrite(11, HIGH);
  }
  else
  {
    digitalWrite(10, LOW);
    digitalWrite(11, LOW);
  }
  
  Serial.println(distanceCentimeters);

  delay(100);
}

