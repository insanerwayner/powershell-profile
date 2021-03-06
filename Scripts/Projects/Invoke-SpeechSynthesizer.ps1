Add-Type -AssemblyName System.speech
$tts = New-Object System.Speech.Synthesis.SpeechSynthesizer

$Phrase = @'
<?xml version="1.0" encoding="ISO-8859-1"?>
<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">
<s>

  <voice gender="female" age="24">
    <prosody pitch="-400Hz" rate="1" volume="70"> Oh my </prosody> 
    <break time="50ms"/> 
During the 2011 Texas legislative session, there were reports of major breaches in electronic data. This further encouraged the legislators to set the legislation into place. For over a year, the state comptroller's office exposed the personal data of 3.5 million Texans leading to identify thefts. Those exposed were members of the Employees’ Retirement System of Texas, The Teachers Retirement System of Texas and the Texas Workforce Commission (Buchele, 2011).

  </voice>

  <voice gender="male" age="54">
    <prosody pitch="900Hz" rate="1" volume="100"> You betcha sister! </prosody> 
  </voice>

</s>
</speak>
'@
$tts.SpeakSsml($Phrase)

