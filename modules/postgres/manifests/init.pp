class postgres ($db_admin_password) {
	class { 'postgresql::server':
		postgres_password => $db_admin_password
	}
}
