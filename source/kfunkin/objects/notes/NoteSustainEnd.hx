package kfunkin.objects.notes;

import kfunkin.formats.data.ChartNoteType;

class NoteSustainEnd extends NoteBase {

    /**
     * Load the note type
     */
    public function new() {
        super();
        type = ChartNoteType.SUSTAIN_END;
    }

}