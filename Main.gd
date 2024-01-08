extends Control
@onready var accept_dialog = $AcceptDialog
@onready var progress_bar = $PanelContainer/MarginContainer/VBoxContainer/Panel3/VBoxContainer/ProgressBar
@onready var button = $PanelContainer/MarginContainer/VBoxContainer/Button
@onready var DoneText = $PanelContainer/MarginContainer/VBoxContainer/Panel3/VBoxContainer/DoneText

const commonpath = "/digimon_common_para.mbe/digimon.csv"
const couplepath = "/mon_cpl.mbe/Coupling.csv"
const modpath = "/Encounter Randomizer Mod/modfiles/data/mon_cpl.mbe/"

func start_patching():
	randomize()
	DoneText.hide()
	button.disabled = true
	progress_bar.value = 0
	progress_bar.show()
	await get_tree().create_timer(.05).timeout
	var dir = DirAccess.open(OS.get_executable_path().get_base_dir())
	dir.make_dir_recursive(OS.get_executable_path().get_base_dir()+modpath)
	await get_tree().create_timer(.05).timeout
	progress_bar.value = 20
	var Monlist = {
	1 : [],
	2 : [],
	3 : [],
	4 : [],
	5 : [],
	6 : [],
	7 : []
	}
	
	
	if !FileAccess.file_exists(OS.get_executable_path().get_base_dir()+commonpath):
		accept_dialog.dialog_text = "Error, missing digimon_common_para.mbe folder."
		button.disabled = false
		progress_bar.hide()
		accept_dialog.popup_centered()
	else:
		var file = FileAccess.open(OS.get_executable_path().get_base_dir()+commonpath, FileAccess.READ)
		var _scrap = file.get_csv_line()
		await get_tree().create_timer(.05).timeout
		progress_bar.value = 40
	
		while !file.eof_reached():
			var current_line = file.get_csv_line()
			if current_line.size() < 2:
				continue
			if int(current_line[1]) > 7:
				continue
			Monlist[int(current_line[1])].append(current_line[0])
	
	
	if !FileAccess.file_exists(OS.get_executable_path().get_base_dir()+couplepath):
		accept_dialog.dialog_text = "Error, missing mon_cpl.mbe folder."
		button.disabled = false
		progress_bar.hide()
		accept_dialog.popup_centered()
	else:
		var file = FileAccess.open(OS.get_executable_path().get_base_dir()+couplepath, FileAccess.READ)
		var modfile = FileAccess.open(OS.get_executable_path().get_base_dir()+modpath+"/Coupling.csv", FileAccess.WRITE)
		var scrap = file.get_csv_line()
		modfile.store_csv_line(scrap)
		await get_tree().create_timer(.05).timeout
		progress_bar.value = 60
		while !file.eof_reached():
			var current_line = file.get_csv_line()
			if current_line.size() < 2:
				continue
			var mod_line: PackedStringArray = []
			mod_line.append(current_line[0])
			for i in range(1,7):
				mod_line.append(current_line[i])
				for m in Monlist:
					if Monlist[m].has(current_line[i]):
						mod_line[-1] = Monlist[m].pick_random()
						break
			for i in range(7, 25):
				mod_line.append(current_line[i])
			modfile.store_csv_line(mod_line)
		progress_bar.value = 80
		await get_tree().create_timer(.05).timeout 
	
	var metadatafile = FileAccess.open(OS.get_executable_path().get_base_dir()+"/Encounter Randomizer Mod/METADATA.json", FileAccess.WRITE)
	var Metadata = {
		"Name": "Randomized Encounters (Load Last)",
		"Author": "Luna Bold",
		"Version": "1.0",
		"Category": "Misc",
		"Description": "Randomizes all encounters"
	}
	
	metadatafile.store_line(JSON.stringify(Metadata, "	", false))
	
	await get_tree().create_timer(.05).timeout
	progress_bar.value = 100
	
	button.disabled = false
	DoneText.show()
