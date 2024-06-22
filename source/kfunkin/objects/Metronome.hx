package kfunkin.objects;

import kawaii.Application;
import kawaii.resources.ResourceAudio;

/**
 * A class to help with metronome sounds
 */
class Metronome {

    private var tick_high: ResourceAudio;
    private var tick_low: ResourceAudio;

    private var chart: Chart;
    private var lastBeat: Int = 0;

    private var app: Application;
    private var active: Bool = false;

    /**
     * Create a new metronome
     * @param chart The chart to use for the metronome
     */
    public function new(chart: Chart) {
        app = Application.getInstance();

        tick_high = app.resources.acquireAudio("editor/m_high.wav");
        tick_low = app.resources.acquireAudio("editor/m_low.wav");
        
        this.chart = chart;
    }

    /**
     * Update the metronome
     * @param time The current time in milliseconds
     */
    public function update(time: Float) {
        var beat = Math.floor(chart.getBeat(time));
        if (beat != lastBeat) {
            lastBeat = beat;
            if (active) app.audio.play(beat % 4 == 0 ? tick_high : tick_low);
        }
    }

    /**
     * Dispose of the metronome
     */
    public function dispose() {
        tick_high.release();
        tick_low.release();
    }
    
    /**
     * Start the metronome
     */
    public function start() {
        active = true;
    }

    /**
     * Stop the metronome
     */
    public function stop() {
        active = false;
    }

    /**
     * Check if the metronome is active
     * @return True if the metronome is active
     */
    public function isActive(): Bool {
        return active;
    }

}
