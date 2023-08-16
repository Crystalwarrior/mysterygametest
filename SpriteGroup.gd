extends CanvasGroup


func set_dir(dir):
	dir = wrapi(dir, 0, 8)
	$body.frame = dir
	$head.frame = dir
	$hair.frame = dir
