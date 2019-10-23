#!/usr/bin/env python3
from pulsectl import Pulse, PulseLoopStop
import alsaaudio
import select

headphone_name = 'Headphone'
speaker_name = 'Speaker'
headphone_pulse_name = 'analog-output-headphones'

class SwitchState:
    def __init__(self, pulse, card):
        self.pulse = pulse
        self.card = card
        self.last_port = None

    def callback(self, ev):
        raise PulseLoopStop

    def do_switch(self):
        sink = get_sink(self.pulse, self.card)

        if self.last_port and sink.port_active == self.last_port:
            return

        self.last_port = sink.port_active

        if sink.port_active.name == headphone_pulse_name:
            copy_vols(int(self.card.proplist['alsa.card']),
                      headphone_name, speaker_name)


def copy_vols(device, src_name, dest_name, copy_mute=False):
    mixers = alsaaudio.mixers(cardindex=device)

    for mname in (src_name, dest_name):
        if mname not in mixers:
            raise RuntimeError('Missing mixer: %s' % mname)

    src = alsaaudio.Mixer(cardindex=device, control=src_name)
    dest = alsaaudio.Mixer(cardindex=device, control=dest_name)

    src_vols = src.getvolume()
    dest_vols = dest.getvolume()

    if len(src_vols) != len(dest_vols):
        raise RuntimeError('Number of channels in each mixer is different!')

    for c, v in enumerate(src_vols):
        dest.setvolume(v, c)

    if copy_mute:
        dest.setmute(src.getmute())

def get_sink(pulse, card):
    sinks = [s for s in pulse.sink_list() if s.card == card.index]

    if len(sinks) != 1:
        raise RuntimeError("Didn't find exactly one matching sink!")

    return sinks[0]

with Pulse('switch-listener') as pulse:
    cards = pulse.card_list()
    card = None
    for card in cards:
        if any(p.name == headphone_pulse_name for p in card.port_list):
            break

    if not card:
        raise RuntimeError('No matching card found')

    state = SwitchState(pulse, card)
    pulse.event_callback_set(state.callback)
    pulse.event_mask_set('card')

    try:
        while True:
            pulse.event_listen()
            state.do_switch()

    except KeyboardInterrupt:
        pass
