package kfunkin;

import kawaii.util.HiResTime;
import kfunkin.modding.ClassRegistry;
import kfunkin.formats.data.ChartNoteBuckets;
import kfunkin.formats.data.ChartEventType;
import kfunkin.formats.data.ChartEvent;
import kfunkin.formats.data.ChartNoteType;
import kfunkin.formats.data.ChartNoteBucket;
import kawaii.Application;

/**
 * This is the class representing a chart, it gets populated with data from derived classes of `BaseFormat`
 */
class Chart {

    private var _app: Application;
    private var audioPaths: Map<AudioBankType, String> = [];
    public var audioBank: AudioBank;

    public var noteBuckets: ChartNoteBuckets;
    public var events: Array<ChartEvent> = [];

    private var _lastRealTime: Float = 0;
    private var _interpolatedTimeStart: Float = HiResTime.now();
    private var _smoothingFactor: Float = 0.1;
    private var _smoothedTime: Float = 0;

    /**
     * Empty constructor for the chart
     */
    public function new() {
        noteBuckets = ClassRegistry.createInstance(ChartNoteBuckets);
        _app = Application.getInstance();
    }

    /**
     * Loads the chart
     */
    public function load(app: Application) {
        // Load the audio / voices
        audioBank = ClassRegistry.createInstance(AudioBank, [ app ]);
        for (path in audioPaths.keys()) audioBank.addAudio(path, audioPaths[path]);
    }

    /**
     * Register audio path
     * @param audioBankType The type of audio bank
     * @param path The path to the audio file
     */
    public function registerAudioPath(audioBankType: AudioBankType, path: String) {
        audioPaths[audioBankType] = path;
    }

    /**
     * Add a note to the chart
     * @param millis The time in milliseconds
     * @param type The type of note to add
     * @param lane The lane to add the note to
     * @param opponent Whether the note is an opponent note
     * @param duration The duration of the note (if applicable)
     */
    public function addNote(millis: Float, type: ChartNoteType, lane: Int, opponent: Bool, duration: Int = 0) {
        var bucket = noteBuckets.getOrCreateBucketByTime(millis);
        bucket.addNote(millis, type, lane, opponent, duration);
    }

    /**
     * Add a single note
     * @param millis The time in milliseconds
     * @param lane The lane to add the note to
     * @param opponent Whether the note is an opponent note
     */
    public function addSingleNote(millis: Float, lane: Int, opponent: Bool) {
        addNote(millis, ChartNoteType.SINGLE, lane, opponent);
    }

    /**
     * Add a sustain (hold) note
     */
    public function addSustainNote(millis: Float, lane: Int, opponent: Bool, duration: Int) {
        addNote(millis, ChartNoteType.SUSTAIN, lane, opponent, duration);
        addNote(millis + duration, ChartNoteType.SUSTAIN_END, lane, opponent);
    }

    /**
     * Add a chart event
     * @param millis The time in milliseconds
     * @param type The type of event
     * @param data The data associated with the event (if applicable)
     */
    public function addEvent(millis: Float, type: ChartEventType, data: Dynamic = null) {
        events.push({ time: millis, type: type, data: data });
    }

    public function getLastEventOfTypeAt(millis: Float, type: ChartEventType): ChartEvent {
        for (i in 0...events.length) {
            var event = events[i];
            if (event.time > millis) return null;
            if (event.type == type) return event;
        }
        return null;
    }
    
    /**
     * Disposes of the chart
     */
    public function dispose() {
        audioBank.dispose();
    }

    /**
     * Get the current (interpolated) audio time.
     */
    public function getAudioTime(): Float {
        var audio = audioBank.getAudio(AudioBankType.AUDIO);
        var realTime = _app.audio.getTime(audio);

        if (realTime != _lastRealTime) {
            _lastRealTime = realTime;
            _interpolatedTimeStart = HiResTime.now();
        }

        var currentTime = HiResTime.now();
        var elapsedTime = currentTime - _interpolatedTimeStart;
        var currentInterpolatedTime = realTime + elapsedTime;

        _smoothedTime = (_smoothedTime * (1 - _smoothingFactor)) + (currentInterpolatedTime * _smoothingFactor);

        return _smoothedTime * 1000;
    }

    /**
     * Get current beat of song
     */
    public function getBeat(time: Float): Float {
        var lastEvent = getLastEventOfTypeAt(time, ChartEventType.TIMING_POINT);
        if (lastEvent == null) return 0;
        
        var absoluteTime = time - lastEvent.time;
        return lastEvent.data * (absoluteTime / 60000);
    }

}
