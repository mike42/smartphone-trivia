<?php
class person_table_controller {
	public static function init() {
		core::loadClass("session");
		core::loadClass("person_table_model");
	}

	public static function create() {
		/* Check permission */
		$role = session::getRole();
		if(!isset(core::$permission[$role]['person_table']['create']) || core::$permission[$role]['person_table']['create'] != true) {
			return array('error' => 'You do not have permission to do that', 'code' => '403');
		}

		/* Find fields to insert */
		$fields = array('round_id', 'person_id', 'team_id');
		$init = array();
		$received = json_decode(file_get_contents('php://input'), true, 2);
		foreach($fields as $field) {
			if(isset($received[$field])) {
				$init["person_table.$field"] = $received[$field];
			}
		}
			$person_table = new person_table_model($init);

		/* Check parent tables */
		if(!round_model::get($person_table -> get_round_id())) {
			return array('error' => 'person_table is invalid because related round does not exist', 'code' => '400');
		}
		if(!person_model::get($person_table -> get_person_id())) {
			return array('error' => 'person_table is invalid because related person does not exist', 'code' => '400');
		}
		if(!team_model::get($person_table -> get_team_id())) {
			return array('error' => 'person_table is invalid because related team does not exist', 'code' => '400');
		}

		/* Insert new row */
		try {
			$person_table -> insert();
			return $person_table -> to_array_filtered($role);
		} catch(Exception $e) {
			return array('error' => 'Failed to add to database', 'code' => '500');
		}
	}

	public static function read($round_id,$person_id) {
		/* Check permission */
		$role = session::getRole();
		if(!isset(core::$permission[$role]['person_table']['read']) || count(core::$permission[$role]['person_table']['read']) == 0) {
			return array('error' => 'You do not have permission to do that', 'code' => '403');
		}

		/* Load person_table */
		$person_table = person_table_model::get($round_id,$person_id);
		if(!$person_table) {
			return array('error' => 'person_table not found', 'code' => '404');
		}
		return $person_table -> to_array_filtered($role);
	}

	public static function update($round_id,$person_id) {
		/* Check permission */
		$role = session::getRole();
		if(!isset(core::$permission[$role]['person_table']['update']) || count(core::$permission[$role]['person_table']['update']) == 0) {
			return array('error' => 'You do not have permission to do that', 'code' => '403');
		}

		/* Load person_table */
		$person_table = person_table_model::get($round_id,$person_id);
		if(!$person_table) {
			return array('error' => 'person_table not found', 'code' => '404');
		}

		/* Find fields to update */
		$update = false;
		$received = json_decode(file_get_contents('php://input'), true);
		if(isset($received['team_id']) && in_array('team_id', core::$permission[$role]['person_table']['update'])) {
			$person_table -> set_team_id($received['team_id']);
		}

		/* Check parent tables */
		if(!round_model::get($person_table -> get_round_id())) {
			return array('error' => 'person_table is invalid because related round does not exist', 'code' => '400');
		}
		if(!person_model::get($person_table -> get_person_id())) {
			return array('error' => 'person_table is invalid because related person does not exist', 'code' => '400');
		}
		if(!team_model::get($person_table -> get_team_id())) {
			return array('error' => 'person_table is invalid because related team does not exist', 'code' => '400');
		}

		/* Update the row */
		try {
			$person_table -> update();
			return $person_table -> to_array_filtered($role);
		} catch(Exception $e) {
			return array('error' => 'Failed to update row', 'code' => '500');
		}
	}

	public static function delete($round_id,$person_id) {
		/* Check permission */
		$role = session::getRole();
		if(!isset(core::$permission[$role]['person_table']['delete']) || core::$permission[$role]['person_table']['delete'] != true) {
			return array('error' => 'You do not have permission to do that', 'code' => '403');
		}

		/* Load person_table */
		$person_table = person_table_model::get($round_id,$person_id);
		if(!$person_table) {
			return array('error' => 'person_table not found', 'code' => '404');
		}


		/* Delete it */
		try {
			$person_table -> delete();
			return array('success' => 'yes');
		} catch(Exception $e) {
			return array('error' => 'Failed to delete', 'code' => '500');
		}
	}
}
?>