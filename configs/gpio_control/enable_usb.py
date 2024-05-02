import RPi.GPIO as GPIO
import time

PIN_USB = 37
PIN_INDICADOR = 35

GPIO.setmode(GPIO.BOARD)
GPIO.setup(PIN_USB, GPIO.OUT)

try:
    print("Enciendiendo USB")
    GPIO.output(PIN_USB, True)
except KeyboardInterrupt:
    print("Keyboard Interrupt")
except:
    print("some error")