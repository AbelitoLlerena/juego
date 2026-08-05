class_name AnimationSystem
extends Node

signal sequence_started(sequence: AnimationSequence)
signal batch_started(batch: AnimationBatch)
signal batch_finished(batch: AnimationBatch)
signal sequence_finished(sequence: AnimationSequence)

var _playing := false

func is_playing() -> bool:
	return _playing

func play(sequence: AnimationSequence) -> void:
	assert(!_playing, "AnimationSystem is already playing.")
	assert(sequence != null)

	_playing = true
	sequence.lock()
	#print("sequence start")

	sequence_started.emit(sequence)

	for batch in sequence.batches:
		await _execute_batch(batch)

	_playing = false
	#print("sequence finished")
	sequence_finished.emit(sequence)

func _execute_batch(batch: AnimationBatch) -> void:
	if batch.commands.is_empty():
		return

	batch_started.emit(batch)
	#print("batch start")
	var remaining := batch.commands.size()

	for command in batch.commands:
		_run_command(command, func():
			remaining -= 1
			
			if remaining == 0:
				batch_finished.emit(batch)
		)

	await batch_finished
	#print("batch finished")

func _run_command(
	command: AnimationCommand,
	finished: Callable
) -> void:
	#print("command start")
	await _execute_command(command)
	finished.call()

func _execute_command(command: AnimationCommand) -> void:
	#print("command call")
	await command.execute(self)
	#print("call finished")
