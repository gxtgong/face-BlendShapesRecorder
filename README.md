# face-BlendShapesRecorder
A simple iOS app that records the BlendShapes feature with timestamps provided by ARKit.

## Getting Started
Download the entire folder and open it in Xcode. Connect an iPhone X or above to your computer. Build the app on the device.

## Recording
Press "Record" to start recording. Press "Stop" to stop recording.

## Results
The output files could be retrieved through "File Sharing" in iTunes. Folders are named by the time the recordings start in the format MMdd_HHmmss.
Each of the folders contain a json file. The keys are the timestamps in format HHmmssSSSS. The values are dictionaries of BlendShapes.

## Built With
- Swift - The language used
- ARKit - AR framework provided by Apple

## Author
Xinting Gong
