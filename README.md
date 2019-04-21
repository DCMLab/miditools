# pitchspelling

This repo contains the code and instructions to use Temperley's pitch spelling algorithmus for MIDI files.

Link: <http://www.link.cs.cmu.edu/music-analysis/>

The library uses `mftext` to transform MIDI files into a note list representation, passes it to Temperley's `meter` function to infer a metrical grid which is used for the spelling algorithm. It is subsequently passed to the `harmony` module that infers the spelled pitches among other things. The resulting data is saved as a CSV file containing four columns that specify the type (`TPCNote`), `onset` and `offset` (**which unit**), the MIDI pitch number, and the inferred TPC number that is given as a position on the line of fifths. For unknown reasons, Temperley centers the line at $B\flat=0$. The output representation shifts it so that $C=0$. A dictionary is provided that maps the TPC numbers to spelled pitch strings via `divmod`. 

