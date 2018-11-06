from sense_hat import SenseHat

sense = SenseHat()

def get_accelerometer_raw():
    raw = sense.get_accelerometer_raw()
    return [raw["x"], raw["y"], raw["z"]]
