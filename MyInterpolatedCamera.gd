# This is a port of the Godot cpp source code for InterpolatedCamera.
# See: https://docs.godotengine.org/en/stable/classes/class_interpolatedcamera.html?highlight=interpolatedcamera
# I intentionally omitted the code that handles the case where the target
# is itself a camera, as I didn't need that functionality.
# UChin Kim -- 08 nov 2020.
#
# LICENSE: CC0
#

extends Camera

class_name MyInterpolatedCamera


export (bool) var enabled = false setget set_interpolation_enabled, is_interpolation_enabled

export (float) var speed = 1.0 setget set_speed, get_speed

export (NodePath) var target = null setget set_target, get_target

var target_spatial = null

func set_interpolation_enabled(value):
    enabled = value


func is_interpolation_enabled():
    return enabled


func set_speed(value):
    speed = value

func get_speed():
    return speed

func set_target(object):
    target_spatial = object as Spatial

func get_target():
    return target_spatial

# Called when the node enters the scene tree for the first time.
func _ready():
    if target != null:
        set_target(get_node(target))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if (! enabled) or (target_spatial == null):
        return

    var target_xform = target_spatial.global_transform
    var local_transform = global_transform
    local_transform = local_transform.interpolate_with(target_xform, delta * speed)
    set_global_transform(local_transform)

    # there's some code related to case where target is actually a camera.
    # I don't need the functionality where a target is itself a camera, so leaving it out.
