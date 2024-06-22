package kfunkin.game;

/**
 * Represents the state of the game.
 */
class GameState {

    // The number of judgements of each type.
    private var judgements: Array<Int> = [ for (_ in 0...Globals.JUDGEMENT_NAMES.length) 0 ];

    /**
     * Empty constructor.
     */
    public function new() {}
    
    /**
     * Add a judgement to the game state.
     * @param judgement The judgement to add.
     */
    public function addJudgement(judgement: Judgement) {
        judgements[judgement]++;
    }

    /**
     * Add a judgement based on the error of the player's input.
     * @param error 
     */
    public function addJudgementTime(error: Float) {
        if (error > Globals.JUDGEMENT_WINDOW) return addMiss();
        for (window in Globals.JUDGEMENT_TIMINGS) {
            if (error > window) continue;

            addJudgement(Globals.JUDGEMENT_TIMINGS[window]);
            break;
        }
    }

    /**
     * Get the number of judgements of a given type.
     * @param judgement The judgement to get the count of.
     * @return The number of judgements of the given type.
     */
    public function getJudgement(judgement: Judgement): Int {
        return judgements[judgement];
    }

    /**
     * Add a miss to the game state.
     */
    public function addMiss() {
        addJudgement(Judgement.MISS);
    }

}
