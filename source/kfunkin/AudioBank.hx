package kfunkin;

import kawaii.Application;
import kawaii.resources.ResourceAudio;

/**
 * Represents a collection of audio files that can be played by the game.
 */
class AudioBank {

    public var _audioBank: Map<AudioBankType, ResourceAudio> = [];
    public var _app: Application;

    /**
     * Creates a new AudioBank.
     */
    public function new(app) {
        _app = app;
    }

    /**
     * Adds an audio file to the bank.
     * @param name The name of the audio file.
     * @param path The path to the audio file.
     */
    public function addAudio(name: AudioBankType, path: String): Void {
        _audioBank[name] = ResourceAudio.fromFile(path);
    }

    /**
     * Plays an audio file.
     * @param name The name of the audio file.
     */
    public function playAudio(name: AudioBankType): Void {
        _app.audio.play(_audioBank[name]);
    }

    /**
     * Play all audio files.
    */
    public function playAllAudio(): Void {
        for (audio in _audioBank.keys()) playAudio(audio);
    }

    /**
     * Disposes of the audio bank.
     */
    public function dispose(): Void {
        for (audio in _audioBank.keys()) _audioBank[audio].dispose();
    }

    /**
     * Get audio
     * @param name The name of the audio file.
     */
    public function getAudio(name: AudioBankType): ResourceAudio {
        return _audioBank[name];
    }

}