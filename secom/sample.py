from sense_hat import SenseHat

sense = SenseHat()

def get_accelerometer_raw():
    raw = sense.get_accelerometer_raw()
    return [raw["x"], raw["y"], raw["z"]]

def wait_for_event():
    event = sense.wait_for_event()
    return [event.action, event.direction]

def get_events():
    events = sense.get_events()
    return map(lambda event:[event.action, event.direction], events)
