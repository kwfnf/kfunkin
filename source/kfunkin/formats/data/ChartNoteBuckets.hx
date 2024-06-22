package kfunkin.formats.data;

import kfunkin.modding.ClassRegistry;

/**
 * Represents a collection of ChartNoteBuckets.
 */
class ChartNoteBuckets {

    private var _buckets: Array<ChartNoteBucket> = [];
    private var _currentlyRelevantNotes: Array<ChartNote> = [];
    private var _bucketTimeLength: Float = 5000;
    private var _lastRelevantTime: Float = -99999;

    public function new() {}

    /**
     * Adds a ChartNoteBucket to the collection.
     * @param bucket The ChartNoteBucket to add.
     */
    public function addBucket(bucket: ChartNoteBucket): Void {
        _buckets.push(bucket);
    }

    /**
     * Gets the ChartNoteBucket at the specified index.
     * @param index The index of the ChartNoteBucket to get.
     * @return The ChartNoteBucket at the specified index.
     */
    public function getBucket(index: Int): ChartNoteBucket {
        return _buckets[index];
    }

    /**
     * Gets the number of ChartNoteBuckets in the collection.
     * @return The number of ChartNoteBuckets in the collection.
     */
    public function getBucketCount() : Int {
        return _buckets.length;
    }

    /**
     * Get the number of notes in the collection.
     */
    public function getNoteCount() : Int {
        var count: Int = 0;
        for (i in 0..._buckets.length) {
            count += _buckets[i].getNoteCount();
        }
        return count;
    }
 
    /**
     * Get or create a bucket at an index.
     * @param index The index of the bucket to get or create.
     */
    public function getOrCreateBucket(index: Int) : ChartNoteBucket {
        if (_buckets[index] == null) _buckets[index] = ClassRegistry.createInstance(ChartNoteBucket, [ index * _bucketTimeLength ]);
        
        for (_ in 0...index) {
            if (_buckets[_] == null) _buckets[_] = ClassRegistry.createInstance(ChartNoteBucket, [ _ * _bucketTimeLength ]);
        }

        return _buckets[index];
    }

    /**
     * Get or create a bucket at a time.
     * @param millis The time of the bucket to get or create.
     */
    public function getOrCreateBucketByTime(millis: Float) {
        var index: Int = Math.floor(millis / _bucketTimeLength);
        return getOrCreateBucket(index);
    }

    /**
     * Get the bucket time length.
     */
    public function getBucketTimeLength() : Float {
        return _bucketTimeLength;
    }

    /**
     * Get the currently relevant notes.
     * @param time The current time.
     */
    public function getCurrentlyRelevantNotes(time: Float) : Array<ChartNote> {
        var currentBucketIndex = Math.floor(time / _bucketTimeLength);
        var lastBucketIndex = Math.floor(_lastRelevantTime / _bucketTimeLength);

        if (currentBucketIndex != lastBucketIndex) {
            _lastRelevantTime = time;
            var buckets = [
                getOrCreateBucket(currentBucketIndex - 1),
                getOrCreateBucket(currentBucketIndex),
                getOrCreateBucket(currentBucketIndex + 1)
            ];

            _currentlyRelevantNotes.resize(0);
            for (bucket in buckets) if (bucket != null) _currentlyRelevantNotes = _currentlyRelevantNotes.concat(bucket.getNotes());
        }


        return _currentlyRelevantNotes;
    }

}   