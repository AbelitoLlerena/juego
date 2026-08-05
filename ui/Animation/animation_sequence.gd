class_name AnimationSequence
extends RefCounted

var batches: Array[AnimationBatch] = []

var _locked := false

func add_batch(batch: AnimationBatch) -> AnimationSequence:
	assert(!_locked)
	batches.append(batch)
	return self

func lock() -> void:
	_locked = true
