void setup()
{
int totalFramesRead = 0;
File fileIn = new File(somePathName);
// somePathName is a pre-existing string whose value was
// based on a user selection.
try {
  AudioInputStream audioInputStream = 
    AudioSystem.getAudioInputStream(fileIn);
  int bytesPerFrame = 
    audioInputStream.getFormat().getFrameSize();
    if (bytesPerFrame == AudioSystem.NOT_SPECIFIED) {
    // some audio formats may have unspecified frame size
    // in that case we may read any amount of bytes
    bytesPerFrame = 1;
  } 
  // Set an arbitrary buffer size of 1024 frames.
  int numBytes = 1024 * bytesPerFrame; 
  byte[] audioBytes = new byte[numBytes];
  try {
    int numBytesRead = 0;
    int numFramesRead = 0;
    // Try to read numBytes bytes from the file.
    while ((numBytesRead = 
      audioInputStream.read(audioBytes)) != -1) {
      // Calculate the number of frames actually read.
      numFramesRead = numBytesRead / bytesPerFrame;
      totalFramesRead += numFramesRead;
      // Here, do something useful with the audio data that's 
      // now in the audioBytes array...
    }
  } catch (Exception ex) { 
    // Handle the error...
  }
} catch (Exception e) {
  // Handle the error...
}

}
