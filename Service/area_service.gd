class_name AreaService
extends RefCounted

static func target(tile: Vector2i) -> Array[Vector2i]:
	return [tile]

static func circle(center: Vector2i, radius: int) -> Array[Vector2i]:
	var result: Array[Vector2i] = []

	for x in range(center.x - radius, center.x + radius + 1):
		for y in range(center.y - radius, center.y + radius + 1):

			var p := Vector2i(x, y)

			if DistanceService.distance(center,p) <= radius:
				result.append(p)

	return result


static func line(
	origin: Vector2i,
	target: Vector2i,
	length: int,
	width: int
) -> Array[Vector2i]:

	var dir := target - origin

	if dir == Vector2i.ZERO:
		return []

	var step := Vector2(dir).normalized()

	var end := origin + Vector2i(
		roundi(step.x * length),
		roundi(step.y * length)
	)

	var line := Geometry2D.bresenham_line(origin, end)

	if width <= 1:
		return line

	var result: Array[Vector2i] = []
	var added := {}

	var expand := Vector2i.ZERO

	# Elegimos el eje de expansión.
	if abs(dir.x) > abs(dir.y):
		expand = Vector2i(0, 1)

	elif abs(dir.y) > abs(dir.x):
		expand = Vector2i(1, 0)

	else:
		expand = Vector2i(0, signi(dir.y))

	for tile in line:
		for i in range(width):
			var p := tile + expand * i

			if !added.has(p):
				added[p] = true
				result.append(p)

	return result

static func cone(
	origin: Vector2i,
	target: Vector2i,
	length: int,
	angle: float
) -> Array[Vector2i]:
	var result: Array[Vector2i] = []

	var forward := target - origin
	if forward == Vector2i.ZERO:
		return result

	var dir := Vector2(forward).normalized()
	var cos_limit := cos(deg_to_rad(angle * 0.5))

	for x in range(origin.x - length, origin.x + length + 1):
		for y in range(origin.y - length, origin.y + length + 1):
			var p := Vector2i(x, y)

			var distance := DistanceService.distance(origin, p)
			if distance == 0 or distance > length:
				continue

			var v := Vector2(p - origin).normalized()

			var dot := dir.dot(v)

			if dot >= cos_limit:
				result.append(p)

	return result
