import numpy as np
import mido, re
from scipy.stats import entropy

def tpc_lof_name(lof_number):
    """returns (a // 7, a % 7)"""
    a, b = divmod(lof_number + 1, 7)
    
    d = {
        0: 'F',
        1 : 'C',
        2 : 'G', 
        3 : 'D', 
        4 : 'A',
        5 : 'E',
        6 : 'B'
    }
    
    if a == 0:
        acc = ''
    elif a > 0:
        acc = '#'*abs(a)
    elif a < 0:
        acc = 'b'*abs(a)
    
    return d[b]+acc

def tpc_counts(df):
    df = df.copy()
    # Temperley's encoding has C=2 (http://www.link.cs.cmu.edu/music-analysis/harmony.html). Shift so that C=0
    df['TPC'] -= 2
    
    df['tpc_name'] = df['TPC'].map(tpc_lof_name) # add spelled note names
    df['pc'] = df['TPC'] * 7 % 12
    
    tpc_counts = df.tpc_name.value_counts().reindex([tpc_lof_name(i).replace('##', 'x') for i in range(-15,20)]).fillna(0)
    
    return tpc_counts

def midi_on_off(file):
    """Replaces MIDI note_on events with velocity 0 with MIDI note_off events"""
    
    try:
        midi = mido.MidiFile(file)

        a = re.compile(r"""note_on(?P<type>\s)
                           channel=(?P<channelno>\d\s)
                           note=(?P<noteno>\d+\s)
                           velocity=(?P<velocity>\d+\s)
                           time=(?P<time>\d+)""", re.X)

        for track in midi.tracks:
            for i, msg in enumerate(track):
                if not msg.is_meta:
                    if re.match(a, str(msg)):
                        if msg.velocity==0:
                            offmsg = mido.Message('note_off')
                            offmsg.channel = msg.channel
                            offmsg.note = msg.note
                            offmsg.velocity = msg.velocity
                            offmsg.time = msg.time

                            track[i] = offmsg

        midi.save(file)
    except Exception as e:
        print(e, file)
    
def jsd(p, q):
    """return Jenson-Shannon divergence"""
    p = np.asarray(p, dtype=float)
    q = np.asarray(q, dtype=float)
    # normalize
    p /= p.sum()
    q /= q.sum()
    m = (p + q) / 2
    return (entropy(p, m, base=2) + entropy(q, m, base=2)) / 2