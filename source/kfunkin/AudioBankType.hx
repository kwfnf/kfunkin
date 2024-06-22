package kfunkin;

/**
 * Allowed types of voice banks
 */
enum abstract AudioBankType(Int) {
    var AUDIO = 0;
    var VOICE_PLAYER = 1;
    var VOICE_OPPONENT = 2;
}
