# miditools

This repo contains several small tools to work with MIDI files.
The scripts are located in `./src` and do

- MusicXML to MIDI conversion via MuseScore
- Pitch spelling inference via Melisma

## MusicXML to MIDI conversion

For this to work MuseScore (2 or 3) has to be installed. See also: https://musescore.org/en/handbook/3/command-line-options

Convert a folder (with subdirectories) of MusicXML files to MIDI:

```batch
cd src
./xml2midi.sh <input dir> <output dir>
```

`<output dir>` will preserve the input directory structure.

## Pitch spelling

This repo contains the code and instructions to use Temperley's pitch spelling algorithmus to infer the spelling for notes in MIDI files.

Link to original software Melisma: <http://www.link.cs.cmu.edu/music-analysis/>

### Procedure

The library uses `mftext` to transform MIDI files into a note list representation, passes it to Temperley's `meter` function to infer a metrical grid which is used for the spelling algorithm. It is subsequently passed to the `harmony` module that infers the spelled pitches among other things.

### Installation

To install `mftext` which converts MIDI files into note lists:

```bash
cd src/melisma2003/mftext
make
```

To install Temperley's meter inference tool:

```bash
cd src/melisma2003/meter
make
```

To install the harmony tool that (among other things) infers the pitch spelling from a note list with MIDI numbers:

```bash
cd src/melisma2003/harmony
make
```

To make the pitch speller executable, run

```bash
cd src
chmod +x midi2tpclist.sh
```

### Infer pitch spelling

To execute `midi2tpclist` run 

```bash
cd src
./midi2tpclist <input directory> <output directory>
```

If `<output directory>` does not exist, it gets created. Each MIDI file in `<input directory>` is converted to a CSV file with the (not named) columns:

- `type` containing only the entry `TPCNote`
- `onset` in MIDI ticks (I think)
- `offset`
- `MIDI` containing the MIDI pitch number
- `tpc` which contains the inferred tonal pitch class as an integer on the line of fifths. For unknown reasons, Temperley centers the line at $B\flat=0$. The output representation shifts it so that $C=0$. A dictionary is provided that maps the TPC numbers to spelled pitch strings via `divmod`. 
